Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933292AbdCaRb4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:31:56 -0400
Subject: [PATCH 4/8] statx: optimize copy of struct statx to userspace
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Mar 2017 18:31:48 +0100
Message-ID: <149098150799.28108.2141923987221727061.stgit@warthog.procyon.org.uk>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

I found that statx() was significantly slower than stat().  As a
microbenchmark, I compared 10,000,000 invocations of fstat() on a tmpfs
file to the same with statx() passed a NULL path:

	$ time ./stat_benchmark

	real	0m1.464s
	user	0m0.275s
	sys	0m1.187s

	$ time ./statx_benchmark

	real	0m5.530s
	user	0m0.281s
	sys	0m5.247s

statx is expected to be a little slower than stat because struct statx
is larger than struct stat, but not by *that* much.  It turns out that
most of the overhead was in copying struct statx to userspace, mostly in
all the stac/clac instructions that got generated for each __put_user()
call.  (This was on x86_64, but some other architectures, e.g. arm64,
have something similar now too.)

stat() instead initializes its struct on the stack and copies it to
userspace with a single call to copy_to_user().  This turns out to be
much faster, and changing statx to do this makes it almost as fast as
stat:

	$ time ./statx_benchmark

	real	0m1.624s
	user	0m0.270s
	sys	0m1.354s

For zeroing the reserved fields, start by zeroing the full struct with
memset.  This makes it clear that every byte copied to userspace is
initialized, even implicit padding bytes (though there are none
currently).  In the scenarios I tested, it also performed the same as a
designated initializer.  Manually initializing each field was still
slightly faster, but would have been more error-prone and less
verifiable.

Also rename statx_set_result() to cp_statx() for consistency with
cp_old_stat() et al., and make it noinline so that struct statx doesn't
add to the stack usage during the main portion of the syscall execution.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/stat.c |   74 ++++++++++++++++++++++++++-----------------------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index b792dd201c31..ab27f2868588 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -510,46 +510,37 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
-static inline int __put_timestamp(struct timespec *kts,
-				  struct statx_timestamp __user *uts)
+static noinline_for_stack int
+cp_statx(const struct kstat *stat, struct statx __user *buffer)
 {
-	return (__put_user(kts->tv_sec,		&uts->tv_sec		) ||
-		__put_user(kts->tv_nsec,	&uts->tv_nsec		) ||
-		__put_user(0,			&uts->__reserved	));
-}
-
-/*
- * Set the statx results.
- */
-static long statx_set_result(struct kstat *stat, struct statx __user *buffer)
-{
-	uid_t uid = from_kuid_munged(current_user_ns(), stat->uid);
-	gid_t gid = from_kgid_munged(current_user_ns(), stat->gid);
-
-	if (__put_user(stat->result_mask,	&buffer->stx_mask	) ||
-	    __put_user(stat->mode,		&buffer->stx_mode	) ||
-	    __clear_user(&buffer->__spare0, sizeof(buffer->__spare0))	  ||
-	    __put_user(stat->nlink,		&buffer->stx_nlink	) ||
-	    __put_user(uid,			&buffer->stx_uid	) ||
-	    __put_user(gid,			&buffer->stx_gid	) ||
-	    __put_user(stat->attributes,	&buffer->stx_attributes	) ||
-	    __put_user(stat->blksize,		&buffer->stx_blksize	) ||
-	    __put_user(MAJOR(stat->rdev),	&buffer->stx_rdev_major	) ||
-	    __put_user(MINOR(stat->rdev),	&buffer->stx_rdev_minor	) ||
-	    __put_user(MAJOR(stat->dev),	&buffer->stx_dev_major	) ||
-	    __put_user(MINOR(stat->dev),	&buffer->stx_dev_minor	) ||
-	    __put_timestamp(&stat->atime,	&buffer->stx_atime	) ||
-	    __put_timestamp(&stat->btime,	&buffer->stx_btime	) ||
-	    __put_timestamp(&stat->ctime,	&buffer->stx_ctime	) ||
-	    __put_timestamp(&stat->mtime,	&buffer->stx_mtime	) ||
-	    __put_user(stat->ino,		&buffer->stx_ino	) ||
-	    __put_user(stat->size,		&buffer->stx_size	) ||
-	    __put_user(stat->blocks,		&buffer->stx_blocks	) ||
-	    __clear_user(&buffer->__spare1, sizeof(buffer->__spare1))	  ||
-	    __clear_user(&buffer->__spare2, sizeof(buffer->__spare2)))
-		return -EFAULT;
-
-	return 0;
+	struct statx tmp;
+
+	memset(&tmp, 0, sizeof(tmp));
+
+	tmp.stx_mask = stat->result_mask;
+	tmp.stx_blksize = stat->blksize;
+	tmp.stx_attributes = stat->attributes;
+	tmp.stx_nlink = stat->nlink;
+	tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
+	tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
+	tmp.stx_mode = stat->mode;
+	tmp.stx_ino = stat->ino;
+	tmp.stx_size = stat->size;
+	tmp.stx_blocks = stat->blocks;
+	tmp.stx_atime.tv_sec = stat->atime.tv_sec;
+	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
+	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
+	tmp.stx_btime.tv_nsec = stat->btime.tv_nsec;
+	tmp.stx_ctime.tv_sec = stat->ctime.tv_sec;
+	tmp.stx_ctime.tv_nsec = stat->ctime.tv_nsec;
+	tmp.stx_mtime.tv_sec = stat->mtime.tv_sec;
+	tmp.stx_mtime.tv_nsec = stat->mtime.tv_nsec;
+	tmp.stx_rdev_major = MAJOR(stat->rdev);
+	tmp.stx_rdev_minor = MINOR(stat->rdev);
+	tmp.stx_dev_major = MAJOR(stat->dev);
+	tmp.stx_dev_minor = MINOR(stat->dev);
+
+	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
 /**
@@ -573,8 +564,6 @@ SYSCALL_DEFINE5(statx,
 
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
-	if (!access_ok(VERIFY_WRITE, buffer, sizeof(*buffer)))
-		return -EFAULT;
 
 	if (filename)
 		error = vfs_statx(dfd, filename, flags, &stat, mask);
@@ -582,7 +571,8 @@ SYSCALL_DEFINE5(statx,
 		error = vfs_statx_fd(dfd, &stat, mask, flags);
 	if (error)
 		return error;
-	return statx_set_result(&stat, buffer);
+
+	return cp_statx(&stat, buffer);
 }
 
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */


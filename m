Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C77C37F3F
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 21:55:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 402B0AC001
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 19:55:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7h36Z0etHqFML0HY for <xfs@oss.sgi.com>;
	Sun, 09 Mar 2014 19:55:39 -0700 (PDT)
Date: Mon, 10 Mar 2014 13:55:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310025523.GV6851@dastard>
References: <531BD8B9.1090400@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531BD8B9.1090400@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Mar 08, 2014 at 09:58:01PM -0500, Michael L. Semon wrote:
> Hi!  I was playing a shell game with some precious backup data.  It 
> went like this:
> 
> open a 36-GB source partition (DM linear, partitions from 2 drives, 
>    v5-superblock XFS)
> 
> open a 32-GB aes-xts crypt (v4-superblock XFS)
> 
> `cp -av` from holding partition to crypt
> 
> It was during the cp operation that I got this multi-CPU version of 
> the harmless lockdep:
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.14.0-rc5+ #6 Not tainted
> ---------------------------------------------------------
> kswapd0/25 just changed the state of lock:
>  (&xfs_dir_ilock_class){++++-.}, at: [<791c09fa>] xfs_ilock+0xff/0x16c
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&mm->mmap_sem){++++++}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&mm->mmap_sem);
>                                local_irq_disable();
>                                lock(&xfs_dir_ilock_class);
>                                lock(&mm->mmap_sem);
>   <Interrupt>
>     lock(&xfs_dir_ilock_class);

Well, that's rather interesting. I'd love to know where we take the
directory ilock with interupts disabled - and then take a page
fault...  :/

....

>   }
>   ... key      at: [<795f1eec>] __key.44037+0x0/0x8
>   ... acquired at:
>    [<79064360>] __lock_acquire+0x397/0xa6c
>    [<7906510f>] lock_acquire+0x8b/0x101
>    [<790d1718>] might_fault+0x81/0xa9
>    [<790f379a>] filldir64+0x92/0xe2
>    [<7916f079>] xfs_dir2_sf_getdents+0x1a0/0x44c
>    [<7917009e>] xfs_readdir+0xc4/0x126
>    [<79171b8b>] xfs_file_readdir+0x25/0x3e
>    [<790f385a>] iterate_dir+0x70/0x9b
>    [<790f3a31>] SyS_getdents64+0x6d/0xcc
>    [<792f85b8>] sysenter_do_call+0x12/0x36

All of these paths are from the syscall path, except for one in
kswapd context. I don't see any stack trace here that could result
in the above "deadlock". It looks to be yet another false
positive...

> I call it harmless because its single-CPU variant can be reproduced
> as far back as I could bisect in earlier testing (way before
> kernel 2.6.20).  However, such lockdep splats have never manifested
> in a noticeable problem on production kernels on x86.  Either
> down_write_nested or down_read_nested is in all of them, depending
> on which kernel version is in use.  At least one reclaim-related
> function is in there as well.  vm_map_ram used to be in there, but Dave 
> took care of that (thanks!).
> 
> This particular splat has been showing up more often, though.  It's not
> tied to one particular commit, event, or change; just something that
> has crept in gradually since maybe kernel 3.11.  It's like watching
> grass grow or watching paint dry.

The above reports all indicate that the taking a page fault while
holding the directory ilock is problematic. So have all the other
new lockdep reports we've got that have been caused by that change.

Realistically, I think that the readdir locking change was
fundamentally broken. Why? Because taking page faults while holding
the ilock violates the lock order we have for inodes.  For regular
files, the lock heirarchy is iolock -> page fault -> ilock, and we
got rid of the need for the iolock in the inode reclaim path because
of all the problems it caused lockdep. Now we've gone and
reintroduced that same set of problems - only worse - by allowing
the readdir code to take page faults while holding the ilock....

I'd like to revert the change that introduced the ilock into the
readdir path, but I suspect that woul dbe an unpopular direction to
take. However, we need a solution that doesn't drive us insane with
lockdep false positives.

IOWs, we need to do this differently - readdir needs to be protected
by the iolock, not the ilock, and only the block mapping routines in
the readdir code should be protected by the ilock. i.e.  the same
locking strategy that is used for regular files: iolock protects the
contents of the file, the ilock protects the inode metadata.

What I think we really need to do is drive the ilock all the way
into the block mapping functions of the directory code and to the
places where the inode metadata is actually going to be modified.
The iolock protects access to the directory data, and logging of
changes to those blocks is serialised by the buffer locks, so we
don't actually need the inode ilock to serialise access to the
directory data - we only need the ilock for modifications to the
inode and it's blockmaps itself, same as for regular files.

Changing the directory code to handle this sort of locking is going
to require a bit of surgery. However, I can see advantages to moving
directory data to the same locking strategy as regular file data -
locking heirarchies are identical, directory ilock hold times are
much reduced, we don't get lockdep whining about taking page faults
with the ilock held, etc.

A quick hack at to demonstrate the high level, initial step of using
the IOLOCK for readdir serialisation. I've done a little smoke
testing on it, so it won't die immediately. It should get rid of all
the nasty lockdep issues, but it doesn't start to address the deeper
restructing that is needed.

Thoughts, comments? I'm especially interested in what SGI people
have to say here because this locking change was needed for CXFS,
and changing the directory locking iheirarchy is probably going to
upset CXFS a lot...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs; holding ilock over readdir is wrong

From: Dave Chinner <dchinner@redhat.com>

The recent change to the readdir locking made in 40194ec ("xfs:
reinstate the ilock in xfs_readdir") for CXFS directory sanity was
fundamentally the wrong thing to do. deep in the readdir code we
can take page faults in the filldir callback, and so taking a page
fault while holding an inode ilock creates a new set of locking
issues that lockdep warns all over the place about.

The locking order for regularl inodes w.r.t. page faults is io_lock
-> pagefault -> mmap_sem -> ilock. The directory readdir code now
triggers ilock -> page fault -> mmap_sem. While we cannot deadlock
at this point, it inverts all the locking patterns that lockdep
normally sees on XFS inodes, and so triggers lockdep. We worked
around this with commit 93a8614 ("xfs: fix directory inode iolock
lockdep false positive"), but that then just moved the lockdep
warning to deeper in the page fault path and triggered on seurity
inode locks.

Further, if we enter memory reclaim in a readdir path, we now get
lockdep warning about potential deadlocks because the ilock is held
when we enter reclaim. This, again, is different to a regular file
in that we never allow memory reclaim to run while holding the
ilock for regular files. Hence lockdep now throws
ilock->kmalloc->reclaim->ilock warnings.

Basically, the problem is that the ilock is being used to protect
the directory data and the inode metadata, whereas for a regular
file the iolock protects the data and the ilock protects the
metadata. From the VFS perspective, the i_mutex serialises all
accesses to the directory data, and so not holding the ilock for
readdir doesn't matter. The issue is that CXFS doesn't access
directory data via the VFS, so it has no "data serialisaton"
mechanism.

While the simplest way to fix these problems would simply be to
revert the ilock addition made to xfs_readdir,but I figure that
would be unpopular with some people. Hence we need a different
solution: we should use the iolock to protect readdir against
modification races.

The ilock can then be used just when the extent list needs to be
read, just like we do for regular files. The directory modification
code can now take the iolock exclusive when the ilock is also taken,
and this then ensures that readdir is correct excluded while
modifications are in progress.

This would be a straight forward change, except for two things:
filestreams and lockdep. The filestream allocator takes the
directory iolock and makes assumptions about parent->child locking
order of the iolock which will now be invalidated. Hence some
changes to the filestreams code is needed to ensure that it never
blocks on directory iolocks and deadlocks. instead it needs to fail
stream associations when such problems occur.

Lockdep is just plain annoying. We have a bug in our handling of the
XFS_LOCK_PARENT handling when it comes to locking multiple inodes
with that flag set - lockdep classes are exclusive and can't be ORed
together to form new classes. And there's only 8 subclasses
available. Luckily, we only need the new annotations on the iolock,
and we never lok more than 2 of those at once, so there's space
available in the iolock lockdep mask to shoehorn in a separate
lockdep subclass map for parent based iolocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.c         |  3 +++
 fs/xfs/xfs_dir2_readdir.c | 10 ++++++++--
 fs/xfs/xfs_filestream.c   | 26 +++++++++++++++---------
 fs/xfs/xfs_inode.c        | 50 +++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h        |  7 ++++++-
 fs/xfs/xfs_symlink.c      |  7 ++++---
 6 files changed, 75 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 0c8ba87..b206da1 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -307,6 +307,7 @@ xfs_dir_lookup(
 	struct xfs_da_args *args;
 	int		rval;
 	int		v;		/* type-checking value */
+	int		lock_mode;
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(xs_dir_lookup);
@@ -331,6 +332,7 @@ xfs_dir_lookup(
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
+	lock_mode = xfs_ilock_data_map_shared(dp);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_lookup(args);
 		goto out_check_rval;
@@ -363,6 +365,7 @@ out_check_rval:
 		}
 	}
 out_free:
+	xfs_iunlock(dp, lock_mode);
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index aead369..19863fe 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -190,6 +190,7 @@ xfs_dir2_block_getdents(
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
+	int			lock_mode;
 
 	mp = dp->i_mount;
 	/*
@@ -198,7 +199,9 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(mp, ctx->pos) > mp->m_dirdatablk)
 		return 0;
 
+	lock_mode = xfs_ilock_data_map_shared(dp);
 	error = xfs_dir3_block_read(NULL, dp, &bp);
+	xfs_iunlock(dp, lock_mode);
 	if (error)
 		return error;
 
@@ -552,9 +555,12 @@ xfs_dir2_leaf_getdents(
 		 * current buffer, need to get another one.
 		 */
 		if (!bp || ptr >= (char *)bp->b_addr + mp->m_dirblksize) {
+			int	lock_mode;
 
+			lock_mode = xfs_ilock_data_map_shared(dp);
 			error = xfs_dir2_leaf_readbuf(dp, bufsize, map_info,
 						      &curoff, &bp);
+			xfs_iunlock(dp, lock_mode);
 			if (error || !map_info->map_valid)
 				break;
 
@@ -684,7 +690,7 @@ xfs_readdir(
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(xs_dir_getdents);
 
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(dp, ctx);
 	else if ((rval = xfs_dir2_isblock(NULL, dp, &v)))
@@ -693,7 +699,7 @@ xfs_readdir(
 		rval = xfs_dir2_block_getdents(dp, ctx);
 	else
 		rval = xfs_dir2_leaf_getdents(dp, ctx, bufsize);
-	xfs_iunlock(dp, lock_mode);
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 
 	return rval;
 }
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 12b6e77..a2b8b12 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -597,9 +597,6 @@ xfs_filestream_associate(
 	 * waiting for the lock because someone else is waiting on the lock we
 	 * hold and we cannot drop that as we are in a transaction here.
 	 *
-	 * Lucky for us, this inversion is not a problem because it's a
-	 * directory inode that we are trying to lock here.
-	 *
 	 * So, if we can't get the iolock without sleeping then just give up
 	 */
 	if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL))
@@ -746,13 +743,24 @@ xfs_filestream_new_ag(
 	 * themselves and their parent to different AGs.
 	 *
 	 * Note that we lock the parent directory iolock inside the child
-	 * iolock here.  That's fine as we never hold both parent and child
-	 * iolock in any other place.  This is different from the ilock,
-	 * which requires locking of the child after the parent for namespace
-	 * operations.
+	 * iolock here. That's fine as we never hold both parent and child
+	 * iolock in any other place. However, we also hold the child ilock
+	 * here, so we are locking inside that as well. This inverts directory
+	 * iolock/child ilock order for operations like rename, and hence we
+	 * cannot block in the parent iolock here.
+	 *
+	 * This is different from the ilock, However, we also hold the child
+	 * ilock here, so we are locking inside that as well. This inverts
+	 * directory iolock/child ilock order for operations like rename, and
+	 * hence we cannot block in the parent iolock here. If we can't get the
+	 * parent iolock, then just default to AG 0 and return.
 	 */
-	if (pip)
-		xfs_ilock(pip, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
+	if (pip) {
+		if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL)) {
+			*agp = 0;
+			return 0;
+		}
+	}
 
 	/*
 	 * A new AG needs to be found for the file.  If the file's parent
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a1668b..422603d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -321,10 +321,25 @@ int xfs_lock_delays;
 static inline int
 xfs_lock_inumorder(int lock_mode, int subclass)
 {
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
-		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
-	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
-		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_ILOCK_SHIFT;
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
+		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
+		subclass += XFS_IOLOCK_INUMORDER;
+		if (lock_mode & XFS_IOLOCK_PARENT) {
+			subclass += XFS_IOLOCK_INUMORDER_PARENT;
+			lock_mode &= ~XFS_IOLOCK_PARENT;
+		}
+		ASSERT(subclass < MAX_LOCKDEP_SUBCLASSES);
+		lock_mode |= subclass << XFS_IOLOCK_SHIFT;
+	}
+
+	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) {
+		ASSERT(subclass <= XFS_ILOCK_MAX_SUBCLASS);
+		ASSERT(!(lock_mode & XFS_ILOCK_PARENT));
+		subclass += XFS_ILOCK_INUMORDER;
+		ASSERT(subclass < MAX_LOCKDEP_SUBCLASSES);
+		lock_mode |= subclass << XFS_ILOCK_SHIFT;
+	}
+
 
 	return lock_mode;
 }
@@ -584,9 +599,9 @@ xfs_lookup(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
 
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
-	xfs_iunlock(dp, lock_mode);
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 
 	if (error)
 		goto out;
@@ -1191,7 +1206,8 @@ xfs_create(
 		goto out_trans_cancel;
 	}
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
+		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
 	xfs_bmap_init(&free_list, &first_block);
@@ -1228,7 +1244,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
@@ -1301,7 +1317,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1348,10 +1364,11 @@ xfs_link(
 		goto error_return;
 	}
 
+	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, tdp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -2454,9 +2471,10 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
@@ -2655,6 +2673,12 @@ xfs_rename(
 	 * whether the target directory is the same as the source
 	 * directory, we can lock from 2 to 4 inodes.
 	 */
+	if (!new_parent)
+		xfs_ilock(src_dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
+	else
+		xfs_lock_two_inodes(src_dp, target_dp,
+				    XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
+
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
@@ -2662,9 +2686,9 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
 	if (target_ip)
 		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5f421a1..f20d4d0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -290,15 +290,20 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
 #define XFS_LOCK_PARENT		1
 #define XFS_LOCK_RTBITMAP	2
 #define XFS_LOCK_RTSUM		3
-#define XFS_LOCK_INUMORDER	4
 
 #define XFS_IOLOCK_SHIFT	16
 #define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
+#define XFS_IOLOCK_INUMORDER	(XFS_LOCK_PARENT + 1)
+#define XFS_IOLOCK_MAX_SUBCLASS	1
+#define XFS_IOLOCK_INUMORDER_PARENT \
+		(XFS_IOLOCK_INUMORDER + XFS_IOLOCK_MAX_SUBCLASS + 1)
 
 #define XFS_ILOCK_SHIFT		24
 #define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
+#define XFS_ILOCK_INUMORDER	(XFS_LOCK_RTSUM + 1);
+#define XFS_ILOCK_MAX_SUBCLASS	3
 
 #define XFS_IOLOCK_DEP_MASK	0x00ff0000
 #define XFS_ILOCK_DEP_MASK	0xff000000
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5fda189..32c3278 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -249,7 +249,8 @@ xfs_symlink(
 		goto error_return;
 	}
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
+		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
 	/*
@@ -296,7 +297,7 @@ xfs_symlink(
 	 * transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
 	/*
@@ -418,7 +419,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

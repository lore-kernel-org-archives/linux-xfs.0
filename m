Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35467 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752283AbdCKHAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Mar 2017 02:00:12 -0500
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] statx: reject unknown flags when using NULL path
Date: Fri, 10 Mar 2017 22:58:23 -0800
Message-Id: <20170311065823.4415-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, mtk.manpages@gmail.com, Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

The statx() system call currently accepts unknown flags when called with
a NULL path to operate on a file descriptor.  Left unchanged, this could
make it hard to introduce new query flags in the future, since
applications may not be able to tell whether a given flag is supported.

Fix this by failing the system call with EINVAL if any flags other than
KSTAT_QUERY_FLAGS are specified in combination with a NULL path.

Arguably, we could still permit known lookup-related flags such as
AT_SYMLINK_NOFOLLOW.  However, that would be inconsistent with how
sys_utimensat() behaves when passed a NULL path, which seems to be the
closest precedent.  And given that the NULL path case is (I believe)
mainly intended to be used to implement a wrapper function like fstatx()
that doesn't have a path argument, I think rejecting lookup-related
flags too is probably the best choice.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/stat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index fa0be59340cc..df484a60846d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -130,9 +130,13 @@ EXPORT_SYMBOL(vfs_getattr);
 int vfs_statx_fd(unsigned int fd, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
-	struct fd f = fdget_raw(fd);
+	struct fd f;
 	int error = -EBADF;
 
+	if (query_flags & ~KSTAT_QUERY_FLAGS)
+		return -EINVAL;
+
+	f = fdget_raw(fd);
 	if (f.file) {
 		error = vfs_getattr(&f.file->f_path, stat,
 				    request_mask, query_flags);
-- 
2.12.0


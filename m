Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44908 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbeDVPIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:08:55 -0400
Subject: [PATCH 10/10] xfs: avoid ABBA deadlock when scrubbing parent
 pointers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:08:35 -0700
Message-ID: <152440971583.30048.12706085815917294148.stgit@magnolia>
In-Reply-To: <152440964593.30048.15577210457233332459.stgit@magnolia>
References: <152440964593.30048.15577210457233332459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In normal operation, the XFS convention is to take an inode's iolock
and then allocate a transaction.  However, when scrubbing parent inodes
this is inverted -- we allocated the transaction to do the scrub, and
now we're trying to grab the parent's iolock.  This can lead to ABBA
deadlocks: some thread grabbed the parent's iolock and is waiting for
space for a transaction while our parent scrubber is sitting on a
transaction trying to get the parent's iolock.

Therefore, convert all iolock attempts to use trylock; if that fails,
they can use the existing mechanisms to back off and try again.

The ABBA deadlock didn't happen with a non-repair scrub because the
transactions don't reserve any space, but repair scrubs require
reservation in order to update metadata.  However, any other concurrent
metadata update (e.g. directory create in the parent) could also induce
this deadlock with the parent scrubber.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/common.h |    1 +
 fs/xfs/scrub/parent.c |   16 ++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 62b33c9..518bff2 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -844,3 +844,25 @@ xfs_scrub_metadata_inode_forks(
 
 	return error;
 }
+
+/*
+ * Try to lock an inode in violation of the usual locking order rules.  For
+ * example, trying to get the IOLOCK while in transaction context, or just
+ * plain breaking AG-order or inode-order inode locking rules.  Either way,
+ * the only way to avoid an ABBA deadlock is to use trylock and back off if
+ * we can't.
+ */
+int
+xfs_scrub_ilock_inverted(
+	struct xfs_inode	*ip,
+	uint			lock_mode)
+{
+	int			i;
+
+	for (i = 0; i < 20; i++) {
+		if (xfs_ilock_nowait(ip, lock_mode))
+			return 0;
+		delay(1);
+	}
+	return -EDEADLOCK;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5d78bb9..119d9b6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -156,5 +156,6 @@ static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
 }
 
 int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
+int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 95fdd0d..85241e6 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -214,7 +214,9 @@ xfs_scrub_parent_validate(
 	 */
 	xfs_iunlock(sc->ip, sc->ilock_flags);
 	sc->ilock_flags = 0;
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
+	error = xfs_scrub_ilock_inverted(dp, XFS_IOLOCK_SHARED);
+	if (error)
+		goto out_rele;
 
 	/* Go looking for our dentry. */
 	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
@@ -223,8 +225,10 @@ xfs_scrub_parent_validate(
 
 	/* Drop the parent lock, relock this inode. */
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	error = xfs_scrub_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
+	if (error)
+		goto out_rele;
 	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
 
 	/*
 	 * If we're an unlinked directory, the parent /won't/ have a link
@@ -326,5 +330,13 @@ xfs_scrub_parent(
 	if (try_again && tries == 20)
 		xfs_scrub_set_incomplete(sc);
 out:
+	/*
+	 * If we failed to lock the parent inode even after a retry, just mark
+	 * this scrub incomplete and return.
+	 */
+	if (sc->try_harder && error == -EDEADLOCK) {
+		error = 0;
+		xfs_scrub_set_incomplete(sc);
+	}
 	return error;
 }


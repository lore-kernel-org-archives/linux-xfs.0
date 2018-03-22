Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbeCVR6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 13:58:04 -0400
Date: Thu, 22 Mar 2018 10:57:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 11/9] xfs: flag inode corruption if parent ptr doesn't get
 us a real inode
Message-ID: <20180322175759.GA4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <20180321032158.GR1757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321032158.GR1757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

If a directory's parent inode pointer doesn't point to an inode, the
directory should be flagged as corrupt.  Enable IGET_UNTRUSTED here so
that _iget will return -EINVAL if the inobt does not confirm that the
inode is present and allocated and we can flag the directory corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: we only want to flag EINVAL as a directory corruption, everything
else is still a cross-referencing error
---
 fs/xfs/scrub/parent.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 0d38514..1fb88c1 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -167,8 +167,18 @@ xfs_scrub_parent_validate(
 	 * if the parent pointer erroneously points to a file, we
 	 * can't use DONTCACHE here because DONTCACHE inodes can trigger
 	 * immediate inactive cleanup of the inode.
+	 *
+	 * If _iget returns -EINVAL then the parent inode number is garbage
+	 * and the directory is corrupt.  If the _iget returns -EFSCORRUPTED
+	 * or -EFSBADCRC then the parent is corrupt which is a cross
+	 * referencing error.  Any other error is an operational error.
 	 */
-	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
+	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
+	if (error == -EINVAL) {
+		error = -EFSCORRUPTED;
+		xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
+		goto out;
+	}
 	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {

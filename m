Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbeCUDWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:22:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2L38qmd061351
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:22:00 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2guf7x0137-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:22:00 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2L3Lxs1031995
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:59 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2L3Lx1S008409
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 03:21:59 GMT
Date: Tue, 20 Mar 2018 20:21:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/9] xfs: flag inode corruption if parent ptr doesn't get us
 a real inode
Message-ID: <20180321032158.GR1757@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a directory's parent inode pointer doesn't point to an inode, flag
the directory as corrupt.  Enable IGET_UNTRUSTED here so that we
can confirm with the inobt that the inode is present and allocated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/parent.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 0d38514..d1547ca 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -167,9 +167,14 @@ xfs_scrub_parent_validate(
 	 * if the parent pointer erroneously points to a file, we
 	 * can't use DONTCACHE here because DONTCACHE inodes can trigger
 	 * immediate inactive cleanup of the inode.
+	 *
+	 * If _iget returns -EINVAL then the parent inode number is garbage
+	 * and the directory is corrupt.
 	 */
-	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
-	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
+	if (error == -EINVAL)
+		error = -EFSCORRUPTED;
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757105AbdLWAoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0gJVD097513
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:02 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2f1ct0r07v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:02 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0i1Do004068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:01 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0i1mL028133
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:01 GMT
Subject: [PATCH 11/21] xfs: fix a few erroneous process_error calls in the
 scrubbers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:44:00 -0800
Message-ID: <151398984007.18741.3912365431444339300.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There are a few places where we make a libxfs api call on behalf of some
object other than the one we're scrubbing but inadvertently call the
regular process_error function.  When this happens we mark the object
corrupt even though it was corruption in /some other/ object that
actually produced the -EFSCORRUPTED code.  The correct output flag for
these situations is SCRUB_OFLAG_XFAIL, not SCRUB_OFLAG_CORRUPT, so fix
this now that we also have a helper to set these.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c    |    2 +-
 fs/xfs/scrub/inode.c  |    2 +-
 fs/xfs/scrub/parent.c |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 69e1efd..e75826b 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -92,7 +92,7 @@ xfs_scrub_dir_check_ftype(
 	 * inodes can trigger immediate inactive cleanup of the inode.
 	 */
 	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
-	if (!xfs_scrub_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
+	if (!xfs_scrub_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 61cd112..304e8bc 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -619,7 +619,7 @@ xfs_scrub_inode(
 	if (xfs_is_reflink_inode(sc->ip)) {
 		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
 				&has_shared);
-		if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+		if (!xfs_scrub_xref_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
 				XFS_INO_TO_AGBNO(mp, ino), &error))
 			goto out;
 		if (!has_shared)
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 63a2533..dd704fd 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -169,7 +169,7 @@ xfs_scrub_parent_validate(
 	 * immediate inactive cleanup of the inode.
 	 */
 	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (dp == sc->ip) {
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
@@ -185,7 +185,7 @@ xfs_scrub_parent_validate(
 	 */
 	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
 		error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
+		if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
 				&error))
 			goto out_unlock;
 		if (nlink != expected_nlink)
@@ -205,7 +205,7 @@ xfs_scrub_parent_validate(
 
 	/* Go looking for our dentry. */
 	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_unlock;
 
 	/* Drop the parent lock, relock this inode. */


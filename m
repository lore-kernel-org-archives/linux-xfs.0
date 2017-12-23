Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757116AbdLWAoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0ggxQ097563
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:08 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2f1ct0r0db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0hO2J029320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:24 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0hO5q027901
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:24 GMT
Subject: [PATCH 05/21] xfs: distinguish between corrupt inode and invalid
 inum in xfs_scrub_get_inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:43:20 -0800
Message-ID: <151398980084.18741.9629764343639418897.stgit@magnolia>
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

In xfs_scrub_get_inode, we don't do a good enough job distinguishing
EINVAL returns from xfs_iget w/ IGET_UNTRUSTED -- this can happen if the
passed in inode number is invalid (past eofs, inobt says it isn't an
inode) or if the inum is actually valid but the inode buffer fails
verifier.  In the first case we still want to return ENOENT, but in the
second case we want to capture the corruption error.

Therefore, if xfs_iget returns EINVAL, try the raw imap lookup.  If that
succeeds, we conclude it's a corruption error, otherwise we just bounce
out to userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6ec4e10..d5c37d8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -503,6 +503,7 @@ xfs_scrub_get_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip_in)
 {
+	struct xfs_imap			imap;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_inode		*ip = NULL;
 	int				error;
@@ -518,10 +519,33 @@ xfs_scrub_get_inode(
 		return -ENOENT;
 	error = xfs_iget(mp, NULL, sc->sm->sm_ino,
 			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &ip);
-	if (error == -ENOENT || error == -EINVAL) {
-		/* inode doesn't exist... */
-		return -ENOENT;
-	} else if (error) {
+	switch (error) {
+	case -ENOENT:
+		/* Inode doesn't exist, just bail out. */
+		return error;
+	case 0:
+		/* Got an inode, continue. */
+		break;
+	case -EINVAL:
+		/*
+		 * -EINVAL with IGET_UNTRUSTED could mean one of several
+		 * things: userspace gave us an inode number that doesn't
+		 * correspond to fs space, or doesn't have an inobt entry;
+		 * or it could simply mean that the inode buffer failed the
+		 * read verifiers.
+		 *
+		 * Try just the inode mapping lookup -- if it succeeds, then
+		 * the inode buffer verifier failed and something needs fixing.
+		 * Otherwise, we really couldn't find it so tell userspace
+		 * that it no longer exists.
+		 */
+		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
+				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
+		if (error)
+			return -ENOENT;
+		error = -EFSCORRUPTED;
+		/* fall through */
+	default:
 		trace_xfs_scrub_op_error(sc,
 				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
 				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),


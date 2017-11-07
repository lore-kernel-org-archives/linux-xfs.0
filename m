Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47207 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdKGBDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:03:43 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA713giJ008394
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA713fDU004526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:41 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA713fVk016408
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:41 GMT
Subject: [PATCH 3/5] xfs: pass inode number to xfs_scrub_ino_set_{preen,
 warning}
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:40 -0800
Message-ID: <151001662000.26786.4013509197578072250.stgit@magnolia>
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

There are two ways to scrub an inode -- calling xfs_iget and checking
the raw inode core, or by loading the inode cluster buffer and checking
the on-disk contents directly.  The second method is only useful if
_iget fails the verifiers; when this is the case, sc->ip is NULL and
calling the tracepoint will cause a system crash.

Therefore, pass the raw inode number directly into the _preen and
_warning functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c   |    2 +-
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |    5 +++--
 fs/xfs/scrub/inode.c  |    8 ++++----
 4 files changed, 12 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5cf30de..4ed8047 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -98,7 +98,7 @@ xfs_scrub_xattr_listent(
 
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
-		xfs_scrub_ino_set_preen(sx->sc, NULL);
+		xfs_scrub_ino_set_preen(sx->sc, context->dp->i_ino, NULL);
 		return;
 	}
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 318dd97..ac95fe9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -165,10 +165,11 @@ xfs_scrub_block_set_preen(
 void
 xfs_scrub_ino_set_preen(
 	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
-	trace_xfs_scrub_ino_preen(sc, sc->ip->i_ino, bp ? bp->b_bn : 0,
+	trace_xfs_scrub_ino_preen(sc, ino, bp ? bp->b_bn : 0,
 			__return_address);
 }
 
@@ -215,10 +216,11 @@ xfs_scrub_fblock_set_corrupt(
 void
 xfs_scrub_ino_set_warning(
 	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
-	trace_xfs_scrub_ino_warning(sc, sc->ip->i_ino, bp ? bp->b_bn : 0,
+	trace_xfs_scrub_ino_warning(sc, ino, bp ? bp->b_bn : 0,
 			__return_address);
 }
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 0409ec2..5c04385 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -58,7 +58,8 @@ bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
 
 void xfs_scrub_block_set_preen(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, struct xfs_buf *bp);
+void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino,
+		struct xfs_buf *bp);
 
 void xfs_scrub_block_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
@@ -67,7 +68,7 @@ void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
 void xfs_scrub_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
-void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc,
+void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino,
 		struct xfs_buf *bp);
 void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index f275dd2..637b7a8 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -328,7 +328,7 @@ xfs_scrub_dinode(
 		 * We autoconvert v1 inodes into v2 inodes on writeout,
 		 * so just mark this inode for preening.
 		 */
-		xfs_scrub_ino_set_preen(sc, bp);
+		xfs_scrub_ino_set_preen(sc, ino, bp);
 		break;
 	case 2:
 	case 3:
@@ -353,7 +353,7 @@ xfs_scrub_dinode(
 	 */
 	if (dip->di_uid == cpu_to_be32(-1U) ||
 	    dip->di_gid == cpu_to_be32(-1U))
-		xfs_scrub_ino_set_warning(sc, bp);
+		xfs_scrub_ino_set_warning(sc, ino, bp);
 
 	/* di_format */
 	switch (dip->di_format) {
@@ -408,7 +408,7 @@ xfs_scrub_dinode(
 	 * overly large offsets, flag the inode for admin review.
 	 */
 	if (isize >= mp->m_super->s_maxbytes)
-		xfs_scrub_ino_set_warning(sc, bp);
+		xfs_scrub_ino_set_warning(sc, ino, bp);
 
 	/* di_nblocks */
 	if (flags2 & XFS_DIFLAG2_REFLINK) {
@@ -601,7 +601,7 @@ xfs_scrub_inode(
 				XFS_INO_TO_AGBNO(mp, ino), &error))
 			goto out;
 		if (!has_shared)
-			xfs_scrub_ino_set_preen(sc, bp);
+			xfs_scrub_ino_set_preen(sc, ino, bp);
 	}
 
 out:


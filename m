Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0D3C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 01:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 188D82343B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 01:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbhAHB5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 20:57:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbhAHB5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 20:57:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081t5rC016809;
        Fri, 8 Jan 2021 01:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=JqhD3DBXKMonCfnqjKqgbOuhLoimEp2NoQKqKLOvcMM=;
 b=IBW/pL9p8T3+uylS3ofee0bG43EQYhCkptZcJNiTHenF7NWmMVRhQfUGHNIlD2Z4v5R6
 iZsoFhBLhVRJn14v4k4bpoD9ko/YC7bA+PtcH5ImZbMT0nQ3Dv6yOkFyCamTqSKDHIyR
 gkI+DQ1kgZKRonasXOBbtnfg07RC8nN6v8z/pJdy7aY0Kgcb8DZCHReJzJCo4athksRm
 qeP7C3xRcjYOF0SvnvaIDmlSA1MNO+45Fe8CFrG2bvH4eaMpSBxSVP5skoLp+JbpIbGB
 r/oFBhS+bwlR/NbNSFvwXDnjn0djBLAfnZSfZUB53Gt/Eur3YgU+Cl9JJV0KbYofZ13A nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmf5p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 01:56:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081tSHC027518;
        Fri, 8 Jan 2021 01:56:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g3mem5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 01:56:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1081uob7017865;
        Fri, 8 Jan 2021 01:56:50 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 17:56:49 -0800
Date:   Thu, 7 Jan 2021 17:56:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     wenli xie <wlxie7296@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, chiluk@ubuntu.com,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210108015648.GP6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=914 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=925
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080007
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.  Set
t_firstblock so that a subsequent directory block allocation never tries
to grab a lower-numbered AGF than the AGIs we grabbed.

Reduce the likelihood that a directory expansion will ENOSPC by starting
with AG 0 when allocating whiteout files.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Make it more obvious that we're grabbing all the AGI locks ahead of
the AGFs, and hide functions that we don't need to export anymore.
---
 fs/xfs/libxfs/xfs_dir2.h    |    2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |    2 +-
 fs/xfs/xfs_inode.c          |   57 ++++++++++++++++++++++++++++++-------------
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e55378640b05..d03e6098ded9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 2463b5d73447..8c4f76bba88b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b7352bc4c815..528152770dc9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3000,6 +3000,24 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+/* Decide if we need to lock the target IP's AGI as part of a rename. */
+static inline bool
+xfs_rename_lock_target_ip(
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_ip)
+{
+	unsigned int		tgt_nlink = VFS_I(target_ip)->i_nlink;
+	bool			src_is_dir = S_ISDIR(VFS_I(src_ip)->i_mode);
+
+	/*
+	 * We only need to lock the AGI if the target ip will end up on the
+	 * unlinked list.
+	 */
+	if (src_is_dir)
+		return tgt_nlink == 2;
+	return tgt_nlink == 1;
+}
+
 /*
  * xfs_rename
  */
@@ -3017,7 +3035,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_buf		*agibp;
+	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3130,6 +3148,27 @@ xfs_rename(
 		}
 	}
 
+	/*
+	 * Lock the AGI buffers we need to handle bumping the nlink of the
+	 * whiteout inode off the unlinked list and to handle dropping the
+	 * nlink of the target inode.  We have to do this in increasing AG
+	 * order to avoid deadlocks, and before directory block allocation
+	 * tries to grab AGFs.
+	 */
+	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
+		if (inodes[i] == wip ||
+		    (inodes[i] == target_ip &&
+		     xfs_rename_lock_target_ip(src_ip, target_ip))) {
+			struct xfs_buf	*bp;
+			xfs_agnumber_t	agno;
+
+			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
+			error = xfs_read_agi(mp, tp, agno, &bp);
+			if (error)
+				goto out_trans_cancel;
+		}
+	}
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
@@ -3182,22 +3221,6 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
-
-		/*
-		 * Check whether the replace operation will need to allocate
-		 * blocks.  This happens when the shortform directory lacks
-		 * space and we have to convert it to a block format directory.
-		 * When more blocks are necessary, we must lock the AGI first
-		 * to preserve locking order (AGI -> AGF).
-		 */
-		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
-			error = xfs_read_agi(mp, tp,
-					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
-					&agibp);
-			if (error)
-				goto out_trans_cancel;
-		}
-
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)

Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA67C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802A5206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zKLbKj3h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgCLDrP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:47:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCLDrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:47:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3eW3X167999;
        Thu, 12 Mar 2020 03:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=u8kOaCN82CSC3g9gRSs/Pfu8dg2KymAf4NX+1iwI/GA=;
 b=zKLbKj3hTTF1Jq7obEcEZ/lbpwNn2NjwoHUelsAmqUCF3diohbfpI2ZdqnhYX2k/Pogu
 9BZllMXkfBQAm+VevfZbOyIrjP1M11v3sqZ6pKzEJjphZGr8LQJUeRDx30IWueiEhesP
 WAF6Hy+VUR0ouetBnNR2EuWLOYYTDaBs1x45uZ5jwIRCk03AZpiF/m8wmBhIxLbEqNin
 t2fzwn3EesffWeo3rZi+cjmPKC0325x2F+XrU5Bko2crN5KatF8kx8dJHBeseDqfdr5V
 JYNAr4dvnRfCUEvLrpkv0zLIDdOGtFlgotLMS/JqoWEPS7NNhcA6rHZ/hq6BIQX1q143 tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yp9v6aa1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:47:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cBK6055438;
        Thu, 12 Mar 2020 03:45:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qxq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3j981007171;
        Thu, 12 Mar 2020 03:45:09 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:08 -0700
Subject: [PATCH 4/7] xfs: rename btree cursor private btree member flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 11 Mar 2020 20:45:07 -0700
Message-ID: <158398470751.1307855.8464463416155765479.stgit@magnolia>
In-Reply-To: <158398468107.1307855.8287106235853942996.stgit@magnolia>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

BPRV is not longer appropriate because bc_private is going away.
Script:

$ sed -i 's/BTCUR_BPRV/BTCUR_BMBT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

With manual cleanup to the definitions in fs/xfs/libxfs/xfs_btree.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: change "BC_BT" to "BTCUR_BMBT", fix subject line typo]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_btree.c      |    2 +-
 fs/xfs/libxfs/xfs_btree.h      |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fc8f6d65576c..8057486c02b5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -1528,7 +1528,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
-	       (bma->cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
+	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2752,7 +2752,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4188,7 +4188,7 @@ xfs_bmapi_allocate(
 
 	if (bma->cur)
 		bma->cur->bc_ino.flags =
-			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 71b60f2a9979..295a59cf8840 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -230,7 +230,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
@@ -644,7 +644,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
-	cur->bc_ino.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
+	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8c6e128c8ae8..4ef9f0b42c7f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1743,7 +1743,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
-	    !(cur->bc_ino.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
+	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_ino.ip->i_ino)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4a1c98bdfaad..00a58ac8b696 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -220,8 +220,8 @@ typedef struct xfs_btree_cur
 			short		forksize;	/* fork's inode space */
 			char		whichfork;	/* data or attr fork */
 			char		flags;		/* flags */
-#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
-#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
+#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
+#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
 #define bc_ag	bc_private.a


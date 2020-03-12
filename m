Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33830C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD9D206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YzUYehCp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbgCLDrd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:47:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCLDrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:47:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBPb181336;
        Thu, 12 Mar 2020 03:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aHc65jiVxGui4PHmmG19a19Y+jLI4qA3km+DxO711QM=;
 b=YzUYehCpDQLC8YiGInjKnTjyo4t0hLCsPf7dSnLXDORPAJoH9SRYCEnzY2fgEvn0kkAA
 y1i/Fvb3t+zxRZh+NNgIosuZVFl8KSG84dfJpsO7rqDta4+0dS6cjvoXjEiJuBaNBxFY
 01AJ7nGwvMe5S1zp9gqa4umxS3x6ZfDErfpasODib3mL0yhUHKtNgqb5k28qvc4Wl+Kv
 fKQDEtwlrwfqEQLKnkK7pen6cbpds85nwYJcRRzu3X0+kPt05mk2fbpZVvjtAEHPDWp1
 91XX6/KwmRhV2oA3CHDUEYNK8GTFimCakghvlXxex+8s8Suv2apX/jHRXtBc5ckHCe/g Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31uq7ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:47:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cAHo055218;
        Thu, 12 Mar 2020 03:45:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qypx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3jSEi017011;
        Thu, 12 Mar 2020 03:45:28 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:28 -0700
Subject: [PATCH 7/7] xfs: make the btree ag cursor private union anonymous
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 11 Mar 2020 20:45:27 -0700
Message-ID: <158398472694.1307855.12435739558591642821.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is much less widely used than the bc_private union was, so this
is done as a single patch. The named union xfs_btree_cur_private
goes away and is embedded into the struct xfs_btree_cur_ag as an
anonymous union, and the code is modified via this script:

$ sed -i 's/priv\.\([abt|refc]\)/\1/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   14 +++++++-------
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_btree.h          |   25 +++++++++++--------------
 fs/xfs/libxfs/xfs_refcount.c       |   24 ++++++++++++------------
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
 5 files changed, 33 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 10ed68dfef5d..337822115bbc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -151,7 +151,7 @@ xfs_alloc_lookup_eq(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -171,7 +171,7 @@ xfs_alloc_lookup_ge(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -190,7 +190,7 @@ xfs_alloc_lookup_le(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -198,7 +198,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_ag.priv.abt.active;
+	return cur && cur->bc_ag.abt.active;
 }
 
 /*
@@ -908,7 +908,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_ag.priv.abt.active = false;
+		cur->bc_ag.abt.active = false;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1352,7 +1352,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_ag.priv.abt.active = false;
+			cur->bc_ag.abt.active = false;
 
 		if (count > 0)
 			count--;
@@ -1467,7 +1467,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_ag.priv.abt.active = true;
+			acur->cnt->bc_ag.abt.active = true;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 92d30c19519d..a28041fdf4c0 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -507,7 +507,7 @@ xfs_allocbt_init_cursor(
 
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
-	cur->bc_ag.priv.abt.active = false;
+	cur->bc_ag.abt.active = false;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 9884f543eb51..0d10bbd5223a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -177,22 +177,19 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
-/* Per-AG btree private information. */
-union xfs_btree_cur_private {
-	struct {
-		unsigned long	nr_ops;		/* # record updates */
-		int		shape_changes;	/* # of extent splits */
-	} refc;
-	struct {
-		bool		active;		/* allocation cursor state */
-	} abt;
-};
-
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_buf			*agbp;
-	xfs_agnumber_t			agno;
-	union xfs_btree_cur_private	priv;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;
+	union {
+		struct {
+			unsigned long nr_ops;	/* # record updates */
+			int	shape_changes;	/* # of extent splits */
+		} refc;
+		struct {
+			bool	active;		/* allocation cursor state */
+		} abt;
+	};
 };
 
 /* Btree-in-inode cursor information */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ef3e706f1d94..2076627243b0 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -883,7 +883,7 @@ xfs_refcount_still_have_space(
 {
 	unsigned long			overhead;
 
-	overhead = cur->bc_ag.priv.refc.shape_changes *
+	overhead = cur->bc_ag.refc.shape_changes *
 			xfs_allocfree_log_count(cur->bc_mp, 1);
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -891,17 +891,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
+	if (cur->bc_ag.refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.priv.refc.nr_ops == 0)
+	if (cur->bc_ag.refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -968,7 +968,7 @@ xfs_refcount_adjust_extents(
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
-				cur->bc_ag.priv.refc.nr_ops++;
+				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.agno,
@@ -1003,7 +1003,7 @@ xfs_refcount_adjust_extents(
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
 				goto out_error;
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 		} else if (ext.rc_refcount == 1) {
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
@@ -1012,7 +1012,7 @@ xfs_refcount_adjust_extents(
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
@@ -1088,7 +1088,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.priv.refc.shape_changes++;
+		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
@@ -1166,8 +1166,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.agno != agno) {
-		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
-		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
+		nr_ops = rcur->bc_ag.refc.nr_ops;
+		shape_changes = rcur->bc_ag.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1183,8 +1183,8 @@ xfs_refcount_finish_one(
 			error = -ENOMEM;
 			goto out_cur;
 		}
-		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
-		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
+		rcur->bc_ag.refc.nr_ops = nr_ops;
+		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index bf1a4cb3c7ac..e07a2c45f8ec 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -340,8 +340,8 @@ xfs_refcountbt_init_cursor(
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.priv.refc.nr_ops = 0;
-	cur->bc_ag.priv.refc.shape_changes = 0;
+	cur->bc_ag.refc.nr_ops = 0;
+	cur->bc_ag.refc.shape_changes = 0;
 
 	return cur;
 }


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB400C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94BDA600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOXKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXKc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B51610A6;
        Wed, 15 Sep 2021 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747353;
        bh=KdRw3JpEg9pXg3DqHTtI9W4qAnWIfAJqLT+CNcg/ywk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VP82nySuQYHQI5EOfV3410iX+25H5+yM3NAIkaDWcmFfW88TBk7DMJOtwtDxdWF1g
         ijMN1x16wD1aUa0QX9c7mYACB6OA+9T+WOuAPHq/A9rKi+EJrrfjhwpZ+5mSXG1wXs
         BiWde6FCS4e1v6pdn5O+xBJ5jBMz8DJBG3+NNYUM9eqp7EdHHPHGAhAdpBHNNzcru7
         xNi+zOtkegZVwT13ZpHBheHXP48d8/wNTBV1PXiXeZprnZgUirYO+hoopJrk1w/R7e
         pRHMvBYXntF2fyiw6rcLSxBZDHoKJT0enDUqtSRpMuQuhUmrzJNIDLn/fW8Uopd29u
         w0vOX+Pt5hn4Q==
Subject: [PATCH 29/61] xfs: push perags through the ag reservation callouts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:13 -0700
Message-ID: <163174735301.350433.10174246477569374371.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 30933120ad79f4549d6e364df7eda474cc0d9c65

We currently pass an agno from the AG reservation functions to the
individual feature accounting functions, which in future may have to
do perag lookups to access per-AG state. Instead, pre-emptively
plumb the perag through from the highest AG reservation layer to the
feature callouts so they won't have to look it up again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/info.c                   |    8 +++++---
 libxfs/xfs_ag_resv.c        |    9 ++++-----
 libxfs/xfs_ialloc_btree.c   |   17 +++++++++--------
 libxfs/xfs_ialloc_btree.h   |    2 +-
 libxfs/xfs_refcount_btree.c |    7 +++----
 libxfs/xfs_refcount_btree.h |    3 ++-
 libxfs/xfs_rmap_btree.c     |    6 +++---
 libxfs/xfs_rmap_btree.h     |    2 +-
 8 files changed, 28 insertions(+), 26 deletions(-)


diff --git a/db/info.c b/db/info.c
index 2731446d..6c5c3e5b 100644
--- a/db/info.c
+++ b/db/info.c
@@ -66,19 +66,20 @@ print_agresv_info(
 {
 	struct xfs_buf	*bp;
 	struct xfs_agf	*agf;
+	struct xfs_perag *pag = xfs_perag_get(mp, agno);
 	xfs_extlen_t	ask = 0;
 	xfs_extlen_t	used = 0;
 	xfs_extlen_t	free = 0;
 	xfs_extlen_t	length = 0;
 	int		error;
 
-	error = -libxfs_refcountbt_calc_reserves(mp, NULL, agno, &ask, &used);
+	error = -libxfs_refcountbt_calc_reserves(mp, NULL, pag, &ask, &used);
 	if (error)
 		xfrog_perror(error, "refcountbt");
-	error = -libxfs_finobt_calc_reserves(mp, NULL, agno, &ask, &used);
+	error = -libxfs_finobt_calc_reserves(mp, NULL, pag, &ask, &used);
 	if (error)
 		xfrog_perror(error, "finobt");
-	error = -libxfs_rmapbt_calc_reserves(mp, NULL, agno, &ask, &used);
+	error = -libxfs_rmapbt_calc_reserves(mp, NULL, pag, &ask, &used);
 	if (error)
 		xfrog_perror(error, "rmapbt");
 
@@ -96,6 +97,7 @@ print_agresv_info(
 	if (ask - used > free)
 		printf(" <not enough space>");
 	printf("\n");
+	xfs_perag_put(pag);
 }
 
 static int
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 34ab68c0..b1392cda 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -249,7 +249,6 @@ xfs_ag_resv_init(
 	struct xfs_trans		*tp)
 {
 	struct xfs_mount		*mp = pag->pag_mount;
-	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
 	int				error = 0, error2;
@@ -259,11 +258,11 @@ xfs_ag_resv_init(
 	if (pag->pag_meta_resv.ar_asked == 0) {
 		ask = used = 0;
 
-		error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
-		error = xfs_finobt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_finobt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
@@ -281,7 +280,7 @@ xfs_ag_resv_init(
 
 			mp->m_finobt_nores = true;
 
-			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
+			error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask,
 					&used);
 			if (error)
 				goto out;
@@ -299,7 +298,7 @@ xfs_ag_resv_init(
 	if (pag->pag_rmapbt_resv.ar_asked == 0) {
 		ask = used = 0;
 
-		error = xfs_rmapbt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_rmapbt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 3f0512b2..e93843e2 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 STATIC int
 xfs_inobt_get_minrecs(
@@ -679,7 +680,7 @@ static int
 xfs_inobt_count_blocks(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum,
 	xfs_extlen_t		*tree_blocks)
 {
@@ -687,7 +688,7 @@ xfs_inobt_count_blocks(
 	struct xfs_btree_cur	*cur = NULL;
 	int			error;
 
-	error = xfs_inobt_cur(mp, tp, agno, btnum, &cur, &agbp);
+	error = xfs_inobt_cur(mp, tp, pag->pag_agno, btnum, &cur, &agbp);
 	if (error)
 		return error;
 
@@ -703,14 +704,14 @@ static int
 xfs_finobt_read_blocks(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp;
 	struct xfs_agi		*agi;
 	int			error;
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
 	if (error)
 		return error;
 
@@ -727,7 +728,7 @@ int
 xfs_finobt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -738,14 +739,14 @@ xfs_finobt_calc_reserves(
 		return 0;
 
 	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
-		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
+		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
+		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
 				&tree_len);
 	if (error)
 		return error;
 
-	*ask += xfs_inobt_max_size(mp, agno);
+	*ask += xfs_inobt_max_size(mp, pag->pag_agno);
 	*used += tree_len;
 	return 0;
 }
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 35bbd978..d5afe01f 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -64,7 +64,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #endif	/* DEBUG */
 
 int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 5344b282..e23ea313 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -449,7 +449,7 @@ int
 xfs_refcountbt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -462,8 +462,7 @@ xfs_refcountbt_calc_reserves(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
 	if (error)
 		return error;
 
@@ -478,7 +477,7 @@ xfs_refcountbt_calc_reserves(
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
 	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index 69dc515d..eab1b0c6 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_perag;
 struct xbtree_afakeroot;
 
 /*
@@ -58,7 +59,7 @@ extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp,
 		xfs_agblock_t agblocks);
 
 extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
-		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
+		struct xfs_trans *tp, struct xfs_perag *pag, xfs_extlen_t *ask,
 		xfs_extlen_t *used);
 
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7abca87e..c8cac84f 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -593,7 +593,7 @@ int
 xfs_rmapbt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -606,7 +606,7 @@ xfs_rmapbt_calc_reserves(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
 	if (error)
 		return error;
 
@@ -621,7 +621,7 @@ xfs_rmapbt_calc_reserves(
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
 	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	/* Reserve 1% of the AG or enough for 1 block per record. */
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 35b81fc8..cef361a1 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -57,6 +57,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 		xfs_agblock_t agblocks);
 
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
 #endif /* __XFS_RMAP_BTREE_H__ */


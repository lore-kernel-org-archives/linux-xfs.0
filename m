Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1750C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D57208C7
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfadqAG5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgJGOv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AF1C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so1157438pjr.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HWUYFVLMHbrA7Y3ulp07MIQubBSMBnV3e9fvI+FdOGg=;
        b=KfadqAG5qJSGCTNi7Smz0r/jTjKwUY+QkMP+zYgjCberBDsoD3r8kI3vzqVep4FmWf
         KCd0dgE29n5ufsVilrjjku7C3D8ObN9Pq88mCPyxbuOvxRLlNT0jAcEvtWalANdzFSEh
         5m+z3wtxE9kKqtSnVGe8dGZ7kKYygf90f5jpccVbC4VtK1VzQIACDmYnzI81Oxsoyoor
         WluO60Rj1XBkInRp8xK1dyU5t4ycngJGaBe6krMbt6vn/cLc32Z1W41Ik3CBH21m9/wC
         oDbBk3o7/5SMQkHdIAxqDiEXRkKAhb59w2lPPSWeOGyGvoPnPeLcRUP8/l6tdEPTlnLS
         SK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HWUYFVLMHbrA7Y3ulp07MIQubBSMBnV3e9fvI+FdOGg=;
        b=artNXYB+KulUFXlLN0+tpixMiNPEZskGxQnYIIP4F38OHdHI5LWICb35tY01QPuaAO
         xZcTYIbKQGjhlCmV7rq/zgHZIfEPGPAbRaRtBs7jiOW2ZEl6er+efLOdjX/0BPMgZfF8
         FZ9eoByPDIFe8wVmj2NueyZlhhkwGDN1zWXp8KrKYPmR+2CIqywUfuaMbug/qhe6lLVq
         HAymDTl8BKyYQCds6XvJawlvd0sZ3UdvdStK4bdd+dLhJAiN9hy1q8qnzc+mkCQBnXcf
         uLH+oSkHcYRAhVi9RxwE3jEL6FUietK8XfwT+tk6/TtNpT87DdP20oRtQDgqAKBZfgvq
         op6w==
X-Gm-Message-State: AOAM530eyj5GI2KoTX0TWbBVVVak6LVoZQ+r1z3A/hO+9AhMg8RGT0jl
        NlP/YYCLX8OurMOiKqG5DGCxadbAwlPr
X-Google-Smtp-Source: ABdhPJxBexWggpLOdDSnXKWQFHxIc7/8wmsYAJrBa8O29VOHkT+i4avLgQwxFCpwPJ8PwQiw579FUw==
X-Received: by 2002:a17:90b:33c6:: with SMTP id lk6mr3072834pjb.163.1602082285628;
        Wed, 07 Oct 2020 07:51:25 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:25 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 4/5] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
Date:   Wed,  7 Oct 2020 22:51:11 +0800
Message-Id: <1602082272-20242-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
is to say, we allocate the new tp->t_dqinfo only when the qtrx values
changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
flag is set, we only need to check if tp->t_dqinfo == NULL in
xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
whether lock all of the dquots and join them to the transaction.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +-------
 fs/xfs/xfs_trans_dquot.c   | 17 ++---------------
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c795ae47b3c9..8c61a461bf7b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
 #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
 #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 49624973eecc..9108eed0ea45 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -941,7 +941,6 @@ xfs_dir_ialloc(
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1000,12 +999,9 @@ xfs_dir_ialloc(
 		 * and attach it to the next transaction.
 		 */
 		dqinfo = NULL;
-		tflags = 0;
 		if (tp->t_dqinfo) {
 			dqinfo = (void *)tp->t_dqinfo;
 			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
 		code = xfs_trans_roll(&tp);
@@ -1013,10 +1009,8 @@ xfs_dir_ialloc(
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
 		 */
-		if (dqinfo) {
+		if (dqinfo)
 			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
 
 		if (code) {
 			xfs_buf_relse(ialloc_context);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 1b56065c9ff1..0ebfd7930382 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
 
 	xfs_trans_alloc_dqinfo(ntp);
 
-	/*
-	 * Because the quota blk reservation is carried forward,
-	 * it is also necessary to carry forward the DQ_DIRTY flag.
-	 */
-	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
-		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
-
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
 		oqa = otp->t_dqinfo->dqs[j];
 		nqa = ntp->t_dqinfo->dqs[j];
@@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
 
 	if (delta)
 		trace_xfs_trans_mod_dquot_after(qtrx);
-
-	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
 
 
@@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
 	int64_t			totalbdelta;
 	int64_t			totalrtbdelta;
 
-	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	ASSERT(tp->t_dqinfo);
@@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
 	struct xfs_dqtrx	*qtrx, *qa;
 	bool			locked;
 
-	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
@@ -695,7 +686,6 @@ xfs_trans_dqresv(
 	 * because we don't have the luxury of a transaction envelope then.
 	 */
 	if (tp) {
-		ASSERT(tp->t_dqinfo);
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 		if (nblks != 0)
 			xfs_trans_mod_dquot(tp, dqp,
@@ -749,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	if (tp && tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-- 
2.20.0


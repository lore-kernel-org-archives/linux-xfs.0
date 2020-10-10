Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCF5C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF53B221FF
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFCkYhW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgJJDJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 23:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730338AbgJJCya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 22:54:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D1EC0613D2
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 19:54:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d1so39773pfc.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 19:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cjVZHoec1iNSj5zagp9OoP0QYXD9vp1o9B3HGu0VgvE=;
        b=iFCkYhW0UbCCSVsYMz7qgA6DabnWUp/Qc4Zt9VU/eadKeym+8HnbP9DrxgqVPGiIJD
         FuxQJj0Zi+uZVyKy81lDZQLDlbjEdwUZV9owkWw5OQGBtbT7CIGvuAGHXLbg56m560Qr
         Um0GEtYZlMlbC1AUoZv1QXdqaEWpEvSaAlIvdk1EaZLq2yw9A+yS9Ng4uClWLU7yRLdY
         B1RYD+Jpo9GQ5p5eRjhLuAZWBk7GXO3XERIbQGOiL1ScaXb9UaXHwA6//vplt+09Ic04
         UJ0nMGeoMzVqcogXWbZCUSGCSWNLUk6+nTBzFz0YSsgGxAi+Q9XrpiujZ68Q3CB0mwe7
         g7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cjVZHoec1iNSj5zagp9OoP0QYXD9vp1o9B3HGu0VgvE=;
        b=St1n+QfjDMHlm7jvJKY1Ov4izNnIoPKffwqbqC3uWDbTuzRd7eJzmpmdohTzd3KpuF
         UWshxi4yXDtXxjVNUYcR8g+UhAEKfXa1cHNB14COUHyNuzZHw/FfpEU2UANL2wwrlgEY
         QPanE/ipSe1/1AjCddc3wJociwFmy/GNWzoqqWGoAEJzMNN4ilz8vGfm9ZlkGSTUvOfp
         xNtpwMs/8deVsrdvHf4ZDdAwnCFzwtCna0xU0rI9E/a9yGz5s1TkrkkUxUszp9Pnqf8o
         h0uq95tbbAVD/Th2oJobuRTOHQPKu1HUa3CeiPYtaG3FvustpQ3jyB6Mne37XEsfnVM+
         xMJA==
X-Gm-Message-State: AOAM530kdSO3XknFoqgvcLKy2isLm2WNnB7jutII2/MStoZpMKTk+tgp
        /cqw91vRywP+AdkB1qrdj0yXgQYcKWXG
X-Google-Smtp-Source: ABdhPJxjdSDC9AWr4Q3hj30CCqpOOzsLrKHFvwb7GYAjHHsp2W1SgI9vRr3JZZbeDSBcY19lJl5Juw==
X-Received: by 2002:a05:6a00:134d:b029:155:d4c:abf2 with SMTP id k13-20020a056a00134db02901550d4cabf2mr15231534pfu.51.1602298469781;
        Fri, 09 Oct 2020 19:54:29 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id kc21sm4800826pjb.36.2020.10.09.19.54.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2020 19:54:29 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v5 2/3] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
Date:   Sat, 10 Oct 2020 10:54:20 +0800
Message-Id: <1602298461-32576-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +-------
 fs/xfs/xfs_trans_dquot.c   | 13 ++-----------
 3 files changed, 3 insertions(+), 19 deletions(-)

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
index 2bfbcf28b1bd..4d2cebaa3637 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -959,7 +959,6 @@ xfs_dir_ialloc(
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1018,12 +1017,9 @@ xfs_dir_ialloc(
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
@@ -1031,10 +1027,8 @@ xfs_dir_ialloc(
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
index 67f1e275b34d..0ebfd7930382 100644
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
-- 
2.20.0


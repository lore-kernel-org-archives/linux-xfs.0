Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0025CC43457
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05E72071A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkMxTXne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394243AbgJPDij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394231AbgJPDii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 23:38:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EF1C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:38 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h4so672081pjk.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AxcmPMgk6Pv7pmjlyF7cb9EhnJeD6m3Xhl4+w4H5kBw=;
        b=YkMxTXneQ4+NYdIZbbnhTXX3N4wXzGi1NsKW+NHCFuflp3MbvwRUldIyF5CSZgAdMD
         kBIbSIADbdGYe/8b2XkevJXMuTkya60+BP97dSc/sDzWx6QlzOlt/6kp+1SBfY9dBrNI
         H7efZ7eCx4qqiTJY0obM3lParG5tKCESjErW8ZegAOt/VgvGpnhiCA9nHW0UN46nt4NS
         sSadb1fgNMwi3Hm8zlhGhT6krXWQbzTw+kXROUFoBe0BJzIDcWu5d4seg2bX5r1sSyda
         6rPBZLQ+rqUw2rbL0TdZo3CArPRqlARG1TMb7JCgWn8YO/49ZST62OILILIgnWyr5Pqp
         yOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AxcmPMgk6Pv7pmjlyF7cb9EhnJeD6m3Xhl4+w4H5kBw=;
        b=THxJcU2Xs12SPwMWvDxTmBDKDZcDlykUSuP2wiDvxdQmk2ZGeNo1Fd1cnrp1SGDw/N
         4Ztxs+Ybi4uD8A5bMmTCw3bcziccE8k5SvvOEXBm1hmj8GNUwiLgmLOLX18I/cPjj5ys
         z94G6rI+YK9xNhEQPCmULoLmAlrgDUpIGUODsgvqAHKpbAY+UNs3GCq1OxGsuD9N97By
         QFKhP/ZcrOCTcDHXbtXj7G5R3xTvrSlk3xDxf+f7SFMg7kMugQzwSJkQNh9O9/7sQ/7F
         pNiOsd5f+7J7gGjff81lsA86Ja3cCibAGQSZUg+XAqy8q3GHNODv7MBAS1URap8Jzqpb
         ElFA==
X-Gm-Message-State: AOAM532U1uLUVMdI/UMsmoqWj7kVq3CFEnN4xqoIJtubYoDStVEGMZGo
        0P/q1M42WidwfyK8hQn1TjAbHKWsdw==
X-Google-Smtp-Source: ABdhPJx5TsNIbJW168ufAHbi5D0A8+HflQp96MTLHR8S6FchNgiz7p0cmyJGsPunjPELsrYXXIdYMA==
X-Received: by 2002:a17:90a:fe82:: with SMTP id co2mr1993643pjb.22.1602819517954;
        Thu, 15 Oct 2020 20:38:37 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o15sm890238pfp.91.2020.10.15.20.38.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 20:38:37 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v6 3/3] xfs: directly return if the delta equal to zero
Date:   Fri, 16 Oct 2020 11:38:28 +0800
Message-Id: <1602819508-29033-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if
it is NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS
_{USR,GRP,PRJ}]. Nowadays seems none of the callers want to join the
dquots to the transaction and push them to device when the delta is
zero. Actually, most of time the caller would check the delta and go
on only when the delta value is not zero, so we should bail out when
it is zero.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_dquot.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0ebfd7930382..28b8ac701919 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -194,6 +194,9 @@ xfs_trans_mod_dquot(
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
 	qtrx = NULL;
 
+	if (!delta)
+		return;
+
 	if (tp->t_dqinfo == NULL)
 		xfs_trans_alloc_dqinfo(tp);
 	/*
@@ -205,10 +208,8 @@ xfs_trans_mod_dquot(
 	if (qtrx->qt_dquot == NULL)
 		qtrx->qt_dquot = dqp;
 
-	if (delta) {
-		trace_xfs_trans_mod_dquot_before(qtrx);
-		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
-	}
+	trace_xfs_trans_mod_dquot_before(qtrx);
+	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	switch (field) {
 	/* regular disk blk reservation */
@@ -261,8 +262,7 @@ xfs_trans_mod_dquot(
 		ASSERT(0);
 	}
 
-	if (delta)
-		trace_xfs_trans_mod_dquot_after(qtrx);
+	trace_xfs_trans_mod_dquot_after(qtrx);
 }
 
 
@@ -687,14 +687,9 @@ xfs_trans_dqresv(
 	 */
 	if (tp) {
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
-		if (nblks != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    flags & XFS_QMOPT_RESBLK_MASK,
-					    nblks);
-		if (ninos != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    XFS_TRANS_DQ_RES_INOS,
-					    ninos);
+		xfs_trans_mod_dquot(tp, dqp, flags & XFS_QMOPT_RESBLK_MASK,
+				    nblks);
+		xfs_trans_mod_dquot(tp, dqp, XFS_TRANS_DQ_RES_INOS, ninos);
 	}
 	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
 	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-- 
2.20.0


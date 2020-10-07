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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54FBC4727E
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64AAE2075A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bzs8Zqpc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgJGOv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9841CC061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q123so1479099pfb.0
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O5+4pxfm0rIlhTIAygdUSVKVo6uA95EQBJHjeRSVM6Q=;
        b=Bzs8ZqpcvRlu6Vlzy04bHmzoKYxd2L783c+u7QoCp+QzWtIwfHkNHuczY8ck1N3Bp6
         UPXyOeAt8SbqmaOyLlMXxCMmufij6d1tnPgGiSauDNqTw7Q9FEvcywqVSAu2+4Gs6wyC
         Ix3mN0Iwwm+xn2qaCMxyWuc5e/IP+XhRuHzmgAvcR5zJAkOP+eo1tXZSUhFpx2+OHZWn
         Rd6luJGKf/Gjt8mOAtThfzIvvg7WR/xtjvxWwOo8VNJK+sl7Q0p3jmu8E+cPOK+nCIkl
         mTeABHpiQlmOfye0yUDpHWW8vRXcYR5kT1j+sXtOqLPstfCrCQ6D8W6+InrQ/OUI9hHh
         pZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O5+4pxfm0rIlhTIAygdUSVKVo6uA95EQBJHjeRSVM6Q=;
        b=YezAz1SyaEXhMz80fskWT0WI6bCoXbhFd9WOk6CFRz2ZRpNlurp+KWeYh9XaTUG+/g
         DQh3MNzyPo0yngV5hBDeIf80UmjfLkB9n9vD28PZrVPcB/TSLvr2aZ/UTgi6jYN9agPW
         pdawFhF/QpKfXgoTeFzzlXsDpH6BFj6F4SmExnRoIjDyAz/vZZzQhrnpTZGy3tT5MEnm
         D65myhypWUkobme0E6iZTQlUYoj4+zdzxd5jBVu/SJhhZalFyLQHAyusQaqdYS3qxG1I
         MePKRjcOTrvI9vGzW+V+D9TE2rqWNvpsmijZsuP9IDojGWgf80ZH3uT0g5qyBlKUF/1o
         JqIA==
X-Gm-Message-State: AOAM531dkXyvHqu9OkVEdizlnsMo2DAbNbLw41cLQJuWgHXqBiDkdIzp
        QgKRzizl8YLVcgGhzs8B4SRCh81FutTE
X-Google-Smtp-Source: ABdhPJwsrZYZy5QUxqGwQdAJqzn6VYNcxFj7OBv33Bnsw+u8MoVc69k7xL3Z1GMUl0eLgNFw6id8gw==
X-Received: by 2002:a63:ce17:: with SMTP id y23mr3456008pgf.447.1602082286830;
        Wed, 07 Oct 2020 07:51:26 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 5/5] xfs: directly return if the delta equal to zero
Date:   Wed,  7 Oct 2020 22:51:12 +0800
Message-Id: <1602082272-20242-6-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if it is
NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}].
Nowadays seems none of the callers want to join the dquots to the
transaction and push them to device when the delta is zero. Actually,
most of time the caller would check the delta and go on only when the
delta value is not zero, so we should bail out when it is zero.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_trans_dquot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 0ebfd7930382..3e37501791bf 100644
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
 
 
-- 
2.20.0


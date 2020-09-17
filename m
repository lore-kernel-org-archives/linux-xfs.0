Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F032C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1394422205
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edDklxcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIQLjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgIQLjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:39:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE08C061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id v14so1090185pjd.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c6MxJDM8pM6i7ZYjZG1xA71VPqPP0Eg2AIP/5f8k0yc=;
        b=edDklxcg49PNl62QJl6cMS4QAcEs5YZBdNpDrwfUKsQi51dvVTPUN3YgQ+o1yCNPG8
         MllBhDT8/pLLB9CTi7K0mgEmmgEwXQaoC1xo95Da/52RINMXEpry3v3wpHn2Sqccyddl
         KQJdm5A9JZ3JjieAenaobnMBOAJJNmuBdFj6jwR7bbZiCQs14li91vf4Q503jD4bR9+T
         0LxbOU2hwzITcznacjaegFCh1XvgCgVBeHzje9XlSntJlNm4vRnh7veGiRjXx07o0cze
         A2Vfn8H6mguF20pqne6V7l28jXIwHc8Cugo2/9enmQt80Jim+tGjjuHPmlAuBxJHpLG3
         btbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c6MxJDM8pM6i7ZYjZG1xA71VPqPP0Eg2AIP/5f8k0yc=;
        b=qcNEognlwa+4VpQttg1efbU0011/YbjGIoiOuPVU3iD/3tGgM5XT0MVFI4BW0NgB7W
         QGOqpr90sFUX99HY0LOdday6tkO0NVfYWmDqV116bBMAmWmsBusYHQ2E/4NmtVyy3MCy
         ibmXA9A0JqcrgOfa6vXNea/PtJp7AjRbNnyppVXD4TN1fdhEmC42zXSf8znN9XTZdfoP
         hOpMhY9uafedHI/2yk0PiLaGFNq1NzPALhhWUEbDwAx0j7xzxFSb7us+0SJN8UP8p7qb
         rzosUKKRKCsK/+rBv+ExZOynbyKYGfAjAgFcHKV2IpBCM6NJq6YGC3QrPowcuLNseSz7
         KFPg==
X-Gm-Message-State: AOAM530nVVwwAgz0nuttskSKX4CMu5EsaFawbWTnIMxz053oyKMTh5zK
        FgUh9qHol/xwnmB1HBN1atw85TIeTg==
X-Google-Smtp-Source: ABdhPJy2C2XjDJszkgaYAq/htt88eWggQNpcxHmFaw/SWa5VdKC2p6oYlKS7yjdEp82sbOaX6VY4IQ==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr8339476pjr.229.1600342738862;
        Thu, 17 Sep 2020 04:38:58 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:58 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 4/7] xfs: do the assert for all the log done items in xfs_trans_cancel
Date:   Thu, 17 Sep 2020 19:38:45 +0800
Message-Id: <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We should do the assert for all the log intent-done items if they appear
here. This patch detect intent-done items by the fact that their item ops
don't have iop_unpin and iop_push methods.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_trans.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ca18a040336a..0d5d5a53fa5a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -925,6 +925,13 @@ xfs_trans_commit(
 	return __xfs_trans_commit(tp, false);
 }
 
+/* Is this a log intent-done item? */
+static inline bool xlog_item_is_intent_done(struct xfs_log_item *lip)
+{
+	return lip->li_ops->iop_unpin == NULL &&
+	       lip->li_ops->iop_push == NULL;
+}
+
 /*
  * Unlock all of the transaction's items and free the transaction.
  * The transaction must not have modified any of its items, because
@@ -959,7 +966,7 @@ xfs_trans_cancel(
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
-			ASSERT(!(lip->li_type == XFS_LI_EFD));
+			ASSERT(!xlog_item_is_intent_done(lip));
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
-- 
2.20.0


Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA613C2BB85
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94838215A4
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fl1L0T8n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDKJNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42347 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgDKJNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id g6so2025081pgs.9
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V4DfzuVS0fgzy2zelwMiqMPJIYS3Fe8zeCRFMWceglM=;
        b=Fl1L0T8nVglfxrsYpuz8HKB1zfmUQxXwmgBIGupoyhDb032I5yrtXfKMC+xhlYoubb
         X2mn3X40HPPELGOGJnj6WwO+ElH9rVaki+SgoT7cgTivi2JbWowYNsVm42aAFOhIoZ6d
         GFTVjTdp14JemjahQCgmrxSeGxLqzoeVsxhc7nH9s2UmpY5M97v1GKCju24LmLuq+5Aq
         lWgVUOGgDOfZI2sbqdnRRymrLus4U1J/LC9RRL7F9skdb/8IcboisbGi0OlqitKCdfuq
         MMpJkXqL5214j1J2DPvcldwsNBelha0gYgK2y53o+vpzBsgc8jC7w73Gm3E3lEv6OYgs
         PCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V4DfzuVS0fgzy2zelwMiqMPJIYS3Fe8zeCRFMWceglM=;
        b=PD/srRbz2bNIgyi6UzX1TcURwfR7ADvd3k2RBdgFSu6dUauCXgM9t9FQbZcCzL7Rat
         pjgQL+AspvTNJ6oj23oYpbZ0Q1mQykehccSrOEyQq2HF05AW5iJvQAYmAWydqQVNF5Wf
         8WH7KmxvI6mp46CYA2Adm1D0G1SLWBcNo39zKUNfwbwcjfL8UzCBXKZ+oSfdpcBe5I3v
         ZjtGbNEpushRuJ0/zYY61Xf33/sng/+0T+QDYhsTLcUiuUUX67HuJeJEVFszmYyvMGhM
         bRXKQ0tOo7ZvSL7bTkRR0vLQnsoplrnw/bRmEj5LlwUD7e+nwGVqNA0jhCG6S3XXmZpS
         dMTQ==
X-Gm-Message-State: AGi0PuYsN5tFE0fuNOx/ILzOJ4wSsKs8XbpKyPx/z7MXi5xhTEaHyLfj
        VrjZe5GHBACf8rf2+w/9ljZob/Y=
X-Google-Smtp-Source: APiQypJdv3EpYPu4/PBMpUF4+uXRV02iT7rF1WRwx+/Iu6KrMHJmxWErwbz4V3qnnAUW/mp3MwgY/A==
X-Received: by 2002:a62:1757:: with SMTP id 84mr8744019pfx.107.1586596390920;
        Sat, 11 Apr 2020 02:13:10 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:10 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 5/6] xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
Date:   Sat, 11 Apr 2020 17:12:57 +0800
Message-Id: <1586596378-10754-6-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The check XFS_IS_QUOTA_RUNNING() has been done when enter the
xfs_qm_vop_create_dqattach() function, it will return directly
if the result is false, so the followed XFS_IS_QUOTA_RUNNING()
assertion is unnecessary. If we truly care about this, the check
also can be added to the condition of next if statements.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b684b0410a52..fc93f88a9926 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1932,7 +1932,6 @@ xfs_qm_vop_create_dqattach(
 		return;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-- 
2.20.0


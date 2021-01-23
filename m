Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4F2C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3E8522D50
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbhAWSx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbhAWSxw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CD022B2D;
        Sat, 23 Jan 2021 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427992;
        bh=U+3bxvLvgs8YQeLdF3soqzM86Y9sSA9/QaSop0LEidE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eS6GS/sLb5idT/PMqMst1HklXy/Q6zH2B5sZl53noE0XPI0p17+vd11wlxa8sZSU7
         AwIpkAOp5LdoVvT8shUgvSpVZSW86FLNjyr6DPloR9Is3BQuocA1Kpx/TT527NNWta
         0J92iOSoErNEvxx0U0TlFbaGvXwapo+G9lrHL1dEa8lEPYfKFOE0EDY/lOyCTD27uP
         uNKuP5m7Jiu3bOnG3jNjNXMjp+bYK01ondGrv58wUAYQUpgbhcUne+x/E2yc16CSvu
         QIIwlgkETA6sMfTmsLfmbN6QMzCQouqqYNsQJCSPDGTxt4lIy92HjBrPqj5yLQ/Wgl
         LYGLJiM98nBrg==
Subject: [PATCH 2/3] xfs: use unbounded workqueues for parallel work
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:14 -0800
Message-ID: <161142799399.2173328.8759691345812968430.stgit@magnolia>
In-Reply-To: <161142798284.2173328.11591192629841647898.stgit@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Switch the pwork workqueue to unbounded, since the current user
(quotacheck) runs lengthy scans for each work item and we don't care
about dispatching the work on a warm cpu cache or anything like that.
Also set WQ_SYSFS so that we can monitor where the wq is running.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_pwork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index 33fe952cdaf8..704a1c2af90c 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -70,8 +70,8 @@ xfs_pwork_init(
 #endif
 	trace_xfs_pwork_init(mp, nr_threads, current->pid);
 
-	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
-			current->pid);
+	pctl->wq = alloc_workqueue("%s-%d", WQ_UNBOUND | WQ_SYSFS | WQ_FREEZABLE,
+			nr_threads, tag, current->pid);
 	if (!pctl->wq)
 		return -ENOMEM;
 	pctl->work_fn = work_fn;


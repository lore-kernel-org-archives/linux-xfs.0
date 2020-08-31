Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CD3C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 01:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE9B20782
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 01:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="Gb0KnAM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgHaBpc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgHaBp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 21:45:28 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47906C061573
        for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2020 18:45:28 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b14so4872705qkn.4
        for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2020 18:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QrYH2o5+zk1SiKRZEFr0mMh9hRmJ4dl12s+7gy3RUAg=;
        b=Gb0KnAM+8MBliwaxnEo8iwH9SMoPmVjIfwHxC37VhFYBan0v5M/7DWD4DBNrTj+HwK
         yeJVvgxnYChpyi0XANWADOOT+W2XUBoPON5Jl7XTlDk2gK8kzg5PDa03u+P2dgiZfhkP
         Bgh4mXNU7XW7TXRhD17l7pkyliv1alW5NzI1YZtWutwPMESZkMJzCGVO8CEhxg3IgjPX
         APVmDl9a6yVsdANx7Zh8/kBlMNjiVVLlTaOasGJyggpx3GWalCab0MA+gyZIjbx78Njk
         kHtEXLYeBq27KRU7YBUEcf3Tp8x91a6rbYa4fS+lZvm6Ep0kUUEtCcpHlDmsqIVE+7J0
         Ec/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QrYH2o5+zk1SiKRZEFr0mMh9hRmJ4dl12s+7gy3RUAg=;
        b=nolPwjHhe0W277bG5/W2WTDDzK28hmdp0g9LrvTUlWePPe4NNBvVHLH5cb4Yxf5lxW
         IlQGnYxUefoBtgoJcipVVsW0br/acD1Ga4659Hn3SOrf90J9Vz9dvzRauntwgCd9vJmy
         0ewP34g2TNPmkpLBwODvEAYGk6IcG7amnlbT774z5WhRFeJRkcC4/COrvrOPCyc9zRWh
         0ZoEbw2OjvinY/kVD6tHZk4LA2iGxpKTNKLAIwj1xTZsWI79lh2YhXDaZsUsuPUTeBGK
         R6TzH0T2r1VZQzthiT3x5r1ffLmQc9KzJDVzAZPUfiBQmFF5fKpHMaTs8QRZV8pgrSyD
         a3hA==
X-Gm-Message-State: AOAM533OPNQ7mX+nTrpobhJDPmNg5rQupwScz65YIzKaxRmspxSUY20p
        pi6mza/SRH4k85qcunPg8VCBqA==
X-Google-Smtp-Source: ABdhPJyglYhJj24S8A7qK0NRCN5Xu+fvhONpZgpIDu1pcxI/eYXkv9ub6eIp7mcebiX3zfPyaA0m4A==
X-Received: by 2002:a37:8601:: with SMTP id i1mr9250267qkd.307.1598838327422;
        Sun, 30 Aug 2020 18:45:27 -0700 (PDT)
Received: from localhost.localdomain.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id e63sm7656466qkf.29.2020.08.30.18.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 18:45:26 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     darrick.wong@oracle.com
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH v2] iomap: Fix WARN_ON_ONCE() from unprivileged users
Date:   Sun, 30 Aug 2020 21:45:11 -0400
Message-Id: <20200831014511.17174-1-cai@lca.pw>
X-Mailer: git-send-email 2.18.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It is trivial to trigger a WARN_ON_ONCE(1) in iomap_dio_actor() by
unprivileged users which would taint the kernel, or worse - panic if
panic_on_warn or panic_on_taint is set. Hence, just convert it to
pr_warn_ratelimited() to let users know their workloads are racing.
Thanks Dave Chinner for the initial analysis of the racing reproducers.

Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: Record the path, pid and command as well.

 fs/iomap/direct-io.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c1aafb2ab990..66a4502ef675 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -374,6 +374,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap, struct iomap *srcmap)
 {
 	struct iomap_dio *dio = data;
+	char pathname[128], *path;
 
 	switch (iomap->type) {
 	case IOMAP_HOLE:
@@ -389,7 +390,21 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	case IOMAP_INLINE:
 		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
 	default:
-		WARN_ON_ONCE(1);
+		/*
+		 * DIO is not serialised against mmap() access at all, and so
+		 * if the page_mkwrite occurs between the writeback and the
+		 * iomap_apply() call in the DIO path, then it will see the
+		 * DELALLOC block that the page-mkwrite allocated.
+		 */
+		path = file_path(dio->iocb->ki_filp, pathname,
+				 sizeof(pathname));
+		if (IS_ERR(path))
+			path = "(unknown)";
+
+		pr_warn_ratelimited("page_mkwrite() is racing with DIO read (iomap->type = %u).\n"
+				    "File: %s PID: %d Comm: %.20s\n",
+				    iomap->type, path, current->pid,
+				    current->comm);
 		return -EIO;
 	}
 }
-- 
2.18.4


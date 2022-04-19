Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381BBC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 15:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349390AbiDSPjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 11:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiDSPju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 11:39:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EC418E1A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 08:37:07 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r83so4247759pgr.2
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=APgyschSxswol7fUxJP+u4t13474sp5ukpCU2Y5vHS4=;
        b=cJzpaf3mk3QXmVbrT+0YCqx6RXo9Vx/wFQUSExkn15kN4Jxu9ERsGHhaqgcfaPbmFi
         wJD+Ymots6OO0xMfQpfH6OZDfXpLsYd4ubbqWBJ8m9JivedCxB1M9fMKEEUv6/yu2WZg
         3wI1NQqzg+b9NO3p91jHP6UibsX9l0pUO73aqta+mo2jglgBn/XAuPPLie8nznW7CDF4
         0owwYwsrWafTBUmuCaie22QZVHqeD+KpkQILgWb8KWh2HsA4EWwPAZYFZsLFMe/Bbhqq
         1ylH4OewRzo5Po+dpACds/MVAWze1iycoaauOBD+jLA1zAEfV53zVr5y9KJ9AjzV1pA9
         ZZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=APgyschSxswol7fUxJP+u4t13474sp5ukpCU2Y5vHS4=;
        b=gW1nquSxklDbFQ7NColvCnFiz1sGmuMADtNWQmeO11JO1qVX9whi/TerS1pyNnPFp4
         1jf8yd3hMxXf3lLLdDPOORTQ8QX1ZozhwipzssF03JalzJR1DmlbKY+9z7dGZbpR4uSF
         95joDzjAE6yrP/laLDHoFoEldgIbJA7Xb+MuX1zFNjWf0e7nEb0U92AO594h/9AqSGml
         eYwtOD9pU2Y6rdhiH99JYjy6TaVPH5svh8xGv9GoOpDdZv6hTlRNKfBVoS+unBE75CSP
         SvqnJnwE2Kns8VQZB3GbvfaFlTm1d+vTii2A8QEbMBoKiq8wKLFoPEIFKo7G2IdnqVGQ
         jKIQ==
X-Gm-Message-State: AOAM530GgiYNozGUsTLFMQqZSMNZxL855BU9hlN0hY2SM1osklKF8a/I
        qZ4XlURhORy51Ai3nPK8r+Z04w67vCX+
X-Google-Smtp-Source: ABdhPJz2OXvVRaSpYhJFn7iZiD1IBKKdTPivDf+kI6SZfbI8OTiwGpNzzuTbHIKz37M4I7bYIisIag==
X-Received: by 2002:a63:3309:0:b0:398:1bfd:21fd with SMTP id z9-20020a633309000000b003981bfd21fdmr14895055pgz.598.1650382626857;
        Tue, 19 Apr 2022 08:37:06 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id s13-20020aa78d4d000000b0050ab610d9fcsm844303pfe.33.2022.04.19.08.37.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Apr 2022 08:37:06 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: simplify the local variables assignment
Date:   Tue, 19 Apr 2022 23:36:46 +0800
Message-Id: <1650382606-22553-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Get the struct inode pointer from iocb->ki_filp->f_mapping->host directly
and the other variables are unnecessary, so simplify the local variables
assignment.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_file.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..691e98fe4eee 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -694,9 +694,7 @@ xfs_file_buffered_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	bool			cleared_space = false;
@@ -767,9 +765,7 @@ xfs_file_write_iter(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	size_t			ocount = iov_iter_count(from);
-- 
2.27.0


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C6DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 06:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C9D611CB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 06:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhKDG1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 02:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhKDG1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 02:27:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E04C061714;
        Wed,  3 Nov 2021 23:24:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 127so4880387pfu.1;
        Wed, 03 Nov 2021 23:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GczOOZ819CBVgyrUgEiQpSFxZ9oaI7CSNNwrM6gcDi4=;
        b=Hu35XFzFsKri1uUtqJXkVeckJpsGM+72fM9nRGmwsmGKva2zZiiphwLe4A9jZ+8JtD
         Kw1zFBfRAPLGrBT+z0EXyEZnEFJjfOjig1FEAfUTMQpNjzgFp4EIFD+zEbsPiEhMTOFb
         JdcrER+e7ACeY4Bvx25gGPy/ncmt1vVnYGX4cPeFK7uY3TFv0z56krh0NkPdygBcjFpr
         NKtSJbz/6sWCN0a1NkDg6/cuYc6xgPPo+Jh7fwRPYPBRka1V51GNCVDLQHEq0zVyv8n0
         yyRcj+R/FYrPKKAQHXvUqRKXMoYB20tThH80cM1JIK2EAS8oRM78+6ARrSP//HG/Aagc
         1KRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GczOOZ819CBVgyrUgEiQpSFxZ9oaI7CSNNwrM6gcDi4=;
        b=MCM1ezX5PLcyxpByBdgeCRMr+MieUk7F9NKb+Y4hOo2VXAhge15efId8H7rPZe/NgW
         X6r27NTMbeKjRiv9zW/HU6hpPtWScmqlH4eJXLl8aVZY1uaeNEczJUJxn2MvOaVINHJ8
         LAfUi+qILvLvPwSWJzdWe7071NHs9enN7H/x2YiMqlKPjru9fRLWhERG/y6S5eySY/s/
         leQb784CR/4x7G0/cqr8wxq2YnkNJR8AqEsTgNl1Zm9I6tw/G4wKSRfTlfBS6kXDbd6g
         bk9oVNtJloZLrn0zpmLL8NfURvGUr0a4uJNkZW8bSBP0tN2cu7XH8fs6eSey8oA73TJM
         hfIw==
X-Gm-Message-State: AOAM530BOUVZCPWEzP1WCpgaWWyR1MuzzHut0PXvYky6SG2Fzi5LSg4k
        CGxLQ/k0xIqsZCWFA54gyQU=
X-Google-Smtp-Source: ABdhPJx2kCDWjn3aW8xNGJEIMKL7cFbznv7TIOcrXCtTgu4rDAqzfybLYZNq4KC75JGG5WTFZNuvRQ==
X-Received: by 2002:a05:6a00:a02:b0:47b:f59a:2c80 with SMTP id p2-20020a056a000a0200b0047bf59a2c80mr49662649pfh.41.1636007078227;
        Wed, 03 Nov 2021 23:24:38 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id h12sm3861462pfh.75.2021.11.03.23.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:24:38 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     djwong@kernel.org
Cc:     davidcomponentone@gmail.com, linux-xfs@vger.kernel.org,
        dchinner@redhat.com, chandan.babu@oracle.com,
        gustavoars@kernel.org, yang.guang5@zte.com.cn,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] xfs: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:24:27 +0800
Message-Id: <20211104062427.1506328-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 fs/xfs/libxfs/xfs_da_btree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index dd7a2dbce1d1..9dc1ecb9713d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -864,7 +864,6 @@ xfs_da3_node_rebalance(
 {
 	struct xfs_da_intnode	*node1;
 	struct xfs_da_intnode	*node2;
-	struct xfs_da_intnode	*tmpnode;
 	struct xfs_da_node_entry *btree1;
 	struct xfs_da_node_entry *btree2;
 	struct xfs_da_node_entry *btree_s;
@@ -894,9 +893,7 @@ xfs_da3_node_rebalance(
 	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
 	     (be32_to_cpu(btree2[nodehdr2.count - 1].hashval) <
 			be32_to_cpu(btree1[nodehdr1.count - 1].hashval)))) {
-		tmpnode = node1;
-		node1 = node2;
-		node2 = tmpnode;
+		swap(node1, node2);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
 		btree1 = nodehdr1.btree;
-- 
2.30.2


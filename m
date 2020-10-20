Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B78DC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 04:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BFD422259
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 04:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDfWevW7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391538AbgJTE4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 00:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391508AbgJTE4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Oct 2020 00:56:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D66C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 21:56:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 10so477121pfp.5
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 21:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HcB7NwqtVzqguDqEFThfhIj7NXZH243zHS+BEXA72Us=;
        b=YDfWevW7wXjDu2oALf8TE4+f6+gEq5lWxXUDNAKluQpN0QxaWfPCFchxzA81/2TfBi
         95kDXfbJYZEYlb38dLshCegJgb4jSmgZhrkmIBFfPLwuLMtOIyOJZy8HdfrMmrf2MKWo
         q86HDCwGawNYh9jm6YFgYhg7QECpfctwon1mpLrF5Z6Kv2VpzFdY6uEhZwX6Jn0ASKLd
         4civ+fW2DAmOQOlsCyKW0IPqamy6I7SMPfGW2/tcy/5OyePMXoOnDdUs58Mx41Vi0kmD
         4YnKLwVINK0WL/yPFAbmQx7owmQRJ2B6hS2fL7x4ITxpf1WguYevic6LlEsivYMFY50R
         InfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HcB7NwqtVzqguDqEFThfhIj7NXZH243zHS+BEXA72Us=;
        b=jgO5eVvbRrhQgbPOjKo3K5Vz2dzAHzUrRWqp5KJa/k8zHRm7MUhP35oYHnwy20kfh4
         oh+pcS2IjY/QL2HHi+K26XuIEyxnmvfVJ6TWFK5loisnIhbTGt7E8RHWOYUsqkouzzKM
         a8V3POzZzmHrzDoZNFWwzolzq9ty059+GOFeiOjYi34KgCDExg/R8AupuGJzKIgwAVyh
         FJHzCY2HAGb06nIz9qb47jgmXFW4AXXxffg6i+/hzZwgp9DMP0PmDQZOrjPtbBWYR0SB
         kacdE2+7yysRYeBMWQ2vkSV+9Mn5nH22TYOCvm6TX7odxVmYRCiqwCDdDhytqCQQ0FSG
         WW0A==
X-Gm-Message-State: AOAM530iVSGqeYJcVKpdwy2ojS/lZGDDDoFK8zMctFZQtrovW7kSKzEx
        3ddQcixzQ9/4JYagO3FSs3FkqB1l55Ue
X-Google-Smtp-Source: ABdhPJxfqxyZ3FLRQLVTlL8KfZNNX8iDQ+QPY/0kdI7I751yYSlO31T8LUPYedIlJc9DNUSx/TJ5jQ==
X-Received: by 2002:aa7:83c9:0:b029:158:11ce:4672 with SMTP id j9-20020aa783c90000b029015811ce4672mr1027116pfn.23.1603169773622;
        Mon, 19 Oct 2020 21:56:13 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id p62sm594963pfb.180.2020.10.19.21.56.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 21:56:12 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the unused XFS_B_FSB_OFFSET macro
Date:   Tue, 20 Oct 2020 12:54:26 +0800
Message-Id: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are no callers of the XFS_B_FSB_OFFSET macro, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd764da08f6f..40b6fa3b4e01 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -625,7 +625,6 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 #define XFS_B_TO_FSB(mp,b)	\
 	((((uint64_t)(b)) + (mp)->m_blockmask) >> (mp)->m_sb.sb_blocklog)
 #define XFS_B_TO_FSBT(mp,b)	(((uint64_t)(b)) >> (mp)->m_sb.sb_blocklog)
-#define XFS_B_FSB_OFFSET(mp,b)	((b) & (mp)->m_blockmask)
 
 /*
  * Allocation group header
-- 
2.20.0


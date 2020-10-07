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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39379C41604
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE06420679
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qs/oS6cL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgJGOvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AE3C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c6so1115140plr.9
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wMt/hpHOCRUpfsxwePuxcEQIo9I+1fhSaWgX+ckR4+0=;
        b=qs/oS6cLMon0u5gey7gWKyvnGHrcLgMRNRiR09Txokiasa21+4ceyR04pyM1Snh19n
         V+hwK0REKjswR1fI5Za0aXPxUyGYLWqt/v+ILIxK9DyX4pVMEzmH89/wv9G0gYp33/NW
         XkSvnoz5r3b6bxDZ9rFAoMKtJmRbqPUks54GZkaob6eFeoKesrPwRxLkm1nMJuL8BRyg
         L55AAFrw/+xC8qhvag6JxyNGRylwbPWcahjngCuFaI7jK/3xiFy/tH/8iQnWlA3ghtHH
         jVBtx/eI5AIH7YdzlFpno7tirnpNkq3QY7yDeVkbUgExKH12op0QCTOJhE1tBnSFufan
         WPBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wMt/hpHOCRUpfsxwePuxcEQIo9I+1fhSaWgX+ckR4+0=;
        b=UFbXoRLFRJKBVf85yPmPPOo87jbg+D560295kfEBGURvr3nBsNER6s7Q/TRBNtROCA
         NedGAoOKxqDm+qrE3ibotjlApNdsIbOX6Yer5o9ykOQi3NsTeHUur354rPrsMVIDA6H3
         4SGbPZ9+zNthZrw5m4t3BARlI62mM2YQGJJKUlsP2yU6//5ObseNIuYiOaU3RHBVURCn
         xNZZBi5x0SdJxHMbPFhlGj1IDqZ6n3qPz8fMKrJiiyiVf+V5GEoMoPBu7QAHGETPHccr
         FJxZsVLEn4nrpgwAy+UISvbh/DyiJm/o9cIiRdztCqvnA/rt16NCaoLR8uAU+kwAvhGc
         nRxA==
X-Gm-Message-State: AOAM533iokENfjzaJx1EcZGtRb55jLXGsZkhFRi//4C0d0mktDRUgav8
        Z+8qroXRdQZLhpHPfhpBYxEO4e8MrRXe
X-Google-Smtp-Source: ABdhPJzRw96b2OxFwquH4sPwPI9ibX430hpXh2U5kVmZWu1SG4+HKCy9MLDh5069UBI1G90x0ty0rw==
X-Received: by 2002:a17:90a:5d94:: with SMTP id t20mr3238947pji.20.1602082284271;
        Wed, 07 Oct 2020 07:51:24 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:23 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 3/5] xfs: delete duplicated tp->t_dqinfo null check and allocation
Date:   Wed,  7 Oct 2020 22:51:10 +0800
Message-Id: <1602082272-20242-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()
to account for quotas, both of them do the null check and allocation. Thus
we can delete the duplicated operation in xfs_trans_mod_dquot_byino().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_trans_dquot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fe45b0c3970c..1b56065c9ff1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
-	if (tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
-- 
2.20.0


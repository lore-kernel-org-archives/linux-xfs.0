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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1991C43467
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5947B207F7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLXV8UpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394241AbgJPDig (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394231AbgJPDig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 23:38:36 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D39C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p21so619089pju.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PX3Xc43cx5GvGaV/aLV3nIIw7ax9KsDPACo6mBmDLpo=;
        b=gLXV8UpUuZKhqzzUxxl9HZr3Hhapz90qv9m0oISQd+DQQYlL0EoaC42+mj1pTUImOX
         1hJOt3VvI1l4s7A0QfKNncgU3oSinjpnq36sf0NrqE+oCtQNisJ30LUKTZma3onvPN6T
         z5ZWMwRhT8ZWTfepV1jKtJ67K0Rm2kzsvNstxmSiCVg84zBZoGNlVBAFy6oZmg67yCqc
         gwiKrDzutKcdhFxKeft11IyoOhKatAskCLfzcnElQIIxhNfK4+SW0RAm84Oey40mxlnU
         0cJ98AOq4m2glcSoixqFX4htGXpQY74mYnX8SoY+xwsJaPVM+4DASTiugVAw9ReKnq0z
         GeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PX3Xc43cx5GvGaV/aLV3nIIw7ax9KsDPACo6mBmDLpo=;
        b=Pk2d26jUE4A4zsHWa27IR1h7Sa2IvnotDGOcoPN3rASVG8iItVC9Vk45Jw7cRrNNjo
         Pds6vfwthJtJqEkRgr0bxV3AMrDpbm1AS5sTMACVBSrUg8IytCIbyurEUGfiU58y/fD7
         KWLm9IC+aRDubS1ylguu8UIBB5PhA8IUaqOj3Pt1dN6p3sJaI2xjtloDIHBr1jeMtbQO
         kY0W1cO3AP/ADj2wUga4K4YuPOyJe9jZst+uG6x2donYQo1Oz6s+bI+hPx3gUKdyBl2l
         muLqdj/pu/ajDbxs0/jzHQhCuPUnt8zcc9rNysNyZWLeXvr24TIciBq3sHE791K3S4pD
         B0MQ==
X-Gm-Message-State: AOAM530zBRSt5+Fusy0KkrXE5mgc74poLadRfc3xOQKN7ovScaeTqMDe
        bTAfi/XoCfPEVk7zJH6KcUfiABXPTg==
X-Google-Smtp-Source: ABdhPJyvk75WwFQqxnb/grefiie+e830XOdbE13BsaAolAhxP9LhcXOjvcdGel4Acmp2+Zp0MmMzAw==
X-Received: by 2002:a17:902:724b:b029:d5:a5e2:51c4 with SMTP id c11-20020a170902724bb02900d5a5e251c4mr1992959pll.80.1602819515581;
        Thu, 15 Oct 2020 20:38:35 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o15sm890238pfp.91.2020.10.15.20.38.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 20:38:34 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v6 1/3] xfs: delete duplicated tp->t_dqinfo null check and allocation
Date:   Fri, 16 Oct 2020 11:38:26 +0800
Message-Id: <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The function xfs_trans_mod_dquot_byino() wraps around
xfs_trans_mod_dquot() to account for quotas, and also there is the
function call chain xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv
-> xfs_trans_mod_dquot, both of them do the duplicated null check and
allocation. Thus we can delete the duplicated operation from them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_dquot.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fe45b0c3970c..67f1e275b34d 100644
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
@@ -698,7 +695,6 @@ xfs_trans_dqresv(
 	 * because we don't have the luxury of a transaction envelope then.
 	 */
 	if (tp) {
-		ASSERT(tp->t_dqinfo);
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 		if (nblks != 0)
 			xfs_trans_mod_dquot(tp, dqp,
@@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	if (tp && tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-- 
2.20.0


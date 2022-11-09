Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331DDC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKICFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKICFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC55154B21
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B90B81CC4
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2330FC433C1;
        Wed,  9 Nov 2022 02:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959506;
        bh=5wELwkrenZ1QejEt5qlI8r5xhdtMsI1RjqDiBqqYThY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tzIUSjlMTmUAbcULbTnS8RFAFiwBS+O817pRSnt1ujMVNYaimk1ghb+Ee8FVvqHGO
         CaIp+Y6f0nSwMcy9M7+O3qtXP92LlEBPjbaUucSbQsKZykyz2gG4vdq59QLRnSz+PA
         vx+3pd+XNIHEkBjKXON9x/NV0YcYIE91D6d9pGy5WGeATjdcthOqF46w/ISZ0jSlNC
         XiMY7hAJulaMyKMgeoEdgsQzcMBkSLhQz3iWTz6JK25gXsbZJ6wmjKByJtMSCe8L6Q
         UfVTqD/55wJtQezqUB7d6mHxHneAK3fUpESkHYHsP0elRelj2Of92anUaL/ma4RyxS
         1YWEyJMjyF2gw==
Subject: [PATCH 1/7] libxfs: consume the xfs_warn mountpoint argument
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:05 -0800
Message-ID: <166795950574.3761353.17233762564000800072.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix these warnings because xfs_warn doesn't do anything in userspace:

xfs_alloc.c: In function ‘xfs_alloc_get_rec’:
xfs_alloc.c:246:34: warning: unused variable ‘mp’ [-Wunused-variable]
  246 |         struct xfs_mount        *mp = cur->bc_mp;
      |                                  ^~

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ad920cd9b6..b2c3f694b0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -125,7 +125,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define xfs_info(mp,fmt,args...)	cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
-#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
+#define xfs_warn(mp,fmt,args...)	cmn_err((mp) ? CE_WARN : CE_WARN, _(fmt), ## args)
 #define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
 #define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
 


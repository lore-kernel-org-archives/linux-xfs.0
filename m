Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B099C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiKWRJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbiKWRJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC6D59165
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12BD7B821BD
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C063AC433D7;
        Wed, 23 Nov 2022 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223340;
        bh=U4ieHGKygnK1z78Bj35y4xBKtb4VWdommV5vatijyWE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ff0EPrIi58jgjJW4dpgvo5iYSrtlZlevia9tuDNFIH+Uk2/wUssVX/mNVVE3jpK67
         MinPND/ITbBPYoZDzvFcZE83RlJRPdXHs4f04z70dTWJFkXr8PYDXL7TdGkit/+HPE
         LK2/ZltDJdaqa6A6d+7GqYtFY9rU8xjW5o0+6GBtDbpgQp4hBwVRP9YmvtaqPnXO8o
         R0jn0USpUoHxa66JptbPBMhcBJ+uzEiBc06G0+td0YXI7vc2fHEF+RWzzPpycpseme
         FZxBbtM2TR/kn8IRXDpqUb0i3N6qyTO+b9WHa1PFPi6fMKWe+QdEYdWbCGc6Li32Go
         qqIZH1HaHPVXA==
Subject: [PATCH 1/9] libxfs: consume the xfs_warn mountpoint argument
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:00 -0800
Message-ID: <166922334040.1572664.6558090785236386982.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
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
index 883b22948bb..ad4b9475832 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -125,7 +125,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define xfs_info(mp,fmt,args...)	cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
-#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
+#define xfs_warn(mp,fmt,args...)	cmn_err((mp) ? CE_WARN : CE_WARN, _(fmt), ## args)
 #define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
 #define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
 


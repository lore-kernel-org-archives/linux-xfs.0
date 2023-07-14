Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44489EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbjGNOp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbjGNOpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1259B10FA
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7679661D42
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9688C433C7;
        Fri, 14 Jul 2023 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345922;
        bh=nKRd9q6jo/GDnTKZIOTHDyXYs8JqzUSf2jEvdKDk2HU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lzXv55mD+R9LatiV6YKl8M0KWpffogFJH9quKmnft+95JHu/D4BsAs/e1jBibqlHT
         PhoBajFmTMIFKcnlUb7cZZF6/BLOvl/mtPS/RokgCu3y6hdvt0QY17YSxdi7euylZn
         rbBU2p/jEjTO5OWXc2WF6eHgS+scRKc6gHBCHA3kTjSUsDdRfwZkNLVSUoZU2JkF+I
         QPzyo2c23MiKRPOEoNQcAJHLcW0LttHuVm4rZwFiEa2TcOAbt5TvyZTy9eI4IBItr4
         41zuQk4HmANJjkgCiWSXc97EPBlCVZETy0hOkGDEuWcxFuc4ehTLjMGYZSii5fSwpf
         sWjsNXAuPfGYg==
Subject: [PATCH 3/3] xfs: convert flex-array declarations in xfs attr
 shortform objects
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, keescook@chromium.org,
        david@fromorbit.com
Date:   Fri, 14 Jul 2023 07:45:22 -0700
Message-ID: <168934592239.3368057.13821438121542148084.stgit@frogsfrogsfrogs>
In-Reply-To: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 980f90c04e1b0fcbc4ccfb1009a724f38adced7d

As of 6.5-rc1, UBSAN trips over the ondisk extended attribute shortform
definitions using an array length of 1 to pretend to be a flex array.
Kernel compilers have to support unbounded array declarations, so let's
correct this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index b2362717..f9015f88 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -591,7 +591,7 @@ struct xfs_attr_shortform {
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
 		uint8_t nameval[];	/* name & value bytes concatenated */
-	} list[1];			/* variable sized array */
+	} list[];			/* variable sized array */
 };
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */


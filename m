Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6EAC27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbjKVXHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjKVXHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623210E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BC1C433C8;
        Wed, 22 Nov 2023 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694454;
        bh=aAp0AbYIFA+/PzGVeGViTbwLLCKcorrwEymJ3KNHfOI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pRzA86+EJEzP5RDjM8QIuUgg0o5Md6Toxt0MqrIFtNC4TQGH7+p37DVmMpAQLAe71
         wWBT/s+cIKk/qOGE93Ffn2pf8EWNS4zWrC3u5ZKNWO8520WZe+Dh8c155i2nZn1oJ6
         zbntZ0hz9QyCHc4+TGZRXg8o9a/RMr9C/6K6l0X30an4r8KcKLD5LBw54Blyo+9B4C
         /gpU0O9/OJxTIbqWt/we/QBwdn7gP3JZ3GzUSxDzBw3XJZf4wMvOxHGC9GaR3Hw+3a
         SulPeC1nllkAzI81CDPMfw5IzKOQCnGUUL15t+ABl3zjI6QH4XwaRwS1UNiyiipQBA
         EKSfHROtDQJew==
Subject: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value,
 not incompat
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:33 -0800
Message-ID: <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix this check to look at the correct header field.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 3190e07e478..3f761e8fe8d 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -268,8 +268,6 @@ read_header_v2(
 	union mdrestore_headers		*h,
 	FILE				*md_fp)
 {
-	bool				want_external_log;
-
 	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
 			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
@@ -280,10 +278,8 @@ read_header_v2(
 	if (h->v2.xmh_reserved != 0)
 		fatal("Metadump header's reserved field has a non-zero value\n");
 
-	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
-			XFS_MD2_COMPAT_EXTERNALLOG);
-
-	if (want_external_log && !mdrestore.external_log)
+	if ((h->v2.xmh_compat_flags & cpu_to_be32(XFS_MD2_COMPAT_EXTERNALLOG)) &&
+	    !mdrestore.external_log)
 		fatal("External Log device is required\n");
 }
 


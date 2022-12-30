Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80648C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiLaC7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:59:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D7F1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7372361CDB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49E2C433EF;
        Sat, 31 Dec 2022 02:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455545;
        bh=HSxgLWzobheimB3609hTVVywpvCXFErbtutQo4e8XGw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qLSNpcyY7tKzbd3PuMnL61M3S8SPbJO1TUJmk45e37ZqOpcIq7TbZM9Kr9P6IF3xS
         9WhqUBzCerQGrqneO0KwYHjRkULp/4ajv0DGBMd3J5CVJaUrKoCn/UDwesh8nG2vVG
         Bdp/bF3hCbkyMhnVpie2XaJHTzUCqTyCJqvUaFoeLxZuS7nfSTkxdZDsBLm07w7uaL
         I34sNjcUKiMPea6Pw7RVH6Q7z/dpG+bLsGH/19cANpGsLznu3dWyNY5pYVWYDhIsLx
         8ZHUZZvn8fSTd1PzTIWOTEChWPZM+5hALOrbnIBlULcBymDqRENlDwb8oBulvSlovP
         w0qIckyEAXaYw==
Subject: [PATCH 19/41] xfs: enable extent size hints for CoW operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881021.734096.3753794982837556934.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 16f0683caef..d5842e3b4f6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6444,7 +6444,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001F7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4AAC610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhINCoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237467AbhINCoL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC13610D1;
        Tue, 14 Sep 2021 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587375;
        bh=is7hlzPg2R/JLjf9gGbteOjAmHUdXJ4U2IZQ+GBlCIs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jk5w0DzxK7uDL7hH+FxXQZxmFiMs/qbsioE69HjAIcC1C4/kXuB1sRisxv7eYSvJD
         +SQt9stTRDBj5TPzMUIEoR2S4o8vawUrS61NOoSHbwrRzX2W1C8xBitRk8IVjDHaE/
         ygKYFoRSB7slXqJ76vG10OOXElLBdkatQeX/2FJH8/xs+Z3MY0vfn+ppXUE20lkce3
         tZhQdILtjcXcGVpixO1OamJmfMkTNi/5ILptuHcERwGZ+UYBJ2N/SARu1gHcsOumBQ
         TUN9HsdzCG85wVDh1L9aBHk+IUhcFDNdDEFdmDZF5NMDL8yH3tYZ1pEot62Q6YD20c
         H3v4kV2KjC46A==
Subject: [PATCH 32/43] libxfs: replace xfs_sb_version checks with feature flag
 checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:54 -0700
Message-ID: <163158737492.1604118.6745890320211128923.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index e7009a2e..593d0fa2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -424,17 +424,17 @@ rtmount_init(
 	xfs_daddr_t	d;	/* address of last block of subvolume */
 	int		error;
 
-	if (mp->m_sb.sb_rblocks == 0)
+	if (!xfs_has_realtime(mp))
 		return 0;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		fprintf(stderr,
 	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		fprintf(stderr,
 	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F5EC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiGSVo7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiGSVo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:44:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F89B50716
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C22EB81D1A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 21:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249EAC341C6;
        Tue, 19 Jul 2022 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658267095;
        bh=dxdOXYPyEGQ8HZVSyjiLQiwsgoBJX0VYmhRpZTq48IM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YjOPyLSmgDx+OoxGRzKZapgbPQ+YyyHwBDrMnt9njzdQDo/mNaG29Zt1lBOJuLIuK
         FBz18g2vo22Eky3P6wj5PGWzsYxDnFlabWHKMjbh4l6t7R8lmuYHDdb51zbHoAyiPl
         VZpEuvYlWxiyyCpdcflFxQ+RDG00y9mHUl28TUkpguSVj4ot3OMzv9if+9cr/+R9SA
         EtJdR8vovis0pp8Y5+dpCDz9PKMiBsFgKIlOC57TboNfr+BBWlqsuLPwXKJVfQ1RYE
         JGBMoTNpPXm9/Zl2sa4MxFhdWKE9AsYD5wPvivbVILQaPXNJNSXeLwpeWi/8ns8mEa
         107cvQo4OyHUQ==
Subject: [PATCH 1/1] mkfs: complain about impossible log size constraints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Jul 2022 14:44:54 -0700
Message-ID: <165826709473.3268805.14134746462173901488.stgit@magnolia>
In-Reply-To: <165826708900.3268805.5228849676662461141.stgit@magnolia>
References: <165826708900.3268805.5228849676662461141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/042 trips over an impossible fs geometry when nrext64 is enabled.
The minimum log size calculation comes out to 4287 blocks, but the mkfs
parameters specify an AG size of 4096 blocks.  This eventually causes
mkfs to complain that the autoselected log size doesn't meet the minimum
size, but we could be a little more explicit in pointing out that the
two size constraints make for an impossible geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b140b815..a5e2df76 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3413,6 +3413,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 	 * an AG.
 	 */
 	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
+	if (max_logblocks < min_logblocks) {
+		fprintf(stderr,
+_("max log size %d smaller than min log size %d, filesystem is too small\n"),
+				max_logblocks,
+				min_logblocks);
+		usage();
+	}
 
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {


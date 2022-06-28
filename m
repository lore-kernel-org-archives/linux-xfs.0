Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4E8C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiF1Uto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiF1Utm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0F330F77
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3D56184B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36086C341C8;
        Tue, 28 Jun 2022 20:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449377;
        bh=KNWN1gkWuWl8xPOhKtZlDwn5X3hBhe0Wlj54LjuH+MA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fyz31IxBcBkE2SbD4jAgewT6hI32ZDOa7tsRhIVgoUmpDmR9DYEnrscmCe5KcmtaA
         BuE9BVeWqF3kmD/+zaNH+H8CgmQNHR3Spk/sZzwgremftFNNVBjVTw4kwNsoKJHLfv
         UK0NKd1bIdNPeN1MRGWD0768SOHBQBzRiVL61TNMJtddHCx+JwUk6/AtuMUMfYdr7w
         0v15kFbd2GWsdnaGROujqgaiCc0XeeFRQwlP2dZYodwh+w0aLZMyBQhx+pG3Lr+91d
         TOmyqnnfFN/MHUIjsGCmmA/XtuqC5Wmb1y1jKOqIkL40WQarTDEYcOD6sfi8GIplak
         +MQPoT/TCovFA==
Subject: [PATCH 4/6] mkfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:36 -0700
Message-ID: <165644937684.1089996.8013011825931751515.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Preserve the state of the NREXT64 inode flag when we're changing the
other flags2 fields.  This is only vital for the kernel version of this
function, but we should keep these in sync.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index ef01fcf8..d2389198 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -198,7 +198,8 @@ xfs_flags2diflags2(
 {
 	uint64_t		di_flags2 =
 		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
-				   XFS_DIFLAG2_BIGTIME));
+				   XFS_DIFLAG2_BIGTIME |
+				   XFS_DIFLAG2_NREXT64));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;


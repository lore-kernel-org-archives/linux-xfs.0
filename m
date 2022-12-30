Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E29C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiL3XtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiL3XtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:49:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1721DF30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:49:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08AA260CF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C85FC433D2;
        Fri, 30 Dec 2022 23:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444162;
        bh=cqeQdpfji4OJa7IiuVo2izRI5CsJWad95IVg/FW7V0U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U0uXsdVjxsBHtvDkQQDyRCW9QhGWFw5mhEMINf+yMDrTqWhvU9gyy8Ailen96AapW
         ieTEJORTfvTU3yDg+wB2R0n7i75UXND+cxdU5A91rP6bguaj1cUXGS5E/XRfMthoBM
         AuoP6ldRa63xvxtHHIIIyJay7dtf+CHBrIVd3K/SDEPOvDE6g6ALKMU54TJqdNXvsU
         EZtJk8F9Ha4ADxyUoYXJ+7ECKEDaDAFmi8pFVgRXO2RiE27lKRslmzm25XkkHag6Jq
         aSbtl0uVpFQEtnC6v/B+ah0ge/Ns/9cZa2/NLoRy6d4b4Y73GOIXSKcAunap70dW2f
         66H5jCuUJbVuQ==
Subject: [PATCH 2/2] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:48 -0800
Message-ID: <167243842840.699248.16544369971115644598.stgit@magnolia>
In-Reply-To: <167243842809.699248.13762919270503755284.stgit@magnolia>
References: <167243842809.699248.13762919270503755284.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ecead1feabe5..7433e1ecdabb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6255,6 +6255,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);


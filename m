Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AECC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjEZAl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZAl6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE727EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A9C364BE0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BD4C433EF;
        Fri, 26 May 2023 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061717;
        bh=bEUWmBTdZQMKQT7W0583Apci9KJSbCIs8PXmCQzd068=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cRIKfkl6OqeF0GSxIL9LxBoBJt36KRsr+xPpJEhEqWtO5Ok8ixl1rJSu0Ei0eLFhp
         h7HORukyfEAEa9CoAn1qDQBPE8atTgC+d0oKO1PeHC1VJojNNGozTf/2S/HsDwP4l3
         HFQ9lEERy1LnpuGEYQVUpXul6V/kCTxsPsl32OojiXrThnpmDMrsyw+SKb4Rx6Vq90
         pJAElKZkhSErjmZaPu12p9JAU2eAzID0X6VnYzFhYqdhBeBEOHrcW7OUtIoX7x1QQU
         YdS2iVEslhISPpBG5w0WO//sc2wJmz16CpVE23f6Sn2DVyQflNxm2aGa+0t/HrugcR
         g7LWhkC0vP2eg==
Date:   Thu, 25 May 2023 17:41:56 -0700
Subject: [PATCH 3/7] xfs: fix getfsmap reporting past the last rt extent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055240.3727958.10764251103410563406.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The realtime section ends at the last rt extent.  If the user configures
the rt geometry with an extent size that is not an integer factor of the
number of rt blocks, it's possible for there to be rt blocks past the
end of the last rt extent.  These tail blocks cannot ever be allocated
and will cause corruption reports if the last extent coincides with the
end of an rt bitmap block, so do not report consider them for the
GETFSMAP output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 901918116d3d..6bd6ab56ca9f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -529,7 +529,7 @@ __xfs_getfsmap_rtdev(
 	uint64_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rextents * mp->m_sb.sb_rextsize);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	start_rtb = XFS_BB_TO_FSBT(mp,


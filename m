Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE39C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiLaB5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiLaB5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:57:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0571C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B135B81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAE1C433D2;
        Sat, 31 Dec 2022 01:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451827;
        bh=der+2yVxVJpSIva0yR9JgMa+rs6Bq4oPOKBMQsYDAfg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sv0DETkE2Qrbbji5muh/JzPQK7piT9lGaiWTYbDv1sWUK0GN8SaZYarwJnMrbjJZL
         AGUibxSorKsbR1myOQMp2WSmwZweCYfsS+pqLxtj/+jivXYcY/jIQTTdBcjuHK5Iu7
         VduqwSy9BDiB3zLCmKO0EIlbRpAc7IcXdQ0ELF8SaCPY8G3d0A42Y7Ky9JLbQA/Xoi
         3qbc9U6NlBLGdbGzYLNAfIsjO8K34OjwJaLyTiZouIJX2AWOXe8DVBaG1S1dtBFU8O
         z8pRb6Xc3bD8SoADpgQzTBR2Rlp4ErXcIk+HhmnmLBgnSq8hXmQ1YoLYpLbrfL9QQ2
         b7mOH81XS8Zew==
Subject: [PATCH 35/42] xfs: don't flag quota rt block usage on rtreflink
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871393.717073.13834650298966488896.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quota space usage is allowed to exceed the size of the physical storage
when reflink is enabled.  Now that we have reflink for the realtime
volume, apply this same logic to the rtb repair logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index a150719c2b90..c79c47714eb6 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -101,7 +101,7 @@ xrep_quota_item(
 		rqi->need_quotacheck = true;
 		dirty = true;
 	}
-	if (dqp->q_rtb.count > mp->m_sb.sb_rblocks) {
+	if (!xfs_has_reflink(mp) && dqp->q_rtb.count > mp->m_sb.sb_rblocks) {
 		dqp->q_rtb.reserved -= dqp->q_rtb.count;
 		dqp->q_rtb.reserved += mp->m_sb.sb_rblocks;
 		dqp->q_rtb.count = mp->m_sb.sb_rblocks;


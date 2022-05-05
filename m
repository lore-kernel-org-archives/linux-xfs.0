Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA5DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379956AbiEEQJV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381637AbiEEQJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2547912AA1
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D612AB82DEF
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A982C385AC;
        Thu,  5 May 2022 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766737;
        bh=KYI1Ua1CMHGjaeeqmsERGl44XzMeX+Z0QM3fyJCmOho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=shF6hODLk8obG5iIT0wikc7KxfgSawxBLibqKADoBWM24sD5nDDEnZZO7pr2kOaM+
         Rl4bFH9v0u9/k8oP4dq3u8lN5PF0zto3eGXP+fb6/saWMMhBF4MDXUF2+vkO6ahoss
         mzVNfGjH5+R33r4RkXZ8RWuTKXSNyMMFG3ZLFEWJ1QLiMOmvN6lctn0U6l/sNygoqR
         Dry824iSz1axbNpFudNZhIh5JvqUr7JPJENMxO9WTmQkvTdESMd3P0y9gc9P1+u9by
         ZemzjTdN3NqAIsNRWK2DZo59s7m38QzbbUONFxrl9kQgFFdDFqq89T5taCAWtGB27x
         TBn4qJfmq50UQ==
Subject: [PATCH 5/6] mkfs: round log size down if rounding log start up causes
 overflow
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:36 -0700
Message-ID: <165176673695.248587.16584045364969444033.stgit@magnolia>
In-Reply-To: <165176670883.248587.2509972137741301804.stgit@magnolia>
References: <165176670883.248587.2509972137741301804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If rounding the log start up to the next stripe unit would cause the log
to overrun the end of the AG, round the log size down by a stripe unit.
We already ensured that logblocks was small enough to fit inside the AG,
so the minor adjustment should suffice.

This can be reproduced with:
mkfs.xfs -dsu=44k,sw=1,size=300m,file,name=fsfile -m rmapbt=0
and:
mkfs.xfs -dsu=48k,sw=1,size=512m,file,name=fsfile -m rmapbt=0

Reported-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b932acaa..01d2e8ca 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3234,6 +3234,15 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
 	/* round up/down the log size now */
 	align_log_size(cfg, sunit, max_logblocks);
 
+	/*
+	 * If the end of the log has been rounded past the end of the AG,
+	 * reduce logblocks by a stripe unit to try to get it back under EOAG.
+	 */
+	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks) &&
+	    cfg->logblocks > sunit) {
+		cfg->logblocks -= sunit;
+	}
+
 	/* check the aligned log still starts and ends in the same AG. */
 	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks)) {
 		fprintf(stderr,


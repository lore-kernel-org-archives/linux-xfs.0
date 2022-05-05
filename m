Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067FEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377858AbiEEQIC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381611AbiEEQIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D55C360
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 818D8B82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1C2C385A8;
        Thu,  5 May 2022 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766660;
        bh=1XkyS7x9F9T8euTGm1AUd7oZEsPB1tc1y02kWtSCtZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=unDGfaxTpOfBA9TFXSl8WMIVbKe4x2e4gbSl8YmFDAiacNbMpgOfu9TX9vW8cuN4M
         8D47IWCXitVQLU5SDZ4gyHZURgMKYMMTbmYoU7CFIv9ejbCfB0nyv3G3oGsig48Qto
         6zoTXk95M8ivqf/N/ytoEkQ1vnvTqtVpvc8IIJmizUv9ccCeSf830zojPMAbW+g3kk
         cJF2nTTq+E0neca5YxdLFoe+LQZSTHtizOdMf6g5uq4zKDBepTFIJ0Y3wN1/rX9V/x
         +YWdfN3zGbORasggqTidhrWQ4Fgt97zdD1BxAOllS7I0h317XmNFUtVvPEfkP5IYV2
         b6UGsLF4JC9Jw==
Subject: [PATCH 1/2] xfs_db: warn about suspicious finobt trees when
 metadumping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:19 -0700
Message-ID: <165176665975.246985.16711050246120025448.stgit@magnolia>
In-Reply-To: <165176665416.246985.13192803422215905607.stgit@magnolia>
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We warn about suspicious roots and btree heights before metadumping the
inode btree, so do the same for the free inode btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index c6f9d382..0d151bb8 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2664,6 +2664,21 @@ copy_inodes(
 		root = be32_to_cpu(agi->agi_free_root);
 		levels = be32_to_cpu(agi->agi_free_level);
 
+		if (root == 0 || root > mp->m_sb.sb_agblocks) {
+			if (show_warnings)
+				print_warning("invalid block number (%u) in "
+						"finobt root in agi %u", root,
+						agno);
+			return 1;
+		}
+
+		if (levels > M_IGEO(mp)->inobt_maxlevels) {
+			if (show_warnings)
+				print_warning("invalid level (%u) in finobt "
+						"root in agi %u", levels, agno);
+			return 1;
+		}
+
 		finobt = 1;
 		if (!scan_btree(agno, root, levels, TYP_FINOBT, &finobt,
 				scanfunc_ino))


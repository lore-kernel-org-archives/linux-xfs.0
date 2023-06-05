Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D46C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbjFEPga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjFEPg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841D511C
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA7D62734
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F0AC433D2;
        Mon,  5 Jun 2023 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979378;
        bh=KfnE33b0V3Vll71MAoQPPrCKPQfxbJ1cvhaVD73rKGg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OI+Ijt9+QIxw13UaPhWLyK1cUxMxOnuJYooycyiChegrG6vQOR43Gf2ymGYissCbX
         FepGOxyWkvcKd+mo/WjIyI7XMY4bQ2mZBFqhsSwOj8OAC7Ix5veIHUoWgzelqcaR7L
         usk+k6yUgR30HV/gy1keUCABvlJoE+yQh5UcbUXud8QSDpVaIjOD/KvjYSjMW639Il
         LJ7ghJEMxymnqO6oLld+n9wToGTNOCa9qgT9z0VicW9N9NkLftK+QRzQqjH/ou8V5e
         cUvU95eQvoZmNPQN3eYitOYF1AKtyCr+NwaAkqWPhyfaU1Gw3FxgBXl3nG0kaGukkm
         dfHUjIg9nViZw==
Subject: [PATCH 2/3] xfs_repair: warn about unwritten bits set in rmap btree
 keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:36:18 -0700
Message-ID: <168597937798.1225991.8653735463476217869.stgit@frogsfrogsfrogs>
In-Reply-To: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
References: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've changed libxfs to handle the rmapbt flags correctly when
creating and comparing rmapbt keys, teach repair to warn about keys that
have the unwritten bit erroneously set.  The old broken behavior never
caused any problems, so we only warn once per filesystem and don't set
the exitcode to 1 if we're running in dry run mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index d66ce60cbb3..008ef65ac75 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -966,6 +966,30 @@ verify_rmap_agbno(
 	return agbno < libxfs_ag_block_count(mp, agno);
 }
 
+static inline void
+warn_rmap_unwritten_key(
+	xfs_agblock_t		agno)
+{
+	static bool		warned = false;
+	static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
+
+	if (warned)
+		return;
+
+	pthread_mutex_lock(&lock);
+	if (!warned) {
+		if (no_modify)
+			do_log(
+ _("would clear unwritten flag on rmapbt key in agno 0x%x\n"),
+			       agno);
+		else
+			do_warn(
+ _("clearing unwritten flag on rmapbt key in agno 0x%x\n"),
+			       agno);
+		warned = true;
+	}
+	pthread_mutex_unlock(&lock);
+}
 
 static void
 scan_rmapbt(
@@ -1218,6 +1242,8 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		key.rm_flags = 0;
 		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
 		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (kp->rm_offset & cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN))
+			warn_rmap_unwritten_key(agno);
 		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
 				&key)) {
 			/* Look for impossible flags. */
@@ -1239,6 +1265,8 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		key.rm_flags = 0;
 		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
 		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (kp->rm_offset & cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN))
+			warn_rmap_unwritten_key(agno);
 		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
 				&key)) {
 			/* Look for impossible flags. */


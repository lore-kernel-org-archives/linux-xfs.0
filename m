Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3206C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiL3Wx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Wx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:53:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7831AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7024161B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D121AC433D2;
        Fri, 30 Dec 2022 22:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440835;
        bh=KfnE33b0V3Vll71MAoQPPrCKPQfxbJ1cvhaVD73rKGg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cKv4VTsOtQAltMKG9QwcTs02yTjBm2cMfEYdd5uPiF/D86Z2szpOnhK8JU83eRQLy
         VyBTdGV+fwo35k8eJVx65tUhjByoV6B71ia6Z4gzwbUsGU4rAJWdwf8clSzOWHXKHH
         zR2kCvCv5fcdOAVKeA3a1bMnAGeWGyNWoqPNoXK8oIQNfSorBe51DCecidPwjk5JZm
         /BVKwzaFrr8bgmQ/7P2H5n/tCrHLZ8erw0zGvdKBwJ3OGfCddyuiRF7O2WVj2cURer
         a4AOwBnapOP6TJjI/KdxpbpaVXpIDG4eunEvHB8IH27RU1Jqm8R5hIBriAlCdPGMns
         TQKM2rX/3Ap+g==
Subject: [PATCH 3/4] xfs_repair: warn about unwritten bits set in rmap btree
 keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834778.692079.16614482307184580250.stgit@magnolia>
In-Reply-To: <167243834739.692079.8979395707061192623.stgit@magnolia>
References: <167243834739.692079.8979395707061192623.stgit@magnolia>
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


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6378EC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1985D64E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhBWDCT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBWDB7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297B864E4D;
        Tue, 23 Feb 2021 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049278;
        bh=O/VBUE1KfX3TruSjzP0z+wCsAneM9yu2vQ7TnoF+XO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PZBQqrbyiZF6gsZEqXe0lH4jupCFT3WKkWACEosYpd8aARyCI19IojFxKGNMQrnwj
         DjsaSTGewix8snUQ/jAYcKLy7PglqzUFfh7ojxdqiHeW5QrCOxTjyGo+ITMdxh0ooz
         /3xW983O7OZGFV1EcoH6vNPoVpP4it3Ku0JDikyD+KADCajUpYp5eQ0VK071Y8x3zv
         YTx+lbQ3AvLMwXsPWdsJrVKPhF1FP9z1YiMErE4DNjgsC5lGMKMT827WPpgTQP6TAH
         x0NiOM5puoWLqVql0CSsCmVZpoRVFOT86j4Xj2t4LAYZmttxIPhrcHJBI8xs2h/WOY
         crsItC2dp9lLw==
Subject: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:17 -0800
Message-ID: <161404927772.425602.2186366769310581007.stgit@magnolia>
In-Reply-To: <161404926046.425602.766097344183886137.stgit@magnolia>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to centralize all the stuff we do at the end of
a repair phase (which for now is limited to reporting progress).  The
next patch will add more interesting things to this helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 03b7c242..a9236bb7 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -849,6 +849,12 @@ repair_capture_writeback(
 	pthread_mutex_unlock(&wb_mutex);
 }
 
+static inline void
+phase_end(int phase)
+{
+	timestamp(PHASE_END, phase, NULL);
+}
+
 int
 main(int argc, char **argv)
 {
@@ -878,7 +884,7 @@ main(int argc, char **argv)
 	msgbuf = malloc(DURATION_BUF_SIZE);
 
 	timestamp(PHASE_START, 0, NULL);
-	timestamp(PHASE_END, 0, NULL);
+	phase_end(0);
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
@@ -901,7 +907,7 @@ main(int argc, char **argv)
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
-	timestamp(PHASE_END, 1, NULL);
+	phase_end(1);
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -1127,23 +1133,23 @@ main(int argc, char **argv)
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
 	phase2(mp, phase2_threads);
-	timestamp(PHASE_END, 2, NULL);
+	phase_end(2);
 
 	if (do_prefetch)
 		init_prefetch(mp);
 
 	phase3(mp, phase2_threads);
-	timestamp(PHASE_END, 3, NULL);
+	phase_end(3);
 
 	phase4(mp);
-	timestamp(PHASE_END, 4, NULL);
+	phase_end(4);
 
 	if (no_modify)
 		printf(_("No modify flag set, skipping phase 5\n"));
 	else {
 		phase5(mp);
 	}
-	timestamp(PHASE_END, 5, NULL);
+	phase_end(5);
 
 	/*
 	 * Done with the block usage maps, toss them...
@@ -1153,10 +1159,10 @@ main(int argc, char **argv)
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
-		timestamp(PHASE_END, 6, NULL);
+		phase_end(6);
 
 		phase7(mp, phase2_threads);
-		timestamp(PHASE_END, 7, NULL);
+		phase_end(7);
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));


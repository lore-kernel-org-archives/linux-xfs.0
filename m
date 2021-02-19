Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C1FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12FD64ED5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhBSDSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBSDSv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 22:18:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A6BD64EDA;
        Fri, 19 Feb 2021 03:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613704690;
        bh=MkeHDcRZlsYNQo92ECHItNR2rwYfuz4y5kRuQU12EEQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TWkZuAb/fS+sZAC3p6K3O4SoHks9F/UxqJjK22Y1kpnp3o1bKkp2Ebp5Ld8KNs8B6
         4Oc5oFmzfaCAwRY6spirOSQoEgsD0v7XtkkI8tpz95vGZZFYvMZ6faUkrJE3CEDMtk
         mJhlTVAcWiXuJcSZ5Mzd/5WgVgNmJCMFlB7ReXDHkzzn0rU7ODomDdFgcxhxiyPkYx
         mPecl1P85ptq4w3XnjIjKpYhIMZ0xwlnuNihLsFPkr3n9doJLXNfVRNcQV0g7hgUi8
         t9z9ygpRFd38J7G+YM7dzmO9sNiTj1ydK1uOKAZBjncCEB+I5o3r+58t5oWsKVvYr4
         fgGVEaB5nIqww==
Subject: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 18 Feb 2021 19:18:10 -0800
Message-ID: <161370469026.2389661.9403286204851498334.stgit@magnolia>
In-Reply-To: <161370467351.2389661.12577563230109429304.stgit@magnolia>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
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
---
 repair/xfs_repair.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8eb7da53..891b3b23 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -847,6 +847,12 @@ repair_capture_writeback(
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
@@ -876,7 +882,7 @@ main(int argc, char **argv)
 	msgbuf = malloc(DURATION_BUF_SIZE);
 
 	timestamp(PHASE_START, 0, NULL);
-	timestamp(PHASE_END, 0, NULL);
+	phase_end(0);
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
@@ -899,7 +905,7 @@ main(int argc, char **argv)
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
-	timestamp(PHASE_END, 1, NULL);
+	phase_end(1);
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -1125,23 +1131,23 @@ main(int argc, char **argv)
 
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
@@ -1151,10 +1157,10 @@ main(int argc, char **argv)
 
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


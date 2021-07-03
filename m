Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D53C07E97
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7209C61416
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhGCDAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGCDAl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D62613EB;
        Sat,  3 Jul 2021 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281088;
        bh=dRIzv18PU7SJLRuTkqFfGGWmwGnlARICtaRvn6C0K8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sEJa16xfbH1a8DnqkOqqgyOrQA6Xl8hSR/tL6tuowTMYFxiLE0d2wqDSaWMBhpGrj
         +d2F2HMtVlb9g3qWW9yvEh4loci0oaIy88l1dsXNt8xa+6OAog/NYQniJnoGcKaaRB
         fGhjDD1dD3llCODSdUet0Y6mWZHeZFzdy/toI81C679WpNOMxSEijvVbklE64ZPiuF
         rluIAGCS4apwke/MKy9G+WHYApUtUQQzbl08ytgkNVSzpQUrI504s5bpB0Mnkd5ZxD
         wtTp5jiNxYu0pxo7JXiFmqnkcX0u3k3Reb/p9Lv93PHiKrIJc1JKIVqI8QZwoiI5/u
         KKCErlAkwCHIw==
Subject: [PATCH 2/2] xfs_io: clean up the funshare command a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:08 -0700
Message-ID: <162528108811.36401.13142861358282476701.stgit@locust>
In-Reply-To: <162528107717.36401.11135745343336506049.stgit@locust>
References: <162528107717.36401.11135745343336506049.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add proper argument parsing to the funshare command so that when you
pass it nonexistent --help it will print the help instead of complaining
that it can't convert that to a number.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/prealloc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 2ae8afe9..94cf326f 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -346,16 +346,24 @@ funshare_f(
 	char		**argv)
 {
 	xfs_flock64_t	segment;
+	int		c;
 	int		mode = FALLOC_FL_UNSHARE_RANGE;
-	int		index = 1;
 
-	if (!offset_length(argv[index], argv[index + 1], &segment)) {
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			command_usage(&funshare_cmd);
+		}
+	}
+        if (optind != argc - 2)
+                return command_usage(&funshare_cmd);
+
+	if (!offset_length(argv[optind], argv[optind + 1], &segment)) {
 		exitcode = 1;
 		return 0;
 	}
 
-	if (fallocate(file->fd, mode,
-			segment.l_start, segment.l_len)) {
+	if (fallocate(file->fd, mode, segment.l_start, segment.l_len)) {
 		perror("fallocate");
 		exitcode = 1;
 		return 0;


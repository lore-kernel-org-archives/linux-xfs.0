Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82867C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B890600CD
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhG1VQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 648F76101B;
        Wed, 28 Jul 2021 21:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506966;
        bh=+F+Pu7IQYvEfKsPuebgniOoXUTI14TBGxKpxyo0iI9k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KcYbTzEyqlcOujTfK0tb0B+zwO5rxnaVeFYDhF3Fsz0klGcyt/BT3wn5+c0tDWC/p
         bG9y/tP5Q9zJYw1bpuNcmKOVOKSZ0WdVcE3ImX8X5jy+5eXG4ci4A7OWCL6tIaDIYk
         dhtWEC4kmEBQqP+8K+9kUE4ZpRuRIz5RYkbVQzcsKwwFNqyHwxssFe6cL5gOgjuUWZ
         fY9FCI3viCxdSIfGE4aaDurDafthb3LhurvCfbgl2lbcn+DJihpRsQbSao8+NBc/6Z
         GIXI3wF/lDcV7U2y4WjZhSGHD3TblPf1p+agrjGxKelPu+21ZNUZhLXWVaq7O04ppw
         WgUZl/f4QyCIg==
Subject: [PATCH 2/2] xfs_io: clean up the funshare command a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:06 -0700
Message-ID: <162750696612.44508.4433629680409310292.stgit@magnolia>
In-Reply-To: <162750695515.44508.15362873895872268737.stgit@magnolia>
References: <162750695515.44508.15362873895872268737.stgit@magnolia>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/prealloc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 2ae8afe9..a8831c1b 100644
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
+	if (optind != argc - 2)
+		return command_usage(&funshare_cmd);
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


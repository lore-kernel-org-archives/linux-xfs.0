Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD425C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbjKVXH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjKVXH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405A710E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D8EC433C8;
        Wed, 22 Nov 2023 23:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694442;
        bh=Xn/E2etGG5axBFj+fX+s/d2I+9wrBsBCjuj7y9jlTVo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DhK7shK7Vjw12It86Rju3SSU9jaSErSemdAQVHBLm3r4ATfhEbL20GWLbjxgpL5Wu
         4e6u6MwvQ0OCW5vq4z2a++VoWp8OdQu7LFBuQxRhk5xiU9r79jrjG5xOw954jQgHOj
         ZYb3I6zG3sP5Cv9uW5jf89R7gAVsWbe06aZSgMWOIhiJGI0eQVV00c7Y6Ahte7YrhR
         CrVBhqOMm8J0LYGPIJS1GgfUX1xgppdZVZjvU8BdQegQ3YIsi/Vt3iKL1kZga1cpHi
         O+cEX2PuR8XxKomF4zKSIZlfVCM1aND8B3fL4h4rkktRbyf2JUf9mQR/pFGBIdJ44B
         k7+1RqwnICjXA==
Subject: [PATCH 6/9] xfs_mdrestore: fix uninitialized variables in mdrestore
 main
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:22 -0800
Message-ID: <170069444236.1865809.11643710907133041679.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Coverity complained about the "is fd a file?" flags being uninitialized.
Clean this up.

Coverity-id: 1554270
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 2de177c6e3f..5dfc423493e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -472,11 +472,11 @@ main(
 	union mdrestore_headers	headers;
 	FILE			*src_f;
 	char			*logdev = NULL;
-	int			data_dev_fd;
-	int			log_dev_fd;
+	int			data_dev_fd = -1;
+	int			log_dev_fd = -1;
 	int			c;
-	bool			is_data_dev_file;
-	bool			is_log_dev_file;
+	bool			is_data_dev_file = false;
+	bool			is_log_dev_file = false;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -561,7 +561,6 @@ main(
 	/* check and open data device */
 	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
 
-	log_dev_fd = -1;
 	if (mdrestore.external_log)
 		/* check and open log device */
 		log_dev_fd = open_device(logdev, &is_log_dev_file);


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC0AC07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3B561416
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhGCDAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGCDAs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F2A0613EB;
        Sat,  3 Jul 2021 02:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281095;
        bh=ZmQAlOSVovNpsXdTepKcJfp/KeNX1unwbGtQUpOAcEM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e561ZUfX4Z0VmCOGx4JvFFHsBqoRlnQjCihDJMrHJkKY6ZJbAaomqUOGx74xYdTd/
         vbh595Bg/5WImdgLNBKvJ2YLzvd5CK/laMGUBbcMkbeYmJ/ZP5oVwd8GXCeK80tvF7
         VWM+cKKrYIj05o4KngBH9Jwg9sWzFrZ3vJkQshsR1P7QUbB8Hkto/+KKTI3Ehuppcb
         j8fK+s1seDGU1QRACyMTwwdFRwgk38Xj10TLavWjlalaCWMecAK+WNlZXBuyuixWdU
         sXNv+zLTBltfu4yT5ONl5ka8V6+7aiA2+17Q2J4Vws00Xsr+AUu5og/iyc1fKkIAQM
         /PH1bwoR7/F7A==
Subject: [PATCH 1/2] xfs_io: only print the header once when dumping fsmap in
 csv format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:15 -0700
Message-ID: <162528109507.38807.485600723669552708.stgit@locust>
In-Reply-To: <162528108960.38807.10502298775223215201.stgit@locust>
References: <162528108960.38807.10502298775223215201.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Only print the column names once when we're dumping fsmap information in
csv format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/fsmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index 4b217595..9f179fa8 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -116,7 +116,8 @@ dump_map_machine(
 	struct fsmap		*p;
 	char			*fork;
 
-	printf(_("EXT,MAJOR,MINOR,PSTART,PEND,OWNER,OSTART,OEND,LENGTH\n"));
+	if (*nr == 0)
+		printf(_("EXT,MAJOR,MINOR,PSTART,PEND,OWNER,OSTART,OEND,LENGTH\n"));
 	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
 		printf("%llu,%u,%u,%lld,%lld,", i + (*nr),
 			major(p->fmr_device), minor(p->fmr_device),


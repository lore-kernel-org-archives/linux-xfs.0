Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC6BC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF47561039
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhG1VQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E219460462;
        Wed, 28 Jul 2021 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506961;
        bh=DkWT6rjh86jW2G/80m6SmC3IJ3CJ2h//RuwmciulVPA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PqHhWW2SemLsiiysuzuB55NA3z1hXMUGqIlJ+mcJFJIWpBrMeGkBALD3fPsZMzBuq
         37ZEkR0x0B0aUiSpTTomQJtQZkBDceveeZy1mMNN7smrb0XSgxAESPjRvoh5neYn4p
         KVsmV9h7XMTVbl3eXMEiz+D/vD1dp2AIR8/JRotQZmoSdq73fJWHZ1KW6C+/Y19wxI
         bKlY5EiwgZ7Ew63rr5szoaxjUqfCHOw5aJ8FdIMx8pVljPrzQPozWejkzuhgibO8Wg
         gRVJvl4BQADl4DOtxDkDvoBq3ODFv8IY27e8L5wnhFdaijDVbTWpbi536oJzHkm7no
         A76MzWtKuCFoA==
Subject: [PATCH 1/2] xfs_io: fix broken funshare_cmd usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:00 -0700
Message-ID: <162750696066.44508.13287474216659665234.stgit@magnolia>
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

Create a funshare_cmd and use that to store information about the
xfs_io funshare command instead of overwriting the contents of
fzero_cmd.  This fixes confusing output like:

$ xfs_io -c 'fzero 2 3 --help' /
fzero: invalid option -- '-'
funshare off len -- unshares shared blocks within the range

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/prealloc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 382e8119..2ae8afe9 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -43,6 +43,7 @@ static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
+static cmdinfo_t funshare_cmd;
 #endif
 
 static int
@@ -467,14 +468,14 @@ prealloc_init(void)
 	_("zeroes space and eliminates holes by preallocating");
 	add_command(&fzero_cmd);
 
-	fzero_cmd.name = "funshare";
-	fzero_cmd.cfunc = funshare_f;
-	fzero_cmd.argmin = 2;
-	fzero_cmd.argmax = 2;
-	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fzero_cmd.args = _("off len");
-	fzero_cmd.oneline =
+	funshare_cmd.name = "funshare";
+	funshare_cmd.cfunc = funshare_f;
+	funshare_cmd.argmin = 2;
+	funshare_cmd.argmax = 2;
+	funshare_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	funshare_cmd.args = _("off len");
+	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
-	add_command(&fzero_cmd);
+	add_command(&funshare_cmd);
 #endif	/* HAVE_FALLOCATE */
 }


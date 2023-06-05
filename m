Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EC5C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbjFEPiF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbjFEPiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D1898
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918DD61539
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16B4C433EF;
        Mon,  5 Jun 2023 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979482;
        bh=57Z+tBHSW0UW497yLJJ2MUVCF6l5ljcqzvx1rqKCcMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CGdi7ByrD0HO/ANvCH718C1Z+gkuW3SWOD4sZGqOFB7ptg+xCUJkP5t1B9M+DUow7
         dAuU0v5ZXREUfKrjc9Lr5ekmO1DUdu+NCiEG96+8oLyvidmO6V5Wz10mctt1dGJMVV
         OOpG3bEOL1SOmiDwblzEDaKe2EvCPHdI7DVX3DkwAtLFIJHKtT27yKPBQbq5CiWOSv
         SwcQdmwAbEE9qGFCZ2S7vMip17WyiflGWug3j0fAyyS+n7QZO9fO+by9/5CpCHDm+O
         8ov4hp/sSmkBq+4EbKJjwbS8cD8z/SxGhR/Us0VnPZVWTcSJSqHgy51/q9dDjjNqao
         yZwSzKIgtbDtg==
Subject: [PATCH 5/5] xfs_repair: fix messaging when fixing imap due to sparse
 cluster
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:38:01 -0700
Message-ID: <168597948159.1226461.18433540672354330389.stgit@frogsfrogsfrogs>
In-Reply-To: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This logic is wrong -- if we're in verbose dry-run mode, we do NOT want
to say that we're correcting the imap.  Otherwise, we print things like:

imap claims inode XXX is present, but inode cluster is sparse,

But then we can erroneously tell the user that we would correct the
imap when in fact we /are/ correcting it.

Fixes: f4ff8086586 ("xfs_repair: don't crash on partially sparse inode clusters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 33008853789..171756818a6 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -834,7 +834,7 @@ process_inode_chunk(
 			do_warn(
 	_("imap claims inode %" PRIu64 " is present, but inode cluster is sparse, "),
 						ino);
-			if (verbose || !no_modify)
+			if (!no_modify)
 				do_warn(_("correcting imap\n"));
 			else
 				do_warn(_("would correct imap\n"));


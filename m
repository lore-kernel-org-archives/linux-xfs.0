Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDDAC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbiATAVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47128 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBDBCB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8327AC004E1;
        Thu, 20 Jan 2022 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638100;
        bh=cqZRkSlw9QheEW77rZB6uR76O+Po1eFqbxaS/84tFQ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ImRkigRaUKTZ8l1qZsw2gM8mR3Ae5/30fMjglFZQcWkHgv/lkwa+qCKuJpdcl9r1z
         cdMny78uSgBi2Dzcmzvj+WBAqURryt/KlG5rdv0+2UB7DKRxAM7dUxQyk9EyYiRv3H
         R8e3Vsy0mapO6Sf3Q3q9cvzh5NOwS90Wnpc8LrZOxoa4dzzvEiJpKUxxeY0bKFPKxy
         FU2sVJhVZ+9lXsfWzYAyZdEpWDFvOUYuqLH6/53/3RoRpLpGN0nlTpMg6BIoq1xHG5
         R0RLAtphikvd4QNorIAyOxIqm2OO34tlHt1GCrE2z/kZy8jMWB6/0a/O5X9b58uW2M
         rv5BRSP7cWGeg==
Subject: [PATCH 01/17] libxcmd: use emacs mode for command history editing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:21:40 -0800
Message-ID: <164263810022.863810.6280233449804628996.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to xfsprogs 5.7.0, we built xfsprogs with libreadline support by
default.  In its default configuration, that library interpreted various
keystrokes in a direct manner (e.g. backspace deletes the character to
the left of the cursor), which seems consistent with how emacs behaves.

However, libeditline's default keybindings are consistent with vim,
which means that suddenly users are presented with not the same line
editing interface that they had before.  Since libeditline is
configurable (put "bind -v" in editrc if you really want vim mode),
let's put things back the way they were.  At least as much as we can.

Fixes: bbe12eb9 ("xfsprogs: remove libreadline support")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/input.c      |    1 +
 libxcmd/input.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/db/input.c b/db/input.c
index 448e84b0..d8113599 100644
--- a/db/input.c
+++ b/db/input.c
@@ -227,6 +227,7 @@ fetchline(void)
 		el_set(el, EL_SIGNAL, 1);
 		el_set(el, EL_PROMPT, el_get_prompt);
 		el_set(el, EL_HIST, history, (const char *)hist);
+		el_set(el, EL_EDITOR, "emacs");
 	}
 
 	if (inputstacksize == 1) {
diff --git a/libxcmd/input.c b/libxcmd/input.c
index e3fa626a..fa80e5ab 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -45,6 +45,7 @@ fetchline(void)
 		el_set(el, EL_SIGNAL, 1);
 		el_set(el, EL_PROMPT, el_get_prompt);
 		el_set(el, EL_HIST, history, (const char *)hist);
+		el_set(el, EL_EDITOR, "emacs");
 	}
 	cmd = el_gets(el, &count);
 	if (!cmd)


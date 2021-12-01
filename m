Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A1BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 17:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbhLASDN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352035AbhLASCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 13:02:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA13C06175E
        for <linux-xfs@vger.kernel.org>; Wed,  1 Dec 2021 09:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7064CE204E
        for <linux-xfs@vger.kernel.org>; Wed,  1 Dec 2021 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66D8C53FAD;
        Wed,  1 Dec 2021 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638381527;
        bh=e372xI5iuyAD2ZD+LN7EuNSRzHoGD5oe2lKpNqZ1t0k=;
        h=Date:From:To:Cc:Subject:From;
        b=NfbfSVb1rBOjT3QF4aolNR3D9XCNtOSFrgnA5mvYc3VaEwu8JRScjWytDb38VozDV
         dpd7YK4p++dR4lEygVdllPpawwdm7aJqtncxuD77xiazGQ1se8B7nFNIvKhoJa8DZ5
         X4efKNQfvv+sQm3yuv+Z2gAbcsc9txYsNIZA0ChlBxgeGXsUgV26FR6QY9O6enEgU7
         21bw7bqNkXrUxzkUjgwG1IrLO11Wmkb38T5lrH4zZHKDKyRyi7DroQBHkXZ9AsDEYz
         8/Msvc67Q1MO2OSPltWfdA8cTQmHWrxN69nxlElYEGNYGoGlxnCAMy9RZEc9VkMhuL
         5gy7JZCKyS/zg==
Date:   Wed, 1 Dec 2021 09:58:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxcmd: use emacs mode for command history editing
Message-ID: <20211201175846.GM8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

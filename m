Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32028C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Dec 2021 00:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhLRATF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:19:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLRATF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 19:19:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875A7B82B2B
        for <linux-xfs@vger.kernel.org>; Sat, 18 Dec 2021 00:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4628AC36AE2;
        Sat, 18 Dec 2021 00:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639786743;
        bh=02c4/FXR1sE3xrBEBQBoY5JgWTxagUWLAnu1O45Z02A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EW4izEfsDK6+xvsIoKNzvQG5nrPRwUB3L6eWYwJOaAYj8ku11CuUVSRdWNhMZipSz
         aD1gmJKL5mCmZ8aLbb7TFcCVkafzIS5j2i2zYILHPOa+deN5REYKk5GYIw+1H6fkKX
         SZfAhfb9rskEbM+kDNKsw1E98tgHIKV8/CZr/01/tWY+g9lNM2PKJsLK4Kcoa1VRKA
         orGZEZoE00zYVL8gYoP7Ly5mNvljwBHKnA17l8O53RWgCTTW8qqDEhcO0b8KvL2VN8
         jsVC2H+no6AqLPY/ZkRnZGI8p9vBGErXBU84tfZbQ7BEHqPCl2XnWmPu9521ASvsPr
         3FWyFrXecP+1g==
Date:   Fri, 17 Dec 2021 16:19:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 1/3] libxcmd: use emacs mode for command history editing
Message-ID: <20211218001902.GS27664@magnolia>
References: <20211218001616.GB27676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218001616.GB27676@magnolia>
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

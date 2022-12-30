Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E065C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiLaDHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiLaDHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:07:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C191054D;
        Fri, 30 Dec 2022 19:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BB6EB81EA2;
        Sat, 31 Dec 2022 03:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3E0C433D2;
        Sat, 31 Dec 2022 03:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456028;
        bh=zWcZvK5otpvmqwZPIb6vjxtYz/oRQJU1IbLgCJ+PSUg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PkRbSTuu8dfslv/tXHwtSP47qzfhRzTusebmZfNRmfypemrhyGxwEVE3cItINsWZO
         lGv/9PZnTgf61AOKvryfj3XNECP6vyQXFKHSM/e0U/zq4gh99gxRKO855bhnkAuM9A
         9IqJUt3VBeKfX9NrTyQklirYRLVcSYJFMj8QNLYB7jG7MAebcCko1ARdhpkdSHHe4E
         239PLFSO3+VdxBR9y00QQApvk5sn6uBIMoGMSmb8vVsYOXGPzk2n3vVT7HwlKhGoK5
         +cxZhygpka1ZvvU+yRbbhW6ECVR7TClLDVgGK+1fsetbFt5chWhBx9tGAvZMfKnY90
         OVjyQxfu72EIQ==
Subject: [PATCH 4/9] common/repair: patch up repair sb inode value complaints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:32 -0800
Message-ID: <167243883294.736753.7002825243368357123.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've refactored xfs_repair to be more consistent in how it
reports unexpected superblock inode pointer values, we have to fix up
the fstests repair filters to emulate the old golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/repair |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/repair b/common/repair
index 8945d0028c..c3afcfb3e6 100644
--- a/common/repair
+++ b/common/repair
@@ -28,6 +28,10 @@ _filter_repair()
 	perl -ne '
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
+s/realtime bitmap inode pointer/realtime bitmap ino pointer/;
+s/sb realtime bitmap inode value/sb realtime bitmap inode/;
+s/realtime summary inode pointer/realtime summary ino pointer/;
+s/sb realtime summary inode value/sb realtime summary inode/;
 s/(pointer to) (\d+)/\1 INO/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;


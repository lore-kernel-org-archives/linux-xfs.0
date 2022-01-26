Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEC6C3525A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 02:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiAZCSn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:18:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50508 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiAZCSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 21:18:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80CFB61659
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jan 2022 02:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC0FC340E0;
        Wed, 26 Jan 2022 02:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643163520;
        bh=uIxqWUi9T9OugcCAVzL0xHlmTxNhZ5Hb4vMVWMPDcoE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=djSBNPTDnm8q1R+5HBPZqURcgsMXEQLzjmJCww4ihZmhkW/gyB3+e8rWJUolK2xiI
         Oq3LhmKs9kQbReDOXay7FVgCskCIXMwUs5gLyxQv8wBGgSaYGPLXcVJA3Xd2EZSKB0
         jkzpqIHU2fCMjXGwVKtOZz5sTm8EWMKwFcfxh+B2MSF248ykQVGkHFiYU9mpVgvH1G
         ZaRxqtEA2JFwtkzfXkU7IVhHI7sWVxBRHG4sKVH7JneRYdVqhfSo03/lSMubgulYF8
         huDhkLWF8JljObOwEwP3mLbSKXmdywLEwSycjG6kB7BKlJc+b+uxq3wS3+aLkUIYid
         NCPEtXh0y3Rig==
Subject: [PATCH 1/1] xfs: reject crazy array sizes being fed to
 XFS_IOC_GETBMAP*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jan 2022 18:18:40 -0800
Message-ID: <164316352054.2600306.4346155831671217356.stgit@magnolia>
In-Reply-To: <164316351504.2600306.5900193386929839795.stgit@magnolia>
References: <164316351504.2600306.5900193386929839795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 03a6198c97f6..2515fe8299e1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1464,7 +1464,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvcalloc(bmx.bmv_count, sizeof(*buf), GFP_KERNEL);


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405DDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiLaAOz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiLaAOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:14:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96362102E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DACFB81E4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C2C433D2;
        Sat, 31 Dec 2022 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445689;
        bh=U0Zyy7WDFOFAa00nZBdZbuGEaNajmJsE8YgmKhXC73s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ODaSvSV83vGILgfBK7z0XhZ6cx2+zkls/Z5uE3xCJ5QZnMYjfEk0JdgNhiPOmG5te
         6SEAUCZjv8TP79DfB5J+mfMcpRLakCuD3nU0ei2lQCZWb70DP9Jxk/Ghejcr4m206o
         YYaoe39vW3HSkxNGXGvDSCcp0LooUesP519jUnbnFaGsBn7CgL8hTGi2Y4XiJOhIML
         OfHrO98B4QgFWGoa4BbOn1XvSRU5oWXS7WVj7E8wTvzEu7nwzBVcAHCG/y2xBDS6Ev
         ccdpKHfNeHy6ZvRmD8RZSRvngdxHts5iegTvd6tGwzSG71tcVPLvZ8hSXZBT8E3jg3
         jjZIiXEV223gg==
Subject: [PATCH 5/5] mkfs: enable reverse mapping by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:46 -0800
Message-ID: <167243866627.712315.15687679675541850153.stgit@magnolia>
In-Reply-To: <167243866562.712315.18184440339100962213.stgit@magnolia>
References: <167243866562.712315.18184440339100962213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that the scrub part of online fsck is feature complete (scrub and
health reporting are done) there's actually a compelling story for
having the reverse mappings enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    4 ++--
 mkfs/xfs_mkfs.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 1c90b5b5595..94f117b6917 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -289,8 +289,8 @@ pinpoint exactly which data has been lost when a disk error occurs.
 .IP
 By default,
 .B mkfs.xfs
-will not create reverse mapping btrees.  This feature is only available
-for filesystems created with the (default)
+will create reverse mapping btrees when possible.
+This feature is only available for filesystems created with the (default)
 .B \-m crc=1
 option set. When the option
 .B \-m crc=0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 638e7ce6ea4..cca3497ab64 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4306,7 +4306,7 @@ main(
 			.dirftype = true,
 			.finobt = true,
 			.spinodes = true,
-			.rmapbt = false,
+			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
 			.parent_pointers = false,


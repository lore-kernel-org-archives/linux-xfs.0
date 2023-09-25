Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D79ECE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjIYV7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjIYV7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91617112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3188FC433C7;
        Mon, 25 Sep 2023 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679171;
        bh=RxMiU2bZZ14O6vEpacgzwkociNX4Qpg94fekByJqb6c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lev8LHks0w8NhXKBUh+Z1gCaCrswntuebLF/CR6PGCm49cE+kNoCTqeJHufbD5eAW
         4HHsOYnHLwSmw3fxQf4YuT98uoEDvE2hP7TXD6IhZDbfNn/m41qDCah2SWvRwxenYd
         qxr/izD0ac1qIZDbIA438g+SM1FFoJhcfCcvwXnOeKwe6faHF2xAWMVnfHgJfSYbzg
         V08z4Ii+4/f7JClFrZhdIVm6jR6JjL65Z1oZySxWf8zVIRdBPgW/XafcnakfxPOMId
         MvrHp0D39v1W+Mh7YX2P0m1Pz24qlm77KURA/N2Vj8+InbopWwHUsQ9jX0mmdtEm4C
         DGM5aEKG+QpMw==
Subject: [PATCH 2/3] mkfs: enable reverse mapping by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:30 -0700
Message-ID: <169567917071.2320343.3177118001791641798.stgit@frogsfrogsfrogs>
In-Reply-To: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
References: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that online fsck is feature complete, there's actually a compelling
story for having the reverse mappings enabled.  Turn it on by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    4 ++--
 mkfs/xfs_mkfs.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 3a44b92a6a0..c152546a47d 100644
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
index a3dcc811304..c522cb4df8b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4134,7 +4134,7 @@ main(
 			.dirftype = true,
 			.finobt = true,
 			.spinodes = true,
-			.rmapbt = false,
+			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
 			.parent_pointers = false,


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32188C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBPVNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBPVNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:13:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9875648E22
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343AB60C6D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A2C4339B;
        Thu, 16 Feb 2023 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581999;
        bh=Q+a7osUMm9ExpAm3B7NbqI/JwquB9oehO7AOp8WtOMk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HW4qDwLPtp2r6pcG5a7QMFpwZjdfTuAXaUwfPlO0Cuwvafx3rNjl0QJF6oJpPEHK0
         FhSkJYnaxoqE0cGw4iUkA0+yZGw6Z+OYNXyaaZE+sAq807ExJ8flJUeRzW0JjAKOp/
         dcUIvLkkqdJShbCpk6SBOwO3NL6d7novu2XSa/9QRvNlpuF9ZA0ncwXgiShozIbKIU
         2UJJI11EJObVvS/d6ikLoFCfWEk3TdRWrislgXaXAfqltSjZaQV2U8yLxDoXa+cJ7d
         /dMYPrpcdXdhNPAxiKbv3CnlIcr2PNkMIunhFxLFXskA9Hi0XV4D7xlfWiPpMr3tOG
         j8Buu6YUVnLsg==
Date:   Thu, 16 Feb 2023 13:13:19 -0800
Subject: [PATCH 2/3] mkfs: enable reverse mapping by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657883086.3478343.5924713027573384229.stgit@magnolia>
In-Reply-To: <167657883060.3478343.13279613574882662321.stgit@magnolia>
References: <167657883060.3478343.13279613574882662321.stgit@magnolia>
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
index 4c379549..9ce8373d 100644
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
index f355e416..325f8617 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4085,7 +4085,7 @@ main(
 			.dirftype = true,
 			.finobt = true,
 			.spinodes = true,
-			.rmapbt = false,
+			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
 			.parent_pointers = false,


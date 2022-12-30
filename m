Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17BBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiLaByj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbiLaByc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:54:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444C11DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D651761CD6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA8C433EF;
        Sat, 31 Dec 2022 01:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451671;
        bh=ainxLkxNFBefq74OUmSYZRTRopOIVf7cuw5vRbe4wVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JkpzCBhF0M2T82/NIBNfR82ofuVJLHaPkLXYSS1KpQLK2RmS3ROzZHKwNIzhVJ+jR
         LN8yOWaS0j5KBfpXgn/aIQuYU2u+ImsCu/JM2F8UmLWLjhSjJ9g0NUfrQBfzAX7lZf
         L7b9dBeG/4NdFEUNGIhhNZHGbyGMJsS55mOJU0GNVFgkk0FkbodAu0qevs3PbqBWGF
         /OSk7h4RpoI47+EEmmrr8ed3ooiDe+GZ4NTtrk5Jt92HSVFWDA0G2VYwG48IxRjH+q
         t7hTA3ApBZ2WFWKsxgaKX1HveHqBK1Mc9HC4Dx7swXFP30fjv3BjV4cywxlPn/ij2Y
         SPMl7yLlDI9wA==
Subject: [PATCH 25/42] xfs: enable extent size hints for CoW operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871251.717073.7768252010589495025.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++++-
 fs/xfs/xfs_bmap_util.c   |    5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 552875ddcc4a..b2bc39b1f9b7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6450,7 +6450,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 842f472292cd..a54ed26e1cc0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -138,7 +138,10 @@ xfs_bmap_rtalloc(
 	bool			ignore_locality = false;
 	int			error;
 
-	align = xfs_get_extsz_hint(ap->ip);
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else
+		align = xfs_get_extsz_hint(ap->ip);
 retry:
 	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,


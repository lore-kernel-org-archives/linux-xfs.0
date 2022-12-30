Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D6AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiLaCAb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:00:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6FE1C438
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF78C61C5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2602AC433EF;
        Sat, 31 Dec 2022 02:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452029;
        bh=482r1WQSyvTSKfMN7OaT+cZrXg8z80qxIGmmX5w7K54=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kxnGkmKy2NlA1xGGtgcpfMVfa8W9aCKbQlb0gkBWS0SkH1naUD8CdtrXoqj1EO5d6
         2trnrtIlWkVroBqxG6ixtYw0EJbABkor2tm0pTNfxvPXAFZT6fdO4PNmgo6q2JuLZv
         0Imor4AJKxnTTZZCQVrAtyBMQIUI9zF5jx+dgFP6P3U8wDzC4K/WP0w0ZZy+uGiIKw
         8RiGgbnDmtSrPRtz+Kgb7rrS8ObfueXL/RxeEBTsaOiTZAH3svQG8k7S9uKE3JyNub
         WA7PRgUFdF/7j8FIi1y/ntpgVUfkqFHaJjkRWDgCQu3I0ZB4wjVpIHRsdvoM10gg7I
         fOPUzvp1G1BSQ==
Subject: [PATCH 6/9] xfs: enable extent size hints for CoW when rtextsize > 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871889.718512.5550194735087623208.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

CoW extent size hints are not allowed on filesystems that have large
realtime extents because we only want to perform the minimum required
amount of write-around (aka write amplification) for shared extents.

On filesystems where rtextsize > 1, allocations can only be done in
units of full rt extents, which means that we can only map an entire rt
extent's worth of blocks into the data fork.  Hole punch requests become
conversions to unwritten if the request isn't aligned properly.

Because a copy-write fundamentally requires remapping, this means that
we also can only do copy-writes of a full rt extent.  This is too
expensive for large hint sizes, since it's all or nothing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b2bc39b1f9b7..053d72063999 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6451,6 +6451,28 @@ xfs_get_cowextsz_hint(
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
 	if (XFS_IS_REALTIME_INODE(ip)) {
+		/*
+		 * For realtime files, the realtime extent is the fundamental
+		 * unit of allocation.  This means that data sharing and CoW
+		 * remapping can only be done in those units.  For filesystems
+		 * where the extent size is larger than one block, write
+		 * requests that are not aligned to an extent boundary employ
+		 * an unshare-around strategy to ensure that all pages for a
+		 * shared extent are fully dirtied.
+		 *
+		 * Because the remapping alignment requirement applies equally
+		 * to all CoW writes, any regular overwrites that could be
+		 * turned (by a speculative CoW preallocation) into a CoW write
+		 * must either employ this dirty-around strategy, or be smart
+		 * enough to ignore the CoW fork mapping unless the entire
+		 * extent is dirty or becomes shared by writeback time.  Doing
+		 * the first would dramatically increase write amplification,
+		 * and the second would require deeper insight into the state
+		 * of the page cache during a writeback request.  For now, we
+		 * ignore the hint.
+		 */
+		if (ip->i_mount->m_sb.sb_rextsize > 1)
+			return ip->i_mount->m_sb.sb_rextsize;
 		b = 0;
 		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
 			b = ip->i_extsize;


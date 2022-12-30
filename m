Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B64AC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiLaDFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiLaDFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC215F27
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:05:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C1061D32
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4349C433D2;
        Sat, 31 Dec 2022 03:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455903;
        bh=37QeixoFuMvg3qMvwAcU8CjWjfDkXHQ1uiGM9k7iQx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rjc8/WjUjq+y7GFtugATKFLuYQ2BOOpu9aw5fife0W73+Kii6mgiiWqVUjiHUJ1ls
         24i21oiSmfQZ1djcZJx6G2liXlRF5AAIhV7H2x7SFR/2he1ZHFGhiDjBnArsexd4c7
         J9JzE1vmRYkIyWvSbd3aN4egNJ7YmJgGr6UpyDp4iENXej437hwviXMcfIu3CT8xSf
         QPnEuupVUTS4s65Kd8hTu9QtjQSffd1pSrPE6wj6Js/tQrkyLKrYOnH1XWdL1QikUi
         f5Oh5jnHOC6L+y3wPwuCOZjPEcSyzvzhuHiMyV+MT0Sed1gPa+X+a0zqnoAvkX/2L6
         7P90iag3tC19A==
Subject: [PATCH 1/3] xfs: enable extent size hints for CoW when rtextsize > 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:16 -0800
Message-ID: <167243881611.735065.16808285137243477595.stgit@magnolia>
In-Reply-To: <167243881598.735065.1487919004054265294.stgit@magnolia>
References: <167243881598.735065.1487919004054265294.stgit@magnolia>
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
 libxfs/xfs_bmap.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d5842e3b4f6..b8fe093f0f3 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6445,6 +6445,28 @@ xfs_get_cowextsz_hint(
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


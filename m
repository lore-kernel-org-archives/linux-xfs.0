Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA2FC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 16:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCPQr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 12:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjCPQr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 12:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFA2B1A6A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 09:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D424620AE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 16:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E751EC4339C;
        Thu, 16 Mar 2023 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678985242;
        bh=0T1XU5svHhcfD76b+kmAJ9JNdMSZKBP13L+qLi2rhjM=;
        h=Date:From:To:Cc:Subject:From;
        b=ITNoy8+x8JywcFRZefKJVwd2j/Z2GQ+CGVqaBo1xM63ed/g9Z/n8n6DtCIAhtXRID
         OAf1ogYWsa3EGLdtmATAac5usyru1XF1S7GvJFB9n6A3Gb9tfoq4c88k8B8ZDvddvc
         zz4wfxiuHhZ6R6X0X34XOuFt8Xazr+qvtMP1bYj11bCL1KcedCCXjP/OHPxB5r4jLy
         gzjOvU6xXYv852imKOYAvkITMiDNuDSLYGQo0AP3pl5KEKvehTrK4MsMzvKRqXUJqt
         s/4CRfNyHUiXCaFIWUvyrNPtcF7/2NUy3BXNy9DGTHTypBIsUqWMa58HGg7vI3ZD/L
         KfwEA5QcgciKw==
Date:   Thu, 16 Mar 2023 09:47:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: walk all AGs if TRYLOCK passed to
 xfs_alloc_vextent_iterate_ags
Message-ID: <20230316164721.GK11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Callers of xfs_alloc_vextent_iterate_ags that pass in the TRYLOCK flag
want us to perform a non-blocking scan of the AGs for free space.  There
are no ordering constraints for non-blocking AGF lock acquisition, so
the scan can freely start over at AG 0 even when minimum_agno > 0.

This manifests fairly reliably on xfs/294 on 6.3-rc2 with the parent
pointer patchset applied and the realtime volume enabled.  I observed
the following sequence as part of an xfs_dir_createname call:

0. Fragment the free space, then allocate nearly all the free space in
   all AGs except AG 0.

1. Create a directory in AG 2 and let it grow for a while.

2. Try to allocate 2 blocks to expand the dirent part of a directory.
   The space will be allocated out of AG 0, but the allocation will not
   be contiguous.  This (I think) activates the LOWMODE allocator.

3. The bmapi call decides to convert from extents to bmbt format and
   tries to allocate 1 block.  This allocation request calls
   xfs_alloc_vextent_start_ag with the inode number, which starts the
   scan at AG 2.  We ignore AG 0 (with all its free space) and instead
   scrape AG 2 and 3 for more space.  We find one block, but this now
   kicks t_highest_agno to 3.

4. The createname call decides it needs to split the dabtree.  It tries
   to allocate even more space with xfs_alloc_vextent_start_ag, but now
   we're constrained to AG 3, and we don't find the space.  The
   createname returns ENOSPC and the filesystem shuts down.

This change fixes the problem by making the trylock scan wrap around to
AG 0 if it doesn't like the AGs that it finds.  Since the current
transaction itself holds AGF 0, the trylock of AGF 0 will succeed, and
we take space from the AG that has plenty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 8999e38e1bed..bd7112d430b6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3326,11 +3326,14 @@ xfs_alloc_vextent_iterate_ags(
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		restart_agno = minimum_agno;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
+	if (flags & XFS_ALLOC_FLAG_TRYLOCK)
+		restart_agno = 0;
 restart:
-	for_each_perag_wrap_range(mp, start_agno, minimum_agno,
+	for_each_perag_wrap_range(mp, start_agno, restart_agno,
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
 		error = xfs_alloc_vextent_prepare_ag(args);
@@ -3369,6 +3372,7 @@ xfs_alloc_vextent_iterate_ags(
 	 */
 	if (flags) {
 		flags = 0;
+		restart_agno = minimum_agno;
 		goto restart;
 	}
 

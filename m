Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4392DC4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJBS1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiJBS1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35E03B971
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 458D160EB1
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F0C433C1;
        Sun,  2 Oct 2022 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735256;
        bh=xFc/OL8/bFpO0HNaST03NQ+mhkAJ16FtGDm3UdwyBBY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Oo/egUCac+nzQ8hDceHP9tfx4ITqffWBfeloTofMwHBgiJK9st0dACdSU+z9wauvl
         8G7danb0Hp3CwJj8rFUtpHUUEn4r5ZHhwdtAngUdnIUi1kEZSSj1sbi2ZyH2EHA32W
         6Sso+9o5qC6XQvRDgQI0rXnFipf57o5ZbMt7DyI1Xlj2qCIoP9ZiM2tdgtoLHvPdsp
         /WAJH0rg0XIbXcd1x6H33rmG9ynOG72UnhTjdjH77APYFoB6XvkHSt5W3FtEzSSHZq
         gfnhQa8SJcwSGBMXzcGI+68fakGOLj0VtVbYz6z78lvwad71nC6w4B/bytirOUvgkH
         qR4wyPPjsLCFA==
Subject: [PATCH 1/4] xfs: fully initialize xfs_da_args in
 xchk_directory_blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:48 -0700
Message-ID: <166473478865.1083155.10793868656289104615.stgit@magnolia>
In-Reply-To: <166473478844.1083155.9238102682926048449.stgit@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running the online fsck test suite, I noticed the following
assertion in the kernel log (edited for brevity):

XFS: Assertion failed: 0, file: fs/xfs/xfs_health.c, line: 571
------------[ cut here ]------------
WARNING: CPU: 3 PID: 11667 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 3 PID: 11667 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_dir2_isblock+0xcc/0xe0
 xchk_directory_blocks+0xc7/0x420
 xchk_directory+0x53/0xb0
 xfs_scrub_metadata+0x2b6/0x6b0
 xfs_scrubv_metadata+0x35e/0x4d0
 xfs_ioc_scrubv_metadata+0x111/0x160
 xfs_file_ioctl+0x4ec/0xef0
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

This assertion triggers in xfs_dirattr_mark_sick when the caller passes
in a whichfork value that is neither of XFS_{DATA,ATTR}_FORK.  The cause
of this is that xchk_directory_blocks only partially initializes the
xfs_da_args structure that is passed to xfs_dir2_isblock.  If the data
fork is not correct, the XFS_IS_CORRUPT clause will trigger.  My
development branch reports this failure to the health monitoring
subsystem, which accesses the uninitialized args->whichfork field,
leading the the assertion tripping.  We really shouldn't be passing
random stack contents around, so the solution here is to force the
compiler to zero-initialize the struct.

Found by fuzzing u3.bmx[0].blockcount = middlebit on xfs/1554.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5abb5fdb71d9..58b9761db48d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -666,7 +666,12 @@ xchk_directory_blocks(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_bmbt_irec	got;
-	struct xfs_da_args	args;
+	struct xfs_da_args	args = {
+		.dp		= sc ->ip,
+		.whichfork	= XFS_DATA_FORK,
+		.geo		= sc->mp->m_dir_geo,
+		.trans		= sc->tp,
+	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
 	xfs_fileoff_t		leaf_lblk;
@@ -689,9 +694,6 @@ xchk_directory_blocks(
 	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
 
 	/* Is this a block dir? */
-	args.dp = sc->ip;
-	args.geo = mp->m_dir_geo;
-	args.trans = sc->tp;
 	error = xfs_dir2_isblock(&args, &is_block);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;


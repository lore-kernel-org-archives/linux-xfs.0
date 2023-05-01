Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC8C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjEAS1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEAS1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E16DF
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D943061E84
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40604C433D2;
        Mon,  1 May 2023 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965619;
        bh=B/KXX9/QYgTj0QZ0Ow25WYl4nwu5/N83I2/JU3lhTDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L6PrFr05S0+wjMGu6DNmB+X42BebdL0TQV4wYZSdWbVywLo1OTNyn2aldLAeE6Nra
         3VvqdG0a/1SCk/KIOsiUH01CuUsE13WOHS5qrGucLFNawIy2rcpU0KcvA7EWqLflJo
         mkDof9vRbukHzahLlGTWZwsZE3QXJ/cNAhS9zltGDfHIj75HmAt2InE2GESC7Wy6iw
         Khh2Yw5UF06xYTcfRcWESTCzY98xAb9714GcBPXQVFxQ8wssT+v9xmROeC+0iK6orL
         HjF2ir2zc/5Of0Ox7J0p5D5Ie7UmKizvrvsYIqsT9v6FcQhWOSP3t3HMj6iC48CG9n
         XzB0VSJ5R/xVg==
Subject: [PATCH 1/4] xfs: don't unconditionally null args->pag in
 xfs_bmap_btalloc_at_eof
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:26:58 -0700
Message-ID: <168296561879.290030.9885864692870487053.stgit@frogsfrogsfrogs>
In-Reply-To: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/170 on a filesystem with su=128k,sw=4 produces this splat:

BUG: kernel NULL pointer dereference, address: 0000000000000010
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP
CPU: 1 PID: 4022907 Comm: dd Tainted: G        W          6.3.0-xfsx #2 6ebeeffbe9577d32
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-bu
RIP: 0010:xfs_perag_rele+0x10/0x70 [xfs]
RSP: 0018:ffffc90001e43858 EFLAGS: 00010217
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: ffffffffa054e717 RSI: 0000000000000005 RDI: 0000000000000000
RBP: ffff888194eea000 R08: 0000000000000000 R09: 0000000000000037
R10: ffff888100ac1cb0 R11: 0000000000000018 R12: 0000000000000000
R13: ffffc90001e43a38 R14: ffff888194eea000 R15: ffff888194eea000
FS:  00007f93d1a0e740(0000) GS:ffff88843fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000018a34f000 CR4: 00000000003506e0
Call Trace:
 <TASK>
 xfs_bmap_btalloc+0x1a7/0x5d0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 xfs_bmapi_allocate+0xee/0x470 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 xfs_bmapi_write+0x539/0x9e0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 xfs_iomap_write_direct+0x1bb/0x2b0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 xfs_direct_write_iomap_begin+0x51c/0x710 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 iomap_iter+0x132/0x2f0
 __iomap_dio_rw+0x2f8/0x840
 iomap_dio_rw+0xe/0x30
 xfs_file_dio_write_aligned+0xad/0x180 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 xfs_file_write_iter+0xfb/0x190 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
 vfs_write+0x2eb/0x410
 ksys_write+0x65/0xe0
 do_syscall_64+0x2b/0x80

This crash occurs under the "out_low_space" label.  We grabbed a perag
reference, passed it via args->pag into xfs_bmap_btalloc_at_eof, and
afterwards args->pag is NULL.  Fix the second function not to clobber
args->pag if the caller had passed one in.

Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b512de0540d5..cd8870a16fd1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3494,8 +3494,10 @@ xfs_bmap_btalloc_at_eof(
 		if (!caller_pag)
 			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
 		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-		if (!caller_pag)
+		if (!caller_pag) {
 			xfs_perag_put(args->pag);
+			args->pag = NULL;
+		}
 		if (error)
 			return error;
 
@@ -3505,7 +3507,6 @@ xfs_bmap_btalloc_at_eof(
 		 * Exact allocation failed. Reset to try an aligned allocation
 		 * according to the original allocation specification.
 		 */
-		args->pag = NULL;
 		args->alignment = stripe_align;
 		args->minlen = nextminlen;
 		args->minalignslop = 0;


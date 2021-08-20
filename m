Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38BEC4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 05:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778A761029
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 05:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhHTFH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhHTFHZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Aug 2021 01:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3DB61029;
        Fri, 20 Aug 2021 05:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629436008;
        bh=pnYOYaHiyZaEo7r1QPbrERXSpM3BNUF10gC7+JYtgm4=;
        h=Date:From:To:Cc:Subject:From;
        b=fMOtT+bQQmAlJRwQBrPWrWq/Xtbq/PnKsqUrFosoQa2yFgRA/5LPr56j+eLFh+4Dv
         tdsNrKW98xyZCjCKLMd8Np4FAHApLtyHWz5gQZFuWRagjzgGBARDjunu1f6dn9EfEg
         TSo3pL4C2qh1C0lUleF2WNR5SnDOhJb2qF4WXS7VJ5BPp/OERF7/+YS0+xxu0Qz43U
         aEzbzmSENYz1haiWhjIU0lYlu4HZRjs2mu+6v26hdq8ynTpA4ZzXnvnUZx+Kwdu56r
         H3DYC/eSX1kznCWuHJFf7/n73cj9nQjlA5n/T4GtIdbn3YME7Iwb+RKDbqLrfL/cec
         O7v3US/4aip+w==
Date:   Thu, 19 Aug 2021 22:06:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     chandanrlinux@gmail.com, oliver.sang@intel.com
Subject: [PATCH] xfs: fix perag structure refcounting error when scrub fails
Message-ID: <20210820050647.GW12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The kernel test robot found the following bug when running xfs/355 to
scrub a bmap btree:

XFS: Assertion failed: !sa->pag, file: fs/xfs/scrub/common.c, line: 412
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:110!
invalid opcode: 0000 [#1] SMP PTI
CPU: 2 PID: 1415 Comm: xfs_scrub Not tainted 5.14.0-rc4-00021-g48c6615cc557 #1
Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
RIP: 0010:assfail+0x23/0x28 [xfs]
RSP: 0018:ffffc9000aacb890 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffc9000aacbcc8 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc09e7dcd
RBP: ffffc9000aacbc80 R08: ffff8881fdf17d50 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
R13: ffff88820c7ed000 R14: 0000000000000001 R15: ffffc9000aacb980
FS:  00007f185b955700(0000) GS:ffff8881fdf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7f6ef43000 CR3: 000000020de38002 CR4: 00000000001706e0
Call Trace:
 xchk_ag_read_headers+0xda/0x100 [xfs]
 xchk_ag_init+0x15/0x40 [xfs]
 xchk_btree_check_block_owner+0x76/0x180 [xfs]
 xchk_btree_get_block+0xd0/0x140 [xfs]
 xchk_btree+0x32e/0x440 [xfs]
 xchk_bmap_btree+0xd4/0x140 [xfs]
 xchk_bmap+0x1eb/0x3c0 [xfs]
 xfs_scrub_metadata+0x227/0x4c0 [xfs]
 xfs_ioc_scrub_metadata+0x50/0xc0 [xfs]
 xfs_file_ioctl+0x90c/0xc40 [xfs]
 __x64_sys_ioctl+0x83/0xc0
 do_syscall_64+0x3b/0xc0

The unusual handling of errors while initializing struct xchk_ag is the
root cause here.  Since the beginning of xfs_scrub, the goal of
xchk_ag_read_headers has been to read all three AG header buffers and
attach them both to the xchk_ag structure and the scrub transaction.
Corruption errors on any of the three headers doesn't necessarily
trigger an immediate return to userspace, because xfs_scrub can also
tell us to /fix/ the problem.

In other words, it's possible for the xchk_ag init functions to return
an error code and a partially filled out structure so that scrub can use
however much information it managed to pull.  Before 5.15, it was
sufficient to cancel (or commit) the scrub transaction on the way out of
the scrub code to release the buffers.

Ccommit 48c6615cc557 added a reference to the perag structure to struct
xchk_ag.  Since perag structures are not attached to transactions like
buffers are, this adds the requirement that the perag ref be released
explicitly.  The scrub teardown function xchk_teardown was amended to do
this for the xchk_ag embedded in struct xfs_scrub.

Unfortunately, I forgot that certain parts of the scrub code probe
multiple AGs and therefore handle the initialization and cleanup on
their own.  Specifically, the bmbt scrubber will initialize it long
enough to cross-reference AG metadata for btree blocks and for the
extent mappings in the bmbt.

If one of the AG headers is corrupt, the init function returns with a
live perag structure reference and some of the AG header buffers.  If an
error occurs, the cross referencing will be noted as XCORRUPTion and
skipped, but the main scrub process will move on to the next record.
It is now necessary to release the perag reference before we try to
analyze something from a different AG, or else we'll trip over the
assertion noted above.

Fixes: 48c6615cc557 ("xfs: grab active perag ref when reading AG headers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c       |    3 ++-
 fs/xfs/scrub/btree.c      |    3 ++-
 fs/xfs/scrub/fscounters.c |    2 +-
 fs/xfs/scrub/inode.c      |    3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 2df5e5a51cbd..017da9ceaee9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -263,7 +263,7 @@ xchk_bmap_iextent_xref(
 	error = xchk_ag_init_existing(info->sc, agno, &info->sc->sa);
 	if (!xchk_fblock_process_error(info->sc, info->whichfork,
 			irec->br_startoff, &error))
-		return;
+		goto out_free;
 
 	xchk_xref_is_used_space(info->sc, agbno, len);
 	xchk_xref_is_not_inode_chunk(info->sc, agbno, len);
@@ -283,6 +283,7 @@ xchk_bmap_iextent_xref(
 		break;
 	}
 
+out_free:
 	xchk_ag_free(info->sc, &info->sc->sa);
 }
 
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index fd832f103fa4..eccb855dc904 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -377,7 +377,7 @@ xchk_btree_check_block_owner(
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
 				level, &error))
-			return error;
+			goto out_free;
 	}
 
 	xchk_xref_is_used_space(bs->sc, agbno, 1);
@@ -393,6 +393,7 @@ xchk_btree_check_block_owner(
 	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
 		bs->cur = NULL;
 
+out_free:
 	if (init_sa)
 		xchk_ag_free(bs->sc, &bs->sc->sa);
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 737aa5b39d5e..48a6cbdf95d0 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -150,7 +150,7 @@ xchk_fscount_btreeblks(
 
 	error = xchk_ag_init_existing(sc, agno, &sc->sa);
 	if (error)
-		return error;
+		goto out_free;
 
 	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
 	if (error)
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d6e0e3a11fbc..2405b09d03d0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -533,7 +533,7 @@ xchk_inode_xref(
 
 	error = xchk_ag_init_existing(sc, agno, &sc->sa);
 	if (!xchk_xref_process_error(sc, agno, agbno, &error))
-		return;
+		goto out_free;
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_inode_xref_finobt(sc, ino);
@@ -541,6 +541,7 @@ xchk_inode_xref(
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_inode_xref_bmap(sc, dip);
 
+out_free:
 	xchk_ag_free(sc, &sc->sa);
 }
 

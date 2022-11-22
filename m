Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E0DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 00:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiKVAQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 19:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVAQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 19:16:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A3E2FD
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 16:16:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87ED961504
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 00:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3A9C433C1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 00:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669076162;
        bh=lDSHsKoXHSFA7rwvVDEyN7hzlTDPrAKfK2KLD94RVEk=;
        h=Date:From:To:Subject:From;
        b=Y0vT1/+VSf/dRM2LfpJn5B9Yl4JQSeK65YDmKSdAtMRzaP0NFc47bN1Mfmv9KUZ7c
         Rz64wjG3pUaMph3XH0cWh/OMIFmZ9EvBevPAmTOZ55Y/e6CbxcjdUmybWMaDKcLKZF
         3rn496AimRUbfrbp6MwYwUN0QQjmPMEhj5RexAqIzjaHf+HvhyLn3PPTEKVs/xpsOB
         Uo8YeqzZkBH9dVp9zhYfO7P2hXc+tbM71VRLn6mxak6EsgKpp6G4c7ZOwlvI5RZ5gd
         I7q4ljAXMe9j9ryA0fkgOGn8Dy7ADOkQCUU51/jOLoIXVJFo0LpalVEDCR72VsZ7OJ
         mdfS+VPMJNz+Q==
Date:   Mon, 21 Nov 2022 16:16:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: moar weird metadata corruptions, this time on arm64
Message-ID: <Y3wUwvcxijj0oqBl@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've been running near-continuous integration testing of online fsck,
and I've noticed that once a day, one of the ARM VMs will fail the test
with out of order records in the data fork.

xfs/804 races fsstress with online scrub (aka scan but do not change
anything), so I think this might be a bug in the core xfs code.  This
also only seems to trigger if one runs the test for more than ~6 minutes
via TIME_FACTOR=13 or something.
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf

I added a debugging patch to the kernel to check the data fork extents
after taking the ILOCK, before dropping ILOCK, and before and after each
bmapping operation.  So far I've narrowed it down to the delalloc code
inserting a record in the wrong place in the iext tree:

xfs_bmap_add_extent_hole_delay, near line 2691:

	case 0:
		/*
		 * New allocation is not contiguous with another
		 * delayed allocation.
		 * Insert a new entry.
		 */
		oldlen = newlen = 0;
		xfs_iunlock_check_datafork(ip);		<-- ok here
		xfs_iext_insert(ip, icur, new, state);
		xfs_iunlock_check_datafork(ip);		<-- bad here
		break;
	}

But I haven't dug far enough to figure out if the insertion does
anything fancy like rebalance the iext tree nodes.  Will add that
tonight.  Also, curiously, so far this has /only/ reproduced on arm64
with 64k pages.  Regrettably, I also have not yet stood up any long term
soak VMs for ARM64, so I don't even know if this affects TOT 6.1-rcX, or
only djwong-wtf.

Anyway, persisting this to the mailing list in case this rings a bell
for anyone else.

--D

run fstests xfs/804 at 2022-11-21 00:59:48
spectre-v4 mitigation disabled by command-line option
XFS (sda2): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
XFS (sda2): Mounting V5 Filesystem a82f60e2-c283-4008-baf7-617a68397795
XFS (sda2): Ending clean mount
XFS (sda2): EXPERIMENTAL online scrub feature in use. Use at your own risk!
XFS (sda3): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
XFS (sda3): Mounting V5 Filesystem 849fc538-5171-40ae-94bc-542b7236eb9e
XFS (sda3): Ending clean mount
XFS (sda3): Quotacheck needed: Please wait.
XFS (sda3): Quotacheck: Done.
XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk!
XFS (sda3): ino 0x6095c72 nr 0x4 offset 0x6a nextoff 0x85
XFS: Assertion failed: got.br_startoff >= nextoff, file: fs/xfs/xfs_inode.c, line: 136
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2897659 at fs/xfs/xfs_message.c:104 assfail+0x4c/0x5c [xfs]
Modules linked in: xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 rpcsec_gss_krb5 auth_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac nf_tables libcrc32c bfq crct10dif_ce sch_fq_codel fuse configfs efivarfs ip_tables x_tables overlay nfsv4
CPU: 0 PID: 2897659 Comm: fsstress Not tainted 6.1.0-rc6-xfsa #rc6 3e319380b68cffd23e45920c8e84d5a5bad7f2aa
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : assfail+0x4c/0x5c [xfs]
lr : assfail+0x3c/0x5c [xfs]
sp : fffffe000fe4f7d0
x29: fffffe000fe4f7d0 x28: 0000000000000001 x27: fffffe0001650928
x26: fffffe0001650960 x25: 0000000000000a83 x24: fffffe00016367d0
x23: 0000000000000003 x22: 0000000000000004 x21: 0000000000000085
x20: fffffc001dacfa00 x19: fffffc001dacfa40 x18: 0000000000000000
x17: 08000000a57b0800 x16: 8bc8553800000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000010000 x12: 00000000000004dc
x11: fffffe000fe4f700 x10: fffffe00016519d8 x9 : fffffe00816519d7
x8 : 000000000000000a x7 : 00000000ffffffc0 x6 : 0000000000000021
x5 : fffffe00016519d9 x4 : 00000000ffffffca x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 assfail+0x4c/0x5c [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 __xfs_iunlock_check_datafork+0x150/0x29c [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 xfs_bmap_add_extent_hole_delay.constprop.0+0x14c/0x5b4 [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 xfs_bmapi_reserve_delalloc+0x1f4/0x390 [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 xfs_buffered_write_iomap_begin+0x414/0x97c [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 iomap_iter+0x134/0x360
 iomap_file_buffered_write+0x224/0x2d0
 xfs_file_buffered_write+0xc0/0x2f0 [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 xfs_file_write_iter+0x124/0x2c0 [xfs 906731d4aa511f3820f146284d4b72ed26f09c78]
 vfs_write+0x270/0x370
 ksys_write+0x70/0x100
 __arm64_sys_write+0x24/0x30
 do_el0_svc+0x88/0x190
 el0_svc+0x40/0x190
 el0t_64_sync_handler+0xbc/0x140
 el0t_64_sync+0x18c/0x190
---[ end trace 0000000000000000 ]---
XFS (sda3): ino 0x6095c72 func xfs_bmap_add_extent_hole_delay line 2691 data fork:
XFS (sda3):    ino 0x6095c72 nr 0x0 nr_real 0x0 offset 0x26 blockcount 0x4 startblock 0xc119c4 state 0
XFS (sda3):    ino 0x6095c72 nr 0x1 nr_real 0x1 offset 0x2a blockcount 0x26 startblock 0xcc457e state 1
XFS (sda3):    ino 0x6095c72 nr 0x2 nr_real 0x2 offset 0x58 blockcount 0x12 startblock 0xcc45ac state 1
XFS (sda3):    ino 0x6095c72 nr 0x3 nr_real 0x3 offset 0x70 blockcount 0x15 startblock 0xffffffffe0007 state 0
XFS (sda3):    ino 0x6095c72 nr 0x4 nr_real 0x3 offset 0x6a blockcount 0x6 startblock 0xcc45be state 0
XFS (sda3):    ino 0x6095c72 nr 0x5 nr_real 0x4 offset 0xa7 blockcount 0x19 startblock 0x17ff88 state 0
XFS (sda3):    ino 0x6095c72 nr 0x6 nr_real 0x5 offset 0xe8 blockcount 0x8 startblock 0x18004e state 0
XFS (sda3):    ino 0x6095c72 nr 0x7 nr_real 0x6 offset 0x195 blockcount 0x2 startblock 0x410f0e state 0
XFS (sda3):    ino 0x6095c72 nr 0x8 nr_real 0x7 offset 0x1ac blockcount 0x2 startblock 0x41e169 state 0


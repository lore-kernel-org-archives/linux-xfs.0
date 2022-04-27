Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35466C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 18:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiD0Stt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiD0StI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 14:49:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2DFF99E2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 11:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234D8B828AB
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 18:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BC0C385A7;
        Wed, 27 Apr 2022 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651084342;
        bh=JnQKAXYP97q+xIzRd1/wobUCwhVIrzNgJO7AnsUkxtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmkT+3zNS1q7X7v8m+VyI8mNQ4olkGedOfqhoXCO30vlLHxLxj+chKre9PfWxN+H8
         Ifn3H5jI2iLqh2O0I42MYdFJvr2N59y1ZczvD08s7JG+/ie4A/YVImOUMP7/Db/VGO
         bq4XMmMbRNuut5J2+UUEnqJi8db0jB8VcQzipP6p9lDq5CHlXrRYQlF1M5pqBana5W
         SG5BPMqkMrv4TRCwLe1umlUnr5vycY39l1HEI0VH/PUMmzhUBxHNnXgJA57mK3LPP+
         6tTRB3aKgvn1m1BUkjYsYwuZBkFCqP/Q1nJtjTJjQoAC449YQyB23N5gEarK3Bdab7
         jedONT53BLEmw==
Date:   Wed, 27 Apr 2022 11:32:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to a44a027a8b2a
Message-ID: <20220427183222.GJ17025@magnolia>
References: <20220425231714.GK1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425231714.GK1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 09:17:14AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I just pushed out a new for-next branch for the XFS tree. It
> contains:
> 
> - pending fixes for 5.18
> - various miscellaneous fixes
> - xlog_write() rework
> - conversions to unsigned for trace_printk flags
> - large on-disk extent counts
> 
> This all passes my local regression testing, though further smoke
> testing in different environments would be appreaciated.
> 
> I haven't pulled in fixes from late last week yet - I'll work
> through those in the next couple of days to get them into the tree
> as well.
> 
> If I've missed anything you were expecting to see in this update,
> let me know and I'll get them sorted for the next update.

Hmm.  I saw the following crash on an arm64 VM with 64k page size and an
8k blocksize:

run fstests xfs/502 at 2022-04-26 20:54:15
spectre-v4 mitigation disabled by command-line option
XFS (sda2): Mounting V5 Filesystem
XFS (sda2): Ending clean mount
XFS (sda3): Mounting V5 Filesystem
XFS (sda3): Ending clean mount
XFS (sda3): Quotacheck needed: Please wait.
XFS (sda3): Quotacheck: Done.
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
XFS: Assertion failed: IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)), file: fs/xfs/xfs_log_cil.c, line: 431
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3168300 at fs/xfs/xfs_message.c:112 assfail+0x44/0x54 [xfs]
Modules linked in: xfs dm_delay dm_zero dm_flakey dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 rputh_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip6table_filter ip6_tables bfq iptable_filter crct10dif_ce sch_fq_codel efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: xfs]
CPU: 1 PID: 3168300 Comm: t_open_tmpfiles Not tainted 5.17.0-xfsa #5.17.0 0288cc936a4dc1878aaf6a4c6fa6235f949bf1e9
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : assfail+0x44/0x54 [xfs]
lr : assfail+0x34/0x54 [xfs]
sp : fffffe00213ef8b0
x29: fffffe00213ef8b0 x28: 0000000000000000 x27: fffffc0102ce3c00
x26: fffffc013c2bbeb0 x25: fffffc01830d8000 x24: fffffc01bc0d4f70
x23: fffffc01825a41da x22: fffffc01bc0d5020 x21: fffffe00015bf0b8
x20: fffffc006023c000 x19: fffffc0102ce3c00 x18: 0000000000000030
x17: 7a6973202c667562 x16: 5f766c3e2d766c29 x15: 676e6f6c2064656e
x14: 6769736e75282844 x13: 313334203a656e69 x12: 6c202c632e6c6963
x11: fffffe00213ef7d0 x10: fffffe00015bb9d8 x9 : fffffe00815bb9d7
x8 : 000000000000000a x7 : 00000000ffffffc0 x6 : 0000000000000021
x5 : fffffe00015bb9d9 x4 : 00000000ffffffca x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 assfail+0x44/0x54 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xlog_cil_commit+0x328/0x9b0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 __xfs_trans_commit+0xe4/0x3a0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_trans_commit+0x20/0x30 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_create_tmpfile+0x1ec/0x270 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_generic_create+0x324/0x390 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_vn_tmpfile+0x24/0x30 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 vfs_tmpfile+0xbc/0x160
 path_openat+0x9c0/0xeb0
 do_filp_open+0x8c/0x13c
 do_sys_openat2+0xbc/0x170
 __arm64_sys_openat+0x70/0xbc
 invoke_syscall.constprop.0+0x58/0xf0
 do_el0_svc+0x5c/0x160
 el0_svc+0x30/0x15c
 el0t_64_sync_handler+0x1a8/0x1b0
 el0t_64_sync+0x1a0/0x1a4
---[ end trace 0000000000000000 ]---
Unable to handle kernel paging request at virtual address 9ac7c01eb06874e8
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
[9ac7c01eb06874e8] address between user and kernel address ranges
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: xfs dm_delay dm_zero dm_flakey dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 rputh_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip6table_filter ip6_tables bfq iptable_filter crct10dif_ce sch_fq_codel efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: xfs]
CPU: 1 PID: 3168300 Comm: t_open_tmpfiles Tainted: G        W         5.17.0-xfsa #5.17.0 0288cc936a4dc1878aaf6a4c6fa6235f949bf1e9
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
pstate: a0401005 (NzCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : __kmalloc+0x120/0x3f0
lr : __kmalloc+0xe8/0x3f0
sp : fffffe00213ef840
x29: fffffe00213ef840 x28: 0000000000000002 x27: fffffe0008fe6000
x26: fffffc00e8740000 x25: fffffe00090e9000 x24: fffffe0001523c44
x23: 0000000000000150 x22: 00000000000128c0 x21: 0000000000000000
x20: 9ac7c01eb06874e8 x19: fffffc00e0010400 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000f0ffffffffff x12: 0000000000000040
x11: fffffc0133b5c678 x10: fffffc0133b5c67a x9 : fffffe0008294814
x8 : 0000000000000001 x7 : fffffe01f68d0000 x6 : 8d4857517c5941da
x5 : 00000000019ff6ec x4 : 0000000000000100 x3 : 0000000000000000
x2 : e87468b01ec0c79a x1 : 0000000003a724a9 x0 : 9ac7c01eb06873e8
Call trace:
 __kmalloc+0x120/0x3f0
 xlog_cil_commit+0x144/0x9b0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 __xfs_trans_commit+0xe4/0x3a0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_trans_commit+0x20/0x30 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_create_tmpfile+0x1ec/0x270 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_generic_create+0x324/0x390 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 xfs_vn_tmpfile+0x24/0x30 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
 vfs_tmpfile+0xbc/0x160
 path_openat+0x9c0/0xeb0
 do_filp_open+0x8c/0x13c
 do_sys_openat2+0xbc/0x170
 __arm64_sys_openat+0x70/0xbc
 invoke_syscall.constprop.0+0x58/0xf0
 do_el0_svc+0x5c/0x160
 el0_svc+0x30/0x15c
 el0t_64_sync_handler+0x1a8/0x1b0
 el0t_64_sync+0x1a0/0x1a4
Code: f9405e66 8b040014 dac00e82 b9400b43 (f8646814) 

Not sure what's going on there, but I'll add it to the list of things to
dig into.

--D

> 
> Cheers,
> 
> Dave.
> 
> ---------------------------------------------------------------
> 
> Head commit:
> 
> a44a027a8b2a Merge tag 'large-extent-counters-v9' of https://github.com/chandanr/linux into xfs-5.19-for-next
> 
> ----------------------------------------------------------------
> Chandan Babu R (19):
>       xfs: Move extent count limits to xfs_format.h
>       xfs: Define max extent length based on on-disk format definition
>       xfs: Introduce xfs_iext_max_nextents() helper
>       xfs: Use xfs_extnum_t instead of basic data types
>       xfs: Introduce xfs_dfork_nextents() helper
>       xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
>       xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
>       xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
>       xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
>       xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
>       xfs: Use uint64_t to count maximum blocks that can be used by BMBT
>       xfs: Introduce macros to represent new maximum extent counts for data/attr forks
>       xfs: Replace numbered inode recovery error messages with descriptive ones
>       xfs: Introduce per-inode 64-bit extent counters
>       xfs: Directory's data fork extent counter can never overflow
>       xfs: Conditionally upgrade existing inodes to use large extent counters
>       xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
>       xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
>       xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
> 
> Christoph Hellwig (2):
>       xfs: change the type of ic_datap
>       xfs: remove xlog_verify_dest_ptr
> 
> Darrick J. Wong (3):
>       xfs: pass explicit mount pointer to rtalloc query functions
>       xfs: recalculate free rt extents after log recovery
>       xfs: use a separate frextents counter for rt extent reservations
> 
> Dave Chinner (36):
>       xfs: convert buffer flags to unsigned.
>       xfs: reorder iunlink remove operation in xfs_ifree
>       xfs: factor out the CIL transaction header building
>       xfs: only CIL pushes require a start record
>       xfs: embed the xlog_op_header in the unmount record
>       xfs: embed the xlog_op_header in the commit record
>       xfs: log tickets don't need log client id
>       xfs: move log iovec alignment to preparation function
>       xfs: reserve space and initialise xlog_op_header in item formatting
>       xfs: log ticket region debug is largely useless
>       xfs: pass lv chain length into xlog_write()
>       xfs: introduce xlog_write_full()
>       xfs: introduce xlog_write_partial()
>       xfs: xlog_write() no longer needs contwr state
>       xfs: xlog_write() doesn't need optype anymore
>       xfs: CIL context doesn't need to count iovecs
>       xfs: convert attr type flags to unsigned.
>       xfs: convert scrub type flags to unsigned.
>       xfs: convert bmap extent type flags to unsigned.
>       xfs: convert bmapi flags to unsigned.
>       xfs: convert AGF log flags to unsigned.
>       xfs: convert AGI log flags to unsigned.
>       xfs: convert btree buffer log flags to unsigned.
>       xfs: convert buffer log item flags to unsigned.
>       xfs: convert da btree operations flags to unsigned.
>       xfs: convert dquot flags to unsigned.
>       xfs: convert log item tracepoint flags to unsigned.
>       xfs: convert inode lock flags to unsigned.
>       xfs: convert ptag flags to unsigned.
>       xfs: convert quota options flags to unsigned.
>       xfs: convert shutdown reasons to unsigned.
>       xfs: convert log ticket and iclog flags to unsigned.
>       Merge branch 'guilt/5.19-miscellaneous' into xfs-5.19-for-next
>       Merge branch 'guilt/xfs-unsigned-flags-5.18' into xfs-5.19-for-next
>       Merge branch 'guilt/xlog-write-rework' into xfs-5.19-for-next
>       Merge tag 'large-extent-counters-v9' of https://github.com/chandanr/linux into xfs-5.19-for-next
> 
> Jonathan Lassoff (2):
>       xfs: Simplify XFS logging methods.
>       xfs: Add XFS messages to printk index
> 
> Kaixu Xia (1):
>       xfs: simplify local variable assignment in file write code
> 
> Matthew Wilcox (Oracle) (1):
>       xfs: Use generic_file_open()
> 
> Tiezhu Yang (1):
>       MAINTAINERS: update IOMAP FILESYSTEM LIBRARY and XFS FILESYSTEM
> 
>  MAINTAINERS                     |   3 -
>  fs/xfs/libxfs/xfs_alloc.c       |  12 +-
>  fs/xfs/libxfs/xfs_alloc.h       |   2 +-
>  fs/xfs/libxfs/xfs_attr.c        |   3 +
>  fs/xfs/libxfs/xfs_bmap.c        | 145 +++++++++-----------
>  fs/xfs/libxfs/xfs_bmap.h        |  58 ++++----
>  fs/xfs/libxfs/xfs_bmap_btree.c  |   9 +-
>  fs/xfs/libxfs/xfs_btree.c       |  10 +-
>  fs/xfs/libxfs/xfs_btree.h       |  26 ++--
>  fs/xfs/libxfs/xfs_da_btree.h    |  17 +--
>  fs/xfs/libxfs/xfs_da_format.h   |   9 +-
>  fs/xfs/libxfs/xfs_dir2.c        |   8 ++
>  fs/xfs/libxfs/xfs_format.h      | 180 ++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_fs.h          |  41 ++++--
>  fs/xfs/libxfs/xfs_ialloc.c      |   8 +-
>  fs/xfs/libxfs/xfs_ialloc.h      |   2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c   |  83 +++++++++---
>  fs/xfs/libxfs/xfs_inode_fork.c  |  39 +++++-
>  fs/xfs/libxfs/xfs_inode_fork.h  |  76 +++++++++--
>  fs/xfs/libxfs/xfs_log_format.h  |  34 ++++-
>  fs/xfs/libxfs/xfs_quota_defs.h  |  49 ++++---
>  fs/xfs/libxfs/xfs_rtbitmap.c    |   9 +-
>  fs/xfs/libxfs/xfs_sb.c          |  10 ++
>  fs/xfs/libxfs/xfs_trans_resv.c  |  11 +-
>  fs/xfs/libxfs/xfs_types.h       |  11 +-
>  fs/xfs/scrub/bmap.c             |   2 +-
>  fs/xfs/scrub/inode.c            |  20 +--
>  fs/xfs/scrub/rtbitmap.c         |   9 +-
>  fs/xfs/xfs_bmap_item.c          |   2 +
>  fs/xfs/xfs_bmap_util.c          |  27 +++-
>  fs/xfs/xfs_buf.c                |   6 +-
>  fs/xfs/xfs_buf.h                |  42 +++---
>  fs/xfs/xfs_buf_item.h           |  24 ++--
>  fs/xfs/xfs_dquot.c              |   3 +
>  fs/xfs/xfs_error.h              |  20 +--
>  fs/xfs/xfs_file.c               |  24 ++--
>  fs/xfs/xfs_fsmap.c              |   6 +-
>  fs/xfs/xfs_fsops.c              |   7 +-
>  fs/xfs/xfs_icache.c             |   9 +-
>  fs/xfs/xfs_inode.c              | 104 ++++-----------
>  fs/xfs/xfs_inode.h              |  29 ++--
>  fs/xfs/xfs_inode_item.c         |  23 +++-
>  fs/xfs/xfs_inode_item_recover.c | 141 ++++++++++++++------
>  fs/xfs/xfs_ioctl.c              |   3 +
>  fs/xfs/xfs_iomap.c              |  33 +++--
>  fs/xfs/xfs_itable.c             |  15 ++-
>  fs/xfs/xfs_itable.h             |   5 +-
>  fs/xfs/xfs_iwalk.h              |   2 +-
>  fs/xfs/xfs_log.c                | 766 +++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
>  fs/xfs/xfs_log.h                |  57 +++-----
>  fs/xfs/xfs_log_cil.c            | 169 ++++++++++++++++--------
>  fs/xfs/xfs_log_priv.h           |  55 ++------
>  fs/xfs/xfs_message.c            |  58 ++++----
>  fs/xfs/xfs_message.h            |  55 +++++---
>  fs/xfs/xfs_mount.c              |  91 +++++++------
>  fs/xfs/xfs_mount.h              |  32 +++--
>  fs/xfs/xfs_reflink.c            |   5 +
>  fs/xfs/xfs_rtalloc.c            |  41 ++++++
>  fs/xfs/xfs_rtalloc.h            |   9 +-
>  fs/xfs/xfs_super.c              |  18 ++-
>  fs/xfs/xfs_symlink.c            |   5 -
>  fs/xfs/xfs_trace.h              |  28 +---
>  fs/xfs/xfs_trans.c              |  49 +++++--
>  fs/xfs/xfs_trans.h              |  10 +-
>  64 files changed, 1585 insertions(+), 1274 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfEICL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 22:11:28 -0400
Date: Wed, 8 May 2019 19:11:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f00b8b784f75
Message-ID: <20190509021105.GA5335@magnolia>
References: <20190501150513.GJ5207@magnolia>
 <20190509020538.GF32512@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509020538.GF32512@dhcp-12-102.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, May 09, 2019 at 10:05:38AM +0800, Zorro Lang wrote:
> On Wed, May 01, 2019 at 08:05:13AM -0700, Darrick J. Wong wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs-linux repository at:
> > 
> > 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > 
> > has just been updated.
> > 
> > Patches often get missed, so please check if your outstanding patches
> > were in this update. If they have not been in this update, please
> > resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> > the next update.  This is yesterday's for-next branch with the iomap
> > branch merged in; if you want /only/ one branch or the other, please see
> > either of the {iomap,xfs}-5.2-merge branches.
> > 
> > The new head of the for-next branch is commit:
> > 
> > f00b8b784f75 Merge remote-tracking branch 'korg/iomap-5.2-merge' into for-next
> 
> Hi,
> 
> Sorry I'm just back from holiday, so just checked the testing results.
> By a quick glance, I find a panic[1] triggered by g/475 on 512b blocksize XFS,
> on ppc64le. I just hit it once for now. I'm trying to check other test jobs at
> first.

FWIW It's all been absorbed upstream now, so whatever it is I guess it's
now a bugfix.

(he says running for the exits)

((see you all in a week and a half))

(((vacation at last!)))

((((fault: grammar chekar offline))))

--D

> PS: the kernel HEAD is commit 8869a2d297cbad848b3a766726adadcaf42d6b60.
> 
> Thanks,
> Zorro
> 
> [1]
> [38127.528417] run fstests generic/475 at 2019-05-08 16:57:45 
> [38131.969803] XFS (dm-0): Mounting V4 Filesystem 
> [38132.157071] XFS (dm-0): Ending clean mount 
> [38132.290780] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len 1 error 5 
> [38132.293045] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len 1 error 5 
> [38132.293364] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x780002 len 1 error 5
> ...
> ...
> [38273.205646] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x16e len 1 error 117 
> [38274.081793] XFS (dm-0): writeback error on sector 7899469 
> [38274.083323] XFS (dm-0): writeback error on sector 72178 
> [38274.083574] XFS (dm-0): writeback error on sector 23615434 
> [38274.083695] XFS (dm-0): writeback error on sector 23615555 
> [38274.083811] XFS (dm-0): writeback error on sector 23655020 
> [38274.084199] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.084857] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.085149] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.085419] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.085772] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.086222] XFS (dm-0): metadata I/O error in "xlog_iodone" at daddr 0xf01604 len 64 error 5 
> [38274.086359] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2441 len 1 error 5 
> [38274.087887] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1272 of file fs/xfs/xfs_log.c. Return address = 0000000008c67e4a 
> [38274.088115] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
> [38274.088267] XFS (dm-0): Please unmount the filesystem and rectify the problem(s) 
> [38274.483973] XFS (dm-0): Unmounting Filesystem 
> [38275.350297] XFS (dm-0): Mounting V4 Filesystem 
> [38275.581566] XFS (dm-0): Starting recovery (logdev: internal) 
> [38276.712742] XFS (dm-0): Ending recovery (logdev: internal) 
> [38277.787662] XFS (dm-0): writeback error on sector 15819152 
> [38277.790479] XFS (dm-0): writeback error on sector 15819387 
> [38277.790794] XFS (dm-0): writeback error on sector 15819486 
> [38277.791125] XFS (dm-0): metadata I/O error in "xlog_iodone" at daddr 0xf0169d len 64 error 5 
> [38277.791127] XFS (dm-0): writeback error on sector 11166 
> [38277.791546] XFS (dm-0): writeback error on sector 11197 
> [38277.795252] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1272 of file fs/xfs/xfs_log.c. Return address = 0000000008c67e4a 
> [38277.795616] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
> [38277.795822] XFS (dm-0): Please unmount the filesystem and rectify the problem(s) 
> [38277.815260] buffer_io_error: 246 callbacks suppressed 
> [38277.815267] Buffer I/O error on dev dm-0, logical block 31457152, async page read 
> [38277.815530] Buffer I/O error on dev dm-0, logical block 31457153, async page read 
> [38277.815721] Buffer I/O error on dev dm-0, logical block 31457154, async page read 
> [38277.815871] Buffer I/O error on dev dm-0, logical block 31457155, async page read 
> [38277.816021] Buffer I/O error on dev dm-0, logical block 31457156, async page read 
> [38277.816165] Buffer I/O error on dev dm-0, logical block 31457157, async page read 
> [38277.816314] Buffer I/O error on dev dm-0, logical block 31457158, async page read 
> [38277.816460] Buffer I/O error on dev dm-0, logical block 31457159, async page read 
> [38277.816604] Buffer I/O error on dev dm-0, logical block 31457160, async page read 
> [38277.816744] Buffer I/O error on dev dm-0, logical block 31457161, async page read 
> [38278.151524] XFS (dm-0): Unmounting Filesystem 
> [38278.990126] XFS (dm-0): Mounting V4 Filesystem 
> [38279.239939] XFS (dm-0): Starting recovery (logdev: internal) 
> [38280.643678] XFS (dm-0): Ending recovery (logdev: internal) 
> [38281.099327] XFS (dm-0): Metadata corruption detected at xfs_attr3_leaf_verify+0x1b8/0x250 [xfs], xfs_attr3_leaf block 0x16e  
> [38281.101275] XFS (dm-0): Unmount and run xfs_repair 
> [38281.101853] XFS (dm-0): First 128 bytes of corrupted metadata buffer: 
> [38281.102064] 00000000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................ 
> [38281.102232] 00000010: 02 00 00 00 00 20 01 e0 00 00 00 00 00 00 00 00  ..... .......... 
> [38281.102408] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103038] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103169] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103302] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103439] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103565] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................ 
> [38281.103733] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x16e len 1 error 117 
> [38281.567271] BUG: Kernel NULL pointer dereference at 0x00000012 
> [38281.567714] Faulting instruction address: 0xd00000000748e4ec 
> [38281.568044] Oops: Kernel access of bad area, sig: 11 [#1] 
> [38281.568178] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries 
> [38281.568354] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg dm_snapshot dm_bufio loop dm_flakey dm_mod sunrpc xts vmx_crypto virtio_balloon ext4 mbcache jbd2 xfs libcrc32c virtio_net net_failover virtio_console virtio_blk failover [last unloaded: scsi_debug] 
> [38281.568900] CPU: 2 PID: 11158 Comm: fsstress Tainted: G        W         5.1.0-rc5+ #1 
> [38281.569048] NIP:  d00000000748e4ec LR: d00000000748e454 CTR: c0000000001fc640 
> [38281.569195] REGS: c0000002eb85b2d0 TRAP: 0300   Tainted: G        W          (5.1.0-rc5+) 
> [38281.569354] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24004442  XER: 20000000 
> [38281.569551] CFAR: 00007fff9e9c5008 DAR: 0000000000000012 DSISR: 40000000 IRQMASK: 0  
> [38281.569551] GPR00: d00000000748e454 c0000002eb85b560 d000000007613700 0000000000000001  
> [38281.569551] GPR04: 000000000000000c 0000000000000001 c0000002eb85b698 c0000002eb85b694  
> [38281.569551] GPR08: c000000001c49c70 d001f7ffff447200 0000000000000013 0000000000000000  
> [38281.569551] GPR12: c0000000001fc640 c00000003fffd680 00000000000126d8 c0000003f32c0000  
> [38281.569551] GPR16: 0000000000000036 c0000003f3300000 000000000000025f c0000003f32c0050  
> [38281.569551] GPR20: c0000003f32c0000 0000000000000088 0000000000000001 d0000000074a2804  
> [38281.569551] GPR24: c0000002eb85b694 c0000002eb85b750 c0000002eb85b744 d0000000074a0594  
> [38281.569551] GPR28: 0000000000000000 0000000000000004 0000000000000001 c000000352189600  
> [38281.570939] NIP [d00000000748e4ec] xfs_bmapi_read+0x134/0x4c0 [xfs] 
> [38281.571153] LR [d00000000748e454] xfs_bmapi_read+0x9c/0x4c0 [xfs] 
> [38281.571260] Call Trace: 
> [38281.571325] [c0000002eb85b560] [c0000002eb85b690] 0xc0000002eb85b690 (unreliable) 
> [38281.571535] [c0000002eb85b620] [d0000000074a0594] xfs_dabuf_map.constprop.9+0x1dc/0x4e0 [xfs] 
> [38281.571807] [c0000002eb85b720] [d0000000074a2804] xfs_da_read_buf+0x8c/0x190 [xfs] 
> [38281.572014] [c0000002eb85b7b0] [d0000000074a2954] xfs_da3_node_read+0x4c/0x190 [xfs] 
> [38281.572256] [c0000002eb85b800] [d0000000074effec] xfs_attr_inactive+0x254/0x398 [xfs] 
> [38281.572464] [c0000002eb85b860] [d000000007529368] xfs_inactive+0x290/0x320 [xfs] 
> [38281.572703] [c0000002eb85b8a0] [d000000007538598] xfs_fs_destroy_inode+0x120/0x458 [xfs] 
> [38281.572946] [c0000002eb85b8f0] [c000000000505408] destroy_inode+0x68/0xb0 
> [38281.573161] [c0000002eb85b920] [d00000000752acf0] xfs_irele+0x1b8/0x270 [xfs] 
> [38281.573363] [c0000002eb85b970] [d00000000752cc14] xfs_bulkstat_one_int+0x22c/0x410 [xfs] 
> [38281.573609] [c0000002eb85b9f0] [d00000000752d16c] xfs_bulkstat+0x344/0x770 [xfs] 
> [38281.573825] [c0000002eb85baf0] [d000000007515ab4] xfs_ioc_bulkstat+0xec/0x220 [xfs] 
> [38281.574025] [c0000002eb85bb70] [d00000000751a2f0] xfs_file_ioctl+0x9d8/0xff8 [xfs] 
> [38281.574177] [c0000002eb85bd00] [c0000000004f67e4] do_vfs_ioctl+0xe4/0x950 
> [38281.574300] [c0000002eb85bdb0] [c0000000004f7114] ksys_ioctl+0xc4/0x110 
> [38281.574420] [c0000002eb85be00] [c0000000004f7188] sys_ioctl+0x28/0x80 
> [38281.574529] [c0000002eb85be20] [c00000000000b488] system_call+0x5c/0x70 
> [38281.574651] Instruction dump: 
> [38281.574738] 7d48502a e93c0ea8 7d295214 81490020 394a0001 91490020 4196021c 2f9e0001  
> [38281.574893] 419e02f4 eb9f0040 2fbc0000 419e0338 <893c0012> 71290002 4082001c 7fc5f378  
> [38281.575071] ---[ end trace a44956bdce233206 ]--- 
> [38281.615022]  
> [38281.803575] XFS (dm-0): writeback error on sector 23649191 
> [38281.804153] XFS (dm-0): writeback error on sector 23648191 
> [38281.804302] XFS (dm-0): metadata I/O error in "xlog_iodone" at daddr 0xf0171d len 64 error 5 
> [38281.804639] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1272 of file fs/xfs/xfs_log.c. Return address = 0000000008c67e4a 
> [38281.804819] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
> [38281.804942] XFS (dm-0): Please unmount the filesystem and rectify the problem(s) 
> [38281.805146] XFS (dm-0): writeback error on sector 23665073 
> [38281.805241] XFS (dm-0): writeback error on sector 23609393 
> [38281.805376] XFS (dm-0): writeback error on sector 23615548 
> 
> > 
> > New Commits:
> > 
> > Andreas Gruenbacher (3):
> >       [26ddb1f4fd88] fs: Turn __generic_write_end into a void function
> >       [7a77dad7e3be] iomap: Fix use-after-free error in page_done callback
> >       [df0db3ecdb8f] iomap: Add a page_prepare callback
> > 
> > Brian Foster (7):
> >       [4d09807f2046] xfs: fix use after free in buf log item unlock assert
> >       [545aa41f5cba] xfs: wake commit waiters on CIL abort before log item abort
> >       [22fedd80b652] xfs: shutdown after buf release in iflush cluster abort path
> >       [1ca89fbc48e1] xfs: don't account extra agfl blocks as available
> >       [945c941fcd82] xfs: make tr_growdata a permanent transaction
> >       [362f5e745ae2] xfs: assert that we don't enter agfl freeing with a non-permanent transaction
> >       [1749d1ea89bd] xfs: add missing error check in xfs_prepare_shift()
> > 
> > Christoph Hellwig (3):
> >       [73ce6abae5f9] iomap: convert to SPDX identifier
> >       [94079285756d] xfs: don't parse the mtpt mount option
> >       [dbc582b6fb6a] iomap: Clean up __generic_write_end calling
> > 
> > Darrick J. Wong (28):
> >       [6772c1f11206] xfs: track metadata health status
> >       [39353ff6e96f] xfs: replace the BAD_SUMMARY mount flag with the equivalent health code
> >       [519841c207de] xfs: clear BAD_SUMMARY if unmounting an unhealthy filesystem
> >       [7cd5006bdb6f] xfs: add a new ioctl to describe allocation group geometry
> >       [c23232d40935] xfs: report fs and rt health via geometry structure
> >       [1302c6a24fd9] xfs: report AG health via AG geometry ioctl
> >       [89d139d5ad46] xfs: report inode health via bulkstat
> >       [9d71e15586fd] xfs: refactor scrub context initialization
> >       [f8c2a2257ca1] xfs: collapse scrub bool state flags into a single unsigned int
> >       [160b5a784525] xfs: hoist the already_fixed variable to the scrub context
> >       [4860a05d2475] xfs: scrub/repair should update filesystem metadata health
> >       [4fb7951fde64] xfs: scrub should only cross-reference with healthy btrees
> >       [cb357bf3d105] xfs: implement per-inode writeback completion queues
> >       [28408243706e] xfs: remove unused m_data_workqueue
> >       [3994fc489575] xfs: merge adjacent io completions of the same type
> >       [1fdeaea4d92c] xfs: abort unaligned nowait directio early
> >       [903b1fc2737f] xfs: widen quota block counters to 64-bit integers
> >       [394aafdc15da] xfs: widen inode delalloc block counter to 64-bits
> >       [078f4a7d3109] xfs: kill the xfs_dqtrx_t typedef
> >       [3de5eab3fde1] xfs: unlock inode when xfs_ioctl_setattr_get_trans can't get transaction
> >       [f60be90fc9a9] xfs: fix broken bhold behavior in xrep_roll_ag_trans
> >       [9fe82b8c422b] xfs: track delayed allocation reservations across the filesystem
> >       [ed30dcbd901c] xfs: rename the speculative block allocation reclaim toggle functions
> >       [9a1f3049f473] xfs: allow scrubbers to pause background reclaim
> >       [47cd97b5b239] xfs: scrub should check incore counters against ondisk headers
> >       [710d707d2fa9] xfs: always rejoin held resources during defer roll
> >       [75efa57d0bf5] xfs: add online scrub for superblock counters
> >       [f00b8b784f75] Merge remote-tracking branch 'korg/iomap-5.2-merge' into for-next
> > 
> > Dave Chinner (1):
> >       [1b6d968de22b] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures
> > 
> > Wang Shilong (1):
> >       [2bf9d264efed] xfs,fstrim: fix to return correct minlen
> > 
> > 
> > Code Diffstat:
> > 
> >  fs/buffer.c                    |   8 +-
> >  fs/gfs2/bmap.c                 |  15 +-
> >  fs/internal.h                  |   2 +-
> >  fs/iomap.c                     |  65 ++++---
> >  fs/xfs/Makefile                |   3 +
> >  fs/xfs/libxfs/xfs_ag.c         |  54 ++++++
> >  fs/xfs/libxfs/xfs_ag.h         |   2 +
> >  fs/xfs/libxfs/xfs_alloc.c      |  13 +-
> >  fs/xfs/libxfs/xfs_attr.c       |  35 ++--
> >  fs/xfs/libxfs/xfs_attr.h       |   2 +-
> >  fs/xfs/libxfs/xfs_bmap.c       |  17 +-
> >  fs/xfs/libxfs/xfs_defer.c      |  14 +-
> >  fs/xfs/libxfs/xfs_fs.h         | 139 +++++++++++----
> >  fs/xfs/libxfs/xfs_health.h     | 190 ++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_sb.c         |  10 +-
> >  fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
> >  fs/xfs/libxfs/xfs_types.c      |   2 +-
> >  fs/xfs/libxfs/xfs_types.h      |   2 +
> >  fs/xfs/scrub/agheader.c        |  20 +++
> >  fs/xfs/scrub/common.c          |  47 ++++-
> >  fs/xfs/scrub/common.h          |   4 +
> >  fs/xfs/scrub/fscounters.c      | 366 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/health.c          | 237 +++++++++++++++++++++++++
> >  fs/xfs/scrub/health.h          |  14 ++
> >  fs/xfs/scrub/ialloc.c          |   4 +-
> >  fs/xfs/scrub/parent.c          |   2 +-
> >  fs/xfs/scrub/quota.c           |   2 +-
> >  fs/xfs/scrub/repair.c          |  34 ++--
> >  fs/xfs/scrub/repair.h          |   5 +-
> >  fs/xfs/scrub/scrub.c           |  49 ++++--
> >  fs/xfs/scrub/scrub.h           |  27 ++-
> >  fs/xfs/scrub/trace.h           |  63 ++++++-
> >  fs/xfs/xfs_aops.c              | 135 ++++++++++++--
> >  fs/xfs/xfs_aops.h              |   1 -
> >  fs/xfs/xfs_bmap_util.c         |   2 +
> >  fs/xfs/xfs_buf_item.c          |   4 +-
> >  fs/xfs/xfs_discard.c           |   3 +-
> >  fs/xfs/xfs_dquot.c             |  17 +-
> >  fs/xfs/xfs_file.c              |   6 +-
> >  fs/xfs/xfs_health.c            | 392 +++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_icache.c            |  11 +-
> >  fs/xfs/xfs_icache.h            |   4 +-
> >  fs/xfs/xfs_inode.c             |   4 +-
> >  fs/xfs/xfs_inode.h             |  17 +-
> >  fs/xfs/xfs_ioctl.c             |  55 +++---
> >  fs/xfs/xfs_ioctl32.c           |   4 +-
> >  fs/xfs/xfs_itable.c            |   2 +
> >  fs/xfs/xfs_log.c               |   3 +-
> >  fs/xfs/xfs_log_cil.c           |  21 ++-
> >  fs/xfs/xfs_mount.c             |  35 +++-
> >  fs/xfs/xfs_mount.h             |  32 +++-
> >  fs/xfs/xfs_qm.c                |   3 +-
> >  fs/xfs/xfs_qm.h                |   8 +-
> >  fs/xfs/xfs_quota.h             |  37 ++--
> >  fs/xfs/xfs_super.c             |  33 ++--
> >  fs/xfs/xfs_trace.h             |  76 ++++++++
> >  fs/xfs/xfs_trans_dquot.c       |  52 +++---
> >  include/linux/iomap.h          |  22 ++-
> >  58 files changed, 2130 insertions(+), 302 deletions(-)
> >  create mode 100644 fs/xfs/libxfs/xfs_health.h
> >  create mode 100644 fs/xfs/scrub/fscounters.c
> >  create mode 100644 fs/xfs/scrub/health.c
> >  create mode 100644 fs/xfs/scrub/health.h
> >  create mode 100644 fs/xfs/xfs_health.c

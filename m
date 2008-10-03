Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 23:33:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m936XGJC007280
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 23:33:17 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D3534A9CDB
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 23:34:52 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170]) by cuda.sgi.com with ESMTP id a4homfsmnFqgYvlN for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 23:34:52 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so1486793wfd.32
        for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 23:34:52 -0700 (PDT)
Message-ID: <50ed5c760810022334j69befdb9pa0bf5ec29aad9126@mail.gmail.com>
Date: Fri, 3 Oct 2008 08:34:52 +0200
From: "=?ISO-8859-2?Q?S=B3awomir_Nowakowski?=" <nailman23@gmail.com>
Subject: XFS on 2.6.25.17 kernel issue
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear All,

We use kernel 2.6.25.17, Promise STEX 8650 RAID controller, LVM2 and
snapshots. After about 3 hours of working (using SAMBA, RSYNC etc)
dmesg showed following errors:

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1546 of file
fs/xfs/xfs_alloc.c.  Caller 0xc024f387
Pid: 16557, comm: smbd Not tainted 2.6.25.17-oe32-00000-g553425c #18
 [<c024e15e>] xfs_free_ag_extent+0x2fe/0x670
 [<c024f387>] xfs_free_extent+0xc7/0xf0
 [<c024f387>] xfs_free_extent+0xc7/0xf0
 [<c0261a2b>] xfs_bmap_finish+0xdb/0x160
 [<c0282a70>] xfs_itruncate_finish+0x240/0x3d0
 [<c029f042>] xfs_inactive+0x3f2/0x460
 [<c019b917>] inotify_inode_is_dead+0x17/0x70
 [<c02ac83e>] xfs_fs_clear_inode+0x8e/0xd0
 [<c0185a23>] clear_inode+0xb3/0x140
 [<c0186692>] generic_delete_inode+0xe2/0x120
 [<c01868b4>] iput+0x54/0x60
 [<c017d269>] do_unlinkat+0xd9/0x130
 [<c0103a42>] syscall_call+0x7/0xb
 [<c0510000>] abituguru_detect_no_pwms+0xc0/0x260
 =======================
xfs_force_shutdown(dm-6,0x8) called from line 4258 of file
fs/xfs/xfs_bmap.c.  Return address = 0xc0261a9b
Filesystem "dm-6": Corruption of in-memory data detected.  Shutting down
filesystem: dm-6
Please umount the filesystem, and rectify the problem(s)
Filesystem "dm-8": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-8
Starting XFS recovery on filesystem: dm-8 (logdev: internal)
XFS resetting qflags for filesystem dm-8
Ending XFS recovery on filesystem: dm-8 (logdev: internal)
program scsiinfo is using a deprecated SCSI ioctl, please convert it to
SG_IO
program scsiinfo is using a deprecated SCSI ioctl, please convert it to
SG_IO
program scsiinfo is using a deprecated SCSI ioctl, please convert it to
SG_IO
xfs_force_shutdown(dm-6,0x1) called from line 420 of file
fs/xfs/xfs_rw.c.  Return address = 0xc02a2be0

and after rebooting of the system:

Filesystem "dm-6": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-6
Starting XFS recovery on filesystem: dm-6 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1546 of file
fs/xfs/xfs_alloc.c.  Caller 0xc024f387
Pid: 10396, comm: mount Not tainted 2.6.25.17-oe32-00000-g553425c #18
 [<c024e15e>] xfs_free_ag_extent+0x2fe/0x670
 [<c024f387>] xfs_free_extent+0xc7/0xf0
 [<c024f387>] xfs_free_extent+0xc7/0xf0
 [<c017053a>] cache_alloc_refill+0xca/0x1f0
 [<c029a62b>] xfs_trans_log_efd_extent+0xb/0x40
 [<c0291376>] xlog_recover_process_efi+0x1c6/0x240
 [<c029142b>] xlog_recover_process_efis+0x3b/0x60
 [<c0292844>] xlog_recover_finish+0x14/0x90
 [<c028a9df>] xfs_log_mount_finish+0x2f/0x40
 [<c0294451>] xfs_mountfs+0x301/0x650
 [<c02ad54e>] icmn_err+0x6e/0x90
 [<c02a2de8>] kmem_alloc+0x58/0xe0
 [<c0295e94>] xfs_mru_cache_create+0xf4/0x160
 [<c029bd8a>] xfs_mount+0x1fa/0x370
 [<c02ad0ad>] xfs_fs_fill_super+0xad/0x1e0
 [<c0175632>] get_sb_bdev+0xe2/0x110
 [<c0156dd9>] __alloc_pages+0x49/0x330
 [<c02ad1f2>] xfs_fs_get_sb+0x12/0x20
 [<c02ad000>] xfs_fs_fill_super+0x0/0x1e0
 [<c0175818>] vfs_kern_mount+0x58/0x110
 [<c017597a>] do_kern_mount+0x2a/0x70
 [<c018934e>] do_new_mount+0x5e/0x90
 [<c01898d6>] do_mount+0x176/0x190
 [<c0189b71>] sys_mount+0x71/0xb0
 [<c0103a42>] syscall_call+0x7/0xb
 =======================
Filesystem "dm-6": corrupt dinode 680795173, (btree extents).  Unmount
and run xfs_repair.
Filesystem "dm-6": XFS internal error xfs_bmap_read_extents(1) at line
4549 of file fs/xfs/xfs_bmap.c.  Caller 0xc0282091
Pid: 10396, comm: mount Not tainted 2.6.25.17-oe32-00000-g553425c #18
 [<c0262366>] xfs_bmap_read_extents+0x466/0x4b0
 [<c0282091>] xfs_iread_extents+0x61/0xb0
 [<c02853cb>] xfs_iext_inline_to_direct+0x1b/0x80
 [<c028531a>] xfs_iext_realloc_direct+0xba/0x100
 [<c0282091>] xfs_iread_extents+0x61/0xb0
 [<c0264803>] xfs_bunmapi+0xc23/0x1150
 [<c0156add>] buffered_rmqueue+0x14d/0x240
 [<c0156d49>] get_page_from_freelist+0x79/0xc0
 [<c0156dd9>] __alloc_pages+0x49/0x330
 [<c01703f4>] cache_grow+0xc4/0x140
 [<c0282a54>] xfs_itruncate_finish+0x224/0x3d0
 [<c029f042>] xfs_inactive+0x3f2/0x460
 [<c02a62a1>] xfs_buf_offset+0x31/0x40
 [<c0280e07>] xfs_itobp+0x77/0x100
 [<c02ac83e>] xfs_fs_clear_inode+0x8e/0xd0
 [<c0185a23>] clear_inode+0xb3/0x140
 [<c0186692>] generic_delete_inode+0xe2/0x120
 [<c01868b4>] iput+0x54/0x60
 [<c0291958>] xlog_recover_process_iunlinks+0x3f8/0x420
 [<c02928bd>] xlog_recover_finish+0x8d/0x90
 [<c028a9df>] xfs_log_mount_finistfs+0x301/0x650
 [<c02ad54e>] icmn_err+0x6e/0x90
 [<c02a2de8>] kmem_alloc+0x58/0xe0
 [<c0295e94>] xfs_mru_cache_create+0xf4/0x160
 [<c029bd8a>] xfs_mount+0x1fa/0x370
 [<c02ad0ad>] xfs_fs_fill_super+0xad/0x1e0
 [<c0175632>] get_sb_bdev+0xe2/0x110
 [<c0156dd9>] __alloc_pages+0x49/0x330
 [<c02ad1f2>] xfs_fs_get_sb+0x12/0x20
 [<c02ad000>] xfs_fs_fill_super+0x0/0x1e0
 [<c0175818>] vfs_kern_mount+0x58/0x110
 [<c017597a>] do_kern_mount+0x2a/0x70
 [<c018934e>] do_new_mount+0x5e/0x90
 [<c01898d6>] do_mount+0x176/0x190
 [<c0189b71>] sys_mount+0x71/0xb0
 [<c0103a42>] syscall_call+0x7/0xb
 =======================
Ending XFS recovery on filesystem: dm-6 (logdev: internal)
Filesystem "dm-9": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-9
Ending clean XFS mount for filesystem: dm-9
Filesystem "dm-8": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-8
Ending clean XFS mount for filesystem: dm-8

After reboot access do volume (size ~1TB) was not possible.

Additionally to this kernel we used following patches:

ommit a3f74ffb6d1448d9a8f482e593b80ec15f1695d4
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:42 2008 +1100

   [XFS] Don't block pdflush when writing back inodes



commit 4ae29b4321b99b711bcfde5527c4fbf249eac60f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:43:34 2008 +1100

   [XFS] Factor xfs_itobp() and xfs_inotobp().


Can these pathces be the reason of these errors? Or is there maybe
some issue in this kernel version (2.6.25.17) or what can be the
reason of above errors?

Some additional parts of information:

at /proc/modules


iscsi_trgt 64316 3 - Live 0xf91e8000
st 35964 0 - Live 0xf8ee9000
sg 31688 2 - Live 0xf8eb8000
scst_vdisk 31124 0 - Live 0xf8eaf000
scst 120564 1 scst_vdisk, Live 0xf8eca000
ipmi_watchdog 18080 0 - Live 0xf8e9d000
ipmi_devintf 7732 0 - Live 0xf8e93000
drbd 201236 0 - Live 0xf8e03000
bonding 85512 0 - Live 0xf8b21000
iscsi_tcp 17520 0 - Live 0xf887a000
libiscsi 23464 1 iscsi_tcp, Live 0xf8a79000
scsi_transport_iscsi 28480 3 iscsi_tcp,libiscsi, Live 0xf8adb000
stex 12424 8 - Live 0xf8a74000
e1000 187780 0 - Live 0xf8aac000
button 7160 0 - Live 0xf8a71000
ftdi_sio 33948 0 - Live 0xf8a56000
usbserial 27248 1 ftdi_sio, Live 0xf8872000

cat /proc/meminfo


MemTotal:      2067392 kB
MemFree:        701324 kB
Buffers:        720852 kB
Cached:         457844 kB
SwapCached:          0 kB
Active:         139468 kB
Inactive:      1103564 kB
HighTotal:     1173980 kB
HighFree:       623144 kB
LowTotal:       893412 kB
LowFree:         78180 kB
SwapTotal:     4194296 kB
SwapFree:      4194296 kB
Dirty:             288 kB
Writeback:           0 kB
AnonPages:       64484 kB
Mapped:          29664 kB
Slab:            64984 kB
SReclaimable:    47444 kB
SUnreclaim:      17540 kB
PageTables:       2236 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5227992 kB
Committed_AS:   289468 kB
VmallocTotal:   116728 kB
VmallocUsed:     10080 kB
VmallocChunk:   106516 kB

slabinfo
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata
<active_slabs> <num_slabs> <sharedavail>
tio                    0      0     24  145    1 : tunables  120   60
8 : slabdata      0      0      0
iscsi_cmnd             0      0    140   28    1 : tunables  120   60
8 : slabdata      0      0      0
scst_vdisk_thr         0      0     40   92    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-4096K          0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-2048K          0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-1024K          0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-512K           0      0   2612    3    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-dma-256K           0      0   1332    3    1 : tunables   24   12
8 : slabdata      0      0      0
sgv-dma-128K           0      0    692   11    2 : tunables   54   27
8 : slabdata      0      0      0
sgv-dma-64K            0      0    372   10    1 : tunables   54   27
8 : slabdata      0      0      0
sgv-dma-32K            0      0    212   18    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-16K            0      0    132   29    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-8K             0      0     92   42    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-dma-4K             0      0     72   53    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-clust-4096K        0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-clust-2048K        0      0   2100    3    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-clust-1024K        0      0   1076    7    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-clust-512K         0      0   3124    2    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-clust-256K         0      0   1588    5    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-clust-128K         0      0    820    9    2 : tunables   54   27
8 : slabdata      0      0      0
sgv-clust-64K          0      0    436    9    1 : tunables   54   27
8 : slabdata      0      0      0
sgv-clust-32K          0      0    244   16    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-clust-16K          0      0    148   26    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-clust-8K           0      0    100   39    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-clust-4K           0      0     76   50    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-4096K              0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-2048K              0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-1024K              0      0     52   72    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-512K               0      0   2612    3    2 : tunables   24   12
8 : slabdata      0      0      0
sgv-256K               0      0   1332    3    1 : tunables   24   12
8 : slabdata      0      0      0
sgv-128K               0      0    692   11    2 : tunables   54   27
8 : slabdata      0      0      0
sgv-64K                0      0    372   10    1 : tunables   54   27
8 : slabdata      0      0      0
sgv-32K                0      0    212   18    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-16K                0      0    132   29    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-8K                 0      0     92   42    1 : tunables  120   60
8 : slabdata      0      0      0
sgv-4K                 0      0     72   53    1 : tunables  120   60
8 : slabdata      0      0      0
scst_acg_dev           0      0     36  101    1 : tunables  120   60
8 : slabdata      0      0      0
scst_tgt_dev           0      0    200   19    1 : tunables  120   60
8 : slabdata      0      0      0
scst_session           0      0    368   10    1 : tunables   54   27
8 : slabdata      0      0      0
scst_cmd               0      0    240   16    1 : tunables  120   60
8 : slabdata      0      0      0
scst_sense           128    160     96   40    1 : tunables  120   60
8 : slabdata      4      4      0
scst_tgt_dev_UA       64     74    104   37    1 : tunables  120   60
8 : slabdata      2      2      0
scst_mgmt_cmd_stub   1024   1270     12  254    1 : tunables  120
60    8 : slabdata      5      5      0
scst_mgmt_cmd         64    106     72   53    1 : tunables  120   60
8 : slabdata      2      2      0
xfs_dqtrx              0      0    192   20    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_dquots             4     24    332   12    1 : tunables   54   27
8 : slabdata      2      2      0
drbd_ee_cache       2040   2079     60   63    1 : tunables  120   60
8 : slabdata     33     33      0
drbd_req_cache      2040   2072     68   56    1 : tunables  120   60
8 : slabdata     37     37      0
kcopyd_job           512    525    264   15    1 : tunables   54   27
8 : slabdata     35     35      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12
8 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60
8 : slabdata      1      1      0
rpc_inode_cache        0      0    448    9    1 : tunables   54   27
8 : slabdata      0      0      0
UNIX                 189    189    448    9    1 : tunables   54   27
8 : slabdata     21     21      0
flow_cache             0      0     80   48    1 : tunables  120   60
8 : slabdata      0      0      0
ib_mad                 0      0    448    9    1 : tunables   54   27
8 : slabdata      0      0      0
dm_snap_pending_exception    128    177     64   59    1 : tunables
120   60    8 : slabdata      3      3      0
dm_snap_exception     30    145     24  145    1 : tunables  120   60
8 : slabdata      1      1      0
dm_mpath_io            0      0     28  127    1 : tunables  120   60
8 : slabdata      0      0      0
dm_crypt_io           70    294     92   42    1 : tunables  120   60
8 : slabdata      7      7      0
dm_target_io        3111   3451     16  203    1 : tunables  120   60
8 : slabdata     17     17      0
dm_io               3096   3380     20  169    1 : tunables  120   60
8 : slabdata     20     20      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60
8 : slabdata      0      0      0
scsi_sense_cache      84    180    128   30    1 : tunables  120   60
8 : slabdata      6      6      0
scsi_cmd_cache        86    140    192   20    1 : tunables  120   60
8 : slabdata      7      7      0
cfq_io_context         0      0     96   40    1 : tunables  120   60
8 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60
8 : slabdata      0      0      0
mqueue_inode_cache      1      7    576    7    1 : tunables   54
27    8 : slabdata      1      1      0
xfs_icluster          38    169     20  169    1 : tunables  120   60
8 : slabdata      1      1      0
xfs_ili               23     56    140   28    1 : tunables  120   60
8 : slabdata      2      2      0
xfs_inode            575    600    384   10    1 : tunables   54   27
8 : slabdata     60     60      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_buf_item           0      0    148   26    1 : tunables  120   60
8 : slabdata      0      0      0
fstrm_item             0      0     12  254    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_mru_cache_elem      0      0     16  203    1 : tunables  120
60    8 : slabdata      0      0      0
xfs_acl                0      0    304   13    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_ifork              1     67     56   67    1 : tunables  120   60
8 : slabdata      1      1      0
xfs_dabuf              0      0     16  203    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_da_state           0      0    336   11    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_trans              0      0    632    6    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_btree_cur          0      0    140   28    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_bmap_free_item      0      0     16  203    1 : tunables  120
60    8 : slabdata      0      0      0
xfs_buf               30     80    192   20    1 : tunables  120   60
8 : slabdata      4      4      0
xfs_ioend             32     67     56   67    1 : tunables  120   60
8 : slabdata      1      1      0
xfs_vnode            575    600    384   10    1 : tunables   54   27
8 : slabdata     60     60      0
udf_inode_cache        0      0    396   10    1 : tunables   54   27
8 : slabdata      0      0      0
nfsd4_delegations      0      0    212   18    1 : tunables  120   60
8 : slabdata      0      0      0
nfsd4_stateids         0      0     72   53    1 : tunables  120   60
8 : slabdata      0      0      0
nfsd4_files            0      0     40   92    1 : tunables  120   60
8 : slabdata      0      0      0
nfsd4_stateowners      0      0    344   11    1 : tunables   54   27
8 : slabdata      0      0      0
nfs_direct_cache       0      0     76   50    1 : tunables  120   60
8 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27
8 : slabdata      4      4      0
nfs_read_data         32     36    448    9    1 : tunables   54   27
8 : slabdata      4      4      0
nfs_inode_cache        0      0    636    6    1 : tunables   54   27
8 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60
8 : slabdata      0      0      0
isofs_inode_cache      0      0    368   10    1 : tunables   54   27
8 : slabdata      0      0      0
squashfs_inode_cache  11069  11090    384   10    1 : tunables   54
27    8 : slabdata   1109   1109      0
ext2_inode_cache      12     16    464    8    1 : tunables   54   27
8 : slabdata      2      2      0
journal_handle        42    169     20  169    1 : tunables  120   60
8 : slabdata      1      1      0
journal_head          74    432     52   72    1 : tunables  120   60
8 : slabdata      6      6      0
revoke_table          14    254     12  254    1 : tunables  120   60
8 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60
8 : slabdata      0      0      0
ext3_inode_cache   16431  16440    484    8    1 : tunables   54   27
8 : slabdata   2055   2055      0
ext3_xattr             0      0     48   78    1 : tunables  120   60
8 : slabdata      0      0      0
dnotify_cache          0      0     20  169    1 : tunables  120   60
8 : slabdata      0      0      0
dquot                  0      0    128   30    1 : tunables  120   60
8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120
60    8 : slabdata      0      0      0
inotify_watch_cache      0      0     40   92    1 : tunables  120
60    8 : slabdata      0      0      0
kioctx                 0      0    192   20    1 : tunables  120   60
8 : slabdata      0      0      0
kiocb                  0      0    192   20    1 : tunables  120   60
8 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60
8 : slabdata      0      0      0
shmem_inode_cache   1078   1116    436    9    1 : tunables   54   27
8 : slabdata    124    124      0
nsproxy                0      0     28  127    1 : tunables  120   60
8 : slabdata      0      0      0
posix_timers_cache      0      0    104   37    1 : tunables  120
60    8 : slabdata      0      0      0
uid_cache              3     30    128   30    1 : tunables  120   60
8 : slabdata      1      1      0
UDP-Lite               0      0    512    7    1 : tunables   54   27
8 : slabdata      0      0      0
tcp_bind_bucket       45    226     32  113    1 : tunables  120   60
8 : slabdata      2      2      0
inet_peer_cache        1     59     64   59    1 : tunables  120   60
8 : slabdata      1      1      0
secpath_cache          0      0     32  113    1 : tunables  120   60
8 : slabdata      0      0      0
xfrm_dst_cache         0      0    320   12    1 : tunables   54   27
8 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60
8 : slabdata      0      0      0
ip_fib_hash           15    101     36  101    1 : tunables  120   60
8 : slabdata      1      1      0
ip_dst_cache          59     75    256   15    1 : tunables  120   60
8 : slabdata      5      5      0
arp_cache              7     40    192   20    1 : tunables  120   60
8 : slabdata      2      2      0
RAW                    9     14    512    7    1 : tunables   54   27
8 : slabdata      2      2      0
UDP                   15     42    512    7    1 : tunables   54   27
8 : slabdata      6      6      0
tw_sock_TCP            3     30    128   30    1 : tunables  120   60
8 : slabdata      1      1      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60
8 : slabdata      0      0      0
TCP                   52     77   1152    7    2 : tunables   24   12
8 : slabdata     11     11      0
eventpoll_pwq         39    101     36  101    1 : tunables  120   60
8 : slabdata      1      1      0
eventpoll_epi         39     60    128   30    1 : tunables  120   60
8 : slabdata      2      2      0
sgpool-128             2      3   2560    3    2 : tunables   24   12
8 : slabdata      1      1      0
sgpool-64              2      3   1280    3    1 : tunables   24   12
8 : slabdata      1      1      0
sgpool-32              2      6    640    6    1 : tunables   54   27
8 : slabdata      1      1      0
sgpool-16              2     12    320   12    1 : tunables   54   27
8 : slabdata      1      1      0
sgpool-8              91    120    192   20    1 : tunables  120   60
8 : slabdata      6      6      0
scsi_bidi_sdb          0      0     20  169    1 : tunables  120   60
8 : slabdata      0      0      0
scsi_io_context        8     37    104   37    1 : tunables  120   60
8 : slabdata      1      1      0
blkdev_queue          80     80   1012    4    1 : tunables   54   27
8 : slabdata     20     20      0
blkdev_requests      214    220    192   20    1 : tunables  120   60
8 : slabdata     11     11      0
blkdev_ioc             0      0     48   78    1 : tunables  120   60
8 : slabdata      0      0      0
biovec-256           274    274   3072    2    2 : tunables   24   12
8 : slabdata    137    137      0
biovec-128           274    280   1536    5    2 : tunables   24   12
8 : slabdata     56     56      0
biovec-64            274    305    768    5    1 : tunables   54   27
8 : slabdata     61     61      0
biovec-16            274    340    192   20    1 : tunables  120   60
8 : slabdata     17     17      0
biovec-4             295    472     64   59    1 : tunables  120   60
8 : slabdata      8      8      0
biovec-1             563   2233     16  203    1 : tunables  120   60
8 : slabdata     11     11     68
bio                  568   1440    128   30    1 : tunables  120   60
8 : slabdata     48     48     24
sock_inode_cache     262    280    384   10    1 : tunables   54   27
8 : slabdata     28     28      0
skbuff_fclone_cache      2     24    320   12    1 : tunables   54
27    8 : slabdata      2      2      0
skbuff_head_cache    611    720    192   20    1 : tunables  120   60
8 : slabdata     36     36      0
file_lock_cache      100    156    100   39    1 : tunables  120   60
8 : slabdata      4      4      0
Acpi-Operand         950   1012     40   92    1 : tunables  120   60
8 : slabdata     11     11      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60
8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60
8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60
8 : slabdata      0      0      0
Acpi-Namespace       631    676     20  169    1 : tunables  120   60
8 : slabdata      4      4      0
proc_inode_cache    3299   3311    356   11    1 : tunables   54   27
8 : slabdata    301    301      0
sigqueue             101    108    144   27    1 : tunables  120   60
8 : slabdata      4      4      0
radix_tree_node     8952   9659    288   13    1 : tunables   54   27
8 : slabdata    743    743      0
bdev_cache            61     70    512    7    1 : tunables   54   27
8 : slabdata     10     10      0
sysfs_dir_cache    10644  10668     44   84    1 : tunables  120   60
8 : slabdata    127    127      0
mnt_cache             62    150    128   30    1 : tunables  120   60
8 : slabdata      5      5      0
inode_cache         1683   1683    340   11    1 : tunables   54   27
8 : slabdata    153    153      0
dentry             36870  36870    128   30    1 : tunables  120   60
8 : slabdata   1229   1229      0
filp                2084   3400    192   20    1 : tunables  120   60
8 : slabdata    170    170      0
names_cache          110    110   4096    1    1 : tunables   24   12
8 : slabdata    110    110      0
idr_layer_cache      172    203    136   29    1 : tunables  120   60
8 : slabdata      7      7      0
buffer_head       343193 431480     56   67    1 : tunables  120   60
8 : slabdata   6440   6440      0
mm_struct            234    333    448    9    1 : tunables   54   27
8 : slabdata     37     37      0
vm_area_struct      3621   3784     88   44    1 : tunables  120   60
8 : slabdata     86     86    180
fs_cache             343    590     64   59    1 : tunables  120   60
8 : slabdata     10     10      0
files_cache          300    450    256   15    1 : tunables  120   60
8 : slabdata     30     30      0
signal_cache         444    513    448    9    1 : tunables   54   27
8 : slabdata     57     57      0
sighand_cache        402    402   1344    3    1 : tunables   24   12
8 : slabdata    134    134     12
task_struct          501    510   1392    5    2 : tunables   24   12
8 : slabdata    102    102      0
anon_vma            1465   1778     12  254    1 : tunables  120   60
8 : slabdata      7      7    180
pid                  900   1003     64   59    1 : tunables  120   60
8 : slabdata     17     17      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1
1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1
1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1
1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1
1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1
1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1
1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1
0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1
0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1
0 : slabdata      0      0      0
size-262144            1      1 262144    1   64 : tunables    1    1
0 : slabdata      1      1      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4
0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4
0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4
0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4
0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4
0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4
0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4
0 : slabdata      0      0      0
size-16384             5      5  16384    1    4 : tunables    8    4
0 : slabdata      5      5      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4
0 : slabdata      0      0      0
size-8192             31     31   8192    1    2 : tunables    8    4
0 : slabdata     31     31      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12
8 : slabdata      0      0      0
size-4096            140    140   4096    1    1 : tunables   24   12
8 : slabdata    140    140      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12
8 : slabdata      0      0      0
size-2048            823    824   2048    2    1 : tunables   24   12
8 : slabdata    412    412      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27
8 : slabdata      0      0      0
size-1024            436    436   1024    4    1 : tunables   54   27
8 : slabdata    109    109      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27
8 : slabdata      0      0      0
size-512            2216   2272    512    8    1 : tunables   54   27
8 : slabdata    284    284      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60
8 : slabdata      0      0      0
size-256             941   1065    256   15    1 : tunables  120   60
8 : slabdata     70     71      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60
8 : slabdata      0      0      0
size-192             281    420    192   20    1 : tunables  120   60
8 : slabdata     21     21      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60
8 : slabdata      0      0      0
size-128             384    570    128   30    1 : tunables  120   60
8 : slabdata     19     19      0
size-96(DMA)           0      0    128   30    1 : tunables  120   60
8 : slabdata      0      0      0
size-96              603    690    128   30    1 : tunables  120   60
8 : slabdata     23     23      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60
8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60
8 : slabdata      0      0      0
size-64             8083   8083     64   59    1 : tunables  120   60
8 : slabdata    137    137      0
size-32            10087  10170     32  113    1 : tunables  120   60
8 : slabdata     90     90      0
kmem_cache           218    225    256   15    1 : tunables  120   60
8 : slabdata     15     15      0

Thank you in advance for your help

Regards
Roland

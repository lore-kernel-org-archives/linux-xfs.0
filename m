Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07AE97F55
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 12:04:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CE28AC00E
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 10:04:39 -0700 (PDT)
Received: from ca1mailout02.kla-tencor.com (mailout03.kla-tencor.com
	[192.146.1.173]) by cuda.sgi.com with ESMTP id sI7BIc8oNqiHgVoI
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Jul 2013 10:04:36 -0700 (PDT)
Received: from CA1EXBH01.adcorp.kla-tencor.com (ca1exbh01.kla-tencor.com
	[10.60.33.3])
	by ca1mailout02.kla-tencor.com (8.14.4/8.14.4) with ESMTP id
	r61H4YJX008306 for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:04:36 -0700
Received: from mail24-db9 (localhost [127.0.0.1])	by mail24-db9-R.bigfish.com
	(Postfix) with ESMTP id 6EB804600FB	for
	<xfs@oss.sgi.com.FOPE.CONNECTOR.OVERRIDE>;
	Mon,  1 Jul 2013 17:04:29 +0000 (UTC)
Received: from DB9EHSMHS015.bigfish.com (unknown [10.174.16.231])	by
	mail24-db9.bigfish.com (Postfix) with ESMTP id 4C37EC0057	for
	<xfs@oss.sgi.com>; Mon,  1 Jul 2013 17:04:27 +0000 (UTC)
From: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Subject: RESEND Flush hung in D state at fclose (after heavy XFS writes)
Date: Mon, 1 Jul 2013 17:04:19 +0000
Message-ID: <3542214BE3A3EF419F236DFE0F878BC917882980@BL2PRD0310MB374.namprd03.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>

Got a note from the list that my earlier post was too big and need moderator approval.  Resend the post with no attachment.
I can send the sysrq dumps separately if it is needed.

Thanks,
Norman
> 
> Hello,
> 
> I had this issue with Kernel 3.0.13 and reported in this forum ~4 months ago.
> I'd been working with Suse support to resolve but getting no where.  I 
> will be grateful should someone can help and give me some pointers to 
> solve or work around this hang.  Suse has asked me to reproduce it 
> with 3.0.80- 0.5(their latest release) so all the attached traces were 
> produced against this kernel.
> 
> My application has ~10+ threads running non-stop with high CPU usage 
> (close to 100% and each is locked to a specific CPU with 32 CPUs in 
> the server).  The processing runs in a 5 minute cycle. After the 
> second minute 5 of these threads start writing to disk for 3 minutes. 
> Each thread writes a file ~16G in size.  The threads run with very 
> high priority (-2, much higher than flush, I also tried threads with 
> same priority as pdflush, fails sooner)
> 
> Disk is a raid-5, I have also tried 5 X raid-0, one raid per disk 
> writing thread same result.
> 
> Below are the traces from magic sysrq "w"
> 
> If I use O_DIRECT write, my application will run for 5-6 days and 
> hang.  If I use buffered write, it will hang after 3-4 hours.
> 
> And when I attached GDB to my applications, the flush-8:16 will 
> immediately free from D state, and my application too.
> 
> Without knowing the internal of flush and XFS, this is my guess 
> looking at the trace below:
> Could it be that flush(xfs_fs_write_inode)  and my application 
> (xfs_file_release at fclose) are holding the same lock?
> 
> Stack trace of a few thread of interests.  The entire dump is attached.
> 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580426] SysRq : Show Blocked State
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580434]   task                        PC stack  pid father

> Jun 28 19:34:11 IMCNode000 kernel: [29127.580629] flush-8:16      D
> 0000000000000400     0  5502      2 0x00000000
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580636]  ffff883e5bbb7b90
> 0000000000000046 ffff8819c91d25c0 ffff883e5bbb6010 
> Jun 28 19:34:11  IMCNode000 kernel: [29127.580643]  0000000000011180 0000000000011180  ffff883e5bbb7fd8 ffff883e5bbb7fd8 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580651]  0000000000011180 ffff883e5b8aa0c0 ffff8819c91d25c0  ffff8819dc99a3c0
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580658]  Call Trace:
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580711]   [<ffffffffa04a2cd5>] xfs_ioend_wait+0x85/0xb0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580800]  [<ffffffffa04acb28>] xfs_fs_write_inode+0xb8/0x190  [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580880]  [<ffffffff81177793>] writeback_single_inode+0x2f3/0x360
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580889]  [<ffffffff81177ee4>] writeback_sb_inodes+0xc4/0x1a0
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580897]  [<ffffffff81178743>] writeback_inodes_wb+0xd3/0x160 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580904]  [<ffffffff81178b8b>] wb_writeback+0x3bb/0x400
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580911]  [<ffffffff81178e0b>] wb_do_writeback+0x23b/0x250
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580918]  [<ffffffff81178f04>] bdi_writeback_thread+0xe4/0x240
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580926]  [<ffffffff8107c646>] kthread+0x96/0xa0 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580936]  [<ffffffff81450e44>] kernel_thread_helper+0x4/0x10
>
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580954] Tigris_IMC.exe  D  0000000100669478     0  6347   6269 0x00000000
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580960]  ffff8819dc9b5848  0000000000000086 0000000000000000 ffff8819dc9b4010
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580968]  0000000000011180 0000000000011180 ffff8819dc9b5fd8 ffff8819dc9b5fd8
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580975]  0000000000011180 ffff8819dc9b2540 0000000085227080 ffff883e86942400
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580982]  Call Trace:
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580991]  [<ffffffff81446555>] schedule_timeout+0x205/0x2a0 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.580998]  [<ffffffff814472f8>] __down+0x68/0xb0 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581008]  [<ffffffff81082097>] down+0x47/0x50 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581030]  [<ffffffffa04a3ce9>] xfs_buf_lock+0x59/0xc0 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581104]  [<ffffffffa04a522b>] _xfs_buf_find+0x11b/0x210 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581176]  [<ffffffffa04a5356>] xfs_buf_get+0x36/0x1d0 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581248]  [<ffffffffa04a5514>] xfs_buf_read+0x24/0x110 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581322]  [<ffffffffa049a8ce>] xfs_trans_read_buf+0x28e/0x3e0 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581393]  [<ffffffffa0467f5e>] xfs_btree_read_buf_block+0x5e/0xd0 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581438]  [<ffffffffa0468682>] xfs_btree_lookup_get_block+0x82/0xf0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581480]  [<ffffffffa0468d32>] xfs_btree_lookup+0xd2/0x470 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581522]  [<ffffffffa045f967>] xfs_bmap_del_extent+0x147/0xac0  [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581560]  [<ffffffffa0463857>] xfs_bunmapi+0x5d7/0xbc0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581601]  [<ffffffffa0482cc8>] xfs_itruncate_finish+0x168/0x330 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581657]  [<ffffffffa049e5ce>] xfs_free_eofblocks+0x1ce/0x2b0  [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581725]  [<ffffffffa049f18c>] xfs_release+0x13c/0x230 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581793]  [<ffffffffa04a6f00>] xfs_file_release+0x10/0x20 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581855]  [<ffffffff81153e83>] __fput+0xb3/0x200
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581863]  [<ffffffff8114fefc>] filp_close+0x5c/0x90
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581870]  [<ffffffff8114ffd7>] sys_close+0xa7/0x100
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581879]  [<ffffffff8144fd12>] system_call_fastpath+0x16/0x1b
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581897]  [<00007f90392c2ea0>] 0x7f90392c2e9f 
> 
> Jun 28 19:34:11  IMCNode000 kernel: [29127.581903] Tigris_IMC.exe  D ffff887ef8994710     0  6352   6269 0x00000000
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581909]  ffff8819dcbe7848 0000000000000086 ffffffffa0480c7e ffff8819dcbe6010
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581916]  0000000000011180 0000000000011180 ffff8819dcbe7fd8 ffff8819dcbe7fd8
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581923]  0000000000011180 ffff8819dcbe4680 ffff883e85249e80 ffff883e86a123c0
>  Jun 28 19:34:11 IMCNode000 kernel: [29127.581930]  Call Trace:
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581940]  [<ffffffff81446555>] schedule_timeout+0x205/0x2a0
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581952]  [<ffffffff814472f8>] __down+0x68/0xb0 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581959]  [<ffffffff81082097>] down+0x47/0x50 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.581979]  [<ffffffffa04a3ce9>] xfs_buf_lock+0x59/0xc0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582050]  [<ffffffffa04a522b>] _xfs_buf_find+0x11b/0x210 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582121]  [<ffffffffa04a5356>] xfs_buf_get+0x36/0x1d0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582191]  [<ffffffffa04a5514>] xfs_buf_read+0x24/0x110 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582264]  [<ffffffffa049a8ce>] xfs_trans_read_buf+0x28e/0x3e0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582330]  [<ffffffffa0467f5e>]  xfs_btree_read_buf_block+0x5e/0xd0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582371]  [<ffffffffa0468682>] xfs_btree_lookup_get_block+0x82/0xf0 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582413]  [<ffffffffa0468d32>] xfs_btree_lookup+0xd2/0x470 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582454]  [<ffffffffa045f967>] xfs_bmap_del_extent+0x147/0xac0  [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582494]  [<ffffffffa0463857>] xfs_bunmapi+0x5d7/0xbc0 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582541]  [<ffffffffa0482cc8>] xfs_itruncate_finish+0x168/0x330 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582597]  [<ffffffffa049e5ce>] xfs_free_eofblocks+0x1ce/0x2b0  [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582665]  [<ffffffffa049f18c>] xfs_release+0x13c/0x230 [xfs]
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582733]  [<ffffffffa04a6f00>] xfs_file_release+0x10/0x20 [xfs] 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582794]  [<ffffffff81153e83>] __fput+0xb3/0x200
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582801]  [<ffffffff8114fefc>] filp_close+0x5c/0x90 
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582807]  [<ffffffff8114ffd7>] sys_close+0xa7/0x100
> Jun 28 19:34:11 IMCNode000 kernel: [29127.582814]  [<ffffffff8144fd12>]  system_call_fastpath+0x16/0x1b 
>Jun 28 19:34:11 IMCNode000 kernel: [29127.582823]  [<00007f90392c2ea0>] 0x7f90392c2e9f
> 
> 
> xfsprogs-3.1.6-0.7.1
> 
> xfs_info /raid
> meta-data=/dev/sdb1              isize=256    agcount=4, agsize=243896192 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=975584768, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=476359, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> fdisk -l
> 
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util 
> fdisk doesn't support GPT. Use GNU Parted.
> Disk /dev/sdb: 3996.0 GB, 3995997306880 bytes
> 255 heads, 63 sectors/track, 485819 cylinders, total 7804682240 
> sectors Units = sectors of 1 * 512 = 512 bytes Sector size 
> (logical/physical): 512 bytes / 512 bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier:
> 0x80560481
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb4               1           1           0+  ee  GPT
> 
>  /proc/partitions
> major minor  #blocks  name
> 
>    8       16 3902341120 sdb
>    8       17 3902339072 sdb1
>    8        0  124022784 sda
>    8        1    1051648 sda1
>    8        2    1051648 sda2
>    8        3  121918464 sda3
> 
> /proc/meminfo
> MemTotal:       526536468 kB
> MemFree:        520264928 kB
> Buffers:           16644 kB
> Cached:           706520 kB
> SwapCached:            0 kB
> Active:           580108 kB
> Inactive:         240800 kB
> Active(anon):      98036 kB
> Inactive(anon):       68 kB
> Active(file):     482072 kB
> Inactive(file):   240732 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       1051644 kB
> SwapFree:        1051644 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:         97868 kB
> Mapped:            13212 kB
> Shmem:               236 kB
> Slab:             125960 kB
> SReclaimable:      17020 kB
> SUnreclaim:       108940 kB
> KernelStack:        3264 kB
> PageTables:         3120 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    522322744 kB
> Committed_AS:     432276 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:     1100980 kB
> VmallocChunk:   34090199776 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:     16384 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:      129732 kB
> DirectMap2M:     6133760 kB
> DirectMap1G:    530579456 kB
> 
> 
> Many thanks in advance,
> 
> Norman
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

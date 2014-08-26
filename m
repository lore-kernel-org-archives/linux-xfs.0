Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA9C17F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 01:26:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7075F8F8037
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 23:26:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Lc03Q6opbIlPUPBR
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 23:26:00 -0700 (PDT)
Subject: Re: storage, libaio,
	or XFS =?UTF-8?Q?problem=3F=20=20=33=2E=34=2E=32=36?=
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 01:25:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
In-Reply-To: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
Message-ID: <75371e88cb16c05079ea5211fe7378e6@localhost>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Forgot to mention:
load average: 171.00, 171.00, 170.95

And that's with all processes idle for over 30 minutes.  So I'm thinking
bug.  Probably has been fixed between .26 and .103 but they're stubborn
about sticking with this 3.4.26 kernel, not because they have an affinity
for it, but because of their slow process.


On Tue, 26 Aug 2014 01:18:50 -0500, Stan Hoeppner <stan@hardwarefreak.com>
wrote:
> Had some controller issues but believe we had those ironed out before
this
> recent breakage.  I had reformatted both 48TB LUNs on this test box with
-f
> and defaults, and fired up the test app again.  Throughput was fantastic
> with no dropped application buffers for ~30 minutes, and IO times were
1.x
> ms max, suggesting all the writes were acked by controller cache.  The
app
> was running perfectly.  Then it hanged and spit out an internal error
msg: 
> 
> 
> Failed to reopen file /mnt/VOL1/sg-04/str-0015/f-0000000005
> 
> I have many call traces in dmesg, most are XFS, pasted below.  I found
no
> SCSI I/O errors in dmesg.  Application is submitting writes via libaio
and
> using O_DIRECT, writing to preallocated files.  I don't see any errors
in
> the storage controller log and everything seems to check out there. 
Using
> noop elevator, mpt2sas, no multipathing.  The application process is
hung
> in d state and kill -9 won't get rid of it.  I can't unmount the hosed
up
> filesystem.  Any ideas?
> 
> # ls -la /mnt/VOL1
> ls: cannot access /mnt/VOL1: Input/output error
> 
> # dd if=/mnt/VOL1 of=/dev/null bs=1M count=16
> dd: opening `/mnt/VOL1': Input/output error
> 
> # dd if=/dev/sdd of=/dev/null bs=1M count=16
> 16+0 records in
> 16+0 records out
> 16777216 bytes (17 MB) copied, 1.10989 s, 15.1 MB/s
> 
> # ls -la /mnt/
> ls: cannot access /mnt/VOL1: Input/output error
> total 8
> drwxrwxrwt  6 root root  120 Aug 25 17:59 .
> drwxr-xr-x 21 root root 4096 Jul 15 09:39 ..
> drwxrwxrwt  3 root root   80 Aug 25 16:52 initramfs
> drwxr-xr-x  3 root root 4096 Apr 24 04:57 scratch
> drwxrwxrwx  5 root root   58 Aug 25 22:06 VOL0
> d?????????  ? ?    ?       ?            ? VOL1
> 
> # umount /mnt/VOL1
> umount: /mnt/VOL1: device is busy.
>         (In some cases useful info about processes that use
>          the device is found by lsof(8) or fuser(1))
> 
> 
> 
> Kernel 3.4.26
> xfs_repair version 3.1.4
> 2 socket, 20 core Xeon(R) CPU E5-2650 v2 @ 2.60GHz
> 
> MemTotal:       264573184 kB
> MemFree:        246519624 kB
> Buffers:           16820 kB
> Cached:            78120 kB
> SwapCached:            0 kB
> Active:         13130040 kB
> Inactive:          75352 kB
> Active(anon):   13110512 kB
> Inactive(anon):      276 kB
> Active(file):      19528 kB
> Inactive(file):    75076 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:             0 kB
> SwapFree:              0 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:      13126968 kB
> Mapped:            11848 kB
> Shmem:               340 kB
> Slab:             208476 kB
> SReclaimable:     118240 kB
> SUnreclaim:        90236 kB
> KernelStack:        3976 kB
> PageTables:        32840 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    132286592 kB
> Committed_AS:   25044716 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:     1050608 kB
> VmallocChunk:   34358680400 kB
> AnonHugePages:  13078528 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:        5056 kB
> DirectMap2M:     2045952 kB
> DirectMap1G:    266338304 kB
> 
> /dev/sdc /mnt/VOL0 xfs
> rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota 0 0
> /dev/sdd /mnt/VOL1 xfs
> rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota 0 0
> 
> major minor  #blocks  name
>    8       32 46837141504 sdc
>    8       48 46837141504 sdd
> 
> 2x hardware RAID5 LUNs - 64KB su, 768KB sw
> 2 controllers, one per LUN, 3GB cache each, write back, FPGA RAID engine
> No LVM.  LUNs directly formatted with XFS
> 26 Seagate SAS 3.5" 7.2K drives, 13 per RAID5, drive caches disabled
> My counterpart had what I'd guess is this same problem on the full test
> rig,
> which has 16 of these LUNS, 208 drives total.  He was also testing with
> libaio.
> I have not dug into the logs on that host as of yet.  Its config is
> identical
> to this box but for the number of LUNs, drives.
> 
> 
> [22635.102013] INFO: task kworker/7:0:45 blocked for more than 120
> seconds.
> [22635.102016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102018] kworker/7:0     D ffff8840666c0b08     0    45      2
> 0x00000000
> [22635.102021]  ffff8840666e7bd0 0000000000000046 ffff883f7c02d000
> ffff8840666f5180
> [22635.102026]  ffff8840666e7b80 0000000000000206 00000000000122c0
> 00000000000122c0
> [22635.102030]  ffff8840666e7fd8 ffff8840666e6000 00000000000122c0
> ffff8840666e6000
> [22635.102033] Call Trace:
> [22635.102041]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102044]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102047]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102051]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102055]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102058]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102070]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102077]  [<ffffffffa01b5ab0>]
xfs_iomap_write_unwritten+0x1b3/0x32e
> [xfs]
> [22635.102080]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102084]  [<ffffffffa01ab3d2>] ? xfs_setfilesize+0x128/0x128 [xfs]
> [22635.102088]  [<ffffffff810bc602>] ? mempool_free+0x73/0x78
> [22635.102093]  [<ffffffffa01ab3d2>] ? xfs_setfilesize+0x128/0x128 [xfs]
> [22635.102098]  [<ffffffffa01ab45b>] xfs_end_io+0x89/0xb4 [xfs]
> [22635.102102]  [<ffffffff81047321>] process_one_work+0x204/0x327
> [22635.102105]  [<ffffffff8104757f>] worker_thread+0x13b/0x25a
> [22635.102108]  [<ffffffff81047444>] ? process_one_work+0x327/0x327
> [22635.102111]  [<ffffffff8104af6f>] kthread+0x89/0x91
> [22635.102115]  [<ffffffff814fdbd4>] kernel_thread_helper+0x4/0x10
> [22635.102118]  [<ffffffff8104aee6>] ? __init_kthread_worker+0x3c/0x3c
> [22635.102120]  [<ffffffff814fdbd0>] ? gs_change+0xb/0xb
> [22635.102131] INFO: task streamRT-sa:5891 blocked for more than 120
> seconds.
> [22635.102132] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102134] streamRT-sa     D ffff883f52850348     0  5891   5114
> 0x00000004
> [22635.102136]  ffff884063af5b28 0000000000000082 000000000000029c
> ffff884066679100
> [22635.102140]  0000000000000006 0000000000000001 00000000000122c0
> 00000000000122c0
> [22635.102143]  ffff884063af5fd8 ffff884063af4000 00000000000122c0
> ffff884063af4000
> [22635.102146] Call Trace:
> [22635.102149]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102151]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102154]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102156]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102158]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102164]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102170]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102172]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.102178]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102184]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102189]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102195]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102199]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102202]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102204]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102207]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102209]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102212]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102215]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102217] INFO: task streamRT-sa:5895 blocked for more than 120
> seconds.
> [22635.102218] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102219] streamRT-sa     D ffff883f537fa3c8     0  5895   5114
> 0x00000004
> [22635.102222]  ffff883f7d057b28 0000000000000082 0000000000000000
> ffff884066227100
> [22635.102225]  ffff883f7d057ad8 0000000000000002 00000000000122c0
> 00000000000122c0
> [22635.102228]  ffff883f7d057fd8 ffff883f7d056000 00000000000122c0
> ffff883f7d056000
> [22635.102232] Call Trace:
> [22635.102234]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102236]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102239]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102241]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102243]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102249]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102254]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102257]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102262]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102268]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102274]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102279]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102282]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102284]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102286]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102288]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102291]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102294]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.102297]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102299]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102301] INFO: task streamRT-sa:5900 blocked for more than 120
> seconds.
> [22635.102302] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102303] streamRT-sa     D ffff883f53003b88     0  5900   5114
> 0x00000004
> [22635.102305]  ffff883f7d109b28 0000000000000082 0000000000000000
> ffff884066679100
> [22635.102309]  ffff883f7d109ad8 0000000000000002 00000000000122c0
> 00000000000122c0
> [22635.102312]  ffff883f7d109fd8 ffff883f7d108000 00000000000122c0
> ffff883f7d108000
> [22635.102315] Call Trace:
> [22635.102318]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102320]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102322]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102324]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102327]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102332]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102338]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102340]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102346]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102351]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102357]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102362]  [<ffffffff8105539b>] ? resched_task+0x3e/0x75
> [22635.102367]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102369]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102372]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102374]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102376]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102379]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102382]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102384]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102386] INFO: task streamRT-sa:5904 blocked for more than 120
> seconds.
> [22635.102387] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102388] streamRT-sa     D ffff88405fd50a48     0  5904   5114
> 0x00000004
> [22635.102390]  ffff883f51c2bb28 0000000000000082 0000000000000000
> ffff8840662d0080
> [22635.102394]  ffff883f51c2bad8 0000000000000002 00000000000122c0
> 00000000000122c0
> [22635.102397]  ffff883f51c2bfd8 ffff883f51c2a000 00000000000122c0
> ffff883f51c2a000
> [22635.102400] Call Trace:
> [22635.102402]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102405]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102407]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102409]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102412]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102417]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102423]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102425]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102430]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102436]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102442]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102447]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102450]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102452]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102454]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102457]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102459]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102461]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.102464]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102466]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102468] INFO: task streamRT-sa:5906 blocked for more than 120
> seconds.
> [22635.102469] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102470] streamRT-sa     D ffff88405fe2ca88     0  5906   5114
> 0x00000004
> [22635.102473]  ffff883f51c2fb28 0000000000000082 0000000000000000
> ffff8840667f00c0
> [22635.102476]  0000000000000000 0000000000000000 00000000000122c0
> 00000000000122c0
> [22635.102479]  ffff883f51c2ffd8 ffff883f51c2e000 00000000000122c0
> ffff883f51c2e000
> [22635.102482] Call Trace:
> [22635.102485]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102487]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102489]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102491]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102494]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102499]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102505]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102507]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.102512]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102518]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102524]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102529]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102532]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102534]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102536]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102538]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102541]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102543]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.102545]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102548]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102550] INFO: task streamRT-sa:5908 blocked for more than 120
> seconds.
> [22635.102551] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102552] streamRT-sa     D ffff88405fe2fac8     0  5908   5114
> 0x00000004
> [22635.102554]  ffff883f518b3b28 0000000000000082 000000000000029c
> ffff884066770040
> [22635.102558]  0000000000000006 0000000000000001 00000000000122c0
> 00000000000122c0
> [22635.102561]  ffff883f518b3fd8 ffff883f518b2000 00000000000122c0
> ffff883f518b2000
> [22635.102564] Call Trace:
> [22635.102566]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102569]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102571]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102573]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102575]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102581]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102586]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102589]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.102594]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102600]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102620]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102627]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102630]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102637]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102641]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102651]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102655]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102661]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102664]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102669] INFO: task streamRT-sa:5909 blocked for more than 120
> seconds.
> [22635.102675] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102677] streamRT-sa     D ffff88405fe2f3c8     0  5909   5114
> 0x00000004
> [22635.102683]  ffff883f518b5b28 0000000000000082 00000000000000de
> ffff88406663a040
> [22635.102694]  0000000000000002 0000000000000001 00000000000122c0
> 00000000000122c0
> [22635.102705]  ffff883f518b5fd8 ffff883f518b4000 00000000000122c0
> ffff883f518b4000
> [22635.102719] Call Trace:
> [22635.102723]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102729]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102734]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102739]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102742]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102751]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102761]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102765]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.102773]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102781]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102788]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102798]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102801]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102805]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102809]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102812]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102815]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102818]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.102824]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102827]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102834] INFO: task streamRT-sa:5911 blocked for more than 120
> seconds.
> [22635.102836] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.102838] streamRT-sa     D ffff883f5372c408     0  5911   5114
> 0x00000004
> [22635.102844]  ffff883f5208bb28 0000000000000082 0000000000000000
> ffff884066001180
> [22635.102850]  0000000000000000 0000000000000000 00000000000122c0
> 00000000000122c0
> [22635.102861]  ffff883f5208bfd8 ffff883f5208a000 00000000000122c0
> ffff883f5208a000
> [22635.102877] Call Trace:
> [22635.102883]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102886]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102890]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102895]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102902]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102911]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102918]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.102924]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.102931]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.102939]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.102947]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.102954]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.102959]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.102962]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.102968]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.102973]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.102976]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.102980]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.102985]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.102989]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> [22635.102995] INFO: task streamRT-sa:5918 blocked for more than 120
> seconds.
> [22635.102997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables
> this message.
> [22635.103001] streamRT-sa     D ffff883f53733a48     0  5918   5114
> 0x00000004
> [22635.103007]  ffff884063d99b28 0000000000000082 0000000000000000
> ffff88406668b1c0
> [22635.103017]  0000000000000000 0000000000000000 00000000000122c0
> 00000000000122c0
> [22635.103029]  ffff884063d99fd8 ffff884063d98000 00000000000122c0
> ffff884063d98000
> [22635.103037] Call Trace:
> [22635.103042]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.103047]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.103050]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.103054]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.103058]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.103065]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.103072]  [<ffffffffa01b00e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [22635.103076]  [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [22635.103086]  [<ffffffffa01b0519>] xfs_file_aio_write_checks+0x41/0xfe
> [xfs]
> [22635.103092]  [<ffffffffa01b06ff>] xfs_file_dio_aio_write+0x103/0x1fc
> [xfs]
> [22635.103099]  [<ffffffffa01b0ac3>] xfs_file_aio_write+0x152/0x1b5
[xfs]
> [22635.103109]  [<ffffffffa01b0971>] ?
> xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [22635.103113]  [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [22635.103120]  [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [22635.103126]  [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [22635.103129]  [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [22635.103134]  [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [22635.103139]  [<ffffffff8103ed3f>] ? sys_rt_sigprocmask+0x69/0xa1
> [22635.103142]  [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [22635.103146]  [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> 
> # ps -ef
> UID        PID  PPID  C STIME TTY          TIME CMD
> root         1     0  0 Aug25 ?        00:00:05 init [3]  
> root         2     0  0 Aug25 ?        00:00:00 [kthreadd]
> root         3     2  0 Aug25 ?        00:00:00 [ksoftirqd/0]
> root         6     2  0 Aug25 ?        00:00:00 [migration/0]
> root         7     2  0 Aug25 ?        00:00:00 [rcuc/0]
> root         8     2  0 Aug25 ?        00:00:00 [rcun/0]
> root         9     2  0 Aug25 ?        00:00:00 [rcub/0]
> root        10     2  0 Aug25 ?        00:00:00 [rcun/1]
> root        11     2  0 Aug25 ?        00:00:00 [rcub/1]
> root        12     2  0 Aug25 ?        00:00:00 [watchdog/0]
> root        13     2  0 Aug25 ?        00:00:00 [migration/1]
> root        15     2  0 Aug25 ?        00:00:00 [rcuc/1]
> root        16     2  0 Aug25 ?        00:00:00 [ksoftirqd/1]
> root        18     2  0 Aug25 ?        00:00:00 [watchdog/1]
> root        19     2  0 Aug25 ?        00:00:00 [migration/2]
> root        20     2  0 Aug25 ?        00:00:00 [kworker/2:0]
> root        21     2  0 Aug25 ?        00:00:00 [rcuc/2]
> root        22     2  0 Aug25 ?        00:00:00 [ksoftirqd/2]
> root        23     2  0 Aug25 ?        00:00:00 [watchdog/2]
> root        24     2  0 Aug25 ?        00:00:00 [migration/3]
> root        26     2  0 Aug25 ?        00:00:00 [rcuc/3]
> root        27     2  0 Aug25 ?        00:00:00 [ksoftirqd/3]
> root        28     2  0 Aug25 ?        00:00:00 [watchdog/3]
> root        29     2  0 Aug25 ?        00:00:00 [migration/4]
> root        30     2  0 Aug25 ?        00:00:00 [kworker/4:0]
> root        31     2  0 Aug25 ?        00:00:00 [rcuc/4]
> root        32     2  0 Aug25 ?        00:00:00 [ksoftirqd/4]
> root        33     2  0 Aug25 ?        00:00:00 [watchdog/4]
> root        34     2  0 Aug25 ?        00:00:00 [migration/5]
> root        36     2  0 Aug25 ?        00:00:00 [rcuc/5]
> root        37     2  0 Aug25 ?        00:00:00 [ksoftirqd/5]
> root        38     2  0 Aug25 ?        00:00:00 [watchdog/5]
> root        39     2  0 Aug25 ?        00:00:00 [migration/6]
> root        40     2  0 Aug25 ?        00:00:00 [kworker/6:0]
> root        41     2  0 Aug25 ?        00:00:00 [rcuc/6]
> root        42     2  0 Aug25 ?        00:00:00 [ksoftirqd/6]
> root        43     2  0 Aug25 ?        00:00:00 [watchdog/6]
> root        44     2  0 Aug25 ?        00:00:00 [migration/7]
> root        45     2  0 Aug25 ?        00:00:00 [kworker/7:0]
> root        46     2  0 Aug25 ?        00:00:00 [rcuc/7]
> root        47     2  0 Aug25 ?        00:00:00 [ksoftirqd/7]
> root        48     2  0 Aug25 ?        00:00:00 [watchdog/7]
> root        49     2  0 Aug25 ?        00:00:00 [migration/8]
> root        50     2  0 Aug25 ?        00:00:00 [kworker/8:0]
> root        51     2  0 Aug25 ?        00:00:00 [rcuc/8]
> root        52     2  0 Aug25 ?        00:00:00 [ksoftirqd/8]
> root        53     2  0 Aug25 ?        00:00:00 [watchdog/8]
> root        54     2  0 Aug25 ?        00:00:00 [migration/9]
> root        56     2  0 Aug25 ?        00:00:00 [rcuc/9]
> root        57     2  0 Aug25 ?        00:00:00 [ksoftirqd/9]
> root        58     2  0 Aug25 ?        00:00:00 [watchdog/9]
> root        59     2  0 Aug25 ?        00:00:00 [migration/10]
> root        60     2  0 Aug25 ?        00:00:00 [kworker/10:0]
> root        61     2  0 Aug25 ?        00:00:00 [rcuc/10]
> root        62     2  0 Aug25 ?        00:00:00 [ksoftirqd/10]
> root        63     2  0 Aug25 ?        00:00:00 [watchdog/10]
> root        64     2  0 Aug25 ?        00:00:00 [migration/11]
> root        66     2  0 Aug25 ?        00:00:00 [rcuc/11]
> root        67     2  0 Aug25 ?        00:00:00 [ksoftirqd/11]
> root        68     2  0 Aug25 ?        00:00:00 [watchdog/11]
> root        69     2  0 Aug25 ?        00:00:00 [migration/12]
> root        70     2  0 Aug25 ?        00:00:00 [kworker/12:0]
> root        71     2  0 Aug25 ?        00:00:00 [rcuc/12]
> root        72     2  0 Aug25 ?        00:00:00 [ksoftirqd/12]
> root        73     2  0 Aug25 ?        00:00:00 [watchdog/12]
> root        74     2  0 Aug25 ?        00:00:00 [migration/13]
> root        76     2  0 Aug25 ?        00:00:00 [rcuc/13]
> root        77     2  0 Aug25 ?        00:00:00 [ksoftirqd/13]
> root        78     2  0 Aug25 ?        00:00:00 [watchdog/13]
> root        79     2  0 Aug25 ?        00:00:00 [migration/14]
> root        80     2  0 Aug25 ?        00:00:00 [kworker/14:0]
> root        81     2  0 Aug25 ?        00:00:00 [rcuc/14]
> root        82     2  0 Aug25 ?        00:00:00 [ksoftirqd/14]
> root        83     2  0 Aug25 ?        00:00:00 [watchdog/14]
> root        84     2  0 Aug25 ?        00:00:00 [migration/15]
> root        86     2  0 Aug25 ?        00:00:00 [rcuc/15]
> root        87     2  0 Aug25 ?        00:00:00 [ksoftirqd/15]
> root        88     2  0 Aug25 ?        00:00:00 [watchdog/15]
> root        89     2  0 Aug25 ?        00:00:00 [migration/16]
> root        90     2  0 Aug25 ?        00:00:00 [kworker/16:0]
> root        91     2  0 Aug25 ?        00:00:00 [rcuc/16]
> root        92     2  0 Aug25 ?        00:00:00 [rcun/2]
> root        93     2  0 Aug25 ?        00:00:00 [rcub/2]
> root        94     2  0 Aug25 ?        00:00:00 [ksoftirqd/16]
> root        95     2  0 Aug25 ?        00:00:00 [watchdog/16]
> root        96     2  0 Aug25 ?        00:00:00 [migration/17]
> root        98     2  0 Aug25 ?        00:00:00 [rcuc/17]
> root        99     2  0 Aug25 ?        00:00:00 [ksoftirqd/17]
> root       100     2  0 Aug25 ?        00:00:00 [watchdog/17]
> root       101     2  0 Aug25 ?        00:00:00 [migration/18]
> root       102     2  0 Aug25 ?        00:00:00 [kworker/18:0]
> root       103     2  0 Aug25 ?        00:00:00 [rcuc/18]
> root       104     2  0 Aug25 ?        00:00:00 [ksoftirqd/18]
> root       105     2  0 Aug25 ?        00:00:00 [watchdog/18]
> root       106     2  0 Aug25 ?        00:00:00 [migration/19]
> root       107     2  0 Aug25 ?        00:00:00 [kworker/19:0]
> root       108     2  0 Aug25 ?        00:00:00 [rcuc/19]
> root       109     2  0 Aug25 ?        00:00:00 [ksoftirqd/19]
> root       110     2  0 Aug25 ?        00:00:00 [watchdog/19]
> root       111     2  0 Aug25 ?        00:00:00 [migration/20]
> root       112     2  0 Aug25 ?        00:00:00 [kworker/20:0]
> root       113     2  0 Aug25 ?        00:00:00 [rcuc/20]
> root       114     2  0 Aug25 ?        00:00:00 [ksoftirqd/20]
> root       115     2  0 Aug25 ?        00:00:00 [watchdog/20]
> root       116     2  0 Aug25 ?        00:00:00 [migration/21]
> root       117     2  0 Aug25 ?        00:00:00 [kworker/21:0]
> root       118     2  0 Aug25 ?        00:00:00 [rcuc/21]
> root       119     2  0 Aug25 ?        00:00:00 [ksoftirqd/21]
> root       120     2  0 Aug25 ?        00:00:00 [watchdog/21]
> root       121     2  0 Aug25 ?        00:00:00 [migration/22]
> root       122     2  0 Aug25 ?        00:00:00 [kworker/22:0]
> root       123     2  0 Aug25 ?        00:00:00 [rcuc/22]
> root       124     2  0 Aug25 ?        00:00:00 [ksoftirqd/22]
> root       125     2  0 Aug25 ?        00:00:00 [watchdog/22]
> root       126     2  0 Aug25 ?        00:00:00 [migration/23]
> root       128     2  0 Aug25 ?        00:00:00 [rcuc/23]
> root       129     2  0 Aug25 ?        00:00:00 [ksoftirqd/23]
> root       130     2  0 Aug25 ?        00:00:00 [watchdog/23]
> root       131     2  0 Aug25 ?        00:00:00 [migration/24]
> root       132     2  0 Aug25 ?        00:00:00 [kworker/24:0]
> root       133     2  0 Aug25 ?        00:00:00 [rcuc/24]
> root       134     2  0 Aug25 ?        00:00:00 [ksoftirqd/24]
> root       135     2  0 Aug25 ?        00:00:00 [watchdog/24]
> root       136     2  0 Aug25 ?        00:00:00 [migration/25]
> root       138     2  0 Aug25 ?        00:00:00 [rcuc/25]
> root       139     2  0 Aug25 ?        00:00:00 [ksoftirqd/25]
> root       140     2  0 Aug25 ?        00:00:00 [watchdog/25]
> root       141     2  0 Aug25 ?        00:00:00 [migration/26]
> root       142     2  0 Aug25 ?        00:00:00 [kworker/26:0]
> root       143     2  0 Aug25 ?        00:00:00 [rcuc/26]
> root       144     2  0 Aug25 ?        00:00:00 [ksoftirqd/26]
> root       145     2  0 Aug25 ?        00:00:00 [watchdog/26]
> root       146     2  0 Aug25 ?        00:00:00 [migration/27]
> root       147     2  0 Aug25 ?        00:00:00 [kworker/27:0]
> root       148     2  0 Aug25 ?        00:00:00 [rcuc/27]
> root       149     2  0 Aug25 ?        00:00:00 [ksoftirqd/27]
> root       150     2  0 Aug25 ?        00:00:00 [watchdog/27]
> root       151     2  0 Aug25 ?        00:00:00 [migration/28]
> root       152     2  0 Aug25 ?        00:00:00 [kworker/28:0]
> root       153     2  0 Aug25 ?        00:00:00 [rcuc/28]
> root       154     2  0 Aug25 ?        00:00:00 [ksoftirqd/28]
> root       155     2  0 Aug25 ?        00:00:00 [watchdog/28]
> root       156     2  0 Aug25 ?        00:00:00 [migration/29]
> root       157     2  0 Aug25 ?        00:00:00 [kworker/29:0]
> root       158     2  0 Aug25 ?        00:00:00 [rcuc/29]
> root       159     2  0 Aug25 ?        00:00:00 [ksoftirqd/29]
> root       160     2  0 Aug25 ?        00:00:00 [watchdog/29]
> root       161     2  0 Aug25 ?        00:00:00 [migration/30]
> root       162     2  0 Aug25 ?        00:00:00 [kworker/30:0]
> root       163     2  0 Aug25 ?        00:00:00 [rcuc/30]
> root       164     2  0 Aug25 ?        00:00:00 [ksoftirqd/30]
> root       165     2  0 Aug25 ?        00:00:00 [watchdog/30]
> root       166     2  0 Aug25 ?        00:00:00 [migration/31]
> root       167     2  0 Aug25 ?        00:00:00 [kworker/31:0]
> root       168     2  0 Aug25 ?        00:00:00 [rcuc/31]
> root       169     2  0 Aug25 ?        00:00:00 [ksoftirqd/31]
> root       170     2  0 Aug25 ?        00:00:00 [watchdog/31]
> root       171     2  0 Aug25 ?        00:00:00 [cpuset]
> root       172     2  0 Aug25 ?        00:00:00 [khelper]
> root       173     2  0 Aug25 ?        00:00:00 [netns]
> root       418     2  0 Aug25 ?        00:00:00 [sync_supers]
> root       420     2  0 Aug25 ?        00:00:00 [bdi-default]
> root       422     2  0 Aug25 ?        00:00:00 [kblockd]
> root       714     2  0 Aug25 ?        00:00:00 [ata_sff]
> root       724     2  0 Aug25 ?        00:00:00 [khubd]
> root       733     2  0 Aug25 ?        00:00:00 [kworker/30:1]
> root       735     2  0 Aug25 ?        00:00:00 [kworker/28:1]
> root       737     2  0 Aug25 ?        00:00:00 [kworker/26:1]
> root       739     2  0 Aug25 ?        00:00:00 [kworker/24:1]
> root       741     2  0 Aug25 ?        00:00:00 [kworker/22:1]
> root       743     2  0 Aug25 ?        00:00:00 [kworker/20:1]
> root       745     2  0 Aug25 ?        00:00:00 [kworker/18:1]
> root       747     2  0 Aug25 ?        00:00:00 [kworker/16:1]
> root       749     2  0 Aug25 ?        00:00:00 [kworker/14:1]
> root       751     2  0 Aug25 ?        00:00:00 [kworker/12:1]
> root       757     2  0 Aug25 ?        00:00:00 [kworker/10:1]
> root       759     2  0 Aug25 ?        00:00:00 [kworker/8:1]
> root       761     2  0 Aug25 ?        00:00:00 [kworker/6:1]
> root       763     2  0 Aug25 ?        00:00:00 [kworker/4:1]
> root       866     2  0 Aug25 ?        00:00:00 [rpciod]
> root       868     2  0 Aug25 ?        00:00:00 [kworker/2:1]
> root       975     2  0 Aug25 ?        00:00:00 [khungtaskd]
> root       981     2  0 Aug25 ?        00:00:00 [kswapd0]
> root       982     2  0 Aug25 ?        00:00:00 [khugepaged]
> root       983     2  0 Aug25 ?        00:00:00 [fsnotify_mark]
> root       984     2  0 Aug25 ?        00:00:00 [nfsiod]
> root       986     2  0 Aug25 ?        00:00:00 [crypto]
> root      1151     2  0 Aug25 ?        00:00:00 [kpsmoused]
> root      1167     2  0 Aug25 ?        00:00:00 [deferwq]
> root      1913     2  0 Aug25 ?        00:00:00 [bond0]
> root      2144     1  0 Aug25 ?        00:00:00 udevd --daemon
> root      2525     2  0 Aug25 ?        00:00:00 [scsi_eh_0]
> root      2537     2  0 Aug25 ?        00:00:00 [mlx4]
> root      2540     2  0 Aug25 ?        00:00:00 [scsi_eh_1]
> root      2541     2  0 Aug25 ?        00:00:00 [fw_event0]
> root      2595     2  0 Aug25 ?        00:00:00 [scsi_eh_2]
> root      2596     2  0 Aug25 ?        00:00:00 [scsi_eh_3]
> root      2597     2  0 Aug25 ?        00:00:00 [scsi_eh_4]
> root      2598     2  0 Aug25 ?        00:00:00 [scsi_eh_5]
> root      2599     2  0 Aug25 ?        00:00:00 [scsi_eh_6]
> root      2600     2  0 Aug25 ?        00:00:00 [scsi_eh_7]
> root      2667     2  0 Aug25 ?        00:00:00 [mlx4_en]
> root      2797  2144  0 Aug25 ?        00:00:00 udevd --daemon
> root      2798  2144  0 Aug25 ?        00:00:00 udevd --daemon
> root      2800     2  0 Aug25 ?        00:00:00 [mlx4_en]
> root      2817     2  0 Aug25 ?        00:00:00 [mlx4_en]
> root      2843     2  0 Aug25 ?        00:00:00 [poll_0_status]
> root      2844     2  0 Aug25 ?        00:00:00 [scsi_eh_8]
> root      2846     2  0 Aug25 ?        00:00:00 [fw_event1]
> root      2860     2  0 Aug25 ?        00:00:00 [poll_1_status]
> root      2861     2  0 Aug25 ?        00:00:00 [scsi_eh_9]
> root      2862     2  0 Aug25 ?        00:00:00 [fw_event2]
> root      2864     2  0 Aug25 ?        00:00:00 [poll_2_status]
> root      2865     2  0 Aug25 ?        00:00:00 [scsi_eh_10]
> root      2866     2  0 Aug25 ?        00:00:00 [fw_event3]
> root      2867     2  0 Aug25 ?        00:00:00 [poll_3_status]
> root      4059     2  0 Aug25 ?        00:00:00 [bond1]
> root      4464     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4470     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4476     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4482     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4488     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4494     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4500     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4506     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4512     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4518     2  0 Aug25 ?        00:00:00 [kdmflush]
> root      4527     2  0 Aug25 ?        00:00:00 [jbd2/dm-4-8]
> root      4528     2  0 Aug25 ?        00:00:00 [ext4-dio-unwrit]
> root      4593     1  0 Aug25 ?        00:00:00 /usr/sbin/rsyslogd -c5
> root      4627     1  0 Aug25 ?        00:00:00 /usr/sbin/sshd
> root      4645     1  0 Aug25 ?        00:00:00 /usr/sbin/acpid
> root      4683     1  0 Aug25 ?        00:00:00 /usr/sbin/cron
> ntp       4713     1  0 Aug25 ?        00:00:00 /usr/sbin/ntpd -g -c
> /etc/ntp.conf -p /var/run/ntpd.pid -u ntp:ntp
> daemon    4747     1  0 Aug25 ?        00:00:00 /sbin/portmap
> root      4773     1  0 Aug25 ?        00:00:00 /sbin/rpc.statd
> root      4796     1  0 Aug25 ttyS0    00:00:00 /sbin/getty -L 115200
> ttyS0 vt100
> root      4797     1  0 Aug25 ?        00:00:22 initBC                  

>                         
> root      4908     2  0 Aug25 ?        00:00:00 [xfsalloc]
> root      4909     2  0 Aug25 ?        00:00:00 [xfs_mru_cache]
> root      4910     2  0 Aug25 ?        00:00:00 [xfslogd]
> root      4930     2  0 Aug25 ?        00:00:00 [xfsbufd/sdc]
> root      4931     2  0 Aug25 ?        00:00:00 [xfs-data/sdc]
> root      4932     2  0 Aug25 ?        00:00:00 [xfs-conv/sdc]
> root      4933     2  0 Aug25 ?        00:00:01 [xfsaild/sdc]
> root      4935     2  0 Aug25 ?        00:00:00 [xfsbufd/sdd]
> root      4936     2  0 Aug25 ?        00:00:00 [xfs-data/sdd]
> root      4937     2  0 Aug25 ?        00:00:00 [xfs-conv/sdd]
> root      4938     2  0 Aug25 ?        00:00:01 [xfsaild/sdd]
> root      5115     1  6 Aug25 ?        00:11:28 [streamRT-sa] <defunct>
> root      6582     2  0 Aug25 ?        00:00:00 [kworker/1:2]
> root      6633     2  0 Aug25 ?        00:00:00 [kworker/23:1]
> root      6636     2  0 Aug25 ?        00:00:00 [kworker/15:0]
> root      6640     2  0 Aug25 ?        00:00:00 [kworker/29:2]
> root      6647     2  0 Aug25 ?        00:00:00 [kworker/3:1]
> root      6649     2  0 Aug25 ?        00:00:00 [kworker/25:2]
> root      6654     2  0 Aug25 ?        00:00:00 [kworker/1:0]
> root      6658     2  0 Aug25 ?        00:00:00 [kworker/19:1]
> root      6659     2  0 Aug25 ?        00:00:00 [kworker/21:1]
> root      6661     2  0 Aug25 ?        00:00:00 [kworker/27:2]
> root      6662     2  0 Aug25 ?        00:00:00 [kworker/15:2]
> root      6663     2  0 Aug25 ?        00:00:00 [kworker/5:2]
> root      6666     2  0 Aug25 ?        00:00:00 [kworker/31:2]
> root      6671     2  0 Aug25 ?        00:00:00 [kworker/0:4]
> root      6673     2  0 Aug25 ?        00:00:00 [kworker/7:3]
> root      6677     2  0 Aug25 ?        00:00:00 [kworker/0:6]
> root      6678     2  0 Aug25 ?        00:00:00 [kworker/0:7]
> root      6681     2  0 Aug25 ?        00:00:00 [kworker/0:10]
> root      6684     2  0 Aug25 ?        00:00:00 [kworker/13:5]
> root      6690     2  0 Aug25 ?        00:00:00 [kworker/9:4]
> root      6695     2  0 Aug25 ?        00:00:00 [kworker/7:5]
> root      6696     2  0 Aug25 ?        00:00:00 [kworker/13:7]
> root      6697     2  0 Aug25 ?        00:00:00 [kworker/9:6]
> root      6702     2  0 Aug25 ?        00:00:00 [kworker/0:11]
> root      6705     2  0 Aug25 ?        00:00:00 [kworker/0:14]
> root      6707     2  0 Aug25 ?        00:00:00 [kworker/0:16]
> root      6719     2  0 Aug25 ?        00:00:00 [kworker/0:24]
> root      6721     2  0 Aug25 ?        00:00:00 [kworker/0:26]
> root      6723     2  0 Aug25 ?        00:00:00 [kworker/9:8]
> root      6726     2  0 Aug25 ?        00:00:00 [kworker/31:5]
> root      6731     2  0 Aug25 ?        00:00:00 [kworker/1:7]
> root      6734     2  0 Aug25 ?        00:00:00 [kworker/11:6]
> root      6736     2  0 Aug25 ?        00:00:00 [kworker/13:10]
> root      6740     2  0 Aug25 ?        00:00:00 [kworker/0:30]
> root      6741     2  0 Aug25 ?        00:00:00 [kworker/0:31]
> root      6745     2  0 Aug25 ?        00:00:00 [kworker/9:9]
> root      6748     2  0 Aug25 ?        00:00:00 [kworker/0:36]
> root      6749     2  0 Aug25 ?        00:00:00 [kworker/19:3]
> root      6753     2  0 Aug25 ?        00:00:00 [kworker/23:3]
> root      6757     2  0 Aug25 ?        00:00:00 [kworker/13:12]
> root      6758     2  0 Aug25 ?        00:00:00 [kworker/7:6]
> root      6761     2  0 Aug25 ?        00:00:00 [kworker/0:41]
> root      6767     2  0 Aug25 ?        00:00:00 [kworker/0:44]
> root      6768     2  0 Aug25 ?        00:00:00 [kworker/5:7]
> root      6769     2  0 Aug25 ?        00:00:00 [kworker/1:9]
> root      6770     2  0 Aug25 ?        00:00:00 [kworker/0:45]
> root      6774     2  0 Aug25 ?        00:00:00 [kworker/17:7]
> root      6776     2  0 Aug25 ?        00:00:00 [kworker/3:4]
> root      6779     2  0 Aug25 ?        00:00:00 [kworker/11:9]
> root      6781     2  0 Aug25 ?        00:00:00 [kworker/0:50]
> root      6787     2  0 Aug25 ?        00:00:00 [kworker/0:53]
> root      6788     2  0 Aug25 ?        00:00:00 [kworker/25:1]
> root      6793     2  0 Aug25 ?        00:00:00 [kworker/1:10]
> root      6795     2  0 Aug25 ?        00:00:00 [kworker/27:4]
> root      6797     2  0 Aug25 ?        00:00:00 [kworker/0:57]
> root      6798     2  0 Aug25 ?        00:00:00 [kworker/0:58]
> root      6806     2  0 Aug25 ?        00:00:00 [kworker/15:5]
> root      6807     2  0 Aug25 ?        00:00:00 [kworker/0:62]
> root      6808     2  0 Aug25 ?        00:00:00 [kworker/0:63]
> root      6809     2  0 Aug25 ?        00:00:00 [kworker/17:8]
> root      6814     2  0 Aug25 ?        00:00:00 [kworker/0:66]
> root      6815     2  0 Aug25 ?        00:00:01 [kworker/0:67]
> root      6819     2  0 Aug25 ?        00:00:00 [kworker/0:69]
> root      6824     2  0 Aug25 ?        00:00:00 [kworker/25:3]
> root      6895     2  0 00:20 ?        00:00:00 [kworker/u:0]
> root      6900     2  0 00:26 ?        00:00:00 [kworker/u:1]
> root      6904     2  0 00:57 ?        00:00:00 [flush-0:20]
> root      6933     2  0 01:00 ?        00:00:00 [kworker/u:2]
> root      6934  4627  0 01:02 ?        00:00:00 sshd: iris [priv]
> iris      6936  6934  0 01:02 ?        00:00:00 sshd: iris@pts/1 
> iris      6937  6936  0 01:02 pts/1    00:00:00 -bash
> root      6967  6937  0 01:02 pts/1    00:00:00 sudo su
> root      6968  6967  0 01:02 pts/1    00:00:00 su
> root      6969  6968  0 01:02 pts/1    00:00:00 bash
> root      6976  6969  0 01:04 pts/1    00:00:00 ps -ef
> 
> # lsof|grep stream
> lsof: WARNING: can't stat() xfs file system /mnt/VOL1
>       Output information may be incomplete.
> bash      6937   iris  cwd       DIR               0,20     4096   
> 2113547 /iris/home/adrian/streamRT (mbc:/iris)
> sudo      6967   root  cwd       DIR               0,20     4096   
> 2113547 /iris/home/adrian/streamRT (mbc:/iris)
> su        6968   root  cwd       DIR               0,20     4096   
> 2113547 /iris/home/adrian/streamRT (mbc:/iris)
> bash      6969   root  cwd       DIR               0,20     4096   
> 2113547 /iris/home/adrian/streamRT (mbc:/iris)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

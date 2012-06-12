Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CFubmY001843 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 10:56:37 -0500
Received: from xsnews-ex.xsnews.local (exchange.xsnews.nl [78.152.36.69]) by
	cuda.sgi.com with ESMTP id XRUzUXdrL7RWd3er (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 08:56:29 -0700 (PDT)
Message-ID: <4FD766A7.9030908@xsnews.nl>
Date: Tue, 12 Jun 2012 17:56:23 +0200
From: Matthew Whittaker-Williams <matthew@xsnews.nl>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
In-Reply-To: <20120612011812.GK22848@dastard>
Content-Type: multipart/mixed; boundary="------------040606000601010808040507"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------040606000601010808040507
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/12 3:18 AM, Dave Chinner wrote:
> On Mon, Jun 11, 2012 at 11:37:23PM +0200, Matthew Whittaker-Williams wrote:
>> [ 6110.300098]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10
> That's pretty much a meaningless stack trace. Can you recompile your
> kernel with frame pointers enabled so we can get a reliable stack
> trace?

See attached for new trace.
>> Could you have a look into this issue?
> We know there is a lurking problem that we've been trying to flush
> out over the past couple of months. Do a search for hangs in
> xlog_grant_log_space - we've found several problems in
> the process, but there's still a remaining hang that is likely to be
> the source of your problems.

I see, it indeed seems about the same issues we encounter.
>> If you need any more information I am happy to provide it.
> What workload are you running that triggers this?

About our workload, we are providing usenet with diablo.
We are currently triggering the issue with running several 
diloadfromspool commands.
This will scan the entire spool and extracts article location size and 
message-id and placement information.

/news/dbin/diloadfromspool -a -S01 &
/news/dbin/diloadfromspool -a -S02 &
/news/dbin/diloadfromspool -a -S03 &
/news/dbin/diloadfromspool -a -S04 &
/news/dbin/diloadfromspool -a -S05 &
/news/dbin/diloadfromspool -a -S06 &
/news/dbin/diloadfromspool -a -S07 &
/news/dbin/diloadfromspool -a -S08 &
/news/dbin/diloadfromspool -a -S09 &
/news/dbin/diloadfromspool -a -S10 &
/news/dbin/diloadfromspool -a -S11 &
/news/dbin/diloadfromspool -a -S12 &
/news/dbin/diloadfromspool -a -S13 &
/news/dbin/diloadfromspool -a -S14 &
/news/dbin/diloadfromspool -a -S15 &
/news/dbin/diloadfromspool -a -S16 &

But we have also been able to produce the same trigger with running 
multiple bonnie++ commands.

nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie1 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie2 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie2 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie3 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie4 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie5 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie6 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie7 -f -b 
-n 1 -u root &
nohup bonnie++ -r 4096 -s 81920 -d /news/spool/news/P.01/bonnie8 -f -b 
-n 1 -u root &

It gets triggered when filesystem gets generally alot of reads.

Filesystem info:

meta-data=/dev/sda               isize=256    agcount=41, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=10741350400, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

meta-data=/dev/sdb               isize=256    agcount=41, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=10741350400, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Adapter 0 -- Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
Size                : 40.014 TB
State               : Optimal
Strip Size          : 64 KB
Number Of Drives    : 24
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Cached, No Write Cache if 
Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Cached, No Write Cache if 
Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Enabled
Encryption Type     : None


Virtual Drive: 1 (Target Id: 1)
Name                :
RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
Size                : 40.014 TB
State               : Optimal
Strip Size          : 1.0 MB
Number Of Drives    : 24
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Cached, No Write Cache if 
Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Cached, No Write Cache if 
Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Enabled
Encryption Type     : None


See attachement for controller info if this might help any bit.


>
> Cheers,
>
> Dave.


--------------040606000601010808040507
Content-Type: text/plain; name="kernel-trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="kernel-trace.txt"

Jun 12 17:02:45 sd70 kernel: imklog 4.6.4, log source = /proc/kmsg started.
Jun 12 17:06:27 sd70 kernel: [  323.966564] XFS (sdb): Mounting Filesystem
Jun 12 17:06:27 sd70 kernel: [  324.183373] XFS (sdb): Ending clean mount
Jun 12 17:09:23 sd70 kernel: Kernel logging (proc) stopped.
Jun 12 17:14:14 sd70 kernel: imklog 4.6.4, log source = /proc/kmsg started.
Jun 12 17:32:47 sd70 kernel: [ 1200.374551] INFO: task kworker/0:2:1115 blocked for more than 120 seconds.
Jun 12 17:32:47 sd70 kernel: [ 1200.374628] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 17:32:47 sd70 kernel: [ 1200.374722] kworker/0:2     D ffff8805ebdd3fa8     0  1115      2 0x00000000
Jun 12 17:32:47 sd70 kernel: [ 1200.374860]  ffff880602ae7bf0 0000000000000046 ffffffff814cecd0 ffff880603c56840
Jun 12 17:32:47 sd70 kernel: [ 1200.375098]  0000000000000400 ffff880602ae6010 0000000000013340 0000000000013340
Jun 12 17:32:47 sd70 kernel: [ 1200.375336]  ffff880602ae7fd8 0000000000013340 ffff880602ae7fd8 0000000000013340
Jun 12 17:32:47 sd70 kernel: [ 1200.375573] Call Trace:
Jun 12 17:32:47 sd70 kernel: [ 1200.375641]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:47 sd70 kernel: [ 1200.375709]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:47 sd70 kernel: [ 1200.375775]  [<ffffffff8137d912>] __down_common+0x96/0xe4
Jun 12 17:32:47 sd70 kernel: [ 1200.375858]  [<ffffffffa034338c>] ? xfs_getsb+0x32/0x60 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.375928]  [<ffffffff8137d9bf>] __down+0x18/0x1a
Jun 12 17:32:47 sd70 kernel: [ 1200.375996]  [<ffffffff81060428>] down+0x28/0x38
Jun 12 17:32:47 sd70 kernel: [ 1200.376071]  [<ffffffffa02f4786>] xfs_buf_lock+0x6f/0xc0 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.376155]  [<ffffffffa034338c>] xfs_getsb+0x32/0x60 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.376235]  [<ffffffffa035065c>] xfs_trans_getsb+0xb3/0x107 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.376319]  [<ffffffffa0343da5>] xfs_mod_sb+0x41/0x112 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.376401]  [<ffffffffa0303bac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.376482]  [<ffffffffa02f9434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.382394]  [<ffffffffa034a656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.382534]  [<ffffffffa0303bea>] xfs_sync_worker+0x3e/0x64 [xfs]
Jun 12 17:32:47 sd70 kernel: [ 1200.382607]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
Jun 12 17:32:47 sd70 kernel: [ 1200.382741]  [<ffffffff8105531e>] worker_thread+0x13e/0x264
Jun 12 17:32:47 sd70 kernel: [ 1200.382884]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:47 sd70 kernel: [ 1200.383007]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:47 sd70 kernel: [ 1200.383119]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:47 sd70 kernel: [ 1200.383258]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:47 sd70 kernel: [ 1200.383331]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: 1386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.488066]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.488140]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.488252] kworker/2:1     S ffff8806039202e8     0    30      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.488398]  ffff88060390be70 0000000000000046 ffff88060390be20 ffffffff8129868a
Jun 12 17:32:48 sd70 kernel: [ 1201.488635]  ffff88060390be00 ffff88060390a010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.488873]  ffff88060390bfd8 0000000000013340 ffff88060390bfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.489109] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.489170]  [<ffffffff8129868a>] ? do_dbs_timer+0xe1/0xef
Jun 12 17:32:48 sd70 kernel: [ 1201.489240]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.489308]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.489377]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.489447]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.489515]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.489585]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.489658]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.489726] kworker/3:1     S ffff880603e1a4a8     0    31      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.489865]  ffff880603945e70 0000000000000046 ffff880603945e20 ffffffff8129868a
Jun 12 17:32:48 sd70 kernel: [ 1201.490110]  ffff880603945e00 ffff880603944010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.490348]  ffff880603945fd8 0000000000013340 ffff880603945fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.490585] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.490646]  [<ffffffff8129868a>] ? do_dbs_timer+0xe1/0xef
Jun 12 17:32:48 sd70 kernel: [ 1201.490715]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.490783]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.490852]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.490923]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.490991]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.491061]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.491135]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.491202] khungtaskd      S ffff880603e3b8e8     0    32      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.491349]  ffff8805ecd57e20 0000000000000046 ffff8805ecd57dd0 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.491585]  ffff8805ecd57dd0 ffff8805ecd56010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.491823]  ffff8805ecd57fd8 0000000000013340 ffff8805ecd57fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.492060] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.492122]  [<ffffffff810a3ed2>] ? check_hung_uninterruptible_tasks+0x1c8/0x1c8
Jun 12 17:32:48 sd70 kernel: [ 1201.492211]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.492278]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.492348]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.492418]  [<ffffffff8137d091>] schedule_timeout_interruptible+0x19/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.492491]  [<ffffffff810a3f0f>] watchdog+0x3d/0x4c
Jun 12 17:32:48 sd70 kernel: [ 1201.492558]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.492626]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.492697]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.492770]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.492838] kswapd0         S ffff880603e3bfa8     0    33      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.492984]  ffff880602fe3de0 0000000000000046 ffffffff8167c938 0000000000000f44
Jun 12 17:32:48 sd70 kernel: [ 1201.493221]  ffff88061fffc000 ffff880602fe2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.493458]  ffff880602fe3fd8 0000000000013340 ffff880602fe3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.493694] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.493756]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.493826]  [<ffffffff810dd7a9>] kswapd_try_to_sleep+0x125/0x16a
Jun 12 17:32:48 sd70 kernel: [ 1201.493896]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.493965]  [<ffffffff810df540>] kswapd+0xe7/0x19f
Jun 12 17:32:48 sd70 kernel: [ 1201.494033]  [<ffffffff810df459>] ? balance_pgdat+0x73b/0x73b
Jun 12 17:32:48 sd70 kernel: [ 1201.494103]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.494171]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.494241]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.494315]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.494382] ksmd            S ffff880603e3c668     0    34      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.494528]  ffff880602fe5e50 0000000000000046 ffff880603e3c380 ffff880603e3c380
Jun 12 17:32:48 sd70 kernel: [ 1201.494764]  ffff880602fe5df0 ffff880602fe4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.495001]  ffff880602fe5fd8 0000000000013340 ffff880602fe5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.495238] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.495299]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.495404]  [<ffffffff81105c33>] ksm_scan_thread+0x1aa/0x233
Jun 12 17:32:48 sd70 kernel: [ 1201.495474]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.495543]  [<ffffffff81105a89>] ? cmp_and_merge_page+0x2ee/0x2ee
Jun 12 17:32:48 sd70 kernel: [ 1201.495613]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.495747]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.495817]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.495890]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.501511] fsnotify_mark   S ffff880603e3cd28     0    35      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.501652]  ffff8805ecd8de40 0000000000000046 ffff8805ecd8de00 ffffffff81059450
Jun 12 17:32:48 sd70 kernel: [ 1201.501885]  0000000000000000 ffff8805ecd8c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.502119]  ffff8805ecd8dfd8 0000000000013340 ffff8805ecd8dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.502352] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.502412]  [<ffffffff81059450>] ? wait_rcu_gp+0x46/0x4f
Jun 12 17:32:48 sd70 kernel: [ 1201.502480]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.502547]  [<ffffffff811412ab>] fsnotify_mark_destroy+0x131/0x147
Jun 12 17:32:48 sd70 kernel: [ 1201.502616]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.502684]  [<ffffffff8114117a>] ? fsnotify_set_mark_ignored_mask_locked+0x1e/0x1e
Jun 12 17:32:48 sd70 kernel: [ 1201.502773]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.502839]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.502909]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.502981]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.503047] crypto          S ffff880603e3d3e8     0    36      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.503192]  ffff8805ecdb9e50 0000000000000046 ffff8805ecdb9df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.503426]  ffff8805ecdb9df0 ffff8805ecdb8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.503659]  ffff8805ecdb9fd8 0000000000013340 ffff8805ecdb9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.503893] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.503953]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.504022]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.504089]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.504157]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.504227]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.504299]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.504367]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.504438]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.504511]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.504578] deferwq         S ffff880603e3e828     0    39      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.504724]  ffff8805ecdc3e50 0000000000000046 ffff8805ecdc3df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.504961]  ffff8805ecdc3df0 ffff8805ecdc2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.505198]  ffff8805ecdc3fd8 0000000000013340 ffff8805ecdc3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.505434] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.505495]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.505565]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.505633]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.505703]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.505773]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.505842]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.505910]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.505981]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.506054]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.506121] scsi_eh_0       S ffff8805ece13800     0   232      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.506268]  ffff8805ebc29e90 0000000000000046 ffff8805ece13800 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.506505]  ffff88061fc33340 ffff8805ebc28010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.506741]  ffff8805ebc29fd8 0000000000013340 ffff8805ebc29fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.506978] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.507039]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.507122]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.507198]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.507272]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.507339]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.507411]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.507484]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.507551] khubd           S ffff880603901068     0   236      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.507698]  ffff8805ebc99e50 0000000000000046 ffff8805ebc99e60 ffffffffa009e6b2
Jun 12 17:32:48 sd70 kernel: [ 1201.507935]  0000000000000002 ffff8805ebc98010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.508231]  ffff8805ebc99fd8 0000000000013340 ffff8805ebc99fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.508469] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.508534]  [<ffffffffa009e6b2>] ? hub_events+0x1d/0x685 [usbcore]
Jun 12 17:32:48 sd70 kernel: [ 1201.508605]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.508675]  [<ffffffffa009ee06>] hub_thread+0xec/0x1a1 [usbcore]
Jun 12 17:32:48 sd70 kernel: [ 1201.508744]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.508816]  [<ffffffffa009ed1a>] ? hub_events+0x685/0x685 [usbcore]
Jun 12 17:32:48 sd70 kernel: [ 1201.508886]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.508952]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.509022]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.509094]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.509161] mpt_poll_0      S ffff880603901728     0   244      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.509306]  ffff8805ec071e50 0000000000000046 ffff8805ec071df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.509539]  ffff8805ec071df0 ffff8805ec070010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.509772]  ffff8805ec071fd8 0000000000013340 ffff8805ec071fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.510005] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.510065]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.510135]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.510201]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.510270]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.510339]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.510407]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.510474]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.510543]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.510615]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.510681] mpt/0           S ffff880603903fa8     0   245      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.510826]  ffff8805ea4f3e50 0000000000000046 ffff8805ea4f3df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.511059]  ffff8805ea4f3df0 ffff8805ea4f2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.511293]  ffff8805ea4f3fd8 0000000000013340 ffff8805ea4f3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.511525] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.511586]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.511655]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.511722]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.511790]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.511859]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.511927]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.511993]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.512063]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.512135]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.512205] ata_sff         S ffff8805eb5f6ee8     0   246      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.512352]  ffff8805ebb03e50 0000000000000046 ffff8805ebb03df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.512589]  ffff8805ebb03df0 ffff8805ebb02010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.512826]  ffff8805ebb03fd8 0000000000013340 ffff8805ebb03fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.513063] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.513124]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.513195]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.513263]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.513333]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.513402]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.513471]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.513539]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.513610]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.513683]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.513750] scsi_eh_1       S ffff8805ec644d28     0   262      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.513897]  ffff8805ec62de90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.514134]  ffff8805ec62de50 ffff8805ec62c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.514371]  ffff8805ec62dfd8 0000000000013340 ffff8805ec62dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.514607] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.514668]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.514740]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.514817]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.514890]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.514954]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.515019]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.515092]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.515162] scsi_eh_2       S ffff880603905aa8     0   263      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.515312]  ffff8805ebe09e90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.515548]  ffff8805ebe09e50 ffff8805ebe08010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.515785]  ffff8805ebe09fd8 0000000000013340 ffff8805ebe09fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.516084] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.516146]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.516217]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.516294]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.516366]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.516434]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.516569]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.516643]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.516710] scsi_eh_3       S ffff8805eb5f75a8     0   264      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.516857]  ffff8805ea767e90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.517093]  ffff8805ea767e50 ffff8805ea766010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.517330]  ffff8805ea767fd8 0000000000013340 ffff8805ea767fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.517566] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.517628]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.517699]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.517775]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.517848]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.517916]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.517987]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.518059]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.523650] scsi_eh_4       S ffff8805ec6453e8     0   265      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.523797]  ffff8805eb6e7e90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.524170]  ffff8805eb6e7e50 ffff8805eb6e6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.524456]  ffff8805eb6e7fd8 0000000000013340 ffff8805eb6e7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.524754] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.524815]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.524886]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.524963]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.525035]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.525103]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.525174]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.525247]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.525314] scsi_eh_5       S ffff880603904d28     0   266      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.525461]  ffff8805ebee5e90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.525693]  ffff8805ebee5e50 ffff8805ebee4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.525931]  ffff8805ebee5fd8 0000000000013340 ffff8805ebee5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.526169] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.526227]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.526294]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.526369]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.526444]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.526515]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.526653]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.526726]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.526793] scsi_eh_6       S ffff8805eb5f2b68     0   267      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.526940]  ffff8805eb727e90 0000000000000046 0000000000000000 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.527176]  ffff8805eb727e50 ffff8805eb726010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.527413]  ffff8805eb727fd8 0000000000013340 ffff8805eb727fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.527650] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.527711]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.527783]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.527859]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.527932]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.528060]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.528130]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.528203]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.528270] kworker/u:4     S ffff8805eabadb00     0   270      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.528417]  ffff8805eb5b9e70 0000000000000046 ffff8805ebd64180 ffff8805ebd64190
Jun 12 17:32:48 sd70 kernel: [ 1201.528654]  ffff8805eb5b9e20 ffff8805eb5b8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.528890]  ffff8805eb5b9fd8 0000000000013340 ffff8805eb5b9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.529127] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.529189]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.529256]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.529326]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.529396]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.529464]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.529534]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.529607]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.529675] kworker/u:5     S ffff8805ec646168     0   271      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.529822]  ffff8805ec3e7e70 0000000000000046 ffff8805ec3e7df0 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.530059]  ffff8805ec3e7e20 ffff8805ec3e6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.530296]  ffff8805ec3e7fd8 0000000000013340 ffff8805ec3e7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.530532] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.530594]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.530661]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.530731]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.530801]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.530869]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.530940]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.531013]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.531080] scsi_eh_7       S ffff8805ebdd75a8     0   295      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.531226]  ffff8805eb4f1e90 0000000000000046 ffff8805ece13480 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.531464]  ffff88061fc73340 ffff8805eb4f0010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.531700]  ffff8805eb4f1fd8 0000000000013340 ffff8805eb4f1fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.531937] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.531998]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.532070]  [<ffffffffa0006a1c>] scsi_error_handler+0x80/0x1a3 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.532147]  [<ffffffffa000699c>] ? scsi_unjam_host+0x1a5/0x1a5 [scsi_mod]
Jun 12 17:32:48 sd70 kernel: [ 1201.532219]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.532287]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.532357]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.532431]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.532498] loop0           S ffff8805ec016168     0   620      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.532645]  ffff8805eaf29e40 0000000000000046 ffff8805eaf29dc0 ffffffff810cf725
Jun 12 17:32:48 sd70 kernel: [ 1201.532882]  ffff8805eaf29de0 ffff8805eaf28010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.533118]  ffff8805eaf29fd8 0000000000013340 ffff8805eaf29fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.533355] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.533417]  [<ffffffff810cf725>] ? mempool_free_slab+0x12/0x14
Jun 12 17:32:48 sd70 kernel: [ 1201.533487]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.533557]  [<ffffffffa01c969f>] loop_thread+0xbe/0x22e [loop]
Jun 12 17:32:48 sd70 kernel: [ 1201.533627]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.533698]  [<ffffffffa01c95e1>] ? do_bio_filebacked+0x2ae/0x2ae [loop]
Jun 12 17:32:48 sd70 kernel: [ 1201.533770]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.533837]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.533908]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.533981]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.534048] udevd           S ffff8805ec48e168     0   946      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.534195]  ffff8805ecee99e8 0000000000000082 0000000000000041 ffff8805ecee9e3c
Jun 12 17:32:48 sd70 kernel: [ 1201.534432]  ffff8805ecee9998 ffff8805ecee8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.534668]  ffff8805ecee9fd8 0000000000013340 ffff8805ecee9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.534905] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.534966]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.535034]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.535107]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.535177]  [<ffffffff8111f52c>] ? __pollwait+0xbe/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535246]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.535318]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.535388]  [<ffffffff8111f83c>] do_poll+0x1da/0x1ff
Jun 12 17:32:48 sd70 kernel: [ 1201.535457]  [<ffffffff811204ad>] do_sys_poll+0x166/0x1d7
Jun 12 17:32:48 sd70 kernel: [ 1201.535526]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535594]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535663]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535732]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535801]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.535871]  [<ffffffff810aad21>] ? call_rcu_sched+0x12/0x14
Jun 12 17:32:48 sd70 kernel: [ 1201.535941]  [<ffffffff810413ab>] ? release_task+0xf5/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.536060]  [<ffffffff8104194c>] ? wait_task_zombie+0x590/0x5a7
Jun 12 17:32:48 sd70 kernel: [ 1201.536131]  [<ffffffff8105c268>] ? remove_wait_queue+0x4c/0x51
Jun 12 17:32:48 sd70 kernel: [ 1201.536201]  [<ffffffff8104250b>] ? do_wait+0x1d7/0x21a
Jun 12 17:32:48 sd70 kernel: [ 1201.536270]  [<ffffffff810425f6>] ? sys_wait4+0xa8/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.536338]  [<ffffffff811206b0>] sys_poll+0x4e/0xb7
Jun 12 17:32:48 sd70 kernel: [ 1201.536406]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.536475] kworker/0:2     D ffff8805ebdd3fa8     0  1115      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.536622]  ffff880602ae7bf0 0000000000000046 ffffffff814cecd0 ffff880603c56840
Jun 12 17:32:48 sd70 kernel: [ 1201.536858]  0000000000000400 ffff880602ae6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.537095]  ffff880602ae7fd8 0000000000013340 ffff880602ae7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.537331] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.537392]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.537460]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.537530]  [<ffffffff8137d912>] __down_common+0x96/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.537613]  [<ffffffffa034338c>] ? xfs_getsb+0x32/0x60 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.537683]  [<ffffffff8137d9bf>] __down+0x18/0x1a
Jun 12 17:32:48 sd70 kernel: [ 1201.537750]  [<ffffffff81060428>] down+0x28/0x38
Jun 12 17:32:48 sd70 kernel: [ 1201.537824]  [<ffffffffa02f4786>] xfs_buf_lock+0x6f/0xc0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.537907]  [<ffffffffa034338c>] xfs_getsb+0x32/0x60 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.537987]  [<ffffffffa035065c>] xfs_trans_getsb+0xb3/0x107 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538071]  [<ffffffffa0343da5>] xfs_mod_sb+0x41/0x112 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538153]  [<ffffffffa0303bac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538233]  [<ffffffffa02f9434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538316]  [<ffffffffa034a656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538400]  [<ffffffffa0303bea>] xfs_sync_worker+0x3e/0x64 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.538471]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.538541]  [<ffffffff8105531e>] worker_thread+0x13e/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.538610]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.538680]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.538748]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.538819]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.538892]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.538959] ifup            S ffff880603921068     0  1234      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.539106]  ffff8805bc5b7e48 0000000000000086 00007f71645664f8 ffff880500000065
Jun 12 17:32:48 sd70 kernel: [ 1201.539343]  ffffffff8106ec4e ffff8805bc5b6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.539579]  ffff8805bc5b7fd8 0000000000013340 ffff8805bc5b7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.539816] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.539877]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:32:48 sd70 kernel: [ 1201.539947]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.540015]  [<ffffffff810424da>] do_wait+0x1a6/0x21a
Jun 12 17:32:48 sd70 kernel: [ 1201.540150]  [<ffffffff8106a645>] ? wake_up_new_task+0xc2/0xce
Jun 12 17:32:48 sd70 kernel: [ 1201.540220]  [<ffffffff8103dc1c>] ? do_fork+0x193/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.540288]  [<ffffffff810425e7>] sys_wait4+0x99/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.540356]  [<ffffffff81114852>] ? sys_newstat+0x2d/0x38
Jun 12 17:32:48 sd70 kernel: [ 1201.545900]  [<ffffffff810406fb>] ? wait_task_continued+0x14c/0x14c
Jun 12 17:32:48 sd70 kernel: [ 1201.545970]  [<ffffffff8137f0e5>] ? page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.546038]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.546107] dhclient        S ffff8805ec6b5aa8     0  1633   1234 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.546252]  ffff8806012d3918 0000000000000086 0000000000000000 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.546485]  ffff8806012d38c8 ffff8806012d2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.546719]  ffff8806012d3fd8 0000000000013340 ffff8806012d3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.546952] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.547013]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.547079]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.547152]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.547220]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.547290]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.547360]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.547430]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.547497]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.547565]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.547633]  [<ffffffff81308df6>] ? udp_recvmsg+0x1c7/0x23b
Jun 12 17:32:48 sd70 kernel: [ 1201.547701]  [<ffffffff8130f54e>] ? inet_recvmsg+0x66/0x77
Jun 12 17:32:48 sd70 kernel: [ 1201.547770]  [<ffffffff812aa5f7>] ? __sock_recvmsg_nosec+0x65/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.547840]  [<ffffffff812ab41e>] ? __sock_recvmsg+0x49/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.547909]  [<ffffffff812abaa3>] ? sock_recvmsg+0xa6/0xbf
Jun 12 17:32:48 sd70 kernel: [ 1201.547978]  [<ffffffff810cdbc8>] ? unlock_page+0x25/0x29
Jun 12 17:32:48 sd70 kernel: [ 1201.548046]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.548115]  [<ffffffff812ab5a8>] ? move_addr_to_user+0x76/0xaa
Jun 12 17:32:48 sd70 kernel: [ 1201.548185]  [<ffffffff812abfd7>] ? sys_recvfrom+0x11a/0x147
Jun 12 17:32:48 sd70 kernel: [ 1201.548254]  [<ffffffff81014fc6>] ? read_tsc+0x9/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.548321]  [<ffffffff8107a59a>] ? timekeeping_get_ns+0x15/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.548390]  [<ffffffff8107b707>] ? ktime_get_ts+0x80/0x89
Jun 12 17:32:48 sd70 kernel: [ 1201.548458]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.548526]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.548594] uptimed         S ffff8805eb5f4668     0  1705      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.548739]  ffff8805ec687e48 0000000000000082 ffff8805ec687dc8 ffffffff8111b17f
Jun 12 17:32:48 sd70 kernel: [ 1201.548972]  ffff8805ec687f68 ffff8805ec686010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.549206]  ffff8805ec687fd8 0000000000013340 ffff8805ec687fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.549439] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.549499]  [<ffffffff8111b17f>] ? putname+0x2d/0x36
Jun 12 17:32:48 sd70 kernel: [ 1201.549566]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.549632]  [<ffffffff8137d71c>] do_nanosleep+0x70/0xb2
Jun 12 17:32:48 sd70 kernel: [ 1201.549700]  [<ffffffff8105f516>] hrtimer_nanosleep+0xba/0x13b
Jun 12 17:32:48 sd70 kernel: [ 1201.549769]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.549837]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.549908]  [<ffffffff8105f5f5>] sys_nanosleep+0x5e/0x72
Jun 12 17:32:48 sd70 kernel: [ 1201.549976]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.550044] atd             S ffff8805ec69a4a8     0  1708      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.550189]  ffff8806011a1e48 0000000000000082 ffff880606dd4a38 ffff880606dd4a38
Jun 12 17:32:48 sd70 kernel: [ 1201.550423]  ffff8806011a1dd8 ffff8806011a0010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.550656]  ffff8806011a1fd8 0000000000013340 ffff8806011a1fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.550890] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.550950]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.551017]  [<ffffffff8137d71c>] do_nanosleep+0x70/0xb2
Jun 12 17:32:48 sd70 kernel: [ 1201.551084]  [<ffffffff8105f516>] hrtimer_nanosleep+0xba/0x13b
Jun 12 17:32:48 sd70 kernel: [ 1201.551153]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.551222]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.551292]  [<ffffffff8105f5f5>] sys_nanosleep+0x5e/0x72
Jun 12 17:32:48 sd70 kernel: [ 1201.551360]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.551429] dbus-daemon     S ffff8805ec6b6828     0  1718      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.551573]  ffff88060102f9e8 0000000000000086 ffff8800dec4a230 ffff8805ba246000
Jun 12 17:32:48 sd70 kernel: [ 1201.551807]  00000000005ba246 ffff88060102e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.552040]  ffff88060102ffd8 0000000000013340 ffff88060102ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.552273] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.552334]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.552400]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.552472]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.552540]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.552611]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.552681]  [<ffffffff8111f83c>] do_poll+0x1da/0x1ff
Jun 12 17:32:48 sd70 kernel: [ 1201.552749]  [<ffffffff811204ad>] do_sys_poll+0x166/0x1d7
Jun 12 17:32:48 sd70 kernel: [ 1201.552816]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.552884]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.552951]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.553019]  [<ffffffff810cdbc8>] ? unlock_page+0x25/0x29
Jun 12 17:32:48 sd70 kernel: [ 1201.553087]  [<ffffffff810ecc12>] ? __do_fault+0x3a7/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.553155]  [<ffffffff810edbe9>] ? handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.553225]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.553295]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.553364]  [<ffffffff81382033>] ? do_page_fault+0x34a/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.553432]  [<ffffffff81111cd8>] ? alloc_file+0x19/0xab
Jun 12 17:32:48 sd70 kernel: [ 1201.553500]  [<ffffffff8104bdd7>] ? do_sigaction+0x80/0x187
Jun 12 17:32:48 sd70 kernel: [ 1201.553569]  [<ffffffff8111d6a3>] ? set_close_on_exec+0x2f/0x57
Jun 12 17:32:48 sd70 kernel: [ 1201.553638]  [<ffffffff811206b0>] sys_poll+0x4e/0xb7
Jun 12 17:32:48 sd70 kernel: [ 1201.553705]  [<ffffffff8137f0e5>] ? page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.553772]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.553841] dnsmasq         S ffff8805ec69f5a8     0  1728      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.553986]  ffff8805bc7db918 0000000000000082 ffff8805bc7db968 ffff8805ebd26400
Jun 12 17:32:48 sd70 kernel: [ 1201.554219]  ffff8805ebc72100 ffff8805bc7da010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.554453]  ffff8805bc7dbfd8 0000000000013340 ffff8805bc7dbfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.554687] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.554747]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.554814]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.554886]  [<ffffffff812eb50f>] ? ip_output+0x58/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.554954]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.555022]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.555090]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.555160]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.555230]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.555298]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555365]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555433]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555501]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555568]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555636]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.555704]  [<ffffffff812ab41e>] ? __sock_recvmsg+0x49/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.555773]  [<ffffffff81108d59>] ? __slab_free+0xe1/0x22d
Jun 12 17:32:48 sd70 kernel: [ 1201.555842]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.555911]  [<ffffffff81109a27>] ? kmem_cache_free+0x6f/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.555980]  [<ffffffff81121ac3>] ? __d_free+0x51/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.556047]  [<ffffffff81121b0b>] ? d_free+0x43/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.556113]  [<ffffffff81122e0a>] ? dentry_kill+0x151/0x15d
Jun 12 17:32:48 sd70 kernel: [ 1201.556181]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.556249]  [<ffffffff8111222a>] ? fput+0x15/0x17
Jun 12 17:32:48 sd70 kernel: [ 1201.556315]  [<ffffffff8110f0c1>] ? filp_close+0x6d/0x78
Jun 12 17:32:48 sd70 kernel: [ 1201.556383]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.556451] irqbalance      S ffff8805ec69ab68     0  1745      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.556596]  ffff8805bc7a7e48 0000000000000086 ffff880602bc0958 ffff88020895e170
Jun 12 17:32:48 sd70 kernel: [ 1201.556830]  ffff8805bc7a7de8 ffff8805bc7a6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.557063]  ffff8805bc7a7fd8 0000000000013340 ffff8805bc7a7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.557297] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.557357]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.557423]  [<ffffffff8137d71c>] do_nanosleep+0x70/0xb2
Jun 12 17:32:48 sd70 kernel: [ 1201.557491]  [<ffffffff811227ad>] ? __d_drop+0x14/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.557558]  [<ffffffff8105f516>] hrtimer_nanosleep+0xba/0x13b
Jun 12 17:32:48 sd70 kernel: [ 1201.557627]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.557695]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.557766]  [<ffffffff8105f5f5>] sys_nanosleep+0x5e/0x72
Jun 12 17:32:48 sd70 kernel: [ 1201.557834]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.557902] cron            S ffff8805ec69e168     0  1862      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.558047]  ffff88060284de48 0000000000000082 ffff8805ec69de80 ffffffffff600400
Jun 12 17:32:48 sd70 kernel: [ 1201.558280]  0000000000000015 ffff88060284c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.558514]  ffff88060284dfd8 0000000000013340 ffff88060284dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.558747] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.558807]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.558873]  [<ffffffff8137d71c>] do_nanosleep+0x70/0xb2
Jun 12 17:32:48 sd70 kernel: [ 1201.558941]  [<ffffffff8105f516>] hrtimer_nanosleep+0xba/0x13b
Jun 12 17:32:48 sd70 kernel: [ 1201.559011]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.559079]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.559150]  [<ffffffff8105f5f5>] sys_nanosleep+0x5e/0x72
Jun 12 17:32:48 sd70 kernel: [ 1201.559217]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.559286] dhclient        S ffff8805ec6982e8     0  1886      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.559431]  ffff880602bd7918 0000000000000086 0000000000000000 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.559664]  ffff880602bd78c8 ffff880602bd6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.559898]  ffff880602bd7fd8 0000000000013340 ffff880602bd7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.560203] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.560264]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.560332]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.560405]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.560475]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.560546]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.560618]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.560689]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.560758]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.560827]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.560895]  [<ffffffff81308df6>] ? udp_recvmsg+0x1c7/0x23b
Jun 12 17:32:48 sd70 kernel: [ 1201.560965]  [<ffffffff8130f54e>] ? inet_recvmsg+0x66/0x77
Jun 12 17:32:48 sd70 kernel: [ 1201.561034]  [<ffffffff812aa5f7>] ? __sock_recvmsg_nosec+0x65/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.561105]  [<ffffffff812ab41e>] ? __sock_recvmsg+0x49/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.566647]  [<ffffffff812abaa3>] ? sock_recvmsg+0xa6/0xbf
Jun 12 17:32:48 sd70 kernel: [ 1201.566716]  [<ffffffff812ab522>] ? sock_aio_read+0xf9/0x109
Jun 12 17:32:48 sd70 kernel: [ 1201.566785]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.566853]  [<ffffffff811108e9>] ? do_sync_read+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.566922]  [<ffffffff812ab5a8>] ? move_addr_to_user+0x76/0xaa
Jun 12 17:32:48 sd70 kernel: [ 1201.566991]  [<ffffffff812abfd7>] ? sys_recvfrom+0x11a/0x147
Jun 12 17:32:48 sd70 kernel: [ 1201.567059]  [<ffffffff81014fc6>] ? read_tsc+0x9/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.567126]  [<ffffffff8107a59a>] ? timekeeping_get_ns+0x15/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.567196]  [<ffffffff8107b707>] ? ktime_get_ts+0x80/0x89
Jun 12 17:32:48 sd70 kernel: [ 1201.567264]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.567331]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.567399] sshd            S ffff880603923fa8     0  1969      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.567544]  ffff8805fd725918 0000000000000086 ffffea00166d5840 0000000000000001
Jun 12 17:32:48 sd70 kernel: [ 1201.567777]  0000000000000202 ffff8805fd724010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.568011]  ffff8805fd725fd8 0000000000013340 ffff8805fd725fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.568251] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.568313]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.568380]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.568454]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.568523]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.568595]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.568665]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.568735]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.568803]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.568872]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.568941]  [<ffffffff810d4a84>] ? __alloc_pages_nodemask+0x12a/0x1ae
Jun 12 17:32:48 sd70 kernel: [ 1201.569014]  [<ffffffff811c22f9>] ? cpumask_any_but+0x29/0x36
Jun 12 17:32:48 sd70 kernel: [ 1201.569085]  [<ffffffff810d8569>] ? __lru_cache_add+0x2f/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.569155]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.569226]  [<ffffffff810f42fe>] ? page_add_new_anon_rmap+0x75/0x87
Jun 12 17:32:48 sd70 kernel: [ 1201.569297]  [<ffffffff810ed22c>] ? do_wp_page+0x5df/0x5f9
Jun 12 17:32:48 sd70 kernel: [ 1201.569367]  [<ffffffff8110b726>] ? kmem_cache_alloc+0x61/0x118
Jun 12 17:32:48 sd70 kernel: [ 1201.569437]  [<ffffffff812ab3c5>] ? sock_aio_write+0xf1/0x101
Jun 12 17:32:48 sd70 kernel: [ 1201.569507]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.569576]  [<ffffffff81124855>] ? destroy_inode+0x3b/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.569646]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.569716]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.569786]  [<ffffffff81121ac3>] ? __d_free+0x51/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.569853]  [<ffffffff81121b0b>] ? d_free+0x43/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.569921]  [<ffffffff81122e0a>] ? dentry_kill+0x151/0x15d
Jun 12 17:32:48 sd70 kernel: [ 1201.569990]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.570058]  [<ffffffff8111222a>] ? fput+0x15/0x17
Jun 12 17:32:48 sd70 kernel: [ 1201.570125]  [<ffffffff8110f0c1>] ? filp_close+0x6d/0x78
Jun 12 17:32:48 sd70 kernel: [ 1201.570195]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.570264] udevd           S ffff880603923228     0  1972    946 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.570411]  ffff880602b63998 0000000000000086 0000005100010000 ffffea0016dbd140
Jun 12 17:32:48 sd70 kernel: [ 1201.570648]  ffff880602b63978 ffff880602b62010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.570885]  ffff880602b63fd8 0000000000013340 ffff880602b63fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.571122] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.571183]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.571250]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.571324]  [<ffffffff81109bd8>] ? __kmalloc_node_track_caller+0x10f/0x16f
Jun 12 17:32:48 sd70 kernel: [ 1201.571397]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.571466]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.571538]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.571608]  [<ffffffff8111f83c>] do_poll+0x1da/0x1ff
Jun 12 17:32:48 sd70 kernel: [ 1201.571677]  [<ffffffff811204ad>] do_sys_poll+0x166/0x1d7
Jun 12 17:32:48 sd70 kernel: [ 1201.571746]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.571815]  [<ffffffff812ab281>] ? __sock_sendmsg_nosec+0x5f/0x6a
Jun 12 17:32:48 sd70 kernel: [ 1201.571887]  [<ffffffff812ab2c9>] ? __sock_sendmsg+0x3d/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.572007]  [<ffffffff812abba0>] ? sock_sendmsg+0xa3/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.572076]  [<ffffffff810cdbc8>] ? unlock_page+0x25/0x29
Jun 12 17:32:48 sd70 kernel: [ 1201.572148]  [<ffffffff810edbe9>] ? handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.572218]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.572287]  [<ffffffff812abc21>] ? sockfd_lookup_light+0x1b/0x53
Jun 12 17:32:48 sd70 kernel: [ 1201.572357]  [<ffffffff812ac154>] ? sys_sendto+0x13f/0x16c
Jun 12 17:32:48 sd70 kernel: [ 1201.572425]  [<ffffffff8104c86f>] ? __set_task_blocked+0x60/0x69
Jun 12 17:32:48 sd70 kernel: [ 1201.572495]  [<ffffffff8104c8a9>] ? set_current_blocked+0x31/0x4c
Jun 12 17:32:48 sd70 kernel: [ 1201.572565]  [<ffffffff811205d9>] sys_ppoll+0xbb/0x144
Jun 12 17:32:48 sd70 kernel: [ 1201.572632]  [<ffffffff812ac616>] ? sys_sendmsg+0x4c/0x5b
Jun 12 17:32:48 sd70 kernel: [ 1201.572700]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.572768] xfsalloc        S ffff880603e3e168     0  1973      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.572910]  ffff8805f3039e50 0000000000000046 ffff8805f3039df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.573142]  ffff8805f3039df0 ffff8805f3038010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.573374]  ffff8805f3039fd8 0000000000013340 ffff8805f3039fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.573605] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.573666]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.573735]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.573802]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.573870]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.573939]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.574007]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.574074]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.574143]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.574215]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.574282] xfs_mru_cache   S ffff8805bc4f75a8     0  1974      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.574426]  ffff880602b87e50 0000000000000046 ffff880602b87df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.574660]  ffff880602b87df0 ffff880602b86010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.574893]  ffff880602b87fd8 0000000000013340 ffff880602b87fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.575126] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.575186]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.575255]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.575321]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.575390]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.575459]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.575527]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.575594]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.575664]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.575736]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.575839] xfslogd         S ffff8805ec699068     0  1975      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.575983]  ffff8805bc6f5e50 0000000000000046 ffff8805bc6f5df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.576217]  ffff8805bc6f5df0 ffff8805bc6f4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.576450]  ffff8805bc6f5fd8 0000000000013340 ffff8805bc6f5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.576684] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.576744]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.576813]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.576880]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.576947]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.577013]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.577082]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.577149]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.577218]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.577290]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.577357] udevd           S ffff880603924d28     0  1976    946 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.577501]  ffff880601255998 0000000000000082 ffff880601255978 000000000001e24c
Jun 12 17:32:48 sd70 kernel: [ 1201.577734]  ffff880601255948 ffff880601254010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.577968]  ffff880601255fd8 0000000000013340 ffff880601255fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.578202] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.578262]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.578329]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.578402]  [<ffffffff81062b71>] ? check_preempt_curr+0x2d/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.578471]  [<ffffffff81069a0d>] ? ttwu_do_wakeup+0x54/0xcb
Jun 12 17:32:48 sd70 kernel: [ 1201.578540]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.578608]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.578679]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.578748]  [<ffffffff8111f83c>] do_poll+0x1da/0x1ff
Jun 12 17:32:48 sd70 kernel: [ 1201.578815]  [<ffffffff811204ad>] do_sys_poll+0x166/0x1d7
Jun 12 17:32:48 sd70 kernel: [ 1201.578884]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.578952]  [<ffffffff812ab281>] ? __sock_sendmsg_nosec+0x5f/0x6a
Jun 12 17:32:48 sd70 kernel: [ 1201.579022]  [<ffffffff811c22f9>] ? cpumask_any_but+0x29/0x36
Jun 12 17:32:48 sd70 kernel: [ 1201.579092]  [<ffffffff81037e67>] ? flush_tlb_page+0x5f/0x7f
Jun 12 17:32:48 sd70 kernel: [ 1201.579161]  [<ffffffff81036e1b>] ? ptep_set_access_flags+0x3f/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.579230]  [<ffffffff810eceee>] ? do_wp_page+0x2a1/0x5f9
Jun 12 17:32:48 sd70 kernel: [ 1201.579299]  [<ffffffff810edc8d>] ? handle_pte_fault+0x17e/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.579363]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.579432]  [<ffffffff81382033>] ? do_page_fault+0x34a/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.579503]  [<ffffffff8100e71d>] ? __switch_to+0x227/0x380
Jun 12 17:32:48 sd70 kernel: [ 1201.579571]  [<ffffffff8104c86f>] ? __set_task_blocked+0x60/0x69
Jun 12 17:32:48 sd70 kernel: [ 1201.579641]  [<ffffffff8104c8a9>] ? set_current_blocked+0x31/0x4c
Jun 12 17:32:48 sd70 kernel: [ 1201.579710]  [<ffffffff811205d9>] sys_ppoll+0xbb/0x144
Jun 12 17:32:48 sd70 kernel: [ 1201.579777]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.579841] xfsbufd/sda     S ffff8805ec6989a8     0  1977      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.579986]  ffff8805bc65dda0 0000000000000046 ffff8805eaaed138 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.580218]  ffff880591aff2e0 ffff8805bc65c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.580449]  ffff8805bc65dfd8 0000000000013340 ffff8805bc65dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.580680] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.580740]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.580807]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.580881]  [<ffffffffa02f4896>] ? xfs_buf_delwri_split+0x21/0x164 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.580950]  [<ffffffff8137d091>] schedule_timeout_interruptible+0x19/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.581028]  [<ffffffffa02f5e47>] xfsbufd+0xc4/0x14e [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.581102]  [<ffffffffa02f5d83>] ? xfs_free_buftarg+0x4c/0x4c [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.581168]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.581234]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.581304]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.581376]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.581442] xfs-data/sda    S ffff8805ec69d3e8     0  1978      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.581587]  ffff880602b5fe50 0000000000000046 ffff880602b5fdf0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.587326]  ffff880602b5fdf0 ffff880602b5e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.587559]  ffff880602b5ffd8 0000000000013340 ffff880602b5ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.587793] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.587853]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.587922]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.587990]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.588058]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.588127]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.588195]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.588262]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.588331]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.588403]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.588469] xfs-conv/sda    S ffff8805ec69bfa8     0  1979      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.588614]  ffff8805bc9c5e50 0000000000000046 ffff8805bc9c5df0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.588848]  ffff8805bc9c5df0 ffff8805bc9c4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.589082]  ffff8805bc9c5fd8 0000000000013340 ffff8805bc9c5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.589316] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.589377]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.589446]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.589513]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.589581]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.589650]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.589718]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.589785]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.589855]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.589927]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.589993] xfsaild/sda     S ffff8805ec6b3228     0  1980      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.590138]  ffff8805fd599e10 0000000000000046 ffff8805bc8ac000 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.590371]  ffff8805fd599dc0 ffff8805fd598010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.590605]  ffff8805fd599fd8 0000000000013340 ffff8805fd599fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.590838] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.590898]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.590965]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.591034]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.591110]  [<ffffffffa034fa4b>] xfsaild+0x67/0xb0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.591185]  [<ffffffffa034f9e4>] ? xfsaild_push+0x540/0x540 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.591255]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.591321]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.591386]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.591458]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.591525] xfsbufd/sdb     S ffff8805ec6b6168     0  1983      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.591665]  ffff8805bc91fda0 0000000000000046 ffff8805eaaee138 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.591898]  ffff8805eb592c00 ffff8805bc91e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.592176]  ffff8805bc91ffd8 0000000000013340 ffff8805bc91ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.592409] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.592469]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.592536]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.592604]  [<ffffffff8137d091>] schedule_timeout_interruptible+0x19/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.592683]  [<ffffffffa02f5e47>] xfsbufd+0xc4/0x14e [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.592757]  [<ffffffffa02f5d83>] ? xfs_free_buftarg+0x4c/0x4c [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.592827]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.592894]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.592964]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.593036]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.593102] xfs-data/sdb    S ffff8805ec6b6ee8     0  1984      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.593247]  ffff8805bc9cfe50 0000000000000046 ffff8805bc9cfdf0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.593480]  ffff8805bc9cfdf0 ffff8805bc9ce010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.593714]  ffff8805bc9cffd8 0000000000013340 ffff8805bc9cffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.593947] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.594008]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.594077]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.594144]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.594213]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.594282]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.594350]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.594416]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.594486]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.594558]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.594625] xfs-conv/sdb    S ffff8805ec6b3fa8     0  1985      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.594769]  ffff8805eabbde50 0000000000000046 ffff8805eabbddf0 ffffffff8106ed25
Jun 12 17:32:48 sd70 kernel: [ 1201.595002]  ffff8805eabbddf0 ffff8805eabbc010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.595235]  ffff8805eabbdfd8 0000000000013340 ffff8805eabbdfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.595469] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.595529]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.595598]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.595665]  [<ffffffff81055677>] rescuer_thread+0x233/0x238
Jun 12 17:32:48 sd70 kernel: [ 1201.595733]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.595802]  [<ffffffff81055444>] ? worker_thread+0x264/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.595871]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.595938]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.596007]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.596083]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.596151] xfsaild/sdb     S ffff8805ec6b02e8     0  1986      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.596297]  ffff8805bcbfbe10 0000000000000046 ffff8805bcbfbdb0 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.596534]  ffff8805bcbfbdc0 ffff8805bcbfa010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.596770]  ffff8805bcbfbfd8 0000000000013340 ffff8805bcbfbfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.597007] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.597068]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.597136]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.597205]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.597285]  [<ffffffffa034fa4b>] xfsaild+0x67/0xb0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.597364]  [<ffffffffa034f9e4>] ? xfsaild_push+0x540/0x540 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.597435]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.597503]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.597574]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.597647]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.597714] ntpd            S ffff8806039238e8     0  2012      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.597860]  ffff8805ec065918 0000000000000082 ffff8805ec0658d8 ffffffff812d56d6
Jun 12 17:32:48 sd70 kernel: [ 1201.598098]  0000000000000000 ffff8805ec064010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.598334]  ffff8805ec065fd8 0000000000013340 ffff8805ec065fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.598571] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.598633]  [<ffffffff812d56d6>] ? sch_direct_xmit+0x93/0x14a
Jun 12 17:32:48 sd70 kernel: [ 1201.598703]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.598771]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.598844]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.598914]  [<ffffffff8111f52c>] ? __pollwait+0xbe/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.598982]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.599054]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.599124]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.599194]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599262]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599331]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599400]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599468]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599537]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599606]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.599675]  [<ffffffff8105b030>] ? do_schedule_next_timer+0xaa/0xb5
Jun 12 17:32:48 sd70 kernel: [ 1201.599747]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.599817]  [<ffffffff8104caf8>] ? block_sigmask+0x41/0x43
Jun 12 17:32:48 sd70 kernel: [ 1201.599946]  [<ffffffff8100f455>] ? handle_signal+0x16a/0x191
Jun 12 17:32:48 sd70 kernel: [ 1201.600016]  [<ffffffff8100f4cc>] ? do_signal+0x50/0x103
Jun 12 17:32:48 sd70 kernel: [ 1201.600087]  [<ffffffff81016e76>] ? init_fpu+0x82/0x8f
Jun 12 17:32:48 sd70 kernel: [ 1201.600155]  [<ffffffff81017b28>] ? restore_i387_xstate+0x6d/0x17d
Jun 12 17:32:48 sd70 kernel: [ 1201.600224]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.600292]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.600360] nrpe            S ffff8805ec69b228     0  2123      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.600505]  ffff8805fd4b3918 0000000000000086 ffffea0006444300 0000000000000282
Jun 12 17:32:48 sd70 kernel: [ 1201.600738]  ffff8805fd4b38c8 ffff8805fd4b2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.600972]  ffff8805fd4b3fd8 0000000000013340 ffff8805fd4b3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.601206] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.601266]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.601332]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.601404]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.601472]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.601543]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.601613]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.601682]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.601750]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.601820]  [<ffffffff811c87cb>] ? put_dec+0x20/0x3c
Jun 12 17:32:48 sd70 kernel: [ 1201.601886]  [<ffffffff811c89b7>] ? number+0x157/0x26b
Jun 12 17:32:48 sd70 kernel: [ 1201.601955]  [<ffffffff8102b884>] ? physflat_send_IPI_mask+0x9/0xb
Jun 12 17:32:48 sd70 kernel: [ 1201.602025]  [<ffffffff81037d4b>] ? flush_tlb_others_ipi+0xbe/0xf7
Jun 12 17:32:48 sd70 kernel: [ 1201.602095]  [<ffffffff81108d59>] ? __slab_free+0xe1/0x22d
Jun 12 17:32:48 sd70 kernel: [ 1201.602163]  [<ffffffff810aa4e4>] ? force_quiescent_state+0x176/0x18d
Jun 12 17:32:48 sd70 kernel: [ 1201.602234]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.602303]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.602372]  [<ffffffff812aa469>] ? sock_destroy_inode+0x2e/0x32
Jun 12 17:32:48 sd70 kernel: [ 1201.602442]  [<ffffffff81124855>] ? destroy_inode+0x3b/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.602510]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.602579]  [<ffffffff8112914f>] ? mntput+0x25/0x27
Jun 12 17:32:48 sd70 kernel: [ 1201.602646]  [<ffffffff81112206>] ? __fput+0x1b6/0x1c5
Jun 12 17:32:48 sd70 kernel: [ 1201.602713]  [<ffffffff8110f02b>] ? put_unused_fd+0x26/0x4f
Jun 12 17:32:48 sd70 kernel: [ 1201.602782]  [<ffffffff81014fc6>] ? read_tsc+0x9/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.602849]  [<ffffffff8107a59a>] ? timekeeping_get_ns+0x15/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.608556]  [<ffffffff8107b707>] ? ktime_get_ts+0x80/0x89
Jun 12 17:32:48 sd70 kernel: [ 1201.608625]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.608693]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.608763] master          S ffff8805ec69eee8     0  2227      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.608910]  ffff8805bcbf5d78 0000000000000086 ffff8805bcbf5d28 ffffffff812ab41e
Jun 12 17:32:48 sd70 kernel: [ 1201.609146]  ffff8805bcbf5d28 ffff8805bcbf4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.609383]  ffff8805bcbf5fd8 0000000000013340 ffff8805bcbf5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.609619] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.609680]  [<ffffffff812ab41e>] ? __sock_recvmsg+0x49/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.609750]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.609818]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.609891]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.609960]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.610031]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.610103]  [<ffffffff81143af1>] ep_poll+0x17a/0x2e0
Jun 12 17:32:48 sd70 kernel: [ 1201.610172]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.610242]  [<ffffffff81143ce5>] sys_epoll_wait+0x8e/0xa7
Jun 12 17:32:48 sd70 kernel: [ 1201.610311]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.610381] pickup          S ffff880603925aa8     0  2228   2227 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.610528]  ffff8805f3083d78 0000000000000086 ffff8805f3083d28 ffffffff812ab2c9
Jun 12 17:32:48 sd70 kernel: [ 1201.610764]  ffff8805f3083d18 ffff8805f3082010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.611001]  ffff8805f3083fd8 0000000000013340 ffff8805f3083fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.611238] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.611300]  [<ffffffff812ab2c9>] ? __sock_sendmsg+0x3d/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.611369]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.611437]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.611509]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.611575]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.611642]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.611713]  [<ffffffff81143af1>] ep_poll+0x17a/0x2e0
Jun 12 17:32:48 sd70 kernel: [ 1201.611783]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.611853]  [<ffffffff81143ce5>] sys_epoll_wait+0x8e/0xa7
Jun 12 17:32:48 sd70 kernel: [ 1201.611925]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.611993] qmgr            S ffff8806039275a8     0  2229   2227 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.612143]  ffff8805ea7b9d78 0000000000000086 ffff8805ea7b9d18 ffffffff8110991e
Jun 12 17:32:48 sd70 kernel: [ 1201.612381]  ffff8805ea7b9d18 ffff8805ea7b8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.612618]  ffff8805ea7b9fd8 0000000000013340 ffff8805ea7b9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.612850] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.612909]  [<ffffffff8110991e>] ? kfree+0x52/0xc9
Jun 12 17:32:48 sd70 kernel: [ 1201.612977]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.613051]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.613125]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.613202]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.613276]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.613348]  [<ffffffff81143af1>] ep_poll+0x17a/0x2e0
Jun 12 17:32:48 sd70 kernel: [ 1201.613412]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.613482]  [<ffffffff81143ce5>] sys_epoll_wait+0x8e/0xa7
Jun 12 17:32:48 sd70 kernel: [ 1201.613554]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.613628] snmpd           S ffff8805eb5f38e8     0  2256      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.613775]  ffff8805f30dd918 0000000000000086 0000000000167ae2 0000000000000282
Jun 12 17:32:48 sd70 kernel: [ 1201.614004]  ffff8805f30dd8c8 ffff8805f30dc010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.614246]  ffff8805f30ddfd8 0000000000013340 ffff8805f30ddfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.614482] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.614544]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.614611]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.614685]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.614754]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.614826]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.614897]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.614968]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.615037]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.615106]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.615175]  [<ffffffff81120dfb>] ? __d_instantiate+0x91/0xe1
Jun 12 17:32:48 sd70 kernel: [ 1201.615245]  [<ffffffff8112aa16>] ? seq_open+0x3f/0x98
Jun 12 17:32:48 sd70 kernel: [ 1201.615314]  [<ffffffff81109e11>] ? kmem_cache_alloc_trace+0xd6/0xe8
Jun 12 17:32:48 sd70 kernel: [ 1201.615386]  [<ffffffff8112aa16>] ? seq_open+0x3f/0x98
Jun 12 17:32:48 sd70 kernel: [ 1201.615454]  [<ffffffff8112aa4e>] ? seq_open+0x77/0x98
Jun 12 17:32:48 sd70 kernel: [ 1201.615523]  [<ffffffff810e4c87>] ? vmstat_open+0x13/0x15
Jun 12 17:32:48 sd70 kernel: [ 1201.615592]  [<ffffffff811c87cb>] ? put_dec+0x20/0x3c
Jun 12 17:32:48 sd70 kernel: [ 1201.615660]  [<ffffffff811c89b7>] ? number+0x157/0x26b
Jun 12 17:32:48 sd70 kernel: [ 1201.615729]  [<ffffffff8110f50a>] ? __dentry_open+0x196/0x287
Jun 12 17:32:48 sd70 kernel: [ 1201.615799]  [<ffffffff8112914f>] ? mntput+0x25/0x27
Jun 12 17:32:48 sd70 kernel: [ 1201.615867]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.615994]  [<ffffffff81124855>] ? destroy_inode+0x3b/0x54
Jun 12 17:32:48 sd70 kernel: [ 1201.616081]  [<ffffffff810aad21>] ? call_rcu_sched+0x12/0x14
Jun 12 17:32:48 sd70 kernel: [ 1201.616150]  [<ffffffff81014fc6>] ? read_tsc+0x9/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.616218]  [<ffffffff8107a59a>] ? timekeeping_get_ns+0x15/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.616289]  [<ffffffff8107b707>] ? ktime_get_ts+0x80/0x89
Jun 12 17:32:48 sd70 kernel: [ 1201.616358]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.616426]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.616496] xinetd          S ffff8805bcaf02e8     0  4075      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.616643]  ffff8805ed20d918 0000000000000082 0000000000000002 ffff88061fffd900
Jun 12 17:32:48 sd70 kernel: [ 1201.616881]  ffff8805ed20d938 ffff8805ed20c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.617119]  ffff8805ed20dfd8 0000000000013340 ffff8805ed20dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.617358] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.617419]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.617487]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.617562]  [<ffffffff81101489>] ? alloc_pages_current+0xc5/0xe6
Jun 12 17:32:48 sd70 kernel: [ 1201.617633]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.617703]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.617774]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.617845]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.617914]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.617983]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618052]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618122]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618190]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618259]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618327]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618396]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618465]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.618534]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.618605]  [<ffffffff81033e09>] ? __bad_area_nosemaphore+0x87/0x1e1
Jun 12 17:32:48 sd70 kernel: [ 1201.618676]  [<ffffffff812abc21>] ? sockfd_lookup_light+0x1b/0x53
Jun 12 17:32:48 sd70 kernel: [ 1201.618747]  [<ffffffff812ac154>] ? sys_sendto+0x13f/0x16c
Jun 12 17:32:48 sd70 kernel: [ 1201.618817]  [<ffffffff810440d7>] ? local_bh_enable+0xd/0xf
Jun 12 17:32:48 sd70 kernel: [ 1201.618886]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.618955]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.619025] rsyslogd        S ffff8805bcbbc280     0  4141      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.619172]  ffff8805bcbcf918 0000000000000082 ffff8805ed243d78 ffff88061fc4fea0
Jun 12 17:32:48 sd70 kernel: [ 1201.619410]  ffff8805bcbcf8c8 ffff8805bcbce010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.619648]  ffff8805bcbcffd8 0000000000013340 ffff8805bcbcffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.619876] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.619941]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.620007]  [<ffffffff8137d646>] schedule_hrtimeout_range_clock+0xe8/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.620084]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.620153]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.620224]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.620293]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.620359]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.620424]  [<ffffffff81035301>] ? kernel_map_pages+0xb0/0xbd
Jun 12 17:32:48 sd70 kernel: [ 1201.620495]  [<ffffffff810d350e>] ? prep_new_page+0xf6/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.620566]  [<ffffffff8103495a>] ? static_protections+0x52/0xcd
Jun 12 17:32:48 sd70 kernel: [ 1201.620636]  [<ffffffff81034fec>] ? __change_page_attr+0x135/0x180
Jun 12 17:32:48 sd70 kernel: [ 1201.620706]  [<ffffffff8103506c>] ? __change_page_attr_set_clr+0x35/0x80
Jun 12 17:32:48 sd70 kernel: [ 1201.620777]  [<ffffffff81035301>] ? kernel_map_pages+0xb0/0xbd
Jun 12 17:32:48 sd70 kernel: [ 1201.620845]  [<ffffffff810d34bc>] ? prep_new_page+0xa4/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.620909]  [<ffffffff810d4a84>] ? __alloc_pages_nodemask+0x12a/0x1ae
Jun 12 17:32:48 sd70 kernel: [ 1201.620980]  [<ffffffff810d438c>] ? get_page_from_freelist+0x51d/0x5d9
Jun 12 17:32:48 sd70 kernel: [ 1201.621051]  [<ffffffff810cda2c>] ? find_get_page+0x43/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.621119]  [<ffffffff810cf4bd>] ? filemap_fault+0x199/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.621184]  [<ffffffff810cdbc8>] ? unlock_page+0x25/0x29
Jun 12 17:32:48 sd70 kernel: [ 1201.621252]  [<ffffffff810ecc12>] ? __do_fault+0x3a7/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.621321]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.621389]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.621458]  [<ffffffff81382033>] ? do_page_fault+0x34a/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.621528]  [<ffffffff81062b71>] ? check_preempt_curr+0x2d/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.621598]  [<ffffffff81014fc6>] ? read_tsc+0x9/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.621665]  [<ffffffff8107a59a>] ? timekeeping_get_ns+0x15/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.621735]  [<ffffffff8107b707>] ? ktime_get_ts+0x80/0x89
Jun 12 17:32:48 sd70 kernel: [ 1201.621803]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.621870]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.621939] rsyslogd        S ffff8805ec641de8     0  4143      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.622084]  ffff8805bbc8b918 0000000000000082 00000000005ed338 80000005ed338160
Jun 12 17:32:48 sd70 kernel: [ 1201.622318]  ffff8805bbc8b8e8 ffff8805bbc8a010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.622552]  ffff8805bbc8bfd8 0000000000013340 ffff8805bbc8bfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.622786] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.622846]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.622913]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.622985]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.623054]  [<ffffffff8111f52c>] ? __pollwait+0xbe/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.623121]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.623191]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.623256]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.623324]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.623392]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.623460]  [<ffffffff8132c619>] ? unix_dgram_recvmsg+0x329/0x33b
Jun 12 17:32:48 sd70 kernel: [ 1201.623530]  [<ffffffff810d4a84>] ? __alloc_pages_nodemask+0x12a/0x1ae
Jun 12 17:32:48 sd70 kernel: [ 1201.623601]  [<ffffffff812aa5f7>] ? __sock_recvmsg_nosec+0x65/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.629376]  [<ffffffff811c2332>] ? cpumask_next_and+0x2c/0x39
Jun 12 17:32:48 sd70 kernel: [ 1201.629447]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:32:48 sd70 kernel: [ 1201.629517]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.629594]  [<ffffffff810676d8>] ? enqueue_task+0x61/0x68
Jun 12 17:32:48 sd70 kernel: [ 1201.629662]  [<ffffffff81062b82>] ? check_preempt_curr+0x3e/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.629737]  [<ffffffff81069a0d>] ? ttwu_do_wakeup+0x54/0xcb
Jun 12 17:32:48 sd70 kernel: [ 1201.629805]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.629876]  [<ffffffff8108383f>] ? futex_wake_op+0x3c2/0x3e6
Jun 12 17:32:48 sd70 kernel: [ 1201.629943]  [<ffffffff8106ed25>] ? enqueue_task_fair+0x2b/0xcf
Jun 12 17:32:48 sd70 kernel: [ 1201.630013]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.630082]  [<ffffffff8137f520>] ? do_device_not_available+0x9/0xb
Jun 12 17:32:48 sd70 kernel: [ 1201.630153]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.630222] rsyslogd        S ffff8805ec644668     0  4144      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.630367]  ffff8805fd5c3e08 0000000000000082 ffff8805fd5c3de8 ffffffff00000001
Jun 12 17:32:48 sd70 kernel: [ 1201.630597]  0000000000000000 ffff8805fd5c2010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.630831]  ffff8805fd5c3fd8 0000000000013340 ffff8805fd5c3fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.631065] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.631125]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.631192]  [<ffffffff8103f7ee>] do_syslog+0x188/0x43f
Jun 12 17:32:48 sd70 kernel: [ 1201.631259]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.631327]  [<ffffffff811652b9>] kmsg_read+0x48/0x4f
Jun 12 17:32:48 sd70 kernel: [ 1201.631394]  [<ffffffff8115afde>] proc_reg_read+0x7b/0x94
Jun 12 17:32:48 sd70 kernel: [ 1201.631462]  [<ffffffff8111135f>] vfs_read+0xa6/0x102
Jun 12 17:32:48 sd70 kernel: [ 1201.631529]  [<ffffffff81111474>] sys_read+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.631596]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.631665] rs:main Q:Reg   S ffff8805bc4f38e8     0  7159      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.631811]  ffff880191041d08 0000000000000082 ffff880191041cb8 ffffffff812ab2c9
Jun 12 17:32:48 sd70 kernel: [ 1201.632045]  ffff880191041cf8 ffff880191040010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.632279]  ffff880191041fd8 0000000000013340 ffff880191041fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.632513] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.632573]  [<ffffffff812ab2c9>] ? __sock_sendmsg+0x3d/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.632641]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.632708]  [<ffffffff8108201b>] futex_wait_queue_me+0xbd/0xdc
Jun 12 17:32:48 sd70 kernel: [ 1201.632778]  [<ffffffff81083018>] futex_wait+0x117/0x25e
Jun 12 17:32:48 sd70 kernel: [ 1201.632846]  [<ffffffff8105eba4>] ? update_rmtp+0x65/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.632914]  [<ffffffff8105f45a>] ? hrtimer_start_range_ns+0xf/0x11
Jun 12 17:32:48 sd70 kernel: [ 1201.632980]  [<ffffffff81084790>] do_futex+0x84/0x117
Jun 12 17:32:48 sd70 kernel: [ 1201.633046]  [<ffffffff81116596>] ? set_task_comm+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.633110]  [<ffffffff8108494a>] sys_futex+0x127/0x141
Jun 12 17:32:48 sd70 kernel: [ 1201.633178]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.633249] rsync           S ffff8805bcaf1068     0  4155      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.633401]  ffff8805ece79918 0000000000000086 ffff8805fd5f7920 ffff8805ea4d2300
Jun 12 17:32:48 sd70 kernel: [ 1201.633638]  ffff8805ece798f8 ffff8805ece78010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.633873]  ffff8805ece79fd8 0000000000013340 ffff8805ece79fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.634108] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.634168]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.634231]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.634303]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
Jun 12 17:32:48 sd70 kernel: [ 1201.634372]  [<ffffffff8105c2ef>] ? add_wait_queue+0x3f/0x44
Jun 12 17:32:48 sd70 kernel: [ 1201.634440]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.634511]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.634581]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.634647]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.634714]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.634783]  [<ffffffff8133e81a>] ? ip6_pol_route_output+0x11/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.634856]  [<ffffffff8135bfed>] ? fib6_rule_action+0x8d/0x156
Jun 12 17:32:48 sd70 kernel: [ 1201.634926]  [<ffffffff8133ae07>] ? __ipv6_addr_label+0x67/0xc5
Jun 12 17:32:48 sd70 kernel: [ 1201.634995]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
Jun 12 17:32:48 sd70 kernel: [ 1201.635065]  [<ffffffff8137ebe3>] ? _raw_read_unlock_bh+0x10/0x12
Jun 12 17:32:48 sd70 kernel: [ 1201.635134]  [<ffffffff8133829d>] ? ipv6_dev_get_saddr+0x294/0x2a8
Jun 12 17:32:48 sd70 kernel: [ 1201.635205]  [<ffffffff810cda2c>] ? find_get_page+0x43/0x65
Jun 12 17:32:48 sd70 kernel: [ 1201.635273]  [<ffffffff810cf4bd>] ? filemap_fault+0x199/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.635342]  [<ffffffff810cdbc8>] ? unlock_page+0x25/0x29
Jun 12 17:32:48 sd70 kernel: [ 1201.635410]  [<ffffffff810ecc12>] ? __do_fault+0x3a7/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.635479]  [<ffffffff8111f2ff>] ? zero_fd_set+0x15/0x19
Jun 12 17:32:48 sd70 kernel: [ 1201.635548]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.635616]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.635685]  [<ffffffff81382033>] ? do_page_fault+0x34a/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.635754]  [<ffffffff8135df5a>] ? __inet6_hash+0x153/0x165
Jun 12 17:32:48 sd70 kernel: [ 1201.635824]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.635891]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.635960] login           S ffff8805ec6e7700     0  5969      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.636099]  ffff8805bca03e48 0000000000000086 000000000060a270 ffff880500000065
Jun 12 17:32:48 sd70 kernel: [ 1201.636331]  ffffffff8106ec4e ffff8805bca02010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.636560]  ffff8805bca03fd8 0000000000013340 ffff8805bca03fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.636794] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.636855]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:32:48 sd70 kernel: [ 1201.636924]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.636988]  [<ffffffff810424da>] do_wait+0x1a6/0x21a
Jun 12 17:32:48 sd70 kernel: [ 1201.637053]  [<ffffffff8106a645>] ? wake_up_new_task+0xc2/0xce
Jun 12 17:32:48 sd70 kernel: [ 1201.637122]  [<ffffffff8103dc1c>] ? do_fork+0x193/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.637190]  [<ffffffff810425e7>] sys_wait4+0x99/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.637256]  [<ffffffff810406fb>] ? wait_task_continued+0x14c/0x14c
Jun 12 17:32:48 sd70 kernel: [ 1201.637327]  [<ffffffff8137f0e5>] ? page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.637394]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.637463] login           S ffff8805bcaf1de8     0  5970      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.637607]  ffff8805ecfcde48 0000000000000082 000000000060a270 ffff880500000065
Jun 12 17:32:48 sd70 kernel: [ 1201.637841]  ffffffff8106ec4e ffff8805ecfcc010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.638074]  ffff8805ecfcdfd8 0000000000013340 ffff8805ecfcdfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.638308] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.638368]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:32:48 sd70 kernel: [ 1201.638437]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.638504]  [<ffffffff810424da>] do_wait+0x1a6/0x21a
Jun 12 17:32:48 sd70 kernel: [ 1201.638571]  [<ffffffff8106a645>] ? wake_up_new_task+0xc2/0xce
Jun 12 17:32:48 sd70 kernel: [ 1201.638639]  [<ffffffff8103dc1c>] ? do_fork+0x193/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.638707]  [<ffffffff810425e7>] sys_wait4+0x99/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.638774]  [<ffffffff810406fb>] ? wait_task_continued+0x14c/0x14c
Jun 12 17:32:48 sd70 kernel: [ 1201.638844]  [<ffffffff8137f0e5>] ? page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.638911]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.638980] bash            S ffff8805bcaf38e8     0  5971   5969 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.639124]  ffff8805ed267e48 0000000000000086 0000000000ef4380 ffff880500000065
Jun 12 17:32:48 sd70 kernel: [ 1201.639357]  ffff8805ed267de8 ffff8805ed266010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.639591]  ffff8805ed267fd8 0000000000013340 ffff8805ed267fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.639825] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.639885]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.639952]  [<ffffffff810424da>] do_wait+0x1a6/0x21a
Jun 12 17:32:48 sd70 kernel: [ 1201.640019]  [<ffffffff8106a645>] ? wake_up_new_task+0xc2/0xce
Jun 12 17:32:48 sd70 kernel: [ 1201.640088]  [<ffffffff8103dc1c>] ? do_fork+0x193/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.640155]  [<ffffffff810425e7>] sys_wait4+0x99/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.640223]  [<ffffffff8104c8a9>] ? set_current_blocked+0x31/0x4c
Jun 12 17:32:48 sd70 kernel: [ 1201.640292]  [<ffffffff810406fb>] ? wait_task_continued+0x14c/0x14c
Jun 12 17:32:48 sd70 kernel: [ 1201.640363]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.640431] bash            S ffff8805ec643228     0  5972   5970 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.640576]  ffff8805ece1bcf8 0000000000000086 ffff8805ecb8b378 000000000000009e
Jun 12 17:32:48 sd70 kernel: [ 1201.640809]  ffff8805ece1bce8 ffff8805ece1a010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.641043]  ffff8805ece1bfd8 0000000000013340 ffff8805ece1bfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.641276] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.641337]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.641403]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.641472]  [<ffffffff81053f2f>] ? flush_work+0x1a/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.641542]  [<ffffffff812458ca>] n_tty_read+0x49b/0x73f
Jun 12 17:32:48 sd70 kernel: [ 1201.641610]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.641679]  [<ffffffff812404e9>] tty_read+0x81/0xc2
Jun 12 17:32:48 sd70 kernel: [ 1201.641746]  [<ffffffff8111135f>] vfs_read+0xa6/0x102
Jun 12 17:32:48 sd70 kernel: [ 1201.641813]  [<ffffffff8104cab3>] ? sigprocmask+0x5e/0x62
Jun 12 17:32:48 sd70 kernel: [ 1201.641880]  [<ffffffff81111474>] sys_read+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.641947]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.642015] sshd            S ffff8805ebdd6828     0  6073   1969 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.642159]  ffff880601343918 0000000000000082 0000000000000092 ffff8805eb5dc000
Jun 12 17:32:48 sd70 kernel: [ 1201.642393]  ffff8806013438f8 ffff880601342010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.642627]  ffff880601343fd8 0000000000013340 ffff880601343fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.642860] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.642920]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.642987]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.643059]  [<ffffffff8106560e>] ? __wake_up+0x3f/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.643127]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.643197]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.643267]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.643335]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.643403]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.643472]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.643539]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.643607]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.643675]  [<ffffffff8131031d>] ? inet_sendmsg+0x8f/0x98
Jun 12 17:32:48 sd70 kernel: [ 1201.643743]  [<ffffffff812ab281>] ? __sock_sendmsg_nosec+0x5f/0x6a
Jun 12 17:32:48 sd70 kernel: [ 1201.643813]  [<ffffffff812ab2c9>] ? __sock_sendmsg+0x3d/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.643882]  [<ffffffff812ab3c5>] ? sock_aio_write+0xf1/0x101
Jun 12 17:32:48 sd70 kernel: [ 1201.643951]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.644020]  [<ffffffff811107e3>] ? do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.644089]  [<ffffffff811400a9>] ? fsnotify+0x255/0x285
Jun 12 17:32:48 sd70 kernel: [ 1201.644157]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.644224]  [<ffffffff81111292>] ? sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.644291]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.644360] bash            S ffff8805ebdd6168     0  6075   6073 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.644504]  ffff8805bc533cf8 0000000000000086 0000000000000001 ffff8805ed397950
Jun 12 17:32:48 sd70 kernel: [ 1201.650205]  0000000000000000 ffff8805bc532010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.650439]  ffff8805bc533fd8 0000000000013340 ffff8805bc533fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.650672] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.650732]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.650799]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.650867]  [<ffffffff81053f2f>] ? flush_work+0x1a/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.650935]  [<ffffffff81241913>] ? tty_wakeup+0x56/0x5b
Jun 12 17:32:48 sd70 kernel: [ 1201.651002]  [<ffffffff8124904f>] ? pty_write+0x4c/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.651070]  [<ffffffff812458ca>] n_tty_read+0x49b/0x73f
Jun 12 17:32:48 sd70 kernel: [ 1201.651138]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.651207]  [<ffffffff812404e9>] tty_read+0x81/0xc2
Jun 12 17:32:48 sd70 kernel: [ 1201.651273]  [<ffffffff8111135f>] vfs_read+0xa6/0x102
Jun 12 17:32:48 sd70 kernel: [ 1201.651340]  [<ffffffff8104cab3>] ? sigprocmask+0x5e/0x62
Jun 12 17:32:48 sd70 kernel: [ 1201.651407]  [<ffffffff81111474>] sys_read+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.651474]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.651542] diloadfromspool D ffff8805ebdd38e8     0  6083      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.651687]  ffff8805fd593b58 0000000000000082 ffff8805fd593b48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.651920]  ffff8805ec918000 ffff8805fd592010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.652154]  ffff8805fd593fd8 0000000000013340 ffff8805fd593fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.652387] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.652448]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.652515]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.652582]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.652650]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.652719]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.652787]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.652858]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.652929]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.652998]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.653066]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.653133]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.653202]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.653271]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.653340]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.653409]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.653477]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.653546]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.653614]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.653680] diloadfromspool D ffff8805ebdd4d28     0  6084      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.653825]  ffff8805c4d8db58 0000000000000086 ffff8805c4d8db48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.654059]  ffff8805ec918000 ffff8805c4d8c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.654293]  ffff8805c4d8dfd8 0000000000013340 ffff8805c4d8dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.654527] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.654587]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.654655]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.654721]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.654789]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.654858]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.654926]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.654997]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.655068]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.655137]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.655206]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.655273]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.655338]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.655406]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.655475]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.655543]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.655611]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.655680]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.655747]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.655813] diloadfromspool D ffff8805ebdd1728     0  6085      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.655959]  ffff8805fd5cdb58 0000000000000086 ffff8805fd5cdb48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.656192]  ffff8805ec918000 ffff8805fd5cc010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.656425]  ffff8805fd5cdfd8 0000000000013340 ffff8805fd5cdfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.656658] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.656719]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.656786]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.656853]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.656921]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.656991]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.657059]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.657130]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.657202]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.657270]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.657339]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.657407]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.657476]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.657545]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.657614]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.657682]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.657750]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.657818]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.657886]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.657952] diloadfromspool D ffff8805ebdd53e8     0  6086      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.658096]  ffff8806012b9b58 0000000000000082 ffff8806012b9b48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.658330]  ffff8805ec918000 ffff8806012b8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.658563]  ffff8806012b9fd8 0000000000013340 ffff8806012b9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.658797] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.658857]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.658925]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.658992]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.659059]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.659130]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.659198]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.659268]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.659339]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.659408]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.659477]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.659544]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.659613]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.659682]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.659751]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.659819]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.659888]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.659957]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.660025]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.660091] diloadfromspool D ffff8805ebdd1068     0  6087      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.660235]  ffff8805fd5efb58 0000000000000086 ffff8805fd5efb48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.660469]  ffff8805ec918000 ffff8805fd5ee010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.660702]  ffff8805fd5effd8 0000000000013340 ffff8805fd5effd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.660935] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.660996]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.661064]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.661130]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.661198]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.661267]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.661335]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.661406]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.661477]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.661547]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.661615]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.661682]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.661751]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.661820]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.661889]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.661958]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.662026]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.662094]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.662162]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.662228] diloadfromspool D ffff8805ebdd2b68     0  6088      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.662372]  ffff8805bc425b58 0000000000000082 ffff8805bc425b48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.662606]  ffff8805ec918000 ffff8805bc424010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.662839]  ffff8805bc425fd8 0000000000013340 ffff8805bc425fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.663073] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.663134]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.663201]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.663268]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.663335]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.663405]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.663473]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.663544]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.663615]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.663684]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.663752]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.663819]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.663888]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.663957]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.664026]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.664094]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.664162]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.664230]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.664298]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.664365] diloadfromspool D ffff8805ebdd02e8     0  6089      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.664509]  ffff8805e5f8fb58 0000000000000082 ffff8805e5f8fb48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.664742]  ffff8805ec918000 ffff8805e5f8e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.664976]  ffff8805e5f8ffd8 0000000000013340 ffff8805e5f8ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.670678] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.670742]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.670811]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.670875]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.670941]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.671010]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.671085]  [<ffffffff810cdc84>] ? wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.671160]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.671231]  [<ffffffff810cdd82>] ? __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.671302]  [<ffffffff810cf4d9>] ? filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.671373]  [<ffffffff810ec910>] ? __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.671441]  [<ffffffff81107557>] ? virt_to_head_page+0x9/0x2c
Jun 12 17:32:48 sd70 kernel: [ 1201.671511]  [<ffffffff811099d3>] ? kmem_cache_free+0x1b/0xac
Jun 12 17:32:48 sd70 kernel: [ 1201.671581]  [<ffffffff810edbe9>] ? handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.671652]  [<ffffffff810ede10>] ? handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.671722]  [<ffffffff8138204d>] ? do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.671792]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.671922]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.671991]  [<ffffffff8137f0e5>] ? page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.672058] diloadfromspool D ffff8805ebdd5aa8     0  6090      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.672205]  ffff88060290bb58 0000000000000086 ffff88060290bb48 0000000000000246
Jun 12 17:32:48 sd70 kernel: [ 1201.672441]  ffff8805ec918000 ffff88060290a010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.672678]  ffff88060290bfd8 0000000000013340 ffff88060290bfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.672915] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.672977]  [<ffffffff810cdb2b>] ? sleep_on_page+0xd/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.673044]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.673108]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.673173]  [<ffffffff810cdb34>] sleep_on_page_killable+0x9/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.673243]  [<ffffffff8137d1d4>] __wait_on_bit+0x43/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.673315]  [<ffffffff810cdc84>] wait_on_page_bit_killable+0x6f/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.673390]  [<ffffffff8105c003>] ? autoremove_wake_function+0x34/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.673463]  [<ffffffff810cdd82>] __lock_page_or_retry+0x40/0x8e
Jun 12 17:32:48 sd70 kernel: [ 1201.673533]  [<ffffffff810cf4d9>] filemap_fault+0x1b5/0x347
Jun 12 17:32:48 sd70 kernel: [ 1201.673603]  [<ffffffff810ec910>] __do_fault+0xa5/0x3e2
Jun 12 17:32:48 sd70 kernel: [ 1201.673671]  [<ffffffff810edbe9>] handle_pte_fault+0xda/0x1ad
Jun 12 17:32:48 sd70 kernel: [ 1201.673741]  [<ffffffff810370da>] ? pte_alloc_one+0x32/0x38
Jun 12 17:32:48 sd70 kernel: [ 1201.673810]  [<ffffffff810ea619>] ? __pte_alloc+0x7e/0xbc
Jun 12 17:32:48 sd70 kernel: [ 1201.673879]  [<ffffffff810ede10>] handle_mm_fault+0x154/0x168
Jun 12 17:32:48 sd70 kernel: [ 1201.673949]  [<ffffffff8138204d>] do_page_fault+0x364/0x389
Jun 12 17:32:48 sd70 kernel: [ 1201.674018]  [<ffffffff8114a984>] ? fcntl_setlk+0x178/0x18a
Jun 12 17:32:48 sd70 kernel: [ 1201.674087]  [<ffffffff8111dfc9>] ? do_fcntl+0x19b/0x312
Jun 12 17:32:48 sd70 kernel: [ 1201.674156]  [<ffffffff8137f0e5>] page_fault+0x25/0x30
Jun 12 17:32:48 sd70 kernel: [ 1201.674223] bonnie++        D ffff8805bc4f02e8     0  6337      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.674370]  ffff88059b5f59b8 0000000000000086 ffff880601a53bb8 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.674607]  ffff88059b5f5968 ffff88059b5f4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.674844]  ffff88059b5f5fd8 0000000000013340 ffff88059b5f5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.675081] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.675142]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.675212]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.675280]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.675350]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.675420]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.675491]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.675561]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.675633]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.675723]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.675858]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.675939]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.676039]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.676117]  [<ffffffffa02f8002>] ? xfs_file_aio_write+0xb/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.676188]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.676257]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.676327]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.676394]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.676461]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.676530] bonnie++        D ffff8805bc4f1728     0  6338      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.676675]  ffff880602b659b8 0000000000000082 ffff880601a53838 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.676909]  ffff880602b65968 ffff880602b64010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.677138]  ffff880602b65fd8 0000000000013340 ffff880602b65fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.677371] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.677431]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.677501]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.677567]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.677636]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.677704]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.677774]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.677843]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.677914]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.678002]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.678073]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.678151]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.678239]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.678316]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.678387]  [<ffffffff8106805e>] ? task_sched_runtime+0x5e/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.678457]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.678525]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.678596]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.678661]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.678725]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.678793] bonnie++        D ffff8805bc4f1068     0  6339      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.678938]  ffff8805fd5039b8 0000000000000086 ffff88040c561fb8 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.679172]  ffff8805fd503968 ffff8805fd502010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.679405]  ffff8805fd503fd8 0000000000013340 ffff8805fd503fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.679636] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.679696]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.679765]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.679832]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.679901]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.679970]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.680034]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.680105]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.680193]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.680263]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.680341]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.680430]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.680501]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.680573]  [<ffffffff8111071a>] ? do_sync_readv_writev+0xfe/0xfe
Jun 12 17:32:48 sd70 kernel: [ 1201.680643]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.680711]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.680782]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.680849]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.680915]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.680979] bonnie++        D ffff8805bc4f2b68     0  6340      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.681123]  ffff880573db19b8 0000000000000086 ffff880601a70ab8 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.681357]  ffff880573db1968 ffff880573db0010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.681591]  ffff880573db1fd8 0000000000013340 ffff880573db1fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.681824] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.681884]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.681954]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.682020]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.682087]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.682152]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.682220]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.682290]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.682360]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.682449]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.682519]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.682597]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.682685]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.682762]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.682833]  [<ffffffff8106805e>] ? task_sched_runtime+0x5e/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.682902]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.682971]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.683042]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.683109]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.683176]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.683244] bonnie++        D ffff8805bc4f24a8     0  6341      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.683389]  ffff880591aa59b8 0000000000000082 ffff88040c561c38 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.683623]  ffff880591aa5968 ffff880591aa4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.683857]  ffff880591aa5fd8 0000000000013340 ffff880591aa5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.684090] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.684150]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.684220]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.684286]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.684354]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.684423]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.684492]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.684561]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.684632]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.684720]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.684791]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.684869]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.690486]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.690558]  [<ffffffff8106805e>] ? task_sched_runtime+0x5e/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.690628]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.690698]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.690769]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.690837]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.690905]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.690975] bonnie++        D ffff8805bc4f09a8     0  6342      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.691122]  ffff880573df59b8 0000000000000082 ffff880601a534b8 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.691357]  ffff880573df5968 ffff880573df4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.691585]  ffff880573df5fd8 0000000000013340 ffff880573df5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.691822] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.691883]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.691952]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.692019]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.692087]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.692152]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.692221]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.692292]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.692379]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.692450]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.692528]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.692615]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.692691]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.692763]  [<ffffffff8111071a>] ? do_sync_readv_writev+0xfe/0xfe
Jun 12 17:32:48 sd70 kernel: [ 1201.692832]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.692901]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.692972]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.693039]  [<ffffffff81111a55>] ? fget_light+0x35/0x94
Jun 12 17:32:48 sd70 kernel: [ 1201.693107]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.693173]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.693242] bonnie++        D ffff8805bc4f3fa8     0  6343      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.693386]  ffff880573de19b8 0000000000000086 ffff8806018e0ab8 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.693620]  ffff880573de1968 ffff880573de0010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.693854]  ffff880573de1fd8 0000000000013340 ffff880573de1fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.694086] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.694146]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.694216]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.694282]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.694351]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.694420]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.694489]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.694557]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.694628]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.694716]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.694786]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.694865]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.694953]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.695029]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.695101]  [<ffffffff8111071a>] ? do_sync_readv_writev+0xfe/0xfe
Jun 12 17:32:48 sd70 kernel: [ 1201.695169]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.695234]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.695303]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.695368]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.695435]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.695504] bonnie++        D ffff8805bc4f6828     0  6344      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.695648]  ffff880573da99b8 0000000000000082 0000000000000286 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.695882]  ffff880573da9968 ffff880573da8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.696113]  ffff880573da9fd8 0000000000013340 ffff880573da9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.696346] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.696407]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.696477]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.696543]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.696612]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.696681]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.696750]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.696819]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.696890]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.696978]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.697048]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.697126]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.697215]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.697291]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.697362]  [<ffffffff8106805e>] ? task_sched_runtime+0x5e/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.697431]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.697500]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.697571]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.697638]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.697705]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.697773] bonnie++        D ffff8805bc4f3228     0  6345      1 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.697917]  ffff880573da59b8 0000000000000082 ffff880601a70738 0000000000000286
Jun 12 17:32:48 sd70 kernel: [ 1201.698151]  ffff880573da5968 ffff880573da4010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.698384]  ffff880573da5fd8 0000000000013340 ffff880573da5fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.698614] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.698672]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
Jun 12 17:32:48 sd70 kernel: [ 1201.698739]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.698807]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.698882]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
Jun 12 17:32:48 sd70 kernel: [ 1201.698948]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
Jun 12 17:32:48 sd70 kernel: [ 1201.699013]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
Jun 12 17:32:48 sd70 kernel: [ 1201.699082]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
Jun 12 17:32:48 sd70 kernel: [ 1201.699157]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
Jun 12 17:32:48 sd70 kernel: [ 1201.699250]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
Jun 12 17:32:48 sd70 kernel: [ 1201.699322]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
Jun 12 17:32:48 sd70 kernel: [ 1201.699402]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.699492]  [<ffffffff810d85ca>] ? lru_cache_add_lru+0x3c/0x3e
Jun 12 17:32:48 sd70 kernel: [ 1201.699570]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.699642]  [<ffffffff8106805e>] ? task_sched_runtime+0x5e/0x6e
Jun 12 17:32:48 sd70 kernel: [ 1201.699713]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.699826]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
Jun 12 17:32:48 sd70 kernel: [ 1201.699898]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.699966]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.700034]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.700104] flush-8:0       D ffff8805bcaf5aa8     0  6346      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.700250]  ffff88059d78f710 0000000000000046 ffff88059d78f700 ffff88059d78f6e0
Jun 12 17:32:48 sd70 kernel: [ 1201.700487]  ffff8805eaef8000 ffff88059d78e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.700724]  ffff88059d78ffd8 0000000000013340 ffff88059d78ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.700961] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.701022]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.701090]  [<ffffffff8137e338>] io_schedule+0x87/0xca
Jun 12 17:32:48 sd70 kernel: [ 1201.701159]  [<ffffffff811aca59>] get_request_wait+0x116/0x1b9
Jun 12 17:32:48 sd70 kernel: [ 1201.701229]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.701298]  [<ffffffff811a70d2>] ? elv_merge+0xae/0xbe
Jun 12 17:32:48 sd70 kernel: [ 1201.701367]  [<ffffffff811acf8f>] blk_queue_bio+0x1a8/0x30d
Jun 12 17:32:48 sd70 kernel: [ 1201.701436]  [<ffffffff811ac2e5>] generic_make_request+0x99/0xdc
Jun 12 17:32:48 sd70 kernel: [ 1201.701507]  [<ffffffff811ac407>] submit_bio+0xdf/0xfe
Jun 12 17:32:48 sd70 kernel: [ 1201.701580]  [<ffffffffa02f1c3d>] xfs_submit_ioend_bio+0x2e/0x30 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.701658]  [<ffffffffa02f236e>] xfs_submit_ioend+0xa1/0xea [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.701736]  [<ffffffffa02f353f>] xfs_vm_writepage+0x40f/0x484 [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.701808]  [<ffffffff811c761c>] ? rb_insert_color+0xbc/0xe5
Jun 12 17:32:48 sd70 kernel: [ 1201.701878]  [<ffffffff810d558a>] __writepage+0x12/0x2b
Jun 12 17:32:48 sd70 kernel: [ 1201.701946]  [<ffffffff810d6a0d>] write_cache_pages+0x25f/0x36a
Jun 12 17:32:48 sd70 kernel: [ 1201.702017]  [<ffffffff810d5578>] ? set_page_dirty+0x62/0x62
Jun 12 17:32:48 sd70 kernel: [ 1201.702087]  [<ffffffff810d6b58>] generic_writepages+0x40/0x57
Jun 12 17:32:48 sd70 kernel: [ 1201.702162]  [<ffffffffa02f1a30>] xfs_vm_writepages+0x48/0x4f [xfs]
Jun 12 17:32:48 sd70 kernel: [ 1201.702234]  [<ffffffff810d6b8b>] do_writepages+0x1c/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.702304]  [<ffffffff81130a04>] writeback_single_inode+0x183/0x370
Jun 12 17:32:48 sd70 kernel: [ 1201.702376]  [<ffffffff81130eaa>] writeback_sb_inodes+0x172/0x20b
Jun 12 17:32:48 sd70 kernel: [ 1201.702447]  [<ffffffff81130fb6>] __writeback_inodes_wb+0x73/0xb4
Jun 12 17:32:48 sd70 kernel: [ 1201.702518]  [<ffffffff8113162b>] wb_writeback+0x136/0x22c
Jun 12 17:32:48 sd70 kernel: [ 1201.702587]  [<ffffffff810d61c1>] ? global_dirty_limits+0x2a/0x10a
Jun 12 17:32:48 sd70 kernel: [ 1201.702659]  [<ffffffff811317b1>] wb_do_writeback+0x90/0x1de
Jun 12 17:32:48 sd70 kernel: [ 1201.702729]  [<ffffffff811319bf>] bdi_writeback_thread+0xc0/0x1e5
Jun 12 17:32:48 sd70 kernel: [ 1201.702800]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
Jun 12 17:32:48 sd70 kernel: [ 1201.702871]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
Jun 12 17:32:48 sd70 kernel: [ 1201.702941]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.703009]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.703079]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.703152]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.703219] kworker/2:2     S ffff8805ea4d4280     0  6347      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.703366]  ffff880573d53e70 0000000000000046 ffff880573d53e20 ffffffff8129868a
Jun 12 17:32:48 sd70 kernel: [ 1201.703603]  0000000000000002 ffff880573d52010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.703905]  ffff880573d53fd8 0000000000013340 ffff880573d53fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.704142] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.704202]  [<ffffffff8129868a>] ? do_dbs_timer+0xe1/0xef
Jun 12 17:32:48 sd70 kernel: [ 1201.704271]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.704338]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.704406]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.704476]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.704542]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.704612]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.704684]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.704750] sshd            S ffff8805eb5f6828     0  6369   1969 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.704895]  ffff880573f13918 0000000000000086 0000000000000072 ffff8805eb5dc000
Jun 12 17:32:48 sd70 kernel: [ 1201.710638]  ffff880573f138f8 ffff880573f12010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.710875]  ffff880573f13fd8 0000000000013340 ffff880573f13fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.711111] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.711173]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.711240]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.711314]  [<ffffffff8106560e>] ? __wake_up+0x3f/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.711382]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.711455]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.711526]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.711595]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.711664]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.711797]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.711866]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.711935]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.712004]  [<ffffffff8131031d>] ? inet_sendmsg+0x8f/0x98
Jun 12 17:32:48 sd70 kernel: [ 1201.712073]  [<ffffffff8137e141>] ? wait_for_common+0xd7/0x14a
Jun 12 17:32:48 sd70 kernel: [ 1201.712144]  [<ffffffff812ab281>] ? __sock_sendmsg_nosec+0x5f/0x6a
Jun 12 17:32:48 sd70 kernel: [ 1201.712215]  [<ffffffff812ab2c9>] ? __sock_sendmsg+0x3d/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.712284]  [<ffffffff812ab3c5>] ? sock_aio_write+0xf1/0x101
Jun 12 17:32:48 sd70 kernel: [ 1201.712354]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.712424]  [<ffffffff811107e3>] ? do_sync_write+0xc9/0x106
Jun 12 17:32:48 sd70 kernel: [ 1201.712493]  [<ffffffff811400a9>] ? fsnotify+0x255/0x285
Jun 12 17:32:48 sd70 kernel: [ 1201.712562]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.712630]  [<ffffffff81111292>] ? sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.712699]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.712766] bash            S ffff8805eb5f6168     0  6371   6369 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.712905]  ffff880573f3fcf8 0000000000000082 0000000000000001 ffff880573e8c950
Jun 12 17:32:48 sd70 kernel: [ 1201.713135]  0000000000000000 ffff880573f3e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.713378]  ffff880573f3ffd8 0000000000013340 ffff880573f3ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.713605] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.713667]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.713738]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:32:48 sd70 kernel: [ 1201.713803]  [<ffffffff81053f2f>] ? flush_work+0x1a/0x34
Jun 12 17:32:48 sd70 kernel: [ 1201.713868]  [<ffffffff81241913>] ? tty_wakeup+0x56/0x5b
Jun 12 17:32:48 sd70 kernel: [ 1201.713937]  [<ffffffff8124904f>] ? pty_write+0x4c/0x56
Jun 12 17:32:48 sd70 kernel: [ 1201.714011]  [<ffffffff812458ca>] n_tty_read+0x49b/0x73f
Jun 12 17:32:48 sd70 kernel: [ 1201.714076]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.714141]  [<ffffffff812404e9>] tty_read+0x81/0xc2
Jun 12 17:32:48 sd70 kernel: [ 1201.714208]  [<ffffffff8111135f>] vfs_read+0xa6/0x102
Jun 12 17:32:48 sd70 kernel: [ 1201.714279]  [<ffffffff8104cab3>] ? sigprocmask+0x5e/0x62
Jun 12 17:32:48 sd70 kernel: [ 1201.714350]  [<ffffffff81111474>] sys_read+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.714418]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.714488] kworker/0:3     S ffff8805bc4f6ee8     0  6387      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.714634]  ffff8806013b9e70 0000000000000046 ffffffff811be375 0000000000000000
Jun 12 17:32:48 sd70 kernel: [ 1201.714871]  ffff8806013b9e00 ffff8806013b8010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.715108]  ffff8806013b9fd8 0000000000013340 ffff8806013b9fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.715345] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.715405]  [<ffffffff811be375>] ? cfq_init_queue+0x280/0x280
Jun 12 17:32:48 sd70 kernel: [ 1201.715476]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.715543]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.715613]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.715683]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.715789]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.715860]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.715933]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.716001] kworker/3:2     S ffff8805eb5f5aa8     0  6400      2 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.716146]  ffff88060299de70 0000000000000046 ffff88060299de20 ffffffff8129868a
Jun 12 17:32:48 sd70 kernel: [ 1201.716378]  ffff88060299de10 ffff88060299c010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.716618]  ffff88060299dfd8 0000000000013340 ffff88060299dfd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.716854] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.716916]  [<ffffffff8129868a>] ? do_dbs_timer+0xe1/0xef
Jun 12 17:32:48 sd70 kernel: [ 1201.716985]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.717053]  [<ffffffff8105543f>] worker_thread+0x25f/0x264
Jun 12 17:32:48 sd70 kernel: [ 1201.717122]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
Jun 12 17:32:48 sd70 kernel: [ 1201.717192]  [<ffffffff8105bb50>] kthread+0x84/0x8c
Jun 12 17:32:48 sd70 kernel: [ 1201.717260]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.717331]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
Jun 12 17:32:48 sd70 kernel: [ 1201.717404]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
Jun 12 17:32:48 sd70 kernel: [ 1201.717471] tail            S ffff8805ec5c6ee8     0  6979   5971 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.717614]  ffff8800df2c7e48 0000000000000082 ffff8800df2c7dd8 ffff8805ea47f970
Jun 12 17:32:48 sd70 kernel: [ 1201.717851]  ffff8800df2c7e18 ffff8800df2c6010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.718088]  ffff8800df2c7fd8 0000000000013340 ffff8800df2c7fd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.718325] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.718386]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.718455]  [<ffffffff81142e03>] inotify_read+0x196/0x1e7
Jun 12 17:32:48 sd70 kernel: [ 1201.718524]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
Jun 12 17:32:48 sd70 kernel: [ 1201.718592]  [<ffffffff8111135f>] vfs_read+0xa6/0x102
Jun 12 17:32:48 sd70 kernel: [ 1201.718660]  [<ffffffff81111474>] sys_read+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.718728]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.718798] sshd            S ffff8805bc7a82e8     0  7167   1969 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.718944]  ffff88019110f918 0000000000000086 0000000000000072 ffff8805eb5dc000
Jun 12 17:32:48 sd70 kernel: [ 1201.719181]  ffff88019110f8f8 ffff88019110e010 0000000000013340 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.719418]  ffff88019110ffd8 0000000000013340 ffff88019110ffd8 0000000000013340
Jun 12 17:32:48 sd70 kernel: [ 1201.719655] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.719782]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:32:48 sd70 kernel: [ 1201.719850]  [<ffffffff8137d5aa>] schedule_hrtimeout_range_clock+0x4c/0x12f
Jun 12 17:32:48 sd70 kernel: [ 1201.719923]  [<ffffffff8106560e>] ? __wake_up+0x3f/0x48
Jun 12 17:32:48 sd70 kernel: [ 1201.719992]  [<ffffffff8137d69b>] schedule_hrtimeout_range+0xe/0x10
Jun 12 17:32:48 sd70 kernel: [ 1201.720064]  [<ffffffff8111f3c2>] poll_schedule_timeout+0x43/0x5f
Jun 12 17:32:48 sd70 kernel: [ 1201.720134]  [<ffffffff8111fd59>] do_select+0x4f8/0x537
Jun 12 17:32:48 sd70 kernel: [ 1201.720204]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.720272]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.720341]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.720410]  [<ffffffff8111f535>] ? __pollwait+0xc7/0xc7
Jun 12 17:32:48 sd70 kernel: [ 1201.720479]  [<ffffffff81062b71>] ? check_preempt_curr+0x2d/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.720549]  [<ffffffff81069a0d>] ? ttwu_do_wakeup+0x54/0xcb
Jun 12 17:32:48 sd70 kernel: [ 1201.720619]  [<ffffffff8106a35a>] ? try_to_wake_up+0x1a2/0x1b4
Jun 12 17:32:48 sd70 kernel: [ 1201.720689]  [<ffffffff8106a379>] ? default_wake_function+0xd/0xf
Jun 12 17:32:48 sd70 kernel: [ 1201.720760]  [<ffffffff8106262b>] ? __wake_up_common+0x49/0x7f
Jun 12 17:32:48 sd70 kernel: [ 1201.720829]  [<ffffffff8137d53d>] ? mutex_lock+0x11/0x32
Jun 12 17:32:48 sd70 kernel: [ 1201.720898]  [<ffffffff812461c5>] ? copy_termios+0x35/0x3d
Jun 12 17:32:48 sd70 kernel: [ 1201.720967]  [<ffffffff81120043>] core_sys_select+0x16f/0x205
Jun 12 17:32:48 sd70 kernel: [ 1201.721038]  [<ffffffff812471ca>] ? put_ldisc+0xac/0xb1
Jun 12 17:32:48 sd70 kernel: [ 1201.721106]  [<ffffffff812471f9>] ? tty_ldisc_deref+0x9/0xb
Jun 12 17:32:48 sd70 kernel: [ 1201.721176]  [<ffffffff812429aa>] ? tty_ioctl+0x771/0x793
Jun 12 17:32:48 sd70 kernel: [ 1201.721245]  [<ffffffff8112031f>] sys_select+0x91/0xb9
Jun 12 17:32:48 sd70 kernel: [ 1201.721314]  [<ffffffff8111ed33>] ? sys_ioctl+0x51/0x76
Jun 12 17:32:48 sd70 kernel: [ 1201.721382]  [<ffffffff81111292>] ? sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.721450]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.721520] bash            R  running task        0  7169   7167 0x00000000
Jun 12 17:32:48 sd70 kernel: [ 1201.721666]  ffff880191145cb8 ffff880191145ca8 ffff880191145d18 0000000000000046
Jun 12 17:32:48 sd70 kernel: [ 1201.721904]  ffff880191145cb6 000000000000000f ffff880191145cb7 0000000000000046
Jun 12 17:32:48 sd70 kernel: [ 1201.722140]  ffffffff814c2aae 6300000000000004 372e31303231205b 00205d3034313232
Jun 12 17:32:48 sd70 kernel: [ 1201.722377] Call Trace:
Jun 12 17:32:48 sd70 kernel: [ 1201.722439]  [<ffffffff81010fb2>] ? dump_trace+0x266/0x275
Jun 12 17:32:48 sd70 kernel: [ 1201.722509]  [<ffffffff81011c60>] show_trace_log_lvl+0x4f/0x58
Jun 12 17:32:48 sd70 kernel: [ 1201.722579]  [<ffffffff810110f2>] show_stack_log_lvl+0x107/0x116
Jun 12 17:32:48 sd70 kernel: [ 1201.722650]  [<ffffffff81011c0f>] show_stack+0x17/0x19
Jun 12 17:32:48 sd70 kernel: [ 1201.722718]  [<ffffffff810671c3>] sched_show_task+0xac/0xb1
Jun 12 17:32:48 sd70 kernel: [ 1201.722788]  [<ffffffff81067213>] show_state_filter+0x4b/0x9e
Jun 12 17:32:48 sd70 kernel: [ 1201.722857]  [<ffffffff8124a0ba>] sysrq_handle_showstate+0xb/0xd
Jun 12 17:32:48 sd70 kernel: [ 1201.722928]  [<ffffffff8124a3fc>] __handle_sysrq+0xba/0x156
Jun 12 17:32:48 sd70 kernel: [ 1201.722997]  [<ffffffff8124a4d0>] write_sysrq_trigger+0x38/0x40
Jun 12 17:32:48 sd70 kernel: [ 1201.723069]  [<ffffffff8115af4a>] proc_reg_write+0x7b/0x94
Jun 12 17:32:48 sd70 kernel: [ 1201.723138]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
Jun 12 17:32:48 sd70 kernel: [ 1201.723205]  [<ffffffff81111292>] sys_write+0x45/0x6c
Jun 12 17:32:48 sd70 kernel: [ 1201.723273]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:32:48 sd70 kernel: [ 1201.723344] Sched Debug Version: v0.10, 3.4.1-custom #5
Jun 12 17:32:48 sd70 kernel: [ 1201.723411] ktime                                   : 1204099.656753
Jun 12 17:32:48 sd70 kernel: [ 1201.723481] sched_clk                               : 1201723.342856
Jun 12 17:32:48 sd70 kernel: [ 1201.723551] cpu_clk                                 : 1201723.342897
Jun 12 17:32:48 sd70 kernel: [ 1201.723621] jiffies                                 : 4295193320
Jun 12 17:32:48 sd70 kernel: [ 1201.723754] sched_clock_stable                      : 1
Jun 12 17:32:48 sd70 kernel: [ 1201.723820] 
Jun 12 17:32:48 sd70 kernel: [ 1201.723877] sysctl_sched
Jun 12 17:32:48 sd70 kernel: [ 1201.723937]   .sysctl_sched_latency                    : 18.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.724007]   .sysctl_sched_min_granularity            : 2.250000
Jun 12 17:32:48 sd70 kernel: [ 1201.724076]   .sysctl_sched_wakeup_granularity         : 3.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.724145]   .sysctl_sched_child_runs_first           : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.724212]   .sysctl_sched_features                   : 24119
Jun 12 17:32:48 sd70 kernel: [ 1201.724281]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Jun 12 17:32:48 sd70 kernel: [ 1201.724353] 
Jun 12 17:32:48 sd70 kernel: [ 1201.724353] cpu#0, 2133.451 MHz
Jun 12 17:32:48 sd70 kernel: [ 1201.724470]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.724535]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.724601]   .nr_switches                   : 1648682
Jun 12 17:32:48 sd70 kernel: [ 1201.724667]   .nr_load_updates               : 68666
Jun 12 17:32:48 sd70 kernel: [ 1201.724733]   .nr_uninterruptible            : 401
Jun 12 17:32:48 sd70 kernel: [ 1201.724799]   .next_balance                  : 4295.193319
Jun 12 17:32:48 sd70 kernel: [ 1201.724866]   .curr->pid                     : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.724932]   .clock                         : 1201717.804248
Jun 12 17:32:48 sd70 kernel: [ 1201.725000]   .cpu_load[0]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.725065]   .cpu_load[1]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.725130]   .cpu_load[2]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.725194]   .cpu_load[3]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.725259]   .cpu_load[4]                   : 7
Jun 12 17:32:48 sd70 kernel: [ 1201.725325] 
Jun 12 17:32:48 sd70 kernel: [ 1201.725326] cfs_rq[0]:/
Jun 12 17:32:48 sd70 kernel: [ 1201.725441]   .exec_clock                    : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.731112]   .MIN_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.731179]   .min_vruntime                  : 38985.442621
Jun 12 17:32:48 sd70 kernel: [ 1201.731247]   .max_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.731314]   .spread                        : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.731381]   .spread0                       : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.731448]   .nr_spread_over                : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.731513]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.731578]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.731643]   .load_avg                      : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.731757]   .load_period                   : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.731823]   .load_contrib                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.731888]   .load_tg                       : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.731954] 
Jun 12 17:32:48 sd70 kernel: [ 1201.731954] rt_rq[0]:
Jun 12 17:32:48 sd70 kernel: [ 1201.732069]   .rt_nr_running                 : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.732133]   .rt_throttled                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.732199]   .rt_time                       : 0.007102
Jun 12 17:32:48 sd70 kernel: [ 1201.732266]   .rt_runtime                    : 950.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.732333] 
Jun 12 17:32:48 sd70 kernel: [ 1201.732334] runnable tasks:
Jun 12 17:32:48 sd70 kernel: [ 1201.732335]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jun 12 17:32:48 sd70 kernel: [ 1201.732336] ----------------------------------------------------------------------------------------------------------
Jun 12 17:32:48 sd70 kernel: [ 1201.732651] 
Jun 12 17:32:48 sd70 kernel: [ 1201.732652] cpu#1, 2133.451 MHz
Jun 12 17:32:48 sd70 kernel: [ 1201.732769]   .nr_running                    : 2
Jun 12 17:32:48 sd70 kernel: [ 1201.732834]   .load                          : 2048
Jun 12 17:32:48 sd70 kernel: [ 1201.732899]   .nr_switches                   : 157645
Jun 12 17:32:48 sd70 kernel: [ 1201.732965]   .nr_load_updates               : 56595
Jun 12 17:32:48 sd70 kernel: [ 1201.733027]   .nr_uninterruptible            : -9
Jun 12 17:32:48 sd70 kernel: [ 1201.733088]   .next_balance                  : 4295.193246
Jun 12 17:32:48 sd70 kernel: [ 1201.733155]   .curr->pid                     : 7169
Jun 12 17:32:48 sd70 kernel: [ 1201.733224]   .clock                         : 1201435.970296
Jun 12 17:32:48 sd70 kernel: [ 1201.733292]   .cpu_load[0]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.733353]   .cpu_load[1]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.733415]   .cpu_load[2]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.733480]   .cpu_load[3]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.733551]   .cpu_load[4]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.733616] 
Jun 12 17:32:48 sd70 kernel: [ 1201.733617] cfs_rq[1]:/
Jun 12 17:32:48 sd70 kernel: [ 1201.733732]   .exec_clock                    : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.733799]   .MIN_vruntime                  : 30918.883472
Jun 12 17:32:48 sd70 kernel: [ 1201.733867]   .min_vruntime                  : 30927.713140
Jun 12 17:32:48 sd70 kernel: [ 1201.733935]   .max_vruntime                  : 30918.883472
Jun 12 17:32:48 sd70 kernel: [ 1201.734001]   .spread                        : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.734064]   .spread0                       : -8057.729481
Jun 12 17:32:48 sd70 kernel: [ 1201.734128]   .nr_spread_over                : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.734194]   .nr_running                    : 2
Jun 12 17:32:48 sd70 kernel: [ 1201.734263]   .load                          : 2048
Jun 12 17:32:48 sd70 kernel: [ 1201.734325]   .load_avg                      : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.734387]   .load_period                   : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.734454]   .load_contrib                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.734522]   .load_tg                       : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.734586] 
Jun 12 17:32:48 sd70 kernel: [ 1201.734587] rt_rq[1]:
Jun 12 17:32:48 sd70 kernel: [ 1201.734700]   .rt_nr_running                 : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.734764]   .rt_throttled                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.734828]   .rt_time                       : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.734894]   .rt_runtime                    : 950.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.734961] 
Jun 12 17:32:48 sd70 kernel: [ 1201.734961] runnable tasks:
Jun 12 17:32:48 sd70 kernel: [ 1201.734962]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jun 12 17:32:48 sd70 kernel: [ 1201.734963] ----------------------------------------------------------------------------------------------------------
Jun 12 17:32:48 sd70 kernel: [ 1201.735266]      kworker/1:1    29     30918.883472     27764   120               0               0               0.000000               0.000000               0.000000 /
Jun 12 17:32:48 sd70 kernel: [ 1201.735534] R           bash  7169     30918.833402        58   120               0               0               0.000000               0.000000               0.000000 /
Jun 12 17:32:48 sd70 kernel: [ 1201.735804] 
Jun 12 17:32:48 sd70 kernel: [ 1201.735804] cpu#2, 2133.451 MHz
Jun 12 17:32:48 sd70 kernel: [ 1201.735920]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.735984]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736049]   .nr_switches                   : 123555
Jun 12 17:32:48 sd70 kernel: [ 1201.736114]   .nr_load_updates               : 40724
Jun 12 17:32:48 sd70 kernel: [ 1201.736179]   .nr_uninterruptible            : -72
Jun 12 17:32:48 sd70 kernel: [ 1201.736244]   .next_balance                  : 4295.193325
Jun 12 17:32:48 sd70 kernel: [ 1201.736311]   .curr->pid                     : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736376]   .clock                         : 1201723.849747
Jun 12 17:32:48 sd70 kernel: [ 1201.736444]   .cpu_load[0]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736508]   .cpu_load[1]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736572]   .cpu_load[2]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736637]   .cpu_load[3]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736701]   .cpu_load[4]                   : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.736766] 
Jun 12 17:32:48 sd70 kernel: [ 1201.736766] cfs_rq[2]:/
Jun 12 17:32:48 sd70 kernel: [ 1201.736880]   .exec_clock                    : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.736946]   .MIN_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.737012]   .min_vruntime                  : 29430.870364
Jun 12 17:32:48 sd70 kernel: [ 1201.737078]   .max_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.737144]   .spread                        : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.737210]   .spread0                       : -9554.572257
Jun 12 17:32:48 sd70 kernel: [ 1201.737277]   .nr_spread_over                : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737341]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737405]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737469]   .load_avg                      : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.737535]   .load_period                   : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.737601]   .load_contrib                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737665]   .load_tg                       : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737729] 
Jun 12 17:32:48 sd70 kernel: [ 1201.737730] rt_rq[2]:
Jun 12 17:32:48 sd70 kernel: [ 1201.737843]   .rt_nr_running                 : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737907]   .rt_throttled                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.737971]   .rt_time                       : 0.006317
Jun 12 17:32:48 sd70 kernel: [ 1201.738037]   .rt_runtime                    : 950.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.738104] 
Jun 12 17:32:48 sd70 kernel: [ 1201.738104] runnable tasks:
Jun 12 17:32:48 sd70 kernel: [ 1201.738105]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jun 12 17:32:48 sd70 kernel: [ 1201.738106] ----------------------------------------------------------------------------------------------------------
Jun 12 17:32:48 sd70 kernel: [ 1201.738412] 
Jun 12 17:32:48 sd70 kernel: [ 1201.738413] cpu#3, 2133.451 MHz
Jun 12 17:32:48 sd70 kernel: [ 1201.738527]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.738591]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.738656]   .nr_switches                   : 122483
Jun 12 17:32:48 sd70 kernel: [ 1201.738721]   .nr_load_updates               : 45075
Jun 12 17:32:48 sd70 kernel: [ 1201.738786]   .nr_uninterruptible            : -301
Jun 12 17:32:48 sd70 kernel: [ 1201.738851]   .next_balance                  : 4295.193333
Jun 12 17:32:48 sd70 kernel: [ 1201.738917]   .curr->pid                     : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.738982]   .clock                         : 1201736.633267
Jun 12 17:32:48 sd70 kernel: [ 1201.739049]   .cpu_load[0]                   : 1024
Jun 12 17:32:48 sd70 kernel: [ 1201.739114]   .cpu_load[1]                   : 520
Jun 12 17:32:48 sd70 kernel: [ 1201.739178]   .cpu_load[2]                   : 301
Jun 12 17:32:48 sd70 kernel: [ 1201.739243]   .cpu_load[3]                   : 192
Jun 12 17:32:48 sd70 kernel: [ 1201.739307]   .cpu_load[4]                   : 127
Jun 12 17:32:48 sd70 kernel: [ 1201.739372] 
Jun 12 17:32:48 sd70 kernel: [ 1201.739372] cfs_rq[3]:/
Jun 12 17:32:48 sd70 kernel: [ 1201.739486]   .exec_clock                    : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.739552]   .MIN_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.739618]   .min_vruntime                  : 32172.100305
Jun 12 17:32:48 sd70 kernel: [ 1201.739685]   .max_vruntime                  : 0.000001
Jun 12 17:32:48 sd70 kernel: [ 1201.739751]   .spread                        : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.739817]   .spread0                       : -6813.342316
Jun 12 17:32:48 sd70 kernel: [ 1201.739883]   .nr_spread_over                : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.739947]   .nr_running                    : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740011]   .load                          : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740076]   .load_avg                      : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.740141]   .load_period                   : 0.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.740207]   .load_contrib                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740272]   .load_tg                       : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740336] 
Jun 12 17:32:48 sd70 kernel: [ 1201.740336] rt_rq[3]:
Jun 12 17:32:48 sd70 kernel: [ 1201.740449]   .rt_nr_running                 : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740513]   .rt_throttled                  : 0
Jun 12 17:32:48 sd70 kernel: [ 1201.740577]   .rt_time                       : 0.018701
Jun 12 17:32:48 sd70 kernel: [ 1201.740643]   .rt_runtime                    : 950.000000
Jun 12 17:32:48 sd70 kernel: [ 1201.740710] 
Jun 12 17:32:48 sd70 kernel: [ 1201.740710] runnable tasks:
Jun 12 17:32:48 sd70 kernel: [ 1201.740711]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jun 12 17:32:48 sd70 kernel: [ 1201.740712] ----------------------------------------------------------------------------------------------------------
Jun 12 17:32:48 sd70 kernel: [ 1201.741017] 
Jun 12 17:38:47 sd70 kernel: [ 1559.653101] INFO: task sync:7493 blocked for more than 120 seconds.
Jun 12 17:38:47 sd70 kernel: [ 1559.653179] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 17:38:47 sd70 kernel: [ 1559.653269] sync            D ffff8805ec48b8e8     0  7493   7169 0x00000000
Jun 12 17:38:47 sd70 kernel: [ 1559.653417]  ffff880208869cf8 0000000000000086 ffff8805bc02ae78 00000000000000c9
Jun 12 17:38:47 sd70 kernel: [ 1559.653655]  ffff880208869ce8 ffff880208868010 0000000000013340 0000000000013340
Jun 12 17:38:47 sd70 kernel: [ 1559.653892]  ffff880208869fd8 0000000000013340 ffff880208869fd8 0000000000013340
Jun 12 17:38:47 sd70 kernel: [ 1559.654129] Call Trace:
Jun 12 17:38:47 sd70 kernel: [ 1559.654197]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:38:47 sd70 kernel: [ 1559.654265]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:38:47 sd70 kernel: [ 1559.654337]  [<ffffffff8106b47b>] ? wake_affine+0x190/0x248
Jun 12 17:38:47 sd70 kernel: [ 1559.660092]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:38:47 sd70 kernel: [ 1559.660163]  [<ffffffff8137e136>] wait_for_common+0xcc/0x14a
Jun 12 17:38:47 sd70 kernel: [ 1559.660235]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:38:47 sd70 kernel: [ 1559.660307]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
Jun 12 17:38:47 sd70 kernel: [ 1559.660382]  [<ffffffff811348f7>] ? __sync_filesystem+0x7a/0x7a
Jun 12 17:38:47 sd70 kernel: [ 1559.660452]  [<ffffffff8137e24e>] wait_for_completion+0x18/0x1a
Jun 12 17:38:47 sd70 kernel: [ 1559.660524]  [<ffffffff81131203>] writeback_inodes_sb_nr+0x78/0x7f
Jun 12 17:38:47 sd70 kernel: [ 1559.660596]  [<ffffffff811312b0>] writeback_inodes_sb+0x4e/0x59
Jun 12 17:38:47 sd70 kernel: [ 1559.660667]  [<ffffffff811348ce>] __sync_filesystem+0x51/0x7a
Jun 12 17:38:47 sd70 kernel: [ 1559.660738]  [<ffffffff81134908>] sync_one_sb+0x11/0x13
Jun 12 17:38:47 sd70 kernel: [ 1559.660827]  [<ffffffff81112aae>] iterate_supers+0x69/0xbb
Jun 12 17:38:47 sd70 kernel: [ 1559.660898]  [<ffffffff81134939>] sys_sync+0x2f/0x5c
Jun 12 17:38:47 sd70 kernel: [ 1559.661052]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
Jun 12 17:38:47 sd70 kernel: [ 1559.661125] INFO: task shutdown:7494 blocked for more than 120 seconds.
Jun 12 17:38:47 sd70 kernel: [ 1559.661197] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 17:38:47 sd70 kernel: [ 1559.661288] shutdown        D ffff8805bc7a89a8     0  7494      1 0x00000000
Jun 12 17:38:47 sd70 kernel: [ 1559.661446]  ffff8805ebd13cf8 0000000000000082 0000000000000000 ffff8805ec96ca80
Jun 12 17:38:47 sd70 kernel: [ 1559.661689]  ffff8806026f3a40 ffff8805ebd12010 0000000000013340 0000000000013340
Jun 12 17:38:47 sd70 kernel: [ 1559.661928]  ffff8805ebd13fd8 0000000000013340 ffff8805ebd13fd8 0000000000013340
Jun 12 17:38:47 sd70 kernel: [ 1559.662166] Call Trace:
Jun 12 17:38:47 sd70 kernel: [ 1559.662228]  [<ffffffff8137e2af>] schedule+0x5f/0x61
Jun 12 17:38:47 sd70 kernel: [ 1559.662295]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
Jun 12 17:38:47 sd70 kernel: [ 1559.662366]  [<ffffffff811c2332>] ? cpumask_next_and+0x2c/0x39
Jun 12 17:38:47 sd70 kernel: [ 1559.662437]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
Jun 12 17:38:47 sd70 kernel: [ 1559.662506]  [<ffffffff8137e136>] wait_for_common+0xcc/0x14a
Jun 12 17:38:47 sd70 kernel: [ 1559.662576]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
Jun 12 17:38:47 sd70 kernel: [ 1559.662646]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
Jun 12 17:38:47 sd70 kernel: [ 1559.662716]  [<ffffffff811348f7>] ? __sync_filesystem+0x7a/0x7a
Jun 12 17:38:47 sd70 kernel: [ 1559.662786]  [<ffffffff8137e24e>] wait_for_completion+0x18/0x1a
Jun 12 17:38:47 sd70 kernel: [ 1559.662857]  [<ffffffff81131203>] writeback_inodes_sb_nr+0x78/0x7f
Jun 12 17:38:47 sd70 kernel: [ 1559.662928]  [<ffffffff811312b0>] writeback_inodes_sb+0x4e/0x59
Jun 12 17:38:47 sd70 kernel: [ 1559.662999]  [<ffffffff811348ce>] __sync_filesystem+0x51/0x7a
Jun 12 17:38:47 sd70 kernel: [ 1559.663069]  [<ffffffff81134908>] sync_one_sb+0x11/0x13
Jun 12 17:38:47 sd70 kernel: [ 1559.663137]  [<ffffffff81112aae>] iterate_supers+0x69/0xbb
Jun 12 17:38:47 sd70 kernel: [ 1559.663207]  [<ffffffff81134939>] sys_sync+0x2f/0x5c
Jun 12 17:38:47 sd70 kernel: [ 1559.663275]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b

--------------040606000601010808040507
Content-Type: text/plain; name="controllerinfo.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="controllerinfo.txt"

DSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKQWRhcHRlciAjMAoKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09CiAgICAgICAgICAgICAgICAgICAgVmVyc2lvbnMKICAg
ICAgICAgICAgICAgID09PT09PT09PT09PT09PT0KUHJvZHVjdCBOYW1lICAgIDogTFNJIE1l
Z2FSQUlEIFNBUyA5MjY1LThpClNlcmlhbCBObyAgICAgICA6IFNWMjE2MzUwODAKRlcgUGFj
a2FnZSBCdWlsZDogMjMuNC4xLTAwMjgKCiAgICAgICAgICAgICAgICAgICAgTWZnLiBEYXRh
CiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09Ck1mZy4gRGF0ZSAgICAgICA6IDA0
LzIxLzEyClJld29yayBEYXRlICAgICA6IDAwLzAwLzAwClJldmlzaW9uIE5vICAgICA6IDAx
QwpCYXR0ZXJ5IEZSVSAgICAgOiBOL0EKCiAgICAgICAgICAgICAgICBJbWFnZSBWZXJzaW9u
cyBpbiBGbGFzaDoKICAgICAgICAgICAgICAgID09PT09PT09PT09PT09PT0KQklPUyBWZXJz
aW9uICAgICAgIDogNS4yOS4wMF80LjEyLjA1LjAwXzB4MDUwOTAwMDAKV2ViQklPUyBWZXJz
aW9uICAgIDogNi4xLTMxLWVfMzEtUmVsClByZWJvb3QgQ0xJIFZlcnNpb246IDA1LjAyLTAx
OiMlMDAwMDEKRlcgVmVyc2lvbiAgICAgICAgIDogMy4xNjAuMTUtMTU1OQpOVkRBVEEgVmVy
c2lvbiAgICAgOiAyLjExMDguMDMtMDA3OApCb290IEJsb2NrIFZlcnNpb24gOiAyLjA1LjAw
LjAwLTAwMDQKQk9PVCBWZXJzaW9uICAgICAgIDogMDcuMjYuMDUuMjE5CgogICAgICAgICAg
ICAgICAgUGVuZGluZyBJbWFnZXMgaW4gRmxhc2gKICAgICAgICAgICAgICAgID09PT09PT09
PT09PT09PT0KTm9uZQoKICAgICAgICAgICAgICAgIFBDSSBJbmZvCiAgICAgICAgICAgICAg
ICA9PT09PT09PT09PT09PT09ClZlbmRvciBJZCAgICAgICA6IDEwMDAKRGV2aWNlIElkICAg
ICAgIDogMDA1YgpTdWJWZW5kb3JJZCAgICAgOiAxMDAwClN1YkRldmljZUlkICAgICA6IDky
NjUKCkhvc3QgSW50ZXJmYWNlICA6IFBDSUUKCkNoaXBSZXZpc2lvbiAgICA6IEIwCgpOdW1i
ZXIgb2YgRnJvbnRlbmQgUG9ydDogMCAKRGV2aWNlIEludGVyZmFjZSAgOiBQQ0lFCgpOdW1i
ZXIgb2YgQmFja2VuZCBQb3J0OiA4IApQb3J0ICA6ICBBZGRyZXNzCjAgICAgICAgIDUwMDMw
NDgwMDAxNTkxZmYgCjEgICAgICAgIDUwMDMwNDgwMDAxYTM0ZmYgCjIgICAgICAgIDAwMDAw
MDAwMDAwMDAwMDAgCjMgICAgICAgIDAwMDAwMDAwMDAwMDAwMDAgCjQgICAgICAgIDAwMDAw
MDAwMDAwMDAwMDAgCjUgICAgICAgIDAwMDAwMDAwMDAwMDAwMDAgCjYgICAgICAgIDAwMDAw
MDAwMDAwMDAwMDAgCjcgICAgICAgIDAwMDAwMDAwMDAwMDAwMDAgCgogICAgICAgICAgICAg
ICAgSFcgQ29uZmlndXJhdGlvbgogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpT
QVMgQWRkcmVzcyAgICAgIDogNTAwNjA1YjAwNDlhZjBmMApCQlUgICAgICAgICAgICAgIDog
UHJlc2VudApBbGFybSAgICAgICAgICAgIDogUHJlc2VudApOVlJBTSAgICAgICAgICAgIDog
UHJlc2VudApTZXJpYWwgRGVidWdnZXIgIDogUHJlc2VudApNZW1vcnkgICAgICAgICAgIDog
UHJlc2VudApGbGFzaCAgICAgICAgICAgIDogUHJlc2VudApNZW1vcnkgU2l6ZSAgICAgIDog
MTAyNE1CClRQTSAgICAgICAgICAgICAgOiBBYnNlbnQKT24gYm9hcmQgRXhwYW5kZXI6IEFi
c2VudApVcGdyYWRlIEtleSAgICAgIDogQWJzZW50ClRlbXBlcmF0dXJlIHNlbnNvciBmb3Ig
Uk9DICAgIDogUHJlc2VudApUZW1wZXJhdHVyZSBzZW5zb3IgZm9yIGNvbnRyb2xsZXIgICAg
OiBBYnNlbnQKClJPQyB0ZW1wZXJhdHVyZSA6IDgyICBkZWdyZWUgQ2VsY2l1cwoKICAgICAg
ICAgICAgICAgIFNldHRpbmdzCiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09CkN1
cnJlbnQgVGltZSAgICAgICAgICAgICAgICAgICAgIDogMjM6MjM6NDEgNi8xMiwgMjAxMgpQ
cmVkaWN0aXZlIEZhaWwgUG9sbCBJbnRlcnZhbCAgICA6IDMwMHNlYwpJbnRlcnJ1cHQgVGhy
b3R0bGUgQWN0aXZlIENvdW50ICA6IDE2CkludGVycnVwdCBUaHJvdHRsZSBDb21wbGV0aW9u
ICAgIDogNTB1cwpSZWJ1aWxkIFJhdGUgICAgICAgICAgICAgICAgICAgICA6IDMwJQpQUiBS
YXRlICAgICAgICAgICAgICAgICAgICAgICAgICA6IDMwJQpCR0kgUmF0ZSAgICAgICAgICAg
ICAgICAgICAgICAgICA6IDMwJQpDaGVjayBDb25zaXN0ZW5jeSBSYXRlICAgICAgICAgICA6
IDMwJQpSZWNvbnN0cnVjdGlvbiBSYXRlICAgICAgICAgICAgICA6IDMwJQpDYWNoZSBGbHVz
aCBJbnRlcnZhbCAgICAgICAgICAgICA6IDRzCk1heCBEcml2ZXMgdG8gU3BpbnVwIGF0IE9u
ZSBUaW1lIDogMgpEZWxheSBBbW9uZyBTcGludXAgR3JvdXBzICAgICAgICA6IDEycwpQaHlz
aWNhbCBEcml2ZSBDb2VyY2lvbiBNb2RlICAgICA6IERpc2FibGVkCkNsdXN0ZXIgTW9kZSAg
ICAgICAgICAgICAgICAgICAgIDogRGlzYWJsZWQKQWxhcm0gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgOiBFbmFibGVkCkF1dG8gUmVidWlsZCAgICAgICAgICAgICAgICAgICAgIDog
RW5hYmxlZApCYXR0ZXJ5IFdhcm5pbmcgICAgICAgICAgICAgICAgICA6IEVuYWJsZWQKRWNj
IEJ1Y2tldCBTaXplICAgICAgICAgICAgICAgICAgOiAxNQpFY2MgQnVja2V0IExlYWsgUmF0
ZSAgICAgICAgICAgICA6IDE0NDAgTWludXRlcwpSZXN0b3JlIEhvdFNwYXJlIG9uIEluc2Vy
dGlvbiAgICA6IERpc2FibGVkCkV4cG9zZSBFbmNsb3N1cmUgRGV2aWNlcyAgICAgICAgIDog
RW5hYmxlZApNYWludGFpbiBQRCBGYWlsIEhpc3RvcnkgICAgICAgICA6IEVuYWJsZWQKSG9z
dCBSZXF1ZXN0IFJlb3JkZXJpbmcgICAgICAgICAgOiBFbmFibGVkCkF1dG8gRGV0ZWN0IEJh
Y2tQbGFuZSBFbmFibGVkICAgIDogU0dQSU8vaTJjIFNFUApMb2FkIEJhbGFuY2UgTW9kZSAg
ICAgICAgICAgICAgICA6IEF1dG8KVXNlIEZERSBPbmx5ICAgICAgICAgICAgICAgICAgICAg
OiBObwpTZWN1cml0eSBLZXkgQXNzaWduZWQgICAgICAgICAgICA6IE5vClNlY3VyaXR5IEtl
eSBGYWlsZWQgICAgICAgICAgICAgIDogTm8KU2VjdXJpdHkgS2V5IE5vdCBCYWNrZWR1cCAg
ICAgICAgOiBObwpEZWZhdWx0IExEIFBvd2VyU2F2ZSBQb2xpY3kgICAgICA6IENvbnRyb2xs
ZXIgRGVmaW5lZApNYXhpbXVtIG51bWJlciBvZiBkaXJlY3QgYXR0YWNoZWQgZHJpdmVzIHRv
IHNwaW4gdXAgaW4gMSBtaW4gOiAxMCAKQW55IE9mZmxpbmUgVkQgQ2FjaGUgUHJlc2VydmVk
ICAgOiBObwpBbGxvdyBCb290IHdpdGggUHJlc2VydmVkIENhY2hlICA6IE5vCkRpc2FibGUg
T25saW5lIENvbnRyb2xsZXIgUmVzZXQgIDogTm8KUEZLIGluIE5WUkFNICAgICAgICAgICAg
ICAgICAgICAgOiBObwpVc2UgZGlzayBhY3Rpdml0eSBmb3IgbG9jYXRlICAgICA6IE5vCgog
ICAgICAgICAgICAgICAgQ2FwYWJpbGl0aWVzCiAgICAgICAgICAgICAgICA9PT09PT09PT09
PT09PT09ClJBSUQgTGV2ZWwgU3VwcG9ydGVkICAgICAgICAgICAgIDogUkFJRDAsIFJBSUQx
LCBSQUlENSwgUkFJRDYsIFJBSUQwMCwgUkFJRDEwLCBSQUlENTAsIFJBSUQ2MCwgUFJMIDEx
LCBQUkwgMTEgd2l0aCBzcGFubmluZywgU1JMIDMgc3VwcG9ydGVkLCBQUkwxMS1STFEwIERE
RiBsYXlvdXQgd2l0aCBubyBzcGFuLCBQUkwxMS1STFEwIERERiBsYXlvdXQgd2l0aCBzcGFu
ClN1cHBvcnRlZCBEcml2ZXMgICAgICAgICAgICAgICAgIDogU0FTLCBTQVRBCgpBbGxvd2Vk
IE1peGluZzoKCk1peCBpbiBFbmNsb3N1cmUgQWxsb3dlZApNaXggb2YgU0FTL1NBVEEgb2Yg
SEREIHR5cGUgaW4gVkQgQWxsb3dlZAoKICAgICAgICAgICAgICAgIFN0YXR1cwogICAgICAg
ICAgICAgICAgPT09PT09PT09PT09PT09PQpFQ0MgQnVja2V0IENvdW50ICAgICAgICAgICAg
ICAgICA6IDAKCiAgICAgICAgICAgICAgICBMaW1pdGF0aW9ucwogICAgICAgICAgICAgICAg
PT09PT09PT09PT09PT09PQpNYXggQXJtcyBQZXIgVkQgICAgICAgICAgOiAzMiAKTWF4IFNw
YW5zIFBlciBWRCAgICAgICAgIDogOCAKTWF4IEFycmF5cyAgICAgICAgICAgICAgIDogMTI4
IApNYXggTnVtYmVyIG9mIFZEcyAgICAgICAgOiA2NCAKTWF4IFBhcmFsbGVsIENvbW1hbmRz
ICAgIDogMTAwOCAKTWF4IFNHRSBDb3VudCAgICAgICAgICAgIDogNjAgCk1heCBEYXRhIFRy
YW5zZmVyIFNpemUgICA6IDgxOTIgc2VjdG9ycyAKTWF4IFN0cmlwcyBQZXJJTyAgICAgICAg
IDogNDIgCk1pbiBTdHJpcCBTaXplICAgICAgICAgICA6IDggS0IKTWF4IFN0cmlwIFNpemUg
ICAgICAgICAgIDogMS4wIE1CCk1heCBDb25maWd1cmFibGUgQ2FjaGVDYWRlIFNpemU6IDAg
R0IKQ3VycmVudCBTaXplIG9mIENhY2hlQ2FkZSAgICAgIDogMCBHQgpDdXJyZW50IFNpemUg
b2YgRlcgQ2FjaGUgICAgICAgOiA5MjMgTUIKCiAgICAgICAgICAgICAgICBEZXZpY2UgUHJl
c2VudAogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpWaXJ0dWFsIERyaXZlcyAg
ICA6IDIgCiAgRGVncmFkZWQgICAgICAgIDogMCAKICBPZmZsaW5lICAgICAgICAgOiAwIApQ
aHlzaWNhbCBEZXZpY2VzICA6IDQ5IAogIERpc2tzICAgICAgICAgICA6IDQ4IAogIENyaXRp
Y2FsIERpc2tzICA6IDAgCiAgRmFpbGVkIERpc2tzICAgIDogMCAKCiAgICAgICAgICAgICAg
ICBTdXBwb3J0ZWQgQWRhcHRlciBPcGVyYXRpb25zCiAgICAgICAgICAgICAgICA9PT09PT09
PT09PT09PT09ClJlYnVpbGQgUmF0ZSAgICAgICAgICAgICAgICAgICAgOiBZZXMKQ0MgUmF0
ZSAgICAgICAgICAgICAgICAgICAgICAgICA6IFllcwpCR0kgUmF0ZSAgICAgICAgICAgICAg
ICAgICAgICAgIDogWWVzClJlY29uc3RydWN0IFJhdGUgICAgICAgICAgICAgICAgOiBZZXMK
UGF0cm9sIFJlYWQgUmF0ZSAgICAgICAgICAgICAgICA6IFllcwpBbGFybSBDb250cm9sICAg
ICAgICAgICAgICAgICAgIDogWWVzCkNsdXN0ZXIgU3VwcG9ydCAgICAgICAgICAgICAgICAg
OiBObwpCQlUgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDogWWVzClNwYW5uaW5nICAg
ICAgICAgICAgICAgICAgICAgICAgOiBZZXMKRGVkaWNhdGVkIEhvdCBTcGFyZSAgICAgICAg
ICAgICA6IFllcwpSZXZlcnRpYmxlIEhvdCBTcGFyZXMgICAgICAgICAgIDogWWVzCkZvcmVp
Z24gQ29uZmlnIEltcG9ydCAgICAgICAgICAgOiBZZXMKU2VsZiBEaWFnbm9zdGljICAgICAg
ICAgICAgICAgICA6IFllcwpBbGxvdyBNaXhlZCBSZWR1bmRhbmN5IG9uIEFycmF5IDogTm8K
R2xvYmFsIEhvdCBTcGFyZXMgICAgICAgICAgICAgICA6IFllcwpEZW55IFNDU0kgUGFzc3Ro
cm91Z2ggICAgICAgICAgIDogTm8KRGVueSBTTVAgUGFzc3Rocm91Z2ggICAgICAgICAgICA6
IE5vCkRlbnkgU1RQIFBhc3N0aHJvdWdoICAgICAgICAgICAgOiBObwpTdXBwb3J0IFNlY3Vy
aXR5ICAgICAgICAgICAgICAgIDogTm8KU25hcHNob3QgRW5hYmxlZCAgICAgICAgICAgICAg
ICA6IE5vClN1cHBvcnQgdGhlIE9DRSB3aXRob3V0IGFkZGluZyBkcml2ZXMgOiBZZXMKU3Vw
cG9ydCBQRksgICAgICAgICAgICAgICAgICAgICA6IFllcwpQRksgVHJhaWxUaW1lIFJlbWFp
bmluZyAgICAgICAgIDogMCBkYXlzIDAgaG91cnMKCiAgICAgICAgICAgICAgICBTdXBwb3J0
ZWQgVkQgT3BlcmF0aW9ucwogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpSZWFk
IFBvbGljeSAgICAgICAgICA6IFllcwpXcml0ZSBQb2xpY3kgICAgICAgICA6IFllcwpJTyBQ
b2xpY3kgICAgICAgICAgICA6IFllcwpBY2Nlc3MgUG9saWN5ICAgICAgICA6IFllcwpEaXNr
IENhY2hlIFBvbGljeSAgICA6IFllcwpSZWNvbnN0cnVjdGlvbiAgICAgICA6IFllcwpEZW55
IExvY2F0ZSAgICAgICAgICA6IE5vCkRlbnkgQ0MgICAgICAgICAgICAgIDogTm8KQWxsb3cg
Q3RybCBFbmNyeXB0aW9uOiBObwpFbmFibGUgTERCQk0gICAgICAgICA6IE5vClN1cHBvcnQg
QnJlYWttaXJyb3IgIDogTm8KUG93ZXIgU2F2aW5ncyAgICAgICAgOiBObwoKICAgICAgICAg
ICAgICAgIFN1cHBvcnRlZCBQRCBPcGVyYXRpb25zCiAgICAgICAgICAgICAgICA9PT09PT09
PT09PT09PT09CkZvcmNlIE9ubGluZSAgICAgICAgICAgICAgICAgICAgICAgICAgICA6IFll
cwpGb3JjZSBPZmZsaW5lICAgICAgICAgICAgICAgICAgICAgICAgICAgOiBZZXMKRm9yY2Ug
UmVidWlsZCAgICAgICAgICAgICAgICAgICAgICAgICAgIDogWWVzCkRlbnkgRm9yY2UgRmFp
bGVkICAgICAgICAgICAgICAgICAgICAgICA6IE5vCkRlbnkgRm9yY2UgR29vZC9CYWQgICAg
ICAgICAgICAgICAgICAgICA6IE5vCkRlbnkgTWlzc2luZyBSZXBsYWNlICAgICAgICAgICAg
ICAgICAgICA6IE5vCkRlbnkgQ2xlYXIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA6
IE5vCkRlbnkgTG9jYXRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICA6IE5vClN1cHBv
cnQgVGVtcGVyYXR1cmUgICAgICAgICAgICAgICAgICAgICA6IFllcwpEaXNhYmxlIENvcHli
YWNrICAgICAgICAgICAgICAgICAgICAgICAgOiBObwpFbmFibGUgSkJPRCAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgOiBObwpFbmFibGUgQ29weWJhY2sgb24gU01BUlQgICAgICAg
ICAgICAgICAgOiBObwpFbmFibGUgQ29weWJhY2sgdG8gU1NEIG9uIFNNQVJUIEVycm9yICAg
OiBZZXMKRW5hYmxlIFNTRCBQYXRyb2wgUmVhZCAgICAgICAgICAgICAgICAgIDogTm8KUFIg
Q29ycmVjdCBVbmNvbmZpZ3VyZWQgQXJlYXMgICAgICAgICAgIDogWWVzCkVuYWJsZSBTcGlu
IERvd24gb2YgVW5Db25maWd1cmVkIERyaXZlcyA6IFllcwpEaXNhYmxlIFNwaW4gRG93biBv
ZiBob3Qgc3BhcmVzICAgICAgICAgOiBObwpTcGluIERvd24gdGltZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgOiAzMCAKVDEwIFBvd2VyIFN0YXRlICAgICAgICAgICAgICAgICAgICAg
ICAgIDogTm8KICAgICAgICAgICAgICAgIEVycm9yIENvdW50ZXJzCiAgICAgICAgICAgICAg
ICA9PT09PT09PT09PT09PT09Ck1lbW9yeSBDb3JyZWN0YWJsZSBFcnJvcnMgICA6IDAgCk1l
bW9yeSBVbmNvcnJlY3RhYmxlIEVycm9ycyA6IDAgCgogICAgICAgICAgICAgICAgQ2x1c3Rl
ciBJbmZvcm1hdGlvbgogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpDbHVzdGVy
IFBlcm1pdHRlZCAgICAgOiBObwpDbHVzdGVyIEFjdGl2ZSAgICAgICAgOiBObwoKICAgICAg
ICAgICAgICAgIERlZmF1bHQgU2V0dGluZ3MKICAgICAgICAgICAgICAgID09PT09PT09PT09
PT09PT0KUGh5IFBvbGFyaXR5ICAgICAgICAgICAgICAgICAgICAgOiAwIApQaHkgUG9sYXJp
dHlTcGxpdCAgICAgICAgICAgICAgICA6IDAgCkJhY2tncm91bmQgUmF0ZSAgICAgICAgICAg
ICAgICAgIDogMzAgClN0cmlwIFNpemUgICAgICAgICAgICAgICAgICAgICAgIDogMjU2a0IK
Rmx1c2ggVGltZSAgICAgICAgICAgICAgICAgICAgICAgOiA0IHNlY29uZHMKV3JpdGUgUG9s
aWN5ICAgICAgICAgICAgICAgICAgICAgOiBXQgpSZWFkIFBvbGljeSAgICAgICAgICAgICAg
ICAgICAgICA6IEFkYXB0aXZlCkNhY2hlIFdoZW4gQkJVIEJhZCAgICAgICAgICAgICAgIDog
RGlzYWJsZWQKQ2FjaGVkIElPICAgICAgICAgICAgICAgICAgICAgICAgOiBObwpTTUFSVCBN
b2RlICAgICAgICAgICAgICAgICAgICAgICA6IE1vZGUgNgpBbGFybSBEaXNhYmxlICAgICAg
ICAgICAgICAgICAgICA6IFllcwpDb2VyY2lvbiBNb2RlICAgICAgICAgICAgICAgICAgICA6
IE5vbmUKWkNSIENvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgOiBVbmtub3duCkRpcnR5
IExFRCBTaG93cyBEcml2ZSBBY3Rpdml0eSAgIDogTm8KQklPUyBDb250aW51ZSBvbiBFcnJv
ciAgICAgICAgICAgOiBObwpTcGluIERvd24gTW9kZSAgICAgICAgICAgICAgICAgICA6IE5v
bmUKQWxsb3dlZCBEZXZpY2UgVHlwZSAgICAgICAgICAgICAgOiBTQVMvU0FUQSBNaXgKQWxs
b3cgTWl4IGluIEVuY2xvc3VyZSAgICAgICAgICAgOiBZZXMKQWxsb3cgSEREIFNBUy9TQVRB
IE1peCBpbiBWRCAgICAgOiBZZXMKQWxsb3cgU1NEIFNBUy9TQVRBIE1peCBpbiBWRCAgICAg
OiBObwpBbGxvdyBIREQvU1NEIE1peCBpbiBWRCAgICAgICAgICA6IE5vCkFsbG93IFNBVEEg
aW4gQ2x1c3RlciAgICAgICAgICAgIDogTm8KTWF4IENoYWluZWQgRW5jbG9zdXJlcyAgICAg
ICAgICAgOiAxNiAKRGlzYWJsZSBDdHJsLVIgICAgICAgICAgICAgICAgICAgOiBZZXMKRW5h
YmxlIFdlYiBCSU9TICAgICAgICAgICAgICAgICAgOiBZZXMKRGlyZWN0IFBEIE1hcHBpbmcg
ICAgICAgICAgICAgICAgOiBObwpCSU9TIEVudW1lcmF0ZSBWRHMgICAgICAgICAgICAgICA6
IFllcwpSZXN0b3JlIEhvdCBTcGFyZSBvbiBJbnNlcnRpb24gICA6IE5vCkV4cG9zZSBFbmNs
b3N1cmUgRGV2aWNlcyAgICAgICAgIDogWWVzCk1haW50YWluIFBEIEZhaWwgSGlzdG9yeSAg
ICAgICAgIDogWWVzCkRpc2FibGUgUHVuY3R1cmluZyAgICAgICAgICAgICAgIDogTm8KWmVy
byBCYXNlZCBFbmNsb3N1cmUgRW51bWVyYXRpb24gOiBObwpQcmVCb290IENMSSBFbmFibGVk
ICAgICAgICAgICAgICA6IFllcwpMRUQgU2hvdyBEcml2ZSBBY3Rpdml0eSAgICAgICAgICA6
IFllcwpDbHVzdGVyIERpc2FibGUgICAgICAgICAgICAgICAgICA6IFllcwpTQVMgRGlzYWJs
ZSAgICAgICAgICAgICAgICAgICAgICA6IE5vCkF1dG8gRGV0ZWN0IEJhY2tQbGFuZSBFbmFi
bGUgICAgIDogU0dQSU8vaTJjIFNFUApVc2UgRkRFIE9ubHkgICAgICAgICAgICAgICAgICAg
ICA6IE5vCkVuYWJsZSBMZWQgSGVhZGVyICAgICAgICAgICAgICAgIDogTm8KRGVsYXkgZHVy
aW5nIFBPU1QgICAgICAgICAgICAgICAgOiAwIApFbmFibGVDcmFzaER1bXAgICAgICAgICAg
ICAgICAgICA6IE5vCkRpc2FibGUgT25saW5lIENvbnRyb2xsZXIgUmVzZXQgIDogTm8KRW5h
YmxlTERCQk0gICAgICAgICAgICAgICAgICAgICAgOiBObwpVbi1DZXJ0aWZpZWQgSGFyZCBE
aXNrIERyaXZlcyAgICA6IEFsbG93ClRyZWF0IFNpbmdsZSBzcGFuIFIxRSBhcyBSMTAgICAg
IDogTm8KTWF4IExEIHBlciBhcnJheSAgICAgICAgICAgICAgICAgOiAxNgpQb3dlciBTYXZp
bmcgb3B0aW9uICAgICAgICAgICAgICA6IERvbid0IEF1dG8gc3BpbiBkb3duIENvbmZpZ3Vy
ZWQgRHJpdmVzCk1heCBwb3dlciBzYXZpbmdzIG9wdGlvbiBpcyAgbm90IGFsbG93ZWQgZm9y
IExEcy4gT25seSBUMTAgcG93ZXIgY29uZGl0aW9ucyBhcmUgdG8gYmUgdXNlZC4KRGVmYXVs
dCBzcGluIGRvd24gdGltZSBpbiBtaW51dGVzOiAzMCAKRW5hYmxlIEpCT0QgICAgICAgICAg
ICAgICAgICAgICAgOiBObwpUVFkgTG9nIEluIEZsYXNoICAgICAgICAgICAgICAgICA6IE5v
CkF1dG8gRW5oYW5jZWQgSW1wb3J0ICAgICAgICAgICAgIDogTm8KQnJlYWtNaXJyb3IgUkFJ
RCBTdXBwb3J0ICAgICAgICAgOiBObwpEaXNhYmxlIEpvaW4gTWlycm9yICAgICAgICAgICAg
ICA6IE5vClRpbWUgdGFrZW4gdG8gZGV0ZWN0IENNRSAgICAgICAgIDogNjBzCgpFeGl0IENv
ZGU6IDB4MDAK
--------------040606000601010808040507
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------040606000601010808040507--

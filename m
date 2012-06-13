Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D8s9wO109965 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 03:54:10 -0500
Received: from xsnews-ex.xsnews.local (exchange.xsnews.nl [78.152.36.69]) by
	cuda.sgi.com with ESMTP id 4DKpwk7E1EslO5aw (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 01:54:06 -0700 (PDT)
Message-ID: <4FD8552C.4090208@xsnews.nl>
Date: Wed, 13 Jun 2012 10:54:04 +0200
From: Matthew Whittaker-Williams <matthew@xsnews.nl>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
In-Reply-To: <20120613011950.GN22848@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8012486331003199709=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8012486331003199709==
Content-Type: multipart/alternative;
	boundary="------------060208000701040406020909"

--------------060208000701040406020909
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/12 3:19 AM, Dave Chinner wrote:
>
> With the valid stack traces, I see that it isn't related to the log,
> though.

Ah ok, we are triggering a new issue?
>
>>>> If you need any more information I am happy to provide it.
>>> What workload are you running that triggers this?
>> About our workload, we are providing usenet with diablo.
>> We are currently triggering the issue with running several
>> diloadfromspool commands.
>> This will scan the entire spool and extracts article location size
>> and message-id and placement information.
> .....
>> But we have also been able to produce the same trigger with running
>> multiple bonnie++ commands.
> .....
>> It gets triggered when filesystem gets generally alot of reads.
> And that is what makes it different to the other hangs we've been
> seeing.
>
>> Filesystem info:
> Looks like a standard 41TB filesystem layout.

Correct
>
>> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
>> Size                : 40.014 TB
>> State               : Optimal
>> Strip Size          : 64 KB
>> Number Of Drives    : 24
> .....
>> Virtual Drive: 1 (Target Id: 1)
>> Name                :
>> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
>> Size                : 40.014 TB
>> State               : Optimal
>> Strip Size          : 1.0 MB
>> Number Of Drives    : 24
> OOC, any reason for the different stripe sizes on the two
> RAID volumes?

This is a fluke, we are running several new systems and this is just one 
of the new servers.
Which indeed has a wrong stripe set, this should be 1MB.
We actually found stripe size set of 1MB to give better performance 
overall than 64/256/512
>
> It does, however, point to your problem - you have 24 disk RAID6
> volumes and you are reading and writing lots of small files on them.
> Every small random file write is going to cause a RMW cycle in the
> RAID6 volume (i.e. across all 24 disks), so it is going to be *very*
> slow when the BBWC can't hide that latency.
>
> That, in turn, is going to make reads very slow as the are going to
> get queued up behind those RMW cycles as the BBWC flushes all those
> small writes it has buffered.
>
> what does the output of a coupl eof minutes of 'iostat -d -x -m 5'
> look like when this problem is occurring?

I will get back to you on this.
>
>>   imklog 4.6.4, log source = /proc/kmsg started.
>>   [  323.966564] XFS (sdb): Mounting Filesystem
>>   [  324.183373] XFS (sdb): Ending clean mount
>>   Kernel logging (proc) stopped.
>>   imklog 4.6.4, log source = /proc/kmsg started.
>>   [ 1200.374551] INFO: task kworker/0:2:1115 blocked for more than 120 seconds.
>>   [ 1200.374628] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   [ 1200.374722] kworker/0:2     D ffff8805ebdd3fa8     0  1115      2 0x00000000
>>   [ 1200.374860]  ffff880602ae7bf0 0000000000000046 ffffffff814cecd0 ffff880603c56840
>>   [ 1200.375098]  0000000000000400 ffff880602ae6010 0000000000013340 0000000000013340
>>   [ 1200.375336]  ffff880602ae7fd8 0000000000013340 ffff880602ae7fd8 0000000000013340
>>   [ 1200.375573] Call Trace:
>>   [ 1200.375641]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>>   [ 1200.375709]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
>>   [ 1200.375775]  [<ffffffff8137d912>] __down_common+0x96/0xe4
>>   [ 1200.375858]  [<ffffffffa034338c>] ? xfs_getsb+0x32/0x60 [xfs]
>>   [ 1200.375928]  [<ffffffff8137d9bf>] __down+0x18/0x1a
>>   [ 1200.375996]  [<ffffffff81060428>] down+0x28/0x38
>>   [ 1200.376071]  [<ffffffffa02f4786>] xfs_buf_lock+0x6f/0xc0 [xfs]
>>   [ 1200.376155]  [<ffffffffa034338c>] xfs_getsb+0x32/0x60 [xfs]
>>   [ 1200.376235]  [<ffffffffa035065c>] xfs_trans_getsb+0xb3/0x107 [xfs]
>>   [ 1200.376319]  [<ffffffffa0343da5>] xfs_mod_sb+0x41/0x112 [xfs]
>>   [ 1200.376401]  [<ffffffffa0303bac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
>>   [ 1200.376482]  [<ffffffffa02f9434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
>>   [ 1200.382394]  [<ffffffffa034a656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
>>   [ 1200.382534]  [<ffffffffa0303bea>] xfs_sync_worker+0x3e/0x64 [xfs]
>>   [ 1200.382607]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
>>   [ 1200.382741]  [<ffffffff8105531e>] worker_thread+0x13e/0x264
> That is blocked trying to read the superblock, which means it is
> probably locked for writeback. i.e. it's sitting in an IO queue
> somewhere. The xfs_sync_worker is not blocked on log space which
> means this is not the same as the problem I mentioned previously.
>
>
>> [ 1201.674223] bonnie++        D ffff8805bc4f02e8     0  6337      1 0x00000000
>> [ 1201.674370]  ffff88059b5f59b8 0000000000000086 ffff880601a53bb8 0000000000000286
>> [ 1201.674607]  ffff88059b5f5968 ffff88059b5f4010 0000000000013340 0000000000013340
>> [ 1201.674844]  ffff88059b5f5fd8 0000000000013340 ffff88059b5f5fd8 0000000000013340
>> [ 1201.675081] Call Trace:
>> [ 1201.675142]  [<ffffffff810d0ef2>] ? __probe_kernel_read+0x36/0x55
>> [ 1201.675212]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>> [ 1201.675280]  [<ffffffff8137d00a>] schedule_timeout+0xa6/0xde
>> [ 1201.675350]  [<ffffffff8104a2d7>] ? lock_timer_base+0x4d/0x4d
>> [ 1201.675420]  [<ffffffff8137da54>] io_schedule_timeout+0x93/0xe4
>> [ 1201.675491]  [<ffffffff810d5ecf>] ? bdi_dirty_limit+0x2c/0x8b
>> [ 1201.675561]  [<ffffffff810d70a5>] balance_dirty_pages+0x511/0x5ba
>> [ 1201.675633]  [<ffffffff810d7224>] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
>> [ 1201.675723]  [<ffffffff810cd1fc>] generic_perform_write+0x192/0x1df
>> [ 1201.675858]  [<ffffffff810cd29c>] generic_file_buffered_write+0x53/0x7d
>> [ 1201.675939]  [<ffffffffa02f7d57>] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
>> [ 1201.676039]  [<ffffffffa02f8155>] xfs_file_aio_write+0x15e/0x1b0 [xfs]
>> [ 1201.676117]  [<ffffffffa02f8002>] ? xfs_file_aio_write+0xb/0x1b0 [xfs]
>> [ 1201.676188]  [<ffffffff811107e3>] do_sync_write+0xc9/0x106
>> [ 1201.676257]  [<ffffffff8117c919>] ? security_file_permission+0x29/0x2e
>> [ 1201.676327]  [<ffffffff8111117d>] vfs_write+0xa9/0x105
>> [ 1201.676394]  [<ffffffff81111292>] sys_write+0x45/0x6c
>> [ 1201.676461]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
> All the bonnie++ processes are waiting for write IO to complete so
> they can dirty more pages (i.e. write more in to the page cache).
>
>>   [ 1201.700104] flush-8:0       D ffff8805bcaf5aa8     0  6346      2 0x00000000
>>   [ 1201.700250]  ffff88059d78f710 0000000000000046 ffff88059d78f700 ffff88059d78f6e0
>>   [ 1201.700487]  ffff8805eaef8000 ffff88059d78e010 0000000000013340 0000000000013340
>>   [ 1201.700724]  ffff88059d78ffd8 0000000000013340 ffff88059d78ffd8 0000000000013340
>>   [ 1201.700961] Call Trace:
>>   [ 1201.701022]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>>   [ 1201.701090]  [<ffffffff8137e338>] io_schedule+0x87/0xca
>>   [ 1201.701159]  [<ffffffff811aca59>] get_request_wait+0x116/0x1b9
>>   [ 1201.701229]  [<ffffffff8105bfcf>] ? wake_up_bit+0x25/0x25
>>   [ 1201.701298]  [<ffffffff811a70d2>] ? elv_merge+0xae/0xbe
>>   [ 1201.701367]  [<ffffffff811acf8f>] blk_queue_bio+0x1a8/0x30d
>>   [ 1201.701436]  [<ffffffff811ac2e5>] generic_make_request+0x99/0xdc
>>   [ 1201.701507]  [<ffffffff811ac407>] submit_bio+0xdf/0xfe
>>   [ 1201.701580]  [<ffffffffa02f1c3d>] xfs_submit_ioend_bio+0x2e/0x30 [xfs]
>>   [ 1201.701658]  [<ffffffffa02f236e>] xfs_submit_ioend+0xa1/0xea [xfs]
>>   [ 1201.701736]  [<ffffffffa02f353f>] xfs_vm_writepage+0x40f/0x484 [xfs]
>>   [ 1201.701808]  [<ffffffff811c761c>] ? rb_insert_color+0xbc/0xe5
>>   [ 1201.701878]  [<ffffffff810d558a>] __writepage+0x12/0x2b
>>   [ 1201.701946]  [<ffffffff810d6a0d>] write_cache_pages+0x25f/0x36a
>>   [ 1201.702017]  [<ffffffff810d5578>] ? set_page_dirty+0x62/0x62
>>   [ 1201.702087]  [<ffffffff810d6b58>] generic_writepages+0x40/0x57
>>   [ 1201.702162]  [<ffffffffa02f1a30>] xfs_vm_writepages+0x48/0x4f [xfs]
>>   [ 1201.702234]  [<ffffffff810d6b8b>] do_writepages+0x1c/0x25
>>   [ 1201.702304]  [<ffffffff81130a04>] writeback_single_inode+0x183/0x370
>>   [ 1201.702376]  [<ffffffff81130eaa>] writeback_sb_inodes+0x172/0x20b
>>   [ 1201.702447]  [<ffffffff81130fb6>] __writeback_inodes_wb+0x73/0xb4
>>   [ 1201.702518]  [<ffffffff8113162b>] wb_writeback+0x136/0x22c
>>   [ 1201.702587]  [<ffffffff810d61c1>] ? global_dirty_limits+0x2a/0x10a
>>   [ 1201.702659]  [<ffffffff811317b1>] wb_do_writeback+0x90/0x1de
>>   [ 1201.702729]  [<ffffffff811319bf>] bdi_writeback_thread+0xc0/0x1e5
>>   [ 1201.702800]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
>>   [ 1201.702871]  [<ffffffff811318ff>] ? wb_do_writeback+0x1de/0x1de
>>   [ 1201.702941]  [<ffffffff8105bb50>] kthread+0x84/0x8c
>>   [ 1201.703009]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
>>   [ 1201.703079]  [<ffffffff8105bacc>] ? kthread_freezable_should_stop+0x5d/0x5d
>>   [ 1201.703152]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
> And writeback is stalled waiting for IO to complete as well (hence
> the bonnie++ processes being blocked). IN this case, the IO request
> queue is full, which indicates it is waiting on the disk subsystem
> to complete IO requests....
>
>>   [ 1559.653179] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   [ 1559.653269] sync            D ffff8805ec48b8e8     0  7493   7169 0x00000000
>>   [ 1559.653417]  ffff880208869cf8 0000000000000086 ffff8805bc02ae78 00000000000000c9
>>   [ 1559.653655]  ffff880208869ce8 ffff880208868010 0000000000013340 0000000000013340
>>   [ 1559.653892]  ffff880208869fd8 0000000000013340 ffff880208869fd8 0000000000013340
>>   [ 1559.654129] Call Trace:
>>   [ 1559.654197]  [<ffffffff8137e2af>] schedule+0x5f/0x61
>>   [ 1559.654265]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
>>   [ 1559.654337]  [<ffffffff8106b47b>] ? wake_affine+0x190/0x248
>>   [ 1559.660092]  [<ffffffff8106ec4e>] ? enqueue_entity+0x121/0x1cd
>>   [ 1559.660163]  [<ffffffff8137e136>] wait_for_common+0xcc/0x14a
>>   [ 1559.660235]  [<ffffffff8106a36c>] ? try_to_wake_up+0x1b4/0x1b4
>>   [ 1559.660307]  [<ffffffff810440c8>] ? local_bh_enable_ip+0x9/0xb
>>   [ 1559.660382]  [<ffffffff811348f7>] ? __sync_filesystem+0x7a/0x7a
>>   [ 1559.660452]  [<ffffffff8137e24e>] wait_for_completion+0x18/0x1a
>>   [ 1559.660524]  [<ffffffff81131203>] writeback_inodes_sb_nr+0x78/0x7f
>>   [ 1559.660596]  [<ffffffff811312b0>] writeback_inodes_sb+0x4e/0x59
>>   [ 1559.660667]  [<ffffffff811348ce>] __sync_filesystem+0x51/0x7a
>>   [ 1559.660738]  [<ffffffff81134908>] sync_one_sb+0x11/0x13
>>   [ 1559.660827]  [<ffffffff81112aae>] iterate_supers+0x69/0xbb
>>   [ 1559.660898]  [<ffffffff81134939>] sys_sync+0x2f/0x5c
>>   [ 1559.661052]  [<ffffffff813857f9>] system_call_fastpath+0x16/0x1b
> And that is sync waiting for the flusher thread to complete
> writeback of all the dirty inodes. The lack of other stall messages
> at this time makes it pretty clear that the problem is not
> filesystem related - the system is simply writeback IO bound.
>
> The reason, I'd suggest, is that you've chosen the wrong RAID volume
> type for your workload. Small random file read and write workloads
> like news and mail spoolers are IOPS intensive workloads and do
> not play well with RAID5/6. RAID5/6 really only work well for large
> files with sequential access patterns - you need to use RAID1/10 for
> IOPS intensive workloads because they don't suffer from the RMW
> cycle problem that RAID5/6 has for small writes. The iostat output
> will help clarify whether this is really the problem or not...

I understand that RAID 10 is better for performance for reads on small 
files sets.
But with raid 10 we of course loose a lot of disk space compared to RAID 6.
Side note to this we have been running RAID 6 for years now without any 
issues.

In the past we did tune our xfs filesystem with switches like sunit and 
swidth.
But back then we couldn't see much peformance difference between using:

mkfs.xfs -f -L P.01 -l lazy-count=1 -d su=1m,sw=22 /dev/sda

and

mkfs.xfs -f -L P.01 -l lazy-count=1 /dev/sda

xfs_info from a system that shows no problems with an H800 Controller 
from dell ( same chipset as the LSI controllers )

Product Name    : PERC H800 Adapter
Serial No       : 071002C
FW Package Build: 12.10.1-0001

sd60:~# xfs_info /dev/sda
meta-data=/dev/sda               isize=256    agcount=58, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=15381037056, imaxpct=1
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Where we even have bigger spools:

Adapter 0 -- Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :p01
RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
Size                : 57.298 TB
State               : Optimal
Strip Size          : 1.0 MB
Number Of Drives    : 23
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache OK 
if Bad BBU
Current Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache OK 
if Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Bad Blocks Exist: No



Aside from the wrong stripe set and write alignments, this still should 
not cause the kernel to crash like this.
We found that running with a newer driver of LSI it takes a bit longer 
for the kernel to crash but it still does.

>
> Cheers,
>
> Dave.

Thanks


--------------060208000701040406020909
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 6/13/12 3:19 AM, Dave Chinner wrote:
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite"><br>
      <pre wrap="">
With the valid stack traces, I see that it isn't related to the log,
though.</pre>
    </blockquote>
    <br>
    Ah ok, we are triggering a new issue? <br>
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite">
      <pre wrap="">

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <blockquote type="cite">
            <pre wrap="">If you need any more information I am happy to provide it.
</pre>
          </blockquote>
          <pre wrap="">What workload are you running that triggers this?
</pre>
        </blockquote>
        <pre wrap="">
About our workload, we are providing usenet with diablo.
We are currently triggering the issue with running several
diloadfromspool commands.
This will scan the entire spool and extracts article location size
and message-id and placement information.
</pre>
      </blockquote>
      <pre wrap="">.....
</pre>
      <blockquote type="cite">
        <pre wrap="">But we have also been able to produce the same trigger with running
multiple bonnie++ commands.
</pre>
      </blockquote>
      <pre wrap="">.....
</pre>
      <blockquote type="cite">
        <pre wrap="">It gets triggered when filesystem gets generally alot of reads.
</pre>
      </blockquote>
      <pre wrap="">
And that is what makes it different to the other hangs we've been
seeing.

</pre>
      <blockquote type="cite">
        <pre wrap="">Filesystem info:
</pre>
      </blockquote>
      <pre wrap="">
Looks like a standard 41TB filesystem layout.</pre>
    </blockquote>
    <br>
    Correct<br>
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite">
      <pre wrap="">

</pre>
      <blockquote type="cite">
        <pre wrap="">RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
Size                : 40.014 TB
State               : Optimal
Strip Size          : 64 KB
Number Of Drives    : 24
</pre>
      </blockquote>
      <pre wrap="">.....
</pre>
      <blockquote type="cite">
        <pre wrap="">Virtual Drive: 1 (Target Id: 1)
Name                :
RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
Size                : 40.014 TB
State               : Optimal
Strip Size          : 1.0 MB
Number Of Drives    : 24
</pre>
      </blockquote>
      <pre wrap="">
OOC, any reason for the different stripe sizes on the two
RAID volumes?</pre>
    </blockquote>
    <br>
    This is a fluke, we are running several new systems and this is just
    one of the new servers.<br>
    Which indeed has a wrong stripe set, this should be 1MB.<br>
    We actually found stripe size set of 1MB to give better performance
    overall than 64/256/512 <br>
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite">
      <pre wrap="">

It does, however, point to your problem - you have 24 disk RAID6
volumes and you are reading and writing lots of small files on them.
Every small random file write is going to cause a RMW cycle in the
RAID6 volume (i.e. across all 24 disks), so it is going to be *very*
slow when the BBWC can't hide that latency.

That, in turn, is going to make reads very slow as the are going to
get queued up behind those RMW cycles as the BBWC flushes all those
small writes it has buffered.

what does the output of a coupl eof minutes of 'iostat -d -x -m 5'
look like when this problem is occurring?</pre>
    </blockquote>
    <br>
    I will get back to you on this.<br>
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite">
      <pre wrap="">

</pre>
      <blockquote type="cite">
        <pre wrap=""> imklog 4.6.4, log source = /proc/kmsg started.
 [  323.966564] XFS (sdb): Mounting Filesystem
 [  324.183373] XFS (sdb): Ending clean mount
 Kernel logging (proc) stopped.
 imklog 4.6.4, log source = /proc/kmsg started.
 [ 1200.374551] INFO: task kworker/0:2:1115 blocked for more than 120 seconds.
 [ 1200.374628] "echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [ 1200.374722] kworker/0:2     D ffff8805ebdd3fa8     0  1115      2 0x00000000
 [ 1200.374860]  ffff880602ae7bf0 0000000000000046 ffffffff814cecd0 ffff880603c56840
 [ 1200.375098]  0000000000000400 ffff880602ae6010 0000000000013340 0000000000013340
 [ 1200.375336]  ffff880602ae7fd8 0000000000013340 ffff880602ae7fd8 0000000000013340
 [ 1200.375573] Call Trace:
 [ 1200.375641]  [&lt;ffffffff8137e2af&gt;] schedule+0x5f/0x61
 [ 1200.375709]  [&lt;ffffffff8137cf95&gt;] schedule_timeout+0x31/0xde
 [ 1200.375775]  [&lt;ffffffff8137d912&gt;] __down_common+0x96/0xe4
 [ 1200.375858]  [&lt;ffffffffa034338c&gt;] ? xfs_getsb+0x32/0x60 [xfs]
 [ 1200.375928]  [&lt;ffffffff8137d9bf&gt;] __down+0x18/0x1a
 [ 1200.375996]  [&lt;ffffffff81060428&gt;] down+0x28/0x38
 [ 1200.376071]  [&lt;ffffffffa02f4786&gt;] xfs_buf_lock+0x6f/0xc0 [xfs]
 [ 1200.376155]  [&lt;ffffffffa034338c&gt;] xfs_getsb+0x32/0x60 [xfs]
 [ 1200.376235]  [&lt;ffffffffa035065c&gt;] xfs_trans_getsb+0xb3/0x107 [xfs]
 [ 1200.376319]  [&lt;ffffffffa0343da5&gt;] xfs_mod_sb+0x41/0x112 [xfs]
 [ 1200.376401]  [&lt;ffffffffa0303bac&gt;] ? xfs_flush_inodes+0x2e/0x2e [xfs]
 [ 1200.376482]  [&lt;ffffffffa02f9434&gt;] xfs_fs_log_dummy+0x61/0x76 [xfs]
 [ 1200.382394]  [&lt;ffffffffa034a656&gt;] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
 [ 1200.382534]  [&lt;ffffffffa0303bea&gt;] xfs_sync_worker+0x3e/0x64 [xfs]
 [ 1200.382607]  [&lt;ffffffff810550d1&gt;] process_one_work+0x1da/0x2e9
 [ 1200.382741]  [&lt;ffffffff8105531e&gt;] worker_thread+0x13e/0x264
</pre>
      </blockquote>
      <pre wrap="">
That is blocked trying to read the superblock, which means it is
probably locked for writeback. i.e. it's sitting in an IO queue
somewhere. The xfs_sync_worker is not blocked on log space which
means this is not the same as the problem I mentioned previously.


</pre>
      <blockquote type="cite">
        <pre wrap="">[ 1201.674223] bonnie++        D ffff8805bc4f02e8     0  6337      1 0x00000000
[ 1201.674370]  ffff88059b5f59b8 0000000000000086 ffff880601a53bb8 0000000000000286
[ 1201.674607]  ffff88059b5f5968 ffff88059b5f4010 0000000000013340 0000000000013340
[ 1201.674844]  ffff88059b5f5fd8 0000000000013340 ffff88059b5f5fd8 0000000000013340
[ 1201.675081] Call Trace:
[ 1201.675142]  [&lt;ffffffff810d0ef2&gt;] ? __probe_kernel_read+0x36/0x55
[ 1201.675212]  [&lt;ffffffff8137e2af&gt;] schedule+0x5f/0x61
[ 1201.675280]  [&lt;ffffffff8137d00a&gt;] schedule_timeout+0xa6/0xde
[ 1201.675350]  [&lt;ffffffff8104a2d7&gt;] ? lock_timer_base+0x4d/0x4d
[ 1201.675420]  [&lt;ffffffff8137da54&gt;] io_schedule_timeout+0x93/0xe4
[ 1201.675491]  [&lt;ffffffff810d5ecf&gt;] ? bdi_dirty_limit+0x2c/0x8b
[ 1201.675561]  [&lt;ffffffff810d70a5&gt;] balance_dirty_pages+0x511/0x5ba
[ 1201.675633]  [&lt;ffffffff810d7224&gt;] balance_dirty_pages_ratelimited_nr+0xd6/0xd8
[ 1201.675723]  [&lt;ffffffff810cd1fc&gt;] generic_perform_write+0x192/0x1df
[ 1201.675858]  [&lt;ffffffff810cd29c&gt;] generic_file_buffered_write+0x53/0x7d
[ 1201.675939]  [&lt;ffffffffa02f7d57&gt;] xfs_file_buffered_aio_write+0xf2/0x156 [xfs]
[ 1201.676039]  [&lt;ffffffffa02f8155&gt;] xfs_file_aio_write+0x15e/0x1b0 [xfs]
[ 1201.676117]  [&lt;ffffffffa02f8002&gt;] ? xfs_file_aio_write+0xb/0x1b0 [xfs]
[ 1201.676188]  [&lt;ffffffff811107e3&gt;] do_sync_write+0xc9/0x106
[ 1201.676257]  [&lt;ffffffff8117c919&gt;] ? security_file_permission+0x29/0x2e
[ 1201.676327]  [&lt;ffffffff8111117d&gt;] vfs_write+0xa9/0x105
[ 1201.676394]  [&lt;ffffffff81111292&gt;] sys_write+0x45/0x6c
[ 1201.676461]  [&lt;ffffffff813857f9&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
All the bonnie++ processes are waiting for write IO to complete so
they can dirty more pages (i.e. write more in to the page cache).

</pre>
      <blockquote type="cite">
        <pre wrap=""> [ 1201.700104] flush-8:0       D ffff8805bcaf5aa8     0  6346      2 0x00000000
 [ 1201.700250]  ffff88059d78f710 0000000000000046 ffff88059d78f700 ffff88059d78f6e0
 [ 1201.700487]  ffff8805eaef8000 ffff88059d78e010 0000000000013340 0000000000013340
 [ 1201.700724]  ffff88059d78ffd8 0000000000013340 ffff88059d78ffd8 0000000000013340
 [ 1201.700961] Call Trace:
 [ 1201.701022]  [&lt;ffffffff8137e2af&gt;] schedule+0x5f/0x61
 [ 1201.701090]  [&lt;ffffffff8137e338&gt;] io_schedule+0x87/0xca
 [ 1201.701159]  [&lt;ffffffff811aca59&gt;] get_request_wait+0x116/0x1b9
 [ 1201.701229]  [&lt;ffffffff8105bfcf&gt;] ? wake_up_bit+0x25/0x25
 [ 1201.701298]  [&lt;ffffffff811a70d2&gt;] ? elv_merge+0xae/0xbe
 [ 1201.701367]  [&lt;ffffffff811acf8f&gt;] blk_queue_bio+0x1a8/0x30d
 [ 1201.701436]  [&lt;ffffffff811ac2e5&gt;] generic_make_request+0x99/0xdc
 [ 1201.701507]  [&lt;ffffffff811ac407&gt;] submit_bio+0xdf/0xfe
 [ 1201.701580]  [&lt;ffffffffa02f1c3d&gt;] xfs_submit_ioend_bio+0x2e/0x30 [xfs]
 [ 1201.701658]  [&lt;ffffffffa02f236e&gt;] xfs_submit_ioend+0xa1/0xea [xfs]
 [ 1201.701736]  [&lt;ffffffffa02f353f&gt;] xfs_vm_writepage+0x40f/0x484 [xfs]
 [ 1201.701808]  [&lt;ffffffff811c761c&gt;] ? rb_insert_color+0xbc/0xe5
 [ 1201.701878]  [&lt;ffffffff810d558a&gt;] __writepage+0x12/0x2b
 [ 1201.701946]  [&lt;ffffffff810d6a0d&gt;] write_cache_pages+0x25f/0x36a
 [ 1201.702017]  [&lt;ffffffff810d5578&gt;] ? set_page_dirty+0x62/0x62
 [ 1201.702087]  [&lt;ffffffff810d6b58&gt;] generic_writepages+0x40/0x57
 [ 1201.702162]  [&lt;ffffffffa02f1a30&gt;] xfs_vm_writepages+0x48/0x4f [xfs]
 [ 1201.702234]  [&lt;ffffffff810d6b8b&gt;] do_writepages+0x1c/0x25
 [ 1201.702304]  [&lt;ffffffff81130a04&gt;] writeback_single_inode+0x183/0x370
 [ 1201.702376]  [&lt;ffffffff81130eaa&gt;] writeback_sb_inodes+0x172/0x20b
 [ 1201.702447]  [&lt;ffffffff81130fb6&gt;] __writeback_inodes_wb+0x73/0xb4
 [ 1201.702518]  [&lt;ffffffff8113162b&gt;] wb_writeback+0x136/0x22c
 [ 1201.702587]  [&lt;ffffffff810d61c1&gt;] ? global_dirty_limits+0x2a/0x10a
 [ 1201.702659]  [&lt;ffffffff811317b1&gt;] wb_do_writeback+0x90/0x1de
 [ 1201.702729]  [&lt;ffffffff811319bf&gt;] bdi_writeback_thread+0xc0/0x1e5
 [ 1201.702800]  [&lt;ffffffff811318ff&gt;] ? wb_do_writeback+0x1de/0x1de
 [ 1201.702871]  [&lt;ffffffff811318ff&gt;] ? wb_do_writeback+0x1de/0x1de
 [ 1201.702941]  [&lt;ffffffff8105bb50&gt;] kthread+0x84/0x8c
 [ 1201.703009]  [&lt;ffffffff81386ae4&gt;] kernel_thread_helper+0x4/0x10
 [ 1201.703079]  [&lt;ffffffff8105bacc&gt;] ? kthread_freezable_should_stop+0x5d/0x5d
 [ 1201.703152]  [&lt;ffffffff81386ae0&gt;] ? gs_change+0x13/0x13
</pre>
      </blockquote>
      <pre wrap="">
And writeback is stalled waiting for IO to complete as well (hence
the bonnie++ processes being blocked). IN this case, the IO request
queue is full, which indicates it is waiting on the disk subsystem
to complete IO requests....

</pre>
      <blockquote type="cite">
        <pre wrap=""> [ 1559.653179] "echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [ 1559.653269] sync            D ffff8805ec48b8e8     0  7493   7169 0x00000000
 [ 1559.653417]  ffff880208869cf8 0000000000000086 ffff8805bc02ae78 00000000000000c9
 [ 1559.653655]  ffff880208869ce8 ffff880208868010 0000000000013340 0000000000013340
 [ 1559.653892]  ffff880208869fd8 0000000000013340 ffff880208869fd8 0000000000013340
 [ 1559.654129] Call Trace:
 [ 1559.654197]  [&lt;ffffffff8137e2af&gt;] schedule+0x5f/0x61
 [ 1559.654265]  [&lt;ffffffff8137cf95&gt;] schedule_timeout+0x31/0xde
 [ 1559.654337]  [&lt;ffffffff8106b47b&gt;] ? wake_affine+0x190/0x248
 [ 1559.660092]  [&lt;ffffffff8106ec4e&gt;] ? enqueue_entity+0x121/0x1cd
 [ 1559.660163]  [&lt;ffffffff8137e136&gt;] wait_for_common+0xcc/0x14a
 [ 1559.660235]  [&lt;ffffffff8106a36c&gt;] ? try_to_wake_up+0x1b4/0x1b4
 [ 1559.660307]  [&lt;ffffffff810440c8&gt;] ? local_bh_enable_ip+0x9/0xb
 [ 1559.660382]  [&lt;ffffffff811348f7&gt;] ? __sync_filesystem+0x7a/0x7a
 [ 1559.660452]  [&lt;ffffffff8137e24e&gt;] wait_for_completion+0x18/0x1a
 [ 1559.660524]  [&lt;ffffffff81131203&gt;] writeback_inodes_sb_nr+0x78/0x7f
 [ 1559.660596]  [&lt;ffffffff811312b0&gt;] writeback_inodes_sb+0x4e/0x59
 [ 1559.660667]  [&lt;ffffffff811348ce&gt;] __sync_filesystem+0x51/0x7a
 [ 1559.660738]  [&lt;ffffffff81134908&gt;] sync_one_sb+0x11/0x13
 [ 1559.660827]  [&lt;ffffffff81112aae&gt;] iterate_supers+0x69/0xbb
 [ 1559.660898]  [&lt;ffffffff81134939&gt;] sys_sync+0x2f/0x5c
 [ 1559.661052]  [&lt;ffffffff813857f9&gt;] system_call_fastpath+0x16/0x1b
</pre>
      </blockquote>
      <pre wrap="">
And that is sync waiting for the flusher thread to complete
writeback of all the dirty inodes. The lack of other stall messages
at this time makes it pretty clear that the problem is not
filesystem related - the system is simply writeback IO bound.

The reason, I'd suggest, is that you've chosen the wrong RAID volume
type for your workload. Small random file read and write workloads
like news and mail spoolers are IOPS intensive workloads and do
not play well with RAID5/6. RAID5/6 really only work well for large
files with sequential access patterns - you need to use RAID1/10 for
IOPS intensive workloads because they don't suffer from the RMW
cycle problem that RAID5/6 has for small writes. The iostat output
will help clarify whether this is really the problem or not...</pre>
    </blockquote>
    <br>
    I understand that RAID 10 is better for performance for reads on
    small files sets.<br>
    But with raid 10 we of course loose a lot of disk space compared to
    RAID 6.<br>
    Side note to this we have been running RAID 6 for years now without
    any issues.<br>
    <br>
    In the past we did tune our xfs filesystem with switches like sunit
    and swidth.<br>
    But back then we couldn't see much peformance difference between
    using:<br>
    <br>
    mkfs.xfs -f -L P.01 -l lazy-count=1 -d su=1m,sw=22 /dev/sda<br>
    <br>
    and<br>
    <br>
    mkfs.xfs -f -L P.01 -l lazy-count=1 /dev/sda<br>
    <br>
    xfs_info from a system that shows no problems with an H800
    Controller from dell ( same chipset as the LSI controllers )<br>
    <br>
    Product Name&nbsp;&nbsp;&nbsp; : PERC H800 Adapter<br>
    Serial No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 071002C<br>
    FW Package Build: 12.10.1-0001<br>
    <br>
    sd60:~# xfs_info /dev/sda <br>
    meta-data=/dev/sda&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isize=256&nbsp;&nbsp;&nbsp; agcount=58,
    agsize=268435455 blks<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; attr=2<br>
    data&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=15381037056,
    imaxpct=1<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=0 blks<br>
    naming&nbsp;&nbsp; =version 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; ascii-ci=0<br>
    log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =internal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=521728,
    version=2<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; sunit=0 blks,
    lazy-count=1<br>
    realtime =none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=4096&nbsp;&nbsp; blocks=0, rtextents=0<br>
    <br>
    Where we even have bigger spools:<br>
    <br>
    Adapter 0 -- Virtual Drive Information:<br>
    Virtual Drive: 0 (Target Id: 0)<br>
    Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :p01<br>
    RAID Level&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Primary-6, Secondary-0, RAID Level Qualifier-3<br>
    Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 57.298 TB<br>
    State&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Optimal<br>
    Strip Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 1.0 MB<br>
    Number Of Drives&nbsp;&nbsp;&nbsp; : 23<br>
    Span Depth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 1<br>
    Default Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache
    OK if Bad BBU<br>
    Current Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache
    OK if Bad BBU<br>
    Access Policy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Read/Write<br>
    Disk Cache Policy&nbsp;&nbsp; : Disk's Default<br>
    Encryption Type&nbsp;&nbsp;&nbsp;&nbsp; : None<br>
    Bad Blocks Exist: No<br>
    <br>
    <br>
    <br>
    Aside from the wrong stripe set and write alignments, this still
    should not cause the kernel to crash like this.<br>
    We found that running with a newer driver of LSI it takes a bit
    longer for the kernel to crash but it still does.<br>
    <br>
    <meta charset="utf-8">
    <blockquote cite="mid:20120613011950.GN22848@dastard" type="cite">
      <pre wrap="">

Cheers,

Dave.
</pre>
    </blockquote>
    <br>
    Thanks<br>
    <br>
  </body>
</html>

--------------060208000701040406020909--


--===============8012486331003199709==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8012486331003199709==--

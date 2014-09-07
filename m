Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECF687F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 00:23:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E662AC004
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 22:23:04 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WA88BTSwLx471NBT
	for <xfs@oss.sgi.com>; Sat, 06 Sep 2014 22:23:02 -0700 (PDT)
Message-ID: <540BEBB7.7020306@hardwarefreak.com>
Date: Sun, 07 Sep 2014 00:23:03 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: storage, libaio, or XFS problem?  3.4.26
References: <20140828003226.GO20518@dastard>	<7f9e5aef187b44e899077467aeb0809d@localhost>	<20140828230817.GU20518@dastard>	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>	<20140829235538.GF20518@dastard>	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>	<20140831235749.GH20518@dastard>	<5403E9B9.7040608@hardwarefreak.com>	<20140901234529.GI20518@dastard>	<5405FB19.2020208@hardwarefreak.com>
	<20140902221915.GK20518@dastard>
In-Reply-To: <20140902221915.GK20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/02/2014 05:19 PM, Dave Chinner wrote:
> On Tue, Sep 02, 2014 at 12:15:05PM -0500, stan hoeppner wrote:
>> On 09/01/2014 06:45 PM, Dave Chinner wrote:
>>> On Sun, Aug 31, 2014 at 10:36:25PM -0500, stan hoeppner wrote:
>>>> On 08/31/2014 06:57 PM, Dave Chinner wrote:
>>>>> On Fri, Aug 29, 2014 at 09:55:53PM -0500, Stan Hoeppner wrote:
>>>>>> Have you played with bcache yet?
>>>>>
>>>>> Enough to scare me. So many ways for things to go wrong, no easy way
>>>>> to recover when things go wrong. And that's before I even get to
>>>>> performance warts, like having systems stall completely because
>>>>> there's tens or hundreds of GB of 4k random writes that have to be
>>>>> flushed to slow SATA RAID6 in the cache....
>>>>
>>>> Yikes.  I hadn't yet heard such opinions expressed.  By go wrong I
>>>> assume you mean the btrees or cached sector data getting broken, corrupted?
>>>
>>> bcache is a complex filesystem hidden inside a block device. If
>>> bcache goes AWOL, so does the all the data on your block device.
>>> Need I say more?
>>
>> So it's no different in that regard than the black box implementations
>> such as LSI's CacheCade and various SAN vendor SSD caching
>> implementations.  Or are you saying the bcache code complexity is so
>> much greater that failure is more likely that the vendor implementations?
> 
> No, not the code complexity in particular. It's more that compared
> to vendor SSD caching implementations there's an awful lot less
> testing and validation, and people tend to use random, unreliable
> hardware for cache devices. It's great when it works, but the
> configuration and validation of correct behaviour in error
> conditions falls to the user...

Understood.  I'm seeing the potential need for a future contract with
Kent if we decide to go forward with bcache.  He could advise on a
testing and validation regimen, optimizing for the workload, and
providing code fixes or features to overcome problems.  Attempting to
use something so new as bcache in a 24x7 commercial workload likely
needs author support.

>>> screen is your friend when it comes to keeping remote shells
>>> active as the network comes and goes. VPN drops out, just bring it
>>> back up when you need it and reconnect to the remote screen instance
>>> and it's like you never left....
>>
>> Thanks for this tip.  I'd heard of screen before but never used it.  I
>> will say the man page is a bit intimidating for such an apparently
>> simple tool...
> 
> Yeah, I use about 0.0001% of what screen can do. It could lose most
> of it's functionality and I wouldn't notice or care. tmux is another
> option for this functionality, but I've never used it because I
> found out about screen first...

I'd guess there are many utils out there used in the same way.


I have some more information regarding the AIO issue.  I fired up the
test harness and it ran for 30 hours at 706 MB/s avg write rate, 303
MB/s per LUN, nearly flawlessly, less than 0.01% buffer loss, and avg IO
times were less than 0.5 seconds.  Then the app crashed and I found the
following in dmesg.  I had to "hard reset" the box due to the shrapnel.
 There are no IO errors of any kind leading up to the forced shutdown.
I assume the inode update and streamRT-sa hung task traces are a result
of the forced shutdown, not a cause of it.  In lieu of an xfs_repair
with a version newer than I'm able to install, any ideas what caused the
forced shutdown after 30 hours, given there are no errors preceding it?


Sep  6 06:33:33 Anguish-ssu-1 kernel: [288087.334863] XFS (dm-5):
xfs_do_force_shutdown(0x8) called from line 3732 of file
fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa02009a6
Sep  6 06:33:42 Anguish-ssu-1 kernel: [288096.220920] XFS (dm-5): failed
to update timestamps for inode 0x2ffc9caae
Sep  6 06:33:48 Anguish-ssu-1 kernel: [288102.492641] XFS (dm-5): failed
to update timestamps for inode 0x97b7566dd
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599412] INFO: task
streamRT-sa:14706 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599414] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599416] streamRT-sa     D
ffff883f3c018408     0 14706  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599420]  ffff883e6fc09b28
0000000000000086 0000000000000000 ffff8840666f5180
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599425]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599428]  ffff883e6fc09fd8
ffff883e6fc08000 00000000000122c0 ffff883e6fc08000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599432] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599441]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599443]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599446]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599451]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599454]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599466]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599472]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599476]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599481]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599487]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599493]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599499]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599503]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599505]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599508]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599510]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599513]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599516]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599519]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599521] INFO: task
streamRT-sa:14713 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599523] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599524] streamRT-sa     D
ffff883b4f52ea48     0 14713  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599527]  ffff883e74af9b28
0000000000000086 0000000000000000 ffff884066622140
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599530]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599534]  ffff883e74af9fd8
ffff883e74af8000 00000000000122c0 ffff883e74af8000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599537] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599540]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599542]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599544]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599547]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599549]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599555]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599561]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599563]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599569]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599575]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599580]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599586]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599589]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599591]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599593]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599596]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599598]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599601]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599603]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599605] INFO: task
streamRT-sa:14723 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599607] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599608] streamRT-sa     D
ffff883e754b2b88     0 14723  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599610]  ffff883e6fca3b28
0000000000000086 0000000000000000 ffff8840662521c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599614]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599617]  ffff883e6fca3fd8
ffff883e6fca2000 00000000000122c0 ffff883e6fca2000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599620] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599623]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599625]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599628]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599630]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599632]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599638]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599644]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599646]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599652]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599657]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599663]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599669]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599671]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599674]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599676]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599678]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599681]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599684]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599686]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599688] INFO: task
streamRT-sa:14730 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599689] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599691] streamRT-sa     D
ffff883dc2360388     0 14730  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599693]  ffff883e6fde1b28
0000000000000086 0000000000000000 ffff884066043080
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599696]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599700]  ffff883e6fde1fd8
ffff883e6fde0000 00000000000122c0 ffff883e6fde0000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599703] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599705]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599708]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599710]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599712]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599715]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599720]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599726]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599728]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599734]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599740]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599745]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599751]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599754]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599756]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599758]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599761]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599763]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599766]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599768]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599770] INFO: task
streamRT-sa:14733 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599771] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599773] streamRT-sa     D
ffff883e7555cb08     0 14733  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599775]  ffff883e7389db28
0000000000000086 0000000000000000 ffff88406663a040
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599778]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599782]  ffff883e7389dfd8
ffff883e7389c000 00000000000122c0 ffff883e7389c000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599785] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599787]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599790]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599792]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599794]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599797]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599802]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599808]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599811]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599816]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599822]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599827]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599833]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599836]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599838]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599840]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599843]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599845]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599848]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599850]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599852] INFO: task
streamRT-sa:14736 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599853] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599855] streamRT-sa     D
ffff883e73915448     0 14736  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599857]  ffff883e73bb5b28
0000000000000086 0000000000000000 ffff884066709080
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599860]  000000025600a331
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599864]  ffff883e73bb5fd8
ffff883e73bb4000 00000000000122c0 ffff883e73bb4000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599867] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599870]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599872]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599874]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599877]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599879]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599885]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599890]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599892]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599898]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599904]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599909]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599915]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599918]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599920]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599922]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599925]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599927]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599930]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599932]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599934] INFO: task
streamRT-sa:14738 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599936] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599937] streamRT-sa     D
ffff883f7c605488     0 14738  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599939]  ffff883c4cda7b28
0000000000000086 0000000000000000 ffff8840667bd1c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599943]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599946]  ffff883c4cda7fd8
ffff883c4cda6000 00000000000122c0 ffff883c4cda6000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599949] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599952]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599954]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599956]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599959]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599961]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599967]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599972]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599975]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599980]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599986]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599991]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.599997]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600000]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600002]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600004]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600007]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600009]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600012]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600014]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600016] INFO: task
streamRT-sa:14739 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600018] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600019] streamRT-sa     D
ffff883e75536a08     0 14739  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600021]  ffff883b4f411b28
0000000000000086 0000000000000000 ffff884066739140
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600025]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600028]  ffff883b4f411fd8
ffff883b4f410000 00000000000122c0 ffff883b4f410000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600031] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600034]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600036]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600038]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600041]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600043]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600048]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600054]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600056]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600062]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600068]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600073]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600079]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600082]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600084]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600086]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600089]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600091]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600094]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600096]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600099] INFO: task
streamRT-sa:14768 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600100] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600101] streamRT-sa     D
ffff883b5f120308     0 14768  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600104]  ffff883cca73bb28
0000000000000086 0000000000000000 ffffffff81813020
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600107]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600110]  ffff883cca73bfd8
ffff883cca73a000 00000000000122c0 ffff883cca73a000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600113] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600116]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600118]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600120]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600123]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600125]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600131]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600136]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600139]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600144]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600150]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600156]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600161]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600164]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600166]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600168]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600171]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600173]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600176]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600178]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600180] INFO: task
streamRT-sa:14789 blocked for more than 120 seconds.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600181] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600183] streamRT-sa     D
ffff883cca430b08     0 14789  14051 0x00000004
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600185]  ffff883f3d9c3b28
0000000000000086 0000000000000000 ffff884066739140
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600188]  0000000000000000
0000000000000000 00000000000122c0 00000000000122c0
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600192]  ffff883f3d9c3fd8
ffff883f3d9c2000 00000000000122c0 ffff883f3d9c2000
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600195] Call Trace:
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600197]
[<ffffffff814f5fd7>] schedule+0x64/0x66
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600200]
[<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600202]
[<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600204]
[<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600207]
[<ffffffff814f5458>] ? down_write+0x25/0x27
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600212]
[<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600218]
[<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600220]
[<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600226]
[<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600231]
[<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600237]
[<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600243]
[<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600245]
[<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600248]
[<ffffffff8113360f>] ? aio_fsync+0x29/0x29
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600250]
[<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600252]
[<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600255]
[<ffffffff8113513d>] do_io_submit+0xfa/0x271
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600258]
[<ffffffff811352c4>] sys_io_submit+0x10/0x12
Sep  6 06:35:41 Anguish-ssu-1 kernel: [288215.600260]
[<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
Sep  6 15:42:02 Anguish-ssu-1 kernel: [320925.045195] SysRq : Resetting


Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

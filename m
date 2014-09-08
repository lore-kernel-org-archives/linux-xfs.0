Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B95A97F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 10:13:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55E96AC001
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 08:13:19 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gafaOsOgu5HDzTjH
	for <xfs@oss.sgi.com>; Mon, 08 Sep 2014 08:13:14 -0700 (PDT)
Message-ID: <540DC78C.4010607@hardwarefreak.com>
Date: Mon, 08 Sep 2014 10:13:16 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: storage, libaio, or XFS problem?  3.4.26
References: <20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
	<20140829235538.GF20518@dastard>
	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>
	<20140831235749.GH20518@dastard>
	<5403E9B9.7040608@hardwarefreak.com>
	<20140901234529.GI20518@dastard>
	<5405FB19.2020208@hardwarefreak.com>
	<20140902221915.GK20518@dastard>
	<540BEBB7.7020306@hardwarefreak.com>
	<20140907233910.GA30012@dastard>
In-Reply-To: <20140907233910.GA30012@dastard>
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

On 09/07/2014 06:39 PM, Dave Chinner wrote:
> On Sun, Sep 07, 2014 at 12:23:03AM -0500, stan hoeppner wrote:
>> I have some more information regarding the AIO issue.  I fired up the
>> test harness and it ran for 30 hours at 706 MB/s avg write rate, 303
>> MB/s per LUN, nearly flawlessly, less than 0.01% buffer loss, and avg IO
>> times were less than 0.5 seconds.  Then the app crashed and I found the
>> following in dmesg.  I had to "hard reset" the box due to the shrapnel.
>>  There are no IO errors of any kind leading up to the forced shutdown.
>> I assume the inode update and streamRT-sa hung task traces are a result
>> of the forced shutdown, not a cause of it.  In lieu of an xfs_repair
>> with a version newer than I'm able to install, any ideas what caused the
>> forced shutdown after 30 hours, given there are no errors preceding it?
>>
>>
>> Sep  6 06:33:33 Anguish-ssu-1 kernel: [288087.334863] XFS (dm-5):
>> xfs_do_force_shutdown(0x8) called from line 3732 of file
>> fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa02009a6
>> Sep  6 06:33:42 Anguish-ssu-1 kernel: [288096.220920] XFS (dm-5): failed
>> to update timestamps for inode 0x2ffc9caae
> 
> Hi Stan, can you need to turn off line wrapping for stuff you paste
> in? It's all but unreadable when it line wraps like this?

Sorry.  I switched my daily desktop from Windows/Tbird to Wheezy/Icedove
and I haven't tweaked it out much yet.  I set hard wrap at 72 and that's
the problem.  I'll set flowed format and see if that helps.

> Next, you need to turn /proc/sys/fs/xfs/error_level up to 11 so that
> it dumps a stack trace on corruption events. I don't have a (I can't
> remember what kernel version you are running) tree in front of me to
> convert that line number to something meaningful, so it's not a
> great help...

error_level is now 11 on both systems and will survive reboots.  It's
kernel 3.4.26.

> Was there anything in the logs before the shutdown?  i.e. can you
> paste the dmesg output from the start of the test (i.e. the mount of
> the fs) to the end?

They have this setup in a quasi production/test manner, which is
frustrating.  The two test rigs PXE/tftp boot and mount rootfs on NFS.
Both systems remote log kern.log into to a single file on the boot
server, so I grep for hostname.  dmesg isn't logged remotely, and is
lost after a reboot.  So I don't have the mount entries for some reason.
 It seems kern.log doesn't get populated with all the stuff that goes
into dmesg.  I'll be sure to grab all of dmesg next time before
rebooting.  However, I don't recall any errors of any kind prior to the
shutdown, which in itself is strange.


> As it is, all the traces looke like this:
> 
>> [<ffffffff814f5fd7>] schedule+0x64/0x66
>> [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
>> [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
>> [<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
>> [<ffffffff814f5458>] ? down_write+0x25/0x27
>> [<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
>> [<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
>> [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
>> [<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
>> [<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
>> [<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
>> [<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
>> [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
>> [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
>> [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
>> [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
>> [<ffffffff8113513d>] do_io_submit+0xfa/0x271
>> [<ffffffff811352c4>] sys_io_submit+0x10/0x12
>> [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b
> 
> Which implies that the shutdown didn't unlock the inode correctly.
> But without knowing what the call stack at the time of the shutdown
> was, I can't really tell...

And error_level 11 should give us the call stack, correct?

My current run without AIO should be completing in a few hours.  I have
one more non-AIO run to make after that.  Takes about 6 hours after all
files are populated.  Then I'll start another AIO run and try to get you
the info you need.  May take 30 hours again, might take less than an
hour.  It's not consistent.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 342D829DF8
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 16:25:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89353AC004
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 14:25:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2RYJufbG1WD1TSCN for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 14:25:56 -0800 (PST)
Message-ID: <54D933F3.4090709@sandeen.net>
Date: Mon, 09 Feb 2015 16:25:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS umount with IO errors seems to lead to memory corruption
References: <CAGdUFVbs3kTTAtXjHux5sW-e9j82ouaRN3aEm+-AdVs6NLuJ+g@mail.gmail.com>
	<20150209221829.GX12722@dastard>
In-Reply-To: <20150209221829.GX12722@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Chris Holcombe <xfactor973@gmail.com>
Cc: xfs@oss.sgi.com

On 2/9/15 4:18 PM, Dave Chinner wrote:
> On Mon, Feb 09, 2015 at 01:24:15PM -0800, Chris Holcombe wrote:
>> Hi Dave,
>>
>> http://www.spinics.net/lists/linux-xfs/msg00061.html
>> Back in Dec 2013 you responded to this message saying that you would
>> take a look at it.  Was a fix for this ever issued? 
> 
> Yes, it's been fixed, but that's not you problem.
> 
>> I'm seeing very
>> similar stacktraces:
>>
>>  INFO: task umount:29224 blocked for more than 120 seconds.
>>        Tainted: G        W     3.13.0-39-generic #66-Ubuntu
>>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>  umount D ffff880c4fc34480     0 29224  29221 0x00000082
>>  ffff880201211db0 0000000000000086 ffff880c39cb1800 ffff880201211fd8
>>  0000000000014480 0000000000014480 ffff880c39cb1800 ffff880c33386480
>>  ffff880c395e4bc8 ffff880c333864c0 ffff880c333864e8 ffff880c33386490
>>  Call Trace:
>>
>> [<ffffffff81723109>] schedule+0x29/0x70
>> [<ffffffffa023b0c9>] xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
>> [<ffffffff810aafd0>] ? prepare_to_wait_event+0x100/0x100
>> [<ffffffffa0236f13>] xfs_log_quiesce+0x33/0x70 [xfs]
>> [<ffffffffa0236f62>] xfs_log_unmount+0x12/0x30 [xfs]
>> [<ffffffffa01ed846>] xfs_unmountfs+0xc6/0x150 [xfs]
>> [<ffffffffa01ef211>] xfs_fs_put_super+0x21/0x60 [xfs]
>> [<ffffffff811bf452>] generic_shutdown_super+0x72/0xf0
>> [<ffffffff811bf707>] kill_block_super+0x27/0x70
>> [<ffffffff811bf9ed>] deactivate_locked_super+0x3d/0x60
>> [<ffffffff811bffa6>] deactivate_super+0x46/0x60
>> [<ffffffff811dcd96>] mntput_no_expire+0xd6/0x170
>> [<ffffffff811de31e>] SyS_umount+0x8e/0x100
>> [<ffffffff8172f7ed>] system_call_fastpath+0x1a/0x1f
> 
> That's XFS hung waiting for IO to complete during unmount.
> 
>> These type of errors are showing up in the logs:
>>
>> XFS (dm-8): metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 19 numblks 1
> 
> Error 19 = ENODEV.
> 
> You pulled the drive out before you tried to unmount?
> 
>> XFS (dm-8): Detected failing async write on buffer block 0x0. Retrying async write.
> 
> Which means it's detecting that the write is failing, but the higher
> level has been told to keep trying until all metadata has been
> flushed. We probably need to tweak this slightly....
> 
> Eric - this is another case where transient vs permanent error is
> somewhat squishy, and treating ENODEV as a permanent error would
> solve this issue (i.e. trigger a shutdown). Did you start doing
> anything in this area?

that's (probably) a little more clear, enodev is unlikely to be transparently
resolved.  Even if it comes back, there's no mechanism to see that it came back
with the same name, right? ...

> AFAICT a ENODEV error on Linux is a permanent error because if you
> replug the device it will come back as a different device and the
> ENODEV onteh removed device will still persist. 

yes, right.  :)

> However, I'm not
> sure what dm-multipath ends up doing in this case - it's supposed to
> hide the same devices coming and going, so maybe it won't trigger
> this error at all...



Anyway, I had started a hack of accumulating consecutive failed IOs but didn't
go too far yet, the initial try didn't do what I expected and I haven't gotten
back to iet yet...

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 114527F3F
	for <xfs@oss.sgi.com>; Sat, 20 Sep 2014 14:47:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84549AC001
	for <xfs@oss.sgi.com>; Sat, 20 Sep 2014 12:47:14 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sO74zlAAK8NB8QKA
	for <xfs@oss.sgi.com>; Sat, 20 Sep 2014 12:47:10 -0700 (PDT)
Message-ID: <541DD9C8.3090403@hardwarefreak.com>
Date: Sat, 20 Sep 2014 14:47:20 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: storage, libaio, or XFS problem?  3.4.26
References: <20140828230817.GU20518@dastard>	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>	<20140829235538.GF20518@dastard>	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>	<20140831235749.GH20518@dastard>	<5403E9B9.7040608@hardwarefreak.com>	<20140901234529.GI20518@dastard>	<5405FB19.2020208@hardwarefreak.com>	<20140902221915.GK20518@dastard>	<540BEBB7.7020306@hardwarefreak.com>	<20140907233910.GA30012@dastard>
	<540DC78C.4010607@hardwarefreak.com>
In-Reply-To: <540DC78C.4010607@hardwarefreak.com>
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


On 09/08/2014 10:13 AM, stan hoeppner wrote:
> On 09/07/2014 06:39 PM, Dave Chinner wrote:
>> On Sun, Sep 07, 2014 at 12:23:03AM -0500, stan hoeppner wrote:
>>> I have some more information regarding the AIO issue.  I fired up the
>>> test harness and it ran for 30 hours at 706 MB/s avg write rate, 303
>>> MB/s per LUN, nearly flawlessly, less than 0.01% buffer loss, and avg IO
>>> times were less than 0.5 seconds.  Then the app crashed and I found the
>>> following in dmesg.  I had to "hard reset" the box due to the shrapnel.
>>>  There are no IO errors of any kind leading up to the forced shutdown.
>>> I assume the inode update and streamRT-sa hung task traces are a result
>>> of the forced shutdown, not a cause of it.  In lieu of an xfs_repair
>>> with a version newer than I'm able to install, any ideas what caused the
>>> forced shutdown after 30 hours, given there are no errors preceding it?
>>>
>>>
>>> Sep  6 06:33:33 Anguish-ssu-1 kernel: [288087.334863] XFS (dm-5):
>>> xfs_do_force_shutdown(0x8) called from line 3732 of file
>>> fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa02009a6
>>> Sep  6 06:33:42 Anguish-ssu-1 kernel: [288096.220920] XFS (dm-5): failed
>>> to update timestamps for inode 0x2ffc9caae
>>
>> Hi Stan, can you need to turn off line wrapping for stuff you paste
>> in? It's all but unreadable when it line wraps like this?
> 
> Sorry.  I switched my daily desktop from Windows/Tbird to Wheezy/Icedove
> and I haven't tweaked it out much yet.  I set hard wrap at 72 and that's
> the problem.  I'll set flowed format and see if that helps.
> 
>> Next, you need to turn /proc/sys/fs/xfs/error_level up to 11 so that
>> it dumps a stack trace on corruption events. I don't have a (I can't
>> remember what kernel version you are running) tree in front of me to
>> convert that line number to something meaningful, so it's not a
>> great help...
> 
> error_level is now 11 on both systems and will survive reboots.  It's
> kernel 3.4.26.
> 
>> Was there anything in the logs before the shutdown?  i.e. can you
>> paste the dmesg output from the start of the test (i.e. the mount of
>> the fs) to the end?
> 
> They have this setup in a quasi production/test manner, which is
> frustrating.  The two test rigs PXE/tftp boot and mount rootfs on NFS.
> Both systems remote log kern.log into to a single file on the boot
> server, so I grep for hostname.  dmesg isn't logged remotely, and is
> lost after a reboot.  So I don't have the mount entries for some reason.
>  It seems kern.log doesn't get populated with all the stuff that goes
> into dmesg.  I'll be sure to grab all of dmesg next time before
> rebooting.  However, I don't recall any errors of any kind prior to the
> shutdown, which in itself is strange.

Hi Dave,

Long story short I was able to get 3.12.26 installed and ran the test
harness for 96 hours without problems.  It usually puked within 30 hours
or much sooner.  Just prior to this a new firmware was uploaded to the
controllers--which decreased throughput by ~35% and increased IO latency
by ~25x.  So I'm not sure if the new kernel fixed this problem or if it
was the new controller firmware.  This old firmware (one of about 50
previous binary loads) is planned to be reloaded Monday so we can test
against it with 3.12.26 and hopefully put this AIO issue to rest.

Thanks,
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F2EP70056735 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:14:25 -0600
Received: from omr12.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89C641C50F51
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 18:15:21 -0800 (PST)
Received: from omr12.networksolutionsemail.com
	(omr12.networksolutionsemail.com [205.178.146.62]) by
	cuda.sgi.com with ESMTP id xfZQsFAmMbba71Kr for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 18:15:21 -0800 (PST)
Received: from mail.networksolutionsemail.com (mail.networksolutionsemail.com
	[205.178.146.50])
	by omr12.networksolutionsemail.com (8.13.6/8.13.6) with SMTP id
	o0F2FL1g014725 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 21:15:21 -0500
Message-ID: <4B4FCFBD.3020300@chaven.com>
Date: Thu, 14 Jan 2010 20:15:25 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: XFS data corruption with high I/O even on Areca hardware raid
References: <4B4E6F3F.1090901@chaven.com>
	<20100114022409.GW17483@discord.disaster>
	<4B4FBC3F.6050904@chaven.com>
	<20100115013507.GB28498@discord.disaster>
In-Reply-To: <20100115013507.GB28498@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 01/14/2010 19:35, Dave Chinner wrote:
> There stack traces do - everything is waiting on IO completion to
> occur. The elevator queues are full, the block device is congested
> and lots of XFS code is waiting on IO completion to occur.
>
>    
>> I don't
>> like the abort device commands to arcmsr, still have not heard anything
>> from Areca support for them to look at it.
>>
>> -------------
>> [ 3494.731923] arcmsr6: abort device command of scsi id = 0 lun = 5
>> [ 3511.746966] arcmsr6: abort device command of scsi id = 0 lun = 5
>> [ 3511.746978] arcmsr6: abort device command of scsi id = 0 lun = 7
>> [ 3528.759509] arcmsr6: abort device command of scsi id = 0 lun = 7
>> [ 3528.759520] arcmsr6: abort device command of scsi id = 0 lun = 7
>> [ 3545.782040] arcmsr6: abort device command of scsi id = 0 lun = 7
>> [ 3545.782052] arcmsr6: abort device command of scsi id = 0 lun = 6
>> [ 3562.785862] arcmsr6: abort device command of scsi id = 0 lun = 6
>> [ 3562.785872] arcmsr6: abort device command of scsi id = 0 lun = 6
>> [ 3579.798404] arcmsr6: abort device command of scsi id = 0 lun = 6
>> [ 3579.798410] arcmsr6: abort device command of scsi id = 0 lun = 5
>>      
> Yea, that looks bad - the driver appears to have aborted some IOs
> (no idea why) but probably hasn't handled the error correctly and
> completed the IOs it aborted with an error status (which would cause
> XFS to shut down the filesystem but not freeze like this).  So it
> looks like there is a buggy error handling path in the driver being
> triggered by some kind of hardware problem.
>
> I note that it is the same raid controller that has had problems
> as the last report. It might just be a bad RAID card or SATA cables
> from that RAID card. I'd work out which card it is, replace it
> and the cables and see if that makes the problem go away....
>    

Yeah, actually this IS a new raid card * cables since the last failure 
so don't think (statistically) that it's hardware.   Could be firmware 
or driver.   I've forwarded this over to Areca and hopefully they can 
come up with something.

Right now I'm testing with the raid in write-through mode in hopes that, 
if it doesn't avoid the problem, minimize the effect of it.  Also found 
some references thanks to the above abort messages about lengthening the 
scsi command timeouts which may help when under 'heavy' load.   
(/sys/class/scsi_device/{?}/device/timeout) which looks to default to 30 
seconds on at least my kernel.   I haven't read up in detail yet as to 
the reasons why it is set to 30 or if that was just some arbitrary 
number someone picked, to me it seems long (considering we're talking 
10-13ms for service times generally on a 7200rpm drive but who knows).

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

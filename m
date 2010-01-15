Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F1YFFP054007 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:34:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74EFB1C4891A
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 17:35:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	WWTZalwQN4IpxBGA for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 17:35:11 -0800 (PST)
Date: Fri, 15 Jan 2010 12:35:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS data corruption with high I/O even on Areca hardware raid
Message-ID: <20100115013507.GB28498@discord.disaster>
References: <4B4E6F3F.1090901@chaven.com>
	<20100114022409.GW17483@discord.disaster>
	<4B4FBC3F.6050904@chaven.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4FBC3F.6050904@chaven.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Steve Costaras <stevecs@chaven.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 06:52:15PM -0600, Steve Costaras wrote:
> On 01/13/2010 20:24, Dave Chinner wrote:
>> On Wed, Jan 13, 2010 at 07:11:27PM -0600, Steve Costaras wrote:
>> The fact that the IO subsystem is freezing at 100% elevator queue
>> utilisation points to an IO never completing. This immediately makes
>> me point a finger at either the RAID hardware or the driver - a bug
>> in XFS is highly unlikely to cause this symptom as those stats are
>> generated at layers lower than XFS.
>>
>> Next time you get a freeze, the output of:
>>
>> # echo w>  /proc/sysrq-trigger
>>
>> will tell use what the system is waiting on (i.e. why it is stuck)
>>
>> ...
>
> didn't want this to happen so soon, but another freeze just occured.  I  
> have the output you mentioned above below.   Don't know if this helps  
> pinpoint anything as to where the problem is more accurately. 

There stack traces do - everything is waiting on IO completion to
occur. The elevator queues are full, the block device is congested
and lots of XFS code is waiting on IO completion to occur.

> I don't  
> like the abort device commands to arcmsr, still have not heard anything  
> from Areca support for them to look at it.
>
> -------------
> [ 3494.731923] arcmsr6: abort device command of scsi id = 0 lun = 5
> [ 3511.746966] arcmsr6: abort device command of scsi id = 0 lun = 5
> [ 3511.746978] arcmsr6: abort device command of scsi id = 0 lun = 7
> [ 3528.759509] arcmsr6: abort device command of scsi id = 0 lun = 7
> [ 3528.759520] arcmsr6: abort device command of scsi id = 0 lun = 7
> [ 3545.782040] arcmsr6: abort device command of scsi id = 0 lun = 7
> [ 3545.782052] arcmsr6: abort device command of scsi id = 0 lun = 6
> [ 3562.785862] arcmsr6: abort device command of scsi id = 0 lun = 6
> [ 3562.785872] arcmsr6: abort device command of scsi id = 0 lun = 6
> [ 3579.798404] arcmsr6: abort device command of scsi id = 0 lun = 6
> [ 3579.798410] arcmsr6: abort device command of scsi id = 0 lun = 5

Yea, that looks bad - the driver appears to have aborted some IOs
(no idea why) but probably hasn't handled the error correctly and
completed the IOs it aborted with an error status (which would cause
XFS to shut down the filesystem but not freeze like this).  So it
looks like there is a buggy error handling path in the driver being
triggered by some kind of hardware problem.

I note that it is the same raid controller that has had problems
as the last report. It might just be a bad RAID card or SATA cables
from that RAID card. I'd work out which card it is, replace it
and the cables and see if that makes the problem go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

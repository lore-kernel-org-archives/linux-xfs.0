Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1QH7R2P245947 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 11:07:28 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yUgCivqxzjmiwkmE
	for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 09:07:26 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2DBFF6C0C9
	for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 11:07:26 -0600 (CST)
Message-ID: <4F4A66D1.40300@hardwarefreak.com>
Date: Sun, 26 Feb 2012 11:07:29 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mount: Structure needs cleaning
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com>
In-Reply-To: <33393429.post@talk.nabble.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 2/26/2012 1:22 AM, MikeJeezy wrote:
> 
> 
> On 02/25/2012 10:35pm, Stan Hoeppner wrote:
>> Can you run xfs_check on the filesystem to determine if a freespace
>> tree is corrupted (post the output if it is), then run xfs_repair
>> to rebuild them?"
> 
> Thank you for responding.  This is a 24/7 production server and I did not
> anticipate getting a response this late on a Saturday, so I panicked quite
> frankly, and went ahead and ran "xfs_repair -L" on both volumes.  I can now

I wasn't sure how big a pickle you were in so I jumped in and tried to
help best I could.

> mount the volumes and everything looks okay as far as I can tell.  There
> were only 2 files in the "lost+found" directory after the repair.  Does that
> mean only two files were lost?  Is there any way to tell how many files were
> lost?

I'm not sure.  If this is free space btree corruption then you shouldn't
have lost any user files.  Others might answer this better than me.

>> This corruption could have happened a long time ago in the past, and
>> it may simply be coincidental that you've tripped over this at
>> roughly the same time you upgraded the kernel.

Note the text above is something I quoted from Dave's 2008 response to
another user with the same problem.  In that case he had just upgraded
his kernel and suspected that as the cause.  It was not.

> It would be nice to find out why this happened.  I suspect it is as you
> suggested, previous corruption and not a hardware issue, because I have
> other volumes mounted to other VM's that are attached to the same SAN
> controller / RAID6 Array... and they did not have any issues - only this one
> VM.

Are those other VMs using XFS filesystems?

Found this in the list archive:

On 9/19/2011 9:27 AM, Christoph Hellwig wrote:

> Given that before ~2.6.35 LVM/device mapper was not able to pass through
> cache flush requests that is your most likely culprit.  A repair will
> rebuild the freespace btrees, and make sure to keep the write caches
> down the whole stack disabled.

What kernel version are you running?  Are you using LVM under XFS?  What
fstab mount options?  Does your SAN array have battery backed write
cache?  Are the individual drive caches in the underlying array disabled?

>> So, run "xfs_check /dev/sde1" and post the output here.  Then await
>> further instructions.  
> 
> Can I still do this (or anything) to help uncover any causes or is it too

If you already ran a repair and it fixed the damage then the check won't
show anything.

> late?  I have also run yum update on the server because it was out of date.

Answering the questions above may lead us to a possible/plausible cause.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

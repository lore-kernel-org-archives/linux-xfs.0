Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB913lnA155554 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 19:03:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 289501D6025
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 17:05:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	prTuhfhyJjQTKHG2 for <xfs@oss.sgi.com>;
	Wed, 08 Dec 2010 17:05:34 -0800 (PST)
Date: Thu, 9 Dec 2010 12:05:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs tuning for a 830 GB partition (mkfs.xfs options)
Message-ID: <20101209010531.GE32766@dastard>
References: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
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
To: Abel Coto <whitewolf573@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 08, 2010 at 08:32:28PM +0100, Abel Coto wrote:
> I want to create a 830 GB partition, to mount as /home in my Centos 5.4
> workstation.
> 
> Actually i have /home not mounted ,so i would have to create the new
> partition in the lvm,format it and use rsync to copy /home directory to it.
> 
> for a 830 GB partition that i will use to save my data in general and also
> 3d / CG projects and renders once finished them what agcount value should be
> used. I have read that mkfs default option creates 1 allocation group each
> 4G , so i understand that for a 830 GB partition agcount should be 208.
> 
> It is this correct ?

No, you've read something that is at least 5 years out of date. Just
use the defaults - they are already optimised for best performance
in most circumstances.

> I have read that too much allocation groups are bad , but i don't now if 416
> are  too much for a 830 GB partition (and shoukd use 208 to 300) or not.

Any more than 4 AGs on a single spindle is bad for performance. AGs
can be up to 1TB in size, so you're going to get 4 as the default
for your 830GB partition.

> I will mount the partition with logbufs=8. (i use a 128m journal and
> logbufs=8 to improve a bit deleting performance). I will perhaps use noatime
> too ,but i have to see if my backup app, uses atime or not.

logbufs=8 is the default. Also, the default atime option is relatime
which has pretty much zero compareeed to noatime, so once again just
use the defaults.

> for this partition , that will handle mostly big files (500 MB to 2-3 GB at
> least) what mkfs.xfs options should i use ?

The defaults.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

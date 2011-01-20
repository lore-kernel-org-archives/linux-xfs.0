Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K5F71W028331 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 23:15:07 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0173019F191A
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 21:17:24 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ztyCDbZp63nyNiP1 for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 21:17:24 -0800 (PST)
Date: Thu, 20 Jan 2011 16:17:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS - issues with writes using sync
Message-ID: <20110120051720.GR16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 10:34:30AM +0530, Amit Sahrawat wrote:
> Hi,
> 
> I am facing issues in XFS for a simple test case.
> *Target:* ARM
> *Kernel version:* 2.6.35.9
> 
> *Test case:*
> mkfs.xfs -f /dev/sda2
> mount -t xfs /dev/sda2 /mnt/usb/sda2
> (Run script - trying to fragment the XFS formatted partition)
> #!/bin/sh
> index=0
> while [ "$?" == 0 ]
> do
> index=$((index+1))
> sync
> cp /mnt/usb/sda1/setupfile /mnt/usb/sda2/setupfile.$index
> done
> 
> Partition Size on which files are being created - 1GB(I need to fragment
> this first to run other cases)
> Size of *'setupfile'*  - 16K
> 
> There used be no such issues till *2.6.34*(last XFS version where we tried
> to create setup). There is no reset involved this time, just simple running
> the script caused this issue.

You have a known good version, a known bad version and a
reproducable test case. i.e. everything you need to run a git bisect
and find the commit introduced the regression. Can you do this and
tell us what that commit is?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

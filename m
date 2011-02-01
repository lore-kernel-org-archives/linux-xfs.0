Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11MjFAu248938 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 16:45:15 -0600
Received: from mx-out.facebook.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 455911A618DC
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 14:47:42 -0800 (PST)
Received: from mx-out.facebook.com (outmail017.snc4.facebook.com
	[66.220.144.149]) by cuda.sgi.com with ESMTP id
	2HlR2kGWqoof7tli for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 14:47:42 -0800 (PST)
From: Peter Vajgel <pv@fb.com>
Subject: RE: XFS Preallocation
Date: Tue, 1 Feb 2011 22:47:41 +0000
Message-ID: <3F5ACD12257C714E9C0535D0A839171802AC21@SC-MBX02-2.TheFacebook.com>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
	<20110128045205.GR21311@dastard>
	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
	<20110129001700.GZ21311@dastard>
	<3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>
	<20110201080354.GM11040@dastard>
	<3F5ACD12257C714E9C0535D0A839171802AB01@SC-MBX02-2.TheFacebook.com>
	<4D48691C.8000006@hardwarefreak.com>
In-Reply-To: <4D48691C.8000006@hardwarefreak.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Jef Fox <jef.fox@kinetx.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Correct. But I've been using similar methods for evaluation and benchmarking purposes at my previous employers as well. I guess it's hard to part with the tools you learn to use. It's not a secret that we use xfs at Facebook. Xfs is the filesystem of choice for the media infrastructure group at the moment. Different projects are free to pick anything they want but I think database tier uses xfs as well. Our usage tends to create large files (databases, haystacks) so limited fragmentation, preallocation and as-close-to-raw performance are important features for us - all aspects where xfs excels. When I am talking about multiple variables which affect the testing it's RAID level, RAID stripe size (same stripe size sometimes produces different results from different controller vendors), IO scheduler, memory available, number of threads, readahead size and other external and application tuning variables.

Peter

> -----Original Message-----
> From: Stan Hoeppner [mailto:stan@hardwarefreak.com]
> Sent: Tuesday, February 01, 2011 12:12 PM
> To: Peter Vajgel
> Cc: Dave Chinner; Jef Fox; xfs@oss.sgi.com
> Subject: Re: XFS Preallocation
> 
> Peter Vajgel put forth on 2/1/2011 1:20 PM:
> 
> > At the scale we operate it does. We have multiple variables so the number of
> combinations is large. We have hit every single possible hardware and software
> problem and problem resolution can take months if it takes days to reproduce the
> problem. Hardware vendors (disk, controller, motherboard manufacturers) are much
> more responsive when you can reproduce a problem on the fly in seconds (especially
> in comparative benchmarking). The tests usually run only couple of minutes. With
> 12x3TB (possibly multiplied by a factor of X with our new platform) it would be
> unacceptable to wait for writes to finish.
> 
> Hi Peter,
> 
> When you mention scale, you're referring to the storage back end at facebook.com,
> your employer, correct?
> 
> --
> Stan
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

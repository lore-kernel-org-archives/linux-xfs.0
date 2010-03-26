Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q4XpXt191673 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 23:33:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E4FC1469B41
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 21:35:30 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 25EOf31I8HccyvUy for
	<xfs@oss.sgi.com>; Thu, 25 Mar 2010 21:35:30 -0700 (PDT)
Message-ID: <4BAC3990.30403@sandeen.net>
Date: Thu, 25 Mar 2010 23:35:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 128TB filesystem limit?
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>	<20100325235433.GM3335@dastard>	<alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>	<20100326003511.GN3335@dastard>
	<alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>
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
To: david@lang.hm
Cc: xfs@oss.sgi.com

david@lang.hm wrote:
> On Fri, 26 Mar 2010, Dave Chinner wrote:

...

>> Is there any reason for putting partitions on these block devices?
>> You could just use the block devices without partitions, and that
>> will avoid alignment potential problems....
> 
> I would like to raid to auto-assemble and I can't do that without
> partitions, can I

I think you can.... it's not like MD is putting anything in the partition
table; you just give it block devices, I doubt it cares if it's a whole
disk or some partition.

Worth a check anyway ;)

...


> the next fun thing is figuring out what sort of stride, etc parameters I
> should have used for this filesystem.

mkfs.xfs should suss that out for you automatically based on talking to md;
of course you'd want to configure md to line up well with the hardware
alignment.

-Eric

> David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

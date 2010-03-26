Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q4tDFt193653 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 23:55:13 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A407D1BC6F2B
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 21:56:55 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id qZ4YAEPfDopqxgKD for <xfs@oss.sgi.com>;
	Thu, 25 Mar 2010 21:56:55 -0700 (PDT)
Date: Thu, 25 Mar 2010 21:56:41 -0700 (PDT)
From: david@lang.hm
Subject: Re: 128TB filesystem limit?
In-Reply-To: <4BAC3990.30403@sandeen.net>
Message-ID: <alpine.DEB.2.00.1003252152350.16138@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
	<20100325235433.GM3335@dastard>
	<alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>
	<20100326003511.GN3335@dastard>
	<alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>
	<4BAC3990.30403@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, 25 Mar 2010, Eric Sandeen wrote:

> david@lang.hm wrote:
>> On Fri, 26 Mar 2010, Dave Chinner wrote:
>
> ...
>
>>> Is there any reason for putting partitions on these block devices?
>>> You could just use the block devices without partitions, and that
>>> will avoid alignment potential problems....
>>
>> I would like to raid to auto-assemble and I can't do that without
>> partitions, can I
>
> I think you can.... it's not like MD is putting anything in the partition
> table; you just give it block devices, I doubt it cares if it's a whole
> disk or some partition.
>
> Worth a check anyway ;)

I know that md will work on raw devices, but the auto-assembly stuff looks 
for the right partition type, I would have to maintain a conf file across 
potential system rebuilds if I used the raw partitions.

> ...
>
>
>> the next fun thing is figuring out what sort of stride, etc parameters I
>> should have used for this filesystem.
>
> mkfs.xfs should suss that out for you automatically based on talking to md;
> of course you'd want to configure md to line up well with the hardware
> alignment.

in this case md thinks it's working with 10 12.8TB drives, I really doubt 
that it's going to do the right thing.

I'm not exactly sure what the right thing is in this case. the hardware 
raid is useing 64K chunks across 16 drives (so 14 * 64K worth of data per 
stripe), but there are 10 of these stripes before you get back to hitting 
the same drive again.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

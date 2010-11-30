Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU7L5DZ059476 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 01:21:05 -0600
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F334D1B4CE2
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 23:22:47 -0800 (PST)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id wyyzvdSNUUEdtph1 for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 23:22:47 -0800 (PST)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1082)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20101117074708.GP22876@dastard>
Date: Mon, 29 Nov 2010 23:22:31 -0800
Message-Id: <BA70F631-15CB-4E52-913A-3715CC9678A0@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCD3CE6.8060407@hardwarefreak.com>
	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
	<201011121422.28993@zmi.at>
	<BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
	<20101114110559.GB22876@dastard>
	<87214B07-148B-4580-84F2-792266DE2C55@ucsc.edu>
	<20101116000436.GG22876@dastard>
	<A219F774-E2D5-4CEB-AB2B-399F3053DFF9@ucsc.edu>
	<20101117074708.GP22876@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On Nov 16, 2010, at 11:47 PM, Dave Chinner wrote:

> On Tue, Nov 16, 2010 at 11:29:41PM -0800, Eli Morris wrote:
>> Hi Dave,
>> 
>> Thanks a lot for your help. I looked at the man page and elsewhere for this info and can't find what this means:
>> 
>> 
>> extent: [startoffset..endoffset]: startblock..endblock
>> 
>> 
>> I understand what an offset would be, but what the heck is a startoffset and an endoffset? 
> 
> startoffset: file offset of the start of the extent
> endoffset: file offset of the end of the extent
> 
>> Is the formula for the location of the file:
>> 
>> startoffset + startblock through endoffset + endblock, where the blocks and the offsets are in 512 bytes?
> 
> no.
> 
>> So this file:
>> 
>> 0: [0..1053271]: 5200578944..5201632215
>> 
>> would be contained from:
>> 
>> beginning: 	(0 + 5200578944) * 512 bytes
>> ending:		(1053271 + 5201632215) * 512 bytes
> 
> No, it translates like this:
> 
>    Logical		  Physical
> File Offset (bytes)	block on disk
> -------------------     -------------
>   0 (0..511)		5200578944
>   1 (512..1023)	5200578945
>   2 (1024..1536)	5200578946
> .....			.....
> 1053270			5201632214
> 1053271			5201632215
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Hi Dave,

Thanks for your help with this. I wrote the program and ran it through and it looks like we have we able to preserve 44 TB of valid data, while removing the corrupted files, which is a great result, considering the circumstances. 

Thanks again,

Eli






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

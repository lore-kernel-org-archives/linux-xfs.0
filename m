Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH7je0g204626 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:45:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 520A31C4DB78
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 23:47:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	IJfyHGFctpQHvLlB for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 23:47:11 -0800 (PST)
Date: Wed, 17 Nov 2010 18:47:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair of critical volume
Message-ID: <20101117074708.GP22876@dastard>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCD3CE6.8060407@hardwarefreak.com>
	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
	<201011121422.28993@zmi.at>
	<BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
	<20101114110559.GB22876@dastard>
	<87214B07-148B-4580-84F2-792266DE2C55@ucsc.edu>
	<20101116000436.GG22876@dastard>
	<A219F774-E2D5-4CEB-AB2B-399F3053DFF9@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A219F774-E2D5-4CEB-AB2B-399F3053DFF9@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 11:29:41PM -0800, Eli Morris wrote:
> Hi Dave,
> 
> Thanks a lot for your help. I looked at the man page and elsewhere for this info and can't find what this means:
> 
> 
> extent: [startoffset..endoffset]: startblock..endblock
> 
> 
> I understand what an offset would be, but what the heck is a startoffset and an endoffset? 

startoffset: file offset of the start of the extent
endoffset: file offset of the end of the extent

> Is the formula for the location of the file:
> 
>  startoffset + startblock through endoffset + endblock, where the blocks and the offsets are in 512 bytes?

no.

> So this file:
> 
> 0: [0..1053271]: 5200578944..5201632215
> 
> would be contained from:
> 
> beginning: 	(0 + 5200578944) * 512 bytes
> ending:		(1053271 + 5201632215) * 512 bytes

No, it translates like this:

    Logical		  Physical
File Offset (bytes)	block on disk
-------------------     -------------
   0 (0..511)		5200578944
   1 (512..1023)	5200578945
   2 (1024..1536)	5200578946
 .....			.....
1053270			5201632214
1053271			5201632215

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

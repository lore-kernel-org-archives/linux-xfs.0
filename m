Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13MAIQx163808 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 16:10:19 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id GiDSC34qSTjVyXq8 for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 14:10:17 -0800 (PST)
Date: Fri, 3 Feb 2012 22:10:15 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120203221015.GA2675@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120203115434.GA649@nsrc.org> <4F2C38BE.2010002@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2C38BE.2010002@hardwarefreak.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Feb 03, 2012 at 01:42:54PM -0600, Stan Hoeppner wrote:
> You've hit the peak read rate of these Hitachi drives.  As others
> pointed out, if you need more read performance than the dozen of these
> you plan to RAID stripe, then you'll need to swap them for units with a
> faster spindle:
> 
> 7.2k 	 1.21x
>  10k	 1.68x
>  15k	 2.53x
> 
> or with SSDs, which will yield an order of magnitude increase.  Your
> stated need is 20M 500-800KB files, or 20GB if my math is correct.

Thanks for your suggestion, but unfortunately your maths isn't correct: 20M
x 0.65MB = 13TB.  And that's just one of many possible datasets like this.

I'm aware that I'm working with low-performance drives. This is intentional:
we need low power consumption so we can get lots in a rack, and large
capacity at low cost.

Fortunately our workload will also parallelise easily, and throwing it
across 24 spindles will be fine.  But obviously I want to squeeze the most
performance out of each spindle we have first.  I'm very happy to have found
the bottleneck that was troubling me :-)

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

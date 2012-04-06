Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3619tUH099733 for <xfs@OSS.SGI.com>; Thu, 5 Apr 2012 20:09:55 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id rqr6sTpr2haVUdah for
	<xfs@OSS.SGI.com>; Thu, 05 Apr 2012 18:09:54 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by april.london.02.net (8.5.140)
	id 4F728CFB002FDB2E for xfs@OSS.SGI.com; Fri, 6 Apr 2012 02:09:53 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFxgR-0006rR-SY
	for <xfs@OSS.SGI.com>; Fri, 06 Apr 2012 02:09:47 +0100
MIME-Version: 1.0
Message-ID: <20350.16987.744621.628702@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 02:09:47 +0100
Subject: Re: XFS: Abysmal write performance because of excessive
	seeking (allocation groups to blame?)
In-Reply-To: <20120405213740.GA22824@infradead.org>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> For metadata intensive workloads like yours you would be much
> better using a non-striping raid, e.g. concatentation and
> mirroring instead of raid 5 or raid 6. I know this has a cost
> in terms of "wasted" space, but for IOPs bound workload the
> difference is dramatic.

The problem with parity RAIDs and small-write-IO intensive
workloads is not striping as such, it is with *large* stripes.
That is a detail that matters quite a lot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

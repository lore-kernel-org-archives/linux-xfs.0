Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2U1esYV000512
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 20:40:54 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8373615A40EB
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 18:44:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5AcGzo45H2fILcbi for <linux-xfs@oss.sgi.com>;
	Tue, 29 Mar 2011 18:44:03 -0700 (PDT)
Date: Wed, 30 Mar 2011 12:44:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110330014400.GK3008@dastard>
References: <20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535D@MSXAOA6.twosigma.com>
	<20110330000942.GI3008@dastard>
	<081DDE43F61F3D43929A181B477DCA95639B5364@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B5364@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

On Tue, Mar 29, 2011 at 09:32:06PM -0400, Sean Noonan wrote:
> > Ok, so that looks like root cause of the problem. can you try the
> > patch below to see if it fixes the problem (without any other
> > patches applied or reverted).
> 
> It looks like this does fix the deadlock problem.  However, it
> appears to come at the price of significantly higher mmap startup
> costs.

It shouldn't make any difference to startup costs with the current
code uses read faults to populate the region and that doesn't cause
any allocation to occur and hence this code is not executed during
the populate phase.

Is this repeatable or is it just a one-off result?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

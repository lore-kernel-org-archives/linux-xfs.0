Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EEYllF044698 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 09:34:47 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84BF81D5A757
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 07:37:22 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id rFQ8pr1DiptrEKH0 for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 07:37:22 -0700 (PDT)
Date: Mon, 14 Jun 2010 16:37:20 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100614143720.GI17092@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100614042700.GC6590@dastard>
	<20100614074309.GA17092@basil.fritz.box>
	<20100614133755.GE6590@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614133755.GE6590@dastard>
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
Cc: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> > > function head comment during development.  Anyway, if we do get an
> > > error here, we cannot handle it anyway - it's too late to do
> > > anything short of a complete shutdown as we've already written the
> > > transaction to the log.
> > 
> > Well I guess it should be unconditional BUG_ON then.
> 
> Don't be silly. A filesystem shutdown is all that is necessary,

Without BUG_ON it will not end up in kerneloops.org and you will
never know about it.  That's standard Linux kernel development
practice.

Maybe XFS should catch up on that.

Ok in principle you could make the shutdown a WARN()

Anyways I'm out of this.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

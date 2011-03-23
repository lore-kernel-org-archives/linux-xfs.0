Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NM10qU118563
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 17:01:05 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCE1C159F692
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 15:03:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bIYegvyu23J8uSJ8 for <linux-xfs@oss.sgi.com>;
	Wed, 23 Mar 2011 15:03:49 -0700 (PDT)
Date: Thu, 24 Mar 2011 09:03:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110323220345.GD26611@dastard>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
	<20110322232504.GC15270@dastard>
	<081DDE43F61F3D43929A181B477DCA95639B532C@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B532C@MSXAOA6.twosigma.com>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

On Wed, Mar 23, 2011 at 05:33:36PM -0400, Sean Noonan wrote:
> > What is the configuration of the machine you are testing on? I can't
> > reproduce this on a current 2.6.39-tot tree on a 2p/2GB RAM VM that
> > has it's blockdev images on a single SATA drive....
> 
> The machine we are testing with has 12 cores, 12 hyperthreaded
> siblings, and 48GB of RAM.  The filesystem is backed by a
> partition on one large hardware RAID.  There is a second bug we've
> run into that I'll report tomorrow.

So why would creating a 16GB file cause and OOM condition if you
have 48GB RAM? That doesn't make a whole lot of sense to me. Is
that memory free, of are other things running and consuming memory?

> Could you point me to the current tree you are working with?
> 2.6.39-tot doesn't mean anything to me.

tot = Top of Tree. IOWs, 2.6.39-tot means the latest development
kernel Linus has released.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

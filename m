Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EMMcmr059081 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 17:22:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBE0B12ADAA1
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 15:28:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	1iOBJBqfsx0CqorH for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 15:28:41 -0700 (PDT)
Date: Tue, 15 Jun 2010 08:24:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100614222458.GF6590@dastard>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100614042700.GC6590@dastard>
	<20100614074309.GA17092@basil.fritz.box>
	<20100614133755.GE6590@dastard>
	<20100614143720.GI17092@basil.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614143720.GI17092@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 04:37:20PM +0200, Andi Kleen wrote:
> > > > function head comment during development.  Anyway, if we do get an
> > > > error here, we cannot handle it anyway - it's too late to do
> > > > anything short of a complete shutdown as we've already written the
> > > > transaction to the log.
> > > 
> > > Well I guess it should be unconditional BUG_ON then.
> > 
> > Don't be silly. A filesystem shutdown is all that is necessary,
> 
> Without BUG_ON it will not end up in kerneloops.org and you will
> never know about it. 

We find out about corrupted filesystems all the time from users
sending mail to the list. Even if we did panic by default on
corruption events, kerneloops.org is *useless* for reporting them
because finding out about a corruption is only the very first step
of what is usually a long and involved process that requires user
interaction to gather information necessary to find the cause of the
corruption.

Besides, if we _really_ want the machine to panic on corruption,
then we configure the machine specifically for it via setting the
relevant corruption type bit in /proc/sys/fs/xfs/panic_mask. This is
generally only used when a developer asks a user to set it to get
kernel crash dumps triggered when a corruption event occurs so we
can do remote, offline analysis of the failure.

> That's standard Linux kernel development
> practice.  Maybe XFS should catch up on that.

I find this really amusing because linux filesystems have, over the
last few years, implemented a simpler version of XFS's way of
dealing with corruption events(*). Perhaps you should catch up
with the state of the art before throwing rocks, Andi....

Cheers,

Dave.

(*) extN, fat, hpfs, jfs, nilfs2, ntfs, ocfs2 and logfs all have
configurable corruption event behaviour that default to remount-ro
and can be configured to panic the machine.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

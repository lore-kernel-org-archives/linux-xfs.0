Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F70Ckj076943 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 02:00:13 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DAC2AE9983
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:06:18 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id Nx5tm8erIeRlJbjq for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:06:18 -0700 (PDT)
Date: Tue, 15 Jun 2010 09:02:45 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100615070244.GD6727@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100614042700.GC6590@dastard>
	<20100614074309.GA17092@basil.fritz.box>
	<20100614133755.GE6590@dastard>
	<20100614143720.GI17092@basil.fritz.box>
	<20100614222458.GF6590@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614222458.GF6590@dastard>
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

> We find out about corrupted filesystems all the time from users
> sending mail to the list. Even if we did panic by default on
> corruption events, kerneloops.org is *useless* for reporting them
> because finding out about a corruption is only the very first step
> of what is usually a long and involved process that requires user
> interaction to gather information necessary to find the cause of the
> corruption.

The idea behind kerneloops.org 
is normally that any single report can be always a flake
(broken memory, hardware, flipped bit whatever).

An error becomes important and interesting when there are multiple
occurrences of it in the field.
> 
> Besides, if we _really_ want the machine to panic on corruption,

BUG_ON is not panic normally.

> then we configure the machine specifically for it via setting the
> relevant corruption type bit in /proc/sys/fs/xfs/panic_mask. This is
> generally only used when a developer asks a user to set it to get
> kernel crash dumps triggered when a corruption event occurs so we
> can do remote, offline analysis of the failure.

Especially when you're talking about desktop class systems
without ECC memory that will mean you'll spend at least some
time on errors which are simply bit flips.

> > That's standard Linux kernel development
> > practice.  Maybe XFS should catch up on that.
> 
> I find this really amusing because linux filesystems have, over the

This has really nothing to do with file systems, it's general
practice for everything (well except XFS) 

> last few years, implemented a simpler version of XFS's way of
> dealing with corruption events(*). Perhaps you should catch up
> with the state of the art before throwing rocks, Andi....

I suspect you miss quite a lot of valuable information from
your user base by not supporting kerneloops.org. On the other
hand it would likely also save you from spending time on 
flakes.

That said you don't need BUG_ON to support it (WARN etc. work
too), it's just the easiest way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

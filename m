Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Aug 2006 16:16:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7NNFNDW014352
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 16:15:34 -0700
Date: Thu, 24 Aug 2006 09:14:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Infinite loop in xfssyncd on full file system
Message-ID: <20060823231429.GF807872@melbourne.sgi.com>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal> <20060823040218.GC807872@melbourne.sgi.com> <20060823044829.GD807872@melbourne.sgi.com> <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal> <1156360259.5368.7.camel@localhost> <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal> <20060823040218.GC807872@melbourne.sgi.com> <20060823044829.GD807872@melbourne.sgi.com> <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1156360259.5368.7.camel@localhost> <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>, Luciano Chavez <lnx1138@us.ibm.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Aug 23, 2006 at 11:00:43AM -0400, Stephane Doyon wrote:
> On Wed, 23 Aug 2006, David Chinner wrote:
> 
> >On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
> >>On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
> >>>I'm seeing what appears to be an infinite loop in xfssyncd. It is
> >>>triggered when writing to a file system that is full or nearly full. I
> >>>have pinpointed the change that introduced this problem: it's
> >>>
> >>>    "TAKE 947395 - Fixing potential deadlock in space allocation and
> >>>    freeing due to ENOSPC"
> >>>
> >>>git commit d210a28cd851082cec9b282443f8cc0e6fc09830.

.....

> >>Now we know what patch introduces the problem, we know where to look.
> >>Stay tuned...
> >
> >I've had a quick look at the above commit. I'm not yet certain that
> >everything is correct in terms of the semantics laid down in the
> >change or that enough blocks are reserved for btree splits , but I
> 
> I actually tried, naively, to bump up SET_ASIDE_BLOCKS from 8 to 32. I 
> won't claim to understand half of what's going on but I wondered whether 
> that might make the problem noticeably harder to reproduce at least, but 
> it had no effect ;-).

That was going to be my next question. ;)

At least that rules out a small error in the block reservation decision,
so I'm going to have  analyse all the code paths the mod introduced
and work out what is going wrong.

> >Stephane/Luciano - can you test the following patch (note: compile
> >tested only) and see if it fixes the problem?
> 
> I just tried it, unfortunately no effect. Stil went into a loop, on the 
> second attempt.

On Wed, Aug 23, 2006 at 02:10:59PM -0500, Luciano Chavez wrote:
> 
> Yes, unfortunetly it had no effect here either.

Thanks for trying. I'll get back to you both when I have something new
to report.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

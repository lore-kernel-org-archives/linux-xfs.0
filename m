Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35DD67F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 17:32:07 -0600 (CST)
Date: Wed, 30 Jan 2013 17:32:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
Message-ID: <20130130233203.GP27055@sgi.com>
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
	<20130130010430.GE7255@disturbed.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130130010430.GE7255@disturbed.disaster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: rjohnston@sgi.com, xfs@oss.sgi.com

Hey Dave,

On Wed, Jan 30, 2013 at 12:04:30PM +1100, Dave Chinner wrote:
> On Tue, Jan 29, 2013 at 09:39:15AM -0600, rjohnston@sgi.com wrote:
> > The agskip mount option specifies  the allocation group, (AG) for a new
> > file, relative to the start of the last created file. agskip has the
> > opposite effect of the rotorstep  system tunable  parameter.   Each
> > new  file  to  be placed in the location lastAG + agskipValue,
> > where lastAG is the allocation group of the last created file.
> > 
> > For example, agskip=3 means each new file will be  allocated  three  AGs  away
> > from the starting AG of the most recently created file.
>
> Overall, I'm wondering if this is the right way to approach this
> problem.

We'll have to make sure we all understand the problem we're trying to solve
with this before going too far.

> It only really works correctly (in terms of distribution of
> files/metadata) for fixed volume sizes (i.e. homogenous layouts) -
> the common case where a skip is useful is after growing a filesystem
> onto a new volume. It's rare that the new volume is the same as the
> existing volumes, so it's hard to set a skip value that reliably
> alternates between old and new volumes.

Based upon what I've read so far on the internal bug when this was introduced,
this is more about being able to utilize all allocation groups in a filesystem
with many concats.  It's not so much related to balance after growing a
filesystem (which is another interesting problem).  The info should be added to
this series and be reposted.

> We talked about this allocation distribution problem last march when
> we met at LSF, and I thought we agreed that pushing
> agskip/agrotorstep mount options upstream was not the way we were
> going to solve this problem after I outlined how I planned to solve
> this problem.

If we can come up with something better, that's great.  But AFAICT the problem
still needs to be addressed.  This is just one way to do it.

> Indeed, I already have prototype patches for the AG control ioctls
> that allow the xfs_spaceman program that associate an AG with an
> "allocation zone" (an "AZ") and partially written kernel
> patches that implement AZs, per-AZ agi/agf rotors and higher level AZ
> iteration in the allocator.
> 
> (It also allows specification of per-AZ stripe unit/stripe width and
> other allocation control parameters but those details are little
> outside the scope of this particular discussion.)

Cool.

> IOWs, I'm close to having a significantly more capable and flexible
> solution to this problem that doesn't require new mount options to
> be added or on-disk format changes to be made. As such, I'm not sure
> that we want to introduce a mount option that is only a partial
> solution to the problem. We basically can't remove mount options
> once they have been added, so introducing a new mount option just to
> mark it deprecated in 6 months time seems like a bad idea....

I'm looking forward to seeing it.  ;)

In the meantime we'll get a conversation started as to how to resolve this
particular problem.... once we have a better understanding of it.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

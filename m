Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p03NNC7f140923 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 17:23:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B5D01D07E73
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 15:25:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	OraZSgUcXIRaCLUD for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 15:25:18 -0800 (PST)
Date: Tue, 4 Jan 2011 10:25:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110103232514.GF15179@dastard>
References: <20101125112304.GA4195@infradead.org>
	<20101223014409.GL4907@dastard>
	<20101230114129.GA4321@infradead.org>
	<alpine.LFD.2.00.1101031152101.2815@dhcp-lab-213.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101031152101.2815@dhcp-lab-213.englab.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 03, 2011 at 11:57:23AM +0100, Lukas Czerner wrote:
> On Thu, 30 Dec 2010, Christoph Hellwig wrote:
> 
> > On Thu, Dec 23, 2010 at 12:44:09PM +1100, Dave Chinner wrote:
> > > Hmmmm - if we are given a range to trim, wouldn't we do better to
> > > walk the by-bno btree instead?  i.e, we have two different cases
> > > here - trim an entire AG, and trim part of an AG given by {start, end}. 
> > > 
> > > We only need these range checks on the AGs that are only partially
> > > trimmed, and it would seem more efficient to me to walk the by-bno
> > > tree for those rather than walk the by-size tree trying to find
> > > range matches.
> > 
> > It might be, but I'm not sure it's really worth the complexity.  I can't
> > really find any good use case for a partially trim anyway.
> > 
> > Ccing Lukas to figure out what his intent with this was.
> 
> Hi, I assume that you're talking about situation, when you call FITRIM
> with start and len not covering the whole filesystem possibly resulting
> in trimming just a part of the AG ? In this case I just copy my answer
> from previous mail...

Yes.

> I had two reasons to do this as it is, but only one is really worth it.
> Since we want to run FITRIM from the userspace on the background, we want
> to disturb other IO as little as possible and whole filesystem trim can
> take minutes on some devices (not talking about LUNs which is even more
> painful).

Right - it's the high end we have to worry about for XFS: how long do you
expect a 100TB filesystem to take to TRIM? ;)

>
> So you'll probably agree that we do not want to have possibly
> minute long stalls when doing FITRIM. And presumably we do not want the
> users to care about the size of AG, nor the blocksize (preferably).

The issue is that an AG can cover 1TB of disk space, and locking it
for the entire time it takes to trim the free space will cause
IO disturbances. Even holding the AGF locked for a few seconds
can cause problems.

So I guess the question is what sort of ranged woul dwe be expecting
to see a userspace background trim daemon be using?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

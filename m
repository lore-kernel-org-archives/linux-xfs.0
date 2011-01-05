Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05AJNmk146358 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 04:19:24 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4360BFA47DB
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 02:21:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HvGlkVP7Kezq5Z6F for
	<xfs@oss.sgi.com>; Wed, 05 Jan 2011 02:21:32 -0800 (PST)
Date: Wed, 5 Jan 2011 11:21:17 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: xfs: add FITRIM support
In-Reply-To: <20110103232514.GF15179@dastard>
Message-ID: <alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
References: <20101125112304.GA4195@infradead.org>
	<20101223014409.GL4907@dastard>
	<20101230114129.GA4321@infradead.org>
	<alpine.LFD.2.00.1101031152101.2815@dhcp-lab-213.englab.brq.redhat.com>
	<20110103232514.GF15179@dastard>
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Tue, 4 Jan 2011, Dave Chinner wrote:

> On Mon, Jan 03, 2011 at 11:57:23AM +0100, Lukas Czerner wrote:
> > On Thu, 30 Dec 2010, Christoph Hellwig wrote:
> > 
> > > On Thu, Dec 23, 2010 at 12:44:09PM +1100, Dave Chinner wrote:
> > > > Hmmmm - if we are given a range to trim, wouldn't we do better to
> > > > walk the by-bno btree instead?  i.e, we have two different cases
> > > > here - trim an entire AG, and trim part of an AG given by {start, end}. 
> > > > 
> > > > We only need these range checks on the AGs that are only partially
> > > > trimmed, and it would seem more efficient to me to walk the by-bno
> > > > tree for those rather than walk the by-size tree trying to find
> > > > range matches.
> > > 
> > > It might be, but I'm not sure it's really worth the complexity.  I can't
> > > really find any good use case for a partially trim anyway.
> > > 
> > > Ccing Lukas to figure out what his intent with this was.
> > 
> > Hi, I assume that you're talking about situation, when you call FITRIM
> > with start and len not covering the whole filesystem possibly resulting
> > in trimming just a part of the AG ? In this case I just copy my answer
> > from previous mail...
> 
> Yes.
> 
> > I had two reasons to do this as it is, but only one is really worth it.
> > Since we want to run FITRIM from the userspace on the background, we want
> > to disturb other IO as little as possible and whole filesystem trim can
> > take minutes on some devices (not talking about LUNs which is even more
> > painful).
> 
> Right - it's the high end we have to worry about for XFS: how long do you
> expect a 100TB filesystem to take to TRIM? ;)

Presumably a really long time, but it really differs from device to
device.

> 
> >
> > So you'll probably agree that we do not want to have possibly
> > minute long stalls when doing FITRIM. And presumably we do not want the
> > users to care about the size of AG, nor the blocksize (preferably).
> 
> The issue is that an AG can cover 1TB of disk space, and locking it
> for the entire time it takes to trim the free space will cause
> IO disturbances. Even holding the AGF locked for a few seconds
> can cause problems.
> 
> So I guess the question is what sort of ranged woul dwe be expecting
> to see a userspace background trim daemon be using?

Well, I think that doing 1TB trim is not very good idea even if AG is
not 1TB big. So doing smaller chunks is probably what userspace daemon
need to do.

Also note that we do not exactly need to do trim all the time. If we
notice that we are running out of space in advance (how much in advance?),
we can start trimming smaller chunks, until we reach reasonable a
reasonable pool of reclaimed space, or until we trim the whole device.

OR, the daemon can watch IO load and when it is low (presumably
at night) it can trim the device (possibly with very small cadence) as
some kind of precaution measure.

The fact is, I am not very familiar with various server IO loads and
typical usage of huge storages, so someone who is, can help us to create
heuristic for trim daemon.

Also I think it is a good idea to something like:

	if (need_resched()) {
		unlock()
		cond_resched();
		lock()
	}

while trimming free chunks in the AG.

-Lukas


> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

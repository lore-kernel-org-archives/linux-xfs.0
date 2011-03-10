Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AM6uNc124709 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 16:07:02 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3B97304084
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 14:09:42 -0800 (PST)
Subject: Re: [PATCH 2/2] xfstests: some refinements on "make depend"
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110310172644.GC13390@infradead.org>
References: <201103041937.p24Jbfh5004820@stout.americas.sgi.com>
	<20110310172644.GC13390@infradead.org>
Date: Thu, 10 Mar 2011 16:09:36 -0600
Message-ID: <1299794976.2573.72.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-03-10 at 12:26 -0500, Christoph Hellwig wrote:
> On Fri, Mar 04, 2011 at 01:37:41PM -0600, Alex Elder wrote:
> > Make it so "make depend" is a generic target, like "make clean".
> > 
> > Each Makefile has a "depend" target that indicates whether making
> > dependencies means creating ".dep" or creating ".ltdep" (or, I
> > suppose, both, though none do that right now).  Both files get
> > created even if there are no CFILES to scan (to ensure the target
> > up-to-date).  The "default" target now depends on "depend" (there is
> > no "ltdepend" any more).
> > 
> > Remove the "depend" and "ltdepend" definitions from the "buildrules"
> > file; only the actual generated files (".dep" and ".ltdep") remain
> > as generic targets.  The "depend' target is still defined as phony.
> >  
> > Do a shell trick when expanding the value of CFILES, to avoid a
> > problem that occurs if it is created by "make" by concatentating two
> > empty strings.  The problem was that in that case CFILES will
> > contain a space, and that wasn't getting treated as empty as
> > desired.
> > 
> > Make the rule for tool/lib dependencies more generic, to reflect the
> > general desire that "lib" subdirectories need to be built before
> > things in the "tool" subdirectories.
> 
> Can we instead port over the generic dependency generation from
> xfsprogs/xfsdump?

My intention was to work toward unifying all the user space
stuff, basically in line with what you suggest.

This is part of a flurry of changes related to the xfstests
dmapi subtree.  One of the things I needed to do was populate
a set of new Makefiles there, and I guess in looking into
that I found I didn't like the way the dependencies were done,
and the changes I made to address that ended up in this patch.

I'll hold off on this patch and will reconsider it once
I get the more substantive dmapi changes in.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

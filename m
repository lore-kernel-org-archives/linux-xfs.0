Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D40C7F37
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 01:05:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D5DA304051
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 23:05:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WVBk3YQl9opY8180 for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 23:05:23 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1VrMoA-0003wy-U0
	for xfs@oss.sgi.com; Fri, 13 Dec 2013 18:05:10 +1100
Date: Fri, 13 Dec 2013 18:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFD] XFS documentation project
Message-ID: <20131213070510.GR10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi folks,

Documentation. Yeah, that bug-bear. Never up to date, never contains
the right stuff, spread all over the place, in nasty formats that
are hard to maintain, blah, blah, blah.

We've got some stuff in publican format in a repo on kernel.org
(http://git.kernel.org/cgit/fs/xfs/xfsdocs-xml-dev.git/), there's
stuff on the wiki at xfs.org (e.g. the XFS FAQ), on oss.sgi.com.
there's man pages in  xfsprogs, Documentation/filesystems/xfs* in
the kernel tree, and there's random user and admin guides written by
SGI, RH, SuSE, and so on.

They are all in different formats, under different licenses, and
contain a heap of information that is either duplicated,
conflicting, out of date, no longer relevant or just plain wrong.

We don't have somewhere we we can record all the information that
comes out of mailing list discussions - we're not capturing useful
information about optimal setups for given workloads, when you
should some feature, etc, and that's a loss for everyone.

What knowledge we do have is mostly tied up in documents that are
hard to modify, share or use as the basis for other documentation.
And there is a huge amount of knowledge that is tied up in our
heads that isn't documented anywhere.

That's what I'd like to capture via an "upstream" XFS documentation
project. What I envisiage is that we end up with with a repository
that users, developers and tech writers contribute changes to, then
distros pull the result back down, trim and "skin" it for their
distro documentation.

I'd like to see if we can get a project underway to acheive
this goal. The documentation I'm thinking of includes administration
guides, filesystem capabilities, strengths, weaknesses, best
practices, optimisation techniques, triage and fault analysis,
on-disk format specification, developer guides, education material,
etc.

I'm not thinking small here - we already have these things in
various levels of detail spread all over the place. However, I'm not
a documentation expert, so I'm kind of fishing around for ideas and
ways to work towards this goal.  I know what problems I'd like to
solve and what outcomes I'd like see, but how to get there is
something we need help to plan and implement.

IOWs, this is an undertaking that I can not do alone, so consider
this a call for help. Anyone willing to put their hat in the ring,
or know someone who might be able to help?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

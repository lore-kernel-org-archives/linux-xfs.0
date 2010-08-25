Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7P19xwj209501 for <xfs@oss.sgi.com>; Tue, 24 Aug 2010 20:10:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D24511E52792
	for <xfs@oss.sgi.com>; Tue, 24 Aug 2010 18:10:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	w0nfNnBRw7kBLbdq for <xfs@oss.sgi.com>;
	Tue, 24 Aug 2010 18:10:32 -0700 (PDT)
Date: Wed, 25 Aug 2010 11:10:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT Review] xfs: 2.6.36 fixes
Message-ID: <20100825011028.GL31488@dastard>
References: <20100824024445.GJ31488@dastard> <1282690498.1885.74.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282690498.1885.74.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 24, 2010 at 05:54:58PM -0500, Alex Elder wrote:
> On Tue, 2010-08-24 at 12:44 +1000, Dave Chinner wrote:
> > Folks,
> > 
> > Can you please cast an eye over the the tree below to check that all
> > the bug fixes that need to go into 2.6.36 are there? If so, I'll
> > send a pull request to Linus tomorrow.
> > 
> > Note that these are just the outstanding bug fixes that have been
> > reviewed (as Linus has again decreed for pull requests after -rc1),
> > so it not the complete set of reviewd patches that exist.
> > 
> > Cheers,
> > 
> > Dave.
> 
> All of these commits look good to me.  I will have these
> and all the rest published on the oss.sgi.com tree later
> this week.  I've been on vacation and have gotten behind.

I'm going to send the pull to Linus, anyway, Alex.

The problem is deeper than "been on vacation" - regardless of
whether you are on vacation we can't rely on you to do anything
immediately. It might be code review, triage community reported
bugs, pulling patches into the OSS tree or sending stuff to Linus,
but it's always a week or two later than it needs to be. This is
not a new problem, either.

Just on the git aspect of this problem, I haven't been using the git
tree on oss.sgi.com now for a couple of months - instead I'm working
from a mainline tree and using topic branches and local merges to
manange separate patch sets. Having to work with a slow-to-update XFS
tree is actually quite painful, and most of that pain goes away it I
just drop the OSS tree out of the loop completely.

For example, the last pull request I sent to Linus was for the
radix-tree branch containing writeback regression fixes. Linus
merged that branch into mainline within ten minutes of me sending
the pull request.

If I contrast that to getting the same patches to Linus via the oss
tree - I'd still be waiting for you to get them into the OSS tree
and all I know is that it would be "later this week". It's just
easier to send stuff that is ready straight to Linus.  Given that
I'm already doing all the git tree work to integrate, tag and test
all the XFS patches coming in on the mailing list, adding an extra
tree hop with an unknown latency to get the commits to Linus is
distinctly sub-optimal.

So, give me some good reasons why I should continue to send XFS
kernel code through the SGI controlled tree on oss.sgi.com rather
than directly to Linus.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

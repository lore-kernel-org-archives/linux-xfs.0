Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 07:30:48 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5TEUgtL004487
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 07:30:43 -0700
Date: Fri, 29 Jun 2007 09:56:12 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070629135612.GH29279@thunk.org>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Thu, Jun 28, 2007 at 11:33:42AM -0700, Andrew Morton wrote:
> > Please let us know what you think of Mingming's suggestion of posting
> > all the fallocate patches including the ext4 ones as incremental ones
> > against the -mm.
> 
> I think Mingming was asking that Ted move the current quilt tree into git,
> presumably because she's working off git.

No, mingming and I both work off of the patch queue (which is also
stored in git).  So what mingming was asking for exactly was just
posting the incremental patches and tagging them appropriately to
avoid confusion.

I tried building the patch queue earlier in the week and it there were
multiple oops/panics as I ran things through various regression tests,
but that may have been fixed since (the tree was broken over the
weekend and I may have grabbed a broken patch series) or it may have
been a screw up on my part feeding them into our testing grid.  I
haven't had time to try again this week, but I'll try to put together
a new tested ext4 patchset over the weekend.

> I'm not sure what to do, really.  The core kernel patches need to be in
> Ted's tree for testing but that'll create a mess for me.

I don't think we have a problem here.  What we have now is fine, and
it was just people kvetching that Amit reposted patches that were
already in -mm and ext4.

In any case, the plan is to push all of the core bits into Linus tree
for 2.6.22 once it opens up, which should be Real Soon Now, it looks
like.

						- Ted

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SBGgcC246816 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 06:16:42 -0500
Date: Wed, 28 Jul 2010 07:19:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Master Branch Rebase
Message-ID: <20100728111946.GA10824@infradead.org>
References: <1280247366.2002.111.camel@doink> <20100727232719.GR7362@dastard>
	<20100728084400.GA9516@infradead.org>
	<20100728110954.GG655@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100728110954.GG655@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 28, 2010 at 09:09:54PM +1000, Dave Chinner wrote:
> If you call a single merge of 2.6.35-rc6 back into the for-2.6.36
> branch a "merge mess", then I'm guilty as charged.  However (and it
> is a *BIG* however),

It wasn't that simple.  We had a few unclean merges from mainline and
from for-linux to for-2.6.36 or similar branches.

> I haven't asked Alex to pull from that tree
> and upstream should not be pulling from downstream trees without a
> specific request to do so.
> 
> I'm maintaining that whole tree for _my_ benefit - I need a
> mainline-based tree that also contains all the non-mainline XFS
> commits, and I need to be able to update them independently.  Just
> because the tree contains a branch named "for-2.6.36" and has XFS
> commits that are not yet upstream doesn't mean the branch is a
> upstream pull target.

Yeah.  The normal way to maintain a development branch is to stay
is to never pull in mainline into an existing branch.  If we absolutely
need to update to a newer version from Linus' tree it should be rebased
ontop of it.  Unfortunately we'll need to do this once in a while
for something like XFS which has rather complex interactions with core
VM and VFS changes, so expecting the xfs development branch to be
a stable target is not generally a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

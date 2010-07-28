Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SGFabV259804 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 11:15:36 -0500
Subject: Re: XFS Master Branch Rebase
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100728110954.GG655@dastard>
References: <1280247366.2002.111.camel@doink>
	<20100727232719.GR7362@dastard> <20100728084400.GA9516@infradead.org>
	<20100728110954.GG655@dastard>
Date: Wed, 28 Jul 2010 11:18:34 -0500
Message-ID: <1280333914.2238.185.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 2010-07-28 at 21:09 +1000, Dave Chinner wrote:
> On Wed, Jul 28, 2010 at 04:44:00AM -0400, Christoph Hellwig wrote:
> > On Wed, Jul 28, 2010 at 09:27:19AM +1000, Dave Chinner wrote:
> > > Alex, this is a bit annoying. Rebases are a real pain for anyone
> > > downstream that is using git in non-trivial ways.
> > 
> > FYI: I asked Alex to do it, so I'll happily take all the blaim here.
> 
> No blame - just pointing out the consequences (again).
> 
> > The real problem is that we had quite a merge mess before, which Linus
> > absolutely doesn't like.  And if I traced it back correctly most of
> > it actually came from the xfsdev tree.
> 
> If you call a single merge of 2.6.35-rc6 back into the for-2.6.36
> branch a "merge mess", then I'm guilty as charged.  However (and it
> is a *BIG* however), I haven't asked Alex to pull from that tree
> and upstream should not be pulling from downstream trees without a
> specific request to do so.

I trusted Christoph's judgement about whether it was a "mess"
or not.  He suggested the re-base, and I agreed to do it.

> I'm maintaining that whole tree for _my_ benefit - I need a
> mainline-based tree that also contains all the non-mainline XFS
> commits, and I need to be able to update them independently.  Just
> because the tree contains a branch named "for-2.6.36" and has XFS
> commits that are not yet upstream doesn't mean the branch is a
> upstream pull target.
> 
> Alex, if you want to pull from my tree rather that commit all the
> patches to the main XFS tree yourself, tell me so I can cherry-pick
> the commits into a clean, pristine branch and send a pull request.
> That way this whole problem just goes away...

Ironically, one of the reasons I wanted to pull from your branch was
to avoid any chance of being in conflict with any of the work you
had already done.  In any case, before I did so, I reached you on
IRC, and there you said that if I had in my branch "already merged
in 2.6.36-rc6, then the for-2.6.36 branch in my tree should just
pull right in...."  I took that as at least a consent to pull
from that branch (which I did).

I normally take in all patches from mail (or patchwork).  You
seem to want me to do things differently--to wait until you
have committed it to your git tree and then requested I pull
it.  All that's fine, but in some cases I've felt like there
was some ambiguity.  Regardless, I won't pull from your tree
unless I have communicated with you about it.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

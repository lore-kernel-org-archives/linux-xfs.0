Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SB6rHA246303 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 06:06:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED9F04792DC
	for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 04:09:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	vhTpBBEvZL90bGIQ for <xfs@oss.sgi.com>;
	Wed, 28 Jul 2010 04:09:57 -0700 (PDT)
Date: Wed, 28 Jul 2010 21:09:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Master Branch Rebase
Message-ID: <20100728110954.GG655@dastard>
References: <1280247366.2002.111.camel@doink> <20100727232719.GR7362@dastard>
	<20100728084400.GA9516@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100728084400.GA9516@infradead.org>
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
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 28, 2010 at 04:44:00AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 28, 2010 at 09:27:19AM +1000, Dave Chinner wrote:
> > Alex, this is a bit annoying. Rebases are a real pain for anyone
> > downstream that is using git in non-trivial ways.
> 
> FYI: I asked Alex to do it, so I'll happily take all the blaim here.

No blame - just pointing out the consequences (again).

> The real problem is that we had quite a merge mess before, which Linus
> absolutely doesn't like.  And if I traced it back correctly most of
> it actually came from the xfsdev tree.

If you call a single merge of 2.6.35-rc6 back into the for-2.6.36
branch a "merge mess", then I'm guilty as charged.  However (and it
is a *BIG* however), I haven't asked Alex to pull from that tree
and upstream should not be pulling from downstream trees without a
specific request to do so.

I'm maintaining that whole tree for _my_ benefit - I need a
mainline-based tree that also contains all the non-mainline XFS
commits, and I need to be able to update them independently.  Just
because the tree contains a branch named "for-2.6.36" and has XFS
commits that are not yet upstream doesn't mean the branch is a
upstream pull target.

Alex, if you want to pull from my tree rather that commit all the
patches to the main XFS tree yourself, tell me so I can cherry-pick
the commits into a clean, pristine branch and send a pull request.
That way this whole problem just goes away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

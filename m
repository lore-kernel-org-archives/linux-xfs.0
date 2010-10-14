Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ELRjOc074804 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 16:27:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7357151438A
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 14:43:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	CRk9gpxsCeYqkAkr for <xfs@oss.sgi.com>;
	Thu, 14 Oct 2010 14:43:23 -0700 (PDT)
Date: Fri, 15 Oct 2010 08:28:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101014212841.GE4681@dastard>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1286187236-16682-3-git-send-email-david@fromorbit.com>
	<1287076970.2362.521.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287076970.2362.521.camel@doink>
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

On Thu, Oct 14, 2010 at 12:22:50PM -0500, Alex Elder wrote:
> On Mon, 2010-10-04 at 21:13 +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index b7bdc43..0c8eeba 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> 
> OK, this comment is unrelated to your exact change.  But just above
> the next hunk there's a big nasty condition, which appears to
> be *almost* duplicated in xfs_inactive() (twice!).  It would be
> very nice if, while you're at modifying this nearby code, you
> could encapsulate that condition in a macro that has a meaningful
> name.

I've looked at doing this factoring before, but the conditions are
subtly different and hence cannot be factored into a single macro.
The xfs_inactive case can be cleaned up (i've got old patches around
that do half the job, IIRC), but the tests in the two functions are
not the same.

> > @@ -979,14 +979,27 @@ xfs_release(
> >  			 * chance to drop them once the last reference to
> >  			 * the inode is dropped, so we'll never leak blocks
> >  			 * permanently.
> 
> I'm curious what the effect is if we simply don't do the truncate
> *except* when the inode becomes inactive.  It means we hang onto
> the stuff for a while longer, and maybe it makes things messier
> in the event of a crash.

It doesn't change a thing in the event of a crash - speculative
preallocation is entirely in-memory state.

> Can you tell me why we do the truncate
> here as well as in xfs_inactive() (or what the problem is of
> *not* doing it here)?

the truncation in ->release is not guaranteed to succeed - it uses
trylock semantics to avoid blocking unnecessarily. It can do this
because we know that when xfs_inactive() is called, the truncation
will happen for real.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

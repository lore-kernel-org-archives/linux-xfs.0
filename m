Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S0SLrk179229 for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:28:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D25CE157D3DB
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:32:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	UeSis4GWVHan6ieH for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 17:32:37 -0700 (PDT)
Date: Fri, 28 May 2010 10:30:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100528003041.GR12087@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<20100527133223.efa4740a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527133223.efa4740a.akpm@linux-foundation.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 27, 2010 at 01:32:23PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 18:53:03 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> =

> > This series reworks the filesystem shrinkers. We currently have a
> > set of issues with the current filesystem shrinkers:
> > =

> >         1. There is an dependency between dentry and inode cache
> >            shrinking that is only implicitly defined by the order of
> >            shrinker registration.
> >         2. The shrinkers need to walk the superblock list and pin
> >            the superblock to avoid unmount races with the sb going
> >            away.
> >         3. The dentry cache uses per-superblock LRUs and proportions
> >            reclaim between all the superblocks which means we are
> >            doing breadth based reclaim. This means we touch every
> >            superblock for every shrinker call, and may only reclaim
> >            a single dentry at a time from a given superblock.
> >         4. The inode cache has a global LRU, so it has different
> >            reclaim patterns to the dentry cache, despite the fact
> >            that the dentry cache is generally the only thing that
> >            pins inodes in memory.
> >         5. Filesystems need to register their own shrinkers for
> >            caches and can't co-ordinate them with the dentry and
> >            inode cache shrinkers.
> =

> Nice description, but...  it never actually told us what the benefit of
> the changes are. =


The first patch I wrote was a small patch to introduce context to
the shrinker callback and a per=ADXFS filesystem shrinker to solve OOM
probelms introduced by background reclaim of XFS inodes.  It was
simple, it worked but Nick refused to allow it because of #1 listed
above. He wanted some <handwaves> guarantee that context based
shrinkers would not break the implicit registration dependency
between the dentry and inode cache shrinkers.

We needed a fix for 2.6.34 for XFS, so I was forced to write a
global shrinker which is what introduced all the lockdep problems.
XFS does not have global inode caches, and the lock required to
manage the list of XFs mounts were what caused all the new lockdep
problems.  There's also other lockdep false positive problems w/ XFS
and shrinkers (e.g. iprune_sem and the unmount path) that need to be
fixed.

That's what this patchset tries to address. It results in simpler
code, less code, removal of implicit, undocumented dependencies,
less locking shenanegans, no superblock list traversals, provides
filesystems with hooks for cache reclaim without needing shrinker
registration and fixes all the all the false positive lockdep
problems XFS has with the current shrinker infrastructure.

If this is all too much, then I'm quite happy to go back to just the
context based shrinker patch and leave everything else alone - the
context based shrinkers are the change we *really* need.  Everything
else in this set of changes is just trying to address objections
raised (that I still don't really understand) against that simple
change.

> Presumably some undescribed workload had some
> undescribed user-visible problem.

$ find . -inum 11111

on a filesystem with more inodes in it than can be held in memory
caused OOM panics.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

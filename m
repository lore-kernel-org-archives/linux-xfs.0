Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:53020 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbfBEU7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 15:59:20 -0500
Date: Wed, 6 Feb 2019 07:59:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190205205915.GD14116@dastard>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930320519.31814.7868551876308474527.stgit@magnolia>
 <20190205142458.GD51421@bfoster>
 <20190205175309.GJ7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205175309.GJ7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Feb 05, 2019 at 09:53:09AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 05, 2019 at 09:24:59AM -0500, Brian Foster wrote:
> > On Mon, Feb 04, 2019 at 10:00:05AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Use a rhashtable to cache the unlinked list incore.  This should speed
> > > up unlinked processing considerably when there are a lot of inodes on
> > > the unlinked list because iunlink_remove no longer has to traverse an
> > > entire bucket list to find which inode points to the one being removed.
> > > 
> > > The incore list structure records "X.next_unlinked = Y" relations, with
> > > the rhashtable using Y to index the records.  This makes finding the
> > > inode X that points to a inode Y very quick.  If our cache fails to find
> > > anything we can always fall back on the old method.
> > > 
> > > FWIW this drastically reduces the amount of time it takes to remove
> > > inodes from the unlinked list.  I wrote a program to open a lot of
> > > O_TMPFILE files and then close them in the same order, which takes
> > > a very long time if we have to traverse the unlinked lists.  With the
> > > ptach, I see:
> > > 
> > ...
> > > ---
> > >  fs/xfs/xfs_inode.c       |  207 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode.h       |    9 ++
> > >  fs/xfs/xfs_log_recover.c |   12 ++-
> > >  fs/xfs/xfs_mount.c       |    5 +
> > >  fs/xfs/xfs_mount.h       |    1 
> > >  5 files changed, 233 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index b9696d762c8f..baee8c894447 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1880,6 +1880,167 @@ xfs_inactive(
> > >  	xfs_qm_dqdetach(ip);
> > >  }
> > >  
> > ...
> > > +
> > > +static const struct rhashtable_params xfs_iunlink_hash_params = {
> > > +	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
> > > +	.nelem_hint		= 512,
> > 
> > Any reasoning behind the 512 value? It seems rather large to me, at
> > least until we get more into deferred inactivation and whatnot. It looks
> > like the rhashtable code will round this up to 1024 as well, FWIW.
> > 
> > I'm also wondering whether a kmem_zone might be worthwhile for
> > xfs_iunlink structures, but that's probably also more for when we expect
> > to drive deeper unlinked lists.
> 
> I picked an arbitrary value of 64 buckets * 8 items per list.  I /do/
> have plans to test various values to see if there's a particular sweet
> spot, though I guess this could be much lower on the assumption that
> we don't expect /that/ many unlinked inodes(?)

Seems pretty large, given we use this for the per-ag buffer cache
rhashtable:

     .min_size               = 32,   /* empty AGs have minimal footprint */
     .nelem_hint             = 16,

And nobody notices problems when they grow and shrink and they run
from empty to hundreds of thousands of entries and back again in
very short preiods of time. Hence I'd suggest that we make it as
small as possible to begin with and then only change things if there
are performance problems triggered by growing and shrinking....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

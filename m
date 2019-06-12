Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438441AbfFLMzS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 08:55:18 -0400
Date: Wed, 12 Jun 2019 08:55:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190612125506.GE12395@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
 <20190611232347.GE14363@dread.disaster.area>
 <20190612003219.GV1871505@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612003219.GV1871505@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, Jun 11, 2019 at 05:32:19PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 12, 2019 at 09:23:47AM +1000, Dave Chinner wrote:
> > On Mon, Jun 10, 2019 at 09:58:52AM -0400, Brian Foster wrote:
> > > On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Convert quotacheck to use the new iwalk iterator to dig through the
> > > > inodes.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
> > > >  1 file changed, 20 insertions(+), 42 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > > index aa6b6db3db0e..a5b2260406a8 100644
> > > > --- a/fs/xfs/xfs_qm.c
> > > > +++ b/fs/xfs/xfs_qm.c
> > > ...
> > > > @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
> > > >  	 * rootino must have its resources accounted for, not so with the quota
> > > >  	 * inodes.
> > > >  	 */
> > > > -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> > > > -		*res = BULKSTAT_RV_NOTHING;
> > > > -		return -EINVAL;
> > > > -	}
> > > > +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> > > > +		return 0;
> > > >  
> > > >  	/*
> > > >  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
> > > >  	 * at mount time and therefore nobody will be racing chown/chproj.
> > > >  	 */
> > > > -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > > > -	if (error) {
> > > > -		*res = BULKSTAT_RV_NOTHING;
> > > > +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > > 
> > > I was wondering if we should start using IGET_UNTRUSTED here, but I
> > > guess we're 1.) protected by quotacheck context and 2.) have the same
> > > record validity semantics as the existing bulkstat walker. LGTM:
> > 
> > FWIW, I'd be wanting to go the other way with bulkstat. i.e. finding
> > ways of reducing IGET_UNTRUSTED in bulkstat because it adds
> > substantial CPU overhead during inode lookup because it has to look
> > up the inobt to validate the inode number. i.e. we are locking the
> > AGI and doing an inobt lookup on every inode we bulkstat because
> > there is some time between the initial inobt lookup and the
> > xfs_iget() call and that's when the inode chunk can get removed.
> > 

Right.. note that I was just surmising whether IGET_UNTRUSTED was
required for correctness here due to the semantics of the iwalk.

> > IOWs, we only need to validate that the inode buffer still contains
> > inodes before we start instantiating inodes from it, but because we
> > don't hold any locks across individual inode processing in bulkstat
> > we have to revalidate that buffer contains inodes for every
> > allocated inode in that buffer. If we had a way of passing a locked
> > cluster buffer into xfs_iget to avoid having to look it up and read
> > it, we could do a single inode cluster read after validating the
> > inobt record is still valid, we could cycle all the remaining inodes
> > through xfs_iget() without having to use IGET_UNTRUSTED to validate
> > the inode cluster still contains valid inodes on every inode....
> > 

Yep, that sounds like a nice idea to me. Perhaps we could cache the
current cluster buffer somewhere in the iteration structure and use that
to validate incoming inode numbers until we move out of the cluster.

> > We still need to cycle inodes through the cache (so bulkstat is
> > coherent with other inode operations), but this would substantially
> > reduce the per-inode bulkstat CPU overhead, I think....
> 

Since we're already discussing tweaks to readahead, another approach to
this problem could be to try and readahead all the way into the inode
cache. For example, consider a mechanism where a cluster buffer
readahead sets a flag on the buffer that effectively triggers an iget of
each allocated inode in the buffer. Darrick has already shown that the
inode memory allocation and iget itself has considerable overhead even
when the cluster buffer is already cached. We know that's not due to
btree lookups because quotacheck isn't using IGET_UNTRUSTED, so perhaps
we could amortize more of this cost via readahead.

The caveats are that would probably be more involved than something that
just caches the current cluster buffer and passes it into the iget path.
We'd have to rectify readahead in-core inodes against DONTCACHE inodes
used by bulkstat, for example, though I don't think that would be too
difficult to address via a new inode readahead flag or some such
preserve existing DONTCACHE behavior.

It's also likely that passing the buffer into iget would already address
most of the overhead associated with the buffer lookup, so there might
not be enough tangible benefit at that point. The positive is that it's
probably an incremental step on top of an "iget from an existing cluster
buffer" mechanism and so could be easily prototyped by hacking in a read
side b_iodone handler or something.

Anyways, just thinking out loud a bit..

> I'll think about this as an addendum to the series, because I suspect
> that remodelling the existing users is going to be an entire series on
> its own.  (IOWs, my brain is too tired for today)
> 

Heh, definitely something for a separate patch (series). :)

Brian

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

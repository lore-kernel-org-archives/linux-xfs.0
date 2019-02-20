Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58709 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfBTPIT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 10:08:19 -0500
Date: Wed, 20 Feb 2019 16:08:18 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] xfs: introduce an always_cow mode
Message-ID: <20190220150818.GA27934@lst.de>
References: <20190218091827.12619-1-hch@lst.de> <20190218091827.12619-9-hch@lst.de> <20190219183114.GK32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219183114.GK32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Feb 19, 2019 at 10:31:14AM -0800, Darrick J. Wong wrote:
> >  - xfs/326 fails to modify the file at all in always_cow mode after
> >    injecting the refcount error, leading to an unexpected md5sum
> >    after the remount, but that again is expected
> 
> I'm assuming the purpose of the debug knob is so that we can get all the
> fstests regressions fixed before enabling always cow modes for users...

Theoriginal  purpose is to allow exercising the always COW functionality,
so that  it can be tested without SMR support or atomic write which are
still in flux.

While developing it I also noticed that it also helps to uncover general
COW functionality bugs, so it also is a pretty good debug aid for that.

> > +		} else {
> > +			/*
> > +			 * If always_cow mode we can't use preallocations and
> > +			 * thus should not create them.
> > +			 */
> > +			if (xfs_is_always_cow_inode(ip)) {
> > +				error = -EOPNOTSUPP;
> > +				goto out_unlock;
> > +			}
> > +
> 
> Ok, so the basic premise here is that we never call xfs_alloc_file_space
> for alwayscow inodes.  As I pointed out in my reply that focused on
> fstests errors, xfs_file_fallocate is not the only caller of
> xfs_alloc_file_space, so I think xfs_ioc_space and friends are going to
> need a similar treatment.

As mentioned the XFS_IOC_RESVSP / XFS_IOC_RESVSP64 cases in
xfs_ioc_space are dead code.  the allocspc/freespc ones aren't, and
while those aren't super useful on always_cow inodes they do work
just fine.

> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 7b71dcc97ef0..72533e9dddc6 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -395,12 +395,13 @@ xfs_quota_calc_throttle(
> >  STATIC xfs_fsblock_t
> >  xfs_iomap_prealloc_size(
> >  	struct xfs_inode	*ip,
> > +	int			whichfork,
> >  	loff_t			offset,
> >  	loff_t			count,
> >  	struct xfs_iext_cursor	*icur)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> 
> Hmm, so are we able to do preallocations in the cow fork now?
> 
> I think that's a separate change from adding the alwayscow knob.

I can split a prep patch out, but by always writing through the COW fork
in always_cow mode we also want the speculative EOF preallocations there.
Without always_cow we don't COW at EOF per defintion so it is rather
pointless.

> > +static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
> > +{
> > +	return ip->i_mount->m_always_cow &&
> > +		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
> 
> Assuming the next step is to rewrite this function to autodetect a
> device that cannot easily handle rewrites (aka SMR)...

For SMR we'll have a per-sb flag, for atomic writes a per-inode one.
But right now I intended these to exist in addition, not instead of the
debug know.

> > --- a/fs/xfs/xfs_sysctl.h
> > +++ b/fs/xfs/xfs_sysctl.h
> > @@ -85,6 +85,7 @@ struct xfs_globals {
> >  	int	log_recovery_delay;	/* log recovery delay (secs) */
> >  	int	mount_delay;		/* mount setup delay (secs) */
> >  	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
> > +	bool	always_cow;		/* use COW fork for all overwrites */
> 
> ...I'm also wondering if it makes sense to separate the creation of the
> sysctl knob into a separate patch so that we can cleanly revert just
> this part whenever we land a more permanent interface for enabling
> alwayscow paths?

I could split it - but my intention was to keep the debug know around
in the long term, as it is really helpful for exercising the COW code.

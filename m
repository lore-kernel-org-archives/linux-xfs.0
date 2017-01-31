Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23883 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdAaVkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 16:40:39 -0500
Date: Tue, 31 Jan 2017 13:40:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/7] xfs: fix toctou race when locking an inode to access
 the data map
Message-ID: <20170131214007.GI9134@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
 <20170131132658.GA17386@infradead.org>
 <20170131194520.GG9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131194520.GG9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 31, 2017 at 11:45:20AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 31, 2017 at 05:26:58AM -0800, Christoph Hellwig wrote:
> > On Mon, Jan 30, 2017 at 04:23:10PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > We use di_format and if_flags to decide whether we're grabbing the ilock
> > > in btree mode (btree extents not loaded) or shared mode (anything else),
> > > but the state of those fields can be changed by other threads that are
> > > also trying to load the btree extents -- IFEXTENTS gets set before the
> > > _bmap_read_extents call and cleared if it fails.  Therefore, once we've
> > > grabbed the shared ilock we have to re-check the fields to see if we
> > > actually need to upgrade to the exclusive ilock in order to try loading
> > > the extents.
> > > 
> > > Without this patch, we trigger ilock assert failures when a bunch of
> > > threads try to access a btree format directory with a corrupt bmbt root
> > > and corrupt the incore data structures, leading to a crash.
> > 
> > I see the problem here, but I really don't like the fix.  Instead
> > I'd much rather check for a new flag that tells that the extent list
> > hasn't been read, which can only be cleared under the exclusive
> > ilock.  That way we shouldn't need any additional relocking or
> > checks.
> 
> I'm confused --
> 
> I thought XFS_IFEXTENTS means "extents have been read", which is the
> inverse of the flag you propose.  AFAICT the bit is only ever set (or
> cleared) with ILOCK_EXCL held, so the problem here is that we're
> performing an unlocked read of if_flags prior to actually taking the
> lock that we need.
> 
> On the other hand, I /think/ it's the case that none of the functions
> called in _iread_extents actually cares about IFEXTENTS being set, so
> perhaps an alternative could be to avoid setting the bit until we've
> successfully read in all the bmbt records?
> 
> I'll try that out and report back.

Seems to work, will send a revised patch.

--D

> 
> --D
> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

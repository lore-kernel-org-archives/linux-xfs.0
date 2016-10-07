Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58436 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752721AbcJGWZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 18:25:38 -0400
Date: Sat, 8 Oct 2016 09:25:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 46/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20161007222508.GK9806@dastard>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
 <20161007180506.GF58659@bfoster.bfoster>
 <20161007202639.GG11241@birch.djwong.org>
 <20161007205838.GH58659@bfoster.bfoster>
 <20161007211540.GI11241@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007211540.GI11241@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Oct 07, 2016 at 02:15:40PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 07, 2016 at 04:58:38PM -0400, Brian Foster wrote:
> > On Fri, Oct 07, 2016 at 01:26:39PM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 07, 2016 at 02:05:07PM -0400, Brian Foster wrote:
> > > > On Thu, Sep 29, 2016 at 08:10:39PM -0700, Darrick J. Wong wrote:
> > > > The code that has been merged is now different from this code :/, but
> > > > just a heads up that the code in the tree looks like it has another one
> > > > of those potentially blind transaction commit sequences between
> > > > xfs_reflink_try_clear_inode_flag() and xfs_reflink_clear_inode_flag().
> > > 
> > > _reflink_unshare jumps out if it's not a reflink inode before
> > > calling _reflink_try_clear_inode_flag -> _reflink_clear_inode_flag.
> > > We do not call _reflink_clear_inode_flag with a non-reflink inode.
> > > As for blindly committing a transaction with no dirty data, that's
> > > fine, _trans_commit checks for that case and simply frees everything
> > > attached to the transaction.
> > > 
> > 
> > Yeah, I saw that. That's what I was alluding to below wrt to the usage
> > being fine in the patch. It's just the pattern that's used that stands
> > out.
> > 
> > With regard to the transaction.. sure, that situation may not be broken,
> > but it's still not ideal if it's a log reservation we didn't have to
> > make in the first place.
> 
> Yeah.  We must hold the ilock from the start of the extent iteration
> until we clear (or not) the inode flag, but we have to allocate the
> transaction before grabbing the ilock.  In other words, we don't know if
> we need the transaction until it's too late to get one, hence this
> suboptimal thing where we sometimes get a reservation and never commit
> anything.  I don't know of any way to avoid that.

Getting a transaction we don't use isn't the end of the world -
in most cases it's just a bit of wasted CPU time. Similarly to
committing an empty transaction it has no actual effect except to
increment the empty transaction stat. In this case, commit is just
fine as xfs_trans_commit will detect that it is empty and do the
cancel work directly.

If I start to see too many empty transaction commits in my
performance test runs, I'll let you know and we can start to look
for solutions. But right now I wouldn't worry about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

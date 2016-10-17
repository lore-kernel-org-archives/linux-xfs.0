Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60159 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932209AbcJQRoO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:44:14 -0400
Date: Mon, 17 Oct 2016 19:44:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/9] xfs: refactor xfs_bunmapi_cow
Message-ID: <20161017174411.GA22930@lst.de>
References: <1476521554-1894-1-git-send-email-hch@lst.de> <1476521554-1894-7-git-send-email-hch@lst.de> <20161017172103.GH12736@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017172103.GH12736@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Mon, Oct 17, 2016 at 01:21:03PM -0400, Brian Foster wrote:
> On Sat, Oct 15, 2016 at 10:52:31AM +0200, Christoph Hellwig wrote:
> > Split out two helpers for deleting delayed or real extents from the COW fork.
> > This allows to call them directly from xfs_reflink_cow_end_io once that
> > function is refactored to iterate the extent tree.  It will also allow
> > to reuse the delalloc deletion from xfs_bunmapi in the future.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 374 ++++++++++++++++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_bmap.h |   5 +
> >  fs/xfs/xfs_reflink.c     |   5 -
> >  3 files changed, 225 insertions(+), 159 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 5d230ea..f33f737 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -535,11 +535,6 @@ xfs_reflink_cancel_cow_blocks(
> >  		trace_xfs_reflink_cancel_cow(ip, &irec);
> >  
> >  		if (irec.br_startblock == DELAYSTARTBLOCK) {
> > -			/* Free a delayed allocation. */
> > -			xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount,
> > -					false);
> 
> Don't we still need this call, or am I missing where it exists
> elsewhere? Also, IIRC we might need to make sure this occurs after
> xfs_bunmapi_cow() since the latter can steal blocks from the deleted
> extent for indirect blocks (e.g., where we call
> xfs_bmap_split_indlen()).

xfs_bmap_del_extent_delay is now taking care of this:

+       ASSERT(da_old >= da_new);
+       da_diff = da_old - da_new;
+       if (!isrt)
+               da_diff += del->br_blockcount;
+       if (da_diff)
+               xfs_mod_fdblocks(mp, da_diff, false);
+       return error;

Note that the old code also was buggy if for some reason
the cancellation was for a partial cow extent.

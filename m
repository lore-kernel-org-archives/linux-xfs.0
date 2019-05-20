Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49890 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfETGLg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:11:36 -0400
Date: Mon, 20 May 2019 08:11:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/20] xfs: add a flag to release log items on commit
Message-ID: <20190520061115.GH31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-9-hch@lst.de> <20190517175025.GH7888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517175025.GH7888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 01:50:25PM -0400, Brian Foster wrote:
> On Fri, May 17, 2019 at 09:31:07AM +0200, Christoph Hellwig wrote:
> > We have various items that are released from ->iop_comitting.  Add a
> > flag to just call ->iop_release from the commit path to avoid tons
> > of boilerplate code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Seems reasonable, but the naming is getting a little confusing. Your
> commit log refers to ->iop_committing() and the patch modifies
> ->iop_committed(). Both the committing and committed callbacks still
> exist, while the flag is called *_RELEASE_ON_COMMIT and thus doesn't
> indicate which event it actually refers to. Can we fix this up? Maybe
> just call it *_RELEASE_ON_COMMITTED?

Sounds fine. 

> 
> >  fs/xfs/xfs_bmap_item.c     | 27 +--------------------------
> >  fs/xfs/xfs_extfree_item.c  | 27 +--------------------------
> >  fs/xfs/xfs_icreate_item.c  | 18 +-----------------
> >  fs/xfs/xfs_refcount_item.c | 27 +--------------------------
> >  fs/xfs/xfs_rmap_item.c     | 27 +--------------------------
> >  fs/xfs/xfs_trans.c         |  5 +++++
> >  fs/xfs/xfs_trans.h         |  7 +++++++
> >  7 files changed, 17 insertions(+), 121 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 45a39de65997..52a8a8ff2ae9 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -849,6 +849,11 @@ xfs_trans_committed_bulk(
> >  		struct xfs_log_item	*lip = lv->lv_item;
> >  		xfs_lsn_t		item_lsn;
> >  
> > +		if (lip->li_ops->flags & XFS_ITEM_RELEASE_ON_COMMIT) {
> > +			lip->li_ops->iop_release(lip);
> > +			continue;
> > +		}
> 
> It might be appropriate to set the aborted flag before the callback.
> Even though none of the current users happen to care, it's a more
> consistent semantic with the other direct caller of ->iop_release().

Ok.

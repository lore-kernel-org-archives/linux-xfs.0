Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44442 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbdHQHoY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:44:24 -0400
Date: Thu, 17 Aug 2017 09:44:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: rename xfs_defer_join to xfs_defer_join_inode
Message-ID: <20170817074422.GA24463@lst.de>
References: <20170813144216.11192-1-hch@lst.de> <20170813144216.11192-3-hch@lst.de> <20170816172130.GA4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170816172130.GA4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 16, 2017 at 10:21:30AM -0700, Darrick J. Wong wrote:
> On Sun, Aug 13, 2017 at 04:42:15PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
> >  fs/xfs/libxfs/xfs_defer.c | 4 ++--
> >  fs/xfs/libxfs/xfs_defer.h | 2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index c09c16b1ad3b..24eba36ef818 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -6452,7 +6452,7 @@ __xfs_bmap_add(
> >  	bi->bi_whichfork = whichfork;
> >  	bi->bi_bmap = *bmap;
> >  
> > -	error = xfs_defer_join(dfops, bi->bi_owner);
> > +	error = xfs_defer_join_inode(dfops, bi->bi_owner);
> 
> /me wonders if this should be named xfs_defer_ijoin to be more
> consistent with xfs_trans_ijoin, or if we should rename the other one to
> xfs_trans_join_inode instead?

Sure.  I'll resend with the __ prefix removed from __xfs_trans_roll
and this renamed to _ijoin.

Should I also rename xfs_trans_roll_inode to xfs_trans_roll_ijoin?

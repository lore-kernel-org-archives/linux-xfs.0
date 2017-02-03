Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39368 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbdBCSIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 13:08:47 -0500
Date: Fri, 3 Feb 2017 10:08:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: update ctime and mtime on clone destinatation
 inodes
Message-ID: <20170203180826.GA31044@birch.djwong.org>
References: <20170203095715.7955-1-hch@lst.de>
 <20170203174541.GS9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203174541.GS9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, amir73il@gmail.com

On Fri, Feb 03, 2017 at 09:45:41AM -0800, Darrick J. Wong wrote:
> [cc amir since he piped up about the v1 patch]
> 
> On Fri, Feb 03, 2017 at 10:57:15AM +0100, Christoph Hellwig wrote:
> > We're changing both metadata and data, so we need to update the
> > timestamps for clone operations.  Dedupe on the other hand does
> > not change file data, and only changes invisible metadata so the
> > timestamps should not be updated.
> > 
> > This follows existing btrfs behavior.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_reflink.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index d5a2cf2b469b..199ce0100bc6 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -961,13 +961,15 @@ STATIC int
> >  xfs_reflink_update_dest(
> >  	struct xfs_inode	*dest,
> >  	xfs_off_t		newlen,
> > -	xfs_extlen_t		cowextsize)
> > +	xfs_extlen_t		cowextsize,
> > +	bool			is_dedupe)
> >  {
> >  	struct xfs_mount	*mp = dest->i_mount;
> >  	struct xfs_trans	*tp;
> >  	int			error;
> >  
> > -	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
> > +	if (is_dedupe &&
> > +	    newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0 && is_dedupe)
> >  		return 0;
> 
> Redundant is_dedupe tests here.
> 
> I also wonder if we really /want/ to emulate the existing btrfs
> behavior, which seems to be:
> 
> reflink: update mtime & ctime
> dedupe: do not update mtime or ctime
> 
> In particular, dedupe changes the inode metadata, which should qualify
> for a ctime update, right?

OTOH, /me fishes out the discussion between mfasheh & zygo where they
discuss changing btrfs to avoid [cm]time updates on dedupe:

https://patchwork.kernel.org/patch/6683161/

So... <shrug> I'm willing to preserve the 'dedupe doesn't update
timestamps' behavior even though we're definitely changing di_nextents
(and possibly di_cowextsize).

(Though, you may note, I didn't write any code to update the timestamps
in the original patches, so clearly I'm not all that passionate either
way. :P)

--D

> 
> --D
> 
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> > @@ -988,6 +990,10 @@ xfs_reflink_update_dest(
> >  		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> >  	}
> >  
> > +	if (!is_dedupe) {
> > +		xfs_trans_ichgtime(tp, dest,
> > +				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > +	}
> >  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
> >  
> >  	error = xfs_trans_commit(tp);
> > @@ -1301,7 +1307,8 @@ xfs_reflink_remap_range(
> >  	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> >  		cowextsize = src->i_d.di_cowextsize;
> >  
> > -	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize);
> > +	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> > +			is_dedupe);
> >  
> >  out_unlock:
> >  	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

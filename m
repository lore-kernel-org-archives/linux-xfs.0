Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752466AbeGCUsC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 16:48:02 -0400
Date: Tue, 3 Jul 2018 16:48:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/24] xfs: use ->t_dfops for all xfs_bmapi_write()
 callers
Message-ID: <20180703204800.GI22789@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-12-bfoster@redhat.com>
 <20180703204257.GG32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703204257.GG32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:42:57PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 28, 2018 at 12:36:23PM -0400, Brian Foster wrote:
> > Attach ->t_dfops for all remaining callers of xfs_bmapi_write().
> > This prepares the latter to no longer require a separate dfops
> > parameter.
> > 
> > Note that xfs_symlink() already uses ->t_dfops. Fix up the local
> > references for consistency.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok, though I'm starting to itch for moving all these
> _defer_{init,finish,cancel} calls into _trans_{alloc,commit,cancel} so
> that we can get rid of all the boilerplate code everywhere.
> 

That's the next step after the firstblock fixups. :)

Brian

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_bmap_util.c |  5 +++--
> >  fs/xfs/xfs_iomap.c     | 21 ++++++++++++---------
> >  fs/xfs/xfs_reflink.c   |  7 ++++---
> >  fs/xfs/xfs_rtalloc.c   |  7 ++++---
> >  fs/xfs/xfs_symlink.c   |  6 +++---
> >  5 files changed, 26 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 83b1e8c6c18f..e6036f56241c 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -972,16 +972,17 @@ xfs_alloc_file_space(
> >  		xfs_trans_ijoin(tp, ip, 0);
> >  
> >  		xfs_defer_init(&dfops, &firstfsb);
> > +		tp->t_dfops = &dfops;
> >  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> >  					allocatesize_fsb, alloc_type, &firstfsb,
> > -					resblks, imapp, &nimaps, &dfops);
> > +					resblks, imapp, &nimaps, tp->t_dfops);
> >  		if (error)
> >  			goto error0;
> >  
> >  		/*
> >  		 * Complete the transaction
> >  		 */
> > -		error = xfs_defer_finish(&tp, &dfops);
> > +		error = xfs_defer_finish(&tp, tp->t_dfops);
> >  		if (error)
> >  			goto error0;
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 55876dd02f0c..8e1f3b451ee4 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -255,17 +255,18 @@ xfs_iomap_write_direct(
> >  	 * caller gave to us.
> >  	 */
> >  	xfs_defer_init(&dfops, &firstfsb);
> > +	tp->t_dfops = &dfops;
> >  	nimaps = 1;
> >  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> >  				bmapi_flags, &firstfsb, resblks, imap,
> > -				&nimaps, &dfops);
> > +				&nimaps, tp->t_dfops);
> >  	if (error)
> >  		goto out_bmap_cancel;
> >  
> >  	/*
> >  	 * Complete the transaction
> >  	 */
> > -	error = xfs_defer_finish(&tp, &dfops);
> > +	error = xfs_defer_finish(&tp, tp->t_dfops);
> >  	if (error)
> >  		goto out_bmap_cancel;
> >  
> > @@ -289,7 +290,7 @@ xfs_iomap_write_direct(
> >  	return error;
> >  
> >  out_bmap_cancel:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> > @@ -717,6 +718,7 @@ xfs_iomap_write_allocate(
> >  			xfs_trans_ijoin(tp, ip, 0);
> >  
> >  			xfs_defer_init(&dfops, &first_block);
> > +			tp->t_dfops = &dfops;
> >  
> >  			/*
> >  			 * it is possible that the extents have changed since
> > @@ -772,11 +774,11 @@ xfs_iomap_write_allocate(
> >  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
> >  						count_fsb, flags, &first_block,
> >  						nres, imap, &nimaps,
> > -						&dfops);
> > +						tp->t_dfops);
> >  			if (error)
> >  				goto trans_cancel;
> >  
> > -			error = xfs_defer_finish(&tp, &dfops);
> > +			error = xfs_defer_finish(&tp, tp->t_dfops);
> >  			if (error)
> >  				goto trans_cancel;
> >  
> > @@ -810,7 +812,7 @@ xfs_iomap_write_allocate(
> >  	}
> >  
> >  trans_cancel:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  	xfs_trans_cancel(tp);
> >  error0:
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > @@ -878,10 +880,11 @@ xfs_iomap_write_unwritten(
> >  		 * Modify the unwritten extent state of the buffer.
> >  		 */
> >  		xfs_defer_init(&dfops, &firstfsb);
> > +		tp->t_dfops = &dfops;
> >  		nimaps = 1;
> >  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> >  					XFS_BMAPI_CONVERT, &firstfsb, resblks,
> > -					&imap, &nimaps, &dfops);
> > +					&imap, &nimaps, tp->t_dfops);
> >  		if (error)
> >  			goto error_on_bmapi_transaction;
> >  
> > @@ -901,7 +904,7 @@ xfs_iomap_write_unwritten(
> >  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >  		}
> >  
> > -		error = xfs_defer_finish(&tp, &dfops);
> > +		error = xfs_defer_finish(&tp, tp->t_dfops);
> >  		if (error)
> >  			goto error_on_bmapi_transaction;
> >  
> > @@ -928,7 +931,7 @@ xfs_iomap_write_unwritten(
> >  	return 0;
> >  
> >  error_on_bmapi_transaction:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  	xfs_trans_cancel(tp);
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	return error;
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index ff10b5e70029..1ff9ef1d65ba 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -429,19 +429,20 @@ xfs_reflink_allocate_cow(
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> >  	xfs_defer_init(&dfops, &first_block);
> > +	tp->t_dfops = &dfops;
> >  	nimaps = 1;
> >  
> >  	/* Allocate the entire reservation as unwritten blocks. */
> >  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> >  			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
> > -			resblks, imap, &nimaps, &dfops);
> > +			resblks, imap, &nimaps, tp->t_dfops);
> >  	if (error)
> >  		goto out_bmap_cancel;
> >  
> >  	xfs_inode_set_cowblocks_tag(ip);
> >  
> >  	/* Finish up. */
> > -	error = xfs_defer_finish(&tp, &dfops);
> > +	error = xfs_defer_finish(&tp, tp->t_dfops);
> >  	if (error)
> >  		goto out_bmap_cancel;
> >  
> > @@ -458,7 +459,7 @@ xfs_reflink_allocate_cow(
> >  convert:
> >  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
> >  out_bmap_cancel:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
> >  			XFS_QMOPT_RES_REGBLKS);
> >  out:
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 329d4d26c13e..312d410d91fb 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -788,13 +788,14 @@ xfs_growfs_rt_alloc(
> >  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> >  
> >  		xfs_defer_init(&dfops, &firstblock);
> > +		tp->t_dfops = &dfops;
> >  		/*
> >  		 * Allocate blocks to the bitmap file.
> >  		 */
> >  		nmap = 1;
> >  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> >  					XFS_BMAPI_METADATA, &firstblock,
> > -					resblks, &map, &nmap, &dfops);
> > +					resblks, &map, &nmap, tp->t_dfops);
> >  		if (!error && nmap < 1)
> >  			error = -ENOSPC;
> >  		if (error)
> > @@ -802,7 +803,7 @@ xfs_growfs_rt_alloc(
> >  		/*
> >  		 * Free any blocks freed up in the transaction, then commit.
> >  		 */
> > -		error = xfs_defer_finish(&tp, &dfops);
> > +		error = xfs_defer_finish(&tp, tp->t_dfops);
> >  		if (error)
> >  			goto out_bmap_cancel;
> >  		error = xfs_trans_commit(tp);
> > @@ -855,7 +856,7 @@ xfs_growfs_rt_alloc(
> >  	return 0;
> >  
> >  out_bmap_cancel:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> >  	return error;
> > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > index e347a3db018f..6825a31727d1 100644
> > --- a/fs/xfs/xfs_symlink.c
> > +++ b/fs/xfs/xfs_symlink.c
> > @@ -291,7 +291,7 @@ xfs_symlink(
> >  
> >  		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
> >  				  XFS_BMAPI_METADATA, &first_block, resblks,
> > -				  mval, &nmaps, &dfops);
> > +				  mval, &nmaps, tp->t_dfops);
> >  		if (error)
> >  			goto out_bmap_cancel;
> >  
> > @@ -354,7 +354,7 @@ xfs_symlink(
> >  		xfs_trans_set_sync(tp);
> >  	}
> >  
> > -	error = xfs_defer_finish(&tp, &dfops);
> > +	error = xfs_defer_finish(&tp, tp->t_dfops);
> >  	if (error)
> >  		goto out_bmap_cancel;
> >  
> > @@ -370,7 +370,7 @@ xfs_symlink(
> >  	return 0;
> >  
> >  out_bmap_cancel:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_defer_cancel(tp->t_dfops);
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> >  out_release_inode:
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

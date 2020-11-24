Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D6AC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 23:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2B320872
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 23:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DR+FqS2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgKXXO4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 18:14:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730736AbgKXXO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 18:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606259692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5B7pqvnlRV4RW8BEkFyrEQxiro//0D1l7MrWX37OP1k=;
        b=DR+FqS2xYQOkPtRIaitsujL8Ni4SpdbB47TMtJ3870JTl+lB9Ko+JSh08oF/D9UJp0LKNj
        yExKj4PWwwIceqX7ZkIPgJ65brnp6rcYJ5tzxN22sX71ooxvNHmaF4r3eVKuKNjp1RSpmt
        sSkiMZmU+loJK8eLRVFxivAicjx/qnI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-VgAqPvK3NyCgO4KRyVGXCw-1; Tue, 24 Nov 2020 18:14:50 -0500
X-MC-Unique: VgAqPvK3NyCgO4KRyVGXCw-1
Received: by mail-pf1-f198.google.com with SMTP id r8so106089pfh.9
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 15:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5B7pqvnlRV4RW8BEkFyrEQxiro//0D1l7MrWX37OP1k=;
        b=eL1VABWO7q3xnzeA3YBE1G/w6QacS8Itje2BJ6InC++wKONW9cJaJbGXFfVt+YcUqF
         DV6y7scKmQMDHAwRH8lxKFOTpVNxwxCP+fx3k3bUSNuO+cFtJY7CKLUJx+UJMXatZCaK
         UbyPJNLW1NXx/HyCseVQPaAiD/XZ8LS2vxIOXeaoVNEJo3umB2Yz4OOZa7gyC1pcUwG2
         ejgaFpmvRFaDmxvIUxzsZl8deyO9/G459Ck6Y0W4NIKn70pcCbufEr7XCWDKLhtqG43f
         3XnfZCMMnPTqe20QZIJgH9256hvIT/HcCBcs+K75de6MsnitllF04QbmLW0pG2rCBuC1
         2ePg==
X-Gm-Message-State: AOAM533qFckTqEf0hT3xIZitXzHllDwbBkcYGj/OoaSR9CiJQDJEO6YY
        TprV4KcVqkEiJ2OPaByLPIYBHF+P292GGdhXlabFKx/yPEDZJkX2aWmdmkl9vyTA+uqW5dsyaAf
        pdktMV56MgB9qq7vxufgR
X-Received: by 2002:a63:1901:: with SMTP id z1mr570426pgl.87.1606259688512;
        Tue, 24 Nov 2020 15:14:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqNMJ7lQooS6Qfl8Lw7sg2A9UTg/pxI1FI3BsI1Ev9ZbzabiXqI2VTmOPdx5PCRYJu1U5mIw==
X-Received: by 2002:a63:1901:: with SMTP id z1mr570399pgl.87.1606259687919;
        Tue, 24 Nov 2020 15:14:47 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e8sm96228pfn.175.2020.11.24.15.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 15:14:47 -0800 (PST)
Date:   Wed, 25 Nov 2020 07:14:38 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: clean up xfs_dialloc() by introducing
 __xfs_dialloc()
Message-ID: <20201124231340.GA102247@xiangao.remote.csb>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-3-hsiangkao@redhat.com>
 <20201124221623.GC2842436@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201124221623.GC2842436@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Nov 25, 2020 at 09:16:23AM +1100, Dave Chinner wrote:
> On Tue, Nov 24, 2020 at 11:51:30PM +0800, Gao Xiang wrote:
> > Move the main loop out into a separated function, so we can save
> > many extra xfs_perag_put()s and gotoes to make the logic cleaner.
> > 
> > Also it can make the modification of perag protection by some lock
> > for shrinking in the future somewhat easier.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > It tries to kill multiple goto exits... which makes the logic hard
> > to read and modify.
> > 
> > not quite sure the name of __xfs_dialloc(), cannot think of some
> > better name since xfs_dialloc_ag is used...
> > 
> >  fs/xfs/libxfs/xfs_ialloc.c | 166 ++++++++++++++++++++-----------------
> >  1 file changed, 88 insertions(+), 78 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 5c8b0210aad3..937455c50570 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -1681,6 +1681,83 @@ xfs_dialloc_ag(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Return 0 for successfully allocating some inodes in this AG;
> > + *        1 for skipping to allocating in the next AG;
> > + *      < 0 for error code.
> > + */
> > +static int
> > +__xfs_dialloc(
> 
> FWIW, we try to avoid "__" prefixes when factoring code out. The new
> function should be obvious in it's function to have a proper name.
> 
> In this case, we are going to try to allocate an inode in the
> provided AG. So xfs_dialloc_try_ag() would seem appropriate.

Ok, Thanks! I was asking for a real name :)

> 
> Also, in that case, an -EAGAIN or -EBUSY error might be more
> appropriate for a "cannot allocate in this AG" soft failure rather
> than having a tri-state return value. We should not get either of
> those errors from inode allocation, so such an error would indicate
> to the caller that is should just try the next AG...

I thought using some error code as well, yet my perference finally
about this could be a functional feature (e.g. non-RCU / completely
retry by using -ECHILD / -ESTALE in lookup code). For such 2 level
internal seperate functions, I'd like to use some tri-state return
value in order to avoid breaking some potential or upcoming functional
features.

Yeah, but it's just my own thought, anyway. I will switch to use
some error code in the next version.

> 
> However, I think there's a higher layer cleanup than needs to be
> done here first....
> 
> > @@ -1711,7 +1788,6 @@ xfs_dialloc(
> >  	xfs_ino_t		*inop)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> > -	struct xfs_buf		*agbp;
> >  	xfs_agnumber_t		agno;
> >  	int			error;
> >  	bool			noroom = false;
> > @@ -1726,8 +1802,9 @@ xfs_dialloc(
> >  		 * continue where we left off before.  In this case, we
> >  		 * know that the allocation group has free inodes.
> >  		 */
> > -		agbp = *IO_agbp;
> > -		goto out_alloc;
> > +		error = xfs_dialloc_ag(tp, *IO_agbp, parent, inop);
> > +		*IO_agbp = NULL;
> > +		return error;
> >  	}
> 
> This whole "ialloc_context/IO_agbp" thing has always been a nasty
> wart in this code. I think getting rid that wart then makes this
> change a lot cleaner and more obvious.
> 
> Completely untested patch below for you to start from...

Yeah, I didn't think much more about it to really change the logic.
My starting point was that I always feel a bit more uncomfortable
about randomly add some perag lock/unlock for such like function
(with random multiple exits, and xfs_alloc.c extent allocation
almost the same...). Hard to review and maybe potential unbalanced
bugs here....

Ok, Thanks for the patch/direction! let me play with it for a while,
and if you don't care I'll make it together with the series (although
the whole progress could be somewhat slow though...)

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> xfs: rework inode allocation interface
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Get rid of the nasty, confusing ialloc_context and messy ENOSPC and
> failure handling around xfs_ialloc() and xfs_dialloc() by separating
> free inode chunk allocation and inode allocation into two individual
> high level operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 132 +++++++++++++-----------
>  fs/xfs/libxfs/xfs_ialloc.h |  42 ++++----
>  fs/xfs/xfs_inode.c         | 245 +++++++++++----------------------------------
>  3 files changed, 151 insertions(+), 268 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 974e71bc4a3a..011813934ee1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1570,7 +1570,7 @@ xfs_dialloc_ag_update_inobt(
>   * The caller selected an AG for us, and made sure that free inodes are
>   * available.
>   */
> -STATIC int
> +int
>  xfs_dialloc_ag(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> @@ -1682,35 +1682,70 @@ xfs_dialloc_ag(
>  	return error;
>  }
>  
> +static int
> +xfs_dialloc_roll(
> +	struct xfs_trans	**tpp,
> +	struct xfs_buf		*agibp)
> +{
> +	struct xfs_trans	*tp = *tpp;
> +	void			*dqinfo = NULL;
> +	unsigned int		tflags = 0;
> +	int			error;
> +
> +	/*
> +	 * Hold to on to the agibp across the commit so no other allocation can
> +	 * come in and take the free inodes we just allocated for our caller.
> +	 */
> +	xfs_trans_bhold(tp, agibp);
> +
> +	/*
> +	 * We want the quota changes to be associated with the next transaction,
> +	 * NOT this one. So, detach the dqinfo from this and attach it to the
> +	 * next transaction.
> +	 */
> +	if (tp->t_dqinfo) {
> +		dqinfo = tp->t_dqinfo;
> +		tp->t_dqinfo = NULL;
> +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> +		tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
> +	}
> +
> +	error = xfs_trans_roll(&tp);
> +
> +	/* Re-attach the quota info that we detached from prev trx. */
> +	if (dqinfo) {
> +		tp->t_dqinfo = dqinfo;
> +		tp->t_flags |= tflags;
> +	}
> +
> +	*tpp = tp;
> +	if (error) {
> +		xfs_buf_relse(agibp);
> +		return error;
> +	}
> +	xfs_trans_bjoin(tp, agibp);
> +	return 0;
> +}
> +
>  /*
> - * Allocate an inode on disk.
> + * Select and prepare an AG for inode allocation.
>   *
> - * Mode is used to tell whether the new inode will need space, and whether it
> - * is a directory.
> + * Mode is used to tell whether the new inode is a directory and hence where to
> + * locate it.
>   *
> - * This function is designed to be called twice if it has to do an allocation
> - * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
> - * If an inode is available without having to performn an allocation, an inode
> - * number is returned.  In this case, *IO_agbp is set to NULL.  If an allocation
> - * needs to be done, xfs_dialloc returns the current AGI buffer in *IO_agbp.
> - * The caller should then commit the current transaction, allocate a
> - * new transaction, and call xfs_dialloc() again, passing in the previous value
> - * of *IO_agbp.  IO_agbp should be held across the transactions. Since the AGI
> - * buffer is locked across the two calls, the second call is guaranteed to have
> - * a free inode available.
> - *
> - * Once we successfully pick an inode its number is returned and the on-disk
> - * data structures are updated.  The inode itself is not read in, since doing so
> - * would break ordering constraints with xfs_reclaim.
> + * This function will ensure that the selected AG has free inodes available to
> + * allocate from. The selected AGI will be returned locked to the caller, and it
> + * will allocate more free inodes if required. If no free inodes are found or
> + * can be allocated, no AGI will be returned.
>   */
>  int
> -xfs_dialloc(
> -	struct xfs_trans	*tp,
> +xfs_dialloc_select_ag(
> +	struct xfs_trans	**tpp,
>  	xfs_ino_t		parent,
>  	umode_t			mode,
> -	struct xfs_buf		**IO_agbp,
> -	xfs_ino_t		*inop)
> +	struct xfs_buf		**IO_agbp)
>  {
> +	struct xfs_trans	*tp = *tpp;
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
> @@ -1722,25 +1757,10 @@ xfs_dialloc(
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	int			okalloc = 1;
>  
> -	if (*IO_agbp) {
> -		/*
> -		 * If the caller passes in a pointer to the AGI buffer,
> -		 * continue where we left off before.  In this case, we
> -		 * know that the allocation group has free inodes.
> -		 */
> -		agbp = *IO_agbp;
> -		goto out_alloc;
> -	}
> -
> -	/*
> -	 * We do not have an agbp, so select an initial allocation
> -	 * group for inode allocation.
> -	 */
> +	*IO_agbp = NULL;
>  	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
> -	if (start_agno == NULLAGNUMBER) {
> -		*inop = NULLFSINO;
> +	if (start_agno == NULLAGNUMBER)
>  		return 0;
> -	}
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> @@ -1773,7 +1793,7 @@ xfs_dialloc(
>  		if (!pag->pagi_init) {
>  			error = xfs_ialloc_pagi_init(mp, tp, agno);
>  			if (error)
> -				goto out_error;
> +				break;
>  		}
>  
>  		/*
> @@ -1788,11 +1808,12 @@ xfs_dialloc(
>  		 */
>  		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
>  		if (error)
> -			goto out_error;
> +			break;
>  
>  		if (pag->pagi_freecount) {
>  			xfs_perag_put(pag);
> -			goto out_alloc;
> +			*IO_agbp = agbp;
> +			return 0;
>  		}
>  
>  		if (!okalloc)
> @@ -1802,46 +1823,39 @@ xfs_dialloc(
>  		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
>  		if (error) {
>  			xfs_trans_brelse(tp, agbp);
> -
>  			if (error != -ENOSPC)
> -				goto out_error;
> -
> -			xfs_perag_put(pag);
> -			*inop = NULLFSINO;
> -			return 0;
> +				break;
>  		}
>  
>  		if (ialloced) {
>  			/*
> -			 * We successfully allocated some inodes, return
> -			 * the current context to the caller so that it
> -			 * can commit the current transaction and call
> -			 * us again where we left off.
> +			 * We successfully allocated some inodes, so roll the
> +			 * transaction and return the locked AGI buffer to the
> +			 * caller so they can allocate one of the free inodes we
> +			 * just prepared for them.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
>  			xfs_perag_put(pag);
>  
> +			error = xfs_dialloc_roll(&tp, agbp);
> +			*tpp = tp;
> +			if (error)
> +				return error;
>  			*IO_agbp = agbp;
> -			*inop = NULLFSINO;
>  			return 0;
>  		}
>  
>  nextag_relse_buffer:
> -		xfs_trans_brelse(tp, agbp);
> +		xfs_trans_brelse(*tpp, agbp);
>  nextag:
>  		xfs_perag_put(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno) {
> -			*inop = NULLFSINO;
>  			return noroom ? -ENOSPC : 0;
>  		}
>  	}
>  
> -out_alloc:
> -	*IO_agbp = NULL;
> -	return xfs_dialloc_ag(tp, agbp, parent, inop);
> -out_error:
>  	xfs_perag_put(pag);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 72b3468b97b1..d8de4b9f6603 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -37,30 +37,26 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>   * Mode is used to tell whether the new inode will need space, and whether
>   * it is a directory.
>   *
> - * To work within the constraint of one allocation per transaction,
> - * xfs_dialloc() is designed to be called twice if it has to do an
> - * allocation to make more free inodes.  If an inode is
> - * available without an allocation, agbp would be set to the current
> - * agbp and alloc_done set to false.
> - * If an allocation needed to be done, agbp would be set to the
> - * inode header of the allocation group and alloc_done set to true.
> - * The caller should then commit the current transaction and allocate a new
> - * transaction.  xfs_dialloc() should then be called again with
> - * the agbp value returned from the previous call.
> - *
> - * Once we successfully pick an inode its number is returned and the
> - * on-disk data structures are updated.  The inode itself is not read
> - * in, since doing so would break ordering constraints with xfs_reclaim.
> - *
> - * *agbp should be set to NULL on the first call, *alloc_done set to FALSE.
> + * There are two phases to inode allocation: selecting an AG and ensuring
> + * that it contains free inodes, followed by allocating one of the free
> + * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
> + * to the caller, ensuring that followup call to xfs_dialloc_ag() will
> + * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
> + * number of the free inode we allocated.
>   */
> -int					/* error */
> -xfs_dialloc(
> -	struct xfs_trans *tp,		/* transaction pointer */
> -	xfs_ino_t	parent,		/* parent inode (directory) */
> -	umode_t		mode,		/* mode bits for new inode */
> -	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
> -	xfs_ino_t	*inop);		/* inode number allocated */
> +int
> +xfs_dialloc_select_ag(
> +	struct xfs_trans	**tpp,
> +	xfs_ino_t		parent,
> +	umode_t			mode,
> +	struct xfs_buf		**agibp);
> +
> +int
> +xfs_dialloc_ag(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_ino_t		parent,
> +	xfs_ino_t		*inop);
>  
>  /*
>   * Free disk inode.  Carefully avoids touching the incore inode, all
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..2a06ca4dee2b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -761,68 +761,28 @@ xfs_inode_inherit_flags2(
>  }
>  
>  /*
> - * Allocate an inode on disk and return a copy of its in-core version.
> - * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
> - * appropriately within the inode.  The uid and gid for the inode are
> - * set according to the contents of the given cred structure.
> - *
> - * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
> - * has a free inode available, call xfs_iget() to obtain the in-core
> - * version of the allocated inode.  Finally, fill in the inode and
> - * log its initial contents.  In this case, ialloc_context would be
> - * set to NULL.
> - *
> - * If xfs_dialloc() does not have an available inode, it will replenish
> - * its supply by doing an allocation. Since we can only do one
> - * allocation within a transaction without deadlocks, we must commit
> - * the current transaction before returning the inode itself.
> - * In this case, therefore, we will set ialloc_context and return.
> - * The caller should then commit the current transaction, start a new
> - * transaction, and call xfs_ialloc() again to actually get the inode.
> - *
> - * To ensure that some other process does not grab the inode that
> - * was allocated during the first call to xfs_ialloc(), this routine
> - * also returns the [locked] bp pointing to the head of the freelist
> - * as ialloc_context.  The caller should hold this buffer across
> - * the commit and pass it back into this routine on the second call.
> - *
> - * If we are allocating quota inodes, we do not have a parent inode
> - * to attach to or associate with (i.e. pip == NULL) because they
> - * are not linked into the directory structure - they are attached
> - * directly to the superblock - and so have no parent.
> + * Initialise a newly allocated inode and return the in-core inode to the
> + * caller locked exclusively.
>   */
>  static int
>  xfs_ialloc(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*pip,
> -	umode_t		mode,
> -	xfs_nlink_t	nlink,
> -	dev_t		rdev,
> -	prid_t		prid,
> -	xfs_buf_t	**ialloc_context,
> -	xfs_inode_t	**ipp)
> -{
> -	struct xfs_mount *mp = tp->t_mountp;
> -	xfs_ino_t	ino;
> -	xfs_inode_t	*ip;
> -	uint		flags;
> -	int		error;
> -	struct timespec64 tv;
> -	struct inode	*inode;
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*pip,
> +	umode_t			mode,
> +	xfs_nlink_t		nlink,
> +	dev_t			rdev,
> +	prid_t			prid,
> +	struct xfs_inode	**ipp)
> +{
> +	struct xfs_mount	 *mp = tp->t_mountp;
> +	struct xfs_inode	*ip;
> +	xfs_ino_t		ino;
> +	uint			flags;
> +	int			error;
> +	struct timespec64	tv;
> +	struct inode		*inode;
>  
> -	/*
> -	 * Call the space management code to pick
> -	 * the on-disk inode to be allocated.
> -	 */
> -	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
> -			    ialloc_context, &ino);
> -	if (error)
> -		return error;
> -	if (*ialloc_context || ino == NULLFSINO) {
> -		*ipp = NULL;
> -		return 0;
> -	}
> -	ASSERT(*ialloc_context == NULL);
> +	*ipp = NULL;
>  
>  	/*
>  	 * Protect against obviously corrupt allocation btree records. Later
> @@ -837,12 +797,10 @@ xfs_ialloc(
>  	}
>  
>  	/*
> -	 * Get the in-core inode with the lock held exclusively.
> -	 * This is because we're setting fields here we need
> -	 * to prevent others from looking at until we're done.
> +	 * Get the in-core inode with the lock held exclusively to prevent
> +	 * others from looking at until we're done.
>  	 */
> -	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
> -			 XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
>  	if (error)
>  		return error;
>  	ASSERT(ip != NULL);
> @@ -932,142 +890,57 @@ xfs_ialloc(
>  }
>  
>  /*
> - * Allocates a new inode from disk and return a pointer to the
> - * incore copy. This routine will internally commit the current
> - * transaction and allocate a new one if the Space Manager needed
> - * to do an allocation to replenish the inode free-list.
> - *
> - * This routine is designed to be called from xfs_create and
> - * xfs_create_dir.
> + * Allocates a new inode from disk and return a pointer to the incore copy. This
> + * routine will internally commit the current transaction and allocate a new one
> + * if we needed to allocate more on-disk free inodes to perform the requested
> + * operation.
>   *
> + * If we are allocating quota inodes, we do not have a parent inode to attach to
> + * or associate with (i.e. dp == NULL) because they are not linked into the
> + * directory structure - they are attached directly to the superblock - and so
> + * have no parent.
>   */
>  int
>  xfs_dir_ialloc(
> -	xfs_trans_t	**tpp,		/* input: current transaction;
> -					   output: may be a new transaction. */
> -	xfs_inode_t	*dp,		/* directory within whose allocate
> -					   the inode. */
> -	umode_t		mode,
> -	xfs_nlink_t	nlink,
> -	dev_t		rdev,
> -	prid_t		prid,		/* project id */
> -	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> -					   locked. */
> -{
> -	xfs_trans_t	*tp;
> -	xfs_inode_t	*ip;
> -	xfs_buf_t	*ialloc_context = NULL;
> -	int		code;
> -	void		*dqinfo;
> -	uint		tflags;
> -
> -	tp = *tpp;
> -	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +	struct xfs_trans	**tpp,
> +	struct xfs_inode	*dp,
> +	umode_t			mode,
> +	xfs_nlink_t		nlink,
> +	dev_t			rdev,
> +	prid_t			prid,
> +	struct xfs_inode	**ipp)
> +{
> +	struct xfs_buf		*agibp = NULL;
> +	xfs_ino_t		pino = dp ? dp->i_ino : 0;
> +	xfs_ino_t		ino;
> +	int			error;
>  
> -	/*
> -	 * xfs_ialloc will return a pointer to an incore inode if
> -	 * the Space Manager has an available inode on the free
> -	 * list. Otherwise, it will do an allocation and replenish
> -	 * the freelist.  Since we can only do one allocation per
> -	 * transaction without deadlocks, we will need to commit the
> -	 * current transaction and start a new one.  We will then
> -	 * need to call xfs_ialloc again to get the inode.
> -	 *
> -	 * If xfs_ialloc did an allocation to replenish the freelist,
> -	 * it returns the bp containing the head of the freelist as
> -	 * ialloc_context. We will hold a lock on it across the
> -	 * transaction commit so that no other process can steal
> -	 * the inode(s) that we've just allocated.
> -	 */
> -	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
> -			&ip);
> +	ASSERT(*tpp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	/*
> -	 * Return an error if we were unable to allocate a new inode.
> -	 * This should only happen if we run out of space on disk or
> -	 * encounter a disk error.
> +	 * Call the space management code to pick the on-disk inode to be
> +	 * allocated.
>  	 */
> -	if (code) {
> -		*ipp = NULL;
> -		return code;
> -	}
> -	if (!ialloc_context && !ip) {
> +	error = xfs_dialloc_select_ag(tpp, pino, mode, &agibp);
> +	if (error)
> +		return error;
> +	if (!agibp) {
>  		*ipp = NULL;
> -		return -ENOSPC;
> +		return 0;
>  	}
>  
> -	/*
> -	 * If the AGI buffer is non-NULL, then we were unable to get an
> -	 * inode in one operation.  We need to commit the current
> -	 * transaction and call xfs_ialloc() again.  It is guaranteed
> -	 * to succeed the second time.
> -	 */
> -	if (ialloc_context) {
> -		/*
> -		 * Normally, xfs_trans_commit releases all the locks.
> -		 * We call bhold to hang on to the ialloc_context across
> -		 * the commit.  Holding this buffer prevents any other
> -		 * processes from doing any allocations in this
> -		 * allocation group.
> -		 */
> -		xfs_trans_bhold(tp, ialloc_context);
> -
> -		/*
> -		 * We want the quota changes to be associated with the next
> -		 * transaction, NOT this one. So, detach the dqinfo from this
> -		 * and attach it to the next transaction.
> -		 */
> -		dqinfo = NULL;
> -		tflags = 0;
> -		if (tp->t_dqinfo) {
> -			dqinfo = (void *)tp->t_dqinfo;
> -			tp->t_dqinfo = NULL;
> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
> -		}
> -
> -		code = xfs_trans_roll(&tp);
> -
> -		/*
> -		 * Re-attach the quota info that we detached from prev trx.
> -		 */
> -		if (dqinfo) {
> -			tp->t_dqinfo = dqinfo;
> -			tp->t_flags |= tflags;
> -		}
> -
> -		if (code) {
> -			xfs_buf_relse(ialloc_context);
> -			*tpp = tp;
> -			*ipp = NULL;
> -			return code;
> -		}
> -		xfs_trans_bjoin(tp, ialloc_context);
> -
> -		/*
> -		 * Call ialloc again. Since we've locked out all
> -		 * other allocations in this allocation group,
> -		 * this call should always succeed.
> -		 */
> -		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  &ialloc_context, &ip);
> -
> -		/*
> -		 * If we get an error at this point, return to the caller
> -		 * so that the current transaction can be aborted.
> -		 */
> -		if (code) {
> -			*tpp = tp;
> -			*ipp = NULL;
> -			return code;
> -		}
> -		ASSERT(!ialloc_context && ip);
> +	/* Allocate an inode from the selected AG */
> +	error = xfs_dialloc_ag(*tpp, agibp, pino, &ino);
> +	if (error)
> +		return error;
> +	ASSERT(ino != NULLFSINO);
>  
> +	/* Initialise the newly allocated inode. */
> +	error = xfs_ialloc(*tpp, dp, mode, nlink, rdev, prid, ipp);
> +	if (error) {
> +		*ipp = NULL;
> +		return error;
>  	}
> -
> -	*ipp = ip;
> -	*tpp = tp;
> -
>  	return 0;
>  }
>  
> 


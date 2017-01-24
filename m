Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdAXV2w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 16:28:52 -0500
Date: Tue, 24 Jan 2017 15:28:49 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2] xfs: do not call xfs_buf_hash_destroy on a NULL pag
Message-ID: <20170124212849.GA25543@redhat.com>
References: <20170120142642.21698-1-colin.king@canonical.com>
 <20170124210848.26179-1-billodo@redhat.com>
 <20170124212155.GE9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124212155.GE9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 01:21:55PM -0800, Darrick J. Wong wrote:
> You might want to cc the maintainer. ;)

will do on v3 ;)

> 
> On Tue, Jan 24, 2017 at 03:08:48PM -0600, Bill O'Donnell wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > If pag cannot be allocated, the current error exit path will trip
> > a null pointer deference error when calling xfs_buf_hash_destroy
> > with a null pag.  Fix this by adding a new error exit lable and
> > jumping to this, avoiding the hash destroy and unnecessary kmem_free
> > on pag.
> > 
> > Fixes CoverityScan CID#1397628 ("Dereference after null check")
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > 
> > ------------
> > v2: correct error exit in xfs_initialize_perag() to properly unwind
> >     pags if error encountered.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 9b9540d..67bb6f2 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -187,9 +187,10 @@ xfs_initialize_perag(
> >  	xfs_agnumber_t	*maxagi)
> >  {
> >  	xfs_agnumber_t	index;
> > -	xfs_agnumber_t	first_initialised = 0;
> > +	xfs_agnumber_t	last_valid_agindex = 0;
> >  	xfs_perag_t	*pag;
> >  	int		error = -ENOMEM;
> > +	int		i;
> >  
> >  	/*
> >  	 * Walk the current per-ag tree so we don't try to initialise AGs
> > @@ -197,17 +198,16 @@ xfs_initialize_perag(
> >  	 * AGs we don't find ready for initialisation.
> >  	 */
> >  	for (index = 0; index < agcount; index++) {
> > +		last_valid_agindex = index;
> >  		pag = xfs_perag_get(mp, index);
> >  		if (pag) {
> >  			xfs_perag_put(pag);
> >  			continue;
> >  		}
> > -		if (!first_initialised)
> > -			first_initialised = index;
> >  
> >  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> >  		if (!pag)
> > -			goto out_unwind;
> > +			goto out_unwind_pags;
> >  		pag->pag_agno = index;
> >  		pag->pag_mount = mp;
> >  		spin_lock_init(&pag->pag_ici_lock);
> > @@ -242,8 +242,11 @@ xfs_initialize_perag(
> >  out_unwind:
> >  	xfs_buf_hash_destroy(pag);
> >  	kmem_free(pag);
> > -	for (; index > first_initialised; index--) {
> > -		pag = radix_tree_delete(&mp->m_perag_tree, index);
> > +out_unwind_pags:
> > +	for (i = last_valid_agindex; i >= 0; i--) {
> 
> xfs_initialize_perag can be called towards the end of a growfs operation
> to initialize the perag structures for the new AGs.  If the
> initialization fails, we want to roll back to the number of AGs we had
> before, which means that we cannot delete the perag structures for the
> not-recently-created AGs.  That (I think) was what first_initialised was
> trying to do (though it does't do that correctly in the case that we're
> mounting).

Yep, I need to reinstate first_initialized and use it.

Thanks-
Bill


> 
> Also, you could start the loop with "index - 1", right?
> 
> --D
> 
> > +		pag = radix_tree_delete(&mp->m_perag_tree, (xfs_agnumber_t)i);
> > +		if (!pag)
> > +			break;
> >  		xfs_buf_hash_destroy(pag);
> >  		kmem_free(pag);
> >  	}
> > -- 
> > 2.9.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

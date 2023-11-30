Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED9E55C09
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4XnKFEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4B6C433C7;
	Thu, 30 Nov 2023 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701364746;
	bh=IIP8JbOSSY5BVGQyvimwoV+1TjORXZrroVYix3xN6J4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U4XnKFEsbP9/EIJw73c+PGSqA2WADr18w3eOzEv5Fxl4LGB+122zRJb0P36w2j8Op
	 MRZlBeEsKQjBVA13URvFywuUVF1HwvncQGXWGIRWXGgE/Fzs7zqRqkOA3Zvua8E+Tz
	 GFS6uPJ5+UsWnfw80M4E5m5zUjsWxfqX9AQZYGQVQmsk4WCy8cx3gwg3JFKY3p9Fu7
	 qDAxg3H/tJpg3ZemlnkrMtukuZ8yCLT9B/Z2DOxcYVpCNi1HjwdMLWNaYj2tstLgSr
	 h+Z3aeQRGi97QnGXt9pJnWCXGxJIui/T7sMt62+CIKB50MZFdyYH7GgAnzZGjE7z7t
	 Oi/OfzrPdOhVg==
Date: Thu, 30 Nov 2023 09:19:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org, hch@lst.de
Subject: Re: [PATCH 5/7] xfs: recreate work items when recovering intent items
Message-ID: <20231130171905.GJ361584@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
 <20231130131315.GA1772751@ceph-admin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231130131315.GA1772751@ceph-admin>

On Thu, Nov 30, 2023 at 09:13:15PM +0800, Long Li wrote:
> On Tue, Nov 28, 2023 at 12:26:57PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Recreate work items for each xfs_defer_pending object when we are
> > recovering intent items.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_defer.h  |    9 ++++
> >  fs/xfs/xfs_attr_item.c     |   94 +++++++++++++++++++++----------------
> >  fs/xfs/xfs_bmap_item.c     |   56 ++++++++++++++--------
> >  fs/xfs/xfs_extfree_item.c  |   50 ++++++++++++-------
> >  fs/xfs/xfs_refcount_item.c |   61 +++++++++++-------------
> >  fs/xfs/xfs_rmap_item.c     |  113 ++++++++++++++++++++++++--------------------
> >  6 files changed, 221 insertions(+), 162 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 3c923a728323..ee1e76d3f7e8 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -130,6 +130,15 @@ struct xfs_defer_pending *xfs_defer_start_recovery(struct xfs_log_item *lip,
> >  void xfs_defer_cancel_recovery(struct xfs_mount *mp,
> >  		struct xfs_defer_pending *dfp);
> >  
> > +static inline void
> > +xfs_defer_recover_work_item(
> > +	struct xfs_defer_pending	*dfp,
> > +	struct list_head		*work)
> > +{
> > +	list_add_tail(work, &dfp->dfp_work);
> > +	dfp->dfp_count++;
> > +}
> > +
> >  int __init xfs_defer_init_item_caches(void);
> >  void xfs_defer_destroy_item_caches(void);
> >  
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 82775e9537df..fbc88325848a 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -539,47 +539,22 @@ xfs_attri_validate(
> >  	return xfs_verify_ino(mp, attrp->alfi_ino);
> >  }
> >  
> > -/*
> > - * Process an attr intent item that was recovered from the log.  We need to
> > - * delete the attr that it describes.
> > - */
> > -STATIC int
> > -xfs_attri_item_recover(
> > +static inline struct xfs_attr_intent *
> > +xfs_attri_recover_work(
> > +	struct xfs_mount		*mp,
> >  	struct xfs_defer_pending	*dfp,
> > -	struct list_head		*capture_list)
> > +	struct xfs_attri_log_format	*attrp,
> > +	struct xfs_inode		*ip,
> > +	struct xfs_attri_log_nameval	*nv)
> >  {
> > -	struct xfs_log_item		*lip = dfp->dfp_intent;
> > -	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> >  	struct xfs_attr_intent		*attr;
> > -	struct xfs_mount		*mp = lip->li_log->l_mp;
> > -	struct xfs_inode		*ip;
> >  	struct xfs_da_args		*args;
> > -	struct xfs_trans		*tp;
> > -	struct xfs_trans_res		resv;
> > -	struct xfs_attri_log_format	*attrp;
> > -	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
> > -	int				error;
> > -	int				total;
> > -	int				local;
> > -	struct xfs_attrd_log_item	*done_item = NULL;
> > -
> > -	/*
> > -	 * First check the validity of the attr described by the ATTRI.  If any
> > -	 * are bad, then assume that all are bad and just toss the ATTRI.
> > -	 */
> > -	attrp = &attrip->attri_format;
> > -	if (!xfs_attri_validate(mp, attrp) ||
> > -	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
> > -		return -EFSCORRUPTED;
> > -
> > -	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> > -	if (error)
> > -		return error;
> >  
> >  	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
> >  			   sizeof(struct xfs_da_args), KM_NOFS);
> >  	args = (struct xfs_da_args *)(attr + 1);
> >  
> > +	INIT_LIST_HEAD(&attr->xattri_list);
> >  	attr->xattri_da_args = args;
> >  	attr->xattri_op_flags = attrp->alfi_op_flags &
> >  						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
> > @@ -607,6 +582,8 @@ xfs_attri_item_recover(
> >  	switch (attr->xattri_op_flags) {
> >  	case XFS_ATTRI_OP_FLAGS_SET:
> >  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> > +		int			local;
> > +
> >  		args->value = nv->value.i_addr;
> >  		args->valuelen = nv->value.i_len;
> >  		args->total = xfs_attr_calc_size(args, &local);
>  
> When I compile the kernel with this set of patches, I get the following error:
> 
> fs/xfs/xfs_attr_item.c: In function ‘xfs_attri_recover_work’:                                            
> fs/xfs/xfs_attr_item.c:585:3: error: a label can only be part of a statement and a declaration is not a statement
>   585 |   int   local;                                                                                   
>       |   ^~~ 

Yeah, the build bots complained about my ham-handed attempt to reduce
variable scope as well.  Oddly, gcc 12.2 doesn't seem to mind it.  That
error message is puzzling.

--D

> Thanks,
> Long Li
> 
> 

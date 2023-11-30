Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C5DD6C
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 05:09:26 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SgxMp3pkszWhpW;
	Thu, 30 Nov 2023 21:08:38 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 Nov
 2023 21:09:23 +0800
Date: Thu, 30 Nov 2023 21:13:15 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <chandanbabu@kernel.org>, <hch@lst.de>
Subject: Re: [PATCH 5/7] xfs: recreate work items when recovering intent items
Message-ID: <20231130131315.GA1772751@ceph-admin>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected

On Tue, Nov 28, 2023 at 12:26:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Recreate work items for each xfs_defer_pending object when we are
> recovering intent items.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_defer.h  |    9 ++++
>  fs/xfs/xfs_attr_item.c     |   94 +++++++++++++++++++++----------------
>  fs/xfs/xfs_bmap_item.c     |   56 ++++++++++++++--------
>  fs/xfs/xfs_extfree_item.c  |   50 ++++++++++++-------
>  fs/xfs/xfs_refcount_item.c |   61 +++++++++++-------------
>  fs/xfs/xfs_rmap_item.c     |  113 ++++++++++++++++++++++++--------------------
>  6 files changed, 221 insertions(+), 162 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 3c923a728323..ee1e76d3f7e8 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -130,6 +130,15 @@ struct xfs_defer_pending *xfs_defer_start_recovery(struct xfs_log_item *lip,
>  void xfs_defer_cancel_recovery(struct xfs_mount *mp,
>  		struct xfs_defer_pending *dfp);
>  
> +static inline void
> +xfs_defer_recover_work_item(
> +	struct xfs_defer_pending	*dfp,
> +	struct list_head		*work)
> +{
> +	list_add_tail(work, &dfp->dfp_work);
> +	dfp->dfp_count++;
> +}
> +
>  int __init xfs_defer_init_item_caches(void);
>  void xfs_defer_destroy_item_caches(void);
>  
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 82775e9537df..fbc88325848a 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -539,47 +539,22 @@ xfs_attri_validate(
>  	return xfs_verify_ino(mp, attrp->alfi_ino);
>  }
>  
> -/*
> - * Process an attr intent item that was recovered from the log.  We need to
> - * delete the attr that it describes.
> - */
> -STATIC int
> -xfs_attri_item_recover(
> +static inline struct xfs_attr_intent *
> +xfs_attri_recover_work(
> +	struct xfs_mount		*mp,
>  	struct xfs_defer_pending	*dfp,
> -	struct list_head		*capture_list)
> +	struct xfs_attri_log_format	*attrp,
> +	struct xfs_inode		*ip,
> +	struct xfs_attri_log_nameval	*nv)
>  {
> -	struct xfs_log_item		*lip = dfp->dfp_intent;
> -	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>  	struct xfs_attr_intent		*attr;
> -	struct xfs_mount		*mp = lip->li_log->l_mp;
> -	struct xfs_inode		*ip;
>  	struct xfs_da_args		*args;
> -	struct xfs_trans		*tp;
> -	struct xfs_trans_res		resv;
> -	struct xfs_attri_log_format	*attrp;
> -	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
> -	int				error;
> -	int				total;
> -	int				local;
> -	struct xfs_attrd_log_item	*done_item = NULL;
> -
> -	/*
> -	 * First check the validity of the attr described by the ATTRI.  If any
> -	 * are bad, then assume that all are bad and just toss the ATTRI.
> -	 */
> -	attrp = &attrip->attri_format;
> -	if (!xfs_attri_validate(mp, attrp) ||
> -	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
> -		return -EFSCORRUPTED;
> -
> -	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> -	if (error)
> -		return error;
>  
>  	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
>  			   sizeof(struct xfs_da_args), KM_NOFS);
>  	args = (struct xfs_da_args *)(attr + 1);
>  
> +	INIT_LIST_HEAD(&attr->xattri_list);
>  	attr->xattri_da_args = args;
>  	attr->xattri_op_flags = attrp->alfi_op_flags &
>  						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
> @@ -607,6 +582,8 @@ xfs_attri_item_recover(
>  	switch (attr->xattri_op_flags) {
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +		int			local;
> +
>  		args->value = nv->value.i_addr;
>  		args->valuelen = nv->value.i_len;
>  		args->total = xfs_attr_calc_size(args, &local);
 
When I compile the kernel with this set of patches, I get the following error:

fs/xfs/xfs_attr_item.c: In function ‘xfs_attri_recover_work’:                                            
fs/xfs/xfs_attr_item.c:585:3: error: a label can only be part of a statement and a declaration is not a statement
  585 |   int   local;                                                                                   
      |   ^~~ 

Thanks,
Long Li


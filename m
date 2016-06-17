Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D8A87CEE
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:59:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6400AC004
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:59:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Wj0ixaizj5BbezjP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:59:32 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:59:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 009/119] xfs: convert list of extents to free into a
	regular list
Message-ID: <20160617115930.GH19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

>  {
> +	struct xfs_bmap_free_item	*new;		/* new element */
>  #ifdef DEBUG
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
> @@ -597,17 +595,7 @@ xfs_bmap_add_free(
>  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
>  	new->xbfi_startblock = bno;
>  	new->xbfi_blockcount = (xfs_extlen_t)len;
> +	list_add(&new->xbfi_list, &flist->xbf_flist);
>  	flist->xbf_count++;

Please kill xbf_count while you're at it, it's entirely superflous.

> @@ -617,14 +605,10 @@ xfs_bmap_add_free(
>   */
>  void
>  xfs_bmap_del_free(
> -	xfs_bmap_free_t		*flist,	/* free item list header */
> -	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
> -	xfs_bmap_free_item_t	*free)	/* list item to be freed */
> +	struct xfs_bmap_free		*flist,	/* free item list header */
> +	struct xfs_bmap_free_item	*free)	/* list item to be freed */

Which then also gets rid of the flist argument here.

> @@ -634,17 +618,16 @@ xfs_bmap_del_free(
>   */
>  void
>  xfs_bmap_cancel(
> +	struct xfs_bmap_free		*flist)	/* list of bmap_free_items */
>  {
> +	struct xfs_bmap_free_item	*free;	/* free list item */
>  
>  	if (flist->xbf_count == 0)
>  		return;
> +	while (!list_empty(&flist->xbf_flist)) {
> +		free = list_first_entry(&flist->xbf_flist,
> +				struct xfs_bmap_free_item, xbfi_list);

	while ((free = list_first_entry_or_null(...))

> +	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);

Can you add a comment on why we are sorting the list?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

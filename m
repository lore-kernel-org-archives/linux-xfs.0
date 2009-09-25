Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8PEedks170150 for <xfs@oss.sgi.com>; Fri, 25 Sep 2009 09:40:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC83FB777B9
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2009 07:41:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FRZEBEFYlEkIDAmF for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2009 07:41:57 -0700 (PDT)
Message-ID: <4ABCD6B3.8070901@sandeen.net>
Date: Fri, 25 Sep 2009 09:41:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] repair: replaced custom block allocation linked lists
	with	list_heads
References: <4AB300CC.5020707@sandeen.net> <4AB312A3.6000403@sandeen.net>
	<20090918051944.GA12914@josefsipek.net>
In-Reply-To: <20090918051944.GA12914@josefsipek.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> The previous implementation of the linked lists was buggy, and leaked memory.
> 
> From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> 
> Cc: sandeen@sandeen.net
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Yeah, ok, this looks better to me.  I just had to rise to the challenge
of fixing it as it was written, I guess ;)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
> 
> Yes, Eric, it wastes an extra pointer per node, but at least it works
> compared to the code it replaces :)
> 
>  repair/incore.c     |   27 ---------------------------
>  repair/incore.h     |   11 -----------
>  repair/incore_ext.c |   27 ++++++++++++++++-----------
>  3 files changed, 16 insertions(+), 49 deletions(-)
> 
> diff --git a/repair/incore.c b/repair/incore.c
> index 84626c9..27604e2 100644
> --- a/repair/incore.c
> +++ b/repair/incore.c
> @@ -25,33 +25,6 @@
>  #include "err_protos.h"
>  #include "threads.h"
>  
> -/*
> - * push a block allocation record onto list.  assumes list
> - * if set to NULL if empty.
> - */
> -void
> -record_allocation(ba_rec_t *addr, ba_rec_t *list)
> -{
> -	addr->next = list;
> -	list = addr;
> -
> -	return;
> -}
> -
> -void
> -free_allocations(ba_rec_t *list)
> -{
> -	ba_rec_t *current = list;
> -
> -	while (list != NULL)  {
> -		list = list->next;
> -		free(current);
> -		current = list;
> -	}
> -
> -	return;
> -}
> -
>  /* ba bmap setupstuff.  setting/getting state is in incore.h  */
>  
>  void
> diff --git a/repair/incore.h b/repair/incore.h
> index 1f0f45a..a22ef0f 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -26,17 +26,6 @@
>   */
>  
>  /*
> - * block allocation lists
> - */
> -typedef struct ba_rec  {
> -	void		*addr;
> -	struct ba_rec	*next;
> -} ba_rec_t;
> -
> -void			record_allocation(ba_rec_t *addr, ba_rec_t *list);
> -void			free_allocations(ba_rec_t *list);
> -
> -/*
>   * block bit map defs -- track state of each filesystem block.
>   * ba_bmap is an array of bitstrings declared in the globals.h file.
>   * the bitstrings are broken up into 64-bit chunks.  one bitstring per AG.
> diff --git a/repair/incore_ext.c b/repair/incore_ext.c
> index a2acbf4..d0b8cdc 100644
> --- a/repair/incore_ext.c
> +++ b/repair/incore_ext.c
> @@ -31,12 +31,12 @@
>   * paranoia -- account for any weird padding, 64/32-bit alignment, etc.
>   */
>  typedef struct extent_alloc_rec  {
> -	ba_rec_t		alloc_rec;
> +	struct list_head	list;
>  	extent_tree_node_t	extents[ALLOC_NUM_EXTS];
>  } extent_alloc_rec_t;
>  
>  typedef struct rt_extent_alloc_rec  {
> -	ba_rec_t		alloc_rec;
> +	struct list_head	list;
>  	rt_extent_tree_node_t	extents[ALLOC_NUM_EXTS];
>  } rt_extent_alloc_rec_t;
>  
> @@ -89,8 +89,8 @@ static avltree_desc_t	**extent_bcnt_ptrs;	/*
>  /*
>   * list of allocated "blocks" for easy freeing later
>   */
> -static ba_rec_t		*ba_list;
> -static ba_rec_t		*rt_ba_list;
> +static struct list_head	ba_list;
> +static struct list_head	rt_ba_list;
>  
>  /*
>   * locks.
> @@ -120,7 +120,7 @@ mk_extent_tree_nodes(xfs_agblock_t new_startblock,
>  			do_error(
>  			_("couldn't allocate new extent descriptors.\n"));
>  
> -		record_allocation(&rec->alloc_rec, ba_list);
> +		list_add(&rec->list, &ba_list);
>  
>  		new = &rec->extents[0];
>  
> @@ -678,7 +678,7 @@ mk_rt_extent_tree_nodes(xfs_drtbno_t new_startblock,
>  			do_error(
>  			_("couldn't allocate new extent descriptors.\n"));
>  
> -		record_allocation(&rec->alloc_rec, rt_ba_list);
> +		list_add(&rec->list, &rt_ba_list);
>  
>  		new = &rec->extents[0];
>  
> @@ -755,12 +755,15 @@ release_rt_extent_tree()
>  void
>  free_rt_dup_extent_tree(xfs_mount_t *mp)
>  {
> +	rt_extent_alloc_rec_t *cur, *tmp;
> +
>  	ASSERT(mp->m_sb.sb_rblocks != 0);
>  
> -	free_allocations(rt_ba_list);
> +	list_for_each_entry_safe(cur, tmp, &rt_ba_list, list)
> +		free(cur);
> +
>  	free(rt_ext_tree_ptr);
>  
> -	rt_ba_list = NULL;
>  	rt_ext_tree_ptr = NULL;
>  
>  	return;
> @@ -895,8 +898,8 @@ incore_ext_init(xfs_mount_t *mp)
>  	int i;
>  	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
>  
> -	ba_list = NULL;
> -	rt_ba_list = NULL;
> +	list_head_init(&ba_list);
> +	list_head_init(&rt_ba_list);
>  	pthread_mutex_init(&ext_flist_lock, NULL);
>  	pthread_mutex_init(&rt_ext_tree_lock, NULL);
>  	pthread_mutex_init(&rt_ext_flist_lock, NULL);
> @@ -954,9 +957,11 @@ incore_ext_init(xfs_mount_t *mp)
>  void
>  incore_ext_teardown(xfs_mount_t *mp)
>  {
> +	extent_alloc_rec_t *cur, *tmp;
>  	xfs_agnumber_t i;
>  
> -	free_allocations(ba_list);
> +	list_for_each_entry_safe(cur, tmp, &ba_list, list)
> +		free(cur);
>  
>  	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
>  		free(extent_tree_ptrs[i]);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

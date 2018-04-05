Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbeDESND (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 14:13:03 -0400
Date: Thu, 5 Apr 2018 14:13:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: replace filestream item xfs_inode reference
 with xfs_mount
Message-ID: <20180405181300.GB417@bfoster.bfoster>
References: <20180405121147.60897-1-bfoster@redhat.com>
 <20180405121147.60897-2-bfoster@redhat.com>
 <20180405171842.GA4849@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405171842.GA4849@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 05, 2018 at 10:18:42AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 05, 2018 at 08:11:47AM -0400, Brian Foster wrote:
> > The obvious solution is to grab an inode reference for
> > xfs_fstrm_item. The filestream mechanism only actually uses the
> > inode pointer as a means to access the xfs_mount, however. Rather
> > than add unnecessary complexity, simplify the implementation to
> > store an xfs_mount pointer instead of the inode. This also requires
> > updates to the tracepoint class to provide the associated data via
> > parameters rather than the inode and a minor hack to peek at the MRU
> > key to establish the inode number at free time.
> 
> How about not replacing it all and just providing the context from
> the mru cache?  Something like the untested patch below:
> 

I actually considered something like this briefly but it initially
looked more involved than what you've come up with here. I think that I
just didn't consider storing the mp directly in the xfs_mru_cache so it
would be available to the reaper context. With that, this looks nicer to
me. I'll give it a whirl.. thanks!

Brian

> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 043ca3808ea2..5131a6e25fc9 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -34,7 +34,6 @@
>  
>  struct xfs_fstrm_item {
>  	struct xfs_mru_cache_elem	mru;
> -	struct xfs_inode		*ip;
>  	xfs_agnumber_t			ag; /* AG in use for this directory */
>  };
>  
> @@ -122,14 +121,15 @@ xfs_filestream_put_ag(
>  
>  static void
>  xfs_fstrm_free_func(
> +	void			*data,
>  	struct xfs_mru_cache_elem *mru)
>  {
> +	struct xfs_mount	*mp = data;
>  	struct xfs_fstrm_item	*item =
>  		container_of(mru, struct xfs_fstrm_item, mru);
>  
> -	xfs_filestream_put_ag(item->ip->i_mount, item->ag);
> -
> -	trace_xfs_filestream_free(item->ip, item->ag);
> +	xfs_filestream_put_ag(mp, item->ag);
> +	trace_xfs_filestream_free(mp, mru->key, item->ag);
>  
>  	kmem_free(item);
>  }
> @@ -165,7 +165,7 @@ xfs_filestream_pick_ag(
>  	trylock = XFS_ALLOC_FLAG_TRYLOCK;
>  
>  	for (nscan = 0; 1; nscan++) {
> -		trace_xfs_filestream_scan(ip, ag);
> +		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
>  
>  		pag = xfs_perag_get(mp, ag);
>  
> @@ -265,7 +265,6 @@ xfs_filestream_pick_ag(
>  		goto out_put_ag;
>  
>  	item->ag = *agp;
> -	item->ip = ip;
>  
>  	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
>  	if (err) {
> @@ -333,7 +332,7 @@ xfs_filestream_lookup_ag(
>  		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
>  		xfs_mru_cache_done(mp->m_filestream);
>  
> -		trace_xfs_filestream_lookup(ip, ag);
> +		trace_xfs_filestream_lookup(mp, ip->i_ino, ag);
>  		goto out;
>  	}
>  
> @@ -399,7 +398,7 @@ xfs_filestream_new_ag(
>  	 * Only free the item here so we skip over the old AG earlier.
>  	 */
>  	if (mru)
> -		xfs_fstrm_free_func(mru);
> +		xfs_fstrm_free_func(mp, mru);
>  
>  	IRELE(pip);
>  exit:
> @@ -426,8 +425,8 @@ xfs_filestream_mount(
>  	 * timer tunable to within about 10 percent.  This requires at least 10
>  	 * groups.
>  	 */
> -	return xfs_mru_cache_create(&mp->m_filestream, xfs_fstrm_centisecs * 10,
> -				    10, xfs_fstrm_free_func);
> +	return xfs_mru_cache_create(&mp->m_filestream, mp,
> +			xfs_fstrm_centisecs * 10, 10, xfs_fstrm_free_func);
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index f8a674d7f092..70eea7ae2876 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -112,6 +112,7 @@ struct xfs_mru_cache {
>  	xfs_mru_cache_free_func_t free_func; /* Function pointer for freeing. */
>  	struct delayed_work	work;      /* Workqueue data for reaping.   */
>  	unsigned int		queued;	   /* work has been queued */
> +	void			*data;
>  };
>  
>  static struct workqueue_struct	*xfs_mru_reap_wq;
> @@ -259,7 +260,7 @@ _xfs_mru_cache_clear_reap_list(
>  
>  	list_for_each_entry_safe(elem, next, &tmp, list_node) {
>  		list_del_init(&elem->list_node);
> -		mru->free_func(elem);
> +		mru->free_func(mru->data, elem);
>  	}
>  
>  	spin_lock(&mru->lock);
> @@ -326,6 +327,7 @@ xfs_mru_cache_uninit(void)
>  int
>  xfs_mru_cache_create(
>  	struct xfs_mru_cache	**mrup,
> +	void			*data,
>  	unsigned int		lifetime_ms,
>  	unsigned int		grp_count,
>  	xfs_mru_cache_free_func_t free_func)
> @@ -369,7 +371,7 @@ xfs_mru_cache_create(
>  
>  	mru->grp_time  = grp_time;
>  	mru->free_func = free_func;
> -
> +	mru->data = data;
>  	*mrup = mru;
>  
>  exit:
> @@ -492,7 +494,7 @@ xfs_mru_cache_delete(
>  
>  	elem = xfs_mru_cache_remove(mru, key);
>  	if (elem)
> -		mru->free_func(elem);
> +		mru->free_func(mru->data, elem);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
> index fb5245ba5ff7..b3f3fbdfcc47 100644
> --- a/fs/xfs/xfs_mru_cache.h
> +++ b/fs/xfs/xfs_mru_cache.h
> @@ -26,13 +26,13 @@ struct xfs_mru_cache_elem {
>  };
>  
>  /* Function pointer type for callback to free a client's data pointer. */
> -typedef void (*xfs_mru_cache_free_func_t)(struct xfs_mru_cache_elem *elem);
> +typedef void (*xfs_mru_cache_free_func_t)(void *, struct xfs_mru_cache_elem *);
>  
>  int xfs_mru_cache_init(void);
>  void xfs_mru_cache_uninit(void);
> -int xfs_mru_cache_create(struct xfs_mru_cache **mrup, unsigned int lifetime_ms,
> -			     unsigned int grp_count,
> -			     xfs_mru_cache_free_func_t free_func);
> +int xfs_mru_cache_create(struct xfs_mru_cache **mrup, void *data,
> +		unsigned int lifetime_ms, unsigned int grp_count,
> +		xfs_mru_cache_free_func_t free_func);
>  void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
>  int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
>  		struct xfs_mru_cache_elem *elem);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 945de08af7ba..19f4e30265c2 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -506,8 +506,8 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
>  DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
>  
>  DECLARE_EVENT_CLASS(xfs_filestream_class,
> -	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno),
> -	TP_ARGS(ip, agno),
> +	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno),
> +	TP_ARGS(mp, ino, agno),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> @@ -515,10 +515,10 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
>  		__field(int, streams)
>  	),
>  	TP_fast_assign(
> -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->ino = ino;
>  		__entry->agno = agno;
> -		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
> +		__entry->streams = xfs_filestream_peek_ag(mp, agno);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -528,8 +528,8 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
>  )
>  #define DEFINE_FILESTREAM_EVENT(name) \
>  DEFINE_EVENT(xfs_filestream_class, name, \
> -	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno), \
> -	TP_ARGS(ip, agno))
> +	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno), \
> +	TP_ARGS(mp, ino, agno))
>  DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
>  DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
>  DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 16:46:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83NkXIP021924
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 16:46:33 -0700
Date: Wed, 3 Sep 2008 19:47:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Improve caching in libxfs
Message-ID: <20080903234758.GA18368@infradead.org>
References: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

>  		hash = cache->c_hash + node->cn_hashidx;
> -		if (node->cn_count > 0 ||
> -				pthread_mutex_trylock(&hash->ch_mutex) != 0) {
> +		if (pthread_mutex_trylock(&hash->ch_mutex) != 0) {
>  			pthread_mutex_unlock(&node->cn_mutex);
>  			continue;
>  		}
> +		ASSERT(node->cn_count == 0);

Remove code to check if it's reference but instead assert that it isn't
because it's not added to the list in that case.  Makes sense.

>  			/*
> -			* node found, bump node's reference count, move it to the
> -			* top of its MRU list, and update stats.
> +			* node found, bump node's reference count, remove it
> +			* from its MRU list, and update stats.
>  			*/

The comment formatting is still b0rked, all the * should line up.

>  			pthread_mutex_lock(&node->cn_mutex);
> -			node->cn_count++;
>
> -			mru = &cache->c_mrus[node->cn_priority];
> -			pthread_mutex_lock(&mru->cm_mutex);
> -			list_move(&node->cn_mru, &mru->cm_list);
> -			pthread_mutex_unlock(&mru->cm_mutex);
> +			if (node->cn_count == 0) {
> +				ASSERT(node->cn_priority >= 0);
> +				ASSERT(!list_empty(&node->cn_mru));
> +				mru = &cache->c_mrus[node->cn_priority];
> +				pthread_mutex_lock(&mru->cm_mutex);
> +				mru->cm_count--;
> +				list_del_init(&node->cn_mru);
> +				pthread_mutex_unlock(&mru->cm_mutex);
> +			}
> +			node->cn_count++;

Instead of moving it around, remove it from the list whe it was
cn_count == 0 and now is rferenced.  Makes sense.

> -	/* add new node to appropriate hash and lowest priority MRU */
> -	mru = &cache->c_mrus[0];
> -	pthread_mutex_lock(&mru->cm_mutex);
> +	/* add new node to appropriate hash */
>  	pthread_mutex_lock(&hash->ch_mutex);
>  	hash->ch_count++;
> -	mru->cm_count++;
>  	list_add(&node->cn_hash, &hash->ch_list);
> -	list_add(&node->cn_mru, &mru->cm_list);
>  	pthread_mutex_unlock(&hash->ch_mutex);
> -	pthread_mutex_unlock(&mru->cm_mutex);

Don't add it to the mru list in cache_Get - makes sense.

>  void
>  cache_node_put(
> +	struct cache *		cache,
>  	struct cache_node *	node)
>  {
> +	struct cache_mru *	mru;
> +
>  	pthread_mutex_lock(&node->cn_mutex);
>  #ifdef CACHE_DEBUG
>  	if (node->cn_count < 1) {
> @@ -368,8 +372,23 @@ cache_node_put(
>  				__FUNCTION__, node->cn_count, node);
>  		cache_abort();
>  	}
> +	if (!list_empty(&node->cn_mru)) {
> +		fprintf(stderr, "%s: node put on node (%p) in MRU list\n",
> +				__FUNCTION__, node);
> +		cache_abort();
> +	}

Assert that we don't put a node that's already on the mru list, okay.
Shouldn't this be ASSERT?

>  #endif
>  	node->cn_count--;
> +
> +	if (node->cn_count == 0) {
> +		/* add unreferenced node to appropriate MRU for shaker */
> +		mru = &cache->c_mrus[node->cn_priority];
> +		pthread_mutex_lock(&mru->cm_mutex);
> +		mru->cm_count++;
> +		list_add(&node->cn_mru, &mru->cm_list);
> +		pthread_mutex_unlock(&mru->cm_mutex);
> +	}

And add it to the list, good.

> @@ -379,33 +398,14 @@ cache_node_set_priority(
>  	struct cache_node *	node,
>  	int			priority)
>  {
> -	struct cache_mru *	mru;
> -
>  	if (priority < 0)
>  		priority = 0;
>  	else if (priority > CACHE_MAX_PRIORITY)
>  		priority = CACHE_MAX_PRIORITY;
>
>  	pthread_mutex_lock(&node->cn_mutex);
> -
>  	ASSERT(node->cn_count > 0);
> -	if (priority == node->cn_priority) {
> -		pthread_mutex_unlock(&node->cn_mutex);
> -		return;
> -	}
> -	mru = &cache->c_mrus[node->cn_priority];
> -	pthread_mutex_lock(&mru->cm_mutex);
> -	list_del_init(&node->cn_mru);
> -	mru->cm_count--;
> -	pthread_mutex_unlock(&mru->cm_mutex);
> -
> -	mru = &cache->c_mrus[priority];
> -	pthread_mutex_lock(&mru->cm_mutex);
> -	list_add(&node->cn_mru, &mru->cm_list);
>  	node->cn_priority = priority;
> -	mru->cm_count++;
> -	pthread_mutex_unlock(&mru->cm_mutex);
> -
>  	pthread_mutex_unlock(&node->cn_mutex);

Set priority now simply sets the priority and doesn't fuzz with the mru
list, good.

>  		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
> -			cache_node_get_priority((struct cache_node *)bp) - 4);
> +			cache_node_get_priority((struct cache_node *)bp) - 8);

???

>  #define B_DIR_BMAP	15
> -#define B_DIR_META_2	13	/* metadata in secondary queue */
> -#define B_DIR_META_H	11	/* metadata fetched for PF_META_ONLY */
> -#define B_DIR_META_S	9	/* single block of metadata */
> -#define B_DIR_META	7
> -#define B_DIR_INODE	6
> -#define B_BMAP		5
> -#define B_INODE		4
> +#define B_DIR_META_2	14	/* metadata in secondary queue */
> +#define B_DIR_META_H	13	/* metadata fetched for PF_META_ONLY */
> +#define B_DIR_META_S	12	/* single block of metadata */
> +#define B_DIR_META	11
> +#define B_DIR_INODE	10
> +#define B_BMAP		9
> +#define B_INODE		8

Changing priorities, this could use some explanation in the
patch description..

> -#define B_IS_INODE(b)	(((b) & 1) == 0)
> -#define B_IS_META(b)	(((b) & 1) != 0)
> +#define B_IS_INODE(f)	(((f) & 5) == 0)
> +#define B_IS_META(f)	(((f) & 5) != 0)

And these two macros really want some comments describing them.

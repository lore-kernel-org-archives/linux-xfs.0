Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D79D29E24
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:59:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E06F6AC002
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k98TuLBNC1zqFc9h for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:29 -0800 (PST)
Message-ID: <52AA078E.90800@redhat.com>
Date: Thu, 12 Dec 2013 13:59:26 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] libxfs: buffer cache hashing is suboptimal
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1386832945-19763-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 12/12/2013 02:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The hashkey calculation is very simplistic,and throws away an amount
> of entropy that should be folded into the hash. The result is
> sub-optimal distribution across the hash tables. For example, with a
> default 512 entry table, phase 2 results in this:
> 
...
> Modify the hash to be something more workable - steal the linux
> kernel inode hash calculation and try that:
> 
...
> 
> Kinda says it all, really...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Results look nice and the algorithm seems to match the kernel variant,
but what about the 32-bit alternate prime/cache line values? Safe to
leave out..?

Brian

>  include/cache.h |  4 +++-
>  libxfs/cache.c  |  7 +++++--
>  libxfs/rdwr.c   | 12 ++++++++++--
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/include/cache.h b/include/cache.h
> index 76cb234..0a84c69 100644
> --- a/include/cache.h
> +++ b/include/cache.h
> @@ -66,7 +66,8 @@ typedef void (*cache_walk_t)(struct cache_node *);
>  typedef struct cache_node * (*cache_node_alloc_t)(cache_key_t);
>  typedef void (*cache_node_flush_t)(struct cache_node *);
>  typedef void (*cache_node_relse_t)(struct cache_node *);
> -typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int);
> +typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int,
> +					  unsigned int);
>  typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
>  typedef unsigned int (*cache_bulk_relse_t)(struct cache *, struct list_head *);
>  
> @@ -112,6 +113,7 @@ struct cache {
>  	cache_node_compare_t	compare;	/* comparison routine */
>  	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
>  	unsigned int		c_hashsize;	/* hash bucket count */
> +	unsigned int		c_hashshift;	/* hash key shift */
>  	struct cache_hash	*c_hash;	/* hash table buckets */
>  	struct cache_mru	c_mrus[CACHE_MAX_PRIORITY + 1];
>  	unsigned long long	c_misses;	/* cache misses */
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index 84d2860..dc69689 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -25,6 +25,7 @@
>  #include <xfs/platform_defs.h>
>  #include <xfs/list.h>
>  #include <xfs/cache.h>
> +#include <xfs/libxfs.h>
>  
>  #define CACHE_DEBUG 1
>  #undef CACHE_DEBUG
> @@ -61,6 +62,7 @@ cache_init(
>  	cache->c_misses = 0;
>  	cache->c_maxcount = maxcount;
>  	cache->c_hashsize = hashsize;
> +	cache->c_hashshift = libxfs_highbit32(hashsize);
>  	cache->hash = cache_operations->hash;
>  	cache->alloc = cache_operations->alloc;
>  	cache->flush = cache_operations->flush;
> @@ -343,7 +345,7 @@ cache_node_get(
>  	int			priority = 0;
>  	int			purged = 0;
>  
> -	hashidx = cache->hash(key, cache->c_hashsize);
> +	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
>  	hash = cache->c_hash + hashidx;
>  	head = &hash->ch_list;
>  
> @@ -515,7 +517,8 @@ cache_node_purge(
>  	struct cache_hash *	hash;
>  	int			count = -1;
>  
> -	hash = cache->c_hash + cache->hash(key, cache->c_hashsize);
> +	hash = cache->c_hash + cache->hash(key, cache->c_hashsize,
> +					   cache->c_hashshift);
>  	head = &hash->ch_list;
>  	pthread_mutex_lock(&hash->ch_mutex);
>  	for (pos = head->next, n = pos->next; pos != head;
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0219a08..0effb9a 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -311,10 +311,18 @@ struct xfs_bufkey {
>  	int			nmaps;
>  };
>  
> +/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
> +#define GOLDEN_RATIO_PRIME	0x9e37fffffffc0001UL
> +#define CACHE_LINE_SIZE		64
>  static unsigned int
> -libxfs_bhash(cache_key_t key, unsigned int hashsize)
> +libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
>  {
> -	return (((unsigned int)((struct xfs_bufkey *)key)->blkno) >> 5) % hashsize;
> +	uint64_t	hashval = ((struct xfs_bufkey *)key)->blkno;
> +	uint64_t	tmp;
> +
> +	tmp = hashval ^ (GOLDEN_RATIO_PRIME + hashval) / CACHE_LINE_SIZE;
> +	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> hashshift);
> +	return tmp % hashsize;
>  }
>  
>  static int
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LJ5UAs089400 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 13:05:31 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: replace KM_LARGE with explicit vmalloc use
Date: Thu, 21 Jan 2010 13:06:21 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B1@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100120215530.GA27535@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> We use the KM_LARGE flag to make kmem_alloc and friends use vmalloc if
> nessecary.  As we only need this for a few boot/mount time allocations
> just switch to explicit vmalloc calls there.

I like this.  Simplifies kmalloc for everybody...

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/kmem.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/kmem.c	2010-01-17 13:33:52.749254562 +0100
> +++ xfs/fs/xfs/linux-2.6/kmem.c	2010-01-17 21:07:10.919003863 +0100
> @@ -16,7 +16,6 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/mm.h>
> -#include <linux/vmalloc.h>
>  #include <linux/highmem.h>
>  #include <linux/swap.h>
>  #include <linux/blkdev.h>
> @@ -24,8 +23,25 @@
>  #include "time.h"
>  #include "kmem.h"
> 
> -#define MAX_VMALLOCS	6
> -#define MAX_SLAB_SIZE	0x20000
> +/*
> + * Greedy allocation.  May fail and may return vmalloced memory.
> + *
> + * Must be freed using kmem_free_large.
> + */
> +void *
> +kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
> +{
> +	void		*ptr;
> +	size_t		kmsize = maxsize;
> +
> +	while (!(ptr = kmem_zalloc_large(kmsize))) {
> +		if ((kmsize >>= 1) <= minsize)
> +			kmsize = minsize;
> +	}
> +	if (ptr)
> +		*size = kmsize;
> +	return ptr;
> +}
> 
>  void *
>  kmem_alloc(size_t size, unsigned int __nocast flags)
> @@ -34,19 +50,8 @@ kmem_alloc(size_t size, unsigned int __n
>  	gfp_t	lflags = kmem_flags_convert(flags);
>  	void	*ptr;
> 
> -#ifdef DEBUG
> -	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
> -		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
> -			__func__, (long)size);
> -		dump_stack();
> -	}
> -#endif
> -
>  	do {
> -		if (size < MAX_SLAB_SIZE || retries > MAX_VMALLOCS)
> -			ptr = kmalloc(size, lflags);
> -		else
> -			ptr = __vmalloc(size, lflags, PAGE_KERNEL);
> +		ptr = kmalloc(size, lflags);
>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
>  			return ptr;
>  		if (!(++retries % 100))
> @@ -68,27 +73,6 @@ kmem_zalloc(size_t size, unsigned int __
>  	return ptr;
>  }
> 
> -void *
> -kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize,
> -		   unsigned int __nocast flags)
> -{
> -	void		*ptr;
> -	size_t		kmsize = maxsize;
> -	unsigned int	kmflags = (flags & ~KM_SLEEP) | KM_NOSLEEP;
> -
> -	while (!(ptr = kmem_zalloc(kmsize, kmflags))) {
> -		if ((kmsize <= minsize) && (flags & KM_NOSLEEP))
> -			break;
> -		if ((kmsize >>= 1) <= minsize) {
> -			kmsize = minsize;
> -			kmflags = flags;
> -		}
> -	}
> -	if (ptr)
> -		*size = kmsize;
> -	return ptr;
> -}
> -
>  void
>  kmem_free(const void *ptr)
>  {
> Index: xfs/fs/xfs/linux-2.6/kmem.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/kmem.h	2010-01-17 13:33:52.755254557 +0100
> +++ xfs/fs/xfs/linux-2.6/kmem.h	2010-01-17 21:07:10.919003863 +0100
> @@ -21,6 +21,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/mm.h>
> +#include <linux/vmalloc.h>
> 
>  /*
>   * General memory allocation interfaces
> @@ -30,7 +31,6 @@
>  #define KM_NOSLEEP	0x0002u
>  #define KM_NOFS		0x0004u
>  #define KM_MAYFAIL	0x0008u
> -#define KM_LARGE	0x0010u
> 
>  /*
>   * We use a special process flag to avoid recursive callbacks into
> @@ -42,7 +42,7 @@ kmem_flags_convert(unsigned int __nocast
>  {
>  	gfp_t	lflags;
> 
> -	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_LARGE));
> +	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
> 
>  	if (flags & KM_NOSLEEP) {
>  		lflags = GFP_ATOMIC | __GFP_NOWARN;
> @@ -56,10 +56,25 @@ kmem_flags_convert(unsigned int __nocast
> 
>  extern void *kmem_alloc(size_t, unsigned int __nocast);
>  extern void *kmem_zalloc(size_t, unsigned int __nocast);
> -extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int __nocast);
>  extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
>  extern void  kmem_free(const void *);
> 
> +static inline void *kmem_zalloc_large(size_t size)
> +{
> +	void *ptr;
> +
> +	ptr = vmalloc(size);
> +	if (ptr)
> +		memset(ptr, 0, size);
> +	return ptr;
> +}
> +static inline void kmem_free_large(void *ptr)
> +{
> +	vfree(ptr);
> +}
> +
> +extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
> +
>  /*
>   * Zone interfaces
>   */
> Index: xfs/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-01-17 13:33:52.767254546 +0100
> +++ xfs/fs/xfs/quota/xfs_qm.c	2010-01-17 21:07:10.921003908 +0100
> @@ -118,9 +118,14 @@ xfs_Gqm_init(void)
>  	 */
>  	udqhash = kmem_zalloc_greedy(&hsize,
>  				     XFS_QM_HASHSIZE_LOW * sizeof(xfs_dqhash_t),
> -				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t),
> -				     KM_SLEEP | KM_MAYFAIL | KM_LARGE);
> -	gdqhash = kmem_zalloc(hsize, KM_SLEEP | KM_LARGE);
> +				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t));
> +	if (!udqhash)
> +		goto out;
> +
> +	gdqhash = kmem_zalloc_large(hsize);
> +	if (!udqhash)
> +		goto out_free_udqhash;
> +
>  	hsize /= sizeof(xfs_dqhash_t);
>  	ndquot = hsize << 8;
> 
> @@ -170,6 +175,11 @@ xfs_Gqm_init(void)
>  	mutex_init(&qcheck_lock);
>  #endif
>  	return xqm;
> +
> + out_free_udqhash:
> +	kmem_free_large(udqhash);
> + out:
> +	return NULL;
>  }
> 
>  /*
> @@ -189,8 +199,8 @@ xfs_qm_destroy(
>  		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
>  		xfs_qm_list_destroy(&(xqm->qm_grp_dqhtable[i]));
>  	}
> -	kmem_free(xqm->qm_usr_dqhtable);
> -	kmem_free(xqm->qm_grp_dqhtable);
> +	kmem_free_large(xqm->qm_usr_dqhtable);
> +	kmem_free_large(xqm->qm_grp_dqhtable);
>  	xqm->qm_usr_dqhtable = NULL;
>  	xqm->qm_grp_dqhtable = NULL;
>  	xqm->qm_dqhashmask = 0;
> @@ -219,8 +229,12 @@ xfs_qm_hold_quotafs_ref(
>  	 */
>  	mutex_lock(&xfs_Gqm_lock);
> 
> -	if (xfs_Gqm == NULL)
> +	if (!xfs_Gqm) {
>  		xfs_Gqm = xfs_Gqm_init();
> +		if (!xfs_Gqm)
> +			return ENOMEM;
> +	}
> +
>  	/*
>  	 * We can keep a list of all filesystems with quotas mounted for
>  	 * debugging and statistical purposes, but ...
> Index: xfs/fs/xfs/xfs_itable.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_itable.c	2010-01-17 13:33:52.778254478 +0100
> +++ xfs/fs/xfs/xfs_itable.c	2010-01-17 21:07:10.922012487 +0100
> @@ -408,8 +408,10 @@ xfs_bulkstat(
>  		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
>  	nimask = ~(nicluster - 1);
>  	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
> -	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4,
> -				   KM_SLEEP | KM_MAYFAIL | KM_LARGE);
> +	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
> +	if (!irbuf)
> +		return ENOMEM;
> +
>  	nirbuf = irbsize / sizeof(*irbuf);
> 
>  	/*
> @@ -727,7 +729,7 @@ xfs_bulkstat(
>  	/*
>  	 * Done, we're either out of filesystem or space to put the data.
>  	 */
> -	kmem_free(irbuf);
> +	kmem_free_large(irbuf);
>  	*ubcountp = ubelem;
>  	/*
>  	 * Found some inodes, return them now and return the error next time.
> Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-01-17 15:06:01.607003933 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-01-17 21:07:10.924003662 +0100
> @@ -1525,8 +1525,8 @@ xfs_alloc_bufhash(
> 
>  	btp->bt_hashshift = external ? 3 : 8;	/* 8 or 256 buckets */
>  	btp->bt_hashmask = (1 << btp->bt_hashshift) - 1;
> -	btp->bt_hash = kmem_zalloc((1 << btp->bt_hashshift) *
> -					sizeof(xfs_bufhash_t), KM_SLEEP | KM_LARGE);
> +	btp->bt_hash = kmem_zalloc_large((1 << btp->bt_hashshift) *
> +					 sizeof(xfs_bufhash_t));
>  	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
>  		spin_lock_init(&btp->bt_hash[i].bh_lock);
>  		INIT_LIST_HEAD(&btp->bt_hash[i].bh_list);
> @@ -1537,7 +1537,7 @@ STATIC void
>  xfs_free_bufhash(
>  	xfs_buftarg_t		*btp)
>  {
> -	kmem_free(btp->bt_hash);
> +	kmem_free_large(btp->bt_hash);
>  	btp->bt_hash = NULL;
>  }
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

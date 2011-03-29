Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TMdQP7254199
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 17:39:27 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D6C115A7FB5
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 15:42:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	R2HpF2FMMVQnN5YL for <linux-xfs@oss.sgi.com>;
	Tue, 29 Mar 2011 15:42:34 -0700 (PDT)
Date: Wed, 30 Mar 2011 09:42:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329224230.GH3008@dastard>
References: <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
	<20110329200256.GA6019@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110329200256.GA6019@infradead.org>
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
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Sean Noonan <Sean.Noonan@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, 'Michel Lespinasse' <walken@google.com>

On Tue, Mar 29, 2011 at 04:02:56PM -0400, 'Christoph Hellwig' wrote:
> On Tue, Mar 29, 2011 at 03:46:21PM -0400, Sean Noonan wrote:
> > > Can you check if the brute force patch below helps?
> > 
> > No such luck.
> 
> Actually thinking about it - we never do the vmalloc under any fs lock,
> so this can't be the reason.  But nothing else in the patch spring to
> mind either, so to narrow this down does reverting the patch on
> 2.6.38 also fix it?  The revert isn't quite trivial due to changes
> since then, so here's the patch I came up with:
> 
> 
> Index: xfs/fs/xfs/linux-2.6/kmem.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/kmem.c	2011-03-29 21:55:12.871726512 +0200
> +++ xfs/fs/xfs/linux-2.6/kmem.c	2011-03-29 21:55:31.648723706 +0200
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/mm.h>
> +#include <linux/vmalloc.h>
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <linux/swap.h>
> @@ -25,25 +26,8 @@
>  #include "kmem.h"
>  #include "xfs_message.h"
>  
> -/*
> - * Greedy allocation.  May fail and may return vmalloced memory.
> - *
> - * Must be freed using kmem_free_large.
> - */
> -void *
> -kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
> -{
> -	void		*ptr;
> -	size_t		kmsize = maxsize;
> -
> -	while (!(ptr = kmem_zalloc_large(kmsize))) {
> -		if ((kmsize >>= 1) <= minsize)
> -			kmsize = minsize;
> -	}
> -	if (ptr)
> -		*size = kmsize;
> -	return ptr;
> -}
> +#define MAX_VMALLOCS	6
> +#define MAX_SLAB_SIZE	0x20000

Why those values for the magic numbers?

....

> Index: xfs/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm.c	2011-03-29 21:55:12.859726589 +0200
> +++ xfs/fs/xfs/quota/xfs_qm.c	2011-03-29 21:55:41.387278609 +0200
> @@ -110,11 +110,12 @@ xfs_Gqm_init(void)
>  	 */
>  	udqhash = kmem_zalloc_greedy(&hsize,
>  				     XFS_QM_HASHSIZE_LOW * sizeof(xfs_dqhash_t),
> -				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t));
> +				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t),
> +				     KM_SLEEP | KM_MAYFAIL | KM_LARGE);
>  	if (!udqhash)
>  		goto out;
>  
> -	gdqhash = kmem_zalloc_large(hsize);
> +	gdqhash = kmem_zalloc(hsize, KM_SLEEP | KM_LARGE);

Needs a KM_MAYFAIL as well?

>  	if (!gdqhash)
>  		goto out_free_udqhash;
>  
....
> Index: xfs/fs/xfs/xfs_itable.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_itable.c	2011-03-29 21:55:12.851725366 +0200
> +++ xfs/fs/xfs/xfs_itable.c	2011-03-29 21:55:31.660724287 +0200
> @@ -259,10 +259,8 @@ xfs_bulkstat(
>  		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
>  	nimask = ~(nicluster - 1);
>  	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
> -	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
> -	if (!irbuf)
> -		return ENOMEM;
> -
> +	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4,
> +				   KM_SLEEP | KM_MAYFAIL | KM_LARGE);
>  	nirbuf = irbsize / sizeof(*irbuf);

Need to keep the if (!irbuf) check as KM_MAYFAIL is passed.

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

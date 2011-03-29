Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2TJa5Jj245591
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:36:05 -0500
Received: from zene.cmpxchg.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 207BD1446F64
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:39:15 -0700 (PDT)
Received: from zene.cmpxchg.org (zene.cmpxchg.org [85.214.230.12]) by
	cuda.sgi.com with ESMTP id VyKSpd3Fx8KtqOAi for
	<linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:39:15 -0700 (PDT)
Date: Tue, 29 Mar 2011 21:39:07 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329193907.GK2310@cmpxchg.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110329192434.GA10536@infradead.org>
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

On Tue, Mar 29, 2011 at 03:24:34PM -0400, 'Christoph Hellwig' wrote:
> Can you check if the brute force patch below helps?  If it does I
> still need to refine it a bit, but it could be that we are doing
> an allocation under an xfs lock that could recurse back into the
> filesystem.  We have a per-process flag to disable that for normal
> kmalloc allocation, but we lost it for vmalloc in the commit you
> bisected the regression to.
> 
> 
> Index: xfs/fs/xfs/linux-2.6/kmem.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:16:58.039224236 +0200
> +++ xfs/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:17:08.368223598 +0200
> @@ -63,7 +63,7 @@ static inline void *kmem_zalloc_large(si
>  {
>  	void *ptr;
>  
> -	ptr = vmalloc(size);
> +	ptr = __vmalloc(size, GFP_NOFS | __GFP_HIGHMEM, PAGE_KERNEL);
>  	if (ptr)
>  		memset(ptr, 0, size);
>  	return ptr;

Note that vmalloc is currently broken in that it does a GFP_KERNEL
allocation if it has to allocate page table pages, even when invoked
with GFP_NOFS:

	http://marc.info/?l=linux-mm&m=128942194520631&w=4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

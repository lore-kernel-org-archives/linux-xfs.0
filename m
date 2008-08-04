Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 23:21:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m746LKQE027398
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 23:21:21 -0700
Message-ID: <4896A197.3090004@sgi.com>
Date: Mon, 04 Aug 2008 16:28:39 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de>
In-Reply-To: <20080728123703.GC13926@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com, xen-devel@lists.xensource.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net

Looks good to me.

Nick Piggin wrote:
> Implement XFS's large buffer support with the new vmap APIs. See the vmap
> rewrite patch for some numbers.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> @@ -265,7 +265,7 @@ xfs_buf_free(
>  		uint		i;
>  
>  		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
> -			vunmap(bp->b_addr - bp->b_offset);
> +			vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
>  
>  		for (i = 0; i < bp->b_page_count; i++) {
>  			struct page	*page = bp->b_pages[i];
> @@ -387,8 +387,8 @@ _xfs_buf_map_pages(
>  		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
>  		bp->b_flags |= XBF_MAPPED;
>  	} else if (flags & XBF_MAPPED) {
> -		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
> -					VM_MAP, PAGE_KERNEL);
> +		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> +					-1, PAGE_KERNEL);
>  		if (unlikely(bp->b_addr == NULL))
>  			return -ENOMEM;
>  		bp->b_addr += bp->b_offset;
> 
> 
> 

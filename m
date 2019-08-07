Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52855 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbfHGIvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 04:51:24 -0400
Subject: Re: [PATCH v3 10/41] media/ivtv: convert put_page() to
 put_user_page*()
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <20190807013340.9706-11-jhubbard@nvidia.com>
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <6fd38719-b5d3-f981-732f-da904e029546@xs4all.nl>
Date: Wed, 7 Aug 2019 10:51:17 +0200
MIME-Version: 1.0
In-Reply-To: <20190807013340.9706-11-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Andy Walls <awalls@md.metrocast.net>, Mauro Carvalho Chehab <mchehab@kernel.org>

On 8/7/19 3:33 AM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/media/pci/ivtv/ivtv-udma.c | 14 ++++----------
>  drivers/media/pci/ivtv/ivtv-yuv.c  | 11 +++--------
>  2 files changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
> index 5f8883031c9c..7c7f33c2412b 100644
> --- a/drivers/media/pci/ivtv/ivtv-udma.c
> +++ b/drivers/media/pci/ivtv/ivtv-udma.c
> @@ -92,7 +92,7 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  {
>  	struct ivtv_dma_page_info user_dma;
>  	struct ivtv_user_dma *dma = &itv->udma;
> -	int i, err;
> +	int err;
>  
>  	IVTV_DEBUG_DMA("ivtv_udma_setup, dst: 0x%08x\n", (unsigned int)ivtv_dest_addr);
>  
> @@ -119,8 +119,7 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
>  			   err, user_dma.page_count);
>  		if (err >= 0) {
> -			for (i = 0; i < err; i++)
> -				put_page(dma->map[i]);
> +			put_user_pages(dma->map, err);
>  			return -EINVAL;
>  		}
>  		return err;
> @@ -130,9 +129,7 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  
>  	/* Fill SG List with new values */
>  	if (ivtv_udma_fill_sg_list(dma, &user_dma, 0) < 0) {
> -		for (i = 0; i < dma->page_count; i++) {
> -			put_page(dma->map[i]);
> -		}
> +		put_user_pages(dma->map, dma->page_count);
>  		dma->page_count = 0;
>  		return -ENOMEM;
>  	}
> @@ -153,7 +150,6 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  void ivtv_udma_unmap(struct ivtv *itv)
>  {
>  	struct ivtv_user_dma *dma = &itv->udma;
> -	int i;
>  
>  	IVTV_DEBUG_INFO("ivtv_unmap_user_dma\n");
>  
> @@ -170,9 +166,7 @@ void ivtv_udma_unmap(struct ivtv *itv)
>  	ivtv_udma_sync_for_cpu(itv);
>  
>  	/* Release User Pages */
> -	for (i = 0; i < dma->page_count; i++) {
> -		put_page(dma->map[i]);
> -	}
> +	put_user_pages(dma->map, dma->page_count);
>  	dma->page_count = 0;
>  }
>  
> diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
> index cd2fe2d444c0..2c61a11d391d 100644
> --- a/drivers/media/pci/ivtv/ivtv-yuv.c
> +++ b/drivers/media/pci/ivtv/ivtv-yuv.c
> @@ -30,7 +30,6 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
>  	struct yuv_playback_info *yi = &itv->yuv_info;
>  	u8 frame = yi->draw_frame;
>  	struct yuv_frame_info *f = &yi->new_frame_info[frame];
> -	int i;
>  	int y_pages, uv_pages;
>  	unsigned long y_buffer_offset, uv_buffer_offset;
>  	int y_decode_height, uv_decode_height, y_size;
> @@ -81,8 +80,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
>  				 uv_pages, uv_dma.page_count);
>  
>  			if (uv_pages >= 0) {
> -				for (i = 0; i < uv_pages; i++)
> -					put_page(dma->map[y_pages + i]);
> +				put_user_pages(&dma->map[y_pages], uv_pages);
>  				rc = -EFAULT;
>  			} else {
>  				rc = uv_pages;
> @@ -93,8 +91,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
>  				 y_pages, y_dma.page_count);
>  		}
>  		if (y_pages >= 0) {
> -			for (i = 0; i < y_pages; i++)
> -				put_page(dma->map[i]);
> +			put_user_pages(dma->map, y_pages);
>  			/*
>  			 * Inherit the -EFAULT from rc's
>  			 * initialization, but allow it to be
> @@ -112,9 +109,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
>  	/* Fill & map SG List */
>  	if (ivtv_udma_fill_sg_list (dma, &uv_dma, ivtv_udma_fill_sg_list (dma, &y_dma, 0)) < 0) {
>  		IVTV_DEBUG_WARN("could not allocate bounce buffers for highmem userspace buffers\n");
> -		for (i = 0; i < dma->page_count; i++) {
> -			put_page(dma->map[i]);
> -		}
> +		put_user_pages(dma->map, dma->page_count);
>  		dma->page_count = 0;
>  		return -ENOMEM;
>  	}
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728157AbfHBEg4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Aug 2019 00:36:56 -0400
Subject: Re: [PATCH 20/34] xen: convert put_page() to put_user_page*()
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-21-jhubbard@nvidia.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <4471e9dc-a315-42c1-0c3c-55ba4eeeb106@suse.com>
Date: Fri, 2 Aug 2019 06:36:51 +0200
MIME-Version: 1.0
In-Reply-To: <20190802022005.5117-21-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>, x86@kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, linux-rpi-kernel@lists.infradead.org, devel@lists.orangefs.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, rds-devel@oss.oracle.com, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, kvm@vger.kernel.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, sparclinux@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>

On 02.08.19 04:19, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>   drivers/xen/gntdev.c  | 5 +----
>   drivers/xen/privcmd.c | 7 +------
>   2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 4c339c7e66e5..2586b3df2bb6 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -864,10 +864,7 @@ static int gntdev_get_page(struct gntdev_copy_batch *batch, void __user *virt,
>   
>   static void gntdev_put_pages(struct gntdev_copy_batch *batch)
>   {
> -	unsigned int i;
> -
> -	for (i = 0; i < batch->nr_pages; i++)
> -		put_page(batch->pages[i]);
> +	put_user_pages(batch->pages, batch->nr_pages);
>   	batch->nr_pages = 0;
>   }
>   
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index 2f5ce7230a43..29e461dbee2d 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -611,15 +611,10 @@ static int lock_pages(
>   
>   static void unlock_pages(struct page *pages[], unsigned int nr_pages)
>   {
> -	unsigned int i;
> -
>   	if (!pages)
>   		return;
>   
> -	for (i = 0; i < nr_pages; i++) {
> -		if (pages[i])
> -			put_page(pages[i]);
> -	}
> +	put_user_pages(pages, nr_pages);

You are not handling the case where pages[i] is NULL here. Or am I
missing a pending patch to put_user_pages() here?


Juergen

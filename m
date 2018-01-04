Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47886 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbeADIZm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:25:42 -0500
Date: Thu, 4 Jan 2018 09:25:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 10/18] mm, dev_pagemap: introduce
        CONFIG_DEV_PAGEMAP_OPS
Message-ID: <20180104082540.GF2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407701384.38751.18357520725643239723.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407701384.38751.18357520725643239723.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

This looks fine except for a few nitpicks below:

>  	}
>  
> +	dev_pagemap_enable_ops();
>  	pgmap->type = MEMORY_DEVICE_FS_DAX;
>  	pgmap->page_free = generic_dax_pagefree;
>  	pgmap->data = owner;
> @@ -215,6 +216,7 @@ void fs_dax_release(struct dax_device *dax_dev, void *owner)
>  	pgmap->type = MEMORY_DEVICE_HOST;
>  	pgmap->page_free = NULL;
>  	pgmap->data = NULL;
> +	dev_pagemap_disable_ops();

should these be get/put instead of enable/disable given that they
implement a refcount?

> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +void __put_devmap_managed_page(struct page *page);
> +DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> +static inline bool put_devmap_managed_page(struct page *page)
>  {
> +	if (!static_branch_unlikely(&devmap_managed_key))
> +		return false;
> +	if (!is_zone_device_page(page))
> +		return false;
> +	switch (page->pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_PUBLIC:
> +	case MEMORY_DEVICE_FS_DAX:
> +		__put_devmap_managed_page(page);
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;

Should the switch be moved into the out of line version to keep
the inline instructions at a minimum?

> + * pages go idle.
> + */
> +void dev_pagemap_enable_ops(void)
> +{
> +	if (atomic_inc_return(&devmap_enable) == 1)
> +		static_branch_enable(&devmap_managed_key);
> +}
> +EXPORT_SYMBOL(dev_pagemap_enable_ops);

_GPL?

> +EXPORT_SYMBOL(dev_pagemap_disable_ops);

Same.




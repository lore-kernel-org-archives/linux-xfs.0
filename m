Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729258AbfDJIZI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Apr 2019 04:25:08 -0400
Date: Wed, 10 Apr 2019 10:25:04 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 4/6] dax: check synchronous mapping is supported
Message-ID: <20190410082504.GF1426@quack2.suse.cz>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-5-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410040826.24371-5-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, kilobyte@angband.pl, yuval.shaia@oracle.com

On Wed 10-04-19 09:38:24, Pankaj Gupta wrote:
> This patch introduces 'daxdev_mapping_supported' helper
> which checks if 'MAP_SYNC' is supported with filesystem
> mapping. It also checks if corresponding dax_device is
> synchronous. Virtio pmem device is asynchronous and
> does not not support VM_SYNC. 
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  include/linux/dax.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b896706a5ee9..4a2a60ffec86 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,6 +38,24 @@ void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> +
> +/*
> + * Callers check if synchronous mapping is enabled for DAX file
> + * and attached dax device is also synchronous.
> + *
> + * dax_synchronous function verifies if dax device is synchronous.
> + * Currently, only virtio pmem device supports asynchronous device
> + * flush.
> + */

Thanks for the patch! I'd restructure this comment like:

/*
 * Check if given mapping is supported by the file / underlying device.
 */
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{

	/* Everyone supports non-sync mappings */
> +	if (!(vma->vm_flags & VM_SYNC))
> +		return true;
	/* Sync mappings are supported only for files using DAX */
> +	if (!IS_DAX(file_inode(vma->vm_file)))
> +		return false;
	/* Underlying device must support persisting through CPU instructions */
> +	return dax_synchronous(dax_dev);
> +}
>  #else
>  static inline struct dax_device *dax_get_by_host(const char *host)
>  {
> @@ -69,6 +87,11 @@ static inline bool dax_synchronous(struct dax_device *dax_dev)
>  {
>  	return true;
>  }
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{
> +	return true;

This looks wrong. Shouldn't it rather be:

	return !(vma->flags & VM_SYNC);

?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

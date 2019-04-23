Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726659AbfDWO11 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 10:27:27 -0400
Date: Tue, 23 Apr 2019 16:27:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 4/6]  dax: check synchronous mapping is supported
Message-ID: <20190423142723.GD9910@quack2.suse.cz>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-5-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423080612.15361-5-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl

On Tue 23-04-19 13:36:10, Pankaj Gupta wrote:
> This patch introduces 'daxdev_mapping_supported' helper
> which checks if 'MAP_SYNC' is supported with filesystem
> mapping. It also checks if corresponding dax_device is
> synchronous. Virtio pmem device is asynchronous and
> does not not support VM_SYNC. 
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  include/linux/dax.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index c97fc0cc7167..41b4a5db6305 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -41,6 +41,18 @@ void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> +/*
> + * Check if given mapping is supported by the file / underlying device.
> + */
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{
> +	if (!(vma->vm_flags & VM_SYNC))
> +		return true;
> +	if (!IS_DAX(file_inode(vma->vm_file)))
> +		return false;
> +	return dax_synchronous(dax_dev);
> +}
>  #else
>  static inline struct dax_device *dax_get_by_host(const char *host)
>  {
> @@ -68,6 +80,11 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
>  {
>  	return false;
>  }
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{
> +	return !(vma->flags & VM_SYNC);
> +}
>  #endif
>  
>  struct writeback_control;
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

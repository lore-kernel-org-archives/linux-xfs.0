Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165737AbeBORwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 12:52:51 -0500
Date: Thu, 15 Feb 2018 09:52:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180215175241.GA25223@infradead.org>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

>  /**
> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> + * bdev_dax_supported() - Check if the device supports dax for filesystem
>   * @sb: The superblock of the device
> + * @bdev: block device to check
>   * @blocksize: The block size of the device
>   *
>   * This is a library function for filesystems to check if the block device
> @@ -82,9 +83,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>   *
>   * Return: negative errno if unsupported, 0 if supported.
>   */
> -int __bdev_dax_supported(struct super_block *sb, int blocksize)
> +int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
> +		       int blocksize)
>  {
> -	struct block_device *bdev = sb->s_bdev;
>  	struct dax_device *dax_dev;
>  	pgoff_t pgoff;
>  	int err, id;

This now only uses sb for sb->s_id.  It might be better to use bdevname
to print the device name and don't bother passing a sb at all.


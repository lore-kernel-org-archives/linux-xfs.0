Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167211AbeBOTHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 14:07:25 -0500
Date: Thu, 15 Feb 2018 11:06:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180215190658.GQ5217@magnolia>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
 <20180215175241.GA25223@infradead.org>
 <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

On Thu, Feb 15, 2018 at 10:58:54AM -0700, Dave Jiang wrote:
> On 02/15/2018 10:52 AM, Christoph Hellwig wrote:
> >>  /**
> >> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> >> + * bdev_dax_supported() - Check if the device supports dax for filesystem
> >>   * @sb: The superblock of the device
> >> + * @bdev: block device to check
> >>   * @blocksize: The block size of the device
> >>   *
> >>   * This is a library function for filesystems to check if the block device
> >> @@ -82,9 +83,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> >>   *
> >>   * Return: negative errno if unsupported, 0 if supported.
> >>   */
> >> -int __bdev_dax_supported(struct super_block *sb, int blocksize)
> >> +int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
> >> +		       int blocksize)
> >>  {
> >> -	struct block_device *bdev = sb->s_bdev;
> >>  	struct dax_device *dax_dev;
> >>  	pgoff_t pgoff;
> >>  	int err, id;
> > 
> > This now only uses sb for sb->s_id.  It might be better to use bdevname
> > to print the device name and don't bother passing a sb at all.
> > 
> 
> I think Darrick wanted to keep the API the same for non-XFS users. I'm
> ok with dropping the passed in sb if Darrick has no objections.

Fine with me to use bdevname.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

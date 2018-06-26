Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752427AbeFZSR2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 14:17:28 -0400
Date: Tue, 26 Jun 2018 14:17:26 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 3/3] dm: prevent DAX mounts if not supported
Message-ID: <20180626181726.GA6630@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180626175932.8899-4-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

On Tue, Jun 26 2018 at  1:59pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
> flag is set on the device's request queue to decide whether or not the
> device supports filesystem DAX.  Really we should be using
> bdev_dax_supported() like filesystems do at mount time.  This performs
> other tests like checking to make sure the dax_direct_access() path works.
> 
> Conditionally set QUEUE_FLAG_DAX on the DM device's request queue based on
> whether all underlying devices support DAX.  Now that bdev_dax_supported()
> explicitly checks for this flag, this will ensure that filesystems built
> upon DM devices will only be able to mount with DAX if all underlying
> devices also support DAX.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-ioctl.c         | 5 +++++
>  drivers/md/dm-table.c         | 7 +++----
>  drivers/md/dm.c               | 3 +--
>  include/linux/device-mapper.h | 5 +++++
>  4 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index b810ea77e6b1..0055bdbee5b1 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1350,6 +1350,11 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
>  		goto err_unlock_md_type;
>  	}
>  
> +	if (dm_table_supports_dax(t))
> +		blk_queue_flag_set(QUEUE_FLAG_DAX, md->queue);
> +	else
> +		blk_queue_flag_clear(QUEUE_FLAG_DAX, md->queue);
> +
>  	dm_unlock_md_type(md);
>  
>  	/* stage inactive table */

This should occur in drivers/md/dm-table.c:dm_table_set_restrictions().
Which already has: 
      if (dm_table_supports_dax(t))
                blk_queue_flag_set(QUEUE_FLAG_DAX, q);

So it just needs tweaking.

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 938766794c2e..c673b4a51fb2 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -885,12 +885,10 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
>  static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>  			       sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
> -
> -	return q && blk_queue_dax(q);
> +	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
>  }
>  
> -static bool dm_table_supports_dax(struct dm_table *t)
> +bool dm_table_supports_dax(struct dm_table *t)
>  {
>  	struct dm_target *ti;
>  	unsigned i;
> @@ -909,6 +907,7 @@ static bool dm_table_supports_dax(struct dm_table *t)
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(dm_table_supports_dax);
>  
>  static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
>  

Which would mean you don't need to export dm_table_supports_dax().

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e65429a29c06..bef5a3f243ed 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1056,8 +1056,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	if (len < 1)
>  		goto out;
>  	nr_pages = min(len, nr_pages);
> -	if (ti->type->direct_access)
> -		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
> +	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
>  
>   out:
>  	dm_put_live_table(md, srcu_idx);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 6fb0808e87c8..45ea9e1f9af9 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -461,6 +461,11 @@ void dm_table_add_target_callbacks(struct dm_table *t, struct dm_target_callback
>   */
>  void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type);
>  
> +/*
> + * Check to see if this target type and all table devices support DAX.
> + */
> +bool dm_table_supports_dax(struct dm_table *t);
> +
>  /*
>   * Finally call this to make the table ready for use.
>   */

Nor do you need to publish the dm_table_supports_dax() interface via
include/linux/device-mapper.h

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 676097CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 19:35:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D52ABAC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 17:35:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xvc9cDFyhvAGTtkT for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 17:35:17 -0700 (PDT)
Date: Thu, 14 Apr 2016 10:32:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 PATCH 03/10] block: add block_device_operations methods
	to set and get reserved space
Message-ID: <20160414003242.GU567@dastard>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
	<1460479373-63317-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460479373-63317-4-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 12:42:46PM -0400, Brian Foster wrote:
> From: Mike Snitzer <snitzer@redhat.com>
> 
> [BF:
>  - Killed wrapper functions.
>  - Condensed to single bdev op.]
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  include/linux/blkdev.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 669e419..6c6ea96 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1650,6 +1650,10 @@ struct blk_dax_ctl {
>  	pfn_t pfn;
>  };
>  
> +#define BDEV_RES_GET		0
> +#define BDEV_RES_MOD		(1 << 0)
> +#define BDEV_RES_PROVISION	(1 << 1)
> +
>  struct block_device_operations {
>  	int (*open) (struct block_device *, fmode_t);
>  	void (*release) (struct gendisk *, fmode_t);
> @@ -1667,6 +1671,8 @@ struct block_device_operations {
>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
>  	/* this callback is with swap_lock and sometimes page table lock held */
>  	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
> +	int (*reserve_space) (struct block_device *, int, sector_t, sector_t,
> +			      sector_t *);
>  	struct module *owner;
>  	const struct pr_ops *pr_ops;

You know, I'm now wondering how much of this has overlap with the
iomap interface we are adding for the VFS IO paths to map and
allocate extents....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

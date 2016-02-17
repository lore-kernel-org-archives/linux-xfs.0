Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96A3D7CB4
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 15:55:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 757318F8033
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:55:15 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id Vaw8ueG6DUkavoQi (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:55:13 -0800 (PST)
Date: Wed, 17 Feb 2016 22:55:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/6] block: disable block device DAX by default
Message-ID: <20160217215534.GL14140@quack.suse.cz>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455680059-20126-2-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455680059-20126-2-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jeff Layton <jlayton@poochiereds.net>, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Al Viro <viro@ftp.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue 16-02-16 20:34:14, Ross Zwisler wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> The recent *sync enabling discovered that we are inserting into the
> block_device pagecache counter to the expectations of the dirty data
> tracking for dax mappings.  This can lead to data corruption.
> 
> We want to support DAX for block devices eventually, but it requires
> wider changes to properly manage the pagecache.
> 
>   [<ffffffff81576d93>] dump_stack+0x85/0xc2
>   [<ffffffff812b9ee0>] dax_writeback_mapping_range+0x60/0xe0
>   [<ffffffff812a1d4f>] blkdev_writepages+0x3f/0x50
>   [<ffffffff811db011>] do_writepages+0x21/0x30
>   [<ffffffff811cb6a6>] __filemap_fdatawrite_range+0xc6/0x100
>   [<ffffffff811cb75a>] filemap_write_and_wait+0x4a/0xa0
>   [<ffffffff812a15e0>] set_blocksize+0x70/0xd0
>   [<ffffffff812a273d>] sb_set_blocksize+0x1d/0x50
>   [<ffffffff8132ac9b>] ext4_fill_super+0x75b/0x3360
>   [<ffffffff81583381>] ? vsnprintf+0x201/0x4c0
>   [<ffffffff815836d9>] ? snprintf+0x49/0x60
>   [<ffffffff81263010>] mount_bdev+0x180/0x1b0
>   [<ffffffff8132a540>] ? ext4_calculate_overhead+0x370/0x370
>   [<ffffffff8131ad95>] ext4_mount+0x15/0x20
>   [<ffffffff81263908>] mount_fs+0x38/0x170
> 
> Mark the support broken so its disabled by default, but otherwise still
> available for testing.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Al Viro <viro@ftp.linux.org.uk>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/Kconfig  | 13 +++++++++++++
>  fs/block_dev.c |  6 +++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 161491d..0363cd7 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -88,6 +88,19 @@ config BLK_DEV_INTEGRITY
>  	T10/SCSI Data Integrity Field or the T13/ATA External Path
>  	Protection.  If in doubt, say N.
>  
> +config BLK_DEV_DAX
> +	bool "Block device DAX support"
> +	depends on FS_DAX
> +	depends on BROKEN
> +	help
> +	  When DAX support is available (CONFIG_FS_DAX) raw block
> +	  devices can also support direct userspace access to the
> +	  storage capacity via MMAP(2) similar to a file on a
> +	  DAX-enabled filesystem.  However, the DAX I/O-path disables
> +	  some standard I/O-statistics, and the MMAP(2) path has some
> +	  operational differences due to bypassing the page
> +	  cache.  If in doubt, say N.
> +
>  config BLK_DEV_THROTTLING
>  	bool "Block layer bio throttling support"
>  	depends on BLK_CGROUP=y
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 39b3a17..31c6d10 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1201,7 +1201,11 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  		bdev->bd_disk = disk;
>  		bdev->bd_queue = disk->queue;
>  		bdev->bd_contains = bdev;
> -		bdev->bd_inode->i_flags = disk->fops->direct_access ? S_DAX : 0;
> +		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
> +			bdev->bd_inode->i_flags = S_DAX;
> +		else
> +			bdev->bd_inode->i_flags = 0;
> +
>  		if (!partno) {
>  			ret = -ENXIO;
>  			bdev->bd_part = disk_get_part(disk, partno);
> -- 
> 2.5.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56579 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbeACOUt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 09:20:49 -0500
Date: Wed, 3 Jan 2018 15:20:47 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 02/18] ext4: auto disable dax instead of failing mount
Message-ID: <20180103142047.GG4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407697190.38751.14634783055964566076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407697190.38751.14634783055964566076.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Sat 23-12-17 16:56:11, Dan Williams wrote:
> Bring the ext4 filesystem in line with xfs that only warns and continues
> when the "-o dax" option is specified to mount and the backing device
> does not support dax. This is in preparation for removing dax support
> from devices that do not enable get_user_pages() operations on dax
> mappings. In other words 'gup' support is required and configurations
> that were using so called 'page-less' dax will be converted back to
> using the page cache.
> 
> Removing the broken 'page-less' dax support is a pre-requisite for
> removing the "EXPERIMENTAL" warning when mounting a filesystem in dax
> mode.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

OK, given the fact that we already silently disable DAX for inodes with
data journalling I agree this makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7c46693a14d7..18873ea89e08 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3710,11 +3710,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		if (ext4_has_feature_inline_data(sb)) {
>  			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
>  					" that may contain inline data");
> -			goto failed_mount;
> +			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
>  		}
>  		err = bdev_dax_supported(sb, blocksize);
> -		if (err)
> -			goto failed_mount;
> +		if (err) {
> +			ext4_msg(sb, KERN_ERR,
> +				"DAX unsupported by block device. Turning off DAX.");
> +			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
> +		}
>  	}
>  
>  	if (ext4_has_feature_encrypt(sb) && es->s_encryption_level) {
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

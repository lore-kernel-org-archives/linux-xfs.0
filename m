Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965611AbeBMUbu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Feb 2018 15:31:50 -0500
Date: Tue, 13 Feb 2018 13:31:48 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 2/3] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180213203148.GB13682@linux.intel.com>
References: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
 <151813669915.15926.5489252461577531.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151813669915.15926.5489252461577531.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

On Thu, Feb 08, 2018 at 05:38:19PM -0700, Dave Jiang wrote:
> The function return values are confusing with the way the function is
> named. We expect a true or false return value but it actually returns
> 0/-errno.  This makes the code very confusing. Changing the return values
> to return a bool where if DAX is supported then return true and no DAX
> support returns false.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 655699321c45..636b9c5e1bff 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -958,9 +958,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> -		err = sb_dax_supported(sb, blocksize);
> -		if (err)
> +		if(!sb_dax_supported(sb, blocksize)) {
> +			err = -EIO;

No need to set 'err' here.  This is just a temporary variable used for some
local checks later in the function.  'ret' is the value that will be returned,
and that is already initialized to -EINVAL which should be fine.

>  			goto failed_mount;
> +		}
>  	}
>  
>  	/* If the blocksize doesn't match, re-read the thing.. */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 804a2d6729af..7b7650ac9c53 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3712,9 +3712,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  					" that may contain inline data");
>  			goto failed_mount;
>  		}
> -		err = sb_dax_supported(sb, blocksize);
> -		if (err)
> +		if (!sb_dax_supported(sb, blocksize)) {
> +			err = -EIO;

Same comment as with the ext2 case - no need to set 'err', 'ret' is -EINVAL
and has you covered.

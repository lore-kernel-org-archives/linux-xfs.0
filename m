Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0446CC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D8761A4A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCYW7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 18:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhCYW7c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 18:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C28C61A0F;
        Thu, 25 Mar 2021 22:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616713172;
        bh=PGX8Gob4CFSuOOXMgnGS+C3DwaJI86zw7dP/Ptz4vVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWQtBci7Ct4ampaoOzv9/RByhjbLpE69wNBq+xWaKnve1RliA8dDVtKryIIZuYGjj
         1zz55p92xuSrav0AR741uTkb/LzrsBUr0rYd5MCEHR5ZXh/RJg5/kdNTdFgPmkSCKG
         XRixDOOnjJqnsSf02VnGO4n8i/9Z6mzM8jxLXFRgLbw/vuwe/0HZ0qDwwx+t9LHpVS
         aphOKbGy5sanXSAscRERWWNgtmHZSBr8QZ1/f0+q88sDWQeL8a8tycROg2HVuMDJDj
         o/yzS5ekkyPxhk6iFO0/MEQ4AkIiwVSWTfBdIQuVCGL3qiM9aBi6Mbn5RO4Z4y3vlS
         1IEHXK0E7735Q==
Date:   Thu, 25 Mar 2021 15:59:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: improve the warnings from iomap_swapfile_activate
Message-ID: <20210325225929.GN4090233@magnolia>
References: <20210325201753.1292361-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325201753.1292361-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 09:17:53PM +0100, Christoph Hellwig wrote:
> Print the path name of the swapfile that failed to active to ease
> debugging the problem and to avoid a scare if xfstests hits these
> cases.  Also reword one warning a bit, as the error is not about
> a file being on multiple devices, but one that has at least an
> extent outside the main device known to the VFS and swap code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/swapfile.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
> index a648dbf6991e4e..1dc63beae0c5b8 100644
> --- a/fs/iomap/swapfile.c
> +++ b/fs/iomap/swapfile.c
> @@ -18,6 +18,7 @@ struct iomap_swapfile_info {
>  	uint64_t highest_ppage;		/* highest physical addr seen (pages) */
>  	unsigned long nr_pages;		/* number of pages collected */
>  	int nr_extents;			/* extent count */
> +	struct file *file;
>  };
>  
>  /*
> @@ -70,6 +71,18 @@ static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
>  	return 0;
>  }
>  
> +static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
> +{
> +	char *buf, *p = ERR_PTR(-ENOMEM);
> +
> +	buf = kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (buf)
> +		p = file_path(isi->file, buf, PATH_MAX);
> +	pr_err("swapon: file %s %s\n", IS_ERR(p) ? "<unknown>" : p, str);
> +	kfree(buf);
> +	return -EINVAL;
> +}
> +
>  /*
>   * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
>   * swap only cares about contiguous page-aligned physical extents and makes no
> @@ -89,28 +102,20 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  		break;
>  	case IOMAP_INLINE:
>  		/* No inline data. */
> -		pr_err("swapon: file is inline\n");
> -		return -EINVAL;
> +		return iomap_swapfile_fail(isi, "is inline");
>  	default:
> -		pr_err("swapon: file has unallocated extents\n");
> -		return -EINVAL;
> +		return iomap_swapfile_fail(isi, "has unallocated extents");
>  	}
>  
>  	/* No uncommitted metadata or shared blocks. */
> -	if (iomap->flags & IOMAP_F_DIRTY) {
> -		pr_err("swapon: file is not committed\n");
> -		return -EINVAL;
> -	}
> -	if (iomap->flags & IOMAP_F_SHARED) {
> -		pr_err("swapon: file has shared extents\n");
> -		return -EINVAL;
> -	}
> +	if (iomap->flags & IOMAP_F_DIRTY)
> +		return iomap_swapfile_fail(isi, "is not committed");
> +	if (iomap->flags & IOMAP_F_SHARED)
> +		return iomap_swapfile_fail(isi, "has shared extents");
>  
>  	/* Only one bdev per swap file. */
> -	if (iomap->bdev != isi->sis->bdev) {
> -		pr_err("swapon: file is on multiple devices\n");
> -		return -EINVAL;
> -	}
> +	if (iomap->bdev != isi->sis->bdev)
> +		return iomap_swapfile_fail(isi, "outside the main device");
>  
>  	if (isi->iomap.length == 0) {
>  		/* No accumulated extent, so just store it. */
> @@ -139,6 +144,7 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
>  	struct iomap_swapfile_info isi = {
>  		.sis = sis,
>  		.lowest_ppage = (sector_t)-1ULL,
> +		.file = swap_file,
>  	};
>  	struct address_space *mapping = swap_file->f_mapping;
>  	struct inode *inode = mapping->host;
> -- 
> 2.30.1
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbeJQQbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:31:31 -0400
Date: Wed, 17 Oct 2018 01:36:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/26] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181017083652.GF16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965999426.3607.3221368918901209000.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965999426.3607.3221368918901209000.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

>  /* Update inode timestamps and remove security privileges when remapping. */
> @@ -2023,7 +2034,8 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>  {
>  	loff_t ret;
>  
> -	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP));
> +	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
> +				     REMAP_FILE_CAN_SHORTEN));

I guess this is where you could actually use REMAP_FILE_VALID_FLAGS..

>  /* REMAP_FILE flags taken care of by the vfs. */
> -#define REMAP_FILE_ADVISORY		(0)
> +#define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)

And btw, they are not 'taken care of by the VFS', they need to be
taken care of by the fs (possibly using helpers) to take affect,
but they can be safely ignored.

> +		if (!IS_ALIGNED(count, bs)) {
> +			if (remap_flags & REMAP_FILE_CAN_SHORTEN)
> +				count = ALIGN_DOWN(count, bs);
> +			else
> +				return -EINVAL;

			if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
				return -EINVAL;
			count = ALIGN_DOWN(count, bs);

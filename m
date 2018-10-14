Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 21:01:12 -0400
Date: Sun, 14 Oct 2018 10:19:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181014171927.GD30673@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938919123.8361.13059492965161549195.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

>  	unsigned (*mmap_capabilities)(struct file *);
>  #endif
>  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				u64 len, unsigned int remap_flags);

None of the other methods in this file name their parameters.  While
I generally don't like people leaving them out, in the end consistency
is even more important.

> +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> +		struct file *dst_file, loff_t destoff, u64 len,
> +		unsigned int remap_flags)
>  {
> +	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> +		return -EINVAL;
> +
> +	if (remap_flags & RFR_SAME_DATA) {

So at least for btrfs there seems to be no shared code at all below
the function calls.  This kinda speaks against the argument that
they fundamentally are the same..

> +/*
> + * These flags control the behavior of the remap_file_range function pointer.
> + *
> + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> + */
> +#define RFR_SAME_DATA		(1 << 0)
> +
> +#define RFR_VALID_FLAGS		(RFR_SAME_DATA)

RFR?  Why not REMAP_FILE_*  Also why not the well understood
REMAP_FILE_DEDUP instead of the odd SAME_DATA?

> +
> +/*
> + * Filesystem remapping implementations should call this helper on their
> + * remap flags to filter out flags that the implementation doesn't support.
> + *
> + * Returns true if the flags are ok, false otherwise.
> + */
> +static inline bool remap_check_flags(unsigned int remap_flags,
> +				     unsigned int supported_flags)
> +{
> +	return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> +}

Any reason to even bother with a helper for this?  ->fallocate
seems to be doing fine without the helper, and the resulting code
seems a lot easier to understand to me.

> @@ -1759,10 +1779,9 @@ struct file_operations {
>  #endif
>  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
>  			loff_t, size_t, unsigned int);
> -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> -			u64);
> -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> -			u64);
> +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				u64 len, unsigned int remap_flags);

Same comment here.  Didn't we have some nice doc tools to avoid this
duplication? :)

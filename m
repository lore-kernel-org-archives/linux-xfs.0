Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63190 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750747AbcIMAC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2016 20:02:29 -0400
Date: Tue, 13 Sep 2016 10:02:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] ovl: use vfs_clone_file_range() for copy up if
 possible
Message-ID: <20160913000225.GM22388@dastard>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-3-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473692803-11964-3-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

On Mon, Sep 12, 2016 at 06:06:41PM +0300, Amir Goldstein wrote:
> When copying up within the same fs, try to use vfs_clone_file_range().
> This is very efficient when lower and upper are on the same fs
> with file reflink support. If vfs_clone_file_range() fails because
> lower and upper are not on the same fs or if fs has no reflink support,
> copy up falls back to the regular data copy code.
> 
> Tested correct behavior when lower and upper are on:
> 1. same ext4 (copy)
> 2. same xfs + reflink patches + mkfs.xfs (copy)
> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
> 
> For comparison, on my laptop, xfstest overlay/001 (copy up of large
> sparse files) takes less than 1 second in the xfs reflink setup vs.
> 25 seconds on the rest of the setups.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 43fdc27..e432d7e 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -136,6 +136,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  		goto out_fput;
>  	}
>  
> +	/*
> +	 * Try to use clone_file_range to clone up within the same fs.
> +	 * On failure to clone entire file, fallback to copy loop.
> +	 */
> +	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
> +	if (error == -EXDEV || error == -EOPNOTSUPP)
> +		error = 0;
> +	else
> +		len = 0;
> +
>  	/* FIXME: copy up sparse files efficiently */
>  	while (len) {
>  		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;

That's nasty. Just use a goto to skip the code that doesn't need to
be run if vfs_clone_file_range() succeeds. This is much better, IMO:

	if (!error)
		goto out_done;
	if (error != -EXDEV && error != -EOPNOTSUPP)
		goto out_error;

	/* Can't clone, so now we try to copy the data */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

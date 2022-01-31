Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DFEC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 17:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380136AbiAaR1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380085AbiAaR1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 12:27:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8365C061714
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 09:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 752B560F54
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C824FC340E8;
        Mon, 31 Jan 2022 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643650025;
        bh=8e4j0CTXkbQr52hpCyJka9l93CMVbQoaG+lRKXnaX8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nQyF64+JA2lLcUhC1tHDsLWEMKvCdfgQaZg1TBdZa+yGVZqCMgilvLNZPCn0VA7B1
         JIma8KoCwu3RhmvT5WfNlhp0wfbALZ6rdQQcf74Dq1cHiJGSjNPX2qZNM0oUhg9iFB
         iq38WWnQ9yBiIFV5K/flJWV5bgodmnW5xJk+HjteyDWZuGa3iPyclq+xnwkyC3mF3h
         2ZzGSM57eSiFceWZpyROC3kQ4cK7O3k+PARixXGfgLTZrL+qwRHXlEukWd7WySJf1R
         Bi0Ve15wh0Ev9SAhcaJ41TT1YCcCzRxyCg3xYBQg52uOEYchQBpUqYwKi7STkQuXEJ
         rdWa0XyBgX1iA==
Date:   Mon, 31 Jan 2022 09:27:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fallocate() should call file_modified()
Message-ID: <20220131172705.GB8313@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
 <20220131064350.739863-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131064350.739863-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 05:43:47PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In XFS, we always update the inode change and modification time when
> any fallocate() operation succeeds.  Furthermore, as various
> fallocate modes can change the file contents (extending EOF,
> punching holes, zeroing things, shifting extents), we should drop
> file privileges like suid just like we do for a regular write().
> There's already a VFS helper that figures all this out for us, so
> use that.
> 
> The net effect of this is that we no longer drop suid/sgid if the
> caller is root, but we also now drop file capabilities.
> 
> We also move the xfs_update_prealloc_flags() function so that it now
> is only called by the scope that needs to set the the prealloc flag.
> 
> Based on a patch from Darrick Wong.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I think you can get rid of @flags entirely, right?

With that fixed, I think this looks good.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6eda41710a5a..223996822d84 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -953,6 +953,10 @@ xfs_file_fallocate(
>  			goto out_unlock;
>  	}
>  
> +	error = file_modified(file);
> +	if (error)
> +		goto out_unlock;
> +
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)
> @@ -1053,11 +1057,12 @@ xfs_file_fallocate(
>  			if (error)
>  				goto out_unlock;
>  		}
> -	}
>  
> -	error = xfs_update_prealloc_flags(ip, flags);
> -	if (error)
> -		goto out_unlock;
> +		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
> +		if (error)
> +			goto out_unlock;
> +
> +	}
>  
>  	/* Change file size if needed */
>  	if (new_size) {
> -- 
> 2.33.0
> 

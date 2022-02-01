Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FD0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 16:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241144AbiBAQhL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 11:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbiBAQhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 11:37:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47642C061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 08:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0943BB82EEE
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 16:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0792C340EB;
        Tue,  1 Feb 2022 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643733428;
        bh=ewvO2zsFTV1j1Zi7zpDXjUI012rL4JL2qgwhWS/Wv2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hp1H1N2u+KI+94OrdLP1W8RyqIEjRXea8QSDMCsgf5K+o+8cME9zADuZYC/tBOvtT
         Vdy2fIuNXf4ysoJa9x4CrYsfYxzK7L4WtCVrOsoLO5NSs+wUTVS9WDbYhhG1ijmI4b
         pXgQhG9BBJexpoPwWuNxeYlB3VfEMAyZpLKRR5phBvH+guKVXKjX+uf+BVhlQYFqa0
         HxoK5ln1vD6Lv184x/VGtf5didWMZXo+g8T945UVbM4/8ZsSpK4okXj8bAPSMtvKQJ
         4XFuFpG6R0df+HhMDgotZS+9pXSP24gC4KuRW7xh0ZXcn5qOy47TEXgMLQSE9AP1WL
         TUjP4tXe/XFNw==
Date:   Tue, 1 Feb 2022 08:37:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: ensure log flush at the end of a synchronous
 fallocate call
Message-ID: <20220201163708.GI8313@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
 <20220131064350.739863-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131064350.739863-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 05:43:50PM +1100, Dave Chinner wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Since we've started treating fallocate more like a file write, we
> should flush the log to disk if the user has asked for synchronous
> writes either by setting it via fcntl flags, or inode flags, or with
> the sync mount option.  We've already got a helper for this, so use
> it.
> 
> [Slightly massaged by <dchinner@redhat.com> to fit this patchset]

I think you made more than 'slight massage' changes...

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ddc3336e8f84..209cba0f0ddc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -861,6 +861,21 @@ xfs_break_layouts(
>  	return error;
>  }
>  
> +/* Does this file, inode, or mount want synchronous writes? */
> +static inline bool xfs_file_sync_writes(struct file *filp)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> +
> +	if (xfs_has_wsync(ip->i_mount))
> +		return true;
> +	if (filp->f_flags & (__O_SYNC | O_DSYNC))
> +		return true;
> +	if (IS_SYNC(file_inode(filp)))
> +		return true;
> +
> +	return false;
> +}
> +
>  #define	XFS_FALLOC_FL_SUPPORTED						\
>  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
>  		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
> @@ -1045,7 +1060,7 @@ xfs_file_fallocate(
>  	if (do_file_insert)
>  		error = xfs_insert_file_space(ip, offset, len);
>  
> -	if (file->f_flags & O_DSYNC)
> +	if (xfs_file_sync_writes(file))
>  		error = xfs_log_force_inode(ip);

...since the preceeding patches that you wrote enable simpler logic
here.  You've done all the (re)thinking necessary to get here, so I
think on those grounds:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  
>  out_unlock:
> @@ -1078,21 +1093,6 @@ xfs_file_fadvise(
>  	return ret;
>  }
>  
> -/* Does this file, inode, or mount want synchronous writes? */
> -static inline bool xfs_file_sync_writes(struct file *filp)
> -{
> -	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> -
> -	if (xfs_has_wsync(ip->i_mount))
> -		return true;
> -	if (filp->f_flags & (__O_SYNC | O_DSYNC))
> -		return true;
> -	if (IS_SYNC(file_inode(filp)))
> -		return true;
> -
> -	return false;
> -}
> -
>  STATIC loff_t
>  xfs_file_remap_range(
>  	struct file		*file_in,
> -- 
> 2.33.0
> 

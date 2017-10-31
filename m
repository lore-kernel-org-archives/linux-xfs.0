Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19032 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753298AbdJaQ4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 12:56:00 -0400
Date: Tue, 31 Oct 2017 09:55:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove redundant assignment to variable bit
Message-ID: <20171031165552.GD4911@magnolia>
References: <20171031111350.21208-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031111350.21208-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 31, 2017 at 11:13:50AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable bit is being assigned a value that is never read, hence
> the assignment is redundant and can be removed. Cleans up clang
> warning:
> 
> fs/xfs/libxfs/xfs_rtbitmap.c:675:3: warning: Value stored to
> 'bit' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 5d4e43ef4eea..ac09c4333485 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -672,7 +672,6 @@ xfs_rtmodify_range(
>  		/*
>  		 * Compute a mask of relevant bits.
>  		 */
> -		bit = 0;
>  		mask = ((xfs_rtword_t)1 << lastbit) - 1;
>  		/*
>  		 * Set/clear the active bits.
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

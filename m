Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfCTUG3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Mar 2019 16:06:29 -0400
Subject: Re: [PATCH 16/36] xfs_scrub: don't close mnt_fd when mnt_fd open
 fails
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259752927.31886.10173767197190539382.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c630e587-9ed4-587c-b91d-511219a9db0f@sandeen.net>
Date: Wed, 20 Mar 2019 15:06:28 -0500
MIME-Version: 1.0
In-Reply-To: <155259752927.31886.10173767197190539382.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we fail to open the mountpoint during phase 1 of scrub, don't bother
> trying to close the file descriptor since it's silly to spray error
> messages about that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase1.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 6b472147..04a5f4a9 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -59,9 +59,11 @@ xfs_cleanup_fs(
>  	if (ctx->datadev)
>  		disk_close(ctx->datadev);
>  	fshandle_destroy();
> -	error = close(ctx->mnt_fd);
> -	if (error)
> -		str_errno(ctx, _("closing mountpoint fd"));
> +	if (ctx->mnt_fd >= 0) {
> +		error = close(ctx->mnt_fd);
> +		if (error)
> +			str_errno(ctx, _("closing mountpoint fd"));
> +	}
>  	fs_table_destroy();
>  
>  	return true;
> 

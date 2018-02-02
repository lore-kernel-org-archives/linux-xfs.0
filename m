Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBBVjw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:39:52 -0500
Subject: Re: [PATCH 2/4] xfs_scrub: close dir_fd if we don't get a DIR pointer
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
 <151760739333.29371.879810257810332609.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <59ab35b1-95fc-1797-8fec-83027343f6bb@redhat.com>
Date: Fri, 2 Feb 2018 15:39:51 -0600
MIME-Version: 1.0
In-Reply-To: <151760739333.29371.879810257810332609.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 2/2/18 3:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we don't get a directory pointer, close dir_fd before jumping out.
> 
> Fixes-coverity-id: 1428799
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/vfs.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index e3c8e62..573a2d0 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -88,6 +88,7 @@ scan_fs_dir(
>  	/* Caller-specific directory checks. */
>  	if (!sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
>  		sft->moveon = false;
> +		close(dir_fd);
>  		goto out;
>  	}
>  
> @@ -95,6 +96,7 @@ scan_fs_dir(
>  	dir = fdopendir(dir_fd);
>  	if (!dir) {
>  		str_errno(ctx, sftd->path);
> +		close(dir_fd);
>  		goto out;
>  	}
>  	rewinddir(dir);
> 


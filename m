Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBBVq7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:46:59 -0500
Subject: Re: [PATCH 3/4] xfs_scrub: kill dead code
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
 <151760739949.29371.1187587453029792957.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <445524c9-6a9d-fd90-e3f3-7ae99b099fb3@redhat.com>
Date: Fri, 2 Feb 2018 15:46:58 -0600
MIME-Version: 1.0
In-Reply-To: <151760739949.29371.1187587453029792957.stgit@magnolia>
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
> We can't reach the return mess at the bottom of __xfs_scrub_test so get
> rid of it.
> 
> Fixes-coverity-id: 1428798
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/scrub.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index 0dbe11c..6abca2a 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -602,7 +602,6 @@ _("Kernel %s %s facility not detected."),
>  		str_info(ctx, ctx->mntpoint, "%s", strerror(errno));
>  		return true;
>  	}
> -	return error == 0 || (error && errno != EOPNOTSUPP && errno != ENOTTY);
>  }
>  
>  bool
> 


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45152 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933066AbeEWVhk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 17:37:40 -0400
Subject: Re: [PATCH v2] xfs_io: syncfs can fail
References: <20180516132738.27776-2-jlayton@kernel.org>
 <20180516171752.26583-1-jlayton@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a4461c24-0c64-ca22-ea52-7f62bd0e4866@sandeen.net>
Date: Wed, 23 May 2018 16:37:38 -0500
MIME-Version: 1.0
In-Reply-To: <20180516171752.26583-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-xfs@vger.kernel.org

On 5/16/18 12:17 PM, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> syncfs can return an error. Report one if it does. Also, ensure that
> xfs_io will exit with a non-zero status in that case.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   io/sync.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> v2: also set exitcode when reporting error
> 
> diff --git a/io/sync.c b/io/sync.c
> index c77263804a35..20ab50a7fcd4 100644
> --- a/io/sync.c
> +++ b/io/sync.c
> @@ -41,8 +41,10 @@ syncfs_f(
>   	int			argc,
>   	char			**argv)
>   {
> -	/* syncfs can't fail */
> -	syncfs(file->fd);
> +	if (syncfs(file->fd) < 0) {
> +		perror("syncfs");
> +		exitcode = 1;
> +	}
>   	return 0;
>   }
>   #endif
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34932 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbeEPO0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 10:26:13 -0400
Subject: Re: [PATCH 2/2] xfs_io: syncfs can fail
References: <20180516132738.27776-1-jlayton@kernel.org>
 <20180516132738.27776-2-jlayton@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bb25277e-bac5-afa0-0377-f5b247f87827@sandeen.net>
Date: Wed, 16 May 2018 09:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <20180516132738.27776-2-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org

On 5/16/18 8:27 AM, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> syncfs can return an error. Report one if it does.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>   io/sync.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/sync.c b/io/sync.c
> index c77263804a35..868cea7c051e 100644
> --- a/io/sync.c
> +++ b/io/sync.c
> @@ -41,8 +41,8 @@ syncfs_f(
>   	int			argc,
>   	char			**argv)
>   {
> -	/* syncfs can't fail */
> -	syncfs(file->fd);
> +	if (syncfs(file->fd) < 0)
> +		perror("syncfs");

In light of dchinner's recent reminder on another of my patches, this
should also set exitcode=1 here, so that the overall xfs_io exit code
will be non-zero if syncfs fails.

(I could just add that on merge if you prefer... assuming I remember)

Thanks,
-Eric

>   	return 0;
>   }
>   #endif
> 

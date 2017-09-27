Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969536AbdI0BkJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 21:40:09 -0400
Subject: Re: [PATCH] mkfs: don't overflow the subopts array
References: <20170927013828.GM5020@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a576e062-e88f-43f6-23b7-4b50a7d14507@redhat.com>
Date: Tue, 26 Sep 2017 20:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <20170927013828.GM5020@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 9/26/17 8:38 PM, Darrick J. Wong wrote:
> The new -d cowextsize option overran the subopts array; make it larger.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sigh, sorry for missing that on review, and build, and build, and another build. :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2acf8bf..7c407b0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -39,7 +39,7 @@ static int  ispow2(unsigned int i);
>  unsigned int		blocksize;
>  unsigned int		sectorsize;
>  
> -#define MAX_SUBOPTS	16
> +#define MAX_SUBOPTS	17
>  #define SUBOPT_NEEDS_VAL	(-1LL)
>  #define MAX_CONFLICTS	8
>  #define LAST_CONFLICT	(-1)
> 


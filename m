Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbeKPFa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 00:30:28 -0500
Subject: Re: [PATCH] xfs: make xfs_file_remap_range() static
References: <20181115011217.104363-1-ebiggers@kernel.org>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b2537174-6c2e-b7a4-9ad8-93bbc9001c53@oracle.com>
Date: Thu, 15 Nov 2018 12:21:19 -0700
MIME-Version: 1.0
In-Reply-To: <20181115011217.104363-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@kernel.org>, linux-xfs@vger.kernel.org

On 11/14/18 6:12 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> xfs_file_remap_range() is only used in fs/xfs/xfs_file.c, so make it
> static.
> 
> This addresses a gcc warning when -Wmissing-prototypes is enabled.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   fs/xfs/xfs_file.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 53c9ab8fb777f..e47425071e654 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -920,7 +920,7 @@ xfs_file_fallocate(
>   }
>   
>   
> -loff_t
> +STATIC loff_t
>   xfs_file_remap_range(
>   	struct file		*file_in,
>   	loff_t			pos_in,
> 

Looks ok to me.  You can add my review:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Thanks!
Allison

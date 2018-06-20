Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753972AbeFTDMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 23:12:21 -0400
Subject: Re: [PATCH] xfs: remove unused iolock arg from xfs_break_dax_layouts
References: <81e4bec1-e555-a351-444d-d7d69a2bf557@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <288d67a0-8492-9e1a-96e2-db2fdef2f87d@oracle.com>
Date: Tue, 19 Jun 2018 20:12:04 -0700
MIME-Version: 1.0
In-Reply-To: <81e4bec1-e555-a351-444d-d7d69a2bf557@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Looks fine.  Thx!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/19/2018 07:54 PM, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> For The Tidiness.
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a3e7767..6b31f41 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -735,7 +735,6 @@
>   static int
>   xfs_break_dax_layouts(
>   	struct inode		*inode,
> -	uint			iolock,
>   	bool			*did_unlock)
>   {
>   	struct page		*page;
> @@ -766,7 +765,7 @@
>   		retry = false;
>   		switch (reason) {
>   		case BREAK_UNMAP:
> -			error = xfs_break_dax_layouts(inode, *iolock, &retry);
> +			error = xfs_break_dax_layouts(inode, &retry);
>   			if (error || retry)
>   				break;
>   			/* fall through */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=WMhCKiOlxc9EQ6zH0cZZlWsm67RdVmus-ZabP3x9Jok&s=n5BRtmR0UQ9UJ2KLZnSXPduglP4XIYYblfczenRkNwI&e=
> 

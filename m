Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54740 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbdHUSo4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 14:44:56 -0400
Subject: Re: [PATCH] xfs_db: bit fuzzing should read the right bit when
 flipping
References: <20170819153210.GR4796@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d8b6ff6c-7e46-a27a-8a58-7c85b8037ea0@sandeen.net>
Date: Mon, 21 Aug 2017 13:44:54 -0500
MIME-Version: 1.0
In-Reply-To: <20170819153210.GR4796@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 8/19/17 10:32 AM, Darrick J. Wong wrote:
> The middle and last bit flip fuzz verbs need to read the same bit that
> they're trying to set.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/fuzz.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/fuzz.c b/db/fuzz.c
> index 53cedbc..d0d78a9 100644
> --- a/db/fuzz.c
> +++ b/db/fuzz.c
> @@ -226,7 +226,7 @@ fuzz_lastbit(
>  	int		nbits)
>  {
>  	setbit_l((char *)buf, bitoff + nbits - 1,
> -			!getbit_l((char *)buf, bitoff));
> +			!getbit_l((char *)buf, bitoff + nbits - 1));
>  	return true;
>  }
>  
> @@ -238,7 +238,7 @@ fuzz_middlebit(
>  	int		nbits)
>  {
>  	setbit_l((char *)buf, bitoff + nbits / 2,
> -			!getbit_l((char *)buf, bitoff));
> +			!getbit_l((char *)buf, bitoff + nbits / 2));
>  	return true;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39120 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdIITJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Sep 2017 15:09:44 -0400
Subject: Re: [PATCH] xfsdump: Use c99 defined int64_t instead of __int64_t
References: <20170909150230.44139-1-raj.khem@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9ba360ec-ef78-ad8d-c83e-9b95f7d60e60@sandeen.net>
Date: Sat, 9 Sep 2017 14:09:43 -0500
MIME-Version: 1.0
In-Reply-To: <20170909150230.44139-1-raj.khem@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>, linux-xfs@vger.kernel.org

Seems fine, but are the __uint32_t instances in the code not a problem?

Thanks,
-Eric

On 9/9/17 10:02 AM, Khem Raj wrote:
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  common/hsmapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/hsmapi.c b/common/hsmapi.c
> index 6054773..0709dbe 100644
> --- a/common/hsmapi.c
> +++ b/common/hsmapi.c
> @@ -585,7 +585,7 @@ HsmModifyExtentMap(
>  	struct getbmapx	*bmap)
>  {
>  	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
> -	__int64_t	length;
> +	int64_t		length;
>  
>  	if (bmap[0].bmv_entries <= 0) {
>  		return 1;	/* caller must already be at EOF */
> 

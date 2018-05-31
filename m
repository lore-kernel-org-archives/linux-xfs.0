Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755729AbeEaRJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 13:09:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VH5ik1148043
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:36 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2j9ev8fxd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:35 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4VH9Zxx016442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:35 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VH9Ydf022346
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:35 GMT
Subject: Re: [PATCH 1/4] xfs: xfs_rtword_t should be unsigned, not signed
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778443080.6891.5154502694195176365.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <97d4a800-9896-1f47-ec1b-72bab0668c56@oracle.com>
Date: Thu, 31 May 2018 10:09:34 -0700
MIME-Version: 1.0
In-Reply-To: <152778443080.6891.5154502694195176365.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


On 05/31/2018 09:33 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_rtword_t is used for bit manipulations in the realtime bitmap file.
> Since we're performing bit shifts with this type, we don't want sign
> extension and we don't want to be left shifting negative quantities
> because that's undefined behavior.
> 
> This also shuts up these UBSAN warnings:
> UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_rtbitmap.c:833:48
> signed integer overflow:
> -2147483648 - 1 cannot be represented in type 'int'
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_types.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 3c560695c546..ea18449bd732 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -30,7 +30,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>   typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>   
>   typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
> -typedef int32_t		xfs_rtword_t;	/* word type for bitmap manipulations */
> +typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */

Looks good.  The spacing turned out a little offset though?  You can add 
my review.

Reviewed by: Allison Henderson <allison.henderson@oracle.com>
>   
>   typedef int64_t		xfs_lsn_t;	/* log sequence number */
>   typedef int32_t		xfs_tid_t;	/* transaction identifier */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=n7ydpJVQ4YnI_crj8hHWumC8ltUYOP1uX00s9_PTdcA&s=4PrUlxl9KFk-MjkyiZuib9VkeSUbfIv2VV_E4jyPzOI&e=
> 

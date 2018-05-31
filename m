Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755719AbeEaRJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 13:09:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VH5qaN148115
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:53 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2j9ev8fxe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4VH9rQ7017331
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:53 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4VH9qIk003961
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:52 GMT
Subject: Re: [PATCH 3/4] xfs: strengthen rtalloc query range checks
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778444301.6891.15337114742525069233.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4b383287-eb11-9194-6c73-ef3b899724a0@oracle.com>
Date: Thu, 31 May 2018 10:09:51 -0700
MIME-Version: 1.0
In-Reply-To: <152778444301.6891.15337114742525069233.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/31/2018 09:34 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Strengthen the rtalloc range query checks to make sure that the keys do
> not run off the end of the realtime device inappropriately.  Note that
> the query range functions require units of rt extents, not blocks,
> despite the type name.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_rtbitmap.c |    7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 7712f282d172..1855182c11ec 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1038,8 +1038,11 @@ xfs_rtalloc_query_range(
>   
>   	if (low_rec->ar_startblock > high_rec->ar_startblock)
>   		return -EINVAL;
> -	else if (low_rec->ar_startblock == high_rec->ar_startblock)
> +	if (low_rec->ar_startblock >= mp->m_sb.sb_rextents ||
> +	    low_rec->ar_startblock == high_rec->ar_startblock)
>   		return 0;
> +	if (high_rec->ar_startblock >= mp->m_sb.sb_rextents)
> +		high_rec->ar_startblock = mp->m_sb.sb_rextents - 1;
>   
>   	/* Iterate the bitmap, looking for discrepancies. */
>   	rtstart = low_rec->ar_startblock;
> @@ -1083,7 +1086,7 @@ xfs_rtalloc_query_all(
>   	struct xfs_rtalloc_rec		keys[2];
>   
>   	keys[0].ar_startblock = 0;
> -	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rblocks;
> +	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rextents - 1;
>   	keys[0].ar_blockcount = keys[1].ar_blockcount = 0;
>   
>   	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
> 
Looks ok.
Reviewed by: Allison Henderson <allison.henderson@oracle.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=MFVzrJTKXLIlUFVLz6r3OL2vnmcjObSpReWRk7GYGuo&s=hxgtdqlBCiIpubwA7m9BUItlt1b_6qY1TueIDaRqA5o&e=
> 

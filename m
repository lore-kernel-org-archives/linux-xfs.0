Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbeFVGl6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:41:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6cpsh068600
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:41:57 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jrp8hrp1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:41:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6fuLt015553
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:41:56 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6fuTF006618
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:41:56 GMT
Subject: Re: [PATCH 7/8] xfs: fix off-by-one error in xfs_rtalloc_query_range
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960590720.26246.9373633806502479237.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5abc6ed6-618b-c28a-ee00-fb439bba1119@oracle.com>
Date: Thu, 21 Jun 2018 23:41:52 -0700
MIME-Version: 1.0
In-Reply-To: <152960590720.26246.9373633806502479237.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 8ad560d2565e6 ("xfs: strengthen rtalloc query range checks")
> we strengthened the input parameter checks in the rtbitmap range query
> function, but introduced an off-by-one error in the process.  The call
> to xfs_rtfind_forw deals with the high key being rextents, but we clamp
> the high key to rextents - 1.  This causes the returned results to stop
> one block short of the end of the rtdev, which is incorrect.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 65fc4ed2e9a1..b228c821bae6 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1029,8 +1029,8 @@ xfs_rtalloc_query_range(
>   	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
>   	    low_rec->ar_startext == high_rec->ar_startext)
>   		return 0;
> -	if (high_rec->ar_startext >= mp->m_sb.sb_rextents)
> -		high_rec->ar_startext = mp->m_sb.sb_rextents - 1;
> +	if (high_rec->ar_startext > mp->m_sb.sb_rextents)
> +		high_rec->ar_startext = mp->m_sb.sb_rextents;
>   
>   	/* Iterate the bitmap, looking for discrepancies. */
>   	rtstart = low_rec->ar_startext;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=zsOQBNyhInhyExIQUb5j_oNmILj9vGQF3A7q32gZLuQ&s=JMHXMs2LK6ulhFTcRhasFM3G1BC2jgwHvrD9CU3INrk&e=
> 

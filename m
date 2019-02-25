Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBYSJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 13:09:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1PI9LB2142759
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:09:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qtwktys5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:09:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1PI9FCD017339
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:09:15 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1PI9FHl030151
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:09:15 GMT
Subject: Re: [PATCH 2/2] xfs: fix backwards endian conversion in scrub
References: <155111649548.15126.8995811550165658297.stgit@magnolia>
 <155111650186.15126.5896442701967175896.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <94dc02ba-ba62-012c-40b6-afb5d1bb201d@oracle.com>
Date: Mon, 25 Feb 2019 11:09:14 -0700
MIME-Version: 1.0
In-Reply-To: <155111650186.15126.5896442701967175896.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 2/25/19 10:41 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a backwards endian conversion of a constant.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/scrub/agheader.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 9d4e8293d37e..ddf06bfaa29d 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -399,7 +399,7 @@ xchk_agf_xref_cntbt(
>   	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
>   		return;
>   	if (!have) {
> -		if (agf->agf_freeblks != be32_to_cpu(0))
> +		if (agf->agf_freeblks != cpu_to_be32(0))
>   			xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
>   		return;
>   	}
> 

Good catch.  I suppose there's not as much need to do the conversion if 
the value is 0?  But I think the call helps to make clear that the value 
is supposed to be in big endian.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

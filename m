Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbeFVGTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:19:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6IqHh016906
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:19:24 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2jrp8hrm9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:19:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6JNtx018863
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:19:24 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6JNr2027939
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:19:23 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/8] xfs: allow empty transactions while frozen
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960587035.26246.9220199251468325711.stgit@magnolia>
Message-ID: <d76b0bef-f2ab-2a02-4a7d-9458948b405f@oracle.com>
Date: Thu, 21 Jun 2018 23:18:58 -0700
MIME-Version: 1.0
In-Reply-To: <152960587035.26246.9220199251468325711.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit e89c041338ed6ef ("xfs: implement the GETFSMAP ioctl") we
> created the ability to obtain empty transactions.  These transactions
> have no log or block reservations and therefore can't modify anything.
> Since they're also NO_WRITECOUNT they can run while the fs is frozen,
> so we don't need to WARN_ON about that usage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_trans.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e040af120b69..524f543c5b82 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -258,7 +258,12 @@ xfs_trans_alloc(
>   	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>   		sb_start_intwrite(mp->m_super);
>   
> -	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	/*
> +	 * Zero-reservation ("empty") transactions can't modify anything, so
> +	 * they're allowed to run while we're frozen.
> +	 */
> +	WARN_ON(resp->tr_logres > 0 &&
> +		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
>   	atomic_inc(&mp->m_active_trans);
>   
>   	tp = kmem_zone_zalloc(xfs_trans_zone,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=jfRT1oYtPVNVBt-lMSR8ZrPgEPjfv7foQ0meuw0oGxM&s=GsacuLUdUkUoZWMAAmlRTyyR7FByN9OA43H6dYDIK6Q&e=
> 

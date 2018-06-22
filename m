Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVGhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:37:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6Yc7b003300
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:37:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2jrp8hrnn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:37:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6bj8x009359
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:37:46 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5M6bjSh030901
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:37:45 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 6/8] xfs: fix uninitialized field in rtbitmap fsmap
 backend
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960590105.26246.13020311829179912536.stgit@magnolia>
Message-ID: <24367f21-b71c-4410-0741-582efe99ab3d@oracle.com>
Date: Thu, 21 Jun 2018 23:37:38 -0700
MIME-Version: 1.0
In-Reply-To: <152960590105.26246.13020311829179912536.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks ok:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Initialize the extent count field of the high key so that when we use
> the high key to synthesize an 'unknown owner' record (i.e. used space
> record) at the end of the queried range we have a field with which to
> compute rm_blockcount.  This is not strictly necessary because the
> synthesizer never uses the rm_blockcount field, but we can shut up the
> static code analysis anyway.
> 
> Coverity-id: 1437358
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_fsmap.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index c34fa9c342f2..2be795b01ce0 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -531,6 +531,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
>   
>   	/* Report any gaps at the end of the rtbitmap */
>   	info->last = true;
> +	ahigh.ar_extcount = 0;
>   	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
>   	if (error)
>   		goto err;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=kG0q-nvJIi8c2zctskm0vTRxZIBqEK8mud41-TvKgAI&s=c2QBy7jBkpo_q56thW4Lrp4PTZl40Ulep8xufwE5NVc&e=
> 

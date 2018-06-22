Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVGcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:32:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6VYAW025593
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:32:08 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jrp8hrnfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:32:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6W7Np025521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:32:07 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5M6W7aJ025290
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:32:07 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 3/8] xfs: don't trip over negative free space in
 xfs_reserve_blocks
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588253.26246.18220681679037001885.stgit@magnolia>
Message-ID: <dd3a9703-e602-9b21-5f63-600a2ded076c@oracle.com>
Date: Thu, 21 Jun 2018 23:32:04 -0700
MIME-Version: 1.0
In-Reply-To: <152960588253.26246.18220681679037001885.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks ok, thx!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we somehow end up with a filesystem that has fewer free blocks than
> the blocks set aside to avoid ENOSPC deadlocks, it's possible that the
> free space calculation in xfs_reserve_blocks will spit out a negative
> number (because percpu_counter_sum returns s64).  We fail to notice
> this negative number and set fdblks_delta to it.  Now we increment
> fdblocks(!) and the unsigned type of m_resblks means that we end up
> setting a ridiculously huge m_resblks reservation.
> 
> Avoid this comedy of errors by detecting the negative free space and
> returning -ENOSPC.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_fsops.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a7afcad6b711..3f2bd6032cf8 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -387,7 +387,7 @@ xfs_reserve_blocks(
>   	do {
>   		free = percpu_counter_sum(&mp->m_fdblocks) -
>   						mp->m_alloc_set_aside;
> -		if (!free)
> +		if (free <= 0)
>   			break;
>   
>   		delta = request - mp->m_resblks;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=N6x3Cwn-CGLBE6LOOAbcetDshZ_SB_Mnv0Jn2FdPq38&s=CizYCC09hHj0NL-62QgWA-Tla03lpYgbx5ytFsHSFx0&e=
> 

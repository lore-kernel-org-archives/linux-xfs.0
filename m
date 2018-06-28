Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935443AbeF1VLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 17:11:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5SL9Ngt181050
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:11:46 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2jum0abyme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:11:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5SLBjUc022506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:11:46 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5SLBj3a002064
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:11:45 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/21] xfs: don't assume a left rmap when allocating a new
 rmap
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986821631.3155.13981921703707802906.stgit@magnolia>
Message-ID: <d811feb2-e614-f69b-ff23-d02c83bf04f7@oracle.com>
Date: Thu, 28 Jun 2018 14:11:38 -0700
MIME-Version: 1.0
In-Reply-To: <152986821631.3155.13981921703707802906.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 06/24/2018 12:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The original rmap code assumed that there would always be at least one
> rmap in the rmapbt (the AG sb/agf/agi) and so errored out if it didn't
> find one.  This assumption isn't true for the rmapbt repair function
> (and it won't be true for realtime rmap either), so remove the check and
> just deal with the situation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_rmap.c |   24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index d4460b0d2d81..8b2a2f81d110 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -753,19 +753,19 @@ xfs_rmap_map(
>   			&have_lt);
>   	if (error)
>   		goto out_error;
> -	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
> -
> -	error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
> -	if (error)
> -		goto out_error;
> -	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
> -	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> -			cur->bc_private.a.agno, ltrec.rm_startblock,
> -			ltrec.rm_blockcount, ltrec.rm_owner,
> -			ltrec.rm_offset, ltrec.rm_flags);
> +	if (have_lt) {
> +		error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
> +		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> +				cur->bc_private.a.agno, ltrec.rm_startblock,
> +				ltrec.rm_blockcount, ltrec.rm_owner,
> +				ltrec.rm_offset, ltrec.rm_flags);
>   
> -	if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
> -		have_lt = 0;
> +		if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
> +			have_lt = 0;
> +	}
>   
>   	XFS_WANT_CORRUPTED_GOTO(mp,
>   		have_lt == 0 ||
> 

Alrighty, looks ok after some digging around. I'm still a little puzzled 
as to why the original code raised the assert without checking to see 
whats on the other side of the cursor?  Assuming the error condition
was supposed to be the case when the tree was empty.  In any case, it 
looks correct now.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=Q2PdVMOGp7_huNLFbP6xty0mgocZk65leUyLVRvSsSY&s=6-FSoklyIhTEtg811gAG43N9-7Z-sYFsm7zv33EadgQ&e=
> 

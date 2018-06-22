Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34760 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeFVGV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:21:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6J9AC125898
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:26 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2jrp8erma5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6LO1A007709
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:25 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6LOGd028929
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:24 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/8] xfs: fix fdblocks accounting w/ RMAPBT per-AG
 reservation
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960587647.26246.17630479835058118272.stgit@magnolia>
Message-ID: <863fb6cc-def5-fead-854e-368a3538cd70@oracle.com>
Date: Thu, 21 Jun 2018 23:21:14 -0700
MIME-Version: 1.0
In-Reply-To: <152960587647.26246.17630479835058118272.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Alrighty, thx for the comments
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In __xfs_ag_resv_init we incorrectly calculate the amount by which to
> decrease fdblocks when reserving blocks for the rmapbt.  Because rmapbt
> allocations do not decrease fdblocks, we must decrease fdblocks by the
> entire size of the requested reservation in order to achieve our goal of
> always having enough free blocks to satisfy an rmapbt expansion.
> 
> This is in contrast to the refcountbt/finobt, which /do/ subtract from
> fdblocks whenever they allocate a block.  For this allocation type we
> preserve the existing behavior where we decrease fdblocks only by the
> requested reservation minus the size of the existing tree.
> 
> This fixes the problem where the available block counts reported by
> statfs change across a remount if there had been an rmapbt size change
> since mount time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_ag_resv.c |   31 +++++++++++++++++++++++++++----
>   1 file changed, 27 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 84db76e0e3e3..fecd187fcf2c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -157,6 +157,7 @@ __xfs_ag_resv_free(
>   	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
>   	resv->ar_reserved = 0;
>   	resv->ar_asked = 0;
> +	resv->ar_orig_reserved = 0;
>   
>   	if (error)
>   		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
> @@ -189,13 +190,34 @@ __xfs_ag_resv_init(
>   	struct xfs_mount		*mp = pag->pag_mount;
>   	struct xfs_ag_resv		*resv;
>   	int				error;
> -	xfs_extlen_t			reserved;
> +	xfs_extlen_t			hidden_space;
>   
>   	if (used > ask)
>   		ask = used;
> -	reserved = ask - used;
>   
> -	error = xfs_mod_fdblocks(mp, -(int64_t)reserved, true);
> +	switch (type) {
> +	case XFS_AG_RESV_RMAPBT:
> +		/*
> +		 * Space taken by the rmapbt is not subtracted from fdblocks
> +		 * because the rmapbt lives in the free space.  Here we must
> +		 * subtract the entire reservation from fdblocks so that we
> +		 * always have blocks available for rmapbt expansion.
> +		 */
> +		hidden_space = ask;
> +		break;
> +	case XFS_AG_RESV_METADATA:
> +		/*
> +		 * Space taken by all other metadata btrees are accounted
> +		 * on-disk as used space.  We therefore only hide the space
> +		 * that is reserved but not used by the trees.
> +		 */
> +		hidden_space = ask - used;
> +		break;
> +	default:
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +	error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
>   	if (error) {
>   		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
>   				error, _RET_IP_);
> @@ -216,7 +238,8 @@ __xfs_ag_resv_init(
>   
>   	resv = xfs_perag_resv(pag, type);
>   	resv->ar_asked = ask;
> -	resv->ar_reserved = resv->ar_orig_reserved = reserved;
> +	resv->ar_orig_reserved = hidden_space;
> +	resv->ar_reserved = ask - used;
>   
>   	trace_xfs_ag_resv_init(pag, type, ask);
>   	return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=57YhFRxyRqjdPfAPfs4wnqA9n455Z75z7qYPx5N5g5A&s=xlMBoLgUrvEbqMKbDc72qnV-gJsBNzbR1VFqvVF9XKg&e=
> 

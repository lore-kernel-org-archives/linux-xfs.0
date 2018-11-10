Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbeKJRGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 12:06:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA6quG6096079
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 07:22:47 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nnprtr9pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 07:22:47 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAA7MkCl011439
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 07:22:46 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAA7Mk0l030212
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 07:22:46 GMT
Subject: Re: [PATCH 3/6] xfs_repair: skip block reservation when fixing
 freelist
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181073309.3727.6459189318125795042.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <791ce192-d0f8-2d77-4fe0-66cfdbb1fd3a@oracle.com>
Date: Sat, 10 Nov 2018 00:22:45 -0700
MIME-Version: 1.0
In-Reply-To: <154181073309.3727.6459189318125795042.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 11/9/18 5:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> AGFL blocks are considered to be part of the fdblocks count, so there's
> no need to obtain a block reservation when fixing the AGFL as part of
> repair.  Asking for a reservation can cause repair to fail if the
> superblock claims zero fdblocks because we haven't gotten far enough
> into phase 5 to have reset the superblock counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/rmap.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index ebb5a3ad..c5a86646 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1374,8 +1374,7 @@ fix_freelist(
>   	args.agno = agno;
>   	args.alignment = 1;
>   	args.pag = libxfs_perag_get(mp, agno);
> -	error = -libxfs_trans_alloc_rollable(mp,
> -			libxfs_alloc_min_freelist(mp, args.pag), &tp);
> +	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
>   	if (error)
>   		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
>   				agno, error);
> 

Ok, you can add my review:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

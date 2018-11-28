Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45446 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbeK2KhZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 05:37:25 -0500
Subject: Re: [PATCH 3/6] xfs_repair: skip block reservation when fixing
 freelist
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181073309.3727.6459189318125795042.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7fda49c8-8bae-940f-b1ae-144a1d3533ee@sandeen.net>
Date: Wed, 28 Nov 2018 17:34:05 -0600
MIME-Version: 1.0
In-Reply-To: <154181073309.3727.6459189318125795042.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 11/9/18 6:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> AGFL blocks are considered to be part of the fdblocks count, so there's
> no need to obtain a block reservation when fixing the AGFL as part of
> repair.  Asking for a reservation can cause repair to fail if the
> superblock claims zero fdblocks because we haven't gotten far enough
> into phase 5 to have reset the superblock counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

OK, makes sense to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/rmap.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index ebb5a3ad..c5a86646 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1374,8 +1374,7 @@ fix_freelist(
>  	args.agno = agno;
>  	args.alignment = 1;
>  	args.pag = libxfs_perag_get(mp, agno);
> -	error = -libxfs_trans_alloc_rollable(mp,
> -			libxfs_alloc_min_freelist(mp, args.pag), &tp);
> +	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
>  	if (error)
>  		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
>  				agno, error);
> 

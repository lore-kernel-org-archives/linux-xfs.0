Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbeEQToY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 15:44:24 -0400
Date: Thu, 17 May 2018 12:44:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs.xfs: if either sunit or swidth is nonzero, the
 other must be as well
Message-ID: <20180517194419.GU23858@magnolia>
References: <026467a9-0249-26a4-9661-c2f5f6e0586e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026467a9-0249-26a4-9661-c2f5f6e0586e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, May 17, 2018 at 01:33:29PM -0500, Eric Sandeen wrote:
> Don't allow the user to set one but not the other.
> 
> Reported-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 78d0ce5..b356d4d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2271,7 +2271,8 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>  		dswidth = big_dswidth;
>  	}
> -	if (dsunit && (!dswidth || (dswidth % dsunit != 0))) {
> +	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> +           (dsunit && (dswidth % dsunit != 0))) {
>  		fprintf(stderr,
>  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  			dswidth, dsunit);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

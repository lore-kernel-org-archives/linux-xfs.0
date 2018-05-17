Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751047AbeEQVLX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 17:11:23 -0400
Date: Thu, 17 May 2018 16:11:21 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: if either sunit or swidth is nonzero, the
 other must be as well
Message-ID: <20180517211121.GA31576@redhat.com>
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
> ---

looks fine.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

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

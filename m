Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56740 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfAaUk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 15:40:58 -0500
Date: Thu, 31 Jan 2019 12:40:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: fix incorrect return value in namecheck()
Message-ID: <20190131204048.GD5761@magnolia>
References: <f17672e5-63eb-0f74-afdf-55ff006ee28d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17672e5-63eb-0f74-afdf-55ff006ee28d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 31, 2019 at 02:20:58PM -0600, Eric Sandeen wrote:
> Obviously a directory entry with a '/' in the name should return
> 1, i.e. failure.  This was just a dumb thinko.
> 
> Fixes: 45571fd5885d ("xfs_repair: allow '/' in attribute names")
> 
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Sez me who complained about this weeks ago on IRC and then RVBd the
broken version so who knows where my brain went lunchtime lol...)

--D

> ---
> 
> diff --git a/repair/da_util.c b/repair/da_util.c
> index c5e690c..4a258e5 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -31,7 +31,7 @@ namecheck(
>  
>  	for (c = name, i = 0; i < length; i++, c++) {
>  		if (isadir && *c == '/')
> -			return 0;
> +			return 1;
>  		if (*c == '\0')
>  			return 1;
>  	}
> 

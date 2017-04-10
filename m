Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23958 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdDJWjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 18:39:02 -0400
Date: Mon, 10 Apr 2017 15:38:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: document barrier deprecation in xfs(5)
Message-ID: <20170410223855.GH10459@birch.djwong.org>
References: <d24e1def-2f2d-5699-46e0-633d613004da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d24e1def-2f2d-5699-46e0-633d613004da@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 10, 2017 at 11:53:53AM -0500, Eric Sandeen wrote:
> Since kernel v4.10, the barrier mount option is deprecated:
> 
> 2291dab2 xfs: Always flush caches when integrity is required
> 4cf4573d xfs: deprecate barrier/nobarrier mount option
> 
> Document this fact in the xfs(5) manpage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index c7fb780..745dad4 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -133,6 +133,12 @@ CRC enabled filesystems always use the attr2 format, and so
>  will reject the noattr2 mount option if it is set.
>  .TP
>  .BR barrier | nobarrier
> +Note: This option has been
> +.B deprecated
> +as of kernel v4.10; in that version, integrity operations are
> +always performed and the mount option is ignored.  These mount
> +options will be removed no earlier than kernel v4.15.
> +.sp
>  Enables/disables the use of block layer write barriers for
>  writes into the journal and for data integrity operations.
>  This allows for drive level write caching to be enabled, for
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

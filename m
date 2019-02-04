Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbfBDVhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 16:37:43 -0500
Date: Mon, 4 Feb 2019 13:37:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: allow disabling xfs tracepoints via Kconfig
Message-ID: <20190204213738.GB7991@magnolia>
References: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 04, 2019 at 10:20:35PM +0100, Rasmus Villemoes wrote:
> linux/tracepoints.h allows individual subsystems to disable their
> tracepoints. Add such a knob for xfs. Disabling XFS_TRACEPOINTS
> reduces the resident size of xfs.ko by about a third, or ~350 KiB.

LOL. :)

> $ size /tmp/xfs/{a,b}/xfs.ko
>    text    data     bss     dec     hex filename
>  671726    4129     632  676487   a5287 /tmp/xfs/a/xfs.ko
>  893192  166737     632 1060561  102ed1 /tmp/xfs/b/xfs.ko
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  fs/xfs/Kconfig     | 9 +++++++++
>  fs/xfs/xfs_trace.h | 4 ++++

I think a similar thing ought to apply to fs/xfs/scrub/trace.h, right?

More general questions:

(a) Do we want to be doing this on a per-subsystem basis?

(b) Since xfs_scrub is a separate trace domain, do we want a separate
Kconfig item for toggling scrub trace, or is one big one enough?

(I can't think of why I'd want one on and the other off.)

--D

>  2 files changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 457ac9f97377..d099e6d9f6c5 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -141,3 +141,12 @@ config XFS_ASSERT_FATAL
>  	  result in warnings.
>  
>  	  This behavior can be modified at runtime via sysfs.
> +
> +config XFS_TRACEPOINTS
> +	bool "XFS tracepoints"
> +	default y
> +	depends on XFS_FS && TRACEPOINTS
> +	help
> +	  Say Y here to build XFS with tracepoints.
> +
> +	  You can say N here to reduce the size of the kernel image.
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6fcc893dfc91..5fb3d5c0483e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -6,6 +6,10 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM xfs
>  
> +#ifndef CONFIG_XFS_TRACEPOINTS
> +#define NOTRACE
> +#endif
> +
>  #if !defined(_TRACE_XFS_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_XFS_H
>  
> -- 
> 2.20.1
> 

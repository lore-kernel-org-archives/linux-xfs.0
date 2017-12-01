Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34417 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdLAW32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 17:29:28 -0500
Date: Fri, 1 Dec 2017 14:29:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: add scrub to XFS_BUILD_OPTIONS
Message-ID: <20171201222922.GZ21412@magnolia>
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <f5769e20-970a-53f5-4fc7-2afd11304ce2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5769e20-970a-53f5-4fc7-2afd11304ce2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 01, 2017 at 04:12:34PM -0600, Eric Sandeen wrote:
> Advertise this config option along with the others.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index fcc5dfc..8cee8e8 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -44,6 +44,12 @@
>  # define XFS_REALTIME_STRING
>  #endif
>  
> +#ifdef CONFIG_XFS_ONLINE_SCRUB
> +# define XFS_SCRUB_STRING	"scrub, "
> +#else
> +# define XFS_SCRUB_STRING
> +#endif

I don't mind this addition to the build options, though I had pictured
scrub becoming an integral part of xfs some day and not remaining a
configurable option.

That said I haven't evaluated how much scrub bloats up xfs nor do I know
if the kernel tinyfication people would actually want to turn it off??

(For my part I prefer it some day not be Kconfig option so that it won't
bitrot ala CONFIG_XFS_RT=y.)

--D

> +
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -54,6 +60,7 @@
>  #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
>  				XFS_SECURITY_STRING \
>  				XFS_REALTIME_STRING \
> +				XFS_SCRUB_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

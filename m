Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59308 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfFEPNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 11:13:43 -0400
Date: Wed, 5 Jun 2019 08:13:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] include WARN, REPAIR build options in XFS_BUILD_OPTIONS
Message-ID: <20190605151318.GG1200785@magnolia>
References: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 04, 2019 at 06:23:25PM -0500, Eric Sandeen wrote:
> The XFS_BUILD_OPTIONS string, shown at module init time and 
> in modinfo output, does not currently include all available
> build options.  So, add in CONFIG_XFS_WARN and CONFIG_XFS_REPAIR.
> 
> It has been suggested in some quarters
> That this is not enough.
> Well ... 
> 
> Anybody who would like to see this in a sysfs file can send
> a patch.  :)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I might send that patch, but would like to have the string
> advertising build options be complete, for now.
> 

Er, are you working on that patch now?

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 21cb49a..763e43d 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -38,6 +38,18 @@
>  # define XFS_SCRUB_STRING
>  #endif
>  
> +#ifdef CONFIG_XFS_ONLINE_REPAIR
> +# define XFS_REPAIR_STRING	"repair, "
> +#else
> +# define XFS_REPAIR_STRING
> +#endif
> +
> +#ifdef CONFIG_XFS_WARN
> +# define XFS_WARN_STRING	"verbose warnings, "
> +#else
> +# define XFS_WARN_STRING
> +#endif
> +
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -49,6 +61,8 @@
>  				XFS_SECURITY_STRING \
>  				XFS_REALTIME_STRING \
>  				XFS_SCRUB_STRING \
> +				XFS_REPAIR_STRING \
> +				XFS_WARN_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> 

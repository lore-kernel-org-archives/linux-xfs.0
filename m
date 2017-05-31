Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31451 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbdEaPgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2017 11:36:44 -0400
Date: Wed, 31 May 2017 08:36:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/2] xfs: define fatal assert build time tunable
Message-ID: <20170531153637.GF4519@birch.djwong.org>
References: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
 <1494426711-6934-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494426711-6934-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 10, 2017 at 10:31:51AM -0400, Brian Foster wrote:
> While configurable at runtime, the DEBUG mode assert failure
> behavior is usually either desired or not for a particular
> situation. For example, developers using kernel modules may prefer
> for fatal asserts to remain disabled across module reloads while QE
> engineers doing broad regression testing may prefer to have fatal
> asserts enabled on boot to facilitate data collection for bug
> reports.
> 
> To provide a compromise/convenience for developers, create a Kconfig
> option that sets the default value of the DEBUG mode 'bug_on_assert'
> sysfs tunable. The default behavior remains to trigger kernel BUGs
> on assert failures to preserve existing behavior across kernel
> configuration updates with DEBUG mode enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/Kconfig       | 13 +++++++++++++
>  fs/xfs/xfs.h         |  4 ++++
>  fs/xfs/xfs_globals.c |  7 +++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 35faf12..1b98cfa 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -96,3 +96,16 @@ config XFS_DEBUG
>  	  not useful unless you are debugging a particular problem.
>  
>  	  Say N unless you are an XFS developer, or you play one on TV.
> +
> +config XFS_ASSERT_FATAL
> +	bool "XFS fatal asserts"
> +	default y
> +	depends on XFS_FS && XFS_DEBUG
> +	help
> +	  Set the default DEBUG mode ASSERT failure behavior.
> +
> +	  Say Y here to cause DEBUG mode ASSERT failures to result in fatal
> +	  errors that BUG() the kernel by default. If you say N, ASSERT failures
> +	  result in warnings.
> +
> +	  This behavior can be modified at runtime via sysfs.
> diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
> index a742c47..80cd0fd 100644
> --- a/fs/xfs/xfs.h
> +++ b/fs/xfs/xfs.h
> @@ -24,6 +24,10 @@
>  #define XFS_BUF_LOCK_TRACKING 1
>  #endif
>  
> +#ifdef CONFIG_XFS_ASSERT_FATAL
> +#define XFS_ASSERT_FATAL 1
> +#endif
> +
>  #ifdef CONFIG_XFS_WARN
>  #define XFS_WARN 1
>  #endif
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 673adf0..3e1cc30 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -47,6 +47,9 @@ xfs_param_t xfs_params = {
>  
>  struct xfs_globals xfs_globals = {
>  	.log_recovery_delay	=	0,	/* no delay by default */
> -	.bug_on_assert		=	true,	/* historical default in DEBUG
> -						 * mode */
> +#ifdef XFS_ASSERT_FATAL

Minor nit to pick, but if you're only testing that XFS_ASSERT_FATAL is
defined, you could just '#define XFS_ASSERT_FATAL' without providing a
value.... or '#if XFS_ASSERT_FATAL' here.

OTOH XFS_WARN also does that, and we reach the same ends regardless of
which way we do it.  I'm willing to pull this in for 4.13 as-is, if
nobody objects.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	.bug_on_assert		=	true,	/* assert failures BUG() */
> +#else
> +	.bug_on_assert		=	false,	/* assert failures WARN() */
> +#endif
>  };
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

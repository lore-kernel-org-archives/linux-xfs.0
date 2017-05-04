Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54904 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbdEDS6e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 14:58:34 -0400
Subject: Re: [PATCH] xfs: make fatal assert failures conditional in debug mode
References: <1493922564-14273-1-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7b09b8c0-53dc-37e4-a6c0-88835515345b@sandeen.net>
Date: Thu, 4 May 2017 13:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <1493922564-14273-1-git-send-email-bfoster@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On 5/4/17 1:29 PM, Brian Foster wrote:
> XFS currently supports two debug modes: XFS_WARN enables assert
> failure warnings and XFS_DEBUG converts assert failures to fatal
> errors (via BUG()) and enables additional runtime debug code.
> 
> While the behavior to BUG the kernel on assert failure is useful in
> certain test scenarios, it is also useful for development/debug to
> enable debug mode code without having to crash the kernel on an
> assert failure.
> 
> To provide this additional flexibility, update XFS debug mode to not
> BUG() the kernel by default and create a new XFS kernel
> configuration option to enable fatal assert failures when debug mode
> is enabled. To provide backwards compatibility with current
> behavior, enable the fatal asserts option by default when debug mode
> is enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This tweaks the rfc version based on feedback from Christoph and
> Darrick. The config option is renamed to minimize confusion and the
> logic is basically flipped to disable BUG() behavior by default in
> XFS_DEBUG mode and have the new config option turn it on. This option is
> dependent on DEBUG mode because I don't believe there is a compelling
> use case for XFS_WARN mode with fatal asserts and I'd rather not
> unnecessarily increase the configuration matrix.
> 
> Note that the new config option is set 'default y' simply to provide
> backwards compatibility with current behavior (so users expecting DEBUG
> mode kernels to BUG() will continue to see that behavior without
> requiring further config modifications). Thoughts, reviews, flames
> appreciated.
> 
> Brian
> 
> v1:
> - Use a new config option rather than reuse XFS_WARN.
> - Disable BUG() in DEBUG mode by default and flip the logic of the new
>   config option.
> rfc: http://www.spinics.net/lists/linux-xfs/msg06390.html
> 
>  fs/xfs/Kconfig     |  8 ++++++++
>  fs/xfs/xfs.h       |  4 ++++
>  fs/xfs/xfs_linux.h | 32 +++++++++++++++++++-------------
>  3 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 35faf12..ded25f8 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -96,3 +96,11 @@ config XFS_DEBUG
>  	  not useful unless you are debugging a particular problem.
>  
>  	  Say N unless you are an XFS developer, or you play one on TV.
> +
> +config XFS_ASSERT_FATAL
> +	bool "XFS fatal asserts"
> +	default y
> +	depends on XFS_FS && XFS_DEBUG
> +	help
> +	  Say Y here to convert DEBUG mode ASSERT failures into fatal errors
> +	  that BUG() the kernel. Otherwise, ASSERT failures result in warnings.

nitpick, and don't care much either way, but since Y is the default, it's
a little odd to restate "say Y."  The "Otherwise" isn't crystal clear IMHO.

Maybe:

"The default XFS_DEBUG mode is to BUG() on ASSERT failures.
 If you say N here, ASSERT failures result in warnings.

Or:

"Say Y here to convert DEBUG mode ASSERT failures into fatal errors
 that BUG() the kernel.
 If you say N, these ASSERTs will be converted into warnings."

I'd just like to see "N" behavior /explicitly/ stated (with the text "N") :)

-Eric

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
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 044fb0e..36c3eab 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -245,37 +245,43 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
>  	return x;
>  }
>  
> +/*
> + * ASSERT() definitions
> + */
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
> -#ifdef DEBUG
> +#if defined(DEBUG) && defined(XFS_ASSERT_FATAL)
> +
>  #define ASSERT(expr)	\
>  	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
> -#ifndef STATIC
> -# define STATIC noinline
> -#endif
> -
> -#else	/* !DEBUG */
> -
> -#ifdef XFS_WARN
> +#elif defined(DEBUG) || defined(XFS_WARN)
>  
>  #define ASSERT(expr)	\
>  	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
>  
> -#ifndef STATIC
> -# define STATIC static noinline
> +#else
> +
> +#define ASSERT(expr)	((void)0)
> +
>  #endif
>  
> -#else	/* !DEBUG && !XFS_WARN */
> +/*
> + * STATIC definitions
> + */
> +#ifdef DEBUG
> +
> +#ifndef STATIC
> +# define STATIC noinline
> +#endif
>  
> -#define ASSERT(expr)	((void)0)
> +#else	/* !DEBUG */
>  
>  #ifndef STATIC
>  # define STATIC static noinline
>  #endif
>  
> -#endif /* XFS_WARN */
>  #endif /* DEBUG */
>  
>  #ifdef CONFIG_XFS_RT
> 

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416CAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 02:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhKXCYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 21:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKXCYz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 21:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11FC460F51;
        Wed, 24 Nov 2021 02:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637720506;
        bh=Sh40D2XBkPvFT6sFQl7PqIfYvPyVECNk6P2Gi4SQSTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgJnv/02salNuyqV4cn3xelkmXeTOvKRKqmCtDoxcnr/Sm0npfe6hQ1LubAVUafvA
         ppvPBGTfcBZkmU7c7VTiw0SibPfgLgfRlwSdPrDqSn8L2w8I0rhZHjd6plAn6ZSEG2
         5LTdtvoTpPVRjCCNx3u1OvFTHM37xyBpOVzM1a/Pvdzj/W1yc9JS520MZM+yjxgu9E
         WjHU1NIpaKigWRWUXxAjrvo3pVJ5/HklP627pXsYX+DgoD4DvzQ3PCPm4VUWZ9rGf8
         j6v4JXd1WP5PIC/mZmn1cPSrCrv3CTqT6BZYVz2ZtTchi08IbMwHbNQKsCpe6hkI42
         5PxfiR5v2mqXA==
Date:   Tue, 23 Nov 2021 18:21:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libxfs: fix atomic64_t poorly for 32-bit
 architectures
Message-ID: <20211124022145.GB266024@magnolia>
References: <163769722838.871940.2491721496902879716.stgit@magnolia>
 <163769723942.871940.11962039327000044904.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163769723942.871940.11962039327000044904.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 23, 2021 at 11:53:59AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit de555f66, we converted the atomic64_t implementation to use
> the liburcu uatomic_* functions.  Regrettably, nobody tried to build
> xfsprogs on a 32-bit architecture (hint: maintainers don't scale well
> anymore) so nobody noticed that the build fails due to the unknown
> symbol _uatomic_link_error.  This is what happens when liburcu doesn't
> know how to perform atomic updates to a variable of a certain size, due
> to some horrid macro magic in urcu.h.
> 
> Rather than a strict revert to non-atomic updates for these platforms or
> (which would introduce a landmine) or roll everything back for the sake
> of older platforms, I went with providing a custom atomic64_t
> implementation that uses a single pthread mutex.  This enables us to
> work around the fact that the kernel atomic64_t API doesn't require a
> special initializer function, and is probably good enough since there
> are only a handful of atomic64_t counters in the kernel.
> 
> Clean up the type declarations of a couple of variables in libxlog to
> match the kernel usage, though that's probably overkill.
> 
> Eventually we'll want to decide if we're deprecating 32-bit, but this
> fixes them in the mean time.
> 
> Fixes: de555f66 ("atomic: convert to uatomic")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  configure.ac         |    1 +
>  include/atomic.h     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/builddefs.in |    4 ++++
>  include/libxlog.h    |    4 ++--
>  libxfs/init.c        |    4 ++++
>  m4/package_urcu.m4   |   19 +++++++++++++++++++
>  repair/phase2.c      |    2 +-
>  7 files changed, 77 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/configure.ac b/configure.ac
> index 89a53170..6adbee8c 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -238,6 +238,7 @@ AC_CHECK_SIZEOF([long])
>  AC_CHECK_SIZEOF([char *])
>  AC_TYPE_UMODE_T
>  AC_MANUAL_FORMAT
> +AC_HAVE_LIBURCU_ATOMIC64
>  
>  AC_CONFIG_FILES([include/builddefs])
>  AC_OUTPUT
> diff --git a/include/atomic.h b/include/atomic.h
> index 2804815e..79e58dfe 100644
> --- a/include/atomic.h
> +++ b/include/atomic.h
> @@ -60,11 +60,57 @@ static inline bool atomic_dec_and_lock(atomic_t *a, spinlock_t *lock)
>  	return 0;
>  }
>  
> +#ifdef HAVE_LIBURCU_ATOMIC64
> +/*
> + * On most (64-bit) platforms, liburcu can handle 64-bit atomic counter
> + * updates, so we preferentially use that.
> + */
>  #define atomic64_read(a)	uatomic_read(a)
>  #define atomic64_set(a, v)	uatomic_set(a, v)
>  #define atomic64_add(v, a)	uatomic_add(a, v)
>  #define atomic64_sub(v, a)	uatomic_sub(a, v)
>  #define atomic64_inc(a)		uatomic_inc(a)
>  #define atomic64_dec(a)		uatomic_dec(a)
> +#else
> +/*
> + * If we don't detect support for that, emulate it with a lock.  Currently
> + * there are only three atomic64_t counters in userspace and none of them are
> + * performance critical, so we serialize them all with a single mutex since
> + * the kernel atomic64_t API doesn't have an _init call.
> + */
> +extern pthread_mutex_t	atomic64_lock;
> +
> +static inline int64_t
> +atomic64_read(atomic64_t *a)
> +{
> +	int64_t	ret;
> +
> +	pthread_mutex_lock(&atomic64_lock);
> +	ret = *a;
> +	pthread_mutex_unlock(&atomic64_lock);
> +	return ret;
> +}
> +
> +static inline void
> +atomic64_add(int v, atomic64_t *a)

fmeh, this should be int64_t for consistency.  I'll respin this if the
maintainer wants me to?

--D

> +{
> +	pthread_mutex_lock(&atomic64_lock);
> +	(*a) += v;
> +	pthread_mutex_unlock(&atomic64_lock);
> +}
> +
> +static inline void
> +atomic64_set(atomic64_t *a, int64_t v)
> +{
> +	pthread_mutex_lock(&atomic64_lock);
> +	(*a) = v;
> +	pthread_mutex_unlock(&atomic64_lock);
> +}
> +
> +#define atomic64_inc(a)		atomic64_add(1, (a))
> +#define atomic64_dec(a)		atomic64_add(-1, (a))
> +#define atomic64_sub(v, a)	atomic64_add(-(v), (a))
> +
> +#endif /* HAVE_URCU_ATOMIC64 */
>  
>  #endif /* __ATOMIC_H__ */
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 78eddf4a..9d0b0800 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -122,6 +122,7 @@ HAVE_SYSTEMD = @have_systemd@
>  SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
>  HAVE_CROND = @have_crond@
>  CROND_DIR = @crond_dir@
> +HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> @@ -159,6 +160,9 @@ endif
>  
>  LIBICU_LIBS = @libicu_LIBS@
>  LIBICU_CFLAGS = @libicu_CFLAGS@
> +ifeq ($(HAVE_LIBURCU_ATOMIC64),yes)
> +PCFLAGS += -DHAVE_LIBURCU_ATOMIC64
> +endif
>  
>  SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
>  SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
> diff --git a/include/libxlog.h b/include/libxlog.h
> index adaa9963..3ade7ffa 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -11,8 +11,8 @@
>   * the need to define any exotic kernel types in userland.
>   */
>  struct xlog {
> -	xfs_lsn_t	l_tail_lsn;     /* lsn of 1st LR w/ unflush buffers */
> -	xfs_lsn_t	l_last_sync_lsn;/* lsn of last LR on disk */
> +	atomic64_t	l_tail_lsn;     /* lsn of 1st LR w/ unflush buffers */
> +	atomic64_t	l_last_sync_lsn;/* lsn of last LR on disk */
>  	xfs_mount_t	*l_mp;	        /* mount point */
>  	struct xfs_buftarg *l_dev;	        /* dev_t of log */
>  	xfs_daddr_t	l_logBBstart;   /* start block of log */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 0f7e8950..75ff4d49 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -25,6 +25,10 @@
>  
>  #include "libxfs.h"		/* for now */
>  
> +#ifndef HAVE_LIBURCU_ATOMIC64
> +pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
> +#endif
> +
>  char *progname = "libxfs";	/* default, changed by each tool */
>  
>  struct cache *libxfs_bcache;	/* global buffer cache */
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> index f0337f34..f8e798b6 100644
> --- a/m4/package_urcu.m4
> +++ b/m4/package_urcu.m4
> @@ -20,3 +20,22 @@ AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
>         AC_MSG_RESULT(no))
>      AC_SUBST(liburcu)
>    ])
> +
> +#
> +# Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
> +# error on _uatomic_link_error, which is how liburcu signals that it doesn't
> +# support atomic operations on 64-bit data types.
> +#
> +AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
> +  [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> +    AC_TRY_LINK([
> +#define _GNU_SOURCE
> +#include <urcu.h>
> +    ], [
> +       long long f = 3;
> +       uatomic_inc(&f);
> +    ], have_liburcu_atomic64=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_liburcu_atomic64)
> +  ])
> diff --git a/repair/phase2.c b/repair/phase2.c
> index cb9adf1d..32ffe18b 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -128,7 +128,7 @@ zero_log(
>  	 * is a v5 filesystem.
>  	 */
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		libxfs_max_lsn = log->l_last_sync_lsn;
> +		libxfs_max_lsn = atomic64_read(&log->l_last_sync_lsn);
>  }
>  
>  static bool
> 

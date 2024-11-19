Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3E0182
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 00:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731974515; cv=none; b=vA9FZ9oevf+QLoJq0amyie2aey4S8WvoOSPinHP53amQseYGOqZfjWcoTya1sV2axNkqKKQk8MIusYn+On0j/6S9sEL0of57UrRPy3RJfoKnpkQSMmc4jp1tDBZB9E6f9PrGpZPPLA7tkN047m+cNB4KkaUeRKNh4sBxVAAE4YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731974515; c=relaxed/simple;
	bh=G/W2wSYVVN8dWSMUBC+VI2YSIv/mQo+E7zvKjFmi7V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQDuIdcya+qs2laG0Xw/wGL9Kh74uso5WweccDuMVeH5hnFdftktYaj/hZdd3+MvcDmEZgvfahcgMYgnGlGWrHLZsPuLMA793QLvyoEfHxZ7WPsVuxMcPQTe6MonVPN9bFrAh7dnaF7sglUWNXrBhsIVULVZoaJApj2+ZW3cb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j55Vm4cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j55Vm4cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F25C4CECC;
	Tue, 19 Nov 2024 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731974515;
	bh=G/W2wSYVVN8dWSMUBC+VI2YSIv/mQo+E7zvKjFmi7V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j55Vm4cdkBlQhCE1d9CF+ZU22TKCZVUyW+rRcCC19gaawOGPwNIpNwMRWnuJuZ7YO
	 JDaYygYSIc+w7iY8JHYTtM7WeKI5w3mvWUDK+V59E4VOVWzZQFsXr99sc9EhxFw+bp
	 sJ2jKGS8XS3IcO0fksq6m0gzEFmK/3bMHa26izLqagVewQR26ugQhZ4SBZLzWX37uF
	 bz2yyeXXPUCCNl+CZBicNifMfC4yzX11twA2pR9jZ9gEKVp0O6vcwVitfbBpV19jk6
	 tg8lmaBQDWZQU2U/6UJveXcsHJMvR9DMiBWs0h8jZt4EA52xqxXvTZ8W0yDMeN6lSu
	 +B8jcLfMRDAWA==
Date: Mon, 18 Nov 2024 16:01:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_io: add support for atomic write statx fields
Message-ID: <20241119000154.GS9438@frogsfrogsfrogs>
References: <20241118235255.23133-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118235255.23133-1-catherine.hoang@oracle.com>

On Mon, Nov 18, 2024 at 03:52:55PM -0800, Catherine Hoang wrote:
> Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
> atomic_write_segments_max fields in statx for xfs_io. In order to support builds
> against old kernel headers, define our own internal statx structs. If the
> system's struct statx does not have the required atomic write fields, override
> the struct definitions with the internal definitions in statx.h.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  4 ++++
>  io/stat.c             |  7 +++++++
>  io/statx.h            | 23 ++++++++++++++++++++++-
>  m4/package_libcdev.m4 | 20 ++++++++++++++++++++
>  5 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 33b01399..0b1ef3c3 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -146,6 +146,7 @@ AC_HAVE_COPY_FILE_RANGE
>  AC_NEED_INTERNAL_FSXATTR
>  AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
>  AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
> +AC_NEED_INTERNAL_STATX
>  AC_HAVE_GETFSMAP
>  AC_HAVE_MAP_SYNC
>  AC_HAVE_DEVMAPPER
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 1647d2cd..cbc9ab0c 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -96,6 +96,7 @@ HAVE_COPY_FILE_RANGE = @have_copy_file_range@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
>  NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
> +NEED_INTERNAL_STATX = @need_internal_statx@
>  HAVE_GETFSMAP = @have_getfsmap@
>  HAVE_MAP_SYNC = @have_map_sync@
>  HAVE_DEVMAPPER = @have_devmapper@
> @@ -130,6 +131,9 @@ endif
>  ifeq ($(NEED_INTERNAL_FSCRYPT_POLICY_V2),yes)
>  PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
>  endif
> +ifeq ($(NEED_INTERNAL_STATX),yes)
> +PCFLAGS+= -DOVERRIDE_SYSTEM_STATX
> +endif
>  ifeq ($(HAVE_GETFSMAP),yes)
>  PCFLAGS+= -DHAVE_GETFSMAP
>  endif
> diff --git a/io/stat.c b/io/stat.c
> index 0f5618f6..7d1c1c93 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -6,6 +6,10 @@
>   * Portions of statx support written by David Howells (dhowells@redhat.com)
>   */
>  
> +#ifdef OVERRIDE_SYSTEM_STATX
> +#define statx sys_statx
> +#endif
> +
>  #include "command.h"
>  #include "input.h"
>  #include "init.h"
> @@ -347,6 +351,9 @@ dump_raw_statx(struct statx *stx)
>  	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
>  	printf("stat.dev_major = %u\n", stx->stx_dev_major);
>  	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
> +	printf("stat.atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
> +	printf("stat.atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
> +	printf("stat.atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);
>  	return 0;
>  }
>  
> diff --git a/io/statx.h b/io/statx.h
> index c6625ac4..d151f732 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -61,6 +61,7 @@ struct statx_timestamp {
>  	__s32	tv_nsec;
>  	__s32	__reserved;
>  };
> +#endif
>  
>  /*
>   * Structures for the extended file attribute retrieval system call
> @@ -99,6 +100,8 @@ struct statx_timestamp {
>   * will have values installed for compatibility purposes so that stat() and
>   * co. can be emulated in userspace.
>   */
> +#if !defined STATX_TYPE || defined OVERRIDE_SYSTEM_STATX

Is there any place where STATX_TYPE is not defined but
OVERRIDE_SYSTEM_STATX will *also* not be defined?

I think the m4 macro you added sets need_internal_statx=yes for old
systems where there's no STATX_TYPE, because there won't be a struct
statx, let alone atomic_write_* fields in it, right?

--D

> +#undef statx
>  struct statx {
>  	/* 0x00 */
>  	__u32	stx_mask;	/* What results were written [uncond] */
> @@ -126,10 +129,23 @@ struct statx {
>  	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
>  	__u32	stx_dev_minor;
>  	/* 0x90 */
> -	__u64	__spare2[14];	/* Spare space for future expansion */
> +	__u64	stx_mnt_id;
> +	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
> +	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
> +	/* 0xa0 */
> +	__u64	stx_subvol;	/* Subvolume identifier */
> +	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
> +	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
> +	/* 0xb0 */
> +	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
> +	__u32   __spare1[1];
> +	/* 0xb8 */
> +	__u64	__spare3[9];	/* Spare space for future expansion */
>  	/* 0x100 */
>  };
> +#endif
>  
> +#ifndef STATX_TYPE
>  /*
>   * Flags to be stx_mask
>   *
> @@ -174,4 +190,9 @@ struct statx {
>  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
>  
>  #endif /* STATX_TYPE */
> +
> +#ifndef STATX_WRITE_ATOMIC
> +#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
> +#endif
> +
>  #endif /* XFS_IO_STATX_H */
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 6de8b33e..bc8a49a9 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -98,6 +98,26 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
>      AC_SUBST(need_internal_fscrypt_policy_v2)
>    ])
>  
> +#
> +# Check if we need to override the system struct statx with
> +# the internal definition.  This /only/ happens if the system
> +# actually defines struct statx /and/ the system definition
> +# is missing certain fields.
> +#
> +AC_DEFUN([AC_NEED_INTERNAL_STATX],
> +  [ AC_CHECK_TYPE(struct statx,
> +      [
> +        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
> +          ,
> +          need_internal_statx=yes,
> +          [#include <linux/stat.h>]
> +        )
> +      ],,
> +      [#include <linux/stat.h>]
> +    )
> +    AC_SUBST(need_internal_statx)
> +  ])
> +
>  #
>  # Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
>  #
> -- 
> 2.34.1
> 
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB75D146A71
	for <linux-xfs@vger.kernel.org>; Sat,  9 Nov 2024 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169760; cv=none; b=co9HYh4NsOY/NoyeSRxzbe1zmrAOQJJctONFkNXacgpgmYVtaTFlnYIFxsAemTgZF8XxqRGmmWbZDllXjnx5Lhu4j9tYsecsPe/COBoSfvBOa6Lq9vQImr4b3iwmpnZ6bZ2Jzosh0qE6OsEE+6eRNUm4+b3E/nS0gobVH2wYIzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169760; c=relaxed/simple;
	bh=yljWODfySeSidz5t4uV3QQ2l5KkLmoQ66NPZm/Cs5Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjecEk4N+EmP93/JUBNDcsNqtzJJXTqz0Oh+eTaTTkDXRYOKIxShLXKNlddjyYzxpRgCpkNx1diQIW69304nMe8ojQ4yIEabqDeZnt/A7w0lZdMvyLGm+Y/n5Cb964ROWHqTdbanzb7ciKDW6yPx9EuZ8zD5+3sq1gPzyi/EpB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9u7gG+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9u7gG+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6ECC4CECE;
	Sat,  9 Nov 2024 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731169760;
	bh=yljWODfySeSidz5t4uV3QQ2l5KkLmoQ66NPZm/Cs5Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T9u7gG+112MPFDYuZWo1I+bABErre7WWB7+UvhvLuG3tDGiiAV7yT0yahgg7uL1uv
	 oerVjrO5NcjH0Wa2Zi3LQ/TZOi+1DvCcHOZguIAM9KUltGwYuWUGmgFt6lyop6PwU2
	 AHRbngUE69iGiyu9VKpGY7ImrftOXShRv8W1Vbxnoqn+5Qw4x9af0ncBp9neitG8m5
	 83ROy7cSrn41m16pJfjvSzyZ2Q6Rf7y0wAV8HKItLUi/YUk+yDDepGjIUaBogdaPDd
	 RrkNf4WUtrvs826DA8mCkRqsd8c9h0qAeGenxuJMlnB4z65yYpnPndj6ZoMFDu9n5h
	 fGipWeoddBguQ==
Date: Sat, 9 Nov 2024 08:29:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_io: add support for atomic write statx fields
Message-ID: <20241109162919.GB9438@frogsfrogsfrogs>
References: <20241108190313.40173-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108190313.40173-1-catherine.hoang@oracle.com>

On Fri, Nov 08, 2024 at 11:03:13AM -0800, Catherine Hoang wrote:
> Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
> atomic_write_segments_max fields in statx for xfs_io. In order to support builds
> against old kernel headers, define our own internal statx structs. If the
> system's struct statx does not have the required atomic write fields, override
> the struct definitions with the internal definitions in statx.h.

/me realizes that his earlier ramblings this week about hch and a statx
update was merely me confusing a patch against *fstests* vs. a patch
against *xfsprogs*.

> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  4 ++++
>  io/stat.c             |  9 +++++++--
>  io/statx.h            | 35 ++++++++++++++++++++++++++++-------
>  m4/package_libcdev.m4 | 14 ++++++++++++++
>  5 files changed, 54 insertions(+), 9 deletions(-)
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
> index 0f5618f6..5c0bab41 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -17,6 +17,8 @@
>  
>  #include <fcntl.h>
>  
> +#define IO_STATX_MASK	(STATX_ALL | STATX_WRITE_ATOMIC)
> +
>  static cmdinfo_t stat_cmd;
>  static cmdinfo_t statfs_cmd;
>  static cmdinfo_t statx_cmd;
> @@ -347,6 +349,9 @@ dump_raw_statx(struct statx *stx)
>  	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
>  	printf("stat.dev_major = %u\n", stx->stx_dev_major);
>  	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
> +	printf("stat.stx_atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
> +	printf("stat.stx_atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
> +	printf("stat.stx_atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);
>  	return 0;
>  }
>  
> @@ -365,7 +370,7 @@ statx_f(
>  	char		*p;
>  	struct statx	stx;
>  	int		atflag = 0;
> -	unsigned int	mask = STATX_ALL;
> +	unsigned int	mask = IO_STATX_MASK;
>  
>  	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
>  		switch (c) {
> @@ -373,7 +378,7 @@ statx_f(
>  			if (strcmp(optarg, "basic") == 0)
>  				mask = STATX_BASIC_STATS;
>  			else if (strcmp(optarg, "all") == 0)
> -				mask = STATX_ALL;
> +				mask = IO_STATX_MASK;
>  			else {
>  				mask = strtoul(optarg, &p, 0);
>  				if (!p || p == optarg) {
> diff --git a/io/statx.h b/io/statx.h
> index c6625ac4..0a51c86c 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -5,6 +5,7 @@
>  
>  #include <unistd.h>
>  #include <sys/syscall.h>
> +#include <sys/types.h>
>  
>  #ifndef AT_EMPTY_PATH
>  #define AT_EMPTY_PATH	0x1000
> @@ -37,10 +38,10 @@
>  #ifndef STATX_TYPE
>  /* Pick up kernel definitions if glibc didn't already provide them */
>  #include <linux/stat.h>
> -#endif
> +#endif /* STATX_TYPE */
>  
> -#ifndef STATX_TYPE
> -/* Local definitions if glibc & kernel headers didn't already provide them */
> +#ifdef OVERRIDE_SYSTEM_STATX
> +/* Local definitions if they don't exist or are too old */
>  
>  /*
>   * Timestamp structure for the timestamps in struct statx.
> @@ -56,11 +57,12 @@
>   *
>   * __reserved is held in case we need a yet finer resolution.
>   */
> -struct statx_timestamp {
> +struct statx_timestamp_internal {
>  	__s64	tv_sec;
>  	__s32	tv_nsec;
>  	__s32	__reserved;
>  };
> +#define statx_timestamp statx_timestamp_internal

Hrmm, usually for overrides in xfsprogs we use #define to rename the
structs provided by the /usr/include headers, and then drop in our own
definitions, e.g.

#ifdef OVERRIDE_SYSTEM_STATX
# define statx_timestamp sys_statx_timestamp
# include <linux/stat.h>
# undef statx_timestamp
#endif

struct statx_timestamp { ... };

Though I guess this works too?  But it goes against the established
convention.

--D

>  /*
>   * Structures for the extended file attribute retrieval system call
> @@ -99,7 +101,7 @@ struct statx_timestamp {
>   * will have values installed for compatibility purposes so that stat() and
>   * co. can be emulated in userspace.
>   */
> -struct statx {
> +struct statx_internal {
>  	/* 0x00 */
>  	__u32	stx_mask;	/* What results were written [uncond] */
>  	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */
> @@ -126,9 +128,21 @@ struct statx {
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
> +#define statx statx_internal
>  
>  /*
>   * Flags to be stx_mask
> @@ -138,6 +152,7 @@ struct statx {
>   * These bits should be set in the mask argument of statx() to request
>   * particular items when calling statx().
>   */
> +#ifndef STATX_TYPE
>  #define STATX_TYPE		0x00000001U	/* Want/got stx_mode & S_IFMT */
>  #define STATX_MODE		0x00000002U	/* Want/got stx_mode & ~S_IFMT */
>  #define STATX_NLINK		0x00000004U	/* Want/got stx_nlink */
> @@ -153,7 +168,11 @@ struct statx {
>  #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
>  #define STATX_ALL		0x00000fffU	/* All currently supported flags */
>  #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
> +#endif /* STATX_TYPE */
>  
> +#ifndef STATX_WRITE_ATOMIC
> +#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
> +#endif /* STATX_WRITE_ATOMIC */
>  /*
>   * Attributes to be found in stx_attributes
>   *
> @@ -165,6 +184,7 @@ struct statx {
>   * semantically.  Where possible, the numerical value is picked to correspond
>   * also.
>   */
> +#ifndef STATX_ATTR_COMPRESSED
>  #define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
>  #define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
>  #define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
> @@ -172,6 +192,7 @@ struct statx {
>  #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
>  
>  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
> +#endif /* STATX_ATTR_COMPRESSED */
>  
> -#endif /* STATX_TYPE */
> +#endif /* OVERRIDE_SYSTEM_STATX */
>  #endif /* XFS_IO_STATX_H */
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 6de8b33e..fd01c4d5 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -220,3 +220,17 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
>      AC_SUBST(lto_cflags)
>      AC_SUBST(lto_ldflags)
>    ])
> +
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
> -- 
> 2.34.1
> 
> 

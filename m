Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2829640BE5
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 03:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732073174; cv=none; b=rfKrYD+QO3hsoVeQkR/vqggRIXJlvgck5BgI3Lw4u79Lzy23f9NINQlVmSNnCVRnJhV/eb7B/EfceaKcutacyzhBUG6hbookUR8Tw/ti16UvaE5HJSZZeNDRFiaOui5H7DYsW82pa2lNgf091by9PawuruFAXCPxioaCn5CLG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732073174; c=relaxed/simple;
	bh=35/XBEJwGcn2jMcDpCO02j7RqYRDyPhiaQMqkdaj4jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIY2myaTUTeqW1qGfT9dve/86fOXFFSuiK9z4bgWhhgCOBQ2KV51TKRh3h3OS84waNCYniLZvEjI1tCVdCgooWiZ+ejtkIhhm8PkO5Nrq3YPNKv32NxTqqxULyVrm/ndDkYiOaaT0hRVvHHdsZsW68tB13TE/La26+n3XACzHnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vN/3qHG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vN/3qHG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E38C4CECD;
	Wed, 20 Nov 2024 03:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732073173;
	bh=35/XBEJwGcn2jMcDpCO02j7RqYRDyPhiaQMqkdaj4jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vN/3qHG10WRsB0ztRpX/Ykd4sMWu+Ycj5jPTFSVDnlG4ywPkoRq1QeqkqKyBuIoxe
	 x1Q5z9YYVgbP4C4g/soXEJM3RbdUtARh4D7IC6bVQnZ2A3BnWkmWRcnOnVZK3vslvU
	 7V+QPqhfCpvk5OocvpjyM5zimOihDrrXuT/hHxtGSM5tM09HLbIftSg3fRsYimu9yn
	 SabVXnGZeHQovYmKR6opEuDevWbx51AKBlfvQffoiYzq5JRvCZtrl1n5N8BR1jT30d
	 U8yudbHd2/5n3C2Z4XulcZJIRucmYDDNxiP0Xrn2G4WS8ILglcx7rNkN2mhjwl/JOd
	 KzpAHU5YdHcqw==
Date: Tue, 19 Nov 2024 19:26:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs_io: add support for atomic write statx fields
Message-ID: <20241120032613.GB9438@frogsfrogsfrogs>
References: <20241120023544.85992-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120023544.85992-1-catherine.hoang@oracle.com>

On Tue, Nov 19, 2024 at 06:35:44PM -0800, Catherine Hoang wrote:
> Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
> atomic_write_segments_max fields in statx for xfs_io. In order to support builds
> against old kernel headers, define our own internal statx structs. If the
> system's struct statx does not have the required atomic write fields, override
> the struct definitions with the internal definitions in statx.h.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
> index 0f5618f6..326f2822 100644
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
> +	printf("stat.atomic_write_unit_min = %u\n", stx->stx_atomic_write_unit_min);
> +	printf("stat.atomic_write_unit_max = %u\n", stx->stx_atomic_write_unit_max);
> +	printf("stat.atomic_write_segments_max = %u\n", stx->stx_atomic_write_segments_max);
>  	return 0;
>  }
>  
> diff --git a/io/statx.h b/io/statx.h
> index c6625ac4..347f6d08 100644
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
> +#ifdef OVERRIDE_SYSTEM_STATX
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

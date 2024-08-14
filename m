Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D02E39879;
	Wed, 14 Aug 2024 05:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723612324; cv=none; b=RwxUx22ElGBf7HsusjKHeJwiICKJi8JVHZB2dDuAxg6CrerfYyESwpvaOAMaRUIx+j6dDU9yCOA/9CXIW45A95xRk4UFozY+21H+W66WG+/f48A7FezEDSlo4cJFnt9y1tItd2zuvpmj7WD+Lw3WMci1i2Ye9QCzpMis4Sk53iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723612324; c=relaxed/simple;
	bh=d+omWQA/mi6ss/6OIr88G25IgShWz+QOCTKaXmRfx2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iO9xkMM5iBEig5cMaO91+znQpl73RzdoFlkiOXL7m5fb64YNXc7NPQypmGEtvQITcfBsiLBz0YU+nwYHPdIKNOavxchGaoHWBAvqeHfem02WdrS32e/q8S+QyQWbHvHMAwEMHncN75C1ylfM6TBgXCJH2c+u57xncA3WEX2Q3fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaiymTXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaiymTXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1552EC32786;
	Wed, 14 Aug 2024 05:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723612324;
	bh=d+omWQA/mi6ss/6OIr88G25IgShWz+QOCTKaXmRfx2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CaiymTXPuh0kh2OKIV4/rU6NhSNXVmFpFhu0UlTwxEXo8jYtyFoEZCx+CwWTQ6DAN
	 yrnDEMx7IGkKhGVhvxUisEJcdayRH1vKG5ZYw56ZaHtmD9bljmg8gDzQD4l/vWcry0
	 w9cpp8JpTAjmCO9FxgcqeEKInkD4S917rlIZrHtmQLNAsTHXkBaA0eTLeSJAQW5ksE
	 /AU6S5bNn+HRcOl17oOuwOXxF88K8XQWXtX/L65+x8SdOKo7Bd/WGnt7/BYoj2kER2
	 MS/3Nf+QEAqdLa/MdzINqn6l5xC8ArK/nrzg9zqPU5tQCPzwS0+FnyzdWT6YYKgk/c
	 a/nUDEnbRhgqw==
Date: Tue, 13 Aug 2024 22:12:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] statx.h: update to latest kernel UAPI
Message-ID: <20240814051203.GB865349@frogsfrogsfrogs>
References: <20240814045232.21189-1-hch@lst.de>
 <20240814045232.21189-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814045232.21189-2-hch@lst.de>

On Wed, Aug 14, 2024 at 06:52:10AM +0200, Christoph Hellwig wrote:
> Update the localy provided statx definition to the latest kernel UAPI,
> and use it unconditionally instead only if no kernel version is provided.
> 
> This allows using more recent additions than provided in the system
> headers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  src/statx.h | 38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/src/statx.h b/src/statx.h
> index 3f239d791..bae1c86f6 100644
> --- a/src/statx.h
> +++ b/src/statx.h
> @@ -5,6 +5,14 @@
>  #include <sys/syscall.h>
>  #include <linux/types.h>
>  
> +/*
> + * Swizzle the symbol namespace so that we can provide our own version
> + * overriding the system one that might now have all the latest fields
> + * under the standard names even when <sys/stat.h> is included.
> + */
> +#define statx_timestamp statx_timestamp_fstests
> +#define statx statx_fstests
> +
>  #ifndef AT_STATX_SYNC_TYPE
>  #define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
>  #define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */
> @@ -28,8 +36,6 @@
>  # endif
>  #endif
>  
> -#ifndef STATX_TYPE
> -
>  /*
>   * Timestamp structure for the timestamps in struct statx.
>   *
> @@ -102,7 +108,8 @@ struct statx {
>  	__u64	stx_ino;	/* Inode number */
>  	__u64	stx_size;	/* File size */
>  	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
> -	__u64	__spare1[1];
> +	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
> +
>  	/* 0x40 */
>  	struct statx_timestamp	stx_atime;	/* Last access time */
>  	struct statx_timestamp	stx_btime;	/* File creation time */
> @@ -114,7 +121,18 @@ struct statx {
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
>  
> @@ -139,6 +157,12 @@ struct statx {
>  #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
>  #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
>  #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
> +#define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
> +#define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
> +#define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
> +#define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
> +#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
> +
>  #define STATX_ALL		0x00000fffU	/* All currently supported flags */
>  
>  /*
> @@ -157,9 +181,11 @@ struct statx {
>  #define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
>  #define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
>  #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
> -
>  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
> -#endif /* STATX_TYPE */
> +#define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
> +#define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
> +#define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
> +#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
>  
>  static inline
>  int xfstests_statx(int dfd, const char *filename, unsigned flags,
> -- 
> 2.43.0
> 
> 

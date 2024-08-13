Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEC19D886;
	Tue, 13 Aug 2024 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559836; cv=none; b=ab1HpupXspZHqp0/RclIpXNKeraJVGLX3jVXJz9nTdQvKijOu8/Tt3dAJ4dKm+PNXwwAFHuTBxPIGIFeNIR0SorlxdDOegQYmK9eRf1wYl+UezAJNMFmgZtxK+76jEvedZecweFfdQlQUj/HZxlxpL4CbyLcQxGAd9sTAlhgbnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559836; c=relaxed/simple;
	bh=xrbXi/Tvzg3SLG5dVVMqrQ+DWhv4hRKjrG2J+apEvRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuoQpDidSRxF4UkroZsn/6uPGa6gTlaWULZVc1gwAlYGdVaKe82f20Jc3386TNZu2M/8PqlVQ9JHhJrpQYX9vBQ1E2nudRRTVuQpnI6PVBv3Ko/B7RO6qSVDSoVusY2z3JcnmNF0TqzcEZPqKCY99UdzaZ3twGsDXqP2gbl2AuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uN0dnmZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uN0dnmZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980CCC4AF09;
	Tue, 13 Aug 2024 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723559835;
	bh=xrbXi/Tvzg3SLG5dVVMqrQ+DWhv4hRKjrG2J+apEvRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uN0dnmZueytWeiZ68uwNEvINpX/1oFHPj3K5vDyski8yZdVrN+YyfNwsUA3ncscEB
	 9Cv9O+wwcdUvfVJhdP20cm1Fx91NW1nFui/SiONOHx4D7L+PdcGqGVmJ85qbcFrLU/
	 2gsVBrpB2mAcAkze1ULK5v+HVLbT4XSAZzVfMyO1ATfKzkcz3hWNflbNVAj8mZ/V+y
	 3ALOhk/cb5H41pFHjr6cznGOhM0RALAjGA7b3eMYSrWKiDErT+qVptetP+YCjcEj36
	 VpvFmeRXIKJkQQLFls7JRYyPtyMOydS2lw5D728Qu5SHa8RnSjx5OrgTR4L6D7Inp0
	 UFTkxLacM54mg==
Date: Tue, 13 Aug 2024 07:37:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] statx.h: update to latest kernel UAPI
Message-ID: <20240813143715.GC6047@frogsfrogsfrogs>
References: <20240813073527.81072-1-hch@lst.de>
 <20240813073527.81072-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813073527.81072-2-hch@lst.de>

On Tue, Aug 13, 2024 at 09:35:00AM +0200, Christoph Hellwig wrote:
> Update the localy provided statx definition to the latest kernel UAPI,
> and use it unconditionally instead only if no kernel version is provided.
> 
> This allows using more recent additions than provided in the system
> headers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  src/statx.h | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/src/statx.h b/src/statx.h
> index 3f239d791..ab29fe22d 100644
> --- a/src/statx.h
> +++ b/src/statx.h
> @@ -28,8 +28,6 @@
>  # endif
>  #endif
>  
> -#ifndef STATX_TYPE
> -
>  /*
>   * Timestamp structure for the timestamps in struct statx.
>   *
> @@ -44,6 +42,7 @@
>   *
>   * __reserved is held in case we need a yet finer resolution.
>   */
> +#define statx_timestamp statx_timestamp_fstests

Might want to put these #defines at the top with a comment so that
future people copy-pastaing too fast (i.e. me) don't obliterate them
accidentally.

/*
 * Use a fstests-specific name for these structures so we can always
 * find the latest version of the abi.
 */
#define statx_timestamp statx_timestamp_fstests
#define statx statx_fstests

[all the statx.h stuff here]

Otherwise looks fine to me.

--D

>  struct statx_timestamp {
>  	__s64	tv_sec;
>  	__s32	tv_nsec;
> @@ -87,6 +86,7 @@ struct statx_timestamp {
>   * will have values installed for compatibility purposes so that stat() and
>   * co. can be emulated in userspace.
>   */
> +#define statx statx_fstests
>  struct statx {
>  	/* 0x00 */
>  	__u32	stx_mask;	/* What results were written [uncond] */
> @@ -102,7 +102,8 @@ struct statx {
>  	__u64	stx_ino;	/* Inode number */
>  	__u64	stx_size;	/* File size */
>  	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
> -	__u64	__spare1[1];
> +	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
> +
>  	/* 0x40 */
>  	struct statx_timestamp	stx_atime;	/* Last access time */
>  	struct statx_timestamp	stx_btime;	/* File creation time */
> @@ -114,7 +115,18 @@ struct statx {
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
> @@ -139,6 +151,12 @@ struct statx {
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
> @@ -157,9 +175,11 @@ struct statx {
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

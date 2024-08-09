Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671A1155A25
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215896; cv=none; b=VQRwnuQDAgIq1vlpLoRRZO0Mua5wWK3L/B/2EI+mQrBafYEXlkUl3mBZSlTP2IX2pGVXwbaURLwoPd3BD1svInwduknAD/fkkR8f/hJWl0fgrEYeHSgMBWcNp49TD2Z1WUMK3/IuL4h18q8mzSrdwcILtX3M0d2llCNVd3W9oVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215896; c=relaxed/simple;
	bh=eJ2EqsE2V8W/QWkSVhZCFshRxXFNqhHsZoHRHiR6A5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yo3g+q15sqnk9dq/jwsi2GlRjZv6A1MXWV1KUhu7BqMhk7wEq4anDi66gdWRgjOsrSl8ZbwD1ugQld4lsDNznUvtbdRpv80EnNLNU9zq5NmeVbIfkeZaNE9YVFcioEi4UxHMShLHLbehD6EoYWqRYZ557mqzueze9twKlX47aNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QALpEN4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QALpEN4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAFBC32782;
	Fri,  9 Aug 2024 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723215896;
	bh=eJ2EqsE2V8W/QWkSVhZCFshRxXFNqhHsZoHRHiR6A5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QALpEN4nciCAlL9fsCj9ZndWS9wcDhu9jXNuk92AIOJino5bMw197ODtCgobY2n8D
	 8fvG2tfOLq4OFCcflMKcqJtxs8FecEVL1FUHqVFfMj2gdOOmf82LugAVZuEN48orqy
	 ar+0Tu5BIN4L22KWu/iA3KDo0DpCilXmOCtkmGVG+IfkmZ646gjHRyQ6l0CWrSNsOM
	 7T39M148xP819tcbhXhpSczoCKgZCzzzEwoQ/h2yF82jaztdQOPW7BZ3COGmrJkbiW
	 TwUuOACxL4aseM54tzW2iyxz1G/h2e3loCDFRETqbjbaLCU7ZGXuwqH3kH1GZ+GE9L
	 F7XHgPMveRKGg==
Date: Fri, 9 Aug 2024 08:04:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs_io: use FICLONE/FICLONERANGE/FIDEDUPERANGE for
 reflink/dudupe IO commands
Message-ID: <20240809150455.GV6051@frogsfrogsfrogs>
References: <20240809090226.196381-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809090226.196381-1-liuhuan01@kylinos.cn>

On Fri, Aug 09, 2024 at 05:02:26PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> Use FICLONE/FICLONERANGE/FIDEDUPERANGE instead of XFS_IOC_CLONE/XFS_IOC_CLONE_RANGE/XFS_IOC_FILE_EXTENT_SAME.
> And remove dead code.

Where was the dead code?

> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  include/xfs_fs_compat.h | 54 -----------------------------------------
>  io/reflink.c            | 52 +++++++++++++++++++--------------------
>  2 files changed, 26 insertions(+), 80 deletions(-)
> 
> diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
> index 0077f00c..e53dcc6e 100644
> --- a/include/xfs_fs_compat.h
> +++ b/include/xfs_fs_compat.h
> @@ -31,60 +31,6 @@
>  #define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
>  #define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
>  
> -/*
> - * Don't use this.
> - * Use struct file_clone_range
> - */
> -struct xfs_clone_args {
> -	__s64 src_fd;
> -	__u64 src_offset;
> -	__u64 src_length;
> -	__u64 dest_offset;
> -};
> -
> -/*
> - * Don't use these.
> - * Use FILE_DEDUPE_RANGE_SAME / FILE_DEDUPE_RANGE_DIFFERS
> - */
> -#define XFS_EXTENT_DATA_SAME	0
> -#define XFS_EXTENT_DATA_DIFFERS	1
> -
> -/* Don't use this. Use file_dedupe_range_info */
> -struct xfs_extent_data_info {
> -	__s64 fd;		/* in - destination file */
> -	__u64 logical_offset;	/* in - start of extent in destination */
> -	__u64 bytes_deduped;	/* out - total # of bytes we were able
> -				 * to dedupe from this file */
> -	/* status of this dedupe operation:
> -	 * < 0 for error
> -	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
> -	 * == XFS_EXTENT_DATA_DIFFERS if data differs
> -	 */
> -	__s32 status;		/* out - see above description */
> -	__u32 reserved;
> -};
> -
> -/*
> - * Don't use this.
> - * Use struct file_dedupe_range
> - */
> -struct xfs_extent_data {
> -	__u64 logical_offset;	/* in - start of extent in source */
> -	__u64 length;		/* in - length of extent */
> -	__u16 dest_count;	/* in - total elements in info array */
> -	__u16 reserved1;
> -	__u32 reserved2;
> -	struct xfs_extent_data_info info[0];
> -};
> -
> -/*
> - * Don't use these.
> - * Use FICLONE/FICLONERANGE/FIDEDUPERANGE
> - */
> -#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> -#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
> -#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
> -
>  /* 64-bit seconds counter that works independently of the C library time_t. */
>  typedef long long int time64_t;
>  
> diff --git a/io/reflink.c b/io/reflink.c
> index b6a3c05a..154ca65b 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -43,49 +43,49 @@ dedupe_ioctl(
>  	uint64_t	len,
>  	int		*ops)
>  {
> -	struct xfs_extent_data		*args;
> -	struct xfs_extent_data_info	*info;
> +	struct file_dedupe_range	*args;
> +	struct file_dedupe_range_info	*info;
>  	int				error;
>  	uint64_t			deduped = 0;
>  
> -	args = calloc(1, sizeof(struct xfs_extent_data) +
> -			 sizeof(struct xfs_extent_data_info));
> +	args = calloc(1, sizeof(struct file_dedupe_range) +
> +			 sizeof(struct file_dedupe_range_info));
>  	if (!args)
>  		goto done;
> -	info = (struct xfs_extent_data_info *)(args + 1);
> -	args->logical_offset = soffset;
> -	args->length = len;
> +	info = (struct file_dedupe_range_info *)(args + 1);
> +	args->src_offset = soffset;
> +	args->src_length = len;
>  	args->dest_count = 1;
> -	info->fd = file->fd;
> -	info->logical_offset = doffset;
> +	info->dest_fd = file->fd;
> +	info->dest_offset = doffset;
>  
> -	while (args->length > 0 || !*ops) {
> -		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
> +	while (args->src_length > 0 || !*ops) {
> +		error = ioctl(fd, FIDEDUPERANGE, args);
>  		if (error) {
> -			perror("XFS_IOC_FILE_EXTENT_SAME");
> +			perror("FIDEDUPERANGE");

If you update these error message prefixes, you'll likely need to update
fstests too:

tests/generic/122.out:7:XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
tests/generic/136.out:10:XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
tests/generic/157.out:5:XFS_IOC_CLONE_RANGE: Invalid cross-device link
tests/generic/157.out:7:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:9:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:11:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:13:XFS_IOC_CLONE_RANGE: Is a directory
tests/generic/157.out:15:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:19:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:21:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/157.out:23:XFS_IOC_CLONE_RANGE: Bad file descriptor
tests/generic/158.out:5:XFS_IOC_FILE_EXTENT_SAME: Invalid cross-device link
tests/generic/158.out:7:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:9:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:11:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:13:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:15:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:17:XFS_IOC_FILE_EXTENT_SAME: Is a directory
tests/generic/158.out:19:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:23:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/158.out:25:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/303.out:7:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/303.out:10:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/303.out:12:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/303.out:14:XFS_IOC_CLONE_RANGE: Invalid argument
tests/generic/304.out:5:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:7:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:9:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:11:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:13:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:15:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/304.out:17:XFS_IOC_FILE_EXTENT_SAME: Invalid argument
tests/generic/493.out:5:XFS_IOC_FILE_EXTENT_SAME: Text file busy
tests/generic/493.out:6:XFS_IOC_FILE_EXTENT_SAME: Text file busy
tests/generic/516.out:7:XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
tests/generic/518.out:6:XFS_IOC_CLONE_RANGE: Invalid argument
tests/xfs/319.out:10:XFS_IOC_CLONE_RANGE: Input/output error
tests/xfs/321.out:9:XFS_IOC_CLONE_RANGE: Input/output error
tests/xfs/322.out:9:XFS_IOC_CLONE_RANGE: Input/output error
tests/xfs/323.out:9:XFS_IOC_CLONE_RANGE: Input/output error

(or leave the prefixes alone)

--D

>  			exitcode = 1;
>  			goto done;
>  		}
>  		if (info->status < 0) {
> -			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
> +			fprintf(stderr, "FIDEDUPERANGE: %s\n",
>  					_(strerror(-info->status)));
>  			goto done;
>  		}
> -		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> -			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
> +		if (info->status == FILE_DEDUPE_RANGE_DIFFERS) {
> +			fprintf(stderr, "FIDEDUPERANGE: %s\n",
>  					_("Extents did not match."));
>  			goto done;
>  		}
> -		if (args->length != 0 &&
> +		if (args->src_length != 0 &&
>  		    (info->bytes_deduped == 0 ||
> -		     info->bytes_deduped > args->length))
> +		     info->bytes_deduped > args->src_length))
>  			break;
>  
>  		(*ops)++;
> -		args->logical_offset += info->bytes_deduped;
> -		info->logical_offset += info->bytes_deduped;
> -		if (args->length >= info->bytes_deduped)
> -			args->length -= info->bytes_deduped;
> +		args->src_offset += info->bytes_deduped;
> +		info->dest_offset += info->bytes_deduped;
> +		if (args->src_length >= info->bytes_deduped)
> +			args->src_length -= info->bytes_deduped;
>  		deduped += info->bytes_deduped;
>  	}
>  done:
> @@ -200,21 +200,21 @@ reflink_ioctl(
>  	uint64_t		len,
>  	int			*ops)
>  {
> -	struct xfs_clone_args	args;
> +	struct file_clone_range	args;
>  	int			error;
>  
>  	if (soffset == 0 && doffset == 0 && len == 0) {
> -		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
> +		error = ioctl(file->fd, FICLONE, fd);
>  		if (error)
> -			perror("XFS_IOC_CLONE");
> +			perror("FICLONE");
>  	} else {
>  		args.src_fd = fd;
>  		args.src_offset = soffset;
>  		args.src_length = len;
>  		args.dest_offset = doffset;
> -		error = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
> +		error = ioctl(file->fd, FICLONERANGE, &args);
>  		if (error)
> -			perror("XFS_IOC_CLONE_RANGE");
> +			perror("FICLONERANGE");
>  	}
>  	if (!error)
>  		(*ops)++;
> -- 
> 2.43.0
> 
> 

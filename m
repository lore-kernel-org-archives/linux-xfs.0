Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992E839879;
	Wed, 14 Aug 2024 05:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723612349; cv=none; b=qbqDacP97gyHj5IYBULBXqNyXhLQFIOfLXQ9YDsL9ZANTXpZ4s6s1RcG5HtTmdQ+L0A/89LzOfqa0/7XyLyRmfMU0yLr2VH8mhCyiZLol5wpnwID4nDUgIop/Y7oLesyuEa/3JOnVu6JkAtm/ivcSqcWcmY1NcuKooBepAEAO+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723612349; c=relaxed/simple;
	bh=Inla43+pi/44Nhb5T/nwC5IJ9GX/L5QYMTS/FVfyoPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tN9s93HyCR6HGjiJ2+SYCIaXiCQZ/Nyt1I8Mk7Hq9CoNwBVWaVOym9/aPP1gxLGToEXp9dCWaxQNmYWGw1x21a5aasV9JnBTQGDwQ4uhXHtqtEVPeSWGkooT2aT6AqTzKdvgtGTtdsE3W/024/87jxKpD6b3JwrficmbE0ffMNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA/QQerg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA/QQerg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E1C32786;
	Wed, 14 Aug 2024 05:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723612348;
	bh=Inla43+pi/44Nhb5T/nwC5IJ9GX/L5QYMTS/FVfyoPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SA/QQerg71Ju3qDAkz68EBDJuwl2Kh4Z3rHAfPURo1md94eJK/8fgg9XuJLI12o75
	 5xq49Lr7CfZwlDwbyklvBc/XOPPR54fz3mFjiTT/DGSBGk4ErLpyL2MHYtNqMx9vh/
	 /uKCRHSHY+oB65aD6pQgfSsgnrpwrH3Ft0vwAg7dWBgA79VPB7VmOQjGD25NMH3+Oc
	 76dwKPIuZK/mLPWZZmdXNEWXMqd7IexZSOc39iT3LtyIALnVt3VbZw+iHAtukjTUxG
	 XX4+p1ibBVt2maQpg9r6SP5vN9FkTi7ftNkSsjmIQUjCV/Q0Wtay3aReNConnlVq+b
	 p3DQ6HqYZRCCQ==
Date: Tue, 13 Aug 2024 22:12:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] add a new min_dio_alignment helper
Message-ID: <20240814051227.GC865349@frogsfrogsfrogs>
References: <20240814045232.21189-1-hch@lst.de>
 <20240814045232.21189-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814045232.21189-3-hch@lst.de>

On Wed, Aug 14, 2024 at 06:52:11AM +0200, Christoph Hellwig wrote:
> Add a new C program to find the minimum direct I/O alignment.  This
> uses the statx stx_dio_offset_align field if provided, then falls
> back to the BLKSSZGET ioctl for block backed file systems and finally
> the page size.  It is intended as a more capable replacement for the
> _min_dio_alignment bash helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  .gitignore              |  1 +
>  src/Makefile            |  2 +-
>  src/min_dio_alignment.c | 66 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 1 deletion(-)
>  create mode 100644 src/min_dio_alignment.c
> 
> diff --git a/.gitignore b/.gitignore
> index 97c7e0014..36083e9d3 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -207,6 +207,7 @@ tags
>  /src/log-writes/replay-log
>  /src/perf/*.pyc
>  /src/fiemap-fault
> +/src/min_dio_alignment
>  
>  # Symlinked files
>  /tests/generic/035.out
> diff --git a/src/Makefile b/src/Makefile
> index 559209be9..b3da59a0e 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -34,7 +34,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
>  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
>  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
> -	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault
> +	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment
>  
>  EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>  	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/min_dio_alignment.c b/src/min_dio_alignment.c
> new file mode 100644
> index 000000000..131f60236
> --- /dev/null
> +++ b/src/min_dio_alignment.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024 Christoph Hellwig
> + */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/mount.h>
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include "statx.h"
> +
> +static int min_dio_alignment(const char *mntpnt, const char *devname)
> +{
> +	struct statx stx = { };
> +	struct stat st;
> +	int fd;
> +
> +	/*
> +	 * If the file system supports STATX_DIOALIGN, use the dio_offset_align
> +	 * member, as that reports exactly the information that we are asking
> +	 * for.
> +	 *
> +	 * STATX_DIOALIGN is only reported on regular files, so use O_TMPFILE
> +	 * to create one without leaving a trace.
> +	 */
> +	fd = open(mntpnt, O_TMPFILE | O_RDWR | O_EXCL, 0600);
> +	if (fd >= 0 &&
> +	    xfstests_statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
> +	    (stx.stx_mask & STATX_DIOALIGN))
> +		return stx.stx_dio_offset_align;
> +
> +	/*
> +	 * If we are on a block device and no explicit aligned is reported, use
> +	 * the logical block size as a guestimate.
> +	 */
> +	if (stat(devname, &st) == 0 && S_ISBLK(st.st_mode)) {
> +		int dev_fd = open(devname, O_RDONLY);
> +		int logical_block_size;
> +
> +		if (dev_fd > 0 &&
> +		    fstat(dev_fd, &st) == 0 &&
> +		    S_ISBLK(st.st_mode) &&
> +		    ioctl(dev_fd, BLKSSZGET, &logical_block_size)) {
> +			return logical_block_size;
> +		}
> +	}
> +
> +	/*
> +	 * No support for STATX_DIOALIGN and not a block device:
> +	 * default to PAGE_SIZE.
> +	 */
> +	return getpagesize();
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	if (argc != 3) {
> +		fprintf(stderr, "usage: %s mountpoint devicename\n", argv[0]);
> +		exit(1);
> +	}
> +
> +	printf("%d\n", min_dio_alignment(argv[1], argv[2]));
> +	exit(0);
> +}
> -- 
> 2.43.0
> 
> 

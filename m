Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78C71A2841;
	Tue, 10 Sep 2024 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988195; cv=none; b=VjQ16ULUZxuQJuoPXU8l3hPGkFapImgSEoNssSNMLhPlD+6jKWsRAtUvEHeqsjslqs0sM0yRKaVWMBKr6YOVelP5vDsANEeEB7o1HHct/reefyzbXmvghaGlRJpVd3NobFjZ/RbXJty5Gfnp771Ir+pxQARuN818Ad3uTK7IBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988195; c=relaxed/simple;
	bh=T6RYEcjuhhod3pUWDrEvB4A/6paG475N0rB+dCDOgEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZYQLIZ6EdB/SlvLAVitrvpD3651nTXyMzWuKU8AYUD0d9lDZfxi9Y9g+5vOl8o6M8SkVOvg/3FPK92MAbB8Y264CaIfnf22SkM/E0WsYZDYpCgSjurE5AqbK8w8SgcVsh0vDAoQNGwoLCoxZJ9Iy/QzdiXcircvHtYV4uX/PAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3MBlNlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3MBlNlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D72FC4CEC3;
	Tue, 10 Sep 2024 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725988195;
	bh=T6RYEcjuhhod3pUWDrEvB4A/6paG475N0rB+dCDOgEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3MBlNlz8pG4bQFxfijQhdt0dFNJsDDZTFEB2PBbXVzCyfVH/lvbCWhtIKIpX4rM8
	 286oBhN+I3CyEvqf4NxrFKUm+j5vtCoqfwTZZiBWhVeNoO+6y9jT653aXnwqiD2TjI
	 psVb5zKhxo4tqmBCHYzHfR4/1cm7khWs1ogSyYWHrDmWEHANUT+c7pNNt3xpQlg9+a
	 ZlgpiWccOrS0SYIGBYzXS8GqVL2CsynO8qWAjVggP7dZnVr0oBO9ksYA5aErOwhhE3
	 mDMhikQdOVL+yxP35sftDO990aEZlltUHLLNeNyUI1I4NJU5brs07df6h/57TKkg4e
	 ZwDUVc9kXenug==
Date: Tue, 10 Sep 2024 10:09:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] add a new min_dio_alignment helper
Message-ID: <20240910170953.GC2642@sol.localdomain>
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

If the file doesn't support DIO then this returns 0.

How did you intend to handle this case?

The callers of this program in xfstests don't check for 0.

- Eric

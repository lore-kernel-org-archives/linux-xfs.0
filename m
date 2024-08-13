Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E967719E819;
	Tue, 13 Aug 2024 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560281; cv=none; b=kvSmo8YjyOkFKkTRgR2QUj2khQ2zVoXJ8wdBDkLhDlfoX/VxCI9IGFMBGXHx6zntNsZAONq1MD2MdGZHdFmPGo+4NUmWyjqIyqa8ROWmqhk1hGE6f8L4u/Uz4oWF91XJKv6lm47L0aR8FT+9mvXTDKn5StHWVhOMw7HlFz73JYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560281; c=relaxed/simple;
	bh=cUiAhBsYggxAw4WIPhShsijtOiPHJ8+61Jrc+S2Z6ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgwkQ5MynXHzSTS1lsuSYjK/r1dXYwZV+eSdkQmvtksgE4UDyXuBCExr3vfebygeiFbhvPsUwUDalejS+6tssQ8D9tNoSfBbf56VRKVEeSwsNs2qpbk7/QhTsKK7mJws2zBux+5DCfZMHWJAIkfQzDVyiTKpIMJ7rG4yxRJQbNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz0fq+1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz0fq+1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69342C4AF0B;
	Tue, 13 Aug 2024 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560280;
	bh=cUiAhBsYggxAw4WIPhShsijtOiPHJ8+61Jrc+S2Z6ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pz0fq+1V3gLCLlcv5OS7PvHMxeiM04hUv+jqiF13/5xSEhL49za6BaeCO5c/5Cx2b
	 R0dbuMM0vekr9utq784NUPLFXedUCSjTB8y1Vppi16+28kMrBRnpy4hBPEK43lIid3
	 anVSvkArLd6/Qw2VNjO3pZEZDbuUqw8Md90T6xx4Uh65+18BolwhzO55eZzo5iVNMA
	 4uY+vAl1a2QO2LpQd2roqBewVnR7w6yI2XA7RK9jNQUqtyXuYKl+TlBOk0j/Vxq33J
	 KatVl4tIwZ2ls3NLgtdM/JCQY8Pq3Ev1zlCsZhtY4L9aSXug4YxBFuyxCTxvRtZjgr
	 CxqvF4aJSn5Gg==
Date: Tue, 13 Aug 2024 07:44:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] add a new min_dio_alignment helper
Message-ID: <20240813144439.GG6047@frogsfrogsfrogs>
References: <20240813073527.81072-1-hch@lst.de>
 <20240813073527.81072-3-hch@lst.de>
 <20240813144004.GD6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144004.GD6047@frogsfrogsfrogs>

On Tue, Aug 13, 2024 at 07:40:04AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 13, 2024 at 09:35:01AM +0200, Christoph Hellwig wrote:
> > Add a new C program to find the minimum direct I/O alignment.  This
> > uses the statx stx_dio_offset_align field if provided, then falls
> > back to the BLKSSZGET ioctl for block backed file systems and finally
> > the page size.  It is intended as a more capable replacement for the
> > _min_dio_alignment bash helper.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  src/Makefile            |  2 +-
> >  src/min_dio_alignment.c | 66 +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 67 insertions(+), 1 deletion(-)
> >  create mode 100644 src/min_dio_alignment.c
> > 
> > diff --git a/src/Makefile b/src/Makefile
> > index 559209be9..b3da59a0e 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -34,7 +34,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
> >  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
> >  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
> > -	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault
> > +	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment

Also this program ought to be listed in gitignore.

--D

> >  
> >  EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
> >  	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> > diff --git a/src/min_dio_alignment.c b/src/min_dio_alignment.c
> > new file mode 100644
> > index 000000000..c3345bfb2
> > --- /dev/null
> > +++ b/src/min_dio_alignment.c
> > @@ -0,0 +1,66 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2024 Christoph Hellwig
> > + */
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <sys/mount.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/stat.h>
> > +#include "statx.h"
> > +
> > +static int min_dio_alignmenent(const char *mntpnt, const char *devname)
> 
>               min_dio_alignment
> 
> > +{
> > +	struct statx stx = { };
> > +	struct stat st;
> > +	int fd;
> > +
> > +	/*
> > +	 * If the file system supports STATX_DIOALIGN, use the dio_offset_align
> > +	 * member, as that reports exactly the information that we are asking
> > +	 * for.
> > +	 *
> > +	 * STATX_DIOALIGN is only reported on regular files, so use O_TMPFILE
> > +	 * to create one without leaving a trace.
> > +	 */
> > +	fd = open(mntpnt, O_TMPFILE | O_RDWR | O_EXCL, 0600);
> > +	if (fd >= 0 &&
> > +	    xfstests_statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
> > +	    (stx.stx_mask & STATX_DIOALIGN))
> > +		return stx.stx_dio_offset_align;
> > +
> > +	/*
> > +	 * If we are on a block device and no explicit aligned is reported, use
> > +	 * the logical block size as a guestimate.
> > +	 */
> > +	if (stat(devname, &st) == 0 && S_ISBLK(st.st_mode)) {
> > +		int dev_fd = open(devname, O_RDONLY);
> > +		int logical_block_size;
> > +
> > +		if (dev_fd > 0 &&
> > +		    fstat(dev_fd, &st) == 0 &&
> > +		    S_ISBLK(st.st_mode) &&
> > +		    ioctl(dev_fd, BLKSSZGET, &logical_block_size)) {
> > +			return logical_block_size;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * No support for STATX_DIOALIGN and not a block device:
> > +	 * default to PAGE_SIZE.
> 
> Should we try DIOINFO here as a second to last gasp?
> 
> --D
> 
> > +	 */
> > +	return getpagesize();
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	if (argc != 3) {
> > +		fprintf(stderr, "usage: %s mountpoint devicename\n", argv[0]);
> > +		exit(1);
> > +	}
> > +
> > +	printf("%d\n", min_dio_alignmenent(argv[1], argv[2]));
> > +	exit(0);
> > +}
> > -- 
> > 2.43.0
> > 
> > 
> 

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 007F67CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:43:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C75CE304048
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 18:43:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SqdJSVTEXKuyls6r for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 18:43:46 -0800 (PST)
Received: from Liberator.local (24-158-28-51.static.dlth.mn.charter.com
	[24.158.28.51])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4D96863C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:43:45 -0600 (CST)
Subject: Re: [PATCH v4 1/2] libxcmd: generalize topology functions
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
	<1455303811-9874-2-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BE9860.6020605@sandeen.net>
Date: Fri, 12 Feb 2016 20:43:44 -0600
MIME-Version: 1.0
In-Reply-To: <1455303811-9874-2-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 2/12/16 1:03 PM, Bill O'Donnell wrote:
> Move general topology functions from xfs_mkfs to new topology
> collection in libxcmd.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/Makefile   |   1 +
>  include/libxcmd.h  |  56 +++++++++
>  libxcmd/Makefile   |   2 +-
>  libxcmd/topology.c | 341 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/Makefile      |   2 +-
>  mkfs/xfs_mkfs.c    | 321 +------------------------------------------------
>  6 files changed, 401 insertions(+), 322 deletions(-)
>  create mode 100644 include/libxcmd.h
>  create mode 100644 libxcmd/topology.c
> 
> diff --git a/include/Makefile b/include/Makefile
> index 6148756..2671f07 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -20,6 +20,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LIBHFILES = libxfs.h \
>  	libxlog.h \
> +	libxcmd.h \
>  	atomic.h \
>  	bitops.h \
>  	cache.h \
> diff --git a/include/libxcmd.h b/include/libxcmd.h
> new file mode 100644
> index 0000000..a912534
> --- /dev/null
> +++ b/include/libxcmd.h
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#ifndef __LIBXCMD_H__
> +#define __LIBXCMD_H__
> +
> +#include "libxfs.h"
> +#include <sys/time.h>
> +
> +/*
> + * Device topology information.
> + */
> +typedef struct fs_topology {
> +	int	dsunit;		/* stripe unit - data subvolume */
> +	int	dswidth;	/* stripe width - data subvolume */
> +	int	rtswidth;	/* stripe width - rt subvolume */
> +	int	lsectorsize;	/* logical sector size &*/
> +	int	psectorsize;	/* physical sector size */
> +} fs_topology_t;
> +
> +extern void
> +get_topology(
> +	libxfs_init_t		*xi,
> +	struct fs_topology	*ft,
> +	int			force_overwrite);
> +
> +extern void
> +calc_default_ag_geometry(
> +	int		blocklog,
> +	__uint64_t	dblocks,
> +	int		multidisk,
> +	__uint64_t	*agsize,
> +	__uint64_t	*agcount);
> +
> +extern int
> +check_overwrite(
> +	char		*device);
> +
> +
> +
> +#endif	/* __LIBXCMD_H__ */
> diff --git a/libxcmd/Makefile b/libxcmd/Makefile
> index 7701ed9..aab8d6d 100644
> --- a/libxcmd/Makefile
> +++ b/libxcmd/Makefile
> @@ -10,7 +10,7 @@ LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
>  
> -CFILES = command.c input.c paths.c projects.c help.c quit.c
> +CFILES = command.c input.c paths.c projects.c help.c quit.c topology.c
>  
>  ifeq ($(HAVE_GETMNTENT),yes)
>  LCFLAGS += -DHAVE_GETMNTENT
> diff --git a/libxcmd/topology.c b/libxcmd/topology.c
> new file mode 100644
> index 0000000..4cbe4b1
> --- /dev/null
> +++ b/libxcmd/topology.c
> @@ -0,0 +1,341 @@
> +/*
> + * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "libxfs.h"
> +#include "libxcmd.h"
> +#ifdef ENABLE_BLKID
> +#  include <blkid/blkid.h>
> +#endif /* ENABLE_BLKID */
> +#include "../mkfs/xfs_mkfs.h"
> +
> +#define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
> +#define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
> +#define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
> +
> +void
> +calc_default_ag_geometry(
> +	int		blocklog,
> +	__uint64_t	dblocks,
> +	int		multidisk,
> +	__uint64_t	*agsize,
> +	__uint64_t	*agcount)
> +{
> +	__uint64_t	blocks = 0;
> +	int		shift = 0;
> +
> +	/*
> +	 * First handle the high extreme - the point at which we will
> +	 * always use the maximum AG size.
> +	 *
> +	 * This applies regardless of storage configuration.
> +	 */
> +	if (dblocks >= TERABYTES(32, blocklog)) {
> +		blocks = XFS_AG_MAX_BLOCKS(blocklog);
> +		goto done;
> +	}
> +
> +	/*
> +	 * For the remainder we choose an AG size based on the
> +	 * number of data blocks available, trying to keep the
> +	 * number of AGs relatively small (especially compared
> +	 * to the original algorithm).  AG count is calculated
> +	 * based on the preferred AG size, not vice-versa - the
> +	 * count can be increased by growfs, so prefer to use
> +	 * smaller counts at mkfs time.
> +	 *
> +	 * For a single underlying storage device between 128MB
> +	 * and 4TB in size, just use 4 AGs, otherwise scale up
> +	 * smoothly between min/max AG sizes.
> +	 */
> +
> +	if (!multidisk && dblocks >= MEGABYTES(128, blocklog)) {
> +		if (dblocks >= TERABYTES(4, blocklog)) {
> +			blocks = XFS_AG_MAX_BLOCKS(blocklog);
> +			goto done;
> +		}
> +		shift = 2;
> +	} else if (dblocks > GIGABYTES(512, blocklog))
> +		shift = 5;
> +	else if (dblocks > GIGABYTES(8, blocklog))
> +		shift = 4;
> +	else if (dblocks >= MEGABYTES(128, blocklog))
> +		shift = 3;
> +	else if (dblocks >= MEGABYTES(64, blocklog))
> +		shift = 2;
> +	else if (dblocks >= MEGABYTES(32, blocklog))
> +		shift = 1;
> +	else
> +		shift = 0;
> +	/*
> +	 * If dblocks is not evenly divisible by the number of
> +	 * desired AGs, round "blocks" up so we don't lose the
> +	 * last bit of the filesystem. The same principle applies
> +	 * to the AG count, so we don't lose the last AG!
> +	 */
> +	blocks = dblocks >> shift;
> +	if (dblocks & xfs_mask32lo(shift)) {
> +		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
> +		    blocks++;
> +	}
> +done:
> +	*agsize = blocks;
> +	*agcount = dblocks / blocks + (dblocks % blocks != 0);
> +}
> +
> +/*
> + * Check for existing filesystem or partition table on device.
> + * Returns:
> + *	 1 for existing fs or partition
> + *	 0 for nothing found
> + *	-1 for internal error
> + */
> +#ifdef ENABLE_BLKID
> +int
> +check_overwrite(
> +	char		*device)
> +{
> +	const char	*type;
> +	blkid_probe	pr = NULL;
> +	int		ret;
> +	int		fd;
> +	long long	size;
> +	int		bsz;
> +
> +	if (!device || !*device)
> +		return 0;
> +
> +	ret = -1; /* will reset on success of all setup calls */
> +
> +	fd = open(device, O_RDONLY);
> +	if (fd < 0)
> +		goto out;
> +	platform_findsizes(device, fd, &size, &bsz);
> +	close(fd);
> +
> +	/* nothing to overwrite on a 0-length device */
> +	if (size == 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	pr = blkid_new_probe_from_filename(device);
> +	if (!pr)
> +		goto out;
> +
> +	ret = blkid_probe_enable_partitions(pr, 1);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = blkid_do_fullprobe(pr);
> +	if (ret < 0)
> +		goto out;
> +
> +	/*
> +	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
> +	 * but we want the exact opposite, so reverse the return value here.
> +	 *
> +	 * In addition print some useful diagnostics about what actually is
> +	 * on the device.
> +	 */
> +	if (ret) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
> +		fprintf(stderr,
> +			_("%s: %s appears to contain an existing "
> +			"filesystem (%s).\n"), progname, device, type);
> +	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
> +		fprintf(stderr,
> +			_("%s: %s appears to contain a partition "
> +			"table (%s).\n"), progname, device, type);
> +	} else {
> +		fprintf(stderr,
> +			_("%s: %s appears to contain something weird "
> +			"according to blkid\n"), progname, device);
> +	}
> +	ret = 1;
> +
> +out:
> +	if (pr)
> +		blkid_free_probe(pr);
> +	if (ret == -1)
> +		fprintf(stderr,
> +			_("%s: probe of %s failed, cannot detect "
> +			  "existing filesystem.\n"), progname, device);
> +	return ret;
> +}
> +
> +static void
> +blkid_get_topology(
> +	const char	*device,
> +	int		*sunit,
> +	int		*swidth,
> +	int		*lsectorsize,
> +	int		*psectorsize,
> +	int		force_overwrite)
> +{
> +
> +	blkid_topology	tp;
> +	blkid_probe 	pr;
> +	unsigned long	val;
> +	struct stat	statbuf;
> +
> +	/* can't get topology info from a file */
> +	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
> +		return;
> +
> +	pr = blkid_new_probe_from_filename(device);
> +	if (!pr)
> +		return;
> +
> +	tp = blkid_probe_get_topology(pr);
> +	if (!tp)
> +		goto out_free_probe;
> +
> +	val = blkid_topology_get_logical_sector_size(tp);
> +	*lsectorsize = val;
> +	val = blkid_topology_get_physical_sector_size(tp);
> +	*psectorsize = val;
> +	val = blkid_topology_get_minimum_io_size(tp);
> +	*sunit = val;
> +	val = blkid_topology_get_optimal_io_size(tp);
> +	*swidth = val;
> +
> +	/*
> +	 * If the reported values are the same as the physical sector size
> +	 * do not bother to report anything.  It will only cause warnings
> +	 * if people specify larger stripe units or widths manually.
> +	 */
> +	if (*sunit == *psectorsize || *swidth == *psectorsize) {
> +		*sunit = 0;
> +		*swidth = 0;
> +	}
> +
> +	/*
> +	 * Blkid reports the information in terms of bytes, but we want it in
> +	 * terms of 512 bytes blocks (only to convert it to bytes later..)
> +	 */
> +	*sunit = *sunit >> 9;
> +	*swidth = *swidth >> 9;
> +
> +	if (blkid_topology_get_alignment_offset(tp) != 0) {
> +		fprintf(stderr,
> +			_("warning: device is not properly aligned %s\n"),
> +			device);
> +
> +		if (!force_overwrite) {
> +			fprintf(stderr,
> +				_("Use -f to force usage of a misaligned device\n"));
> +
> +			exit(EXIT_FAILURE);
> +		}
> +		/* Do not use physical sector size if the device is misaligned */
> +		*psectorsize = *lsectorsize;
> +	}
> +
> +	blkid_free_probe(pr);
> +	return;
> +
> +out_free_probe:
> +	blkid_free_probe(pr);
> +	fprintf(stderr,
> +		_("warning: unable to probe device topology for device %s\n"),
> +		device);
> +}
> +#else /* ifdef ENABLE_BLKID */
> +/*
> + * Without blkid, we can't do a good check for signatures.
> + * So instead of some messy attempts, just disable any checks
> + * and always return 'nothing found'.
> + */
> +#  warning BLKID is disabled, so signature detection and block device\
> + access are not working!
> +
> +int
> +check_overwrite(
> +	char		*device)
> +{
> +	return 1;
> +}
> +
> +static void
> +blkid_get_topology(
> +	const char	*device,
> +	int		*sunit,
> +	int		*swidth,
> +	int		*lsectorsize,
> +	int		*psectorsize,
> +	int		force_overwrite)
> +{
> +	/*
> +	 * Shouldn't make any difference (no blkid = no block device access),
> +	 * but make sure this dummy replacement returns with at least some
> +	 * sanity.
> +	 */
> +	*lsectorsize = *psectorsize = 512;
> +}
> +
> +#endif /* ENABLE_BLKID */
> +
> +
> +void
> +get_topology(
> +	libxfs_init_t		*xi,
> +	struct fs_topology	*ft,
> +	int			force_overwrite)
> +{
> +	struct stat statbuf;
> +	char *dfile = xi->volname ? xi->volname : xi->dname;
> +
> +	/*
> +	 * If our target is a regular file, use platform_findsizes
> +	 * to try to obtain the underlying filesystem's requirements
> +	 * for direct IO; we'll set our sector size to that if possible.
> +	 */
> +	if (xi->disfile ||
> +	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
> +		int fd;
> +		int flags = O_RDONLY;
> +		long long dummy;
> +
> +		/* with xi->disfile we may not have the file yet! */
> +		if (xi->disfile)
> +			flags |= O_CREAT;
> +
> +		fd = open(dfile, flags, 0666);
> +		if (fd >= 0) {
> +			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
> +			close(fd);
> +			ft->psectorsize = ft->lsectorsize;
> +		} else
> +			ft->psectorsize = ft->lsectorsize = BBSIZE;
> +	} else {
> +		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> +				   &ft->lsectorsize, &ft->psectorsize,
> +				   force_overwrite);
> +	}
> +
> +	if (xi->rtname && !xi->risfile) {
> +		int sunit, lsectorsize, psectorsize;
> +
> +		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
> +				   &lsectorsize, &psectorsize, force_overwrite);
> +	}
> +}
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 570ab07..2997398 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,7 +10,7 @@ LTCOMMAND = mkfs.xfs
>  HFILES = xfs_mkfs.h
>  CFILES = maxtrres.c proto.c xfs_mkfs.c
>  
> -LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> +LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
>  LTDEPENDENCIES += $(LIBXFS)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4c3a802..0a02719 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -22,17 +22,7 @@
>  #  include <blkid/blkid.h>
>  #endif /* ENABLE_BLKID */
>  #include "xfs_mkfs.h"
> -
> -/*
> - * Device topology information.
> - */
> -struct fs_topology {
> -	int	dsunit;		/* stripe unit - data subvolume */
> -	int	dswidth;	/* stripe width - data subvolume */
> -	int	rtswidth;	/* stripe width - rt subvolume */
> -	int	lsectorsize;	/* logical sector size &*/
> -	int	psectorsize;	/* physical sector size */
> -};
> +#include "libxcmd.h"
>  
>  /*
>   * Prototypes for internal functions.
> @@ -295,244 +285,6 @@ calc_stripe_factors(
>  	}
>  }
>  
> -/*
> - * Check for existing filesystem or partition table on device.
> - * Returns:
> - *	 1 for existing fs or partition
> - *	 0 for nothing found
> - *	-1 for internal error
> - */
> -#ifdef ENABLE_BLKID
> -static int
> -check_overwrite(
> -	char		*device)
> -{
> -	const char	*type;
> -	blkid_probe	pr = NULL;
> -	int		ret;
> -	int		fd;
> -	long long	size;
> -	int		bsz;
> -
> -	if (!device || !*device)
> -		return 0;
> -
> -	ret = -1; /* will reset on success of all setup calls */
> -
> -	fd = open(device, O_RDONLY);
> -	if (fd < 0)
> -		goto out;
> -	platform_findsizes(device, fd, &size, &bsz);
> -	close(fd);
> -
> -	/* nothing to overwrite on a 0-length device */
> -	if (size == 0) {
> -		ret = 0;
> -		goto out;
> -	}
> -
> -	pr = blkid_new_probe_from_filename(device);
> -	if (!pr)
> -		goto out;
> -
> -	ret = blkid_probe_enable_partitions(pr, 1);
> -	if (ret < 0)
> -		goto out;
> -
> -	ret = blkid_do_fullprobe(pr);
> -	if (ret < 0)
> -		goto out;
> -
> -	/*
> -	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
> -	 * but we want the exact opposite, so reverse the return value here.
> -	 *
> -	 * In addition print some useful diagnostics about what actually is
> -	 * on the device.
> -	 */
> -	if (ret) {
> -		ret = 0;
> -		goto out;
> -	}
> -
> -	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
> -		fprintf(stderr,
> -			_("%s: %s appears to contain an existing "
> -			"filesystem (%s).\n"), progname, device, type);
> -	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
> -		fprintf(stderr,
> -			_("%s: %s appears to contain a partition "
> -			"table (%s).\n"), progname, device, type);
> -	} else {
> -		fprintf(stderr,
> -			_("%s: %s appears to contain something weird "
> -			"according to blkid\n"), progname, device);
> -	}
> -	ret = 1;
> -
> -out:
> -	if (pr)
> -		blkid_free_probe(pr);
> -	if (ret == -1)
> -		fprintf(stderr,
> -			_("%s: probe of %s failed, cannot detect "
> -			  "existing filesystem.\n"), progname, device);
> -	return ret;
> -}
> -
> -static void blkid_get_topology(
> -	const char	*device,
> -	int		*sunit,
> -	int		*swidth,
> -	int		*lsectorsize,
> -	int		*psectorsize,
> -	int		force_overwrite)
> -{
> -
> -	blkid_topology tp;
> -	blkid_probe pr;
> -	unsigned long val;
> -	struct stat statbuf;
> -
> -	/* can't get topology info from a file */
> -	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
> -		return;
> -
> -	pr = blkid_new_probe_from_filename(device);
> -	if (!pr)
> -		return;
> -
> -	tp = blkid_probe_get_topology(pr);
> -	if (!tp)
> -		goto out_free_probe;
> -
> -	val = blkid_topology_get_logical_sector_size(tp);
> -	*lsectorsize = val;
> -	val = blkid_topology_get_physical_sector_size(tp);
> -	*psectorsize = val;
> -	val = blkid_topology_get_minimum_io_size(tp);
> -	*sunit = val;
> -	val = blkid_topology_get_optimal_io_size(tp);
> -	*swidth = val;
> -
> -	/*
> -	 * If the reported values are the same as the physical sector size
> -	 * do not bother to report anything.  It will only cause warnings
> -	 * if people specify larger stripe units or widths manually.
> -	 */
> -	if (*sunit == *psectorsize || *swidth == *psectorsize) {
> -		*sunit = 0;
> -		*swidth = 0;
> -	}
> -
> -	/*
> -	 * Blkid reports the information in terms of bytes, but we want it in
> -	 * terms of 512 bytes blocks (only to convert it to bytes later..)
> -	 */
> -	*sunit = *sunit >> 9;
> -	*swidth = *swidth >> 9;
> -
> -	if (blkid_topology_get_alignment_offset(tp) != 0) {
> -		fprintf(stderr,
> -			_("warning: device is not properly aligned %s\n"),
> -			device);
> -
> -		if (!force_overwrite) {
> -			fprintf(stderr,
> -				_("Use -f to force usage of a misaligned device\n"));
> -
> -			exit(EXIT_FAILURE);
> -		}
> -		/* Do not use physical sector size if the device is misaligned */
> -		*psectorsize = *lsectorsize;
> -	}
> -
> -	blkid_free_probe(pr);
> -	return;
> -
> -out_free_probe:
> -	blkid_free_probe(pr);
> -	fprintf(stderr,
> -		_("warning: unable to probe device topology for device %s\n"),
> -		device);
> -}
> -#else /* ifdef ENABLE_BLKID */
> -/*
> - * Without blkid, we can't do a good check for signatures.
> - * So instead of some messy attempts, just disable any checks
> - * and always return 'nothing found'.
> - */
> -#  warning BLKID is disabled, so signature detection and block device\
> - access are not working!
> -static int
> -check_overwrite(
> -	char		*device)
> -{
> -	return 1;
> -}
> -
> -static void blkid_get_topology(
> -	const char	*device,
> -	int		*sunit,
> -	int		*swidth,
> -	int		*lsectorsize,
> -	int		*psectorsize,
> -	int		force_overwrite)
> -{
> -	/*
> -	 * Shouldn't make any difference (no blkid = no block device access),
> -	 * but make sure this dummy replacement returns with at least some
> -	 * sanity.
> -	 */
> -	*lsectorsize = *psectorsize = 512;
> -}
> -
> -#endif /* ENABLE_BLKID */
> -
> -static void get_topology(
> -	libxfs_init_t		*xi,
> -	struct fs_topology	*ft,
> -	int			force_overwrite)
> -{
> -	struct stat statbuf;
> -	char *dfile = xi->volname ? xi->volname : xi->dname;
> -
> -	/*
> -	 * If our target is a regular file, use platform_findsizes
> -	 * to try to obtain the underlying filesystem's requirements
> -	 * for direct IO; we'll set our sector size to that if possible.
> -	 */
> -	if (xi->disfile ||
> -	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
> -		int fd;
> -		int flags = O_RDONLY;
> -		long long dummy;
> -
> -		/* with xi->disfile we may not have the file yet! */
> -		if (xi->disfile)
> -			flags |= O_CREAT;
> -
> -		fd = open(dfile, flags, 0666);
> -		if (fd >= 0) {
> -			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
> -			close(fd);
> -			ft->psectorsize = ft->lsectorsize;
> -		} else
> -			ft->psectorsize = ft->lsectorsize = BBSIZE;
> -	} else {
> -		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> -				   &ft->lsectorsize, &ft->psectorsize,
> -				   force_overwrite);
> -	}
> -
> -	if (xi->rtname && !xi->risfile) {
> -		int sunit, lsectorsize, psectorsize;
> -
> -		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
> -				   &lsectorsize, &psectorsize, force_overwrite);
> -	}
> -}
> -
>  static void
>  fixup_log_stripe_unit(
>  	int		lsflag,
> @@ -640,77 +392,6 @@ calc_default_imaxpct(
>  	return 1;
>  }
>  
> -
> -void
> -calc_default_ag_geometry(
> -	int		blocklog,
> -	__uint64_t	dblocks,
> -	int		multidisk,
> -	__uint64_t	*agsize,
> -	__uint64_t	*agcount)
> -{
> -	__uint64_t	blocks = 0;
> -	int		shift = 0;
> -
> -	/*
> -	 * First handle the high extreme - the point at which we will
> -	 * always use the maximum AG size.
> -	 *
> -	 * This applies regardless of storage configuration.
> -	 */
> -	if (dblocks >= TERABYTES(32, blocklog)) {
> -		blocks = XFS_AG_MAX_BLOCKS(blocklog);
> -		goto done;
> -	}
> -
> -	/*
> -	 * For the remainder we choose an AG size based on the
> -	 * number of data blocks available, trying to keep the
> -	 * number of AGs relatively small (especially compared
> -	 * to the original algorithm).  AG count is calculated
> -	 * based on the preferred AG size, not vice-versa - the
> -	 * count can be increased by growfs, so prefer to use
> -	 * smaller counts at mkfs time.
> -	 *
> -	 * For a single underlying storage device between 128MB
> -	 * and 4TB in size, just use 4 AGs, otherwise scale up
> -	 * smoothly between min/max AG sizes.
> -	 */
> -
> -	if (!multidisk && dblocks >= MEGABYTES(128, blocklog)) {
> -		if (dblocks >= TERABYTES(4, blocklog)) {
> -			blocks = XFS_AG_MAX_BLOCKS(blocklog);
> -			goto done;
> -		}
> -		shift = 2;
> -	} else if (dblocks > GIGABYTES(512, blocklog))
> -		shift = 5;
> -	else if (dblocks > GIGABYTES(8, blocklog))
> -		shift = 4;
> -	else if (dblocks >= MEGABYTES(128, blocklog))
> -		shift = 3;
> -	else if (dblocks >= MEGABYTES(64, blocklog))
> -		shift = 2;
> -	else if (dblocks >= MEGABYTES(32, blocklog))
> -		shift = 1;
> -	else
> -		shift = 0;
> -	/*
> -	 * If dblocks is not evenly divisible by the number of
> -	 * desired AGs, round "blocks" up so we don't lose the
> -	 * last bit of the filesystem. The same principle applies
> -	 * to the AG count, so we don't lose the last AG!
> -	 */
> -	blocks = dblocks >> shift;
> -	if (dblocks & xfs_mask32lo(shift)) {
> -		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
> -		    blocks++;
> -	}
> -done:
> -	*agsize = blocks;
> -	*agcount = dblocks / blocks + (dblocks % blocks != 0);
> -}
> -
>  static void
>  validate_ag_geometry(
>  	int		blocklog,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B9357CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 19:27:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3C06AC005
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 17:27:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5LFJGoaBpjBErm0g for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 17:27:26 -0800 (PST)
Date: Mon, 14 Dec 2015 12:27:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] mkfs: get sector size from host fs dev when
	mkfs'ing file
Message-ID: <20151214012712.GL26718@dastard>
References: <5660CD5E.2040209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5660CD5E.2040209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 03, 2015 at 05:16:46PM -0600, Eric Sandeen wrote:
> Now that we allow logical-sector-sized DIOs even if our xfs
> filesystem is set to physical-sector-sized "sectors," we can
> allow the creation of filesystem images with block and sector
> sizes down to the host device's logical sector size, rather
> than the filesystem's sector size.
> 
> So in platform_findsizes(), change our query of the filesystem
> to a query of the device, and use that for sector size in the
> S_IFREG case.
> 
> This allows the creation of i.e. a 2k block sized image on
> an xfs filesystem w/ 4k sector size created on a 4k/512
> block device, which would otherwise fail today.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This feels like about my 5th stab at this; it seems like
> the correct thing to do but by now my brain is full.
> Seem sane?

I'm not sure I like the idea of encoding blkid functionality
into libxfs, especially as blkid support is optional:

commit 6635d6ab510c58996f5ed3f212148db5e3c299ba
Author: Jan Tulak <jtulak@redhat.com>
Date:   Wed Oct 14 10:57:39 2015 +1100

    build: make libblkid usage optional


> Still needs a run through xfstests but wanted to see if this
> was obviously bonkers or not...?
> 
> (I don't know why copy/Makefile needs a $(LIBBLKID), either...)

Because libxfs now has a dependency on libblkid, and libxfs is a
static library so it doesn't resolve undefined extern objects as the
library is built. That is only done when linking binaries....

> index 885016a..3a8dc12 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -24,6 +24,7 @@
>  #include <sys/mount.h>
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
> +#include <blkid/blkid.h>
>  
>  #include "libxfs_priv.h"
>  #include "xfs_fs.h"
> @@ -142,18 +143,29 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
>  			progname, path, strerror(errno));
>  		exit(1);
>  	}
> +
>  	if ((st.st_mode & S_IFMT) == S_IFREG) {
> -		struct xfs_fsop_geom_v1 geom = { 0 };
> +		int	fd;
> +		char	*hostfs_dev_path;	/* path to host fs device */
>  
>  		*sz = (long long)(st.st_size >> 9);
> -		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> -			/*
> -			 * fall back to BBSIZE; mkfs might fail if there's a
> -			 * size mismatch between the image & the host fs...
> -			 */
> -			*bsz = BBSIZE;
> -		} else
> -			*bsz = geom.sectsize;
> +
> +		/*
> +		 * Default to BBSIZE; mkfs might fail if there's a
> +		 * size mismatch between the image & the host fs...
> +		 */
> +		*bsz = BBSIZE;
> +
> +		/* Get logical sector size of host device */
> +		hostfs_dev_path = blkid_devno_to_devname(st.st_dev);
> +		if (hostfs_dev_path) {
> +			fd = open(hostfs_dev_path, O_RDONLY);
> +			if (fd >= 0)
> +				if (ioctl(fd, BLKSSZGET, bsz) < 0)
> +					*bsz = BBSIZE;
> +			close(fd);
> +			free(hostfs_dev_path);
> +		}

So the current behaviour is to use the underlying filesystem
sector size, but we might have a 4k fs sector on a 512 physical
sector device, and you want to detect this, right? The logical
sector size is exposed by the filesystem in the XFS_IOC_DIOINFO
information. i.e:

        case XFS_IOC_DIOINFO: {
                struct dioattr  da;
                xfs_buftarg_t   *target =
                        XFS_IS_REALTIME_INODE(ip) ?
                        mp->m_rtdev_targp : mp->m_ddev_targp;

                da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
                da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);

                if (copy_to_user(arg, &da, sizeof(da)))
                        return -EFAULT;
                return 0;
        }

Isn't this exactly what XFS_IOC_DIOINFO is for?

(Oh, and "old kernels don't support...." simply means the distros
will have a kernel patch to backport, too....)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

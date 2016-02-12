Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7FC4E7CA4
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 18:19:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F019AAC007
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 16:19:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ovLOgUfOT8XwdDDt for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 16:19:14 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C13B863C5FF0
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 18:19:13 -0600 (CST)
Subject: Re: [PATCH 2/2 v3] xfs_repair: new secondary superblock search method
References: <1455130218-8683-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BD2500.4080708@sandeen.net>
Date: Thu, 11 Feb 2016 18:19:12 -0600
MIME-Version: 1.0
In-Reply-To: <1455130218-8683-1-git-send-email-billodo@redhat.com>
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

Hi Bill, looks like this is a diff on top of your prior patch,
not a standalone patch.  It's modifying (not creating) libxcmd/topology.c,
which doesn't exist upstream yet.

A couple small formatting things below, might save one more round trip ;)

-Eric

On 2/10/16 12:50 PM, Bill O'Donnell wrote:
> Optimize secondary sb search, using similar method to find
> fs geometry as that of xfs_mkfs. If this faster method fails
> in finding a secondary sb, fall back to original brute force
> slower search.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  Makefile           |  2 +-
>  include/libxcmd.h  |  4 +++-
>  libxcmd/topology.c | 36 ++++++++++++++++++++++++++++++++----
>  repair/Makefile    |  4 ++--
>  repair/sb.c        | 50 +++++++++++++++++++++++++++++++++++++++++---------
>  5 files changed, 79 insertions(+), 17 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index fca0a42..1d60d9c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -80,7 +80,7 @@ fsr: libhandle
>  growfs: libxcmd
>  io: libxcmd libhandle
>  quota: libxcmd
> -repair: libxlog
> +repair: libxlog libxcmd
>  copy: libxlog
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
> diff --git a/include/libxcmd.h b/include/libxcmd.h
> index df7046e..b140adb 100644
> --- a/include/libxcmd.h
> +++ b/include/libxcmd.h
> @@ -50,6 +50,8 @@ extern int
>  check_overwrite(
>  	char		*device);
>  
> -
> +extern int guess_default_geometry(__uint64_t *agsize,
> +				  __uint64_t *agcount,
> +				  libxfs_init_t x);
>  
>  #endif	/* __LIBXCMD_H__ */
> diff --git a/libxcmd/topology.c b/libxcmd/topology.c
> index 0eeea28..5f06be5 100644
> --- a/libxcmd/topology.c
> +++ b/libxcmd/topology.c
> @@ -192,7 +192,8 @@ out:
>  	return ret;
>  }
>  
> -static void blkid_get_topology(
> +static void
> +blkid_get_topology(
>  	const char	*device,
>  	int		*sunit,
>  	int		*swidth,
> @@ -284,7 +285,8 @@ check_overwrite(
>  	return 1;
>  }
>  
> -static void blkid_get_topology(
> +static void
> +blkid_get_topology(
>  	const char	*device,
>  	int		*sunit,
>  	int		*swidth,
> @@ -302,8 +304,8 @@ static void blkid_get_topology(
>  
>  #endif /* ENABLE_BLKID */
>  
> -
> -void get_topology(
> +void
> +get_topology(
>  	libxfs_init_t		*xi,
>  	struct fs_topology	*ft,
>  	int			force_overwrite)
> @@ -346,3 +348,29 @@ void get_topology(
>  				   &lsectorsize, &psectorsize, force_overwrite);
>  	}
>  }
> +
> +int
> +guess_default_geometry(
> +	__uint64_t *agsize, __uint64_t *agcount,
> +	libxfs_init_t x)

move all the args onto their own lines, with consistent
tab-spacing.

> +{
> +	struct fs_topology ft;
> +	int blocklog;
> +	__uint64_t	dblocks;
> +	int		multidisk;

consistent tabs out here, too please.

> +
> +	memset(&ft, 0, sizeof(ft));
> +	get_topology(&x, &ft, 1);
> +
> +	/*
> +	 * get geometry from get_topology result.
> +	 * Use default block size (2^12)
> +	 */
> +	blocklog = 12;
> +	multidisk = ft.dswidth | ft.dsunit;
> +	dblocks = x.dsize >> (blocklog - BBSHIFT);
> +	calc_default_ag_geometry(blocklog, dblocks, multidisk,
> +				 agsize, agcount);
> +
> +	return blocklog;
> +}
> diff --git a/repair/Makefile b/repair/Makefile
> index 251722b..d24ab1f 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -20,8 +20,8 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
>  	progress.c prefetch.c rt.c sb.c scan.c threads.c \
>  	versions.c xfs_repair.c
>  
> -LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> -LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
> +LLDLIBS = $(LIBBLKID) $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
> +LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD)
>  LLDFLAGS = -static-libtool-libs
>  
>  default: depend $(LTCOMMAND)
> diff --git a/repair/sb.c b/repair/sb.c
> index 4eef14a..d91990a 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "libxcmd.h"
>  #include "libxlog.h"
>  #include "agheader.h"
>  #include "globals.h"
> @@ -85,10 +86,15 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
>  }
>  
>  /*
> - * find a secondary superblock, copy it into the sb buffer
> + * find a secondary superblock, copy it into the sb buffer.
> + * start is the point to begin reading BSIZE bytes.
> + * skip contains a byte-count of how far to advance for next read.
>   */
> -int
> -find_secondary_sb(xfs_sb_t *rsb)
> +static int
> +__find_secondary_sb(
> +	xfs_sb_t *rsb,
> +	__uint64_t start,
> +	__uint64_t skip)
>  {
>  	xfs_off_t	off;
>  	xfs_sb_t	*sb;
> @@ -101,7 +107,6 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	int		bsize;
>  
>  	do_warn(_("\nattempting to find secondary superblock...\n"));
> -
>  	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
>  	if (!sb) {
>  		do_error(
> @@ -117,7 +122,7 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	/*
>  	 * skip first sector since we know that's bad
>  	 */
> -	for (done = 0, off = XFS_AG_MIN_BYTES; !done ; off += bsize)  {
> +	for (done = 0, off = start; !done ; off += skip)  {
>  		/*
>  		 * read disk 1 MByte at a time.
>  		 */
> @@ -128,9 +133,7 @@ find_secondary_sb(xfs_sb_t *rsb)
>  		if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {
>  			done = 1;
>  		}
> -
>  		do_warn(".");
> -
>  		/*
>  		 * check the buffer 512 bytes at a time since
>  		 * we don't know how big the sectors really are.
> @@ -164,9 +167,38 @@ find_secondary_sb(xfs_sb_t *rsb)
>  			}
>  		}
>  	}
> -
>  	free(sb);
> -	return(retval);
> +	return retval;
> +}
> +
> +int
> +find_secondary_sb(xfs_sb_t *rsb)
> +{
> +	int		retval;
> +	__uint64_t	agcount;
> +	__uint64_t	agsize;
> +	__uint64_t	skip;
> +	int		blocklog;
> +
> +	/*
> +	 * Attempt to find secondary sb with a coarse approach,
> +	 * using a large skip (agsize in bytes). Failing that,
> +	 * fallback to the fine-grained approach using min agsize.
> +	 */
> +	blocklog = guess_default_geometry(&agsize, &agcount, x);
> +
> +	/*
> +	 * use found ag geometry to quickly find secondary sb
> +	 */
> +	skip = agsize << blocklog;
> +	retval = __find_secondary_sb(rsb, skip, skip);
> +	if (!retval)  {
> +		/*
> +		 * fallback: use minimum agsize for skipsize
> +		 */
> +		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
> +	}
> +	return retval;
>  }
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

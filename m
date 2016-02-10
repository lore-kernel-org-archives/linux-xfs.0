Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DAB929DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 22:49:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92C16AC005
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 20:49:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TWh594ffnCwW2dNu for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 20:49:21 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 596AF63C607A
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 22:49:21 -0600 (CST)
Subject: Re: [PATCH 2/2 v2] xfs_repair: new secondary superblock search
	method] xfs_repair: new secondary superblock search method
References: <1455068099-26992-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BAC150.7070808@sandeen.net>
Date: Tue, 9 Feb 2016 22:49:20 -0600
MIME-Version: 1.0
In-Reply-To: <1455068099-26992-1-git-send-email-billodo@redhat.com>
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

On 2/9/16 7:34 PM, Bill O'Donnell wrote:
> Optimize secondary sb search, using similar method to find
> fs geometry as that of xfs_mkfs. If this faster method fails
> in finding a secondary sb, fall back to original brute force
> slower search.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  Makefile           |  2 +-
>  include/libxcmd.h  |  4 +++-
>  libxcmd/topology.c | 35 ++++++++++++++++++++++++++++----
>  repair/Makefile    |  4 ++--
>  repair/sb.c        | 58 ++++++++++++++++++++++++++++++++++++++++++++----------
>  5 files changed, 85 insertions(+), 18 deletions(-)
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
> index 0eeea28..b98d9b9 100644
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
> @@ -346,3 +348,28 @@ void get_topology(
>  				   &lsectorsize, &psectorsize, force_overwrite);
>  	}
>  }
> +
> +int
> +guess_default_geometry(__uint64_t *agsize, __uint64_t *agcount,
> +		       libxfs_init_t x)
> +{
> +	struct fs_topology ft;
> +	int blocklog;

When in Rome:  :)

int
guess_default_geometry(
	__uint64_t	*agsize,
	__uint64_t	*agcount,
	libxfs_init_t	x)
{
...

(sorry, forgot to mention that last time, but other functions in the
file are laid out this way; it is easier to read)

> +	__uint64_t	dblocks;
> +	int		multidisk;
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
> index 4eef14a..8bc246e 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -22,6 +22,7 @@
>  #include "globals.h"
>  #include "protos.h"
>  #include "err_protos.h"
> +#include "libxcmd.h"

Nitpick, we usually include that right after libxfs.h.
 
>  #define BSIZE	(1024 * 1024)
>  
> @@ -85,10 +86,11 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
>  }
>  
>  /*
> - * find a secondary superblock, copy it into the sb buffer
> + * find a secondary superblock, copy it into the sb buffer.
> + * skipsize units is bytes, it contains either the agsize in bytes
> + * (if known), or the minimum agsize in bytes if agsize unknown.
>   */

Ok, so this is a little confused.  There are actually 3 relevant
parameters here:

1) The place to start reading
2) The number of bytes to read at that point
3) How far to seek forward for the next read

In the old world, it's:

1) XFS_MIN_AG_BYTES
2) BSIZE (1MB)
3) BSIZE (i.e. it does sequential reads)

In the new world, it's:

1) the guessed AG size (skipsize?)
2) BSIZE (more than we need, but not expensive, so leave it)
3) the guessed AG size (skipsize)

You really have 2 different pieces of info: Where to do the first read,
and how far forward to skip for the next read.  I don't think you
can convey that with a single argument, "skipsize."

> -int
> -find_secondary_sb(xfs_sb_t *rsb)
> +static int __find_secondary_sb(xfs_sb_t *rsb, __uint64_t skipsize)

better to format as:

static int
__find_secondary_sb(
	xfs_sb_t	*rsb,
	__uint64_t	skipsize)
{

but ...

>  {
>  	xfs_off_t	off;
>  	xfs_sb_t	*sb;
> @@ -99,9 +101,9 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	int		dirty;
>  	int		retval;
>  	int		bsize;
> +	int		readsize;
>  
>  	do_warn(_("\nattempting to find secondary superblock...\n"));
> -
>  	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
>  	if (!sb) {
>  		do_error(
> @@ -113,13 +115,16 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	retval = 0;
>  	dirty = 0;
>  	bsize = 0;
> +	readsize = 0;
>  
>  	/*
>  	 * skip first sector since we know that's bad
>  	 */
> -	for (done = 0, off = XFS_AG_MIN_BYTES; !done ; off += bsize)  {
> +	for (done = 0, off = skipsize; !done ; off += readsize)  {
>  		/*
> -		 * read disk 1 MByte at a time.

we are actually still doing that, read(x.dfd, sb, BSIZE), so I'd
leave the comment...

> +		 * read disk using readsize interval
> +		 * (either the bytecount of actual agsize or bsize if
> +		 * agsize undetermined.)


>  		 */
>  		if (lseek64(x.dfd, off, SEEK_SET) != off)  {
>  			done = 1;
> @@ -128,9 +133,13 @@ find_secondary_sb(xfs_sb_t *rsb)
>  		if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {
>  			done = 1;
>  		}
> -
> +		if (skipsize == XFS_AG_MIN_BYTES)  {
> +			readsize = bsize;
> +		}
> +		else  {

better as:
		} else {

> +			readsize = skipsize;
> +		}

I wouldn't call this "readsize" - we are only ever reading BSIZE at a time.
This is how much we advance each loop, so skipsize is a bit better.

But the _functional_ problem here is that it is possible and permissible
to have a filesystem with an AG size of XFS_AG_MIN_BYTES (16MB).

So if you guessed a default geometry with an agsize of XFS_AG_MIN_BYTES,
you've gone back to the fine-grained scanning.  The fs probably isn't
very big as a result, so it's not the end of the world, but ...
see below.

>  		do_warn(".");
> -
>  		/*
>  		 * check the buffer 512 bytes at a time since
>  		 * we don't know how big the sectors really are.
> @@ -164,9 +173,38 @@ find_secondary_sb(xfs_sb_t *rsb)
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
> +	__uint64_t	skipsize;
> +	__uint64_t	agcount;
> +	__uint64_t	agsize;
> +	int		blocklog;
> +
> +	/*
> +	 * Attempt to find secondary sb with a coarse approach,
> +	 * using a large skipsize (agsize in bytes). Failing that,
> +	 * fallback to the fine-grained approach using min agsize.
> +	 */
> +	blocklog = guess_default_geometry(&agsize, &agcount, x);
> +
> +	/*
> +	 * use found ag geometry to quickly find secondary sb
> +	 */
> +	skipsize = agsize << blocklog;
> +	retval = __find_secondary_sb(rsb, skipsize);
> +	if (!retval)  {
> +		/*
> +		 * fallback: use minimum agsize for skipsize
> +		 */
> +		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES);
> +	}
> +	return retval;
>  }

I'd make __find_secondary_sb() take (sb, start, skip) i.e. send in
this:

> +	retval = __find_secondary_sb(rsb, agsize, agsize);
> +	if (!retval)  {
> +		/*
> +		 * fallback: use minimum agsize for skipsize
> +		 */
> +		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
> +	}

and the function is something like:

static int
__find_secondary_sb(
        xfs_sb_t	*rsb,
	xfs_off_t	start,
        xfs_off_t	skip)

{

...

        for (done = 0, off = start; !done ; off += skip)  {
...
               if (lseek64(x.dfd, off, SEEK_SET) != off)
                        done = 1;

               if (!done && (read(x.dfd, sb, BSIZE)) <= 0)
                        done = 1;


because you really can't deduce both the starting point and the skip-ahead
size from just one parameter.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

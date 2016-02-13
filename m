Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BA147CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 21:12:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F397A304048
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 19:12:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mXuRU9bIq7kxsvp3 for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 19:12:21 -0800 (PST)
Received: from Liberator.local (24-158-28-51.static.dlth.mn.charter.com
	[24.158.28.51])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 02A6363C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 21:12:20 -0600 (CST)
Subject: Re: [PATCH v4 2/2] xfs_repair: new secondary superblock search method
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
	<1455303811-9874-3-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BE9F13.7080107@sandeen.net>
Date: Fri, 12 Feb 2016 21:12:19 -0600
MIME-Version: 1.0
In-Reply-To: <1455303811-9874-3-git-send-email-billodo@redhat.com>
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
> Optimize secondary sb search, using similar method to find
> fs geometry as that of xfs_mkfs. If this faster method fails
> in finding a secondary sb, fall back to original brute force
> slower search.

Hey Bill, looks like this is pretty much there.  I do have a few
comments, things which I really should have seen earlier, so I'm
very sorry about that.  Inline below.

I think you can just send a V5 in reply to this one to keep it in
the thread.

Dave's up to V6 on his latest patchset so don't feel too bad.  :D

-Eric
 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  Makefile           |  2 +-
>  include/libxcmd.h  |  6 +++++-
>  libxcmd/topology.c | 27 +++++++++++++++++++++++++++
>  repair/Makefile    |  4 ++--
>  repair/sb.c        | 49 +++++++++++++++++++++++++++++++++++++++++--------
>  5 files changed, 76 insertions(+), 12 deletions(-)
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
> index a912534..eb16cd5 100644
> --- a/include/libxcmd.h
> +++ b/include/libxcmd.h
> @@ -51,6 +51,10 @@ extern int
>  check_overwrite(
>  	char		*device);
>  
> -
> +extern int
> +guess_default_geometry(
> +	__uint64_t	*agsize,
> +	__uint64_t	*agcount,
> +	libxfs_init_t	x);

This function is only used in repair/sb.c, so it can just
be a static in that function, no need to have it in the library.

But more importantly, passing the libxfs_init_t structure by
value is pretty unusual; it works in this case because it's
not modified, but it would be safer and make more sense to
pass in a pointer.
 
>  #endif	/* __LIBXCMD_H__ */
> diff --git a/libxcmd/topology.c b/libxcmd/topology.c
> index 4cbe4b1..ec9695c 100644
> --- a/libxcmd/topology.c
> +++ b/libxcmd/topology.c
> @@ -339,3 +339,30 @@ get_topology(
>  				   &lsectorsize, &psectorsize, force_overwrite);
>  	}
>  }
> +
> +int
> +guess_default_geometry(
> +	__uint64_t	*agsize,
> +	__uint64_t	*agcount,
> +	libxfs_init_t	x)

+	__uint64_t		*agsize,
+	__uint64_t		*agcount,
+	libxfs_init_t		*x)

tab out to match below, and take pointer for x

> +{
> +	struct fs_topology	ft;
> +	int			blocklog;
> +	__uint64_t		dblocks;
> +	int			multidisk;
> +
> +	memset(&ft, 0, sizeof(ft));
> +	get_topology(&x, &ft, 1);

+	get_topology(x, &ft,1);

> +
> +	/*
> +	 * get geometry from get_topology result.
> +	 * Use default block size (2^12)
> +	 */
> +	blocklog = 12;
> +	multidisk = ft.dswidth | ft.dsunit;
> +	dblocks = x.dsize >> (blocklog - BBSHIFT);

+	dblocks = x->dsize >> (blocklog - BBSHIFT);

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
> index 4eef14a..8dcad5f 100644
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

again, tab those out to match:

+	xfs_sb_t 	*rsb,
+	__uint64_t 	start,
+	__uint64_t 	skip)

>  {
>  	xfs_off_t	off;
>  	xfs_sb_t	*sb;
> @@ -101,7 +107,6 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	int		bsize;
>  
>  	do_warn(_("\nattempting to find secondary superblock...\n"));
> -

No good reason to remove this line, really; sometimes we clean up
whitespace if it makes sense and we're in the area, but this hunk
is nothing but a line removal; generally don't want unrelated whitespace
changes to sneak in.

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

While we're at it - no reason to remove these lines, it makes the
dot-generator stand out a little more. ;)

>  		/*
>  		 * check the buffer 512 bytes at a time since
>  		 * we don't know how big the sectors really are.
> @@ -166,7 +169,37 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	}
>  
>  	free(sb);
> -	return(retval);
> +	return retval;
> +}

You can put guess_default_geometry() here, as a static
function.

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

"using a large start and skip," I guess.

> +	 * fallback to the fine-grained approach using min agsize.

"fallback to the fine-grained approach, starting at min agsize."

(it's not using min agsize for skip, so just to keep that clear)

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

actually that's the start, not skip; so

	"fallback: Start at min agsize and scan all blocks"

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

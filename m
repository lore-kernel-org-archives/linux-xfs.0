Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BD8929DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:14:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EFDE8F8066
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 11:14:17 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oTEb0SA1THy4Ekpv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 11:14:14 -0800 (PST)
Date: Tue, 9 Feb 2016 11:14:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs_repair: new secondary superblock search method
Message-ID: <20160209191409.GC6350@birch.djwong.org>
References: <1455037988-7213-1-git-send-email-billodo@redhat.com>
	<1455037988-7213-3-git-send-email-billodo@redhat.com>
	<56BA3868.7090900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56BA3868.7090900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 01:05:12PM -0600, Eric Sandeen wrote:
> On 2/9/16 11:13 AM, Bill O'Donnell wrote:
> > Optimize secondary sb search, using similar method to find
> > fs geometry as that of xfs_mkfs. If this faster method fails
> > in finding a secondary sb, fall back to original brute force
> > slower search.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  Makefile           |  2 +-
> >  include/libxcmd.h  |  4 +++-
> >  libxcmd/topology.c | 28 +++++++++++++++++++++++++++-
> >  repair/Makefile    |  4 ++--
> >  repair/phase1.c    | 25 +++++++++++++++++++++++--
> >  repair/protos.h    |  2 +-
> >  repair/sb.c        | 27 +++++++++++++++++++++------
> >  7 files changed, 78 insertions(+), 14 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index fca0a42..1d60d9c 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -80,7 +80,7 @@ fsr: libhandle
> >  growfs: libxcmd
> >  io: libxcmd libhandle
> >  quota: libxcmd
> > -repair: libxlog
> > +repair: libxlog libxcmd
> >  copy: libxlog
> >  
> >  ifeq ($(HAVE_BUILDDEFS), yes)
> > diff --git a/include/libxcmd.h b/include/libxcmd.h
> > index df7046e..b140adb 100644
> > --- a/include/libxcmd.h
> > +++ b/include/libxcmd.h
> > @@ -50,6 +50,8 @@ extern int
> >  check_overwrite(
> >  	char		*device);
> >  
> > -
> > +extern int guess_default_geometry(__uint64_t *agsize,
> > +				  __uint64_t *agcount,
> > +				  libxfs_init_t x);
> >  
> >  #endif	/* __LIBXCMD_H__ */
> > diff --git a/libxcmd/topology.c b/libxcmd/topology.c
> > index 0eeea28..4a8ab8b 100644
> > --- a/libxcmd/topology.c
> > +++ b/libxcmd/topology.c
> > @@ -302,7 +302,6 @@ static void blkid_get_topology(
> >  
> >  #endif /* ENABLE_BLKID */
> >  
> > -
> >  void get_topology(
> >  	libxfs_init_t		*xi,
> >  	struct fs_topology	*ft,
> > @@ -346,3 +345,30 @@ void get_topology(
> >  				   &lsectorsize, &psectorsize, force_overwrite);
> >  	}
> >  }
> > +
> > +/*
> > + * Use this macro before we have superblock and mount structure
> > + */
> > +#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
> 
> Hm, I hate this macro.  ;)  I know it lives in xfs_mkfs.c too... depending
> on a local variable is ick.  Since you only use it once below, it might be best
> to just open-code it, see below.
> 
> > +
> > +int guess_default_geometry(__uint64_t *agsize, __uint64_t *agcount, libxfs_init_t x) {
> 
> Move the "{" down to this line, please, and wrap the args so it doesn't go
> over 80 chars.

Also, please put the function name at the start of a line like most of the
other XFS code:

int
guess_default_geometry(
	__uint64_t	*agsize,
	__uint64_t	*agcount,
	libxfs_init_t	x)
{
	/* ... */
}

This makes it wayyyy easier to grep-hunt for function definitions.

(Try wading through the mishmash of ext4/e2fsprogs until your brain fades...)

--D

> 
> > +	struct fs_topology ft;
> > +	int blocklog;
> > +	__uint64_t      dblocks;
>                   ^tab here please
> > +	int             multidisk;
>            ^tabs here please
> 
> ... and a newline here to separate variable declarations...
> 
> > +        memset(&ft, 0, sizeof(ft));
> 
> ... from this call.  Tab this call in...
> 
> 
> > +        get_topology(&x, &ft, 1);
>    ^^^^ as well as this one.
> 
> > +
> > +        /*
>    ^ tab here too
> > +	 * get geometry from get_topology result.
> > +	 * Use default block size (2^12)
> > +	 */
> > +        blocklog = 12;
> > +        multidisk = ft.dswidth | ft.dsunit;
> > +	printf("x.dsize = %lu\n",(long unsigned int)x.dsize);
> 
> drop the debug printf
> 
> > +        dblocks = DTOBT(x.dsize);
> 
> maybe best to just:
> 
>            dblocks = x.dsize >> (blocklog - BBSHIFT); 
> 
> > +        calc_default_ag_geometry(blocklog, dblocks, multidisk,
> > +                                 agsize, agcount);
> 
> general whitespace problems above; use tabs not spaces please,
> as appropriate.
> 
> > +
> > +	return(blocklog);
> 
> while we're at it it'd be nice to make return not a function; 
> just "return blocklog;"
> 
> > +}
> > diff --git a/repair/Makefile b/repair/Makefile
> > index 251722b..d24ab1f 100644
> > --- a/repair/Makefile
> > +++ b/repair/Makefile
> > @@ -20,8 +20,8 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
> >  	progress.c prefetch.c rt.c sb.c scan.c threads.c \
> >  	versions.c xfs_repair.c
> >  
> > -LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> > -LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
> > +LLDLIBS = $(LIBBLKID) $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
> > +LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD)
> >  LLDFLAGS = -static-libtool-libs
> >  
> >  default: depend $(LTCOMMAND)
> > diff --git a/repair/phase1.c b/repair/phase1.c
> > index 126d0b3..c27033d 100644
> > --- a/repair/phase1.c
> > +++ b/repair/phase1.c
> > @@ -21,6 +21,7 @@
> >  #include "agheader.h"
> >  #include "protos.h"
> >  #include "err_protos.h"
> > +#include "libxcmd.h"
> >  
> >  static void
> >  no_sb(void)
> > @@ -47,6 +48,9 @@ alloc_ag_buf(int size)
> >   */
> >  #define MAX_SECTSIZE		(512 * 1024)
> >  
> > +extern libxfs_init_t x;
> 
> It would be better to 
> 
> #include "libxlog.h"
> 
> after the inclusion of libxfs.h at the top of this file, and you won't
> need this extern.  That's how the main file/function gets "x" for
> xfs_repair.  but actually, see more below.
> 
> > +
> > +
> >  /* ARGSUSED */
> >  void
> >  phase1(xfs_mount_t *mp)
> > @@ -54,6 +58,10 @@ phase1(xfs_mount_t *mp)
> >  	xfs_sb_t		*sb;
> >  	char			*ag_bp;
> >  	int			rval;
> > +	int			blocklog;
> > +	__uint64_t		agcount;
> > +	__uint64_t		agsize;
> > +	__uint64_t		skipsize;
> >  
> >  	do_log(_("Phase 1 - find and verify superblock...\n"));
> >  
> > @@ -65,6 +73,18 @@ phase1(xfs_mount_t *mp)
> >  	lost_quotas = 0;
> >  
> >  	/*
> > +	 * divine the geometry 
> > +	 */
> > +	blocklog = guess_default_geometry(&agsize, &agcount, x);
> > +
> > +	/*
> > +	 * use found ag geometry to quickly find secondary sb
> > +	 */
> > +	skipsize = agsize << blocklog;
> > +	do_log("agsize = %d  agcount = %d  skipsize = %d\n",
> > +	       (int)agsize, (int)agcount, (int)skipsize);
> 
> Since this is just a guess, I wouldn't log.  It may well
> print out geometry that is not correct, and that would be confusing.
> 
> And actually - looking at how you have refactored find_secondary_sb(),
> you can move the above 12 or so lines into find_secondary_sb(),
> and you don't need to pre-compute skipsize etc here.  You can do it
> all in find_secondary_sb() when it gets called.
> 
> Then this file (phase1.c) can be completely unchanged, and all the
> magic happens in repair/sb.c.
> 
> > +
> > +	/*
> >  	 * get AG 0 into ag header buf
> >  	 */
> >  	ag_bp = alloc_ag_buf(MAX_SECTSIZE);
> > @@ -80,14 +100,15 @@ phase1(xfs_mount_t *mp)
> >  	if (rval != XR_OK)  {
> >  		do_warn(_("bad primary superblock - %s !!!\n"),
> >  			err_string(rval));
> > -		if (!find_secondary_sb(sb))
> > +
> > +		if (!find_secondary_sb(sb, skipsize))
> >  			no_sb();
> >  		primary_sb_modified = 1;
> >  	} else if ((rval = verify_set_primary_sb(sb, 0,
> >  					&primary_sb_modified)) != XR_OK)  {
> >  		do_warn(_("couldn't verify primary superblock - %s !!!\n"),
> >  			err_string(rval));
> > -		if (!find_secondary_sb(sb))
> > +		if (!find_secondary_sb(sb, skipsize))
> >  			no_sb();
> >  		primary_sb_modified = 1;
> >  	}
> > diff --git a/repair/protos.h b/repair/protos.h
> > index 9d5a2a6..d96373e 100644
> > --- a/repair/protos.h
> > +++ b/repair/protos.h
> > @@ -31,7 +31,7 @@ int	get_sb(xfs_sb_t			*sbp,
> >  void	write_primary_sb(xfs_sb_t	*sbp,
> >  			int		size);
> >  
> > -int	find_secondary_sb(xfs_sb_t	*sb);
> > +int	find_secondary_sb(xfs_sb_t	*sb, __uint64_t skipsize);
> 
> this would be unchanged as well.
> 
> >  
> >  struct fs_geometry;
> >  void	get_sb_geometry(struct fs_geometry	*geo,
> > diff --git a/repair/sb.c b/repair/sb.c
> > index 4eef14a..4386479 100644
> > --- a/repair/sb.c/d
> > +++ b/repair/sb.c
> > @@ -87,8 +87,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
> >  /*
> >   * find a secondary superblock, copy it into the sb buffer
> 
> It'd be good to document "skipsize" here - units, and purpose.
> 
> >   */
> > -int
> > -find_secondary_sb(xfs_sb_t *rsb)
> > +static int __find_secondary_sb(xfs_sb_t *rsb, __uint64_t skipsize )
> 
> no space between skipsize and ")" please.
> 
> >  {
> >  	xfs_off_t	off;
> >  	xfs_sb_t	*sb;
> > @@ -101,7 +100,6 @@ find_secondary_sb(xfs_sb_t *rsb)
> >  	int		bsize;
> >  
> >  	do_warn(_("\nattempting to find secondary superblock...\n"));
> > -
> >  	sb = (xfs_sb_t *)memalign(libxfs_device_alignment(), BSIZE);
> >  	if (!sb) {
> >  		do_error(
> > @@ -117,7 +115,7 @@ find_secondary_sb(xfs_sb_t *rsb)
> >  	/*
> >  	 * skip first sector since we know that's bad
> >  	 */
> > -	for (done = 0, off = XFS_AG_MIN_BYTES; !done ; off += bsize)  {
> > +	for (done = 0, off = skipsize; !done ; off += bsize)  {
> 
> Ok, so you jump out "skipsize" for the first read, but after that you
> only move the offset by bsize, which is BSIZE (or 1MB).
> 
> That works OK if the 2nd superblock (at skipsize) is OK, but if it's
> not, you'll start from there doing smaller reads like before, and
> then this loop isn't really any more efficient than it was.
> 
> If skipsize is set, you need to start out 1x skipsize, then read
> at 2x skipsize, 3x skipsize, etc.  So you need to change the
> loop increment as well.
> 
> i.e. fast path: start at skipsize, advance by skipsize each loop
> 
> slow path: start at XFS_AG_MIN_BYTES, advance by BSIZE each loop
> 
> If you make a 4t sparse file, mkfs it, and corrupt the first *2*
> superblocks, then point repair at it you'll see what I mean.
> 
> >  		/*
> >  		 * read disk 1 MByte at a time.
> >  		 */
> > @@ -130,7 +128,6 @@ find_secondary_sb(xfs_sb_t *rsb)
> >  		}
> >  
> >  		do_warn(".");
> > -
> >  		/*
> >  		 * check the buffer 512 bytes at a time since
> >  		 * we don't know how big the sectors really are.
> > @@ -164,11 +161,29 @@ find_secondary_sb(xfs_sb_t *rsb)
> >  			}
> >  		}
> >  	}
> > -
> >  	free(sb);
> >  	return(retval);
> >  }
> >  
> > +int
> > +find_secondary_sb(xfs_sb_t *rsb, __uint64_t skipsize)
> > +{
> > +	int		retval;
> > +
> > +	/*
> > +	 * Attempt to find secondary sb with a coarse approach,
> > +	 * using a large skipsize (agsize in bytes). Failing that,
> > +	 * fallback to the fine-grained approach using min agsize.
> > +	 */
> > +	retval = __find_secondary_sb(rsb, skipsize);
> > +	if (!retval)
> 
> With the comment below, it's safest to wrap these multiple lines after
> the conditional in { .... }
> 
> > +		/*
> > +		 * fallback: use minimum agsize for skipsize
> > +		 */
> > +		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES);
> > +	return(retval);
> 
> again drop the () on the return, please.
> 
> > +}
> > +
> >  /*
> >   * Calculate what the inode alignment field ought to be based on internal
> >   * superblock info and determine if it is valid.
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

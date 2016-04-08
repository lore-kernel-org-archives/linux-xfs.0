Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E7F57CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:25:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BA4CAC006
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:25:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1u4aMj9GA6BHGZm3 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 17:25:34 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C76F8481A
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:25:32 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706FA7C.7020103@sandeen.net>
Date: Thu, 7 Apr 2016 19:25:32 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-16-git-send-email-jtulak@redhat.com>
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



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CHANGELOG
> o Fix where xi.dname was incorrectly used instead of dfile
> o Variable alignment (tabs)
> o Added error handling for stat/statfs in init.c
> o Remove a duplicate pread in zero_old_xfs_structures and for the
> remaining call, save the return value in a more meaningful variable.
> o A chunk moved to previous patch.
> 
> If the device is actually a file, and "-d file" is not specified,
> mkfs will try to treat it as a block device and get stuff wrong.
> Image files don't necessarily have the same sector sizes as the
> block device or filesystem underlying the image file, nor should we
> be issuing discard ioctls on image files.
> 
> To fix this sanely, only require "-d file" if the device name is
> invalid to trigger creation of the file. Otherwise, use stat() to
> determine if the device is a file or block device and deal with that
> appropriately by setting the "isfile" variables and turning off
> direct IO. Then ensure that we check the "isfile" options before
> doing things that are specific to block devices.  Also, as direct IO
> is disabled for files, use statfs() for getting host FS blocksize,
> not platform_findsizes().
> 
> These changes, however, can cause some tests to fail when the test
> partition on which the file is created has blocksize bigger than 512.
> Before, the underlying fs was ignored. Now, an attempt to create
> a fs in a file with blocksize 512 on a 4096 underlying partition will
> fail.
> 
> Other file/blockdev issues fixed:
> 	- use getstr to detect specifying the data device name
> 	  twice.
> 	- check file/size/name parameters before anything else.
> 	- overwrite checks need to be done before the image file is
> 	  opened and potentially truncated.
> 	- blkid_get_topology() should not be called for image files,
> 	  so warn when it is called that way.
> 	- zero_old_xfs_structures() emits a spurious error:
> 		"existing superblock read failed: Success"
> 	  when it is run on a truncated image file. Don't warn if we
> 	  see this problem on an image file.
> 	- Don't issue discards on image files.
> 	- Use fsync() for image files, not BLKFLSBUF in
> 	  platform_flush_device() for Linux.

This one causes at least one interesting issue:

#mkfs/mkfs.xfs
Error accessing specified device (null): Bad address
Usage: mkfs.xfs
...

because:

        check_device_type(dfile, &xi.disfile, !dsize, !dfile,
                          Nflag ? NULL : &xi.dcreat, force_overwrite, "d");

so "dfile" can be NULL, but that function immediately tries to stat it.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  libxfs/init.c   |  12 ++++
>  libxfs/linux.c  |  12 +++-
>  mkfs/xfs_mkfs.c | 181 ++++++++++++++++++++++++++++++++++++++------------------
>  3 files changed, 147 insertions(+), 58 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 8d747e8..268136f 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -246,6 +246,9 @@ libxfs_init(libxfs_init_t *a)
>  	char		rtpath[25];
>  	int		rval = 0;
>  	int		flags;
> +	struct		stat st;
> +	struct		statfs stfs;
> +	int		statres;
>  
>  	dpath[0] = logpath[0] = rtpath[0] = '\0';
>  	dname = a->dname;
> @@ -278,6 +281,15 @@ libxfs_init(libxfs_init_t *a)
>  			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
>  						    a->setblksize);
>  			a->dfd = libxfs_device_to_fd(a->ddev);
> +			statres = stat(dname, &st);
> +			statres += statfs(dname, &stfs);
> +			if(statres){
			  ^space   ^space
> +				fprintf(stderr, _("%s: stat failed.\n"),
> +					progname);
> +				goto done;
> +			}
> +			a->dsize = st.st_size/BBSIZE;
> +			a->dbsize = stfs.f_bsize;

ok so for a file you choose ->dsize to be file size in 512-sector units,
and ->dbsize to be the fs block size.

This is all under if (a->disfile); if we didn't actually specify "-dfile"
but it *is* a file, then we get to platform_findsizes() - which handles
files.  And handles them differently.   Hm but you removed that (see below)
and added more stat() calls...?

What is the reason for adding these stats at this point?

(and if there's a reason, why only for ->disfile but not ->lisfile?)

>  		} else {
>  			if (!check_open(dname, flags, &rawfile, &blockfile))
>  				goto done;
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index f6ea1b2..adb8ff1 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -18,6 +18,7 @@
>  
>  #define ustat __kernel_ustat
>  #include <mntent.h>
> +#include <sys/vfs.h>
>  #include <sys/stat.h>
>  #undef ustat
>  #include <sys/ustat.h>
> @@ -125,7 +126,16 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
>  void
>  platform_flush_device(int fd, dev_t device)
>  {
> -	if (major(device) != RAMDISK_MAJOR)
> +	struct stat64	st;
> +	if (major(device) == RAMDISK_MAJOR)
> +		return;
> +
> +	if (fstat64(fd, &st) < 0)
> +		return;
> +
> +	if (S_ISREG(st.st_mode))
> +		fsync(fd);
> +	else
>  		ioctl(fd, BLKFLSBUF, 0);
>  }
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9261ed5..7bd9fd5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -787,7 +787,7 @@ calc_stripe_factors(
>  #ifdef ENABLE_BLKID
>  static int
>  check_overwrite(
> -	char		*device)
> +	const char	*device)
>  {
>  	const char	*type;
>  	blkid_probe	pr = NULL;
> @@ -804,7 +804,7 @@ check_overwrite(
>  	fd = open(device, O_RDONLY);
>  	if (fd < 0)
>  		goto out;
> -	platform_findsizes(device, fd, &size, &bsz);
> +	platform_findsizes((char *)device, fd, &size, &bsz);
>  	close(fd);
>  
>  	/* nothing to overwrite on a 0-length device */
> @@ -851,7 +851,6 @@ check_overwrite(
>  			"according to blkid\n"), progname, device);
>  	}
>  	ret = 1;
> -
>  out:
>  	if (pr)
>  		blkid_free_probe(pr);
> @@ -877,8 +876,12 @@ static void blkid_get_topology(
>  	struct stat statbuf;
>  
>  	/* can't get topology info from a file */
> -	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
> +	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> +		fprintf(stderr,
> +	_("%s: Warning: trying to probe topology of a file %s!\n"),
> +			progname, device);
>  		return;
> +	}
>  
>  	pr = blkid_new_probe_from_filename(device);
>  	if (!pr)
> @@ -976,35 +979,35 @@ static void get_topology(
>  	struct fs_topology	*ft,
>  	int			force_overwrite)
>  {
> -	struct stat statbuf;
>  	char *dfile = xi->volname ? xi->volname : xi->dname;
> +	struct stat statbuf;
> +	struct statfs statfsbuf;
>  
>  	/*
> -	 * If our target is a regular file, use platform_findsizes
> -	 * to try to obtain the underlying filesystem's requirements
> -	 * for direct IO; we'll set our sector size to that if possible.
> +	 * If our target is a regular file, use statfs
> +	 * to try to obtain the underlying filesystem's blocksize.
>  	 */
>  	if (xi->disfile ||
> -	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
> +		(!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {

dave pointed out that this indentation "fix" is incorrect, the line is fine as
it is; it's part of the same conditional; it shouldn't be tabbed into the code
block under the conditional.

>  		int fd;
>  		int flags = O_RDONLY;
> -		long long dummy;
>  
>  		/* with xi->disfile we may not have the file yet! */
>  		if (xi->disfile)
>  			flags |= O_CREAT;
>  
>  		fd = open(dfile, flags, 0666);
> +
>  		if (fd >= 0) {
> -			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
> +			fstatfs(fd, &statfsbuf);

no error checking on fstatfs, but...

> +			ft->lsectorsize = statfsbuf.f_bsize;

Ok, platform_findsizes already explicitly handled regular files, and tries to
find out via an xfs ioctl what the minimum DIO size is, and uses that for 
the sector size for the filesystem in the iamge.

Now you stat & get the blocksize, and use that instead, but it's likely
to be different:

i.e. before:

# mkfs/mkfs.xfs -f fsfile
meta-data=fsfile                 isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1

after:

# mkfs/mkfs.xfs -f fsfile
meta-data=fsfile                 isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=4096  attr=2, projid32bit=1

and also, now:

# mkfs/mkfs.xfs -f -dfile,name=fsfile,size=1g -b size=2048
block size 2048 cannot be smaller than logical sector size 4096

What prompted you to make this change, was there some other problem you
needed to fix?

>  			close(fd);
> -			ft->psectorsize = ft->lsectorsize;

hm, now psectorsize isn't set at all?

>  		} else
>  			ft->psectorsize = ft->lsectorsize = BBSIZE;
>  	} else {
>  		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> -				   &ft->lsectorsize, &ft->psectorsize,
> -				   force_overwrite);
> +					&ft->lsectorsize, &ft->psectorsize,
> +					force_overwrite);

please don't change these lines, they line up w/ the function opening paren as
they should.

>  	}
>  
>  	if (xi->rtname && !xi->risfile) {
> @@ -1016,6 +1019,75 @@ static void get_topology(
>  }
>  
>  static void
> +check_device_type(
> +	const char	*name,
> +	int		*isfile,
> +	bool		no_size,
> +	bool		no_name,
> +	int		*create,
> +	bool		force_overwrite,
> +	const char	*optname)
> +{
> +	struct stat64 statbuf;
> +
> +	if (*isfile && (no_size || no_name)) {
> +		fprintf(stderr,
> +	_("if -%s file then -%s name and -%s size are required\n"),
> +			optname, optname, optname);
> +		usage();
> +	}
> +
> +	if (stat64(name, &statbuf)) {
> +		if (errno == ENOENT && *isfile) {
> +			if (create)
> +				*create = 1;
> +			return;
> +		}
> +
> +		fprintf(stderr,
> +	_("Error accessing specified device %s: %s\n"),
> +				name, strerror(errno));
> +		usage();
> +		return;
> +	}
> +
> +	if (!force_overwrite && check_overwrite(name)) {
> +		fprintf(stderr,
> +	_("%s: Use the -f option to force overwrite.\n"),
> +			progname);
> +		exit(1);
> +	}
> +
> +	/*
> +	 * We only want to completely truncate and recreate an existing file if
> +	 * we were specifically told it was a file. Set the create flag only in
> +	 * this case to trigger that behaviour.
> +	 */
> +	if (S_ISREG(statbuf.st_mode)) {
> +		if (!*isfile)
> +			*isfile = 1;
> +		else if (create)
> +			*create = 1;
> +		return;
> +	}
> +
> +	if (S_ISBLK(statbuf.st_mode)) {
> +		if (*isfile) {
> +			fprintf(stderr,
> +	_("specified \"-%s file\" on a block device %s\n"),
> +				optname, name);
> +			usage();
> +		}
> +		return;
> +	}
> +
> +	fprintf(stderr,
> +	_("specified device %s not a file or block device\n"),
> +		name);
> +	usage();
> +}
> +
> +static void
>  fixup_log_stripe_unit(
>  	int		lsflag,
>  	int		sunit,
> @@ -1279,7 +1351,6 @@ zero_old_xfs_structures(
>  	__uint32_t		bsize;
>  	int			i;
>  	xfs_off_t		off;
> -	int			tmp;
>  
>  	/*
>  	 * We open regular files with O_TRUNC|O_CREAT. Nothing to do here...
> @@ -1299,15 +1370,23 @@ zero_old_xfs_structures(
>  	}
>  	memset(buf, 0, new_sb->sb_sectsize);
>  
> -	tmp = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> -	if (tmp < 0) {
> +	off = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> +	if (off < 0) {
>  		fprintf(stderr, _("existing superblock read failed: %s\n"),
>  			strerror(errno));
>  		goto done;
>  	}
> -	if (tmp != new_sb->sb_sectsize) {
> -		fprintf(stderr,
> -	_("warning: could not read existing superblock, skip zeroing\n"));
> +	/*
> +	 * If we are creating an image file, it might be of zero length at this
> +	 * point in time. Hence reading the existing superblock is going to
> +	 * return zero bytes. It's not a failure we need to warn about in this
> +	 * case.
> +	 */

except you already did "if (off < 0) fail" above this.

Ok, at this point I think it might be best to revert to Dave's original version.

If there were specific problems you were trying to address, can you point them out?

Thanks,
-Eric

> +	if (off != new_sb->sb_sectsize) {
> +		if (!xi->disfile)
> +			fprintf(stderr,
> +	_("error reading existing superblock: %s\n"),
> +				strerror(errno));
>  		goto done;
>  	}
>  	libxfs_sb_from_disk(&sb, buf);
> @@ -1787,8 +1866,6 @@ main(
>  				case D_FILE:
>  					xi.disfile = getnum(value, &dopts,
>  							    D_FILE);
> -					if (xi.disfile && !Nflag)
> -						xi.dcreat = 1;
>  					break;
>  				case D_NAME:
>  					xi.dname = getstr(value, &dopts, D_NAME);
> @@ -1914,11 +1991,6 @@ main(
>  				case L_FILE:
>  					xi.lisfile = getnum(value, &lopts,
>  							    L_FILE);
> -					if (xi.lisfile && loginternal)
> -						conflict('l', subopts, L_INTERNAL,
> -							 L_FILE);
> -					if (xi.lisfile)
> -						xi.lcreat = 1;
>  					break;
>  				case L_INTERNAL:
>  					loginternal = getnum(value, &lopts,
> @@ -2087,8 +2159,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				case R_FILE:
>  					xi.risfile = getnum(value, &ropts,
>  							    R_FILE);
> -					if (xi.risfile)
> -						xi.rcreat = 1;
>  					break;
>  				case R_NAME:
>  				case R_DEV:
> @@ -2193,6 +2263,26 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  		lsectorsize = sectorsize;
>  	}
>  
> +	/*
> +	 * Before anything else, verify that we are correctly operating on
> +	 * files or block devices and set the control parameters correctly.
> +	 * Explicitly disable direct IO for image files so we don't error out on
> +	 * sector size mismatches between the new filesystem and the underlying
> +	 * host filesystem.
> +	 */
> +	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
> +			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
> +	if (!loginternal)
> +		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
> +				  Nflag ? NULL : &xi.lcreat,
> +				  force_overwrite, "l");
> +	if (xi.rtname)
> +		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
> +				  Nflag ? NULL : &xi.rcreat,
> +				  force_overwrite, "r");
> +	if (xi.disfile || xi.lisfile || xi.risfile)
> +		xi.isdirect = 0;
> +
>  	memset(&ft, 0, sizeof(ft));
>  	get_topology(&xi, &ft, force_overwrite);
>  
> @@ -2345,11 +2435,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  	}
>  
>  
> -	if (xi.disfile && (!dsize || !xi.dname)) {
> -		fprintf(stderr,
> -	_("if -d file then -d name and -d size are required\n"));
> -		usage();
> -	}
>  	if (dsize) {
>  		__uint64_t dbytes;
>  
> @@ -2382,11 +2467,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  		usage();
>  	}
>  
> -	if (xi.lisfile && (!logsize || !xi.logname)) {
> -		fprintf(stderr,
> -		_("if -l file then -l name and -l size are required\n"));
> -		usage();
> -	}
>  	if (logsize) {
>  		__uint64_t logbytes;
>  
> @@ -2404,11 +2484,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  				(long long)logbytes, blocksize,
>  				(long long)(logblocks << blocklog));
>  	}
> -	if (xi.risfile && (!rtsize || !xi.rtname)) {
> -		fprintf(stderr,
> -		_("if -r file then -r name and -r size are required\n"));
> -		usage();
> -	}
>  	if (rtsize) {
>  		__uint64_t rtbytes;
>  
> @@ -2530,22 +2605,14 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  	xi.rtsize &= sector_mask;
>  	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
>  
> -	if (!force_overwrite) {
> -		if (check_overwrite(dfile) ||
> -		    check_overwrite(logfile) ||
> -		    check_overwrite(xi.rtname)) {
> -			fprintf(stderr,
> -			_("%s: Use the -f option to force overwrite.\n"),
> -				progname);
> -			exit(1);
> -		}
> -	}
>  
> +	/* don't do discards on print-only runs or on files */
>  	if (discard && !Nflag) {
> -		discard_blocks(xi.ddev, xi.dsize);
> -		if (xi.rtdev)
> +		if (!xi.disfile)
> +			discard_blocks(xi.ddev, xi.dsize);
> +		if (xi.rtdev && !xi.risfile)
>  			discard_blocks(xi.rtdev, xi.rtsize);
> -		if (xi.logdev && xi.logdev != xi.ddev)
> +		if (xi.logdev && xi.logdev != xi.ddev && !xi.lisfile)
>  			discard_blocks(xi.logdev, xi.logBBsize);
>  	}
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

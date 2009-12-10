Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBAMe2fr121474 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 16:40:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E51F0EAC66
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:40:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DZJTWswZIPW0vJjb for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:40:38 -0800 (PST)
Date: Thu, 10 Dec 2009 17:40:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: handle 4k sector devices more cleanly
Message-ID: <20091210224037.GA28342@infradead.org>
References: <4B1E9A25.50108@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B1E9A25.50108@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 08, 2009 at 12:25:41PM -0600, Eric Sandeen wrote:
> Trying to mkfs a 4k sector device today fails w/o manually specifying
> sector size:
> 
> # modprobe scsi_debug sector_size=4096 dev_size_mb=32
> # mkfs.xfs -f /dev/sdc
> mkfs.xfs: warning - cannot set blocksize on block device /dev/sdc: Invalid argument
> Warning: the data subvolume sector size 512 is less than the sector size 
> reported by the device (4096).
> ... <fail>
> 
> add sectorsize to the device topology info, and use that if present.
> 
> Also check that explicitly requested sector sizes are not smaller
> than the hardware size.  This already fails today, but with the more
> cryptic "cannot set blocksize" ioctl error above.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index bc49903..2e07d54 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -112,9 +112,9 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
>  	if (major(device) != RAMDISK_MAJOR) {
>  		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
>  			fprintf(stderr, _("%s: %s - cannot set blocksize "
> -					"on block device %s: %s\n"),
> +					"%d on block device %s: %s\n"),
>  				progname, fatal ? "error": "warning",
> -				path, strerror(errno));
> +				blocksize, path, strerror(errno));

Defintively a more useful error message than before, thanks.

> -static void blkid_get_topology(const char *device, int *sunit, int *swidth)
> +static void blkid_get_topology(const char *device, int *sunit, int *swidth, int *sectorsize)
>  {
>  	blkid_topology tp;
>  	blkid_probe pr;
> @@ -348,7 +349,9 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth)
>  	val = blkid_topology_get_optimal_io_size(tp) >> 9;
>  	if (val > 1)
>  		*swidth = val;
> -
> +	val = blkid_probe_get_sectorsize(pr);
> +	if (val > 1)
> +		*sectorsize = val;

I don't think the val > 1 check here makes any sense.

> +		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth, &ft->sectorsize);

The lines is growing a bit too long here..


Also I think you should add the sector size retrival by using the ioctl
directly for the non-blkid case to make sure the code doesn't have too
many corner cases.

> -	if (ft.sectoralign) {
> -		sectorsize = blocksize;
> +	/*
> +	 * MD wants sector size set == block size to avoid switching.
> +	 * Otherwise, if not specfied via command, use device sectorsize
> +	 */
> +	if (ft.sectoralign || !ssflag) {
> +		if (ft.sectoralign)
> +			sectorsize = blocksize;
> +		else
> +			sectorsize = ft.sectorsize;

The code looks good, but I don't think the comment helps understanding
what's going on.  And I might get a bit pendantic here, but changing it
to

	if (!ssflag || ft.sectoralign)

might make the intent a bit more clear.


> +	if (sectorsize < ft.sectorsize) {
> +		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
> +			sectorsize, ft.sectorsize);
> +		usage();
> +	}

Looks good.

>  	if (lsectorsize < XFS_MIN_SECTORSIZE ||
>  	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
>  		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
> @@ -1749,10 +1764,10 @@ main(
>  	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
>  				&dsunit, &dswidth, &lsunit);
>  
> -	if (slflag || ssflag)
> +	if (slflag || ssflag || ft.setorsize)

There's a c missing here, this wouldn't even compile :)

It will also be always true for blkid builds which is at least a bit
confusing.  If you also updated the libdisk case as suggested above we
could also get rid of the xi.setblksize = 1 special case totally and
always pass the proper block size to libxfs_init and libxfs_device_open
(and make libxfs_device_open static in libxfs/init.c while we're at it
:))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BFkk7C254262 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 10:46:46 -0500
Subject: Re: [PATCH] repair: handle repair of image files on large sector
	size filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312772354-9059-1-git-send-email-david@fromorbit.com>
References: <1312772354-9059-1-git-send-email-david@fromorbit.com>
Date: Thu, 11 Aug 2011 10:46:42 -0500
Message-ID: <1313077602.2899.29.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-08-08 at 12:59 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because repair uses direct IO, it cannot do IO smaller than a sector
> on the underlying device. When repairing a filesystem image, the
> filesystem hosting the image may have a sector size larger than the
> sector size of the image, and so single image sector reads and
> writes will fail.
> 
> To avoid this, when checking a file and there is a sector size
> mismatch like this, turn off direct IO. While there, fix a compile
> bug in the IO_DEBUG option for libxfs which was found during triage.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, but I have a few pretty minor things I think
you should consider fixing before you commit.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> diff --git a/repair/sb.c b/repair/sb.c
> index 0ee2345..c8df076 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -689,7 +689,14 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  	 */
>  	num_sbs = MIN(NUM_SBS, rsb->sb_agcount);
>  	skip = howmany(num_sbs, rsb->sb_agcount);
> -	size = NUM_AGH_SECTS * rsb->sb_sectsize;
> +
> +	/*
> +	 * We haven't been able to validate the sector size yet properly
> +	 * (e.g. in the case of repairing an image in a file), so we need to
> +	 * take into account sector mismatches and so use the maximum possible
> +	 * sector size rather than that in @rsb.

How about "rather than the sector size in @rsb".

What you have is OK, but my parser had to backtrack
to be sure I knew what "that" was referring to.

> +	 */
> +	size = NUM_AGH_SECTS * (1 << (XFS_MAX_SECTORSIZE_LOG));
>  	retval = 0;
>  	list = NULL;
>  	num_ok = 0;
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 4707b83..dda9daa 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -569,6 +569,36 @@ main(int argc, char **argv)
>  	memset(&xfs_m, 0, sizeof(xfs_mount_t));
>  	libxfs_sb_from_disk(&xfs_m.m_sb, XFS_BUF_TO_SBP(sbp));
>  
> +	/*
> +	 * if the sector size of the filesystem we are trying to repair is
> +	 * smaller than that of the underlying filesystem (i.e. we are repairing
> +	 * an image), the we have to turn off direct IO because we cannot do IO
> +	 * smaller than the host filesystem's sector size.
> +	 */
> +	if (isa_file) {
> +		int     fd = libxfs_device_to_fd(x.ddev);
> +		struct xfs_fsop_geom_v1 geom = {
> +			.sectsize = BBSIZE,

Why do you fill in sectsize here?  I don't know that
you're guaranteed it will still be intact if the ioctl()
below fails.  If that's your reason I'd prefer to see it
filled in after the do_warn() call.

> +		};
> +
> +		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> +			do_warn(_("Cannot get host fiesystem geometry.\n"
                                                    filesystem
> +		"Repair may fail if there is a sector size mismatch between "
                     Put a newline at the end of this line too...
> +		"the image and the host filesystem.\n"));
                     ...otherwise the combination is a pretty long line.
> +		}
> +
> +		if (xfs_m.m_sb.sb_sectsize < geom.sectsize) {
> +			long	old_flags;
> +
> +			old_flags = fcntl(fd, F_GETFL, 0);

Maybe don't bother turning off direct I/O if it's not
already set in old_flags.

> +			if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
> +				do_warn(_(
> +		"Sector size on host filesystem larger than image sector size.\n"
> +		"Cannot turn off direct IO, so exiting.\n"));
> +				exit(1);
> +			}
> +		}
> +	}
>  	mp = libxfs_mount(&xfs_m, &xfs_m.m_sb, x.ddev, x.logdev, x.rtdev, 0);
>  
>  	if (!mp)  {



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

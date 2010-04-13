Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D53f7d194354 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 00:03:41 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C6731AD9894
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 22:05:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	TSYovAQ84C2o6L8f for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 22:05:34 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	20404982-1927428
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 14:35:33 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1O1YJX-0003Ym-O8
	for xfs@oss.sgi.com; Tue, 13 Apr 2010 15:05:31 +1000
Date: Tue, 13 Apr 2010 15:05:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_fsr: Improve handling of attribute forks V2
Message-ID: <20100413050531.GS2493@dastard>
References: <1270545579-24835-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270545579-24835-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

ping?

On Tue, Apr 06, 2010 at 07:19:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the file being defragmented has attributes, then fsr puts a dummy
> attribute on the temporary file to try to ensure that the inode
> attribute fork offset is set correctly. This works perfectly well
> for the old style of attributes that use a fixed fork offset - the
> presence of any attribute of any size or shape will result in fsr
> doing the correct thing.
> 
> However, for attr2 filesystems, the attribute fork offset is
> dependent on the size and shape of both the data and attribute
> forks. Hence setting a small attribute on the file does not
> guarantee that the two inodes have the same fork offset and
> therefore compatible for a data fork swap.
> 
> This patch improves the attribute fork handling of fsr. It checks
> the filesystem version to see if the old style attributes are in
> use, and if so uses the current method.
> 
> If attr2 is in use, fsr uses bulkstat output to determine what the
> fork offset is. If the attribute fork offsets differ then fsr will
> try to create attributes that will result in the correct offset. If
> that fails, or the attribute fork is too large, it will give up and just
> attempt the swap.
> 
> This fork offset value in bulkstat new functionality in the kernel,
> so if there are attributes and a zero fork offset, then the kernel
> does not support this feature and we simply fall back to the existing,
> less effective code.
> 
> Version 2:
> - simplify the attribute creation to use a small fixed size attribute
> - handle the fork offset not changing as attributes are added - it can take a
>   few attributes to move it from one offset to another
> - comment the code better
> - passes test 226 and reduces the number of unswappable inode pairs passed to
>   the (fixed) kernel to zero
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fsr/xfs_fsr.c    |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  include/xfs_fs.h |    3 +-
>  2 files changed, 152 insertions(+), 9 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 1f933c7..5619676 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -17,8 +17,13 @@
>   */
>  
>  #include <xfs/xfs.h>
> +#include <libxfs.h>
> +#include <xfs/xfs_types.h>
>  #include <xfs/jdm.h>
>  #include <xfs/xfs_dfrag.h>
> +#include <xfs/xfs_bmap_btree.h>
> +#include <xfs/xfs_dinode.h>
> +#include <xfs/xfs_attr_sf.h>
>  
>  #include <fcntl.h>
>  #include <errno.h>
> @@ -946,6 +951,147 @@ fsrfile_common(
>  	return -1; /* no error */
>  }
>  
> +/*
> + * Attempt to set the attr fork up correctly. This is simple for attr1
> + * filesystems as they have a fixed inode fork offset. In that case
> + * just create an attribute and that's all we need to do.
> + *
> + * For attr2 filesystems, see if we have the actual fork offset in
> + * the bstat structure. If so, just create additional attributes on
> + * the temporary inode until the offset matches.
> + *
> + * If it doesn't exist, we can only do best effort. Add an attribute at a time
> + * to move the inode fork around, but take into account that the attribute
> + * might be too small to move the fork every time we add one.  This should
> + * hopefully put the fork offset in the right place. It's not a big deal if we
> + * don't get it right - the kernel will reject it when we try to swap extents.
> + */
> +static int
> +fsr_setup_attr_fork(
> +	int		fd,
> +	int		tfd,
> +	xfs_bstat_t	*bstatp)
> +{
> +	struct stat64	tstatbuf;
> +	int		i;
> +	int		last_forkoff = 0;
> +	int		no_change_cnt = 0;
> +	int		ret;
> +
> +	if (!(bstatp->bs_xflags & XFS_XFLAG_HASATTR))
> +		return 0;
> +
> +	/*
> +	 * use the old method if we have attr1 or the kernel does not yet
> +	 * support passing the fork offset in the bulkstat data.
> +	 */
> +	if (!(fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ATTR2) ||
> +	    bstatp->bs_forkoff == 0) {
> +		/* attr1 */
> +		ret = fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE);
> +		if (ret) {
> +			fsrprintf(_("could not set ATTR\n"));
> +			return -1;
> +		}
> +		goto out;
> +	}
> +
> +	/* attr2 w/ fork offsets */
> +
> +	if (fstat64(tfd, &tstatbuf) < 0) {
> +		fsrprintf(_("unable to stat temp file: %s\n"),
> +					strerror(errno));
> +		return -1;
> +	}
> +
> +	i = 0;
> +	do {
> +		xfs_bstat_t	tbstat;
> +		xfs_ino_t	ino;
> +		char		name[64];
> +		int		diff;
> +
> +		/*
> +		 * bulkstat the temp inode  to see what the forkoff is. Use
> +		 * this to compare against the target and determine what we
> +		 * need to do.
> +		 */
> +		ino = tstatbuf.st_ino;
> +		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
> +			fsrprintf(_("unable to get bstat on temp file: %s\n"),
> +						strerror(errno));
> +			return -1;
> +		}
> +		if (dflag)
> +			fsrprintf(_("orig forkoff %d, temp forkoff %d\n"),
> +					bstatp->bs_forkoff, tbstat.bs_forkoff);
> +
> +		snprintf(name, sizeof(name), "user.%d", i);
> +
> +		/*
> +		 * If there is no attribute, then we need to create one to get
> +		 * an attribute fork at the default location.
> +		 */
> +		if (!tbstat.bs_forkoff) {
> +			ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
> +			if (ret) {
> +				fsrprintf(_("could not set ATTR\n"));
> +				return -1;
> +			}
> +			continue;
> +		}
> +
> +		/*
> +		 * make a progress check so we don't get stuck trying to extend
> +		 * a large btree form attribute fork.
> +		 */
> +		if (last_forkoff == tbstat.bs_forkoff) {
> +			if (no_change_cnt++ > 10)
> +				break;
> +		}
> +		no_change_cnt = 0;
> +		last_forkoff = tbstat.bs_forkoff;
> +
> +		/* work out which way to grow the fork */
> +		diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
> +		if (abs(diff) > fsgeom.inodesize - sizeof(struct xfs_dinode)) {
> +			fsrprintf(_("forkoff diff %d too large!\n"), diff);
> +			return -1;
> +		}
> +
> +		/* if they are equal, we are done */
> +		if (!diff)
> +			goto out;
> +
> +		/*
> +		 * if the temp inode fork offset is smaller then we have to
> +		 * grow the data fork
> +		 */
> +		if (diff < 0) {
> +			/*
> +			 * create some temporary extents in the inode to move
> +			 * the fork in the direction we need. This can be done
> +			 * by preallocating some single block extents at
> +			 * non-contiguous offsets.
> +			 */
> +			/* XXX: unimplemented! */
> +			goto out;
> +		}
> +
> +		/* we need to grow the attr fork, so create another attr */
> +		ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
> +		if (ret) {
> +			fsrprintf(_("could not set ATTR\n"));
> +			return -1;
> +		}
> +
> +	} while (++i < 100); /* don't go forever */
> +
> +out:
> +	if (dflag)
> +		fsrprintf(_("set temp attr\n"));
> +	return 0;
> +}
>  
>  /*
>   * Do the defragmentation of a single file.
> @@ -1000,14 +1146,10 @@ packfile(char *fname, char *tname, int fd,
>  	unlink(tname);
>  
>  	/* Setup extended attributes */
> -	if (statp->bs_xflags & XFS_XFLAG_HASATTR) {
> -		if (fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE) != 0) {
> -			fsrprintf(_("could not set ATTR on tmp: %s:\n"), tname);
> -			close(tfd);
> -			return -1;
> -		}
> -		if (dflag)
> -			fsrprintf(_("%s set temp attr\n"), tname);
> +	if (fsr_setup_attr_fork(fd, tfd, statp) != 0) {
> +		fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);
> +		close(tfd);
> +		return -1;
>  	}
>  
>  	/* Setup extended inode flags, project identifier, etc */
> diff --git a/include/xfs_fs.h b/include/xfs_fs.h
> index 9aff7bb..2376abb 100644
> --- a/include/xfs_fs.h
> +++ b/include/xfs_fs.h
> @@ -300,7 +300,8 @@ typedef struct xfs_bstat {
>  	__s32		bs_extents;	/* number of extents		*/
>  	__u32		bs_gen;		/* generation count		*/
>  	__u16		bs_projid;	/* project id			*/
> -	unsigned char	bs_pad[14];	/* pad space, unused		*/
> +	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
> +	unsigned char	bs_pad[12];	/* pad space, unused		*/
>  	__u32		bs_dmevmask;	/* DMIG event mask		*/
>  	__u16		bs_dmstate;	/* DMIG state info		*/
>  	__u16		bs_aextents;	/* attribute number of extents	*/
> -- 
> 1.6.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

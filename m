Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFD727F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 06:36:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5074304053
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 04:36:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0yIA2QJExHC1aoog (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 May 2015 04:36:18 -0700 (PDT)
Date: Wed, 6 May 2015 07:36:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mkfs: inode/block size error messages confusing
Message-ID: <20150506113615.GA5021@laptop.bfoster>
References: <1430711548-26441-1-git-send-email-david@fromorbit.com>
	<20150505142816.GC43235@bfoster.bfoster>
	<20150505224846.GI21261@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150505224846.GI21261@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, May 06, 2015 at 08:48:46AM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> As reported by Brain:
> 
> # ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512
> illegal inode size 512
> allowable inode size with 512 byte blocks is 256
> # ./mkfs/mkfs.xfs -f /dev/test/scratch -b size=512 -i size=256
> Minimum inode size for CRCs is 512 bytes
> Usage: mkfs.xfs
> ...
> 
> Fix mkfs to catch the block size as being too small, rather than
> leaving it for inode size detection to enforce.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/xfs_types.h | 3 +++
>  mkfs/xfs_mkfs.c     | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/xfs_types.h b/include/xfs_types.h
> index 65c6e66..accb95d 100644
> --- a/include/xfs_types.h
> +++ b/include/xfs_types.h
> @@ -100,11 +100,14 @@ typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
>   * Minimum and maximum blocksize and sectorsize.
>   * The blocksize upper limit is pretty much arbitrary.
>   * The sectorsize upper limit is due to sizeof(sb_sectsize).
> + * CRC enable filesystems use 512 byte inodes, meaning 512 byte block sizes
> + * cannot be used.
>   */
>  #define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
>  #define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
>  #define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
>  #define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
> +#define XFS_MIN_CRC_BLOCKSIZE	(1 << (XFS_MIN_BLOCKSIZE_LOG + 1))
>  #define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
>  #define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
>  #define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0218491..e2a052d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1758,6 +1758,12 @@ _("cannot specify both crc and ftype\n"));
>  		fprintf(stderr, _("illegal block size %d\n"), blocksize);
>  		usage();
>  	}
> +	if (crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> +		fprintf(stderr,
> +_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
> +			XFS_MIN_CRC_BLOCKSIZE);
> +		usage();
> +	}

I'd move this down by the crc inode size check a page or so down since
we already have a crcs_enabled block there (the error messages could
also be made more uniform I suppose). Otherwise looks good, thanks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	memset(&ft, 0, sizeof(ft));
>  	get_topology(&xi, &ft, force_overwrite);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

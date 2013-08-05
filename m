Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A843D7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 15:43:19 -0500 (CDT)
Date: Mon, 5 Aug 2013 15:43:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 40/48] xfsprogs: support CRC enabled filesystem detection
Message-ID: <20130805204319.GP3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-41-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-41-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:03AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the XFS_FSOP_GEOM_FLAGS_V5SB flag to the XFS_IOC_FSGEOMETRY
> ioctl to allow utilities like xfs_info to detect that the filesystem
> is CRC enabled.
> 
> While touching xfs_info, add projid32bit output as well.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  growfs/xfs_growfs.c |   16 ++++++++++++----
>  include/xfs_fs.h    |    1 +
>  mkfs/xfs_mkfs.c     |    2 +-
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 5d544da..cad2b7f 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -53,11 +53,14 @@ report_info(
>  	int		dirversion,
>  	int		logversion,
>  	int		attrversion,
> +	int		projid32bit,
> +	int		crcs_enabled,
>  	int		cimode)
>  {
>  	printf(_(
>  	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
> -	    "         =%-22s sectsz=%-5u attr=%u\n"
> +	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> +	    "         =%-22s crc=%u\n"
>  	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  	    "         =%-22s sunit=%-6u swidth=%u blks\n"
>  	    "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
> @@ -66,7 +69,8 @@ report_info(
>  	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
>  
>  		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
> -		"", geo.sectsize, attrversion,
> +		"", geo.sectsize, attrversion, projid32bit,
> +		"", crcs_enabled,
>  		"", geo.blocksize, (unsigned long long)geo.datablocks,
>  			geo.imaxpct,
>  		"", geo.sunit, geo.swidth,
> @@ -115,6 +119,8 @@ main(int argc, char **argv)
>  	char			*rtdev;	/*   RT device name */
>  	fs_path_t		*fs;	/* mount point information */
>  	libxfs_init_t		xi;	/* libxfs structure */
> +	int			projid32bit;
> +	int			crcs_enabled;
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -234,10 +240,12 @@ main(int argc, char **argv)
>  	attrversion = geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
>  			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
>  	ci = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
> +	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
> +	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
>  	if (nflag) {
>  		report_info(geo, datadev, isint, logdev, rtdev,
>  				lazycount, dirversion, logversion,
> -				attrversion, ci);
> +				attrversion, projid32bit, crcs_enabled, ci);
>  		exit(0);
>  	}
>  
> @@ -274,7 +282,7 @@ main(int argc, char **argv)
>  
>  	report_info(geo, datadev, isint, logdev, rtdev,
>  			lazycount, dirversion, logversion,
> -			attrversion, ci);
> +			attrversion, projid32bit, crcs_enabled, ci);
>  
>  	ddsize = xi.dsize;
>  	dlsize = ( xi.logBBsize? xi.logBBsize :
> diff --git a/include/xfs_fs.h b/include/xfs_fs.h
> index 1cc1aa0..44b69e7 100644
> --- a/include/xfs_fs.h
> +++ b/include/xfs_fs.h
> @@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
>  #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
> +#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
>  
>  
>  /*
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9987dde..bb5d8d4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2424,7 +2424,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  		printf(_(
>  		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
>  		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> -		   "         =%-22s crc=%-5u\n"
> +		   "         =%-22s crc=%u\n"
>  		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  		   "         =%-22s sunit=%-6u swidth=%u blks\n"
>  		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"

D'oh.  Looks like I missed that in the previous patch, where the additional
args are added to the print, but not the format string.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35704 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbdHNXbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 19:31:13 -0400
Date: Mon, 14 Aug 2017 16:31:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] mkfs: replace variables with opts table: -i options
Message-ID: <20170814233107.GM4796@magnolia>
References: <20170811123058.16061-1-jtulak@redhat.com>
 <20170811123058.16061-4-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811123058.16061-4-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 02:30:55PM +0200, Jan Tulak wrote:
> Remove variables that can be replaced with a direct access to the opts
> table, so we have it all in a single place, accessible from anywhere.
> 
> In future, we can remove some instances where we are passing values as
> arguments to helper functions, when we have the values in the opts
> struct and could pass only the struct.  But for now, limit the changes
> to simple replacement without any change in the logic.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mkfs/xfs_mkfs.c | 96 +++++++++++++++++++++++++++++----------------------------
>  1 file changed, 49 insertions(+), 47 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7f7f4554..66ba2869 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1689,13 +1689,9 @@ main(
>  	bool			force_overwrite;
>  	struct fsxattr		fsx;
>  	int			ilflag;
> -	int			imaxpct;
>  	int			imflag;
> -	int			inodelog;
> -	int			inopblock;
>  	int			ipflag;
>  	int			isflag;
> -	int			isize;
>  	char			*label = NULL;
>  	int			laflag;
>  	int			lalign;
> @@ -1780,8 +1776,7 @@ main(
>  	logagno = logblocks = rtblocks = rtextblocks = 0;
>  	Nflag = nlflag = nsflag = nvflag = 0;
>  	dirblocklog = dirblocksize = 0;
> -	qflag = 0;
> -	imaxpct = inodelog = inopblock = isize = 0;
> +	qflag = false;
>  	dfile = logfile = rtfile = NULL;
>  	protofile = NULL;
>  	rtbytes = rtextbytes = logbytes = 0;
> @@ -1926,27 +1921,22 @@ main(
>  							       value);
>  					break;
>  				case I_LOG:
> -					inodelog = parse_conf_val(OPT_I, I_LOG,
> -								  value);
> -					isize = 1 << inodelog;
> +					parse_conf_val(OPT_I, I_LOG,
> +							     value);
>  					ilflag = 1;
>  					break;
>  				case I_MAXPCT:
> -					imaxpct = parse_conf_val(OPT_I,
> -								 I_MAXPCT,
> -								 value);
> +					parse_conf_val(OPT_I, I_MAXPCT, value);
>  					imflag = 1;
>  					break;
>  				case I_PERBLOCK:
> -					inopblock = parse_conf_val(OPT_I,
> -								   I_PERBLOCK,
> -								   value);
> +					parse_conf_val(OPT_I, I_PERBLOCK,
> +						       value);
>  					ipflag = 1;
>  					break;
>  				case I_SIZE:
> -					isize = parse_conf_val(OPT_I, I_SIZE,
> +					parse_conf_val(OPT_I, I_SIZE,
>  							       value);
> -					inodelog = libxfs_highbit32(isize);
>  					isflag = 1;
>  					break;
>  				case I_ATTR:
> @@ -2398,7 +2388,8 @@ _("block size %lld cannot be smaller than logical sector size %d\n"),
>  	 */
>  	if (sb_feat.crcs_enabled) {
>  		/* minimum inode size is 512 bytes, ipflag checked later */
> -		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
> +		if ((isflag || ilflag) &&
> +		    get_conf_val(OPT_I, I_LOG) < XFS_DINODE_DFL_CRC_LOG) {
>  			fprintf(stderr,
>  _("Minimum inode size for CRCs is %d bytes\n"),
>  				1 << XFS_DINODE_DFL_CRC_LOG);
> @@ -2522,15 +2513,17 @@ _("rmapbt not supported with realtime devices\n"));
>  					   get_conf_val(OPT_B, B_LOG)));
>  	}
>  	if (ipflag) {
> -		inodelog = get_conf_val(OPT_B, B_LOG) -
> -			libxfs_highbit32(inopblock);
> -		isize = 1 << inodelog;
> +		set_conf_val(OPT_I, I_LOG, get_conf_val(OPT_B, B_LOG) -
> +			libxfs_highbit32(get_conf_val(OPT_I, I_PERBLOCK)));
> +		set_conf_val(OPT_I, I_SIZE, 1 << get_conf_val(OPT_I, I_LOG));
>  	} else if (!ilflag && !isflag) {
> -		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
> -						: XFS_DINODE_DFL_LOG;
> -		isize = 1 << inodelog;
> +		set_conf_val(OPT_I, I_LOG,
> +			     sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
> +						: XFS_DINODE_DFL_LOG);
> +		set_conf_val(OPT_I, I_SIZE, 1 << get_conf_val(OPT_I, I_LOG));
>  	}
> -	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
> +	if (sb_feat.crcs_enabled && get_conf_val(OPT_I, I_LOG) <
> +	    XFS_DINODE_DFL_CRC_LOG) {
>  		fprintf(stderr,
>  		_("Minimum inode size for CRCs is %d bytes\n"),
>  			1 << XFS_DINODE_DFL_CRC_LOG);
> @@ -2617,12 +2610,14 @@ _("rmapbt not supported with realtime devices\n"));
>  	/*
>  	 * Check some argument sizes against mins, maxes.
>  	 */
> -	if (isize > get_conf_val(OPT_B, B_SIZE) / XFS_MIN_INODE_PERBLOCK ||
> -	    isize < XFS_DINODE_MIN_SIZE ||
> -	    isize > XFS_DINODE_MAX_SIZE) {
> +	if (get_conf_val(OPT_I, I_SIZE) >
> +	    get_conf_val(OPT_B, B_SIZE) / XFS_MIN_INODE_PERBLOCK ||
> +	    get_conf_val(OPT_I, I_SIZE) < XFS_DINODE_MIN_SIZE ||
> +	    get_conf_val(OPT_I, I_SIZE) > XFS_DINODE_MAX_SIZE) {
>  		int	maxsz;
>  
> -		fprintf(stderr, _("illegal inode size %d\n"), isize);
> +		fprintf(stderr, _("illegal inode size %lld\n"),
> +			get_conf_val(OPT_I, I_SIZE));
>  		maxsz = MIN(get_conf_val(OPT_B, B_SIZE) /
>  			    XFS_MIN_INODE_PERBLOCK,
>  			    XFS_DINODE_MAX_SIZE);
> @@ -3034,8 +3029,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  			     get_conf_val(OPT_D, D_AGCOUNT));
>  
>  	if (!imflag)
> -		imaxpct = calc_default_imaxpct(get_conf_val(OPT_B, B_LOG),
> -					       dblocks);
> +		set_conf_val(OPT_I, I_MAXPCT,
> +			     calc_default_imaxpct(get_conf_val(OPT_B, B_LOG),
> +					       dblocks));
>  
>  	/*
>  	 * check that log sunit is modulo fsblksize or default it to D_SUNIT.
> @@ -3068,7 +3064,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  				   sb_feat.crcs_enabled, sb_feat.dir_version,
>  				   get_conf_val(OPT_D, D_SECTLOG),
>  				   get_conf_val(OPT_B, B_LOG),
> -				   inodelog, dirblocklog,
> +				   get_conf_val(OPT_I, I_LOG), dirblocklog,
>  				   sb_feat.log_version, lsunit, sb_feat.finobt,
>  				   sb_feat.rmapbt, sb_feat.reflink,
>  				   sb_feat.inode_align);
> @@ -3227,29 +3223,32 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  
>  	if (!qflag || Nflag) {
>  		printf(_(
> -		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
> +		   "meta-data=%-22s isize=%-6lld agcount=%lld, agsize=%lld blks\n"
>  		   "         =%-22s sectsz=%-5lld attr=%u, projid32bit=%u\n"
>  		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
> -		   "data     =%-22s bsize=%-6lld blocks=%llu, imaxpct=%u\n"
> -		   "         =%-22s sunit=%-6lld swidth=%lld blks\n"
> -		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
> +		   "data     =%-22s bsize=%-6llu blocks=%lld, imaxpct=%lld\n"
> +		   "         =%-22s sunit=%-6llu swidth=%lld blks\n"
> +		   "naming   =version %-14u bsize=%-6llu ascii-ci=%d ftype=%d\n"
>  		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
> -		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
> +		   "         =%-22s sectsz=%-5lld sunit=%lld blks, lazy-count=%d\n"
>  		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> -			dfile, isize, get_conf_val(OPT_D, D_AGCOUNT),
> +			dfile, get_conf_val(OPT_I, I_SIZE),
> +			get_conf_val(OPT_D, D_AGCOUNT),
>  			get_conf_val(OPT_D, D_AGSIZE),
>  			"", get_conf_val(OPT_D, D_SECTSIZE),
>  			sb_feat.attr_version,
>  				    !sb_feat.projid16bit,
>  			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
>  			sb_feat.rmapbt, sb_feat.reflink,
> -			"", get_conf_val(OPT_B, B_SIZE), (long long)dblocks, imaxpct,
> +			"", get_conf_val(OPT_B, B_SIZE),
> +			(long long)dblocks,
> +			get_conf_val(OPT_I, I_MAXPCT),
>  			"", get_conf_val(OPT_D, D_SUNIT),
>  			get_conf_val(OPT_D, D_SWIDTH),
> -			sb_feat.dir_version, dirblocksize, sb_feat.nci,
> +			sb_feat.dir_version, (long long)dirblocksize, sb_feat.nci,
>  				sb_feat.dirftype,
>  			logfile, 1 << get_conf_val(OPT_B, B_LOG), (long long)logblocks,
> -			sb_feat.log_version, "", lsectorsize, lsunit,
> +			sb_feat.log_version, "", (long long)lsectorsize, (long long)lsunit,
>  				sb_feat.lazy_sb_counters,
>  			rtfile, rtextblocks << get_conf_val(OPT_B, B_LOG),
>  			(long long)rtblocks, (long long)rtextents);
> @@ -3274,16 +3273,18 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_rbmblocks = nbmblocks;
>  	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
>  	sbp->sb_sectsize = (uint16_t)get_conf_val(OPT_D, D_SECTSIZE);
> -	sbp->sb_inodesize = (uint16_t)isize;
> -	sbp->sb_inopblock = (uint16_t)(get_conf_val(OPT_B, B_SIZE) / isize);
> +	sbp->sb_inodesize = (uint16_t)get_conf_val(OPT_I, I_SIZE);
> +	sbp->sb_inopblock = (uint16_t)(get_conf_val(OPT_B, B_SIZE) /
> +					 get_conf_val(OPT_I, I_SIZE));
>  	sbp->sb_sectlog = (uint8_t)get_conf_val(OPT_D, D_SECTLOG);
> -	sbp->sb_inodelog = (uint8_t)inodelog;
> -	sbp->sb_inopblog = (uint8_t)(get_conf_val(OPT_B, B_LOG) - inodelog);
> +	sbp->sb_inodelog = (uint8_t)get_conf_val(OPT_I, I_LOG);
> +	sbp->sb_inopblog = (uint8_t)(get_conf_val(OPT_B, B_LOG) -
> +				       get_conf_val(OPT_I, I_LOG));
>  	sbp->sb_rextslog =
>  		(uint8_t)(rtextents ?
>  			libxfs_highbit32((unsigned int)rtextents) : 0);
>  	sbp->sb_inprogress = 1;	/* mkfs is in progress */
> -	sbp->sb_imax_pct = imaxpct;
> +	sbp->sb_imax_pct = get_conf_val(OPT_I, I_MAXPCT);
>  	sbp->sb_icount = 0;
>  	sbp->sb_ifree = 0;
>  	sbp->sb_fdblocks = dblocks -
> @@ -3303,7 +3304,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	if (sb_feat.inode_align) {
>  		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
>  		if (sb_feat.crcs_enabled)
> -			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
> +			cluster_size *= get_conf_val(OPT_I, I_SIZE) /
> +				XFS_DINODE_MIN_SIZE;
>  		sbp->sb_inoalignmt = cluster_size >> get_conf_val(OPT_B, B_LOG);
>  		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
>  	} else
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

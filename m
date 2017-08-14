Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27855 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdHNXe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 19:34:56 -0400
Date: Mon, 14 Aug 2017 16:34:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] mkfs: replace variables with opts table: -n options
Message-ID: <20170814233450.GO4796@magnolia>
References: <20170811123058.16061-1-jtulak@redhat.com>
 <20170811123058.16061-6-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811123058.16061-6-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 02:30:57PM +0200, Jan Tulak wrote:
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
>  mkfs/xfs_mkfs.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4e85694f..51c1a794 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1685,8 +1685,6 @@ main(
>  	int			dasize;
>  	xfs_rfsblock_t		dblocks;
>  	char			*dfile;
> -	int			dirblocklog;
> -	int			dirblocksize;
>  	int			dsflag;
>  	bool			force_overwrite;
>  	struct fsxattr		fsx;
> @@ -1767,7 +1765,6 @@ main(
>  	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = false;
>  	logblocks = rtblocks = rtextblocks = 0;
>  	Nflag = nlflag = nsflag = nvflag = false;
> -	dirblocklog = dirblocksize = 0;
>  	qflag = false;
>  	dfile = logfile = rtfile = NULL;
>  	protofile = NULL;
> @@ -2082,18 +2079,15 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case N_LOG:
> -					dirblocklog = parse_conf_val(OPT_N,
> +					parse_conf_val(OPT_N,
>  								     N_LOG,
>  								     value);
> -					dirblocksize = 1 << dirblocklog;
>  					nlflag = 1;
>  					break;
>  				case N_SIZE:
> -					dirblocksize = parse_conf_val(OPT_N,
> +					parse_conf_val(OPT_N,
>  								      N_SIZE,
>  								      value);
> -					dirblocklog =
> -						libxfs_highbit32(dirblocksize);
>  					nsflag = 1;
>  					break;
>  				case N_VERSION:
> @@ -2458,18 +2452,19 @@ _("rmapbt not supported with realtime devices\n"));
>  	}
>  
>  	if (nsflag || nlflag) {
> -		if (dirblocksize < get_conf_val(OPT_B, B_SIZE) ||
> -					dirblocksize > XFS_MAX_BLOCKSIZE) {
> -			fprintf(stderr, _("illegal directory block size %d\n"),
> -				dirblocksize);
> +		if (get_conf_val(OPT_N, N_SIZE) <
> +		    get_conf_val(OPT_B, B_SIZE) ||
> +		    get_conf_val(OPT_N, N_SIZE) > XFS_MAX_BLOCKSIZE) {
> +			fprintf(stderr, _("illegal directory block size %lld\n"),
> +				get_conf_val(OPT_N, N_SIZE));
>  			usage();
>  		}
>  	} else {
>  		if (get_conf_val(OPT_B, B_SIZE) < (1 << XFS_MIN_REC_DIRSIZE))
> -			dirblocklog = XFS_MIN_REC_DIRSIZE;
> +			set_conf_val(OPT_N, N_LOG, XFS_MIN_REC_DIRSIZE);
>  		else
> -			dirblocklog = get_conf_val(OPT_B, B_LOG);
> -		dirblocksize = 1 << dirblocklog;
> +			set_conf_val(OPT_N, N_LOG, get_conf_val(OPT_B, B_LOG));
> +		set_conf_val(OPT_N, N_SIZE, 1 << get_conf_val(OPT_N, N_LOG));
>  	}
>  
>  
> @@ -3053,7 +3048,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  				   sb_feat.crcs_enabled, sb_feat.dir_version,
>  				   get_conf_val(OPT_D, D_SECTLOG),
>  				   get_conf_val(OPT_B, B_LOG),
> -				   get_conf_val(OPT_I, I_LOG), dirblocklog,
> +				   get_conf_val(OPT_I, I_LOG),
> +				   get_conf_val(OPT_N, N_LOG),
>  				   sb_feat.log_version,
>  				   get_conf_val(OPT_L, L_SUNIT),
>  				   sb_feat.finobt,
> @@ -3244,7 +3240,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			get_conf_val(OPT_I, I_MAXPCT),
>  			"", get_conf_val(OPT_D, D_SUNIT),
>  			get_conf_val(OPT_D, D_SWIDTH),
> -			sb_feat.dir_version, (long long)dirblocksize, sb_feat.nci,
> +			sb_feat.dir_version,
> +			get_conf_val(OPT_N, N_SIZE), sb_feat.nci,
>  				sb_feat.dirftype,
>  			logfile, 1 << get_conf_val(OPT_B, B_LOG), (long long)logblocks,
>  			sb_feat.log_version, "",
> @@ -3296,7 +3293,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_qflags = 0;
>  	sbp->sb_unit = get_conf_val(OPT_D, D_SUNIT);
>  	sbp->sb_width = get_conf_val(OPT_D, D_SWIDTH);
> -	sbp->sb_dirblklog = dirblocklog - get_conf_val(OPT_B, B_LOG);
> +	sbp->sb_dirblklog = get_conf_val(OPT_N, N_LOG) -
> +		get_conf_val(OPT_B, B_LOG);
>  	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
>  		set_conf_val(OPT_L, L_SUNIT,
>  			     (get_conf_val(OPT_L, L_SUNIT) == 0) ?
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

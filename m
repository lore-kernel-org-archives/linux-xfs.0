Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753916AbeGFDfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:35:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663Z3YP193336
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:35:53 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2k0dnjg1ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:35:53 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w663ZqF5027562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:35:52 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w663ZqX0015388
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:35:52 GMT
Date: Thu, 5 Jul 2018 20:35:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 1/1] xfsprogs: add inode inline data support
Message-ID: <20180706033550.GO32415@magnolia>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-10-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-10-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:30AM +0800, Shan Hai wrote:
> Add a new mkfs command line option to enable the inode inline data
> feature. The mkfs set a bit in the superblock to notify the kernel
> that the data inlining is enabled, there is no extra options for
> mount.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  growfs/xfs_growfs.c | 14 +++++++++-----
>  libxfs/xfs_format.h |  4 +++-
>  libxfs/xfs_fs.h     |  1 +
>  mkfs/xfs_mkfs.c     | 20 +++++++++++++++++---
>  4 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 366176b7..a370bf9d 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -60,13 +60,14 @@ report_info(
>  	int		finobt_enabled,
>  	int		spinodes,
>  	int		rmapbt_enabled,
> -	int		reflink_enabled)
> +	int		reflink_enabled,
> +	int		inlinedata_enabled)
>  {
>  	printf(_(
>  	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
>  	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
>  	    "         =%-22s crc=%-8u finobt=%u spinodes=%u rmapbt=%u\n"
> -	    "         =%-22s reflink=%u\n"
> +	    "         =%-22s reflink=%u inline=%u\n"

I coulda sworn we refactored this into a library function...

Do xfs_db or xfs_repair require any changes?

Did xfstests have anything exciting to say about this feature?

--D

>  	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  	    "         =%-22s sunit=%-6u swidth=%u blks\n"
>  	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
> @@ -77,7 +78,7 @@ report_info(
>  		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
>  		"", geo.sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> -		"", reflink_enabled,
> +		"", reflink_enabled, inlinedata_enabled,
>  		"", geo.blocksize, (unsigned long long)geo.datablocks,
>  			geo.imaxpct,
>  		"", geo.sunit, geo.swidth,
> @@ -133,6 +134,7 @@ main(int argc, char **argv)
>  	int			spinodes;
>  	int			rmapbt_enabled;
>  	int			reflink_enabled;
> +	int			inlinedata_enabled;
>  	char			rpath[PATH_MAX];
>  
>  	progname = basename(argv[0]);
> @@ -266,12 +268,14 @@ main(int argc, char **argv)
>  	spinodes = geo.flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
>  	rmapbt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
>  	reflink_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
> +	inlinedata_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_INLINE ? 1 : 0;
>  	if (nflag) {
>  		report_info(geo, datadev, isint, logdev, rtdev,
>  				lazycount, dirversion, logversion,
>  				attrversion, projid32bit, crcs_enabled, ci,
>  				ftype_enabled, finobt_enabled, spinodes,
> -				rmapbt_enabled, reflink_enabled);
> +				rmapbt_enabled, reflink_enabled,
> +				inlinedata_enabled);
>  		exit(0);
>  	}
>  
> @@ -310,7 +314,7 @@ main(int argc, char **argv)
>  			lazycount, dirversion, logversion,
>  			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
>  			finobt_enabled, spinodes, rmapbt_enabled,
> -			reflink_enabled);
> +			reflink_enabled, inlinedata_enabled);
>  
>  	ddsize = xi.dsize;
>  	dlsize = ( xi.logBBsize? xi.logBBsize :
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index 48548933..2a765d12 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -478,10 +478,12 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> +#define XFS_SB_FEAT_INCOMPAT_INLINEDATA	(1 << 3)	/* inline inode data */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> +		 XFS_SB_FEAT_INCOMPAT_INLINEDATA)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 86a379f6..40737fb9 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -243,6 +243,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
> +#define XFS_FSOP_GEOM_FLAGS_INLINE	0x200000 /* inline data into inode */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 78d0ce5d..b321761b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -82,6 +82,7 @@ enum {
>  	I_ATTR,
>  	I_PROJID32BIT,
>  	I_SPINODES,
> +	I_INLINE,
>  	I_MAX_OPTS,
>  };
>  
> @@ -394,6 +395,7 @@ struct opt_params iopts = {
>  		[I_ATTR] = "attr",
>  		[I_PROJID32BIT] = "projid32bit",
>  		[I_SPINODES] = "sparse",
> +		[I_INLINE] = "inline",
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> @@ -442,6 +444,12 @@ struct opt_params iopts = {
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> +		{ .index = I_INLINE,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 0,
> +		},
>  	},
>  };
>  
> @@ -743,6 +751,7 @@ struct sb_feat_args {
>  	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
>  	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
>  	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
> +	bool	inlinedata;		/* XFS_SB_FEAT_INCOMPAT_INLINEDATA */
>  	bool	nodalign;
>  	bool	nortalign;
>  };
> @@ -871,7 +880,7 @@ usage( void )
>  			    sectsize=num\n\
>  /* force overwrite */	[-f]\n\
>  /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> -			    projid32bit=0|1,sparse=0|1]\n\
> +			    projid32bit=0|1,sparse=0|1,inline=0|1]\n\
>  /* no discard */	[-K]\n\
>  /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
>  			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
> @@ -1506,6 +1515,9 @@ inode_opts_parser(
>  	case I_SPINODES:
>  		cli->sb_feat.spinodes = getnum(value, opts, subopt);
>  		break;
> +	case I_INLINE:
> +		cli->sb_feat.inlinedata = getnum(value, opts, subopt);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2903,6 +2915,8 @@ sb_set_features(
>  		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
>  	}
>  
> +	if (fp->inlinedata)
> +		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_INLINEDATA;
>  }
>  
>  /*
> @@ -3184,7 +3198,7 @@ print_mkfs_cfg(
>  	printf(_(
>  "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
>  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> -"         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
> +"         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u, inline=%u\n"
>  "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  "         =%-22s sunit=%-6u swidth=%u blks\n"
>  "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
> @@ -3195,7 +3209,7 @@ print_mkfs_cfg(
>  			(long long)cfg->agsize,
>  		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
>  		"", fp->crcs_enabled, fp->finobt, fp->spinodes, fp->rmapbt,
> -			fp->reflink,
> +			fp->reflink, fp->inlinedata,
>  		"", cfg->blocksize, (long long)cfg->dblocks, cfg->imaxpct,
>  		"", cfg->dsunit, cfg->dswidth,
>  		fp->dir_version, cfg->dirblocksize, fp->nci, fp->dirftype,
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

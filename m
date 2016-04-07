Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E22E7CA3
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 14:02:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4259E304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 12:02:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Q5dLYHb6te1da4MX for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 12:02:36 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 66C8D16C165
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 14:02:34 -0500 (CDT)
Subject: Re: [PATCH 09/19] mkfs: use getnum_checked for all ranged parameters
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-10-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706AEC9.7030002@sandeen.net>
Date: Thu, 7 Apr 2016 14:02:33 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-10-git-send-email-jtulak@redhat.com>
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
> Now that getnum_checked can handle min/max checking, use this for
> all parameters that take straight numbers and don't require unit
> conversions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks ok.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_multidisk.h |   5 +-
>  mkfs/xfs_mkfs.c         | 148 ++++++++++++++++++++++++------------------------
>  2 files changed, 76 insertions(+), 77 deletions(-)
> 
> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index af35100..8e81d90 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -42,8 +42,9 @@
>  
>  #define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
>  #define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
> -#define XFS_AG_MIN_BLOCKS(blog)	((XFS_AG_BYTES(15)) >> (blog))
> -#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_BYTES(31) - 1) >> (blog))
> +#define	XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
> +#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
> +#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
>  
>  #define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0e2cfac..021d682 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -163,6 +163,8 @@ struct opt_params dopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> +		  .minval = 1,
> +		  .maxval = XFS_MAX_AGNUMBER,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_FILE,
> @@ -177,18 +179,26 @@ struct opt_params dopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SUNIT,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SWIDTH,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_AGSIZE,
> +		  .minval = XFS_AG_MIN_BYTES,
> +		  .maxval = XFS_AG_MAX_BYTES,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SU,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SW,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTLOG,
> @@ -207,12 +217,18 @@ struct opt_params dopts = {
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_RTINHERIT,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .minval = 1,
> +		  .maxval = 1,
> +		  .defaultval = 1,
>  		},
>  		{ .index = D_PROJINHERIT,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_EXTSZINHERIT,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  	},
> @@ -252,15 +268,23 @@ struct opt_params iopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_MAXPCT,
> +		  .minval = 0,
> +		  .maxval = 100,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PERBLOCK,
> +		  .minval = XFS_MIN_INODE_PERBLOCK,
> +		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_SIZE,
> +		  .minval = XFS_DINODE_MIN_SIZE,
> +		  .maxval = XFS_DINODE_MAX_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_ATTR,
> +		  .minval = 0,
> +		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PROJID32BIT,
> @@ -307,6 +331,8 @@ struct opt_params lopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = L_AGNUM,
> +		  .minval = 0,
> +		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_INTERNAL,
> @@ -318,9 +344,13 @@ struct opt_params lopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_VERSION,
> +		  .minval = 1,
> +		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SUNIT,
> +		  .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
> +		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SU,
> @@ -380,6 +410,8 @@ struct opt_params nopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_VERSION,
> +		  .minval = 2,
> +		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_FTYPE,
> @@ -1560,13 +1592,11 @@ main(
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case D_AGCOUNT:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_AGCOUNT);
>  					if (daflag)
>  						respec('d', subopts, D_AGCOUNT);
> -					agcount = getnum(value, 0, 0, false);
> -					if ((__int64_t)agcount <= 0)
> -						illegal(value, "d agcount");
> +
> +					agcount = getnum_checked(value, &dopts,
> +								 D_AGCOUNT);
>  					daflag = 1;
>  					break;
>  				case D_AGSIZE:
> @@ -1601,28 +1631,22 @@ main(
>  					dsize = value;
>  					break;
>  				case D_SUNIT:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_SUNIT);
>  					if (dsunit)
>  						respec('d', subopts, D_SUNIT);
>  					if (nodsflag)
>  						conflict('d', subopts, D_NOALIGN,
>  							 D_SUNIT);
> -					dsunit = getnum(value, 0, 0, false);
> -					if (dsunit < 0)
> -						illegal(value, "d sunit");
> +					dsunit = getnum_checked(value, &dopts,
> +								 D_SUNIT);
>  					break;
>  				case D_SWIDTH:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_SWIDTH);
>  					if (dswidth)
>  						respec('d', subopts, D_SWIDTH);
>  					if (nodsflag)
>  						conflict('d', subopts, D_NOALIGN,
>  							 D_SWIDTH);
> -					dswidth = getnum(value, 0, 0, false);
> -					if (dswidth < 0)
> -						illegal(value, "d swidth");
> +					dswidth = getnum_checked(value, &dopts,
> +								 D_SWIDTH);
>  					break;
>  				case D_SU:
>  					if (!value || *value == '\0')
> @@ -1638,16 +1662,13 @@ main(
>  						illegal(value, "d su");
>  					break;
>  				case D_SW:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_SW);
>  					if (dsw)
>  						respec('d', subopts, D_SW);
>  					if (nodsflag)
>  						conflict('d', subopts, D_NOALIGN,
>  							 D_SW);
> -					dsw = getnum(value, 0, 0, false);
> -					if (dsw < 0)
> -						illegal(value, "d sw");
> +					dsw = getnum_checked(value, &dopts,
> +								 D_SW);
>  					break;
>  				case D_NOALIGN:
>  					nodsflag = getnum_checked(value,
> @@ -1696,21 +1717,22 @@ main(
>  					ssflag = 1;
>  					break;
>  				case D_RTINHERIT:
> -					fsx.fsx_xflags |= \
> -						XFS_DIFLAG_RTINHERIT;
> +					c = getnum_checked(value, &dopts,
> +							   D_RTINHERIT);
> +					if (c)
> +						fsx.fsx_xflags |=
> +							XFS_DIFLAG_RTINHERIT;
>  					break;
>  				case D_PROJINHERIT:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_PROJINHERIT);
> -					fsx.fsx_projid = atoi(value);
> -					fsx.fsx_xflags |= \
> +					fsx.fsx_projid = getnum_checked(value,
> +							&dopts, D_PROJINHERIT);
> +					fsx.fsx_xflags |=
>  						XFS_DIFLAG_PROJINHERIT;
>  					break;
>  				case D_EXTSZINHERIT:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_EXTSZINHERIT);
> -					fsx.fsx_extsize = atoi(value);
> -					fsx.fsx_xflags |= \
> +					fsx.fsx_extsize = getnum_checked(value,
> +							&dopts, D_EXTSZINHERIT);
> +					fsx.fsx_xflags |=
>  						XFS_DIFLAG_EXTSZINHERIT;
>  					break;
>  				default:
> @@ -1745,18 +1767,13 @@ main(
>  					ilflag = 1;
>  					break;
>  				case I_MAXPCT:
> -					if (!value || *value == '\0')
> -						reqval('i', subopts, I_MAXPCT);
>  					if (imflag)
>  						respec('i', subopts, I_MAXPCT);
> -					imaxpct = getnum(value, 0, 0, false);
> -					if (imaxpct < 0 || imaxpct > 100)
> -						illegal(value, "i maxpct");
> +					imaxpct = getnum_checked(
> +							value, &iopts, I_MAXPCT);
>  					imflag = 1;
>  					break;
>  				case I_PERBLOCK:
> -					if (!value || *value == '\0')
> -						reqval('i', subopts, I_PERBLOCK);
>  					if (ilflag)
>  						conflict('i', subopts, I_LOG,
>  							 I_PERBLOCK);
> @@ -1765,16 +1782,13 @@ main(
>  					if (isflag)
>  						conflict('i', subopts, I_SIZE,
>  							 I_PERBLOCK);
> -					inopblock = getnum(value, 0, 0, false);
> -					if (inopblock <
> -						XFS_MIN_INODE_PERBLOCK ||
> -					    !ispow2(inopblock))
> +					inopblock = getnum_checked(value, &iopts,
> +								   I_PERBLOCK);
> +					if (!ispow2(inopblock))
>  						illegal(value, "i perblock");
>  					ipflag = 1;
>  					break;
>  				case I_SIZE:
> -					if (!value || *value == '\0')
> -						reqval('i', subopts, I_SIZE);
>  					if (ilflag)
>  						conflict('i', subopts, I_LOG,
>  							 I_SIZE);
> @@ -1783,19 +1797,16 @@ main(
>  							 I_SIZE);
>  					if (isflag)
>  						respec('i', subopts, I_SIZE);
> -					isize = getnum(value, 0, 0, true);
> -					if (isize <= 0 || !ispow2(isize))
> +					isize = getnum_checked(value, &iopts,
> +							       I_SIZE);
> +					if (!ispow2(isize))
>  						illegal(value, "i size");
>  					inodelog = libxfs_highbit32(isize);
>  					isflag = 1;
>  					break;
>  				case I_ATTR:
> -					if (!value || *value == '\0')
> -						reqval('i', subopts, I_ATTR);
> -					c = getnum(value, 0, 0, false);
> -					if (c < 0 || c > 2)
> -						illegal(value, "i attr");
> -					sb_feat.attr_version = c;
> +					sb_feat.attr_version = getnum_checked(
> +							value, &iopts, I_ATTR);
>  					break;
>  				case I_PROJID32BIT:
>  					sb_feat.projid16bit =
> @@ -1817,21 +1828,16 @@ main(
>  			while (*p != '\0') {
>  				char	**subopts = (char **)lopts.subopts;
>  				char	*value;
> -				long long tmp_num;
>  
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case L_AGNUM:
> -					if (!value || *value == '\0')
> -						reqval('l', subopts, L_AGNUM);
>  					if (laflag)
>  						respec('l', subopts, L_AGNUM);
>  					if (ldflag)
>  						conflict('l', subopts, L_AGNUM, L_DEV);
> -					tmp_num = getnum(value, 0, 0, false);
> -					if (tmp_num < 0)
> -						illegal(value, "l agno");
> -					logagno = (xfs_agnumber_t)tmp_num;
> +					logagno = getnum_checked(value, &lopts,
> +								 L_AGNUM);
>  					laflag = 1;
>  					break;
>  				case L_FILE:
> @@ -1868,13 +1874,10 @@ main(
>  					lsuflag = 1;
>  					break;
>  				case L_SUNIT:
> -					if (!value || *value == '\0')
> -						reqval('l', subopts, L_SUNIT);
>  					if (lsunit)
>  						respec('l', subopts, L_SUNIT);
> -					lsunit = getnum(value, 0, 0, false);
> -					if (lsunit < 0)
> -						illegal(value, "l sunit");
> +					lsunit = getnum_checked(value, &lopts,
> +								 L_SUNIT);
>  					lsunitflag = 1;
>  					break;
>  				case L_NAME:
> @@ -1893,14 +1896,10 @@ main(
>  					xi.logname = value;
>  					break;
>  				case L_VERSION:
> -					if (!value || *value == '\0')
> -						reqval('l', subopts, L_VERSION);
>  					if (lvflag)
>  						respec('l', subopts, L_VERSION);
> -					c = getnum(value, 0, 0, false);
> -					if (c < 1 || c > 2)
> -						illegal(value, "l version");
> -					sb_feat.log_version = c;
> +					sb_feat.log_version = getnum_checked(
> +						value, &lopts, L_VERSION);
>  					lvflag = 1;
>  					break;
>  				case L_SIZE:
> @@ -2035,11 +2034,10 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  						/* ASCII CI mode */
>  						sb_feat.nci = true;
>  					} else {
> -						c = getnum(value, 0, 0, false);
> -						if (c != 2)
> -							illegal(value,
> -								"n version");
> -						sb_feat.dir_version = c;
> +						sb_feat.dir_version =
> +							getnum_checked(value,
> +								&nopts,
> +								N_VERSION);
>  					}
>  					nvflag = 1;
>  					break;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

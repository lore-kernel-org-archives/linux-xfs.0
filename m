Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbdAMRne (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 12:43:34 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EDF63DE3E
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2017 17:43:35 +0000 (UTC)
Date: Fri, 13 Jan 2017 11:43:31 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 17/22] mkfs: use old variables as pointers to the new
 opts struct values
Message-ID: <20170113174331.GG23576@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-18-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-18-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:24PM +0100, Jan Tulak wrote:
> We need to have the values inside of the opts structure to validate it.
> To avoid duplicity and to prevent issues with using a wrong type from
> values union (e.g trating an int option as long long), keep the old
> variables like agcount, dsunit, ... and just turn them into pointers
> to the various opts fields.
> 
> However, at this moment, do not touch fields in other structures.
> If some option saves the value into the xi or fsx structure, then
> simply copy the value at the end of option parsing.
> 
> This might be changed in future if there is a nice way how to do it.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 771 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 418 insertions(+), 353 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index afc63d1..d55eb9a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -39,7 +39,7 @@ static int  ispow2(unsigned int i);
>   * The configured block and sector sizes are defined as global variables so
>   * that they don't need to be passed to functions that require them.
>   */
> -unsigned int		blocksize;
> +unsigned int		*blocksize;
>  unsigned int		sectorsize;
>  
>  #define MAX_OPTS	16
> @@ -557,7 +557,7 @@ struct opt_params {
>  					 },
>  					 {LAST_CONFLICT} },
>  			  .minval.i = 0,
> -			  .maxval.i = UINT_MAX,
> +			  .maxval.i = INT_MAX,
>  			  .needs_val = true,
>  			  .type = INT,
>  			},
> @@ -573,7 +573,7 @@ struct opt_params {
>  					 },
>  					 {LAST_CONFLICT} },
>  			  .minval.i = 0,
> -			  .maxval.i = UINT_MAX,
> +			  .maxval.i = INT_MAX,
>  			  .needs_val = true,
>  			  .type = INT,
>  			},
> @@ -601,7 +601,7 @@ struct opt_params {
>  					 {LAST_CONFLICT} },
>  			  .convert = true,
>  			  .minval.i = 0,
> -			  .maxval.i = UINT_MAX,
> +			  .maxval.i = INT_MAX,
>  			  .needs_val = true,
>  			  .type = INT,
>  			},
> @@ -617,7 +617,7 @@ struct opt_params {
>  					 },
>  					 {LAST_CONFLICT} },
>  			  .minval.i = 0,
> -			  .maxval.i = UINT_MAX,
> +			  .maxval.i = INT_MAX,
>  			  .needs_val = true,
>  			  .type = INT,
>  			},
> @@ -853,6 +853,7 @@ struct opt_params {
>  			  .maxval.i = 1,
>  			  .flagval.i = 1,
>  			  .type = INT,
> +			  .value.i = 1,
>  			},
>  			{ .index = L_SIZE,
>  			  .conflicts = { {LAST_CONFLICT} },
> @@ -1345,7 +1346,7 @@ static void conflict_struct(struct opt_params 	*opt, struct subopt_param *subopt
>  /*
>   * Use this macro before we have superblock and mount structure
>   */
> -#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
> +#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> ((*blocklog) - BBSHIFT)))
>  
>  /*
>   * Use this for block reservations needed for mkfs's conditions
> @@ -1416,16 +1417,16 @@ calc_stripe_factors(
>  		*lsunit = (int)BTOBBT(lsu);
>  
>  	/* verify if lsu/lsunit is a multiple block size */
> -	if (lsu % blocksize != 0) {
> +	if (lsu % *blocksize != 0) {
>  		fprintf(stderr,
>  _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
> -		lsu, blocksize);
> +		lsu, *blocksize);
>  		exit(1);
>  	}
> -	if ((BBTOB(*lsunit) % blocksize != 0)) {
> +	if ((BBTOB(*lsunit) % *blocksize != 0)) {
>  		fprintf(stderr,
>  _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
> -		BBTOB(*lsunit), blocksize);
> +		BBTOB(*lsunit), *blocksize);
>  		exit(1);
>  	}
>  }
> @@ -2003,6 +2004,10 @@ check_all_opts(struct opt_params *opts)
>  	}
>  }
>  
> +/* TODO we might loose some numbers here, if they are unsigned and bigger than
> + * long long max value. So it might be worth to transform this... (think
> + * __uint64_t)
> + */

OK, so is this "might" be recommended or should we go ahead and prevent it in this
implementation? ;)

>  static long long
>  getnum(
>  	const char		*str,
> @@ -2061,7 +2066,7 @@ getnum(
>  	 * number.
>  	 */
>  	if (sp->convert)
> -		c = cvtnum(blocksize, sectorsize, str);
> +		c = cvtnum(*blocksize, sectorsize, str);
>  	else {
>  		char		*str_end;
>  
> @@ -2106,15 +2111,15 @@ main(
>  	int			argc,
>  	char			**argv)
>  {
> -	__uint64_t		agcount;
> +	__uint64_t		*agcount;
>  	xfs_agf_t		*agf;
>  	xfs_agi_t		*agi;
>  	xfs_agnumber_t		agno;
> -	__uint64_t		agsize;
> +	__uint64_t		*agsize;
>  	xfs_alloc_rec_t		*arec;
>  	struct xfs_btree_block	*block;
>  	int			blflag;
> -	int			blocklog;
> +	int			*blocklog;
>  	int			bsflag;
>  	int			bsize;
>  	xfs_buf_t		*buf;
> @@ -2123,51 +2128,51 @@ main(
>  	int			dasize;
>  	xfs_rfsblock_t		dblocks;
>  	char			*dfile;
> -	int			dirblocklog;
> -	int			dirblocksize;
> -	__uint64_t 		dbytes;
> -	int			dsu;
> -	int			dsw;
> -	int			dsunit;
> -	int			dswidth;
> +	int			*dirblocklog;
> +	int			*dirblocksize;
> +	__uint64_t 		*dbytes;
> +	int			*dsu;
> +	int			*dsw;
> +	int			*dsunit;
> +	int			*dswidth;
>  	int			force_overwrite;
>  	struct fsxattr		fsx;
>  	int			ilflag;
> -	int			imaxpct;
> +	int			*imaxpct;
>  	int			imflag;
> -	int			inodelog;
> -	int			inopblock;
> +	int			*inodelog;
> +	int			*inopblock;
>  	int			ipflag;
>  	int			isflag;
> -	int			isize;
> +	int			*isize;
>  	char			*label = NULL;
>  	int			laflag;
>  	int			lalign;
>  	int			ldflag;
>  	int			liflag;
> -	xfs_agnumber_t		logagno;
> +	xfs_agnumber_t		*logagno;
>  	xfs_rfsblock_t		logblocks;
>  	char			*logfile;
> -	int			loginternal;
> -	__uint64_t 		logbytes;
> +	int			*loginternal;
> +	__uint64_t 		*logbytes;
>  	xfs_fsblock_t		logstart;
>  	int			lvflag;
>  	int			lsflag;
>  	int			lsuflag;
>  	int			lsunitflag;
> -	int			lsectorlog;
> -	int			lsectorsize;
> +	int			*lsectorlog;
> +	int			*lsectorsize;
>  	int			lslflag;
>  	int			lssflag;
> -	int			lsu;
> -	int			lsunit;
> +	int			*lsu;
> +	int			*lsunit;
>  	int			min_logblocks;
>  	xfs_mount_t		*mp;
>  	xfs_mount_t		mbuf;
>  	xfs_extlen_t		nbmblocks;
>  	int			nlflag;
> -	int			nodsflag;
> -	int			norsflag;
> +	int			*nodsflag;
> +	int			*norsflag;
>  	xfs_alloc_rec_t		*nrec;
>  	int			nsflag;
>  	int			nvflag;
> @@ -2178,10 +2183,10 @@ main(
>  	char			*protostring;
>  	int			qflag;
>  	xfs_rfsblock_t		rtblocks;
> -	__uint64_t 		rtbytes;
> +	__uint64_t 		*rtbytes;
>  	xfs_extlen_t		rtextblocks;
>  	xfs_rtblock_t		rtextents;
> -	__uint64_t 		rtextbytes;
> +	__uint64_t 		*rtextbytes;
>  	char			*rtfile;
>  	xfs_sb_t		*sbp;
>  	int			sectorlog;
> @@ -2216,24 +2221,51 @@ main(
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> +
> +	/*
> +	 * Set up pointers, so we can use shorter names and to let gcc
> +	 * check the correct type. We don't want to inadvertently use an int as
> +	 * unsigned int and so on...
> +	 */
> +	agcount = &opts[OPT_D].subopt_params[D_AGCOUNT].value.uint64;
> +	agsize = &opts[OPT_D].subopt_params[D_AGSIZE].value.uint64;
> +	dbytes = &opts[OPT_D].subopt_params[D_SIZE].value.uint64;
> +	dsunit = &opts[OPT_D].subopt_params[D_SUNIT].value.i;
> +	dswidth = &opts[OPT_D].subopt_params[D_SWIDTH].value.i;
> +	dsu = &opts[OPT_D].subopt_params[D_SU].value.i;
> +	dsw = &opts[OPT_D].subopt_params[D_SW].value.i;
> +	nodsflag = &opts[OPT_D].subopt_params[D_NOALIGN].value.i;
> +	norsflag = &opts[OPT_R].subopt_params[R_NOALIGN].value.i;
> +	logagno = &opts[OPT_L].subopt_params[L_AGNUM].value.u;
> +	lsu = &opts[OPT_L].subopt_params[L_SU].value.i;
> +	lsunit = &opts[OPT_L].subopt_params[L_SUNIT].value.i;
> +	logbytes = &opts[OPT_L].subopt_params[L_SIZE].value.uint64;
> +	imaxpct = &opts[OPT_I].subopt_params[I_MAXPCT].value.i;
> +	inopblock = &opts[OPT_I].subopt_params[I_PERBLOCK].value.i;
> +	dirblocksize = &opts[OPT_N].subopt_params[N_SIZE].value.i;
> +	dirblocklog = &opts[OPT_N].subopt_params[N_LOG].value.i;
> +	rtextbytes = &opts[OPT_R].subopt_params[R_EXTSIZE].value.uint64;
> +	rtbytes = &opts[OPT_R].subopt_params[R_SIZE].value.uint64;
> +	blocklog = &opts[OPT_B].subopt_params[B_LOG].value.i;
> +	blocksize = &opts[OPT_B].subopt_params[B_SIZE].value.u;
> +	isize = &opts[OPT_I].subopt_params[I_SIZE].value.i;
> +	inodelog = &opts[OPT_I].subopt_params[I_LOG].value.i;
> +	loginternal = &opts[OPT_L].subopt_params[L_INTERNAL].value.i;
> +	lsectorsize = &opts[OPT_L].subopt_params[L_SECTSIZE].value.i;
> +	lsectorlog = &opts[OPT_L].subopt_params[L_SECTLOG].value.i;
> +
>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
> -	blocklog = blocksize = 0;
> -	sectorlog = lsectorlog = 0;
> -	sectorsize = lsectorsize = 0;
> -	agsize = daflag = dasize = dblocks = 0;
> +	sectorlog = 0;
> +	sectorsize = 0;
> +	daflag = dasize = dblocks = 0;
>  	ilflag = imflag = ipflag = isflag = 0;
>  	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
> -	loginternal = 1;
> -	logagno = logblocks = rtblocks = rtextblocks = 0;
> +	logblocks = rtblocks = rtextblocks = 0;
>  	Nflag = nlflag = nsflag = nvflag = 0;
> -	dirblocklog = dirblocksize = 0;
>  	qflag = 0;
> -	imaxpct = inodelog = inopblock = isize = 0;
>  	dfile = logfile = rtfile = NULL;
>  	protofile = NULL;
> -	rtbytes = rtextbytes = logbytes = dbytes = 0;
> -	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
> -	nodsflag = norsflag = 0;
> +	lalign = 0;
>  	force_overwrite = 0;
>  	worst_freelist = 0;
>  	memset(&fsx, 0, sizeof(fsx));
> @@ -2256,15 +2288,15 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case B_LOG:
> -					blocklog = getnum(value, &opts[OPT_B],
> +					*blocklog = getnum(value, &opts[OPT_B],
>  								B_LOG);
> -					blocksize = 1 << blocklog;
> +					*blocksize = 1 << *blocklog;
>  					blflag = 1;
>  					break;
>  				case B_SIZE:
> -					blocksize = getnum(value, &opts[OPT_B],
> +					*blocksize = getnum(value, &opts[OPT_B],
>  							   B_SIZE);
> -					blocklog = libxfs_highbit32(blocksize);
> +					*blocklog = libxfs_highbit32(*blocksize);
>  					bsflag = 1;
>  					break;
>  				default:
> @@ -2280,12 +2312,12 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case D_AGCOUNT:
> -					agcount = getnum(value, &opts[OPT_D],
> +					*agcount = getnum(value, &opts[OPT_D],
>  							 D_AGCOUNT);
>  					daflag = 1;
>  					break;
>  				case D_AGSIZE:
> -					agsize = getnum(value, &opts[OPT_D],
> +					*agsize = getnum(value, &opts[OPT_D],
>  								D_AGSIZE);
>  					dasize = 1;
>  					break;
> @@ -2298,25 +2330,25 @@ main(
>  								D_NAME);
>  					break;
>  				case D_SIZE:
> -					dbytes = getnum(value, &opts[OPT_D],
> +					*dbytes = getnum(value, &opts[OPT_D],
>  								D_SIZE);
>  					break;
>  				case D_SUNIT:
> -					dsunit = getnum(value, &opts[OPT_D],
> +					*dsunit = getnum(value, &opts[OPT_D],
>  								D_SUNIT);
>  					break;
>  				case D_SWIDTH:
> -					dswidth = getnum(value, &opts[OPT_D],
> +					*dswidth = getnum(value, &opts[OPT_D],
>  							 D_SWIDTH);
>  					break;
>  				case D_SU:
> -					dsu = getnum(value, &opts[OPT_D], D_SU);
> +					*dsu = getnum(value, &opts[OPT_D], D_SU);
>  					break;
>  				case D_SW:
> -					dsw = getnum(value, &opts[OPT_D], D_SW);
> +					*dsw = getnum(value, &opts[OPT_D], D_SW);
>  					break;
>  				case D_NOALIGN:
> -					nodsflag = getnum(value, &opts[OPT_D],
> +					*nodsflag = getnum(value, &opts[OPT_D],
>  								D_NOALIGN);
>  					break;
>  				case D_SECTLOG:
> @@ -2338,6 +2370,7 @@ main(
>  					if (c)
>  						fsx.fsx_xflags |=
>  							XFS_DIFLAG_RTINHERIT;
> +					opts[OPT_D].subopt_params[D_RTINHERIT].value.u = c;
>  					break;
>  				case D_PROJINHERIT:
>  					fsx.fsx_projid = getnum(value, &opts[OPT_D],
> @@ -2369,25 +2402,25 @@ main(
>  								I_ALIGN);
>  					break;
>  				case I_LOG:
> -					inodelog = getnum(value, &opts[OPT_I],
> +					*inodelog = getnum(value, &opts[OPT_I],
>  								I_LOG);
> -					isize = 1 << inodelog;
> +					*isize = 1 << *inodelog;
>  					ilflag = 1;
>  					break;
>  				case I_MAXPCT:
> -					imaxpct = getnum(value, &opts[OPT_I],
> +					*imaxpct = getnum(value, &opts[OPT_I],
>  							 I_MAXPCT);
>  					imflag = 1;
>  					break;
>  				case I_PERBLOCK:
> -					inopblock = getnum(value, &opts[OPT_I],
> +					*inopblock = getnum(value, &opts[OPT_I],
>  							   I_PERBLOCK);
>  					ipflag = 1;
>  					break;
>  				case I_SIZE:
> -					isize = getnum(value, &opts[OPT_I],
> +					*isize = getnum(value, &opts[OPT_I],
>  								I_SIZE);
> -					inodelog = libxfs_highbit32(isize);
> +					*inodelog = libxfs_highbit32(*isize);
>  					isflag = 1;
>  					break;
>  				case I_ATTR:
> @@ -2419,7 +2452,7 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case L_AGNUM:
> -					logagno = getnum(value, &opts[OPT_L],
> +					*logagno = getnum(value, &opts[OPT_L],
>  								L_AGNUM);
>  					laflag = 1;
>  					break;
> @@ -2428,16 +2461,16 @@ main(
>  							    L_FILE);
>  					break;
>  				case L_INTERNAL:
> -					loginternal = getnum(value, &opts[OPT_L],
> +					*loginternal = getnum(value, &opts[OPT_L],
>  							     L_INTERNAL);
>  					liflag = 1;
>  					break;
>  				case L_SU:
> -					lsu = getnum(value, &opts[OPT_L], L_SU);
> +					*lsu = getnum(value, &opts[OPT_L], L_SU);
>  					lsuflag = 1;
>  					break;
>  				case L_SUNIT:
> -					lsunit = getnum(value, &opts[OPT_L],
> +					*lsunit = getnum(value, &opts[OPT_L],
>  								L_SUNIT);
>  					lsunitflag = 1;
>  					break;
> @@ -2447,7 +2480,7 @@ main(
>  								L_NAME);
>  					xi.logname = logfile;
>  					ldflag = 1;
> -					loginternal = 0;
> +					*loginternal = 0;
>  					break;
>  				case L_VERSION:
>  					sb_feat.log_version =
> @@ -2456,20 +2489,20 @@ main(
>  					lvflag = 1;
>  					break;
>  				case L_SIZE:
> -					logbytes = getnum(value, &opts[OPT_L],
> +					*logbytes = getnum(value, &opts[OPT_L],
>  								L_SIZE);
>  					break;
>  				case L_SECTLOG:
> -					lsectorlog = getnum(value, &opts[OPT_L],
> +					*lsectorlog = getnum(value, &opts[OPT_L],
>  							    L_SECTLOG);
> -					lsectorsize = 1 << lsectorlog;
> +					*lsectorsize = 1 << *lsectorlog;
>  					lslflag = 1;
>  					break;
>  				case L_SECTSIZE:
> -					lsectorsize = getnum(value, &opts[OPT_L],
> +					*lsectorsize = getnum(value, &opts[OPT_L],
>  							     L_SECTSIZE);
> -					lsectorlog =
> -						libxfs_highbit32(lsectorsize);
> +					*lsectorlog =
> +						libxfs_highbit32(*lsectorsize);
>  					lssflag = 1;
>  					break;
>  				case L_LAZYSBCNTR:
> @@ -2510,6 +2543,7 @@ main(
>  						reqval('m', subopts, M_UUID);
>  					if (platform_uuid_parse(value, &uuid))
>  						illegal(optarg, "m uuid");
> +					opts[OPT_M].subopt_params[M_UUID].value.s = value;
>  					break;
>  				case M_RMAPBT:
>  					sb_feat.rmapbt = getnum(
> @@ -2532,16 +2566,16 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case N_LOG:
> -					dirblocklog = getnum(value, &opts[OPT_N],
> +					*dirblocklog = getnum(value, &opts[OPT_N],
>  							     N_LOG);
> -					dirblocksize = 1 << dirblocklog;
> +					*dirblocksize = 1 << *dirblocklog;
>  					nlflag = 1;
>  					break;
>  				case N_SIZE:
> -					dirblocksize = getnum(value, &opts[OPT_N],
> +					*dirblocksize = getnum(value, &opts[OPT_N],
>  							      N_SIZE);
> -					dirblocklog =
> -						libxfs_highbit32(dirblocksize);
> +					*dirblocklog =
> +						libxfs_highbit32(*dirblocksize);
>  					nsflag = 1;
>  					break;
>  				case N_VERSION:
> @@ -2588,7 +2622,7 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case R_EXTSIZE:
> -					rtextbytes = getnum(value, &opts[OPT_R],
> +					*rtextbytes = getnum(value, &opts[OPT_R],
>  								R_EXTSIZE);
>  					break;
>  				case R_FILE:
> @@ -2601,11 +2635,11 @@ main(
>  							   R_NAME);
>  					break;
>  				case R_SIZE:
> -					rtbytes = getnum(value, &opts[OPT_R],
> +					*rtbytes = getnum(value, &opts[OPT_R],
>  								R_SIZE);
>  					break;
>  				case R_NOALIGN:
> -					norsflag = getnum(value, &opts[OPT_R],
> +					*norsflag = getnum(value, &opts[OPT_R],
>  								R_NOALIGN);
>  					break;
>  				default:
> @@ -2627,9 +2661,9 @@ main(
>  							 S_SECTSIZE, S_SECTLOG);
>  					sectorlog = getnum(value, &opts[OPT_S],
>  							   S_SECTLOG);
> -					lsectorlog = sectorlog;
> +					*lsectorlog = sectorlog;
>  					sectorsize = 1 << sectorlog;
> -					lsectorsize = sectorsize;
> +					*lsectorsize = sectorsize;
>  					lslflag = slflag = 1;
>  					break;
>  				case S_SIZE:
> @@ -2639,10 +2673,10 @@ main(
>  							 S_SECTSIZE);
>  					sectorsize = getnum(value, &opts[OPT_S],
>  							    S_SECTSIZE);
> -					lsectorsize = sectorsize;
> +					*lsectorsize = sectorsize;
>  					sectorlog =
>  						libxfs_highbit32(sectorsize);
> -					lsectorlog = sectorlog;
> +					*lsectorlog = sectorlog;
>  					lssflag = ssflag = 1;
>  					break;
>  				default:
> @@ -2665,6 +2699,36 @@ main(
>  	} else
>  		dfile = xi.dname;
>  
> +	/*
> +	 * Not every field could be connected with a pointer, so just copy
> +	 * the values for a options check.
> +	 */
> +	opts[OPT_D].subopt_params[D_FILE].value.i  = xi.disfile;
> +	opts[OPT_D].subopt_params[D_PROJINHERIT].value.u = fsx.fsx_projid;
> +	opts[OPT_D].subopt_params[D_EXTSZINHERIT].value.u = fsx.fsx_extsize;
> +	opts[OPT_L].subopt_params[L_FILE].value.i = xi.lisfile;
> +	opts[OPT_L].subopt_params[L_VERSION].value.i = sb_feat.log_version;
> +	opts[OPT_L].subopt_params[L_LAZYSBCNTR].value.b = sb_feat.lazy_sb_counters;
> +	opts[OPT_I].subopt_params[I_ATTR].value.i = sb_feat.attr_version ;
> +	opts[OPT_I].subopt_params[I_PROJID32BIT].value.b = !sb_feat.projid16bit ;
> +	opts[OPT_I].subopt_params[I_SPINODES].value.i = sb_feat.spinodes ;
> +	opts[OPT_M].subopt_params[M_FINOBT].value.i = sb_feat.finobt ;
> +	opts[OPT_M].subopt_params[M_RMAPBT].value.b = sb_feat.rmapbt ;
> +	opts[OPT_R].subopt_params[R_FILE].value.i = xi.risfile ;
> +	opts[OPT_R].subopt_params[R_NAME].value.s = xi.rtname;
> +	opts[OPT_R].subopt_params[R_DEV].value.s = xi.rtname;
> +	opts[OPT_S].subopt_params[S_LOG].value.u = sectorsize;
> +	opts[OPT_S].subopt_params[S_SECTLOG].value.u = sectorsize;
> +	opts[OPT_D].subopt_params[D_NAME].value.s = xi.dname;
> +	opts[OPT_D].subopt_params[D_SECTSIZE].value.u = sectorsize;
> +	opts[OPT_D].subopt_params[D_SECTLOG].value.i = sectorlog;
> +	opts[OPT_I].subopt_params[I_ALIGN].value.b = sb_feat.inode_align;
> +	opts[OPT_L].subopt_params[L_NAME].value.s = xi.logname;
> +	opts[OPT_L].subopt_params[L_DEV].value.s = xi.logname;
> +	opts[OPT_M].subopt_params[M_CRC].value.b = sb_feat.crcs_enabled;
> +	opts[OPT_N].subopt_params[N_VERSION].value.i = sb_feat.dir_version;
> +	opts[OPT_N].subopt_params[N_FTYPE].value.b = sb_feat.dirftype;
> +
>  	check_all_opts(opts);
>  
>  	/*
> @@ -2673,14 +2737,14 @@ main(
>  	 * so we need to start with the device geometry extraction too.
>  	 */
>  	if (!blflag && !bsflag) {
> -		blocklog = XFS_DFL_BLOCKSIZE_LOG;
> -		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
> +		*blocklog = XFS_DFL_BLOCKSIZE_LOG;
> +		*blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
>  	}
> -	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
> -		fprintf(stderr, _("illegal block size %d\n"), blocksize);
> +	if (*blocksize < XFS_MIN_BLOCKSIZE || *blocksize > XFS_MAX_BLOCKSIZE) {
> +		fprintf(stderr, _("illegal block size %d\n"), *blocksize);
>  		usage();
>  	}
> -	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> +	if (sb_feat.crcs_enabled && *blocksize < XFS_MIN_CRC_BLOCKSIZE) {
>  		fprintf(stderr,
>  _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  			XFS_MIN_CRC_BLOCKSIZE);
> @@ -2701,8 +2765,8 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  		sectorsize = XFS_MIN_SECTORSIZE;
>  	}
>  	if (!lslflag && !lssflag) {
> -		lsectorlog = sectorlog;
> -		lsectorsize = sectorsize;
> +		*lsectorlog = sectorlog;
> +		*lsectorsize = sectorsize;
>  	}
>  
>  	/*
> @@ -2712,14 +2776,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  	 * sector size mismatches between the new filesystem and the underlying
>  	 * host filesystem.
>  	 */
> -	check_device_type(dfile, &xi.disfile, !dbytes, !dfile,
> +	check_device_type(dfile, &xi.disfile, !*dbytes, !dfile,
>  			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
> -	if (!loginternal)
> -		check_device_type(xi.logname, &xi.lisfile, !logbytes, !xi.logname,
> +	if (!*loginternal)
> +		check_device_type(xi.logname, &xi.lisfile, !*logbytes, !xi.logname,
>  				  Nflag ? NULL : &xi.lcreat,
>  				  force_overwrite, "l");
>  	if (xi.rtname)
> -		check_device_type(xi.rtname, &xi.risfile, !rtbytes, !xi.rtname,
> +		check_device_type(xi.rtname, &xi.risfile, !*rtbytes, !xi.rtname,
>  				  Nflag ? NULL : &xi.rcreat,
>  				  force_overwrite, "r");
>  	if (xi.disfile || xi.lisfile || xi.risfile)
> @@ -2744,10 +2808,10 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  		sectorsize = ft.psectorsize ? ft.psectorsize :
>  					      XFS_MIN_SECTORSIZE;
>  
> -		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
> +		if ((*blocksize < sectorsize) && (*blocksize >= ft.lsectorsize)) {
>  			fprintf(stderr,
>  _("specified blocksize %d is less than device physical sector size %d\n"),
> -				blocksize, ft.psectorsize);
> +				*blocksize, ft.psectorsize);
>  			fprintf(stderr,
>  _("switching to logical sector size %d\n"),
>  				ft.lsectorsize);
> @@ -2758,20 +2822,20 @@ _("switching to logical sector size %d\n"),
>  
>  	if (!ssflag) {
>  		sectorlog = libxfs_highbit32(sectorsize);
> -		if (loginternal) {
> -			lsectorsize = sectorsize;
> -			lsectorlog = sectorlog;
> +		if (*loginternal) {
> +			*lsectorsize = sectorsize;
> +			*lsectorlog = sectorlog;
>  		}
>  	}
>  
>  	if (sectorsize < XFS_MIN_SECTORSIZE ||
> -	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
> +	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > *blocksize) {
>  		if (ssflag)
>  			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
>  		else
>  			fprintf(stderr,
>  _("block size %d cannot be smaller than logical sector size %d\n"),
> -				blocksize, ft.lsectorsize);
> +				*blocksize, ft.lsectorsize);
>  		usage();
>  	}
>  	if (sectorsize < ft.lsectorsize) {
> @@ -2779,12 +2843,12 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
>  			sectorsize, ft.lsectorsize);
>  		usage();
>  	}
> -	if (lsectorsize < XFS_MIN_SECTORSIZE ||
> -	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
> -		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
> +	if (*lsectorsize < XFS_MIN_SECTORSIZE ||
> +	    *lsectorsize > XFS_MAX_SECTORSIZE || *lsectorsize > *blocksize) {
> +		fprintf(stderr, _("illegal log sector size %d\n"), *lsectorsize);
>  		usage();
> -	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
> -		lsu = blocksize;
> +	} else if (*lsectorsize > XFS_MIN_SECTORSIZE && !*lsu && !*lsunit) {
> +		*lsu = *blocksize;
>  		sb_feat.log_version = 2;
>  	}
>  
> @@ -2795,7 +2859,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
>  	 */
>  	if (sb_feat.crcs_enabled) {
>  		/* minimum inode size is 512 bytes, ipflag checked later */
> -		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
> +		if ((isflag || ilflag) && *inodelog < XFS_DINODE_DFL_CRC_LOG) {
>  			fprintf(stderr,
>  _("Minimum inode size for CRCs is %d bytes\n"),
>  				1 << XFS_DINODE_DFL_CRC_LOG);
> @@ -2819,89 +2883,89 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  	}
>  
>  	if (nsflag || nlflag) {
> -		if (dirblocksize < blocksize ||
> -					dirblocksize > XFS_MAX_BLOCKSIZE) {
> +		if (*dirblocksize < *blocksize ||
> +					*dirblocksize > XFS_MAX_BLOCKSIZE) {
>  			fprintf(stderr, _("illegal directory block size %d\n"),
> -				dirblocksize);
> +				*dirblocksize);
>  			usage();
>  		}
>  	} else {
> -		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
> -			dirblocklog = XFS_MIN_REC_DIRSIZE;
> +		if (*blocksize < (1 << XFS_MIN_REC_DIRSIZE))
> +			*dirblocklog = XFS_MIN_REC_DIRSIZE;
>  		else
> -			dirblocklog = blocklog;
> -		dirblocksize = 1 << dirblocklog;
> +			*dirblocklog = *blocklog;
> +		*dirblocksize = 1 << *dirblocklog;
>  	}
>  
>  
> -	if (dbytes) {
> -		if (dbytes % XFS_MIN_BLOCKSIZE) {
> +	if (*dbytes) {
> +		if (*dbytes % XFS_MIN_BLOCKSIZE) {
>  			fprintf(stderr,
>  			_("illegal data length %lld, not a multiple of %d\n"),
> -				(long long)dbytes, XFS_MIN_BLOCKSIZE);
> +				(long long)*dbytes, XFS_MIN_BLOCKSIZE);
>  			usage();
>  		}
> -		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
> -		if (dbytes % blocksize)
> +		dblocks = (xfs_rfsblock_t)(*dbytes >> *blocklog);
> +		if (*dbytes % *blocksize)
>  			fprintf(stderr, _("warning: "
>  	"data length %lld not a multiple of %d, truncated to %lld\n"),
> -				(long long)dbytes, blocksize,
> -				(long long)(dblocks << blocklog));
> +				(long long)*dbytes, *blocksize,
> +				(long long)(dblocks << *blocklog));
>  	}
>  	if (ipflag) {
> -		inodelog = blocklog - libxfs_highbit32(inopblock);
> -		isize = 1 << inodelog;
> +		*inodelog = *blocklog - libxfs_highbit32(*inopblock);
> +		*isize = 1 << *inodelog;
>  	} else if (!ilflag && !isflag) {
> -		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
> +		*inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
>  						: XFS_DINODE_DFL_LOG;
> -		isize = 1 << inodelog;
> +		*isize = 1 << *inodelog;
>  	}
> -	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
> +	if (sb_feat.crcs_enabled && *inodelog < XFS_DINODE_DFL_CRC_LOG) {
>  		fprintf(stderr,
>  		_("Minimum inode size for CRCs is %d bytes\n"),
>  			1 << XFS_DINODE_DFL_CRC_LOG);
>  		usage();
>  	}
>  
> -	if (logbytes) {
> -		if (logbytes % XFS_MIN_BLOCKSIZE) {
> +	if (*logbytes) {
> +		if (*logbytes % XFS_MIN_BLOCKSIZE) {
>  			fprintf(stderr,
>  			_("illegal log length %lld, not a multiple of %d\n"),
> -				(long long)logbytes, XFS_MIN_BLOCKSIZE);
> +				(long long)*logbytes, XFS_MIN_BLOCKSIZE);
>  			usage();
>  		}
> -		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
> -		if (logbytes % blocksize)
> +		logblocks = (xfs_rfsblock_t)(*logbytes >> *blocklog);
> +		if (*logbytes % *blocksize)
>  			fprintf(stderr,
>  	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
> -				(long long)logbytes, blocksize,
> -				(long long)(logblocks << blocklog));
> +				(long long)*logbytes, *blocksize,
> +				(long long)(logblocks << *blocklog));
>  	}
> -	if (rtbytes) {
> -		if (rtbytes % XFS_MIN_BLOCKSIZE) {
> +	if (*rtbytes) {
> +		if (*rtbytes % XFS_MIN_BLOCKSIZE) {
>  			fprintf(stderr,
>  			_("illegal rt length %lld, not a multiple of %d\n"),
> -				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
> +				(long long)*rtbytes, XFS_MIN_BLOCKSIZE);
>  			usage();
>  		}
> -		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
> -		if (rtbytes % blocksize)
> +		rtblocks = (xfs_rfsblock_t)(*rtbytes >> *blocklog);
> +		if (*rtbytes % *blocksize)
>  			fprintf(stderr,
>  	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
> -				(long long)rtbytes, blocksize,
> -				(long long)(rtblocks << blocklog));
> +				(long long)*rtbytes, *blocksize,
> +				(long long)(rtblocks << *blocklog));
>  	}
>  	/*
>  	 * If specified, check rt extent size against its constraints.
>  	 */
> -	if (rtextbytes) {
> -		if (rtextbytes % blocksize) {
> +	if (*rtextbytes) {
> +		if (*rtextbytes % *blocksize) {
>  			fprintf(stderr,
>  		_("illegal rt extent size %lld, not a multiple of %d\n"),
> -				(long long)rtextbytes, blocksize);
> +				(long long)*rtextbytes, *blocksize);
>  			usage();
>  		}
> -		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
> +		rtextblocks = (xfs_extlen_t)(*rtextbytes >> *blocklog);
>  	} else {
>  		/*
>  		 * If realtime extsize has not been specified by the user,
> @@ -2911,23 +2975,23 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  		__uint64_t	rswidth;
>  		__uint64_t	rtextbytes;
>  
> -		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
> +		if (!*norsflag && !xi.risfile && !(!*rtbytes && xi.disfile))
>  			rswidth = ft.rtswidth;
>  		else
>  			rswidth = 0;
>  
> -		/* check that rswidth is a multiple of fs blocksize */
> -		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
> +		/* check that rswidth is a multiple of fs *blocksize */
> +		if (!*norsflag && rswidth && !(BBTOB(rswidth) % *blocksize)) {
>  			rswidth = DTOBT(rswidth);
> -			rtextbytes = rswidth << blocklog;
> +			rtextbytes = rswidth << *blocklog;
>  			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
>  			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
>  				rtextblocks = rswidth;
>  			}
>  		}
>  		if (!rtextblocks) {
> -			rtextblocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
> -					XFS_MIN_RTEXTSIZE >> blocklog : 1;
> +			rtextblocks = (*blocksize < XFS_MIN_RTEXTSIZE) ?
> +					XFS_MIN_RTEXTSIZE >> *blocklog : 1;
>  		}
>  	}
>  	ASSERT(rtextblocks);
> @@ -2935,34 +2999,34 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  	/*
>  	 * Check some argument sizes against mins, maxes.
>  	 */
> -	if (isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
> -	    isize < XFS_DINODE_MIN_SIZE ||
> -	    isize > XFS_DINODE_MAX_SIZE) {
> +	if (*isize > *blocksize / XFS_MIN_INODE_PERBLOCK ||
> +	    *isize < XFS_DINODE_MIN_SIZE ||
> +	    *isize > XFS_DINODE_MAX_SIZE) {
>  		int	maxsz;
>  
> -		fprintf(stderr, _("illegal inode size %d\n"), isize);
> -		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
> +		fprintf(stderr, _("illegal inode size %d\n"), *isize);
> +		maxsz = MIN(*blocksize / XFS_MIN_INODE_PERBLOCK,
>  			    XFS_DINODE_MAX_SIZE);
>  		if (XFS_DINODE_MIN_SIZE == maxsz)
>  			fprintf(stderr,
>  			_("allowable inode size with %d byte blocks is %d\n"),
> -				blocksize, XFS_DINODE_MIN_SIZE);
> +				*blocksize, XFS_DINODE_MIN_SIZE);
>  		else
>  			fprintf(stderr,
>  	_("allowable inode size with %d byte blocks is between %d and %d\n"),
> -				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
> +				*blocksize, XFS_DINODE_MIN_SIZE, maxsz);
>  		exit(1);
>  	}
>  
> -	/* if lsu or lsunit was specified, automatically use v2 logs */
> -	if ((lsu || lsunit) && sb_feat.log_version == 1) {
> +	/* if *lsu or *lsunit was specified, automatically use v2 logs */
> +	if ((*lsu || *lsunit) && sb_feat.log_version == 1) {
>  		fprintf(stderr,
>  			_("log stripe unit specified, using v2 logs\n"));
>  		sb_feat.log_version = 2;
>  	}
>  
> -	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
> -				&dsunit, &dswidth, &lsunit);
> +	calc_stripe_factors(*dsu, *dsw, sectorsize, *lsu, *lsectorsize,
> +				dsunit, dswidth, lsunit);
>  
>  	xi.setblksize = sectorsize;
>  
> @@ -2990,7 +3054,7 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  	sector_mask = (__uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
>  	xi.dsize &= sector_mask;
>  	xi.rtsize &= sector_mask;
> -	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
> +	xi.logBBsize &= (__uint64_t)-1 << (MAX(*lsectorlog, 10) - BBSHIFT);
>  
>  
>  	/* don't do discards on print-only runs or on files */
> @@ -3004,10 +3068,10 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  	}
>  
>  	if (!liflag && !ldflag)
> -		loginternal = xi.logdev == 0;
> +		*loginternal = xi.logdev == 0;
>  	if (xi.logname)
>  		logfile = xi.logname;
> -	else if (loginternal)
> +	else if (*loginternal)
>  		logfile = _("internal log");
>  	else if (xi.volname && xi.logdev)
>  		logfile = _("volume log");
> @@ -3022,15 +3086,15 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  		rtfile = _("volume rt");
>  	else if (!xi.rtdev)
>  		rtfile = _("none");
> -	if (dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
> +	if (*dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
>  		fprintf(stderr,
>  			_("size %lld specified for data subvolume is too large, "
>  			"maximum is %lld blocks\n"),
> -			(long long)dbytes, (long long)DTOBT(xi.dsize));
> +			(long long)*dbytes, (long long)DTOBT(xi.dsize));
>  		usage();
> -	} else if (!dbytes && xi.dsize > 0)
> +	} else if (!*dbytes && xi.dsize > 0)
>  		dblocks = DTOBT(xi.dsize);
> -	else if (!dbytes) {
> +	else if (!*dbytes) {
>  		fprintf(stderr, _("can't get size of data subvolume\n"));
>  		usage();
>  	}
> @@ -3041,11 +3105,11 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  		usage();
>  	}
>  
> -	if (loginternal && xi.logdev) {
> +	if (*loginternal && xi.logdev) {
>  		fprintf(stderr,
>  			_("can't have both external and internal logs\n"));
>  		usage();
> -	} else if (loginternal && sectorsize != lsectorsize) {
> +	} else if (*loginternal && sectorsize != *lsectorsize) {
>  		fprintf(stderr,
>  	_("data and log sector sizes must be equal for internal logs\n"));
>  		usage();
> @@ -3057,147 +3121,147 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>  reported by the device (%u).\n"),
>  			sectorsize, xi.dbsize);
>  	}
> -	if (!loginternal && xi.lbsize > lsectorsize) {
> +	if (!*loginternal && xi.lbsize > *lsectorsize) {
>  		fprintf(stderr, _(
>  "Warning: the log subvolume sector size %u is less than the sector size\n\
>  reported by the device (%u).\n"),
> -			lsectorsize, xi.lbsize);
> +			*lsectorsize, xi.lbsize);
>  	}
> -	if (rtbytes && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
> +	if (*rtbytes && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
>  		fprintf(stderr, _(
>  "Warning: the realtime subvolume sector size %u is less than the sector size\n\
>  reported by the device (%u).\n"),
>  			sectorsize, xi.rtbsize);
>  	}
>  
> -	if (rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
> +	if (*rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
>  		fprintf(stderr,
>  			_("size %lld specified for rt subvolume is too large, "
>  			"maximum is %lld blocks\n"),
> -			(long long)rtbytes, (long long)DTOBT(xi.rtsize));
> +			(long long)*rtbytes, (long long)DTOBT(xi.rtsize));
>  		usage();
> -	} else if (!rtbytes && xi.rtsize > 0)
> +	} else if (!*rtbytes && xi.rtsize > 0)
>  		rtblocks = DTOBT(xi.rtsize);
> -	else if (rtbytes && !xi.rtdev) {
> +	else if (*rtbytes && !xi.rtdev) {
>  		fprintf(stderr,
>  			_("size specified for non-existent rt subvolume\n"));
>  		usage();
>  	}
>  	if (xi.rtdev) {
>  		rtextents = rtblocks / rtextblocks;
> -		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * blocksize);
> +		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * *blocksize);
>  	} else {
>  		rtextents = rtblocks = 0;
>  		nbmblocks = 0;
>  	}
>  
> -	if (!nodsflag) {
> -		if (dsunit) {
> -			if (ft.dsunit && ft.dsunit != dsunit) {
> +	if (!*nodsflag) {
> +		if (*dsunit) {
> +			if (ft.dsunit && ft.dsunit != *dsunit) {
>  				fprintf(stderr,
>  					_("%s: Specified data stripe unit %d "
>  					"is not the same as the volume stripe "
>  					"unit %d\n"),
> -					progname, dsunit, ft.dsunit);
> +					progname, *dsunit, ft.dsunit);
>  			}
> -			if (ft.dswidth && ft.dswidth != dswidth) {
> +			if (ft.dswidth && ft.dswidth != *dswidth) {
>  				fprintf(stderr,
>  					_("%s: Specified data stripe width %d "
>  					"is not the same as the volume stripe "
>  					"width %d\n"),
> -					progname, dswidth, ft.dswidth);
> +					progname, *dswidth, ft.dswidth);
>  			}
>  		} else {
> -			dsunit = ft.dsunit;
> -			dswidth = ft.dswidth;
> -			nodsflag = 1;
> +			*dsunit = ft.dsunit;
> +			*dswidth = ft.dswidth;
> +			*nodsflag = 1;
>  		}
> -	} /* else dsunit & dswidth can't be set if nodsflag is set */
> +	} /* else *dsunit & *dswidth can't be set if *nodsflag is set */
>  
>  	if (dasize) {		/* User-specified AG size */
>  		/*
> -		 * Check specified agsize is a multiple of blocksize.
> +		 * Check specified agsize is a multiple of *blocksize.
>  		 */
> -		if (agsize % blocksize) {
> +		if (*agsize % *blocksize) {
>  			fprintf(stderr,
>  		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
> -				(long long)agsize, blocksize);
> +				(long long)*agsize, *blocksize);
>  			usage();
>  		}
> -		agsize /= blocksize;
> -		agcount = dblocks / agsize + (dblocks % agsize != 0);
> +		*agsize /= *blocksize;
> +		*agcount = dblocks / *agsize + (dblocks % *agsize != 0);
>  
>  	} else if (daflag) {	/* User-specified AG count */
> -		agsize = dblocks / agcount + (dblocks % agcount != 0);
> +		*agsize = dblocks / *agcount + (dblocks % *agcount != 0);
>  	} else {
> -		calc_default_ag_geometry(blocklog, dblocks,
> -				dsunit | dswidth, &agsize, &agcount);
> +		calc_default_ag_geometry(*blocklog, dblocks,
> +				*dsunit | *dswidth, agsize, agcount);
>  	}
>  
>  	/*
> -	 * If dsunit is a multiple of fs blocksize, then check that is a
> +	 * If *dsunit is a multiple of fs *blocksize, then check that is a
>  	 * multiple of the agsize too
>  	 */
> -	if (dsunit && !(BBTOB(dsunit) % blocksize) &&
> -	    dswidth && !(BBTOB(dswidth) % blocksize)) {
> +	if (*dsunit && !(BBTOB(*dsunit) % *blocksize) &&
> +	    *dswidth && !(BBTOB(*dswidth) % *blocksize)) {
>  
> -		/* convert from 512 byte blocks to fs blocksize */
> -		dsunit = DTOBT(dsunit);
> -		dswidth = DTOBT(dswidth);
> +		/* convert from 512 byte blocks to fs *blocksize */
> +		*dsunit = DTOBT(*dsunit);
> +		*dswidth = DTOBT(*dswidth);
>  
>  		/*
> -		 * agsize is not a multiple of dsunit
> +		 * agsize is not a multiple of *dsunit
>  		 */
> -		if ((agsize % dsunit) != 0) {
> +		if ((*agsize % *dsunit) != 0) {
>  			/*
>  			 * Round up to stripe unit boundary. Also make sure
>  			 * that agsize is still larger than
> -			 * XFS_AG_MIN_BLOCKS(blocklog)
> +			 * XFS_AG_MIN_BLOCKS(*blocklog)
>  		 	 */
> -			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
> +			tmp_agsize = ((*agsize + (*dsunit - 1))/ *dsunit) * *dsunit;
>  			/*
>  			 * Round down to stripe unit boundary if rounding up
>  			 * created an AG size that is larger than the AG max.
>  			 */
> -			if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
> -				tmp_agsize = ((agsize) / dsunit) * dsunit;
> +			if (tmp_agsize > XFS_AG_MAX_BLOCKS(*blocklog))
> +				tmp_agsize = ((*agsize) / *dsunit) * *dsunit;
>  
> -			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
> -			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
> -				agsize = tmp_agsize;
> +			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(*blocklog)) &&
> +			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(*blocklog))) {
> +				*agsize = tmp_agsize;
>  				if (!daflag)
> -					agcount = dblocks/agsize +
> -						(dblocks % agsize != 0);
> +					*agcount = dblocks/ *agsize +
> +						(dblocks % *agsize != 0);
>  				if (dasize)
>  					fprintf(stderr,
>  				_("agsize rounded to %lld, swidth = %d\n"),
> -						(long long)agsize, dswidth);
> +						(long long)*agsize, *dswidth);
>  			} else {
> -				if (nodsflag) {
> -					dsunit = dswidth = 0;
> +				if (*nodsflag) {
> +					*dsunit = *dswidth = 0;
>  				} else {
>  					/*
>  					 * agsize is out of bounds, this will
>  					 * print nice details & exit.
>  					 */
> -					validate_ag_geometry(blocklog, dblocks,
> -							    agsize, agcount);
> +					validate_ag_geometry(*blocklog, dblocks,
> +							    *agsize, *agcount);
>  					exit(1);
>  				}
>  			}
>  		}
> -		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
> +		if (*dswidth && ((*agsize % *dswidth) == 0) && (*agcount > 1)) {
>  			/* This is a non-optimal configuration because all AGs
>  			 * start on the same disk in the stripe.  Changing
>  			 * the AG size by one sunit will guarantee that this
>  			 * does not happen.
>  			 */
> -			tmp_agsize = agsize - dsunit;
> -			if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
> -				tmp_agsize = agsize + dsunit;
> -				if (dblocks < agsize) {
> +			tmp_agsize = *agsize - *dsunit;
> +			if (tmp_agsize < XFS_AG_MIN_BLOCKS(*blocklog)) {
> +				tmp_agsize = *agsize + *dsunit;
> +				if (dblocks < *agsize) {
>  					/* oh well, nothing to do */
> -					tmp_agsize = agsize;
> +					tmp_agsize = *agsize;
>  				}
>  			}
>  			if (daflag || dasize) {
> @@ -3207,30 +3271,30 @@ problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
>  an AG size that is one stripe unit smaller, for example %llu.\n"),
>  					(unsigned long long)tmp_agsize);
>  			} else {
> -				agsize = tmp_agsize;
> -				agcount = dblocks/agsize + (dblocks % agsize != 0);
> +				*agsize = tmp_agsize;
> +				*agcount = dblocks/ *agsize + (dblocks % *agsize != 0);
>  				/*
>  				 * If the last AG is too small, reduce the
>  				 * filesystem size and drop the blocks.
>  				 */
> -				if ( dblocks % agsize != 0 &&
> -				    (dblocks % agsize <
> -				    XFS_AG_MIN_BLOCKS(blocklog))) {
> -					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
> -					agcount--;
> -					ASSERT(agcount != 0);
> +				if ( dblocks % *agsize != 0 &&
> +				    (dblocks % *agsize <
> +				    XFS_AG_MIN_BLOCKS(*blocklog))) {
> +					dblocks = (xfs_rfsblock_t)((*agcount - 1) * *agsize);
> +					(*agcount)--;
> +					ASSERT(*agcount != 0);
>  				}
>  			}
>  		}
>  	} else {
> -		if (nodsflag)
> -			dsunit = dswidth = 0;
> +		if (*nodsflag)
> +			*dsunit = *dswidth = 0;
>  		else {
>  			fprintf(stderr,
>  				_("%s: Stripe unit(%d) or stripe width(%d) is "
>  				"not a multiple of the block size(%d)\n"),
> -				progname, BBTOB(dsunit), BBTOB(dswidth),
> -				blocksize);
> +				progname, BBTOB(*dsunit), BBTOB(*dswidth),
> +				*blocksize);
>  			exit(1);
>  		}
>  	}
> @@ -3239,82 +3303,83 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  	 * If the last AG is too small, reduce the filesystem size
>  	 * and drop the blocks.
>  	 */
> -	if ( dblocks % agsize != 0 &&
> -	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
> +	if ( dblocks % *agsize != 0 &&
> +	     (dblocks % *agsize < XFS_AG_MIN_BLOCKS(*blocklog))) {
>  		ASSERT(!daflag);
> -		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
> -		agcount--;
> -		ASSERT(agcount != 0);
> +		dblocks = (xfs_rfsblock_t)((*agcount - 1) * *agsize);
> +		(*agcount)--;
> +		ASSERT(*agcount != 0);
>  	}
>  
> -	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
> +	validate_ag_geometry(*blocklog, dblocks, *agsize, *agcount);
>  
>  	if (!imflag)
> -		imaxpct = calc_default_imaxpct(blocklog, dblocks);
> +		*imaxpct = calc_default_imaxpct(*blocklog, dblocks);
>  
>  	/*
> -	 * check that log sunit is modulo fsblksize or default it to dsunit.
> +	 * check that log sunit is modulo fsblksize or default it to *dsunit.
>  	 */
>  
> -	if (lsunit) {
> +	if (*lsunit) {
>  		/* convert from 512 byte blocks to fs blocks */
> -		lsunit = DTOBT(lsunit);
> -	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
> -		/* lsunit and dsunit now in fs blocks */
> -		lsunit = dsunit;
> +		*lsunit = DTOBT(*lsunit);
> +	} else if (sb_feat.log_version == 2 && *loginternal && *dsunit) {
> +		/* *lsunit and *dsunit now in fs blocks */
> +		*lsunit = *dsunit;
>  	}
>  
> -	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
> +	if (sb_feat.log_version == 2 && (*lsunit * *blocksize) > 256 * 1024) {
>  		/* Warn only if specified on commandline */
>  		if (lsuflag || lsunitflag) {
>  			fprintf(stderr,
>  	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
> -				(lsunit * blocksize));
> +				(*lsunit * *blocksize));
>  			fprintf(stderr,
>  	_("log stripe unit adjusted to 32KiB\n"));
>  		}
> -		lsunit = (32 * 1024) >> blocklog;
> +		*lsunit = (32 * 1024) >> *blocklog;
>  	}
>  
> -	min_logblocks = max_trans_res(agsize,
> +	min_logblocks = max_trans_res(*agsize,
>  				   sb_feat.crcs_enabled, sb_feat.dir_version,
> -				   sectorlog, blocklog, inodelog, dirblocklog,
> -				   sb_feat.log_version, lsunit, sb_feat.finobt,
> +				   sectorlog, *blocklog, *inodelog, *dirblocklog,
> +				   sb_feat.log_version, *lsunit, sb_feat.finobt,
>  				   sb_feat.rmapbt, sb_feat.reflink);
> +
>  	ASSERT(min_logblocks);
>  	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
> -	if (!logbytes && dblocks >= (1024*1024*1024) >> blocklog)
> -		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
> -	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
> +	if (!*logbytes && dblocks >= (1024*1024*1024) >> *blocklog)
> +		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>*blocklog);
> +	if (*logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
>  		fprintf(stderr,
>  _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"),
> -			(long long)logbytes, (long long)DTOBT(xi.logBBsize));
> +			(long long)*logbytes, (long long)DTOBT(xi.logBBsize));
>  		usage();
> -	} else if (!logbytes && xi.logBBsize > 0) {
> +	} else if (!*logbytes && xi.logBBsize > 0) {
>  		logblocks = DTOBT(xi.logBBsize);
> -	} else if (logbytes && !xi.logdev && !loginternal) {
> +	} else if (*logbytes && !xi.logdev && !*loginternal) {
>  		fprintf(stderr,
>  			_("size specified for non-existent log subvolume\n"));
>  		usage();
> -	} else if (loginternal && logbytes && logblocks >= dblocks) {
> +	} else if (*loginternal && *logbytes && logblocks >= dblocks) {
>  		fprintf(stderr, _("size %lld too large for internal log\n"),
>  			(long long)logblocks);
>  		usage();
> -	} else if (!loginternal && !xi.logdev) {
> +	} else if (!*loginternal && !xi.logdev) {
>  		logblocks = 0;
> -	} else if (loginternal && !logbytes) {
> +	} else if (*loginternal && !*logbytes) {
>  
> -		if (dblocks < GIGABYTES(1, blocklog)) {
> +		if (dblocks < GIGABYTES(1, *blocklog)) {
>  			/* tiny filesystems get minimum sized logs. */
>  			logblocks = min_logblocks;
> -		} else if (dblocks < GIGABYTES(16, blocklog)) {
> +		} else if (dblocks < GIGABYTES(16, *blocklog)) {
>  
>  			/*
>  			 * For small filesystems, we want to use the
>  			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
>  			 * at all possible, ramping up to 128MB at 256GB.
>  			 */
> -			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
> +			logblocks = MIN(XFS_MIN_LOG_BYTES >> *blocklog,
>  					min_logblocks * XFS_DFL_LOG_FACTOR);
>  		} else {
>  			/*
> @@ -3323,34 +3388,34 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  			 * max log size of 128M at 256GB fs size. IOWs,
>  			 * the ratio of fs size to log size is 2048:1.
>  			 */
> -			logblocks = (dblocks << blocklog) / 2048;
> -			logblocks = logblocks >> blocklog;
> +			logblocks = (dblocks << *blocklog) / 2048;
> +			logblocks = logblocks >> *blocklog;
>  		}
>  
>  		/* Ensure the chosen size meets minimum log size requirements */
>  		logblocks = MAX(min_logblocks, logblocks);
>  
>  		/* make sure the log fits wholly within an AG */
> -		if (logblocks >= agsize)
> +		if (logblocks >= *agsize)
>  			logblocks = min_logblocks;
>  
>  		/* and now clamp the size to the maximum supported size */
>  		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
> -		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
> -			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
> +		if ((logblocks << *blocklog) > XFS_MAX_LOG_BYTES)
> +			logblocks = XFS_MAX_LOG_BYTES >> *blocklog;
>  
>  	}
> -	validate_log_size(logblocks, blocklog, min_logblocks);
> +	validate_log_size(logblocks, *blocklog, min_logblocks);
>  
>  	protostring = setup_proto(protofile);
> -	bsize = 1 << (blocklog - BBSHIFT);
> +	bsize = 1 << (*blocklog - BBSHIFT);
>  	mp = &mbuf;
>  	sbp = &mp->m_sb;
>  	memset(mp, 0, sizeof(xfs_mount_t));
> -	sbp->sb_blocklog = (__uint8_t)blocklog;
> +	sbp->sb_blocklog = (__uint8_t)*blocklog;
>  	sbp->sb_sectlog = (__uint8_t)sectorlog;
> -	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
> -	sbp->sb_agblocks = (xfs_agblock_t)agsize;
> +	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)*agsize);
> +	sbp->sb_agblocks = (xfs_agblock_t)*agsize;
>  	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
>  	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
>  
> @@ -3358,22 +3423,22 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	 * sb_versionnum, finobt and rmapbt flags must be set before we use
>  	 * libxfs_prealloc_blocks().
>  	 */
> -	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
> +	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, *lsectorsize, *dsunit);
>  
>  
> -	if (loginternal) {
> +	if (*loginternal) {
>  		/*
>  		 * Readjust the log size to fit within an AG if it was sized
>  		 * automatically.
>  		 */
> -		if (!logbytes) {
> +		if (!*logbytes) {
>  			logblocks = MIN(logblocks,
>  					libxfs_alloc_ag_max_usable(mp));
>  
>  			/* revalidate the log size is valid if we changed it */
> -			validate_log_size(logblocks, blocklog, min_logblocks);
> +			validate_log_size(logblocks, *blocklog, min_logblocks);
>  		}
> -		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
> +		if (logblocks > *agsize - libxfs_prealloc_blocks(mp)) {
>  			fprintf(stderr,
>  	_("internal log size %lld too large, must fit in allocation group\n"),
>  				(long long)logblocks);
> @@ -3381,35 +3446,35 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		}
>  
>  		if (laflag) {
> -			if (logagno >= agcount) {
> +			if (*logagno >= *agcount) {
>  				fprintf(stderr,
>  		_("log ag number %d too large, must be less than %lld\n"),
> -					logagno, (long long)agcount);
> +					*logagno, (long long)*agcount);
>  				usage();
>  			}
>  		} else
> -			logagno = (xfs_agnumber_t)(agcount / 2);
> +			*logagno = (xfs_agnumber_t)(*agcount / 2);
>  
> -		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
> +		logstart = XFS_AGB_TO_FSB(mp, *logagno, libxfs_prealloc_blocks(mp));
>  		/*
>  		 * Align the logstart at stripe unit boundary.
>  		 */
> -		if (lsunit) {
> +		if (*lsunit) {
>  			logstart = fixup_internal_log_stripe(mp,
> -					lsflag, logstart, agsize, lsunit,
> -					&logblocks, blocklog, &lalign);
> -		} else if (dsunit) {
> +					lsflag, logstart, *agsize, *lsunit,
> +					&logblocks, *blocklog, &lalign);
> +		} else if (*dsunit) {
>  			logstart = fixup_internal_log_stripe(mp,
> -					lsflag, logstart, agsize, dsunit,
> -					&logblocks, blocklog, &lalign);
> +					lsflag, logstart, *agsize, *dsunit,
> +					&logblocks, *blocklog, &lalign);
>  		}
>  	} else {
>  		logstart = 0;
> -		if (lsunit)
> -			fixup_log_stripe_unit(lsflag, lsunit,
> -					&logblocks, blocklog);
> +		if (*lsunit)
> +			fixup_log_stripe_unit(lsflag, *lsunit,
> +					&logblocks, *blocklog);
>  	}
> -	validate_log_size(logblocks, blocklog, min_logblocks);
> +	validate_log_size(logblocks, *blocklog, min_logblocks);
>  
>  	if (!qflag || Nflag) {
>  		printf(_(
> @@ -3422,19 +3487,19 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
>  		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> -			dfile, isize, (long long)agcount, (long long)agsize,
> +			dfile, *isize, (long long)*agcount, (long long)*agsize,
>  			"", sectorsize, sb_feat.attr_version,
>  				    !sb_feat.projid16bit,
>  			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
>  			sb_feat.rmapbt, sb_feat.reflink,
> -			"", blocksize, (long long)dblocks, imaxpct,
> -			"", dsunit, dswidth,
> -			sb_feat.dir_version, dirblocksize, sb_feat.nci,
> +			"", *blocksize, (long long)dblocks, *imaxpct,
> +			"", *dsunit, *dswidth,
> +			sb_feat.dir_version, *dirblocksize, sb_feat.nci,
>  				sb_feat.dirftype,
> -			logfile, 1 << blocklog, (long long)logblocks,
> -			sb_feat.log_version, "", lsectorsize, lsunit,
> +			logfile, 1 << *blocklog, (long long)logblocks,
> +			sb_feat.log_version, "", *lsectorsize, *lsunit,
>  				sb_feat.lazy_sb_counters,
> -			rtfile, rtextblocks << blocklog,
> +			rtfile, rtextblocks << *blocklog,
>  			(long long)rtblocks, (long long)rtextents);
>  		if (Nflag)
>  			exit(0);
> @@ -3443,7 +3508,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	if (label)
>  		strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
>  	sbp->sb_magicnum = XFS_SB_MAGIC;
> -	sbp->sb_blocksize = blocksize;
> +	sbp->sb_blocksize = *blocksize;
>  	sbp->sb_dblocks = dblocks;
>  	sbp->sb_rblocks = rtblocks;
>  	sbp->sb_rextents = rtextents;
> @@ -3453,52 +3518,52 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	sbp->sb_logstart = logstart;
>  	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
>  	sbp->sb_rextsize = rtextblocks;
> -	sbp->sb_agcount = (xfs_agnumber_t)agcount;
> +	sbp->sb_agcount = (xfs_agnumber_t)*agcount;
>  	sbp->sb_rbmblocks = nbmblocks;
>  	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
>  	sbp->sb_sectsize = (__uint16_t)sectorsize;
> -	sbp->sb_inodesize = (__uint16_t)isize;
> -	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
> +	sbp->sb_inodesize = (__uint16_t)*isize;
> +	sbp->sb_inopblock = (__uint16_t)(*blocksize / *isize);
>  	sbp->sb_sectlog = (__uint8_t)sectorlog;
> -	sbp->sb_inodelog = (__uint8_t)inodelog;
> -	sbp->sb_inopblog = (__uint8_t)(blocklog - inodelog);
> +	sbp->sb_inodelog = (__uint8_t)*inodelog;
> +	sbp->sb_inopblog = (__uint8_t)(*blocklog - *inodelog);
>  	sbp->sb_rextslog =
>  		(__uint8_t)(rtextents ?
>  			libxfs_highbit32((unsigned int)rtextents) : 0);
>  	sbp->sb_inprogress = 1;	/* mkfs is in progress */
> -	sbp->sb_imax_pct = imaxpct;
> +	sbp->sb_imax_pct = *imaxpct;
>  	sbp->sb_icount = 0;
>  	sbp->sb_ifree = 0;
> -	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
> -		(loginternal ? logblocks : 0);
> +	sbp->sb_fdblocks = dblocks - *agcount * libxfs_prealloc_blocks(mp) -
> +		(*loginternal ? logblocks : 0);
>  	sbp->sb_frextents = 0;	/* will do a free later */
>  	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
>  	sbp->sb_qflags = 0;
> -	sbp->sb_unit = dsunit;
> -	sbp->sb_width = dswidth;
> -	sbp->sb_dirblklog = dirblocklog - blocklog;
> +	sbp->sb_unit = *dsunit;
> +	sbp->sb_width = *dswidth;
> +	sbp->sb_dirblklog = *dirblocklog - *blocklog;
>  	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
> -		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
> -		sbp->sb_logsunit = lsunit;
> +		*lsunit = (*lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, *lsunit);
> +		sbp->sb_logsunit = *lsunit;
>  	} else
>  		sbp->sb_logsunit = 0;
>  	if (sb_feat.inode_align) {
>  		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
>  		if (sb_feat.crcs_enabled)
> -			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
> -		sbp->sb_inoalignmt = cluster_size >> blocklog;
> +			cluster_size *= *isize / XFS_DINODE_MIN_SIZE;
> +		sbp->sb_inoalignmt = cluster_size >> *blocklog;
>  		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
>  	} else
>  		sbp->sb_inoalignmt = 0;
> -	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
> -		sbp->sb_logsectlog = (__uint8_t)lsectorlog;
> -		sbp->sb_logsectsize = (__uint16_t)lsectorsize;
> +	if (*lsectorsize != BBSIZE || sectorsize != BBSIZE) {
> +		sbp->sb_logsectlog = (__uint8_t)*lsectorlog;
> +		sbp->sb_logsectsize = (__uint16_t)*lsectorsize;
>  	} else {
>  		sbp->sb_logsectlog = 0;
>  		sbp->sb_logsectsize = 0;
>  	}
>  
> -	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
> +	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, *lsectorsize, *dsunit);
>  
>  	if (force_overwrite)
>  		zero_old_xfs_structures(&xi, sbp);
> @@ -3528,8 +3593,8 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	 * if needed so that the reads for the end of the device in the mount
>  	 * code will succeed.
>  	 */
> -	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
> -		if (ftruncate(xi.dfd, dblocks * blocksize) < 0) {
> +	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * *blocksize) {
> +		if (ftruncate(xi.dfd, dblocks * *blocksize) < 0) {
>  			fprintf(stderr,
>  				_("%s: Growing the data section failed\n"),
>  				progname);
> @@ -3557,7 +3622,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	libxfs_log_clear(mp->m_logdev_targp, NULL,
>  		XFS_FSB_TO_DADDR(mp, logstart),
>  		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
> -		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
> +		&sbp->sb_uuid, sb_feat.log_version, *lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
>  
>  	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
>  	if (mp == NULL) {
> @@ -3571,7 +3636,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	 * These initialisations should be pulled into libxfs to keep the
>  	 * kernel/userspace header initialisation code the same.
>  	 */
> -	for (agno = 0; agno < agcount; agno++) {
> +	for (agno = 0; agno < *agcount; agno++) {
>  		struct xfs_agfl	*agfl;
>  		int		bucket;
>  		struct xfs_perag *pag = libxfs_perag_get(mp, agno);
> @@ -3596,12 +3661,12 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		buf->b_ops = &xfs_agf_buf_ops;
>  		agf = XFS_BUF_TO_AGF(buf);
>  		memset(agf, 0, sectorsize);
> -		if (agno == agcount - 1)
> -			agsize = dblocks - (xfs_rfsblock_t)(agno * agsize);
> +		if (agno == *agcount - 1)
> +			*agsize = dblocks - (xfs_rfsblock_t)(agno * *agsize);
>  		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
>  		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
>  		agf->agf_seqno = cpu_to_be32(agno);
> -		agf->agf_length = cpu_to_be32(agsize);
> +		agf->agf_length = cpu_to_be32(*agsize);
>  		agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
>  		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
>  		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
> @@ -3623,15 +3688,15 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		agf->agf_flfirst = 0;
>  		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
>  		agf->agf_flcount = 0;
> -		nbmblocks = (xfs_extlen_t)(agsize - libxfs_prealloc_blocks(mp));
> +		nbmblocks = (xfs_extlen_t)(*agsize - libxfs_prealloc_blocks(mp));
>  		agf->agf_freeblks = cpu_to_be32(nbmblocks);
>  		agf->agf_longest = cpu_to_be32(nbmblocks);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
>  
> -		if (loginternal && agno == logagno) {
> +		if (*loginternal && agno == *logagno) {
>  			be32_add_cpu(&agf->agf_freeblks, -logblocks);
> -			agf->agf_longest = cpu_to_be32(agsize -
> +			agf->agf_longest = cpu_to_be32(*agsize -
>  				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
>  		}
>  		if (libxfs_alloc_min_freelist(mp, pag) > worst_freelist)
> @@ -3670,7 +3735,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
>  		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
>  		agi->agi_seqno = cpu_to_be32(agno);
> -		agi->agi_length = cpu_to_be32((xfs_agblock_t)agsize);
> +		agi->agi_length = cpu_to_be32((xfs_agblock_t)*agsize);
>  		agi->agi_count = 0;
>  		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
>  		agi->agi_level = cpu_to_be32(1);
> @@ -3695,7 +3760,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  				bsize);
>  		buf->b_ops = &xfs_allocbt_buf_ops;
>  		block = XFS_BUF_TO_BLOCK(buf);
> -		memset(block, 0, blocksize);
> +		memset(block, 0, *blocksize);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			libxfs_btree_init_block(mp, buf, XFS_ABTB_CRC_MAGIC, 0, 1,
>  						agno, XFS_BTREE_CRC_BLOCKS);
> @@ -3705,7 +3770,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
>  		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
> -		if (loginternal && agno == logagno) {
> +		if (*loginternal && agno == *logagno) {
>  			if (lalign) {
>  				/*
>  				 * Have to insert two records
> @@ -3735,7 +3800,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		 * so, reset the record count to 0 to avoid exposure of an invalid
>  		 * record start block.
>  		 */
> -		arec->ar_blockcount = cpu_to_be32(agsize -
> +		arec->ar_blockcount = cpu_to_be32(*agsize -
>  					be32_to_cpu(arec->ar_startblock));
>  		if (!arec->ar_blockcount)
>  			block->bb_numrecs = 0;
> @@ -3750,7 +3815,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  				bsize);
>  		buf->b_ops = &xfs_allocbt_buf_ops;
>  		block = XFS_BUF_TO_BLOCK(buf);
> -		memset(block, 0, blocksize);
> +		memset(block, 0, *blocksize);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			libxfs_btree_init_block(mp, buf, XFS_ABTC_CRC_MAGIC, 0, 1,
>  						agno, XFS_BTREE_CRC_BLOCKS);
> @@ -3760,7 +3825,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
>  		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
> -		if (loginternal && agno == logagno) {
> +		if (*loginternal && agno == *logagno) {
>  			if (lalign) {
>  				arec->ar_blockcount = cpu_to_be32(
>  					XFS_FSB_TO_AGBNO(mp, logstart) -
> @@ -3780,7 +3845,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  		 * so, reset the record count to 0 to avoid exposure of an invalid
>  		 * record start block.
>  		 */
> -		arec->ar_blockcount = cpu_to_be32(agsize -
> +		arec->ar_blockcount = cpu_to_be32(*agsize -
>  					be32_to_cpu(arec->ar_startblock));
>  		if (!arec->ar_blockcount)
>  			block->bb_numrecs = 0;
> @@ -3798,7 +3863,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  			buf->b_ops = &xfs_refcountbt_buf_ops;
>  
>  			block = XFS_BUF_TO_BLOCK(buf);
> -			memset(block, 0, blocksize);
> +			memset(block, 0, *blocksize);
>  			libxfs_btree_init_block(mp, buf, XFS_REFC_CRC_MAGIC, 0,
>  						0, agno, XFS_BTREE_CRC_BLOCKS);
>  
> @@ -3813,7 +3878,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  				bsize);
>  		buf->b_ops = &xfs_inobt_buf_ops;
>  		block = XFS_BUF_TO_BLOCK(buf);
> -		memset(block, 0, blocksize);
> +		memset(block, 0, *blocksize);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			libxfs_btree_init_block(mp, buf, XFS_IBT_CRC_MAGIC, 0, 0,
>  						agno, XFS_BTREE_CRC_BLOCKS);
> @@ -3831,7 +3896,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  					bsize);
>  			buf->b_ops = &xfs_inobt_buf_ops;
>  			block = XFS_BUF_TO_BLOCK(buf);
> -			memset(block, 0, blocksize);
> +			memset(block, 0, *blocksize);
>  			if (xfs_sb_version_hascrc(&mp->m_sb))
>  				libxfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
>  							agno, XFS_BTREE_CRC_BLOCKS);
> @@ -3850,7 +3915,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  				bsize);
>  			buf->b_ops = &xfs_rmapbt_buf_ops;
>  			block = XFS_BUF_TO_BLOCK(buf);
> -			memset(block, 0, blocksize);
> +			memset(block, 0, *blocksize);
>  
>  			libxfs_btree_init_block(mp, buf, XFS_RMAP_CRC_MAGIC, 0, 0,
>  						agno, XFS_BTREE_CRC_BLOCKS);
> @@ -3905,7 +3970,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  			}
>  
>  			/* account for the log space */
> -			if (loginternal && agno == logagno) {
> +			if (*loginternal && agno == *logagno) {
>  				rrec = XFS_RMAP_REC_ADDR(block,
>  					be16_to_cpu(block->bb_numrecs) + 1);
>  				rrec->rm_startblock = cpu_to_be32(
> @@ -3927,7 +3992,7 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	 */
>  	buf = libxfs_getbuf(mp->m_ddev_targp,
>  		(xfs_daddr_t)XFS_FSB_TO_BB(mp, dblocks - 1LL), bsize);
> -	memset(XFS_BUF_PTR(buf), 0, blocksize);
> +	memset(XFS_BUF_PTR(buf), 0, *blocksize);
>  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  
>  	/*
> @@ -3936,14 +4001,14 @@ _("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"
>  	if (mp->m_rtdev_targp->dev && rtblocks > 0) {
>  		buf = libxfs_getbuf(mp->m_rtdev_targp,
>  				XFS_FSB_TO_BB(mp, rtblocks - 1LL), bsize);
> -		memset(XFS_BUF_PTR(buf), 0, blocksize);
> +		memset(XFS_BUF_PTR(buf), 0, *blocksize);
>  		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  	}
>  
>  	/*
>  	 * BNO, CNT free block list
>  	 */
> -	for (agno = 0; agno < agcount; agno++) {
> +	for (agno = 0; agno < *agcount; agno++) {
>  		xfs_alloc_arg_t	args;
>  		xfs_trans_t	*tp;
>  		struct xfs_trans_res tres = {0};
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

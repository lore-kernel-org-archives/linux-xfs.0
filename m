Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35476 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeABRql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 12:46:41 -0500
Date: Tue, 2 Jan 2018 09:41:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] mkfs: pass switch case value directly into
 getnum/getstr
Message-ID: <20180102174136.GB4857@magnolia>
References: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
 <8d4ef402-e625-3f14-5848-499b9ff82923@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d4ef402-e625-3f14-5848-499b9ff82923@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Dec 24, 2017 at 11:10:21AM -0800, Eric Sandeen wrote:
> Parsing did does sort of thing:

'Parsing does this sort of thing:'?

> 
> 	case D_AGCOUNT:
> 		cli->agcount = getnum(value, opts, D_AGCOUNT);
> 
> which is just begging for a cut and paste error between the
> case value and the enum passed into getnum/getstr.  Pass
> "subopt" instead so that it is always consistent with the case.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1f3494c..035af03 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1400,7 +1400,7 @@ block_opts_parser(
>  {
>  	switch (subopt) {
>  	case B_SIZE:
> -		cli->blocksize = getnum(value, opts, B_SIZE);
> +		cli->blocksize = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1417,52 +1417,52 @@ data_opts_parser(
>  {
>  	switch (subopt) {
>  	case D_AGCOUNT:
> -		cli->agcount = getnum(value, opts, D_AGCOUNT);
> +		cli->agcount = getnum(value, opts, subopt);
>  		break;
>  	case D_AGSIZE:
> -		cli->agsize = getstr(value, opts, D_AGSIZE);
> +		cli->agsize = getstr(value, opts, subopt);
>  		break;
>  	case D_FILE:
> -		cli->xi->disfile = getnum(value, opts, D_FILE);
> +		cli->xi->disfile = getnum(value, opts, subopt);
>  		break;
>  	case D_NAME:
> -		cli->xi->dname = getstr(value, opts, D_NAME);
> +		cli->xi->dname = getstr(value, opts, subopt);
>  		break;
>  	case D_SIZE:
> -		cli->dsize = getstr(value, opts, D_SIZE);
> +		cli->dsize = getstr(value, opts, subopt);
>  		break;
>  	case D_SUNIT:
> -		cli->dsunit = getnum(value, opts, D_SUNIT);
> +		cli->dsunit = getnum(value, opts, subopt);
>  		break;
>  	case D_SWIDTH:
> -		cli->dswidth = getnum(value, opts, D_SWIDTH);
> +		cli->dswidth = getnum(value, opts, subopt);
>  		break;
>  	case D_SU:
> -		cli->dsu = getstr(value, opts, D_SU);
> +		cli->dsu = getstr(value, opts, subopt);
>  		break;
>  	case D_SW:
> -		cli->dsw = getnum(value, opts, D_SW);
> +		cli->dsw = getnum(value, opts, subopt);
>  		break;
>  	case D_NOALIGN:
> -		cli->sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
> +		cli->sb_feat.nodalign = getnum(value, opts, subopt);
>  		break;
>  	case D_SECTSIZE:
> -		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
> +		cli->sectorsize = getnum(value, opts, subopt);
>  		break;
>  	case D_RTINHERIT:
> -		if (getnum(value, opts, D_RTINHERIT))
> +		if (getnum(value, opts, subopt))
>  			cli->fsx.fsx_xflags |= XFS_DIFLAG_RTINHERIT;
>  		break;
>  	case D_PROJINHERIT:
> -		cli->fsx.fsx_projid = getnum(value, opts, D_PROJINHERIT);
> +		cli->fsx.fsx_projid = getnum(value, opts, subopt);
>  		cli->fsx.fsx_xflags |= XFS_DIFLAG_PROJINHERIT;
>  		break;
>  	case D_EXTSZINHERIT:
> -		cli->fsx.fsx_extsize = getnum(value, opts, D_EXTSZINHERIT);
> +		cli->fsx.fsx_extsize = getnum(value, opts, subopt);
>  		cli->fsx.fsx_xflags |= XFS_DIFLAG_EXTSZINHERIT;
>  		break;
>  	case D_COWEXTSIZE:
> -		cli->fsx.fsx_cowextsize = getnum(value, opts, D_COWEXTSIZE);
> +		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
>  		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
>  		break;
>  	default:
> @@ -1480,25 +1480,25 @@ inode_opts_parser(
>  {
>  	switch (subopt) {
>  	case I_ALIGN:
> -		cli->sb_feat.inode_align = getnum(value, opts, I_ALIGN);
> +		cli->sb_feat.inode_align = getnum(value, opts, subopt);
>  		break;
>  	case I_MAXPCT:
> -		cli->imaxpct = getnum(value, opts, I_MAXPCT);
> +		cli->imaxpct = getnum(value, opts, subopt);
>  		break;
>  	case I_PERBLOCK:
> -		cli->inopblock = getnum(value, opts, I_PERBLOCK);
> +		cli->inopblock = getnum(value, opts, subopt);
>  		break;
>  	case I_SIZE:
> -		cli->inodesize = getnum(value, opts, I_SIZE);
> +		cli->inodesize = getnum(value, opts, subopt);
>  		break;
>  	case I_ATTR:
> -		cli->sb_feat.attr_version = getnum(value, opts, I_ATTR);
> +		cli->sb_feat.attr_version = getnum(value, opts, subopt);
>  		break;
>  	case I_PROJID32BIT:
> -		cli->sb_feat.projid32bit = getnum(value, opts, I_PROJID32BIT);
> +		cli->sb_feat.projid32bit = getnum(value, opts, subopt);
>  		break;
>  	case I_SPINODES:
> -		cli->sb_feat.spinodes = getnum(value, opts, I_SPINODES);
> +		cli->sb_feat.spinodes = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1515,36 +1515,36 @@ log_opts_parser(
>  {
>  	switch (subopt) {
>  	case L_AGNUM:
> -		cli->logagno = getnum(value, opts, L_AGNUM);
> +		cli->logagno = getnum(value, opts, subopt);
>  		break;
>  	case L_FILE:
> -		cli->xi->lisfile = getnum(value, opts, L_FILE);
> +		cli->xi->lisfile = getnum(value, opts, subopt);
>  		break;
>  	case L_INTERNAL:
> -		cli->loginternal = getnum(value, opts, L_INTERNAL);
> +		cli->loginternal = getnum(value, opts, subopt);
>  		break;
>  	case L_SU:
> -		cli->lsu = getstr(value, opts, L_SU);
> +		cli->lsu = getstr(value, opts, subopt);
>  		break;
>  	case L_SUNIT:
> -		cli->lsunit = getnum(value, opts, L_SUNIT);
> +		cli->lsunit = getnum(value, opts, subopt);
>  		break;
>  	case L_NAME:
>  	case L_DEV:
> -		cli->xi->logname = getstr(value, opts, L_NAME);
> +		cli->xi->logname = getstr(value, opts, subopt);
>  		cli->loginternal = 0;
>  		break;
>  	case L_VERSION:
> -		cli->sb_feat.log_version = getnum(value, opts, L_VERSION);
> +		cli->sb_feat.log_version = getnum(value, opts, subopt);
>  		break;
>  	case L_SIZE:
> -		cli->logsize = getstr(value, opts, L_SIZE);
> +		cli->logsize = getstr(value, opts, subopt);
>  		break;
>  	case L_SECTSIZE:
> -		cli->lsectorsize = getnum(value, opts, L_SECTSIZE);
> +		cli->lsectorsize = getnum(value, opts, subopt);
>  		break;
>  	case L_LAZYSBCNTR:
> -		cli->sb_feat.lazy_sb_counters = getnum(value, opts, L_LAZYSBCNTR);
> +		cli->sb_feat.lazy_sb_counters = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1561,24 +1561,24 @@ meta_opts_parser(
>  {
>  	switch (subopt) {
>  	case M_CRC:
> -		cli->sb_feat.crcs_enabled = getnum(value, opts, M_CRC);
> +		cli->sb_feat.crcs_enabled = getnum(value, opts, subopt);
>  		if (cli->sb_feat.crcs_enabled)
>  			cli->sb_feat.dirftype = true;
>  		break;
>  	case M_FINOBT:
> -		cli->sb_feat.finobt = getnum(value, opts, M_FINOBT);
> +		cli->sb_feat.finobt = getnum(value, opts, subopt);
>  		break;
>  	case M_UUID:
>  		if (!value || *value == '\0')
> -			reqval('m', opts->subopts, M_UUID);
> +			reqval('m', opts->subopts, subopt);
>  		if (platform_uuid_parse(value, &cli->uuid))
>  			illegal(value, "m uuid");
>  		break;
>  	case M_RMAPBT:
> -		cli->sb_feat.rmapbt = getnum(value, opts, M_RMAPBT);
> +		cli->sb_feat.rmapbt = getnum(value, opts, subopt);
>  		break;
>  	case M_REFLINK:
> -		cli->sb_feat.reflink = getnum(value, opts, M_REFLINK);
> +		cli->sb_feat.reflink = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1595,19 +1595,19 @@ naming_opts_parser(
>  {
>  	switch (subopt) {
>  	case N_SIZE:
> -		cli->dirblocksize = getstr(value, opts, N_SIZE);
> +		cli->dirblocksize = getstr(value, opts, subopt);
>  		break;
>  	case N_VERSION:
> -		value = getstr(value, &nopts, N_VERSION);
> +		value = getstr(value, &nopts, subopt);
>  		if (!strcasecmp(value, "ci")) {
>  			/* ASCII CI mode */
>  			cli->sb_feat.nci = true;
>  		} else {
> -			cli->sb_feat.dir_version = getnum(value, opts, N_VERSION);
> +			cli->sb_feat.dir_version = getnum(value, opts, subopt);
>  		}
>  		break;
>  	case N_FTYPE:
> -		cli->sb_feat.dirftype = getnum(value, opts, N_FTYPE);
> +		cli->sb_feat.dirftype = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1624,20 +1624,20 @@ rtdev_opts_parser(
>  {
>  	switch (subopt) {
>  	case R_EXTSIZE:
> -		cli->rtextsize = getstr(value, opts, R_EXTSIZE);
> +		cli->rtextsize = getstr(value, opts, subopt);
>  		break;
>  	case R_FILE:
> -		cli->xi->risfile = getnum(value, opts, R_FILE);
> +		cli->xi->risfile = getnum(value, opts, subopt);
>  		break;
>  	case R_NAME:
>  	case R_DEV:
> -		cli->xi->rtname = getstr(value, opts, R_NAME);
> +		cli->xi->rtname = getstr(value, opts, subopt);
>  		break;
>  	case R_SIZE:
> -		cli->rtsize = getstr(value, opts, R_SIZE);
> +		cli->rtsize = getstr(value, opts, subopt);
>  		break;
>  	case R_NOALIGN:
> -		cli->sb_feat.nortalign = getnum(value, opts, R_NOALIGN);
> +		cli->sb_feat.nortalign = getnum(value, opts, subopt);
>  		break;
>  	default:
>  		return -EINVAL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

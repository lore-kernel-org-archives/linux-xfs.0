Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50110 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdLTC4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 21:56:44 -0500
Date: Tue, 19 Dec 2017 18:56:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/7] mkfs: convert subopt name,val pairs to enums and
 declared arrays
Message-ID: <20171220025640.GM12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218091158.14537-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:11:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Replace the nasty #define + implicit array index definitions with
> pre-declared enums and index specific name array declarations.
> 
> This cleans up the code quite a bit and the pre-declaration of the
> enums allows tables to use indexes from other tables in things like
> conflict specifications.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mkfs/xfs_mkfs.c | 276 +++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 153 insertions(+), 123 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2272700807dc..4b79c03e442b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -46,7 +46,102 @@
>  unsigned int		blocksize;
>  unsigned int		sectorsize;
>  
> -#define MAX_SUBOPTS	17
> +/*
> + * Enums for each CLI parameter type are declared first so we can calculate the
> + * maximum array size needed to hold them automatically.
> + */
> +enum {
> +	B_LOG = 0,
> +	B_SIZE,
> +	B_MAX_OPTS,
> +};
> +
> +enum {
> +	D_AGCOUNT = 0,
> +	D_FILE,
> +	D_NAME,
> +	D_SIZE,
> +	D_SUNIT,
> +	D_SWIDTH,
> +	D_AGSIZE,
> +	D_SU,
> +	D_SW,
> +	D_SECTLOG,
> +	D_SECTSIZE,
> +	D_NOALIGN,
> +	D_RTINHERIT,
> +	D_PROJINHERIT,
> +	D_EXTSZINHERIT,
> +	D_COWEXTSIZE,
> +	D_MAX_OPTS,
> +};
> +
> +enum {
> +	I_ALIGN = 0,
> +	I_LOG,
> +	I_MAXPCT,
> +	I_PERBLOCK,
> +	I_SIZE,
> +	I_ATTR,
> +	I_PROJID32BIT,
> +	I_SPINODES,
> +	I_MAX_OPTS,
> +};
> +
> +enum {
> +	L_AGNUM = 0,
> +	L_INTERNAL,
> +	L_SIZE,
> +	L_VERSION,
> +	L_SUNIT,
> +	L_SU,
> +	L_DEV,
> +	L_SECTLOG,
> +	L_SECTSIZE,
> +	L_FILE,
> +	L_NAME,
> +	L_LAZYSBCNTR,
> +	L_MAX_OPTS,
> +};
> +
> +enum {
> +	N_LOG = 0,
> +	N_SIZE,
> +	N_VERSION,
> +	N_FTYPE,
> +	N_MAX_OPTS,
> +};
> +
> +enum {
> +	R_EXTSIZE = 0,
> +	R_SIZE,
> +	R_DEV,
> +	R_FILE,
> +	R_NAME,
> +	R_NOALIGN,
> +	R_MAX_OPTS,
> +};
> +
> +enum {
> +	S_LOG = 0,
> +	S_SECTLOG,
> +	S_SIZE,
> +	S_SECTSIZE,
> +	S_MAX_OPTS,
> +};
> +
> +enum {
> +	M_CRC = 0,
> +	M_FINOBT,
> +	M_UUID,
> +	M_RMAPBT,
> +	M_REFLINK,
> +	M_MAX_OPTS,
> +};
> +
> +/* Just define the max options array size manually right now */
> +#define MAX_SUBOPTS	D_MAX_OPTS
> +
>  #define SUBOPT_NEEDS_VAL	(-1LL)
>  #define MAX_CONFLICTS	8
>  #define LAST_CONFLICT	(-1)
> @@ -138,11 +233,8 @@ struct opt_params {
>  struct opt_params bopts = {
>  	.name = 'b',
>  	.subopts = {
> -#define	B_LOG		0
> -		"log",
> -#define	B_SIZE		1
> -		"size",
> -		NULL
> +		[B_LOG] = "log",
> +		[B_SIZE] = "size",
>  	},
>  	.subopt_params = {
>  		{ .index = B_LOG,
> @@ -167,39 +259,22 @@ struct opt_params bopts = {
>  struct opt_params dopts = {
>  	.name = 'd',
>  	.subopts = {
> -#define	D_AGCOUNT	0
> -		"agcount",
> -#define	D_FILE		1
> -		"file",
> -#define	D_NAME		2
> -		"name",
> -#define	D_SIZE		3
> -		"size",
> -#define D_SUNIT		4
> -		"sunit",
> -#define D_SWIDTH	5
> -		"swidth",
> -#define D_AGSIZE	6
> -		"agsize",
> -#define D_SU		7
> -		"su",
> -#define D_SW		8
> -		"sw",
> -#define D_SECTLOG	9
> -		"sectlog",
> -#define D_SECTSIZE	10
> -		"sectsize",
> -#define D_NOALIGN	11
> -		"noalign",
> -#define D_RTINHERIT	12
> -		"rtinherit",
> -#define D_PROJINHERIT	13
> -		"projinherit",
> -#define D_EXTSZINHERIT	14
> -		"extszinherit",
> -#define D_COWEXTSIZE	15
> -		"cowextsize",
> -		NULL
> +		[D_AGCOUNT] = "agcount",
> +		[D_FILE] = "file",
> +		[D_NAME] = "name",
> +		[D_SIZE] = "size",
> +		[D_SUNIT] = "sunit",
> +		[D_SWIDTH] = "swidth",
> +		[D_AGSIZE] = "agsize",
> +		[D_SU] = "su",
> +		[D_SW] = "sw",
> +		[D_SECTLOG] = "sectlog",
> +		[D_SECTSIZE] = "sectsize",
> +		[D_NOALIGN] = "noalign",
> +		[D_RTINHERIT] = "rtinherit",
> +		[D_PROJINHERIT] = "projinherit",
> +		[D_EXTSZINHERIT] = "extszinherit",
> +		[D_COWEXTSIZE] = "cowextsize",
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> @@ -328,23 +403,14 @@ struct opt_params dopts = {
>  struct opt_params iopts = {
>  	.name = 'i',
>  	.subopts = {
> -#define	I_ALIGN		0
> -		"align",
> -#define	I_LOG		1
> -		"log",
> -#define	I_MAXPCT	2
> -		"maxpct",
> -#define	I_PERBLOCK	3
> -		"perblock",
> -#define	I_SIZE		4
> -		"size",
> -#define	I_ATTR		5
> -		"attr",
> -#define	I_PROJID32BIT	6
> -		"projid32bit",
> -#define I_SPINODES	7
> -		"sparse",
> -		NULL
> +		[I_ALIGN] = "align",
> +		[I_LOG] = "log",
> +		[I_MAXPCT] = "maxpct",
> +		[I_PERBLOCK] = "perblock",
> +		[I_SIZE] = "size",
> +		[I_ATTR] = "attr",
> +		[I_PROJID32BIT] = "projid32bit",
> +		[I_SPINODES] = "sparse",
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> @@ -409,31 +475,18 @@ struct opt_params iopts = {
>  struct opt_params lopts = {
>  	.name = 'l',
>  	.subopts = {
> -#define	L_AGNUM		0
> -		"agnum",
> -#define	L_INTERNAL	1
> -		"internal",
> -#define	L_SIZE		2
> -		"size",
> -#define L_VERSION	3
> -		"version",
> -#define L_SUNIT		4
> -		"sunit",
> -#define L_SU		5
> -		"su",
> -#define L_DEV		6
> -		"logdev",
> -#define	L_SECTLOG	7
> -		"sectlog",
> -#define	L_SECTSIZE	8
> -		"sectsize",
> -#define	L_FILE		9
> -		"file",
> -#define	L_NAME		10
> -		"name",
> -#define	L_LAZYSBCNTR	11
> -		"lazy-count",
> -		NULL
> +		[L_AGNUM] = "agnum",
> +		[L_INTERNAL] = "internal",
> +		[L_SIZE] = "size",
> +		[L_VERSION] = "version",
> +		[L_SUNIT] = "sunit",
> +		[L_SU] = "su",
> +		[L_DEV] = "logdev",
> +		[L_SECTLOG] = "sectlog",
> +		[L_SECTSIZE] = "sectsize",
> +		[L_FILE] = "file",
> +		[L_NAME] = "name",
> +		[L_LAZYSBCNTR] = "lazy-count",
>  	},
>  	.subopt_params = {
>  		{ .index = L_AGNUM,
> @@ -530,15 +583,10 @@ struct opt_params lopts = {
>  struct opt_params nopts = {
>  	.name = 'n',
>  	.subopts = {
> -#define	N_LOG		0
> -		"log",
> -#define	N_SIZE		1
> -		"size",
> -#define	N_VERSION	2
> -		"version",
> -#define	N_FTYPE		3
> -		"ftype",
> -	NULL,
> +		[N_LOG] = "log",
> +		[N_SIZE] = "size",
> +		[N_VERSION] = "version",
> +		[N_FTYPE] = "ftype",
>  	},
>  	.subopt_params = {
>  		{ .index = N_LOG,
> @@ -575,19 +623,12 @@ struct opt_params nopts = {
>  struct opt_params ropts = {
>  	.name = 'r',
>  	.subopts = {
> -#define	R_EXTSIZE	0
> -		"extsize",
> -#define	R_SIZE		1
> -		"size",
> -#define	R_DEV		2
> -		"rtdev",
> -#define	R_FILE		3
> -		"file",
> -#define	R_NAME		4
> -		"name",
> -#define R_NOALIGN	5
> -		"noalign",
> -		NULL
> +		[R_EXTSIZE] = "extsize",
> +		[R_SIZE] = "size",
> +		[R_DEV] = "rtdev",
> +		[R_FILE] = "file",
> +		[R_NAME] = "name",
> +		[R_NOALIGN] = "noalign",
>  	},
>  	.subopt_params = {
>  		{ .index = R_EXTSIZE,
> @@ -630,15 +671,10 @@ struct opt_params ropts = {
>  struct opt_params sopts = {
>  	.name = 's',
>  	.subopts = {
> -#define	S_LOG		0
> -		"log",
> -#define	S_SECTLOG	1
> -		"sectlog",
> -#define	S_SIZE		2
> -		"size",
> -#define	S_SECTSIZE	3
> -		"sectsize",
> -		NULL
> +		[S_LOG] = "log",
> +		[S_SECTLOG] = "sectlog",
> +		[S_SIZE] = "size",
> +		[S_SECTSIZE] = "sectsize",
>  	},
>  	.subopt_params = {
>  		{ .index = S_LOG,
> @@ -683,17 +719,11 @@ struct opt_params sopts = {
>  struct opt_params mopts = {
>  	.name = 'm',
>  	.subopts = {
> -#define	M_CRC		0
> -		"crc",
> -#define M_FINOBT	1
> -		"finobt",
> -#define M_UUID		2
> -		"uuid",
> -#define M_RMAPBT	3
> -		"rmapbt",
> -#define M_REFLINK	4
> -		"reflink",
> -		NULL
> +		[M_CRC] = "crc",
> +		[M_FINOBT] = "finobt",
> +		[M_UUID] = "uuid",
> +		[M_RMAPBT] = "rmapbt",
> +		[M_REFLINK] = "reflink",
>  	},
>  	.subopt_params = {
>  		{ .index = M_CRC,
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

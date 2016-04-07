Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DC327CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 22:15:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53769AC004
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 20:15:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uF1xza9ZZbPH9aXM for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 20:14:55 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5E06016C152
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 22:14:54 -0500 (CDT)
Subject: Re: [PATCH 07/19] mkfs: structify input parameter passing
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-8-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5705D0AD.9060106@sandeen.net>
Date: Wed, 6 Apr 2016 22:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-8-git-send-email-jtulak@redhat.com>
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
> CHANGELOG:
> o Add a description of the new opt_params structure.
> o Fix indenting
> o Add missing I_SPINODES to subopt_params
> o Add a check for undefined minval/maxval into getnum_checked
> o Drop "const" from struct opt_params - it would be removed in a later
>   patch anyway
> 
> Passing large number of parameters around to number conversion
> functions is painful. Add a structure to encapsulate the constant
> parameters that are passed, and convert getnum_checked to use it.
> 
> This is the first real step towards a table driven option parser.

All the code looks ok, nitpicks on docs below.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 650 ++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 439 insertions(+), 211 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dda076d..6e29848 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -48,147 +48,361 @@ static int  ispow2(unsigned int i);
>  static long long cvtnum(unsigned int blocksize,
>  			unsigned int sectorsize, const char *s);
>  
> +#define MAX_SUBOPTS	16
>  /*
> - * option tables for getsubopt calls
> + * Table for parsing mkfs parameters.
> + *
> + * Description of the structure members follows:
> + *
> + * name MANDATORY
> + *   Name is a single char, e.g., for '-d file', name is 'd'.
> + *
> + * subopts MANDATORY
> + *   Subopts is a list of strings naming suboptions. In the example above,
> + *   it would contain "file". The last entry of this list has to be NULL.
> + *
> + * subopt_params MANDATORY
> + *   This is a list of structs tied with subopts. For each entry in subopts,
> + *   a coresponding entry has to be defined:

"corresponding"

> + *
> + * subopt_params struct:
> + *   index MANDATORY
> + *     This number, starting from zero, denotes which item in subopt_params
> + *     it is. The index has to be the same as is the order in subopts list,
> + *     so we can access the right item both in subopt_param and subopts.
> + *
> + *   minval, maxval OPTIONAL
> + *     These options are used for automatic range check and they have to be
> + *     always used together in pair. If you don't want to limit the max value,
> + *     use something like UINT_MAX. If no value is given, then you either has

then you must either supply your own validation, or ...

> + *     to supply your own validation, or refuse any value in the 'case
> + *     X_SOMETHING' block. If you forget to pass a min or max value here, but

forget to define a min and max value (?)

> + *     call a standard function for validating user's value, it will cause an
> + *     error message notifying you about this issue.
> + *
> + *     (Said in another way, you can't have minval and maxval both equal
> + *     to zero. But if one value is different: minval=0 and maxval=1,
> + *     then it is OK.)

I think that makes sense ... by the time I got to the end of this I was a
little confused.  ;)

So you don't have to define min/max, but if you call getnum_checked(), then
min & max are required, and they can't both be zero - is that correct?

Thanks,
-Eric

>   */
> -char *bopts[] = {
> +struct opt_params {
> +	const char	name;
> +	const char	*subopts[MAX_SUBOPTS];
> +	struct subopt_param {
> +		int		index;
> +		long long	minval;
> +		long long	maxval;
> +	}		subopt_params[MAX_SUBOPTS];
> +};
> +
> +struct opt_params bopts = {
> +	.name = 'b',
> +	.subopts = {
>  #define	B_LOG		0
> -	"log",
> +		"log",
>  #define	B_SIZE		1
> -	"size",
> -	NULL
> +		"size",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = B_LOG,
> +		  .minval = XFS_MIN_BLOCKSIZE_LOG,
> +		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> +		},
> +		{ .index = B_SIZE,
> +		  .minval = XFS_MIN_BLOCKSIZE,
> +		  .maxval = XFS_MAX_BLOCKSIZE,
> +		},
> +	},
>  };
>  
> -char	*dopts[] = {
> +struct opt_params dopts = {
> +	.name = 'd',
> +	.subopts = {
>  #define	D_AGCOUNT	0
> -	"agcount",
> +		"agcount",
>  #define	D_FILE		1
> -	"file",
> +		"file",
>  #define	D_NAME		2
> -	"name",
> +		"name",
>  #define	D_SIZE		3
> -	"size",
> +		"size",
>  #define D_SUNIT		4
> -	"sunit",
> +		"sunit",
>  #define D_SWIDTH	5
> -	"swidth",
> +		"swidth",
>  #define D_AGSIZE	6
> -	"agsize",
> +		"agsize",
>  #define D_SU		7
> -	"su",
> +		"su",
>  #define D_SW		8
> -	"sw",
> +		"sw",
>  #define D_SECTLOG	9
> -	"sectlog",
> +		"sectlog",
>  #define D_SECTSIZE	10
> -	"sectsize",
> +		"sectsize",
>  #define D_NOALIGN	11
> -	"noalign",
> +		"noalign",
>  #define D_RTINHERIT	12
> -	"rtinherit",
> +		"rtinherit",
>  #define D_PROJINHERIT	13
> -	"projinherit",
> +		"projinherit",
>  #define D_EXTSZINHERIT	14
> -	"extszinherit",
> -	NULL
> +		"extszinherit",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = D_AGCOUNT,
> +		},
> +		{ .index = D_FILE,
> +		},
> +		{ .index = D_NAME,
> +		},
> +		{ .index = D_SIZE,
> +		},
> +		{ .index = D_SUNIT,
> +		},
> +		{ .index = D_SWIDTH,
> +		},
> +		{ .index = D_AGSIZE,
> +		},
> +		{ .index = D_SU,
> +		},
> +		{ .index = D_SW,
> +		},
> +		{ .index = D_SECTLOG,
> +		  .minval = XFS_MIN_SECTORSIZE_LOG,
> +		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> +		},
> +		{ .index = D_SECTSIZE,
> +		  .minval = XFS_MIN_SECTORSIZE,
> +		  .maxval = XFS_MAX_SECTORSIZE,
> +		},
> +		{ .index = D_NOALIGN,
> +		},
> +		{ .index = D_RTINHERIT,
> +		},
> +		{ .index = D_PROJINHERIT,
> +		},
> +		{ .index = D_EXTSZINHERIT,
> +		},
> +	},
>  };
>  
> -char	*iopts[] = {
> +
> +struct opt_params iopts = {
> +	.name = 'i',
> +	.subopts = {
>  #define	I_ALIGN		0
> -	"align",
> +		"align",
>  #define	I_LOG		1
> -	"log",
> +		"log",
>  #define	I_MAXPCT	2
> -	"maxpct",
> +		"maxpct",
>  #define	I_PERBLOCK	3
> -	"perblock",
> +		"perblock",
>  #define	I_SIZE		4
> -	"size",
> +		"size",
>  #define	I_ATTR		5
> -	"attr",
> +		"attr",
>  #define	I_PROJID32BIT	6
> -	"projid32bit",
> +		"projid32bit",
>  #define I_SPINODES	7
> -	"sparse",
> -	NULL
> +		"sparse",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = I_ALIGN,
> +		},
> +		{ .index = I_LOG,
> +		  .minval = XFS_DINODE_MIN_LOG,
> +		  .maxval = XFS_DINODE_MAX_LOG,
> +		},
> +		{ .index = I_MAXPCT,
> +		},
> +		{ .index = I_PERBLOCK,
> +		},
> +		{ .index = I_SIZE,
> +		},
> +		{ .index = I_ATTR,
> +		},
> +		{ .index = I_PROJID32BIT,
> +		},
> +		{ .index = I_SPINODES,
> +		},
> +	},
>  };
>  
> -char	*lopts[] = {
> +struct opt_params lopts = {
> +	.name = 'l',
> +	.subopts = {
>  #define	L_AGNUM		0
> -	"agnum",
> +		"agnum",
>  #define	L_INTERNAL	1
> -	"internal",
> +		"internal",
>  #define	L_SIZE		2
> -	"size",
> +		"size",
>  #define L_VERSION	3
> -	"version",
> +		"version",
>  #define L_SUNIT		4
> -	"sunit",
> +		"sunit",
>  #define L_SU		5
> -	"su",
> +		"su",
>  #define L_DEV		6
> -	"logdev",
> +		"logdev",
>  #define	L_SECTLOG	7
> -	"sectlog",
> +		"sectlog",
>  #define	L_SECTSIZE	8
> -	"sectsize",
> +		"sectsize",
>  #define	L_FILE		9
> -	"file",
> +		"file",
>  #define	L_NAME		10
> -	"name",
> +		"name",
>  #define	L_LAZYSBCNTR	11
> -	"lazy-count",
> -	NULL
> +		"lazy-count",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = L_AGNUM,
> +		},
> +		{ .index = L_INTERNAL,
> +		},
> +		{ .index = L_SIZE,
> +		},
> +		{ .index = L_VERSION,
> +		},
> +		{ .index = L_SUNIT,
> +		},
> +		{ .index = L_SU,
> +		},
> +		{ .index = L_DEV,
> +		},
> +		{ .index = L_SECTLOG,
> +		  .minval = XFS_MIN_SECTORSIZE_LOG,
> +		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> +		},
> +		{ .index = L_SECTSIZE,
> +		  .minval = XFS_MIN_SECTORSIZE,
> +		  .maxval = XFS_MAX_SECTORSIZE,
> +		},
> +		{ .index = L_FILE,
> +		},
> +		{ .index = L_NAME,
> +		},
> +		{ .index = L_LAZYSBCNTR,
> +		},
> +	},
>  };
>  
> -char	*nopts[] = {
> +struct opt_params nopts = {
> +	.name = 'n',
> +	.subopts = {
>  #define	N_LOG		0
> -	"log",
> +		"log",
>  #define	N_SIZE		1
> -	"size",
> +		"size",
>  #define	N_VERSION	2
> -	"version",
> +		"version",
>  #define	N_FTYPE		3
> -	"ftype",
> +		"ftype",
>  	NULL,
> +	},
> +	.subopt_params = {
> +		{ .index = N_LOG,
> +		  .minval = XFS_MIN_REC_DIRSIZE,
> +		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> +		},
> +		{ .index = N_SIZE,
> +		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
> +		  .maxval = XFS_MAX_BLOCKSIZE,
> +		},
> +		{ .index = N_VERSION,
> +		},
> +		{ .index = N_FTYPE,
> +		},
> +	},
>  };
>  
> -char	*ropts[] = {
> +struct opt_params ropts = {
> +	.name = 'r',
> +	.subopts = {
>  #define	R_EXTSIZE	0
> -	"extsize",
> +		"extsize",
>  #define	R_SIZE		1
> -	"size",
> +		"size",
>  #define	R_DEV		2
> -	"rtdev",
> +		"rtdev",
>  #define	R_FILE		3
> -	"file",
> +		"file",
>  #define	R_NAME		4
> -	"name",
> +		"name",
>  #define R_NOALIGN	5
> -	"noalign",
> -	NULL
> +		"noalign",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = R_EXTSIZE,
> +		},
> +		{ .index = R_SIZE,
> +		},
> +		{ .index = R_DEV,
> +		},
> +		{ .index = R_FILE,
> +		},
> +		{ .index = R_NAME,
> +		},
> +		{ .index = R_NOALIGN,
> +		},
> +	},
>  };
>  
> -char	*sopts[] = {
> +struct opt_params sopts = {
> +	.name = 's',
> +	.subopts = {
>  #define	S_LOG		0
> -	"log",
> +		"log",
>  #define	S_SECTLOG	1
> -	"sectlog",
> +		"sectlog",
>  #define	S_SIZE		2
> -	"size",
> +		"size",
>  #define	S_SECTSIZE	3
> -	"sectsize",
> -	NULL
> +		"sectsize",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = S_LOG,
> +		  .minval = XFS_MIN_SECTORSIZE_LOG,
> +		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> +		},
> +		{ .index = S_SECTLOG,
> +		  .minval = XFS_MIN_SECTORSIZE_LOG,
> +		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> +		},
> +		{ .index = S_SIZE,
> +		  .minval = XFS_MIN_SECTORSIZE,
> +		  .maxval = XFS_MAX_SECTORSIZE,
> +		},
> +		{ .index = S_SECTSIZE,
> +		  .minval = XFS_MIN_SECTORSIZE,
> +		  .maxval = XFS_MAX_SECTORSIZE,
> +		},
> +	},
>  };
>  
> -char	*mopts[] = {
> +struct opt_params mopts = {
> +	.name = 'm',
> +	.subopts = {
>  #define	M_CRC		0
> -	"crc",
> +		"crc",
>  #define M_FINOBT	1
>  	"finobt",
>  #define M_UUID		2
> -	"uuid",
> -	NULL
> +		"uuid",
> +		NULL
> +	},
> +	.subopt_params = {
> +		{ .index = M_CRC,
> +		},
> +	},
>  };
>  
>  #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
> @@ -1022,24 +1236,42 @@ getbool(
>  	return c ? true : false;
>  }
>  
> +static __attribute__((noreturn)) void
> +illegal_option(
> +	const char	*value,
> +	struct opt_params	*opts,
> +	int		index)
> +{
> +	fprintf(stderr,
> +		_("Illegal value %s for -%c %s option\n"),
> +		value, opts->name, opts->subopts[index]);
> +	usage();
> +}
> +
>  static int
>  getnum_checked(
>  	const char	*str,
> -	long long	min_val,
> -	long long	max_val,
> -	const char	*illegal_str,
> -	char		reqval_char,
> -	char		*reqval_opts[],
> -	int		reqval_optind)
> +	struct opt_params	*opts,
> +	int		index)
>  {
>  	long long	c;
>  
>  	if (!str || *str == '\0')
> -		reqval(reqval_char, reqval_opts, reqval_optind);
> +		reqval(opts->name, (char **)opts->subopts, index);
> +
> +	if (opts->subopt_params[index].minval == 0 &&
> +	    opts->subopt_params[index].maxval == 0) {
> +		fprintf(stderr,
> +			_("Option -%c %s has undefined minval/maxval."
> +			  "Can't verify value range. This is a bug.\n"),
> +			opts->name, opts->subopts[index]);
> +		exit(1);
> +	}
>  
>  	c = getnum(str, 0, 0, false);
> -	if (c < min_val || c > max_val)
> -		illegal(str, illegal_str);
> +	if (c < opts->subopt_params[index].minval ||
> +	    c > opts->subopt_params[index].maxval)
> +		illegal_option(str, opts, index);
>  	return c;
>  }
>  
> @@ -1196,30 +1428,29 @@ main(
>  		case 'b':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)bopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)bopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case B_LOG:
>  					if (blflag)
> -						respec('b', bopts, B_LOG);
> +						respec('b', subopts, B_LOG);
>  					if (bsflag)
> -						conflict('b', bopts, B_SIZE,
> +						conflict('b', subopts, B_SIZE,
>  							 B_LOG);
> -					blocklog = getnum_checked(value,
> -							XFS_MIN_BLOCKSIZE_LOG,
> -							XFS_MAX_BLOCKSIZE_LOG,
> -							"b log", 'b', bopts,
> -							B_LOG);
> +					blocklog = getnum_checked(value, &bopts,
> +								  B_LOG);
>  					blocksize = 1 << blocklog;
>  					blflag = 1;
>  					break;
>  				case B_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('b', bopts, B_SIZE);
> +						reqval('b', subopts, B_SIZE);
>  					if (bsflag)
> -						respec('b', bopts, B_SIZE);
> +						respec('b', subopts, B_SIZE);
>  					if (blflag)
> -						conflict('b', bopts, B_LOG,
> +						conflict('b', subopts, B_LOG,
>  							 B_SIZE);
>  					blocksize = getnum(value, blocksize,
>  							sectorsize, true);
> @@ -1237,14 +1468,16 @@ main(
>  		case 'd':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)dopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)dopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case D_AGCOUNT:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_AGCOUNT);
> +						reqval('d', subopts, D_AGCOUNT);
>  					if (daflag)
> -						respec('d', dopts, D_AGCOUNT);
> +						respec('d', subopts, D_AGCOUNT);
>  					agcount = getnum(value, 0, 0, false);
>  					if ((__int64_t)agcount <= 0)
>  						illegal(value, "d agcount");
> @@ -1252,9 +1485,9 @@ main(
>  					break;
>  				case D_AGSIZE:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_AGSIZE);
> +						reqval('d', subopts, D_AGSIZE);
>  					if (dasize)
> -						respec('d', dopts, D_AGSIZE);
> +						respec('d', subopts, D_AGSIZE);
>  					agsize = getnum(value, blocksize,
>  							sectorsize, true);
>  					if ((__int64_t)agsize <= 0)
> @@ -1269,25 +1502,25 @@ main(
>  					break;
>  				case D_NAME:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_NAME);
> +						reqval('d', subopts, D_NAME);
>  					if (xi.dname)
> -						respec('d', dopts, D_NAME);
> +						respec('d', subopts, D_NAME);
>  					xi.dname = value;
>  					break;
>  				case D_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SIZE);
> +						reqval('d', subopts, D_SIZE);
>  					if (dsize)
> -						respec('d', dopts, D_SIZE);
> +						respec('d', subopts, D_SIZE);
>  					dsize = value;
>  					break;
>  				case D_SUNIT:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SUNIT);
> +						reqval('d', subopts, D_SUNIT);
>  					if (dsunit)
> -						respec('d', dopts, D_SUNIT);
> +						respec('d', subopts, D_SUNIT);
>  					if (nodsflag)
> -						conflict('d', dopts, D_NOALIGN,
> +						conflict('d', subopts, D_NOALIGN,
>  							 D_SUNIT);
>  					dsunit = getnum(value, 0, 0, false);
>  					if (dsunit < 0)
> @@ -1295,11 +1528,11 @@ main(
>  					break;
>  				case D_SWIDTH:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SWIDTH);
> +						reqval('d', subopts, D_SWIDTH);
>  					if (dswidth)
> -						respec('d', dopts, D_SWIDTH);
> +						respec('d', subopts, D_SWIDTH);
>  					if (nodsflag)
> -						conflict('d', dopts, D_NOALIGN,
> +						conflict('d', subopts, D_NOALIGN,
>  							 D_SWIDTH);
>  					dswidth = getnum(value, 0, 0, false);
>  					if (dswidth < 0)
> @@ -1307,11 +1540,11 @@ main(
>  					break;
>  				case D_SU:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SU);
> +						reqval('d', subopts, D_SU);
>  					if (dsu)
> -						respec('d', dopts, D_SU);
> +						respec('d', subopts, D_SU);
>  					if (nodsflag)
> -						conflict('d', dopts, D_NOALIGN,
> +						conflict('d', subopts, D_NOALIGN,
>  							 D_SU);
>  					dsu = getnum(value, blocksize,
>  						     sectorsize, true);
> @@ -1320,11 +1553,11 @@ main(
>  					break;
>  				case D_SW:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SW);
> +						reqval('d', subopts, D_SW);
>  					if (dsw)
> -						respec('d', dopts, D_SW);
> +						respec('d', subopts, D_SW);
>  					if (nodsflag)
> -						conflict('d', dopts, D_NOALIGN,
> +						conflict('d', subopts, D_NOALIGN,
>  							 D_SW);
>  					dsw = getnum(value, 0, 0, false);
>  					if (dsw < 0)
> @@ -1332,40 +1565,37 @@ main(
>  					break;
>  				case D_NOALIGN:
>  					if (dsu)
> -						conflict('d', dopts, D_SU,
> +						conflict('d', subopts, D_SU,
>  							 D_NOALIGN);
>  					if (dsunit)
> -						conflict('d', dopts, D_SUNIT,
> +						conflict('d', subopts, D_SUNIT,
>  							 D_NOALIGN);
>  					if (dsw)
> -						conflict('d', dopts, D_SW,
> +						conflict('d', subopts, D_SW,
>  							 D_NOALIGN);
>  					if (dswidth)
> -						conflict('d', dopts, D_SWIDTH,
> +						conflict('d', subopts, D_SWIDTH,
>  							 D_NOALIGN);
>  					nodsflag = 1;
>  					break;
>  				case D_SECTLOG:
>  					if (slflag)
> -						respec('d', dopts, D_SECTLOG);
> +						respec('d', subopts, D_SECTLOG);
>  					if (ssflag)
> -						conflict('d', dopts, D_SECTSIZE,
> +						conflict('d', subopts, D_SECTSIZE,
>  							 D_SECTLOG);
> -					sectorlog = getnum_checked(value,
> -							XFS_MIN_SECTORSIZE_LOG,
> -							XFS_MAX_SECTORSIZE_LOG,
> -							"d sectlog", 'd', dopts,
> -							D_SECTLOG);
> +					sectorlog = getnum_checked(value, &dopts,
> +								   D_SECTLOG);
>  					sectorsize = 1 << sectorlog;
>  					slflag = 1;
>  					break;
>  				case D_SECTSIZE:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SECTSIZE);
> +						reqval('d', subopts, D_SECTSIZE);
>  					if (ssflag)
> -						respec('d', dopts, D_SECTSIZE);
> +						respec('d', subopts, D_SECTSIZE);
>  					if (slflag)
> -						conflict('d', dopts, D_SECTLOG,
> +						conflict('d', subopts, D_SECTLOG,
>  							 D_SECTSIZE);
>  					sectorsize = getnum(value, blocksize,
>  							    sectorsize, true);
> @@ -1382,14 +1612,14 @@ main(
>  					break;
>  				case D_PROJINHERIT:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_PROJINHERIT);
> +						reqval('d', subopts, D_PROJINHERIT);
>  					fsx.fsx_projid = atoi(value);
>  					fsx.fsx_xflags |= \
>  						XFS_DIFLAG_PROJINHERIT;
>  					break;
>  				case D_EXTSZINHERIT:
>  					if (!value || *value == '\0')
> -						reqval('d', dopts, D_EXTSZINHERIT);
> +						reqval('d', subopts, D_EXTSZINHERIT);
>  					fsx.fsx_extsize = atoi(value);
>  					fsx.fsx_xflags |= \
>  						XFS_DIFLAG_EXTSZINHERIT;
> @@ -1402,37 +1632,34 @@ main(
>  		case 'i':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)iopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)iopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case I_ALIGN:
>  					sb_feat.inode_align = getbool(
>  							value, "i align", true);
>  					break;
>  				case I_LOG:
> -					if (!value || *value == '\0')
> -						reqval('i', iopts, I_LOG);
>  					if (ilflag)
> -						respec('i', iopts, I_LOG);
> +						respec('i', subopts, I_LOG);
>  					if (ipflag)
> -						conflict('i', iopts, I_PERBLOCK,
> +						conflict('i', subopts, I_PERBLOCK,
>  							 I_LOG);
>  					if (isflag)
> -						conflict('i', iopts, I_SIZE,
> +						conflict('i', subopts, I_SIZE,
>  							 I_LOG);
> -					inodelog = getnum_checked(value,
> -							XFS_DINODE_MIN_LOG,
> -							XFS_DINODE_MAX_LOG,
> -							"i log", 'i', iopts,
> -							I_LOG);
> +					inodelog = getnum_checked(value, &iopts,
> +								  I_LOG);
>  					isize = 1 << inodelog;
>  					ilflag = 1;
>  					break;
>  				case I_MAXPCT:
>  					if (!value || *value == '\0')
> -						reqval('i', iopts, I_MAXPCT);
> +						reqval('i', subopts, I_MAXPCT);
>  					if (imflag)
> -						respec('i', iopts, I_MAXPCT);
> +						respec('i', subopts, I_MAXPCT);
>  					imaxpct = getnum(value, 0, 0, false);
>  					if (imaxpct < 0 || imaxpct > 100)
>  						illegal(value, "i maxpct");
> @@ -1440,14 +1667,14 @@ main(
>  					break;
>  				case I_PERBLOCK:
>  					if (!value || *value == '\0')
> -						reqval('i', iopts, I_PERBLOCK);
> +						reqval('i', subopts, I_PERBLOCK);
>  					if (ilflag)
> -						conflict('i', iopts, I_LOG,
> +						conflict('i', subopts, I_LOG,
>  							 I_PERBLOCK);
>  					if (ipflag)
> -						respec('i', iopts, I_PERBLOCK);
> +						respec('i', subopts, I_PERBLOCK);
>  					if (isflag)
> -						conflict('i', iopts, I_SIZE,
> +						conflict('i', subopts, I_SIZE,
>  							 I_PERBLOCK);
>  					inopblock = getnum(value, 0, 0, false);
>  					if (inopblock <
> @@ -1458,15 +1685,15 @@ main(
>  					break;
>  				case I_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('i', iopts, I_SIZE);
> +						reqval('i', subopts, I_SIZE);
>  					if (ilflag)
> -						conflict('i', iopts, I_LOG,
> +						conflict('i', subopts, I_LOG,
>  							 I_SIZE);
>  					if (ipflag)
> -						conflict('i', iopts, I_PERBLOCK,
> +						conflict('i', subopts, I_PERBLOCK,
>  							 I_SIZE);
>  					if (isflag)
> -						respec('i', iopts, I_SIZE);
> +						respec('i', subopts, I_SIZE);
>  					isize = getnum(value, 0, 0, true);
>  					if (isize <= 0 || !ispow2(isize))
>  						illegal(value, "i size");
> @@ -1475,7 +1702,7 @@ main(
>  					break;
>  				case I_ATTR:
>  					if (!value || *value == '\0')
> -						reqval('i', iopts, I_ATTR);
> +						reqval('i', subopts, I_ATTR);
>  					c = getnum(value, 0, 0, false);
>  					if (c < 0 || c > 2)
>  						illegal(value, "i attr");
> @@ -1501,17 +1728,19 @@ main(
>  		case 'l':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)lopts.subopts;
>  				char	*value;
>  				long long tmp_num;
>  
> -				switch (getsubopt(&p, (constpp)lopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case L_AGNUM:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_AGNUM);
> +						reqval('l', subopts, L_AGNUM);
>  					if (laflag)
> -						respec('l', lopts, L_AGNUM);
> +						respec('l', subopts, L_AGNUM);
>  					if (ldflag)
> -						conflict('l', lopts, L_AGNUM, L_DEV);
> +						conflict('l', subopts, L_AGNUM, L_DEV);
>  					tmp_num = getnum(value, 0, 0, false);
>  					if (tmp_num < 0)
>  						illegal(value, "l agno");
> @@ -1520,7 +1749,7 @@ main(
>  					break;
>  				case L_FILE:
>  					if (loginternal)
> -						conflict('l', lopts, L_INTERNAL,
> +						conflict('l', subopts, L_INTERNAL,
>  							 L_FILE);
>  					xi.lisfile = getbool(value, "l file",
>  							     true);
> @@ -1529,12 +1758,12 @@ main(
>  					break;
>  				case L_INTERNAL:
>  					if (ldflag)
> -						conflict('l', lopts, L_INTERNAL, L_DEV);
> +						conflict('l', subopts, L_INTERNAL, L_DEV);
>  					if (xi.lisfile)
> -						conflict('l', lopts, L_FILE,
> +						conflict('l', subopts, L_FILE,
>  							 L_INTERNAL);
>  					if (liflag)
> -						respec('l', lopts, L_INTERNAL);
> +						respec('l', subopts, L_INTERNAL);
>  
>  					loginternal = getbool(value,
>  							"l internal", true);
> @@ -1542,9 +1771,9 @@ main(
>  					break;
>  				case L_SU:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_SU);
> +						reqval('l', subopts, L_SU);
>  					if (lsu)
> -						respec('l', lopts, L_SU);
> +						respec('l', subopts, L_SU);
>  					lsu = getnum(value, blocksize,
>  						     sectorsize, true);
>  					if (lsu < 0)
> @@ -1553,9 +1782,9 @@ main(
>  					break;
>  				case L_SUNIT:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_SUNIT);
> +						reqval('l', subopts, L_SUNIT);
>  					if (lsunit)
> -						respec('l', lopts, L_SUNIT);
> +						respec('l', subopts, L_SUNIT);
>  					lsunit = getnum(value, 0, 0, false);
>  					if (lsunit < 0)
>  						illegal(value, "l sunit");
> @@ -1564,13 +1793,13 @@ main(
>  				case L_NAME:
>  				case L_DEV:
>  					if (laflag)
> -						conflict('l', lopts, L_AGNUM, L_DEV);
> +						conflict('l', subopts, L_AGNUM, L_DEV);
>  					if (liflag)
> -						conflict('l', lopts, L_INTERNAL, L_DEV);
> +						conflict('l', subopts, L_INTERNAL, L_DEV);
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_NAME);
> +						reqval('l', subopts, L_NAME);
>  					if (xi.logname)
> -						respec('l', lopts, L_NAME);
> +						respec('l', subopts, L_NAME);
>  					ldflag = 1;
>  					loginternal = 0;
>  					logfile = value;
> @@ -1578,9 +1807,9 @@ main(
>  					break;
>  				case L_VERSION:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_VERSION);
> +						reqval('l', subopts, L_VERSION);
>  					if (lvflag)
> -						respec('l', lopts, L_VERSION);
> +						respec('l', subopts, L_VERSION);
>  					c = getnum(value, 0, 0, false);
>  					if (c < 1 || c > 2)
>  						illegal(value, "l version");
> @@ -1589,33 +1818,30 @@ main(
>  					break;
>  				case L_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_SIZE);
> +						reqval('l', subopts, L_SIZE);
>  					if (logsize)
> -						respec('l', lopts, L_SIZE);
> +						respec('l', subopts, L_SIZE);
>  					logsize = value;
>  					lsflag = 1;
>  					break;
>  				case L_SECTLOG:
>  					if (lslflag)
> -						respec('l', lopts, L_SECTLOG);
> +						respec('l', subopts, L_SECTLOG);
>  					if (lssflag)
> -						conflict('l', lopts, L_SECTSIZE,
> +						conflict('l', subopts, L_SECTSIZE,
>  							 L_SECTLOG);
>  					lsectorlog = getnum_checked(value,
> -							XFS_MIN_SECTORSIZE_LOG,
> -							XFS_MAX_SECTORSIZE_LOG,
> -							"l sectlog", 'l', lopts,
> -							L_SECTLOG);
> +							&lopts, L_SECTLOG);
>  					lsectorsize = 1 << lsectorlog;
>  					lslflag = 1;
>  					break;
>  				case L_SECTSIZE:
>  					if (!value || *value == '\0')
> -						reqval('l', lopts, L_SECTSIZE);
> +						reqval('l', subopts, L_SECTSIZE);
>  					if (lssflag)
> -						respec('l', lopts, L_SECTSIZE);
> +						respec('l', subopts, L_SECTSIZE);
>  					if (lslflag)
> -						conflict('l', lopts, L_SECTLOG,
> +						conflict('l', subopts, L_SECTLOG,
>  							 L_SECTSIZE);
>  					lsectorsize = getnum(value, blocksize,
>  							     sectorsize, true);
> @@ -1644,9 +1870,11 @@ main(
>  		case 'm':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)mopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)mopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case M_CRC:
>  					sb_feat.crcs_enabled = getbool(
>  							value, "m crc", true);
> @@ -1665,7 +1893,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					break;
>  				case M_UUID:
>  					if (!value || *value == '\0')
> -						reqval('m', mopts, M_UUID);
> +						reqval('m', subopts, M_UUID);
>  					if (platform_uuid_parse(value, &uuid))
>  						illegal(optarg, "m uuid");
>  					break;
> @@ -1677,30 +1905,29 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  		case 'n':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)nopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)nopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case N_LOG:
>  					if (nlflag)
> -						respec('n', nopts, N_LOG);
> +						respec('n', subopts, N_LOG);
>  					if (nsflag)
> -						conflict('n', nopts, N_SIZE,
> +						conflict('n', subopts, N_SIZE,
>  							 N_LOG);
>  					dirblocklog = getnum_checked(value,
> -							XFS_MIN_REC_DIRSIZE,
> -							XFS_MAX_BLOCKSIZE_LOG,
> -							"n log", 'n', nopts,
> -							N_LOG);
> +								&nopts, N_LOG);
>  					dirblocksize = 1 << dirblocklog;
>  					nlflag = 1;
>  					break;
>  				case N_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('n', nopts, N_SIZE);
> +						reqval('n', subopts, N_SIZE);
>  					if (nsflag)
> -						respec('n', nopts, N_SIZE);
> +						respec('n', subopts, N_SIZE);
>  					if (nlflag)
> -						conflict('n', nopts, N_LOG,
> +						conflict('n', subopts, N_LOG,
>  							 N_SIZE);
>  					dirblocksize = getnum(value, blocksize,
>  							      sectorsize, true);
> @@ -1713,9 +1940,9 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					break;
>  				case N_VERSION:
>  					if (!value || *value == '\0')
> -						reqval('n', nopts, N_VERSION);
> +						reqval('n', subopts, N_VERSION);
>  					if (nvflag)
> -						respec('n', nopts, N_VERSION);
> +						respec('n', subopts, N_VERSION);
>  					if (!strcasecmp(value, "ci")) {
>  						/* ASCII CI mode */
>  						sb_feat.nci = true;
> @@ -1730,7 +1957,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					break;
>  				case N_FTYPE:
>  					if (nftype)
> -						respec('n', nopts, N_FTYPE);
> +						respec('n', subopts, N_FTYPE);
>  					if (sb_feat.crcs_enabled) {
>  						fprintf(stderr,
>  _("cannot specify both -m crc=1 and -n ftype\n"));
> @@ -1762,14 +1989,16 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  		case 'r':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)ropts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)ropts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case R_EXTSIZE:
>  					if (!value || *value == '\0')
> -						reqval('r', ropts, R_EXTSIZE);
> +						reqval('r', subopts, R_EXTSIZE);
>  					if (rtextsize)
> -						respec('r', ropts, R_EXTSIZE);
> +						respec('r', subopts, R_EXTSIZE);
>  					rtextsize = value;
>  					break;
>  				case R_FILE:
> @@ -1781,16 +2010,16 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				case R_NAME:
>  				case R_DEV:
>  					if (!value || *value == '\0')
> -						reqval('r', ropts, R_NAME);
> +						reqval('r', subopts, R_NAME);
>  					if (xi.rtname)
> -						respec('r', ropts, R_NAME);
> +						respec('r', subopts, R_NAME);
>  					xi.rtname = value;
>  					break;
>  				case R_SIZE:
>  					if (!value || *value == '\0')
> -						reqval('r', ropts, R_SIZE);
> +						reqval('r', subopts, R_SIZE);
>  					if (rtsize)
> -						respec('r', ropts, R_SIZE);
> +						respec('r', subopts, R_SIZE);
>  					rtsize = value;
>  					break;
>  				case R_NOALIGN:
> @@ -1804,21 +2033,20 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  		case 's':
>  			p = optarg;
>  			while (*p != '\0') {
> +				char	**subopts = (char **)sopts.subopts;
>  				char	*value;
>  
> -				switch (getsubopt(&p, (constpp)sopts, &value)) {
> +				switch (getsubopt(&p, (constpp)subopts,
> +						  &value)) {
>  				case S_LOG:
>  				case S_SECTLOG:
>  					if (slflag || lslflag)
> -						respec('s', sopts, S_SECTLOG);
> +						respec('s', subopts, S_SECTLOG);
>  					if (ssflag || lssflag)
> -						conflict('s', sopts, S_SECTSIZE,
> -							 S_SECTLOG);
> -					sectorlog = getnum_checked(value,
> -							XFS_MIN_SECTORSIZE_LOG,
> -							XFS_MAX_SECTORSIZE_LOG,
> -							"s sectlog", 's', sopts,
> -							S_SECTLOG);
> +						conflict('s', subopts,
> +							 S_SECTSIZE, S_SECTLOG);
> +					sectorlog = getnum_checked(value, &sopts,
> +								   S_SECTLOG);
>  					lsectorlog = sectorlog;
>  					sectorsize = 1 << sectorlog;
>  					lsectorsize = sectorsize;
> @@ -1827,11 +2055,11 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				case S_SIZE:
>  				case S_SECTSIZE:
>  					if (!value || *value == '\0')
> -						reqval('s', sopts, S_SECTSIZE);
> +						reqval('s', subopts, S_SECTSIZE);
>  					if (ssflag || lssflag)
> -						respec('s', sopts, S_SECTSIZE);
> +						respec('s', subopts, S_SECTSIZE);
>  					if (slflag || lslflag)
> -						conflict('s', sopts, S_SECTLOG,
> +						conflict('s', subopts, S_SECTLOG,
>  							 S_SECTSIZE);
>  					sectorsize = getnum(value, blocksize,
>  							    sectorsize, true);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

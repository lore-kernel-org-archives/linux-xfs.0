Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1432264AbdDYQwc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 12:52:32 -0400
Subject: Re: [PATCH 02/12] mkfs: rename defaultval to flagval in opts
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-3-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cbd1b9d4-9675-6cd8-7c39-e60758c63a06@sandeen.net>
Date: Tue, 25 Apr 2017 11:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170423185503.31415-3-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/23/17 1:54 PM, Jan Tulak wrote:
> The old name 'defaultval' was misleading - it is not the default value,
> but the value the option has when used as a flag by an user.

The value should only ever be 0 or 1, correct?

Ok, so I see something interesting here:

# grep "flagval = " mkfs/xfs_mkfs.c | sort | uniq -c
      1 			  .flagval = 0,
      1 			.flagval = 0,
     14 			  .flagval = 1,
     40 			  .flagval = SUBOPT_NEEDS_VAL,

of the 56 subopts, only 16 are treated as a flag, and only 2 default
to 0, while the rest default to 1.

Those 2 seem like outliers: -m rmapbt and -m reflink.  What's
going on there?

In every other case where there is a subopt which is actually a
boolean flag, a bare specification without a value means "enable
the feature."

It seems very unintuitive to have:

-X THING1 -> THING1 is enabled 14 times, but
-X THING12 - THING2 is still /disabled/ in only 2 cases

I'd argue that "-m rmapbt" and "-m reflink" leaving those features
/disabled/ is a bug, due to misunderstanding of what "defaultval"
means, and that they should be fixed to behave like the other 14
boolean flags.

i.e. I'd argue that a bare boolean flag specification should /always/
enable the feature.  At that point, you can say within your code 
"if min = 0 and max = 1, this is a boolean, and the flag may be specified
without a value, in which case the value is set to 1, and the feature
is enabled."

At that point you don't need this extra structure member, and you won't
have to re-state it 56 times, thus simplifying the code.

What do you think?  I'd happily review and merge 2 patches, which:

1) Makes rmapbt and reflink behave like every other boolean flag, and

2) Removes "defaultval" altogether, and uses min=0/max=1 as a sign that
   the option is a boolean, with a bare flag name allowed to enable it.

-Eric

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 120 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 60 insertions(+), 60 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 84674d5..0a795a6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -112,7 +112,7 @@ uint64_t		sectorsize;
>   *     to zero. But if one value is different: minval=0 and maxval=1,
>   *     then it is OK.)
>   *
> - *   defaultval MANDATORY
> + *   flagval MANDATORY
>   *     The value used if user specifies the subopt, but no value.
>   *     If the subopt accepts some values (-d file=[1|0]), then this
>   *     sets what is used with simple specifying the subopt (-d file).
> @@ -144,7 +144,7 @@ struct opt_params {
>  		int		conflicts[MAX_CONFLICTS];
>  		uint64_t	minval;
>  		uint64_t	maxval;
> -		uint64_t	defaultval;
> +		uint64_t	flagval;
>  		const char	*raw_input;
>  	}		subopt_params[MAX_SUBOPTS];
>  };
> @@ -164,7 +164,7 @@ struct opt_params bopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_BLOCKSIZE_LOG,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = B_SIZE,
>  		  .convert = true,
> @@ -173,7 +173,7 @@ struct opt_params bopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_BLOCKSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  	},
>  };
> @@ -219,24 +219,24 @@ struct opt_params dopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = XFS_MAX_AGNUMBER,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_FILE,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = D_NAME,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SIZE,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = LLONG_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SUNIT,
>  		  .conflicts = { D_NOALIGN,
> @@ -245,7 +245,7 @@ struct opt_params dopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SWIDTH,
>  		  .conflicts = { D_NOALIGN,
> @@ -254,7 +254,7 @@ struct opt_params dopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_AGSIZE,
>  		  .conflicts = { D_AGCOUNT,
> @@ -262,7 +262,7 @@ struct opt_params dopts = {
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = XFS_AG_MAX_BYTES,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SU,
>  		  .conflicts = { D_NOALIGN,
> @@ -272,7 +272,7 @@ struct opt_params dopts = {
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SW,
>  		  .conflicts = { D_NOALIGN,
> @@ -281,14 +281,14 @@ struct opt_params dopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTLOG,
>  		  .conflicts = { D_SECTSIZE,
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTSIZE,
>  		  .conflicts = { D_SECTLOG,
> @@ -297,7 +297,7 @@ struct opt_params dopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
>  		  .maxval = XFS_MAX_SECTORSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_NOALIGN,
>  		  .conflicts = { D_SU,
> @@ -307,25 +307,25 @@ struct opt_params dopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = D_RTINHERIT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = D_PROJINHERIT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_EXTSZINHERIT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  	},
>  };
> @@ -357,7 +357,7 @@ struct opt_params iopts = {
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = I_LOG,
>  		  .conflicts = { I_PERBLOCK,
> @@ -365,13 +365,13 @@ struct opt_params iopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_DINODE_MIN_LOG,
>  		  .maxval = XFS_DINODE_MAX_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_MAXPCT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 100,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PERBLOCK,
>  		  .conflicts = { I_LOG,
> @@ -380,7 +380,7 @@ struct opt_params iopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_INODE_PERBLOCK,
>  		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_SIZE,
>  		  .conflicts = { I_PERBLOCK,
> @@ -389,25 +389,25 @@ struct opt_params iopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_DINODE_MIN_SIZE,
>  		  .maxval = XFS_DINODE_MAX_SIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_ATTR,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 2,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PROJID32BIT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = I_SPINODES,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  	},
>  };
> @@ -447,7 +447,7 @@ struct opt_params lopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_INTERNAL,
>  		  .conflicts = { L_FILE,
> @@ -455,27 +455,27 @@ struct opt_params lopts = {
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = L_SIZE,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
>  		  .maxval = XFS_MAX_LOG_BYTES,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_VERSION,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = 2,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SUNIT,
>  		  .conflicts = { L_SU,
>  				 LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SU,
>  		  .conflicts = { L_SUNIT,
> @@ -483,20 +483,20 @@ struct opt_params lopts = {
>  		  .convert = true,
>  		  .minval = BBTOB(1),
>  		  .maxval = XLOG_MAX_RECORD_BSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_DEV,
>  		  .conflicts = { L_AGNUM,
>  				 L_INTERNAL,
>  				 LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTLOG,
>  		  .conflicts = { L_SECTSIZE,
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTSIZE,
>  		  .conflicts = { L_SECTLOG,
> @@ -505,26 +505,26 @@ struct opt_params lopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
>  		  .maxval = XFS_MAX_SECTORSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_FILE,
>  		  .conflicts = { L_INTERNAL,
>  				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = L_NAME,
>  		  .conflicts = { L_AGNUM,
>  				 L_INTERNAL,
>  				 LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_LAZYSBCNTR,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  	},
>  };
> @@ -548,7 +548,7 @@ struct opt_params nopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_REC_DIRSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_SIZE,
>  		  .conflicts = { N_LOG,
> @@ -557,19 +557,19 @@ struct opt_params nopts = {
>  		  .is_power_2 = true,
>  		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_VERSION,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 2,
>  		  .maxval = 2,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_FTYPE,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  	},
>  };
> @@ -597,33 +597,33 @@ struct opt_params ropts = {
>  		  .convert = true,
>  		  .minval = XFS_MIN_RTEXTSIZE,
>  		  .maxval = XFS_MAX_RTEXTSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_SIZE,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = LLONG_MAX,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_DEV,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_FILE,
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		  .conflicts = { LAST_CONFLICT },
>  		},
>  		{ .index = R_NAME,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_NOALIGN,
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		  .conflicts = { LAST_CONFLICT },
>  		},
>  	},
> @@ -649,7 +649,7 @@ struct opt_params sopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTLOG,
>  		  .conflicts = { S_SIZE,
> @@ -657,7 +657,7 @@ struct opt_params sopts = {
>  				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SIZE,
>  		  .conflicts = { S_LOG,
> @@ -667,7 +667,7 @@ struct opt_params sopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
>  		  .maxval = XFS_MAX_SECTORSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTSIZE,
>  		  .conflicts = { S_LOG,
> @@ -677,7 +677,7 @@ struct opt_params sopts = {
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
>  		  .maxval = XFS_MAX_SECTORSIZE,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  	},
>  };
> @@ -702,29 +702,29 @@ struct opt_params mopts = {
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = M_FINOBT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 1,
> +		  .flagval = 1,
>  		},
>  		{ .index = M_UUID,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> +		  .flagval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = M_RMAPBT,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 0,
> +		  .flagval = 0,
>  		},
>  		{ .index = M_REFLINK,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 0,
> +		  .flagval = 0,
>  		},
>  	},
>  };
> @@ -1365,9 +1365,9 @@ getnum(
>  	check_opt(opts, index, false);
>  	/* empty strings might just return a default value */
>  	if (!str || *str == '\0') {
> -		if (sp->defaultval == SUBOPT_NEEDS_VAL)
> +		if (sp->flagval == SUBOPT_NEEDS_VAL)
>  			reqval(opts->name, (char **)opts->subopts, index);
> -		return sp->defaultval;
> +		return sp->flagval;
>  	}
>  
>  	if (sp->minval == 0 && sp->maxval == 0) {
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdLTCxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 21:53:51 -0500
Date: Tue, 19 Dec 2017 18:53:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] mkfs: support arbitrary conflict specification
Message-ID: <20171220025346.GL12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218091158.14537-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:11:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the conflict table is a single dimension, allowing
> conflicts to be specified in the same option table. however, we
> have conflicts that span option tables (e.g. sector size) and
> so we need to encode both the table and the option that conflicts.
> 
> Add support for a two dimensional conflict definition and convert
> all the code over to use it.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 257 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 130 insertions(+), 127 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7cc5ee2ddb9d..2272700807dc 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -125,7 +125,10 @@ struct opt_params {
>  		bool		str_seen;
>  		bool		convert;
>  		bool		is_power_2;
> -		int		conflicts[MAX_CONFLICTS];
> +		struct _conflict {
> +			struct opt_params	*opts;
> +			int			subopt;
> +		}		conflicts[MAX_CONFLICTS];
>  		long long	minval;
>  		long long	maxval;
>  		long long	defaultval;
> @@ -143,8 +146,8 @@ struct opt_params bopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = B_LOG,
> -		  .conflicts = { B_SIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &bopts, B_SIZE },
> +				 { &bopts, LAST_CONFLICT } },

Hmm.  The LAST_CONFLICT entry doesn't require an *opts pointer, right?

It feels a little funny to me that the last entry isn't:

{ NULL, LAST_CONFLICT }

...since we're not actually doing anything with bopts in that last
entry, but that might be a matter of taste (aka I punt to sandeen) :)

--D

>  		  .minval = XFS_MIN_BLOCKSIZE_LOG,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -152,8 +155,8 @@ struct opt_params bopts = {
>  		{ .index = B_SIZE,
>  		  .convert = true,
>  		  .is_power_2 = true,
> -		  .conflicts = { B_LOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &bopts, B_LOG },
> +				 { &bopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_BLOCKSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -200,84 +203,84 @@ struct opt_params dopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> -		  .conflicts = { D_AGSIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_AGSIZE },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = 1,
>  		  .maxval = XFS_MAX_AGNUMBER,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_FILE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_NAME,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SIZE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = LLONG_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SUNIT,
> -		  .conflicts = { D_NOALIGN,
> -				 D_SU,
> -				 D_SW,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_NOALIGN },
> +				 { &dopts, D_SU },
> +				 { &dopts, D_SW },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SWIDTH,
> -		  .conflicts = { D_NOALIGN,
> -				 D_SU,
> -				 D_SW,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_NOALIGN },
> +				 { &dopts, D_SU },
> +				 { &dopts, D_SW },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_AGSIZE,
> -		  .conflicts = { D_AGCOUNT,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_AGCOUNT },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = XFS_AG_MAX_BYTES,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SU,
> -		  .conflicts = { D_NOALIGN,
> -				 D_SUNIT,
> -				 D_SWIDTH,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_NOALIGN },
> +				 { &dopts, D_SUNIT },
> +				 { &dopts, D_SWIDTH },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SW,
> -		  .conflicts = { D_NOALIGN,
> -				 D_SUNIT,
> -				 D_SWIDTH,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_NOALIGN },
> +				 { &dopts, D_SUNIT },
> +				 { &dopts, D_SWIDTH },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTLOG,
> -		  .conflicts = { D_SECTSIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_SECTSIZE },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTSIZE,
> -		  .conflicts = { D_SECTLOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_SECTLOG },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -285,35 +288,35 @@ struct opt_params dopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_NOALIGN,
> -		  .conflicts = { D_SU,
> -				 D_SW,
> -				 D_SUNIT,
> -				 D_SWIDTH,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &dopts, D_SU },
> +				 { &dopts, D_SW },
> +				 { &dopts, D_SUNIT },
> +				 { &dopts, D_SWIDTH },
> +				 { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_RTINHERIT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .minval = 1,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_PROJINHERIT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_EXTSZINHERIT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_COWEXTSIZE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &dopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -345,57 +348,57 @@ struct opt_params iopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = I_LOG,
> -		  .conflicts = { I_PERBLOCK,
> -				 I_SIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &iopts, I_PERBLOCK },
> +				 { &iopts, I_SIZE },
> +				 { &iopts, LAST_CONFLICT } },
>  		  .minval = XFS_DINODE_MIN_LOG,
>  		  .maxval = XFS_DINODE_MAX_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_MAXPCT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 100,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PERBLOCK,
> -		  .conflicts = { I_LOG,
> -				 I_SIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &iopts, I_LOG },
> +				 { &iopts, I_SIZE },
> +				 { &iopts, LAST_CONFLICT } },
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_INODE_PERBLOCK,
>  		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_SIZE,
> -		  .conflicts = { I_PERBLOCK,
> -				 I_LOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &iopts, I_PERBLOCK },
> +				 { &iopts, I_LOG },
> +				 { &iopts, LAST_CONFLICT } },
>  		  .is_power_2 = true,
>  		  .minval = XFS_DINODE_MIN_SIZE,
>  		  .maxval = XFS_DINODE_MAX_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_ATTR,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PROJID32BIT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = I_SPINODES,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -434,68 +437,68 @@ struct opt_params lopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = L_AGNUM,
> -		  .conflicts = { L_DEV,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_DEV },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_INTERNAL,
> -		  .conflicts = { L_FILE,
> -				 L_DEV,
> -				 L_SECTLOG,
> -				 L_SECTSIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_FILE },
> +				 { &lopts, L_DEV },
> +				 { &lopts, L_SECTLOG },
> +				 { &lopts, L_SECTSIZE },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = L_SIZE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &lopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
>  		  .maxval = XFS_MAX_LOG_BYTES,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_VERSION,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &lopts, LAST_CONFLICT } },
>  		  .minval = 1,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SUNIT,
> -		  .conflicts = { L_SU,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_SU },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .minval = 1,
>  		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SU,
> -		  .conflicts = { L_SUNIT,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_SUNIT },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = BBTOB(1),
>  		  .maxval = XLOG_MAX_RECORD_BSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_DEV,
> -		  .conflicts = { L_AGNUM,
> -				 L_INTERNAL,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_AGNUM },
> +				 { &lopts, L_INTERNAL },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTLOG,
> -		  .conflicts = { L_SECTSIZE,
> -				 L_INTERNAL,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_SECTSIZE },
> +				 { &lopts, L_INTERNAL },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTSIZE,
> -		  .conflicts = { L_SECTLOG,
> -				 L_INTERNAL,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_SECTLOG },
> +				 { &lopts, L_INTERNAL },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -503,20 +506,20 @@ struct opt_params lopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_FILE,
> -		  .conflicts = { L_INTERNAL,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_INTERNAL },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = L_NAME,
> -		  .conflicts = { L_AGNUM,
> -				 L_INTERNAL,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &lopts, L_AGNUM },
> +				 { &lopts, L_INTERNAL },
> +				 { &lopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_LAZYSBCNTR,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &lopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -539,15 +542,15 @@ struct opt_params nopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = N_LOG,
> -		  .conflicts = { N_SIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &nopts, N_SIZE },
> +				 { &nopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_REC_DIRSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_SIZE,
> -		  .conflicts = { N_LOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &nopts, N_LOG },
> +				 { &nopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
> @@ -555,13 +558,13 @@ struct opt_params nopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_VERSION,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &nopts, LAST_CONFLICT } },
>  		  .minval = 2,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_FTYPE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &nopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -588,38 +591,38 @@ struct opt_params ropts = {
>  	},
>  	.subopt_params = {
>  		{ .index = R_EXTSIZE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = XFS_MIN_RTEXTSIZE,
>  		  .maxval = XFS_MAX_RTEXTSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_SIZE,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = LLONG_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_DEV,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_FILE,
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		},
>  		{ .index = R_NAME,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_NOALIGN,
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		},
>  	},
>  };
> @@ -639,25 +642,25 @@ struct opt_params sopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = S_LOG,
> -		  .conflicts = { S_SIZE,
> -				 S_SECTSIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &sopts, S_SIZE },
> +				 { &sopts, S_SECTSIZE },
> +				 { &sopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTLOG,
> -		  .conflicts = { S_SIZE,
> -				 S_SECTSIZE,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &sopts, S_SIZE },
> +				 { &sopts, S_SECTSIZE },
> +				 { &sopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SIZE,
> -		  .conflicts = { S_LOG,
> -				 S_SECTLOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &sopts, S_LOG },
> +				 { &sopts, S_SECTLOG },
> +				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -665,9 +668,9 @@ struct opt_params sopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTSIZE,
> -		  .conflicts = { S_LOG,
> -				 S_SECTLOG,
> -				 LAST_CONFLICT },
> +		  .conflicts = { { &sopts, S_LOG },
> +				 { &sopts, S_SECTLOG },
> +				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -694,29 +697,29 @@ struct opt_params mopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = M_CRC,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &mopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_FINOBT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &mopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_UUID,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &mopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = M_RMAPBT,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &mopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_REFLINK,
> -		  .conflicts = { LAST_CONFLICT },
> +		  .conflicts = { { &mopts, LAST_CONFLICT } },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -925,13 +928,14 @@ usage( void )
>  
>  static void
>  conflict(
> -	char		opt,
> -	const char	*tab[],
> -	int		oldidx,
> -	int		newidx)
> +	struct opt_params       *opts,
> +	int			option,
> +	struct opt_params       *con_opts,
> +	int			conflict)
>  {
>  	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
> -		opt, tab[oldidx], opt, tab[newidx]);
> +			opts->name, opts->subopts[option],
> +			con_opts->name, con_opts->subopts[conflict]);
>  	usage();
>  }
>  
> @@ -1342,14 +1346,13 @@ check_opt(
>  
>  	/* check for conflicts with the option */
>  	for (i = 0; i < MAX_CONFLICTS; i++) {
> -		int conflict_opt = sp->conflicts[i];
> +		struct _conflict *con = &sp->conflicts[i];
>  
> -		if (conflict_opt == LAST_CONFLICT)
> +		if (con->subopt == LAST_CONFLICT)
>  			break;
> -		if (opts->subopt_params[conflict_opt].seen ||
> -		    opts->subopt_params[conflict_opt].str_seen)
> -			conflict(opts->name, opts->subopts,
> -				 conflict_opt, index);
> +		if (con->opts->subopt_params[con->subopt].seen ||
> +		    con->opts->subopt_params[con->subopt].str_seen)
> +			conflict(opts, index, con->opts, con->subopt);
>  	}
>  }
>  
> @@ -1491,13 +1494,13 @@ data_opts_parser(
>  		break;
>  	case D_SECTLOG:
>  		if (cli->sectorsize)
> -			conflict('d', opts->subopts, D_SECTSIZE, D_SECTLOG);
> +			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
>  		sectorlog = getnum(value, opts, D_SECTLOG);
>  		cli->sectorsize = 1 << sectorlog;
>  		break;
>  	case D_SECTSIZE:
>  		if (cli->sectorsize)
> -			conflict('d', opts->subopts, D_SECTSIZE, D_SECTLOG);
> +			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
>  		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
>  		break;
>  	case D_RTINHERIT:
> @@ -1724,7 +1727,7 @@ sector_opts_parser(
>  	case S_LOG:
>  	case S_SECTLOG:
>  		if (cli->sectorsize)
> -			conflict('s', opts->subopts, S_SECTSIZE, S_SECTLOG);
> +			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
>  		sectorlog = getnum(value, opts, S_SECTLOG);
>  		cli->sectorsize = 1 << sectorlog;
>  		cli->lsectorsize = cli->sectorsize;
> @@ -1732,7 +1735,7 @@ sector_opts_parser(
>  	case S_SIZE:
>  	case S_SECTSIZE:
>  		if (cli->sectorsize)
> -			conflict('s', opts->subopts, S_SECTLOG, S_SECTSIZE);
> +			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
>  		cli->sectorsize = getnum(value, opts, S_SECTSIZE);
>  		cli->lsectorsize = cli->sectorsize;
>  		break;
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

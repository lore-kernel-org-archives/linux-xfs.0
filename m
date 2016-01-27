Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 335027CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 07:31:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07A0E30405F
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 05:31:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vPiuoMUmLzeAxErG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2016 05:31:10 -0800 (PST)
Date: Wed, 27 Jan 2016 08:31:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: use named array initializers for log item dumping
Message-ID: <20160127133106.GB60730@bfoster.bfoster>
References: <20160123003425.2338.18133.stgit@birch.djwong.org>
	<20160123003431.2338.77639.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123003431.2338.77639.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 04:34:31PM -0800, Darrick J. Wong wrote:
> Use named array initializers for the string arrays used to dump log
> items, rather than depending on the order being maintained correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c |  132 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 68 insertions(+), 64 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2aa187e..4758f06 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1989,77 +1989,81 @@ xlog_print_tic_res(
>  	uint ophdr_spc = ticket->t_res_num_ophdrs * (uint)sizeof(xlog_op_header_t);
>  
>  	/* match with XLOG_REG_TYPE_* in xfs_log.h */
> -	static char *res_type_str[XLOG_REG_TYPE_MAX] = {
> -	    "bformat",
> -	    "bchunk",
> -	    "efi_format",
> -	    "efd_format",
> -	    "iformat",
> -	    "icore",
> -	    "iext",
> -	    "ibroot",
> -	    "ilocal",
> -	    "iattr_ext",
> -	    "iattr_broot",
> -	    "iattr_local",
> -	    "qformat",
> -	    "dquot",
> -	    "quotaoff",
> -	    "LR header",
> -	    "unmount",
> -	    "commit",
> -	    "trans header"
> +#define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
> +	static char *res_type_str[XLOG_REG_TYPE_MAX + 1] = {

Maybe we should just fix XLOG_REG_TYPE_MAX to hold the array size (as
XFS_TRANS_TYPE_MAX does)..?

> +	    REG_TYPE_STR(BFORMAT, "bformat"),
> +	    REG_TYPE_STR(BCHUNK, "bchunk"),
> +	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
> +	    REG_TYPE_STR(EFD_FORMAT, "efd_format"),
> +	    REG_TYPE_STR(IFORMAT, "iformat"),
> +	    REG_TYPE_STR(ICORE, "icore"),
> +	    REG_TYPE_STR(IEXT, "iext"),
> +	    REG_TYPE_STR(IBROOT, "ibroot"),
> +	    REG_TYPE_STR(ILOCAL, "ilocal"),
> +	    REG_TYPE_STR(IATTR_EXT, "iattr_ext"),
> +	    REG_TYPE_STR(IATTR_BROOT, "iattr_broot"),
> +	    REG_TYPE_STR(IATTR_LOCAL, "iattr_local"),
> +	    REG_TYPE_STR(QFORMAT, "qformat"),
> +	    REG_TYPE_STR(DQUOT, "dquot"),
> +	    REG_TYPE_STR(QUOTAOFF, "quotaoff"),
> +	    REG_TYPE_STR(LRHEADER, "LR header"),
> +	    REG_TYPE_STR(UNMOUNT, "unmount"),
> +	    REG_TYPE_STR(COMMIT, "commit"),
> +	    REG_TYPE_STR(TRANSHDR, "trans header"),
> +	    REG_TYPE_STR(ICREATE, "inode create")
>  	};
> +#undef REG_TYPE_STR
> +#define TRANS_TYPE_STR(type)	[XFS_TRANS_##type] = #type
>  	static char *trans_type_str[XFS_TRANS_TYPE_MAX] = {
...
>  	};
> +#undef TRANS_TYPE_STR
>  
>  	xfs_warn(mp, "xlog_write: reservation summary:");
>  	xfs_warn(mp, "  trans type  = %s (%u)",
>  		 ((ticket->t_trans_type <= 0 ||
>  		   ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
> -		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
> +		  "bad-trans-type" : trans_type_str[ticket->t_trans_type]),

Why not incorporate the -1 offset in the new macros and leave these as
is? That avoids a dummy entry at index 0 in each array as well.

Brian

>  		 ticket->t_trans_type);
>  	xfs_warn(mp, "  unit res    = %d bytes",
>  		 ticket->t_unit_res);
> @@ -2078,7 +2082,7 @@ xlog_print_tic_res(
>  		uint r_type = ticket->t_res_arr[i].r_type;
>  		xfs_warn(mp, "region[%u]: %s - %u bytes", i,
>  			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
> -			    "bad-rtype" : res_type_str[r_type-1]),
> +			    "bad-rtype" : res_type_str[r_type]),
>  			    ticket->t_res_arr[i].r_len);
>  	}
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

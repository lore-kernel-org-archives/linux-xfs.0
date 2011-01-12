Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C4DBeg137256 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 22:13:11 -0600
Subject: Re: [PATCH 04/12] xfs: Convert xlog_warn to new logging interface
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294792553-8378-5-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-5-git-send-email-david@fromorbit.com>
Date: Tue, 11 Jan 2011 22:13:32 -0600
Message-ID: <1294805612.3115.128.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-01-12 at 11:35 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the xfs log operations to use the new error logging
> interfaces. This removes the xlog_{warn,panic} wrappers and makes
> almost all errors emit the device they belong to instead of just
> refering to "XFS".
> 

One mistake noted below, otherwise:

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/quota/xfs_dquot.c |   10 ++-
>  fs/xfs/quota/xfs_qm.c    |    2 +-
>  fs/xfs/xfs_log.c         |  124 ++++++++++++-------------
>  fs/xfs/xfs_log_priv.h    |    4 -
>  fs/xfs/xfs_log_recover.c |  223 ++++++++++++++++++++++-----------------------

. . .

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ae6fef1..d645f09 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c

. . .

> @@ -1563,38 +1561,36 @@ xlog_print_tic_res(
>  	    "SWAPEXT"
>  	};
>  
> -	xfs_fs_cmn_err(CE_WARN, mp,
> -			"xfs_log_write: reservation summary:\n"
> -			"  trans type  = %s (%u)\n"
> -			"  unit res    = %d bytes\n"
> -			"  current res = %d bytes\n"
> -			"  total reg   = %u bytes (o/flow = %u bytes)\n"
> -			"  ophdrs      = %u (ophdr space = %u bytes)\n"
> -			"  ophdr + reg = %u bytes\n"
> -			"  num regions = %u\n",
> -			((ticket->t_trans_type <= 0 ||
> -			  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
> -			  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
> -			ticket->t_trans_type,
> -			ticket->t_unit_res,
> -			ticket->t_curr_res,
> -			ticket->t_res_arr_sum, ticket->t_res_o_flow,
> -			ticket->t_res_num_ophdrs, ophdr_spc,
> -			ticket->t_res_arr_sum + 
> -			ticket->t_res_o_flow + ophdr_spc,
> -			ticket->t_res_num);
> +	xfs_alert(mp,

	xfs_warn(mp,

> +		"xfs_log_write: reservation summary:\n"
> +		"  trans type  = %s (%u)\n"
> +		"  unit res    = %d bytes\n"
> +		"  current res = %d bytes\n"
> +		"  total reg   = %u bytes (o/flow = %u bytes)\n"
> +		"  ophdrs      = %u (ophdr space = %u bytes)\n"
> +		"  ophdr + reg = %u bytes\n"
> +		"  num regions = %u\n",
> +		((ticket->t_trans_type <= 0 ||
> +		  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
> +		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
> +		ticket->t_trans_type,
> +		ticket->t_unit_res,
> +		ticket->t_curr_res,
> +		ticket->t_res_arr_sum, ticket->t_res_o_flow,
> +		ticket->t_res_num_ophdrs, ophdr_spc,
> +		ticket->t_res_arr_sum +
> +		ticket->t_res_o_flow + ophdr_spc,
> +		ticket->t_res_num);
>  
>  	for (i = 0; i < ticket->t_res_num; i++) {
> -		uint r_type = ticket->t_res_arr[i].r_type; 
> -		cmn_err(CE_WARN,
> -			    "region[%u]: %s - %u bytes\n",
> -			    i, 
> +		uint r_type = ticket->t_res_arr[i].r_type;
> +		xfs_warn(mp, "region[%u]: %s - %u bytes\n", i,
>  			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
>  			    "bad-rtype" : res_type_str[r_type-1]),
>  			    ticket->t_res_arr[i].r_len);
>  	}
>  
> -	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
> +	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
>  		"xfs_log_write: reservation ran out. Need to up reservation");
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  }

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

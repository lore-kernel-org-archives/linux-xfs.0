Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49E377F52
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 10:15:30 -0500 (CDT)
Message-ID: <51EE9E11.8000508@sgi.com>
Date: Tue, 23 Jul 2013 10:15:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 41/49] xfs: Add xfs_log_rlimit.c
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-42-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-42-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:25, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Add source files for xfs_log_rlimit.c The new file is used for log
> size calculations and validation shared with userspace.
>
> [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
> tr_attrsetm reservation, just calculates the maximum. ]
>
> [dchinner: rework loop in xfs_log_get_max_trans_res() ]
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

> +	if (lsunit)
> +		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
> +	else
> +		min_logblks = BTOBB(max_logres);

^^ The space is not really needed when using the below multiplier, but 
add the 2 * BBSIZE size just to be consistent?

> +	min_logblks *= XFS_MIN_LOG_FACTOR;

^^ okay, a 3 times multiplier of the max transaction and an additional 
log stripe unit padding will more than make up for all my CIL/CTX concerns.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6460529DFC
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:22:34 -0500 (CDT)
Message-ID: <522A1D69.1020700@sgi.com>
Date: Fri, 06 Sep 2013 13:22:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 46/55] xfs: Add xfs_log_rlimit.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-47-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
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
> [dchinner: implement xfs_log_calc_unit_res() in util.c to give mkfs
> a worse case calculation of the log size needed. ]
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Already reviewed in other posting.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

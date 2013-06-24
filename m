Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1D767F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 16:26:33 -0500 (CDT)
Message-ID: <51C8B984.3090400@sgi.com>
Date: Mon, 24 Jun 2013 16:26:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-60-git-send-email-david@fromorbit.com>
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

On 06/18/13 23:51, Dave Chinner wrote:
> +	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
> +	 *    for the reservation because there are two log writes that can
> +	 *    require padding - the transaction data and the commit record which
> +	 *    are written separately and both can require padding to the LSU.
> +	 *    Consider that we can have an active CIL reservation holding 2*LSU,
> +	 *    but the CIL is not over a push threshold, in this case, if we
> +	 *    don't have enough log space for at one new transaction, which
> +	 *    includes another 2*LSU in the reservation, we will run into dead
> +	 *    loop situation in log space grant procedure. i.e.
> +	 *    xlog_grant_head_wait().
> +	 *
> +	 *    Hence the log size needs to be able to contain two maximally sized
> +	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
> +	 *

Any thoughts on how we can separate the 2 * log stripe unit from the 
reservation.

The added extended attribute calls for parent inode pointers (especially 
xfs_rename() where it could add up to one and remove up to two 
attributes) is causing a huge multiplication cnt for reservation. Those 
multiplications would be killers on 256KiB log stripe units.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

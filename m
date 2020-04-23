Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A328EC2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F093206B9
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgDWEqJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 00:46:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45150 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgDWEqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:46:09 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A706C820799;
        Thu, 23 Apr 2020 14:46:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTkS-0000P0-PS; Thu, 23 Apr 2020 14:46:04 +1000
Date:   Thu, 23 Apr 2020 14:46:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200423044604.GI27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-6-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=b_QqpttUgBRde-ZydO8A:9 a=GK0pHGH6ASMIHaOo:21 a=zSmhVrXdMMoc41sw:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> At unmount time, XFS emits a warning for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount.
> 
> We already have a ratelimit state defined for buffers failing
> writeback. Fold this state into the buftarg and reuse it for the
> unmount time errors.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine, but I suspect we both missed something here:
xfs_buf_ioerror_alert() was made a ratelimited printk in the last
cycle:

void
xfs_buf_ioerror_alert(
        struct xfs_buf          *bp,
        xfs_failaddr_t          func)
{
        xfs_alert_ratelimited(bp->b_mount,
"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
                        func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
                        -bp->b_error);
}

Hence I think all these buffer error alerts can be brought under the
same rate limiting variable. Something like this in xfs_message.c:

void
xfs_buf_alert_ratelimited(
        struct xfs_buf          *bp,
	const char		*rlmsg,
	const char		*fmt,
	...)
{
	struct va_format        vaf;
	va_list                 args;

	if (!___ratelimit(&bp->b_target->bt_ioerror_rl, rlmsg)
		return;

	va_start(args, fmt);
	vaf.fmt = fmt;
	vaf.args = &args;
	__xfs_printk(KERN_ALERT, bp->b_mount, &vaf);
	va_end(args);
}

and:

void
xfs_buf_ioerror_alert(
        struct xfs_buf          *bp,
        xfs_failaddr_t          func)
{
	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
		func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length, -bp->b_error);
}


> ---
>  fs/xfs/xfs_buf.c      | 13 +++++++++++--
>  fs/xfs/xfs_buf.h      |  1 +
>  fs/xfs/xfs_buf_item.c | 10 +---------
>  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7a6bc617f0a9..c28a93d2fd8c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1684,10 +1684,12 @@ xfs_wait_buftarg(
>  			struct xfs_buf *bp;
>  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  			list_del_init(&bp->b_lru);
> -			if (bp->b_flags & XBF_WRITE_FAIL) {
> +			if (bp->b_flags & XBF_WRITE_FAIL &&
> +			    ___ratelimit(&bp->b_target->bt_ioerror_rl,
> +					 "XFS: Corruption Alert")) {
>  				xfs_alert(btp->bt_mount,
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> -					(long long)bp->b_bn);
> +					  (long long)bp->b_bn);
>  				xfs_alert(btp->bt_mount,
>  "Please run xfs_repair to determine the extent of the problem.");
>  			}

I think if we are tossing away metadata here, we should probably
shut down the filesystem once the loop has completed. That way we
get all the normal warnings about running xfs_repair and don't have
to open code it here...

> -
>  STATIC uint
>  xfs_buf_item_push(
>  	struct xfs_log_item	*lip,
> @@ -518,7 +510,7 @@ xfs_buf_item_push(
>  
>  	/* has a previous flush failed due to IO errors? */
>  	if ((bp->b_flags & XBF_WRITE_FAIL) &&
> -	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
> +	    ___ratelimit(&bp->b_target->bt_ioerror_rl, "XFS: Failing async write")) {
>  		xfs_warn(bp->b_mount,
>  "Failing async write on buffer block 0x%llx. Retrying async write.",
>  			 (long long)bp->b_bn);

This gets simplified to:

	if (bp->b_flags & XBF_WRITE_FAIL) {
		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
"Failing async write on buffer block 0x%llx. Retrying async write.",
					(long long)bp->b_bn);
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BE7C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6E62074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgD3WHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:07:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44897 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727058AbgD3WHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:07:49 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9784F3A33FE;
        Fri,  1 May 2020 08:07:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jUHLL-0000CE-RR; Fri, 01 May 2020 08:07:43 +1000
Date:   Fri, 1 May 2020 08:07:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/17] xfs: ratelimit unmount time per-buffer I/O
 error alert
Message-ID: <20200430220743.GJ2040@dread.disaster.area>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-8-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=8Z6F-4iF4xnVNqcJd88A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:43PM -0400, Brian Foster wrote:
> At unmount time, XFS emits an alert for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount.
> 
> Now that we have a ratelimit mechanism specifically for buffer
> alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
> Also lift the final repair message out of the loop so it always
> prints and assert that the metadata error handling code has shut
> down the fs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 594d5e1df6f8..8f0f605de579 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1657,7 +1657,8 @@ xfs_wait_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
>  	LIST_HEAD(dispose);
> -	int loop = 0;
> +	int			loop = 0;
> +	bool			write_fail = false;
>  
>  	/*
>  	 * First wait on the buftarg I/O count for all in-flight buffers to be
> @@ -1685,17 +1686,23 @@ xfs_wait_buftarg(
>  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  			list_del_init(&bp->b_lru);
>  			if (bp->b_flags & XBF_WRITE_FAIL) {
> -				xfs_alert(btp->bt_mount,
> +				write_fail = true;
> +				xfs_buf_alert_ratelimited(bp,
> +					"XFS: Corruption Alert",
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
>  					(long long)bp->b_bn);
> -				xfs_alert(btp->bt_mount,
> -"Please run xfs_repair to determine the extent of the problem.");
>  			}
>  			xfs_buf_rele(bp);
>  		}
>  		if (loop++ != 0)
>  			delay(100);
>  	}
> +
> +	if (write_fail) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));

I think this is incorrect. A metadata write that is set to retry
forever and is failing because of a bad sector or some other
persistent device error will not shut down the filesystem, but still
be reported here as a failure. Hence we can easily get here without
a filesystem shutdown having occurred...

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DC1C54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 02:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96767206A5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 02:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDTCsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 22:48:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43951 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgDTCsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 22:48:42 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 925133A39A7;
        Mon, 20 Apr 2020 12:48:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQMUC-0007oS-3K; Mon, 20 Apr 2020 12:48:40 +1000
Date:   Mon, 20 Apr 2020 12:48:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: factor out buffer I/O failure simulation code
Message-ID: <20200420024840.GE9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-3-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=YRJZO3tkELT-KBUD4jIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:49AM -0400, Brian Foster wrote:
> We use the same buffer I/O failure simulation code in a few
> different places. It's not much code, but it's not necessarily
> self-explanatory. Factor it into a helper and document it in one
> place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c      | 23 +++++++++++++++++++----
>  fs/xfs/xfs_buf.h      |  1 +
>  fs/xfs/xfs_buf_item.c | 22 +++-------------------
>  fs/xfs/xfs_inode.c    |  7 +------
>  4 files changed, 24 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9ec3eaf1c618..93942d8e35dd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1248,6 +1248,24 @@ xfs_buf_ioerror_alert(
>  			-bp->b_error);
>  }
>  
> +/*
> +  * To simulate an I/O failure, the buffer must be locked and held with at least

Whitespace.

> + * three references. The LRU reference is dropped by the stale call. The buf
> + * item reference is dropped via ioend processing. The third reference is owned
> + * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
> + */
> +void
> +xfs_buf_iofail(
> +	struct xfs_buf	*bp,
> +	int		flags)
> +{
> +	bp->b_flags |= flags;
> +	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_stale(bp);
> +	xfs_buf_ioerror(bp, -EIO);
> +	xfs_buf_ioend(bp);
> +}

This function is an IO completion function. Can we call it
xfs_buf_ioend_fail(), please, to indicate that it both fails and
completes the IO in progress?


Otherwise ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4AAC0044D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 00:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6D0206E2
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 00:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbgCQAPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 20:15:46 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47119 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732960AbgCQAPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 20:15:46 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 750513A235F;
        Tue, 17 Mar 2020 11:15:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jDztW-0005NI-0Y; Tue, 17 Mar 2020 11:15:42 +1100
Date:   Tue, 17 Mar 2020 11:15:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: merge xlog_cil_push into xlog_cil_push_work
Message-ID: <20200317001541.GS10776@dread.disaster.area>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-2-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=TDf9XxNU75roeiFt9qAA:9
        a=aL6r1SzTO5whl0UJ:21 a=XNDS9AlzluPwmJ97:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:20PM +0100, Christoph Hellwig wrote:
> xlog_cil_push is only called by xlog_cil_push_work, so merge the two
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++---------------------------
>  1 file changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..6a6278b8eb2d 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -626,24 +626,26 @@ xlog_cil_process_committed(
>  }
>  
>  /*
> - * Push the Committed Item List to the log. If @push_seq flag is zero, then it
> - * is a background flush and so we can chose to ignore it. Otherwise, if the
> - * current sequence is the same as @push_seq we need to do a flush. If
> - * @push_seq is less than the current sequence, then it has already been
> + * Push the Committed Item List to the log.
> + *
> + * If the current sequence is the same as xc_push_seq we need to do a flush. If
> + * xc_push_seq is less than the current sequence, then it has already been
>   * flushed and we don't need to do anything - the caller will wait for it to
>   * complete if necessary.
>   *
> - * @push_seq is a value rather than a flag because that allows us to do an
> - * unlocked check of the sequence number for a match. Hence we can allows log
> - * forces to run racily and not issue pushes for the same sequence twice. If we
> - * get a race between multiple pushes for the same sequence they will block on
> - * the first one and then abort, hence avoiding needless pushes.
> + * xc_push_seq is checked unlocked against the sequence number for a match.
> + * Hence we can allows log forces to run racily and not issue pushes for the
                   ^^^^^^
		   allow

> + * same sequence twice.  If we get a race between multiple pushes for the same
> + * sequence they will block on the first one and then abort, hence avoiding
> + * needless pushes.

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

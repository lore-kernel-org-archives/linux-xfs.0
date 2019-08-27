Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1229C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 23:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FB1205C9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 23:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfH0X3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:29:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60163 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbfH0X3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 19:29:17 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D1930360EC3;
        Wed, 28 Aug 2019 09:29:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2ktj-0001We-U0; Wed, 28 Aug 2019 09:29:11 +1000
Date:   Wed, 28 Aug 2019 09:29:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: log proper length of btree block in scrub/repair
Message-ID: <20190827232911.GJ1119@dread.disaster.area>
References: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=riuVGc2jU5OFhNDM0CwA:9
        a=zi4I9Ah368d7wbtw:21 a=VkAaf6lrBJljG037:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 02:17:36PM -0500, Eric Sandeen wrote:
> xfs_trans_log_buf() takes a final argument of the last byte to
> log in the buffer; b_length is in basic blocks, so this isn't
> the correct last byte.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> just found by inspection/pattern matching, not tested TBH...
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 4cfeec57fb05..7bcc755beb40 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -351,7 +351,7 @@ xrep_init_btblock(
>  	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
>  	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
> -	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
> +	xfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length) - 1);

Ok, while this is technically wrong, it would not have resulted in a
bug at all. That's because the length would have been rounded up
to a BLFCHUNK of 128 bytes, and that covers the entire btree block
header. Hence the part of the buffer that actually matters for
recovery was still logged correctly.

Still, should be fixed, so consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

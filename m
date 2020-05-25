Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4536FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 00:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1849C20776
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 00:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgEYAG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 20:06:27 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41308 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388149AbgEYAG1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 20:06:27 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 48EC6D5956B;
        Mon, 25 May 2020 10:06:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd0dI-0001Hf-A5; Mon, 25 May 2020 10:06:20 +1000
Date:   Mon, 25 May 2020 10:06:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/24] xfs: mark inode buffers in cache
Message-ID: <20200525000620.GT2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-4-david@fromorbit.com>
 <20200523084827.GB31566@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523084827.GB31566@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=LoOfA7Ww2QlmTMG1DeoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 01:48:27AM -0700, Christoph Hellwig wrote:
> On Fri, May 22, 2020 at 01:50:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Inode buffers always have write IO callbacks, so by marking them
> > directly we can avoid needing to attach ->b_iodone functions to
> > them. This avoids an indirect call, and makes future modifications
> > much simpler.
> > 
> > This is largely a rearrangement of the code at this point - no IO
> > completion functionality changes at this point, just how the
> > code is run is modified.
> 
> So I've looked over the whole series where this leads, and I really like
> killing off li_cb and sorting out the mess around b_iodone.  But I think
> the series ends up moving too much out of xfs_buf.c.  I'd rather keep
> a minimal b_write_done callback rather than the checking of the inode
> and dquote flags, and keep most of the logic in xfs_buf.c.  This is the
> patch I cooked up on top of your series to show what I mean - it removes
> the need for both flags and kills about 100 lines of code:

Let's deal with further cleanups after this patchset and the
follow-on patchsets that I have are sorted out. All cleanups will do
right now is invalidate all the stuff I'm still working on that sits
on top of this patchset..

> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index e5f58a4b13eee..4220fee1c9ddb 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -169,7 +169,7 @@ xfs_trans_log_inode(
>  		xfs_buf_hold(bp);
>  		spin_lock(&iip->ili_lock);
>  		iip->ili_item.li_buf = bp;
> -		bp->b_flags |= _XBF_INODES;
> +		bp->b_write_done = xfs_iflush_done;

I originally tried this, but then I ended up with places in
follow-on patchsets where I had to do this sort of check:

	if (bp->b_write_done == xfs_iflush_done)

To detect a buffer that already had inodes attached to it. Which
clearly told me that there should be a state flag to indicate that
the buffer has attached inodes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

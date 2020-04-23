Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E57C54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 21:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443C620728
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 21:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDWVOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 17:14:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45770 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDWVOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 17:14:41 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7E1E23A2C81;
        Fri, 24 Apr 2020 07:14:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRjB7-0006Ez-1J; Fri, 24 Apr 2020 07:14:37 +1000
Date:   Fri, 24 Apr 2020 07:14:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200423211437.GP27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
 <20200423044604.GI27860@dread.disaster.area>
 <20200423142958.GB43557@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423142958.GB43557@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=DMlZY9ff6PqbcFkLXZUA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 10:29:58AM -0400, Brian Foster wrote:
> On Thu, Apr 23, 2020 at 02:46:04PM +1000, Dave Chinner wrote:
> > On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> > > At unmount time, XFS emits a warning for every in-core buffer that
> > > might have undergone a write error. In practice this behavior is
> > > probably reasonable given that the filesystem is likely short lived
> > > once I/O errors begin to occur consistently. Under certain test or
> > > otherwise expected error conditions, this can spam the logs and slow
> > > down the unmount.
> > > 
> > > We already have a ratelimit state defined for buffers failing
> > > writeback. Fold this state into the buftarg and reuse it for the
> > > unmount time errors.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Looks fine, but I suspect we both missed something here:
> > xfs_buf_ioerror_alert() was made a ratelimited printk in the last
> > cycle:
> > 
> > void
> > xfs_buf_ioerror_alert(
> >         struct xfs_buf          *bp,
> >         xfs_failaddr_t          func)
> > {
> >         xfs_alert_ratelimited(bp->b_mount,
> > "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> >                         func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> >                         -bp->b_error);
> > }
> > 
> 
> Yeah, I hadn't noticed that.
> 
> > Hence I think all these buffer error alerts can be brought under the
> > same rate limiting variable. Something like this in xfs_message.c:
> > 
> 
> One thing to note is that xfs_alert_ratelimited() ultimately uses
> the DEFAULT_RATELIMIT_INTERVAL of 5s. The ratelimit we're generalizing
> here uses 30s (both use a burst of 10). That seems reasonable enough to
> me for I/O errors so I'm good with the changes below.
> 
> FWIW, that also means we could just call xfs_buf_alert_ratelimited()
> from xfs_buf_item_push() if we're also Ok with using an "alert" instead
> of a "warn." I'm not immediately aware of a reason to use one over the
> other (xfs_wait_buftarg() already uses alert) so I'll try that unless I
> hear an objection.

SOunds fine to me.

> The xfs_wait_buftarg() ratelimit presumably remains
> open coded because it's two separate calls and we probably don't want
> them to individually count against the limit.

That's why I suggested dropping the second "run xfs_repair" message
and triggering a shutdown after the wait loop. That way we don't
issue "run xfs_repair" for every single failed buffer (largely
noise!), and we get a non-rate-limited common "run xfs-repair"
message once we processed all the failed writes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

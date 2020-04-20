Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440E6C54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242A9206DD
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgDTWXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:23:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47555 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgDTWXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:23:38 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2C29B5836FF;
        Tue, 21 Apr 2020 08:23:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQepA-0006KZ-QY; Tue, 21 Apr 2020 08:23:32 +1000
Date:   Tue, 21 Apr 2020 08:23:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error
 warning
Message-ID: <20200420222332.GP9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-6-bfoster@redhat.com>
 <20200420031959.GH9800@dread.disaster.area>
 <20200420140205.GE27516@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420140205.GE27516@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=BE_2l6gJ5e0v_kKrTcUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 10:02:05AM -0400, Brian Foster wrote:
> On Mon, Apr 20, 2020 at 01:19:59PM +1000, Dave Chinner wrote:
> > On Fri, Apr 17, 2020 at 11:08:52AM -0400, Brian Foster wrote:
> > > At unmount time, XFS emits a warning for every in-core buffer that
> > > might have undergone a write error. In practice this behavior is
> > > probably reasonable given that the filesystem is likely short lived
> > > once I/O errors begin to occur consistently. Under certain test or
> > > otherwise expected error conditions, this can spam the logs and slow
> > > down the unmount. Ratelimit the warning to prevent this problem
> > > while still informing the user that errors have occurred.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf.c | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 93942d8e35dd..5120fed06075 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
> > >  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
> > >  			list_del_init(&bp->b_lru);
> > >  			if (bp->b_flags & XBF_WRITE_FAIL) {
> > > -				xfs_alert(btp->bt_mount,
> > > -"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > > +				xfs_alert_ratelimited(btp->bt_mount,
> > > +"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\n"
> > > +"Please run xfs_repair to determine the extent of the problem.",
> > >  					(long long)bp->b_bn);
> > 
> > Hmmmm. I was under the impression that multiple line log messages
> > were frowned upon because they prevent every output line in the log
> > being tagged correctly. That's where KERN_CONT came from (i.e. it's
> > a continuation of a previous log message), but we don't use that
> > with the XFS logging and hence multi-line log messages are split
> > into multiple logging calls.
> > 
> 
> I debated combining these into a single line for that exact reason for
> about a second and then just went with this because I didn't think it
> mattered that much.

It doesn't matter to us, but it does matter to those people who want
their log entries correctly tagged for their classification
engines...

> > IOWs, this might be better handled just using a static ratelimit
> > variable here....
> > 
> > Actually, we already have one for xfs_buf_item_push() to limit
> > warnings about retrying XBF_WRITE_FAIL buffers:
> > 
> > static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
> > 
> > Perhaps we should be using the same ratelimit variable here....
> > 
> 
> IIRC that was static in another file, but we can centralize (and perhaps
> generalize..) it somewhere if that is preferred..

I think it makes sense to have all the buffer write fail
messages ratelimited under the same variable - once it starts
spewing messages, we should limit them all the same way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384B1C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 23:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1821D2075D
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 23:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388512AbgEXXyr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 19:54:47 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36806 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388124AbgEXXyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 19:54:47 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 555EF5AA2E7;
        Mon, 25 May 2020 09:54:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd0Rz-000186-Pi; Mon, 25 May 2020 09:54:39 +1000
Date:   Mon, 25 May 2020 09:54:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 05/24] xfs: mark log recovery buffers for completion
Message-ID: <20200524235439.GS2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-6-david@fromorbit.com>
 <CAOQ4uxgBbRNTpmj9j3C6cZL2Ldj6h6L=Ft26Cef2-iKoX1KXsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgBbRNTpmj9j3C6cZL2Ldj6h6L=Ft26Cef2-iKoX1KXsw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=R7Ubp6OAIPT-dX00P40A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 10:41:21AM +0300, Amir Goldstein wrote:
> On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Log recovery has it's own buffer write completion handler for
> > buffers that it directly recovers. Convert these to direct calls by
> > flagging these buffers as being log recovery buffers. The flag will
> > get cleared by the log recovery IO completion routine, so it will
> > never leak out of log recovery.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c                | 10 ++++++++++
> >  fs/xfs/xfs_buf.h                |  2 ++
> >  fs/xfs/xfs_buf_item_recover.c   |  5 ++---
> >  fs/xfs/xfs_dquot_item_recover.c |  2 +-
> >  fs/xfs/xfs_inode_item_recover.c |  2 +-
> >  fs/xfs/xfs_log_recover.c        |  5 ++---
> >  6 files changed, 18 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 77d40eb4a11db..b89685ce8519d 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -14,6 +14,7 @@
> >  #include "xfs_mount.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_log.h"
> > +#include "xfs_log_recover.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_buf_item.h"
> >  #include "xfs_errortag.h"
> > @@ -1207,6 +1208,15 @@ xfs_buf_ioend(
> >         if (read)
> >                 goto out_finish;
> >
> > +       /*
> > +        * If this is a log recovery buffer, we aren't doing transactional IO
> > +        * yet so we need to let it handle IO completions.
> > +        */
> > +       if (bp->b_flags & _XBF_LOGRCVY) {
> > +               xlog_recover_iodone(bp);
> > +               return;
> > +       }
> > +
> >         /* inodes always have a callback on write */
> >         if (bp->b_flags & _XBF_INODES) {
> >                 xfs_buf_inode_iodone(bp);
> 
> This turns out to be a "static calls" pattern.

Yes, that was one of the intents of this set of changes - to remove
a function pointer that is largely unnecessary. The main point of it
was to clearly separate out the different completions that need to
be run.

> I think it would look nicer as a switch statement on
> (bp->b_flags & _XBF_BUFFER_TYPE_MASK)
> It would be also nicer to document near flag definition
> that the type flags are mutually exclusive.

That doesn't actually make the code any more compact.

	case _XBF_LOGRCVY:
	       /*
		* If this is a log recovery buffer, we aren't doing
		* transactional IO yet so we need to let it handle IO
		* completions.
		*/
		xlog_recover_iodone(bp);
		return;

Is actually more lines of additional code than just a set of if()
based flag checks. So adding a mask just to make this handling a
switch statement is largely marginal as to it's benefit here.

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index ec015df55b77a..0aa823aeafca9 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -287,9 +287,8 @@ xlog_recover_iodone(
> >         if (bp->b_log_item)
> >                 xfs_buf_item_relse(bp);
> >         ASSERT(bp->b_log_item == NULL);
> > -
> > -       bp->b_iodone = NULL;
> > -       xfs_buf_ioend(bp);
> > +       bp->b_flags &= ~_XBF_LOGRCVY;
> > +       xfs_buf_ioend_finish(bp);
> 
> 
> For someone like me who does not know all the assumptions
> about buffers, why is this fag leak prevention needed for log recovery
> buffers and not for inode/dquote buffers?
> 
> Wouldn't it be better to have:
>        bp->b_flags &= ~_XBF_BUFFER_TYPE_MASK;
> 
> inside xfs_buf_ioend_finish()?

No. The flag indicates there is a completion to run on the buffer;
having the completion run does not mean the next time the buffer is
written the completion doesn't need to run. i.e. for writes during
log recovery, the flag is a one-shot. It will be set before each
write, and cleared afterwards. For something like inode cluster
buffers, it will be set when the inode is attached to the buffer,
and cleared when there are no more inodes attached to it. There may
be hundreds of IO completions run on the buffer between attach and
detatch, so clearing the _XBF_INODES flag in xfs_buf_ioend_finish()
is completely wrong.

i.e. the flag is not managed by the buffer cache infrastructure; it's
owned by the subsystem that is attaching things to the buffer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69B5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 21:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92D4207DA
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 21:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgFBViO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 17:38:14 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33540 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbgFBViO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 17:38:14 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B2F9C82094B;
        Wed,  3 Jun 2020 07:38:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgEbp-0000cz-AS; Wed, 03 Jun 2020 07:38:09 +1000
Date:   Wed, 3 Jun 2020 07:38:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/30] xfs: call xfs_buf_iodone directly
Message-ID: <20200602213809.GG2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-8-david@fromorbit.com>
 <20200602164742.GG7967@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602164742.GG7967@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=rWSMRbOoVjO0xuiQfU8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 12:47:42PM -0400, Brian Foster wrote:
> On Tue, Jun 02, 2020 at 07:42:28AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > All unmarked dirty buffers should be in the AIL and have log items
> > attached to them. Hence when they are written, we will run a
> > callback to remove the item from the AIL if appropriate. Now that
> > we've handled inode and dquot buffers, all remaining calls are to
> > xfs_buf_iodone() and so we can hard code this rather than use an
> > indirect call.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/xfs_buf.c       | 24 ++++++++----------------
> >  fs/xfs/xfs_buf.h       |  6 +-----
> >  fs/xfs/xfs_buf_item.c  | 40 ++++++++++------------------------------
> >  fs/xfs/xfs_buf_item.h  |  4 ++--
> >  fs/xfs/xfs_trans_buf.c | 13 +++----------
> >  5 files changed, 24 insertions(+), 63 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 0a69de674af9d..d7695b638e994 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> ...
> > @@ -1226,14 +1225,7 @@ xfs_buf_ioend(
> >  		xfs_buf_dquot_iodone(bp);
> >  		return;
> >  	}
> > -
> > -	if (bp->b_iodone) {
> > -		(*(bp->b_iodone))(bp);
> > -		return;
> > -	}
> > -
> > -out_finish:
> > -	xfs_buf_ioend_finish(bp);
> > +	xfs_buf_iodone(bp);
> 
> The way this function ends up would probably look nicer as an if/else
> chain rather than a sequence of internal return statements.

I've kinda avoided refactoring these early patches because they
cascade into non-trivial conflicts with later patches in the series.
I've spent too much time chasing bugs introduced in the later
patches because of conflict resolution not being quite right. Hence
I want to leave cleanup and refactoring to a series after this whole
line of development is complete and the problems are solved.

> BTW, is there a longer term need to have three separate iodone functions
> here that do the same thing?

The inode iodone function changes almost immediately. I did it this
way so that the process of changing the inode buffer completion
functionality did not, in any way, impact on other types of buffers.
We need to go through the same process with dquot buffers, and then
once that is done, we can look to refactor all this into a more
integrated solution that largely sits in xfs_buf.c.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

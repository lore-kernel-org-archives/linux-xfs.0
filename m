Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB6CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 00:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B8320787
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 00:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbgEYAhb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 20:37:31 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38941 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388014AbgEYAhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 20:37:31 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BE7145AC8F2;
        Mon, 25 May 2020 10:37:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd17L-0001Sz-Jt; Mon, 25 May 2020 10:37:23 +1000
Date:   Mon, 25 May 2020 10:37:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/24] xfs: clean up the buffer iodone callback functions
Message-ID: <20200525003723.GU2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-11-david@fromorbit.com>
 <20200522222611.GN8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522222611.GN8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=jo8rPNXKFRnEBjk5R5AA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 03:26:11PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:15PM +1000, Dave Chinner wrote:
> > @@ -1188,19 +1146,10 @@ void
> >  xfs_buf_inode_iodone(
> >  	struct xfs_buf		*bp)
> >  {
> > -	struct xfs_buf_log_item *blip = bp->b_log_item;
> > -	struct xfs_log_item	*lip;
> > -
> >  	if (xfs_buf_had_callback_errors(bp))
> >  		return;
> >  
> > -	/* If there is a buf_log_item attached, run its callback */
> > -	if (blip) {
> > -		lip = &blip->bli_item;
> > -		lip->li_cb(bp, lip);
> > -		bp->b_log_item = NULL;
> > -	}
> > -
> > +	xfs_buf_item_done(bp);
> >  	xfs_iflush_done(bp);
> 
> Just out of curiosity, we still have a reference to bp here even if
> xfs_buf_item_done calls xfs_buf_rele, right? 

Yes, the IO still has a reference to the buffer that won't be
released until the xfs_buf_ioend_finish() call is made.

> I think the answer is that yes
> we do still have the reference because the inodes themselves hold references
> to the cluster buffer, right?

That too, but the important one is the IO reference as even the
inode references can go away on completion at this point.

> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Ta.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

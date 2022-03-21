Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76338C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 22:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiCUWuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 18:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiCUWtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 18:49:40 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CFB12BB26
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:43:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9E24910E4978;
        Tue, 22 Mar 2022 09:43:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWQkY-008Hot-8R; Tue, 22 Mar 2022 09:43:42 +1100
Date:   Tue, 22 Mar 2022 09:43:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220321224342.GL1544202@dread.disaster.area>
References: <20220321012329.376307-1-david@fromorbit.com>
 <20220321012329.376307-2-david@fromorbit.com>
 <20220321215620.GL8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321215620.GL8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6238ff9f
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=fnGCBbFQ-lOUCcpozYYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 02:56:20PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 21, 2022 at 12:23:28PM +1100, Dave Chinner wrote:
> > +
> > +	/*
> > +	 * Capture the associated buffer and lock it if the caller didn't
> > +	 * pass us the locked buffer to begin with.
> > +	 */
> > +	spin_lock(&iip->ili_lock);
> > +	bp = iip->ili_item.li_buf;
> > +	xfs_iflush_abort_clean(iip);
> > +	spin_unlock(&iip->ili_lock);
> 
> Is the comment here incorrect?  The _shutdown_abort variant will go
> ahead and lock the buffer, but this function does not do that...?

Ah, stale comment from before I refactored it into separate
functions. I'll clean it up....

> > -	xfs_iflags_clear(ip, XFS_IFLUSHING);
> > -	if (bp)
> > -		xfs_buf_rele(bp);
> > +
> > +	/*
> > +	 * Got two references to bp. The first will get droped by 
> 
> "The first will get dropped by..." (spelling and stgit nagging me about
> trailing whitespace)
> 
> > +	 * xfs_iflush_abort() when the item is removed from the buffer list, but
> > +	 * we can't drop our reference until _abort() returns because we have to
> > +	 * unlock the buffer as well. Hence we abort and then unlock and release
> > +	 * our reference to the buffer.
> 
> ...and presumably xfs_iflush_abort will drop the other bp reference at
> some point after where we unlocked the inode item, locked the (held)
> buffer, and relocked the inode item?

Yes, xfs_iflush_abort() will drop the other buffer reference when it
removes the inode from the buffer item list.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

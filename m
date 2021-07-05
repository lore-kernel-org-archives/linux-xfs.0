Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C95C07E95
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 01:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C21D613D2
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 01:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGEBbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jul 2021 21:31:14 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35711 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhGEBbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 21:31:14 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4B16A80B4D5;
        Mon,  5 Jul 2021 11:28:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0DPX-002r3y-5z; Mon, 05 Jul 2021 11:28:35 +1000
Date:   Mon, 5 Jul 2021 11:28:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make forced shutdown processing atomic
Message-ID: <20210705012835.GI664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-6-david@fromorbit.com>
 <YN7NO5tAn6tVnyIb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7NO5tAn6tVnyIb@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=jxlUHEd8FVBbv7CLyDcA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:24:27AM +0100, Christoph Hellwig wrote:
> > +	spin_lock(&mp->m_sb_lock);
> > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > +		spin_unlock(&mp->m_sb_lock);
> >  		return;
> >  	}
> > +	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> > +	if (mp->m_sb_bp)
> > +		mp->m_sb_bp->b_flags |= XBF_DONE;
> > +	spin_unlock(&mp->m_sb_lock);
> 
> Any particular reason for picking m_sb_lock which so far doesn't
> seem to be related to mp->m_flags at all? (On which we probably
> have a few other races, most notably remount).

I was just reusing an existing lock rather than having to add yet
another global scope spinlock just for the shutdown. I can add
another lock but...

... as you point out, m_flags is a mess when it comes to races. I've
got a series somewhere that addresses this... Yeah:

https://lore.kernel.org/linux-xfs/20180820044851.414-1-david@fromorbit.com/

And that does similar things bit making state changes atomic as this
patchset does, in which case the lock around this shutdown state
change goes away...

I need to rebase that series and get it moving again, because we
really do need to split m_flags up into features and atomic
operational state, too. In the mean time, I considered using the
m_sb_lock largely harmless...

> > +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> > +		xfs_stack_trace();
> 
> This seems new and unrelated?

It's run on the majority of shutdowns already, but not all. It makes
no sense to have an error level triggered stack dump on shutdown and
not actually use it multiple shutdown vectors - that has been
problematic in the past when trying to diagnose shutdown causes in
the field. I'll add a comment to the commit description.

> > +
> 
> Spurious empty line at the end of the function.

Removed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

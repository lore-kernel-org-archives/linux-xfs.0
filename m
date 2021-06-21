Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B2FC49361
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839F86113C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhFUGbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 02:31:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49307 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhFUGbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 02:31:45 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 01EE386361E;
        Mon, 21 Jun 2021 16:29:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvDR3-00FE07-8P; Mon, 21 Jun 2021 16:29:29 +1000
Date:   Mon, 21 Jun 2021 16:29:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
Message-ID: <20210621062929.GV664593@dread.disaster.area>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404245053.2377241.2678360661858649500.stgit@locust>
 <YNAj8xlFB/XnmVIn@infradead.org>
 <20210621060222.GU664593@dread.disaster.area>
 <YNAscPMObALPLYLa@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNAscPMObALPLYLa@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=j2Kn81u3C99JlEvtx70A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 07:06:40AM +0100, Christoph Hellwig wrote:
> On Mon, Jun 21, 2021 at 04:02:22PM +1000, Dave Chinner wrote:
> > > >  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> > > >  		xfs_alert(mp,
> > > > -"User initiated shutdown received. Shutting down filesystem");
> > > > +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> > > > +				flags);
> > > >  		return;
> > > >  	}
> > > 
> > > So SHUTDOWN_FORCE_UMOUNT can actually be used together with
> > > SHUTDOWN_LOG_IO_ERROR so printing something more specific could be
> > > useful, although I'd prefer text over the hex flags.
> > 
> > I'm in the process of reworking the shutdown code because shutdown
> > is so, so very broken. Can we just fix the message and stop moving
> > the goal posts on me while I try to fix bugs?
> 
> I suggest just not adding these not very useful flags.  That is not
> moving the goal post.  And I'm growing really tried of this pointlessly
> aggressive attitude.

Aggressive? Not at all. I'm being realistic.

We've still got bugs in the for-next tree that need to be fixed and
this code is part of the problem. It's already -rc7 and we need to
focus on understanding the bugs in for-next well enough to either
fix them or revert them.

Cosmetic concerns about the code are extremely low priority right
now, so can you please just have a little patience here and wait for
me to deal with the bugs rather than bikeshedding log messages that
might not even exist in a couple of days time?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

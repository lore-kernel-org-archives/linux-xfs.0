Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367C9C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B8B960FE7
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 06:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhFUGEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 02:04:40 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50394 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhFUGEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 02:04:40 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 2F4D25D78;
        Mon, 21 Jun 2021 16:02:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvD0o-00FDYX-CN; Mon, 21 Jun 2021 16:02:22 +1000
Date:   Mon, 21 Jun 2021 16:02:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
Message-ID: <20210621060222.GU664593@dread.disaster.area>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404245053.2377241.2678360661858649500.stgit@locust>
 <YNAj8xlFB/XnmVIn@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNAj8xlFB/XnmVIn@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ssixJMh04jjFr3_Vp5cA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 06:30:27AM +0100, Christoph Hellwig wrote:
> On Fri, Jun 18, 2021 at 11:54:10AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Consolidate the shutdown messages to a single line containing the
> > reason, the passed-in flags, the source of the shutdown, and the end
> > result.  This means we now only have one line to look for when
> > debugging, which is useful when the fs goes down while something else is
> > flooding dmesg.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index b7f979eca1e2..6ed29b158312 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -538,25 +538,25 @@ xfs_do_force_shutdown(
> >  
> >  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> >  		xfs_alert(mp,
> > -"User initiated shutdown received. Shutting down filesystem");
> > +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> > +				flags);
> >  		return;
> >  	}
> 
> So SHUTDOWN_FORCE_UMOUNT can actually be used together with
> SHUTDOWN_LOG_IO_ERROR so printing something more specific could be
> useful, although I'd prefer text over the hex flags.

I'm in the process of reworking the shutdown code because shutdown
is so, so very broken. Can we just fix the message and stop moving
the goal posts on me while I try to fix bugs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

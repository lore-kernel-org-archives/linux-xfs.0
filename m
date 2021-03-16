Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5E5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 03:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A88065076
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 03:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCPDE2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:04:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36331 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231453AbhCPDEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 23:04:07 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 161858280CB;
        Tue, 16 Mar 2021 14:04:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lM004-0031mO-09; Tue, 16 Mar 2021 14:04:04 +1100
Date:   Tue, 16 Mar 2021 14:04:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/45] xfs: xlog_sync() manually adjusts grant head space
Message-ID: <20210316030403.GL63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-45-david@fromorbit.com>
 <20210311020045.GR3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311020045.GR3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=gIL9Y0tZqmN-2cCdLRQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 06:00:45PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:42PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When xlog_sync() rounds off the tail the iclog that is being
> > flushed, it manually subtracts that space from the grant heads. This
> > space is actually reserved by the transaction ticket that covers
> > the xlog_sync() call from xlog_write(), but we don't plumb the
> > ticket down far enough for it to account for the space consumed in
> > the current log ticket.
> > 
> > The grant heads are hot, so we really should be accounting this to
> > the ticket is we can, rather than adding thousands of extra grant
> > head updates every CIL commit.
> > 
> > Interestingly, this actually indicates a potential log space overrun
> > can occur when we force the log. By the time that xfs_log_force()
> > pushes out an active iclog and consumes the roundoff space, the
> 
> Ok I was wondering about that when I was trying to figure out what all
> this ticket space stealing code was doing.
> 
> So in addition to fixing the theoretical overrun, I guess the
> performance fix here is that every time we write an iclog we might have
> to move the grant heads forward so that we always write a full log
> sector / log stripe unit?  And since a CIL context might write a lot of
> iclogs, it's cheaper to make those grant adjustments to the CIL ticket
> (which already asked for enough space to handle the roundoffs) since the
> ticket only jumps in the hot path once when the ticket is ungranted?
> 
> If I got that right,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

You got it right. :)

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

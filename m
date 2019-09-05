Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B8DC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B5412070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbfIEW2E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:28:04 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55070 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbfIEW2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:28:04 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 86E49361C11;
        Fri,  6 Sep 2019 08:28:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i60EU-0002uS-2g; Fri, 06 Sep 2019 08:28:02 +1000
Date:   Fri, 6 Sep 2019 08:28:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: push iclog state cleaning into
 xlog_state_clean_log
Message-ID: <20190905222802.GJ1119@dread.disaster.area>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-8-david@fromorbit.com>
 <20190905154853.GH2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905154853.GH2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=nsMOOVYl7cPwjwDxCrcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:48:53AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 05, 2019 at 06:47:16PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xlog_state_clean_log() is only called from one place, and it occurs
> > when an iclog is transitioning back to ACTIVE. Prior to calling
> > xlog_state_clean_log, the iclog we are processing has a hard coded
> > state check to DIRTY so that xlog_state_clean_log() processes it
> > correctly. We also have a hard coded wakeup after
> > xlog_state_clean_log() to enfore log force waiters on that iclog
> > are woken correctly.
> > 
> > Both of these things are operations required to finish processing an
> > iclog and return it to the ACTIVE state again, so they make little
> > sense to be separated from the rest of the clean state transition
> > code.
> > 
> > Hence push these things inside xlog_state_clean_log(), document the
> > behaviour and rename it xlog_state_clean_iclog() to indicate that
> > it's being driven by an iclog state change and does the iclog state
> > change work itself.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log.c | 57 ++++++++++++++++++++++++++++--------------------
> >  1 file changed, 33 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 356204ddf865..bef314361bc4 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2521,21 +2521,35 @@ xlog_write(
> >   *****************************************************************************
> >   */
> >  
> > -/* Clean iclogs starting from the head.  This ordering must be
> > - * maintained, so an iclog doesn't become ACTIVE beyond one that
> > - * is SYNCING.  This is also required to maintain the notion that we use
> > - * a ordered wait queue to hold off would be writers to the log when every
> > - * iclog is trying to sync to disk.
> > +/*
> > + * An iclog has just finished it's completion processing, so we need to update
> 
> it's -> its, but I can fix that on import.

Fixed - "just finished IO completion processing"...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

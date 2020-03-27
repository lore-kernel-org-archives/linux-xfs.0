Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831FAC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 00:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60951206E6
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 00:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgC0AuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 20:50:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43281 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727722AbgC0AuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 20:50:17 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B740A7EBABD;
        Fri, 27 Mar 2020 11:50:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHdCQ-0006Gz-K4; Fri, 27 Mar 2020 11:50:14 +1100
Date:   Fri, 27 Mar 2020 11:50:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: factor common AIL item deletion code
Message-ID: <20200327005014.GP10776@dread.disaster.area>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-7-david@fromorbit.com>
 <20200326051001.GB29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326051001.GB29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=VUTs4LY8n920DA8nI-sA:9
        a=6IjA9ukDPFaNDi16:21 a=_usyt2Yp5QEbl7kV:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 10:10:01PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 25, 2020 at 12:42:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Factor the common AIL deletion code that does all the wakeups into a
> > helper so we only have one copy of this somewhat tricky code to
> > interface with all the wakeups necessary when the LSN of the log
> > tail changes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> This call site didn't have a wake_up_all and now it does; is that going
> to make a difference?

That logic only changedf for xfs_trans_ail_update_bulk()...

> I /think/ the answer is that this function
> usually puts things on the AIL so we won't trigger the ail_empty wakeup;

which only inserts into the AIL, so will never trigger the "wake up
if AIL empty" code that is now there because the AIL will never be
empty...

> and if the AIL was previously empty and we didn't match any log items
> (such that it's still empty) then it's fine to wake up anyone who was
> waiting for the ail to clear out?

If we are calling xfs_trans_ail_update_bulk() with zero log items on
an empty AIL, we are probably doing something else wrong. But doing
a wakeup on anything waiting on an empty log will not hurt anything
in this case, because the log was already empty and there should be
nothing waiting for the log to empty...

So, yes, it is safe and won't cause strange issues....

> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

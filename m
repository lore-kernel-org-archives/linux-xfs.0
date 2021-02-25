Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78853C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3162A64EC3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhBYWMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:12:09 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51368 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233242AbhBYWMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:12:08 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 7819E107A9F;
        Fri, 26 Feb 2021 09:11:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFOqz-004KYE-SC; Fri, 26 Feb 2021 09:11:25 +1100
Date:   Fri, 26 Feb 2021 09:11:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: only CIL pushes require a start record
Message-ID: <20210225221125.GQ4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-3-david@fromorbit.com>
 <YDdqz9LwTJRZCFmj@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdqz9LwTJRZCFmj@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=a1-E_89XMFGARVMhx3QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 10:15:59AM +0100, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index e8c674b291f3..145f1e847f82 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -652,14 +652,22 @@ xlog_cil_process_committed(
> >  }
> >  
> >  struct xlog_cil_trans_hdr {
> > +	struct xlog_op_header	oph[2];
> >  	struct xfs_trans_header	thdr;
> > -	struct xfs_log_iovec	lhdr;
> > +	struct xfs_log_iovec	lhdr[2];
> 
> oph and lhdr aren't really used as individual arrays.  What about
> splitting them into separate fields and giving them descriptive names?

Because the next steps with this series are to start combining
adjacent regions in a log vector buffer into a single regions to
reduce the number of regions that we have to process in
xlog_write().

I did it this way here just to maintain the current "start rec is
spearate from trans_header" because of all the special treatment of
the start rec in the existing code. Now that all that special
treatment or start records in xlog_write() is gone, we can collapse
this down to just a single region again. I plan to do that in a
future patchset that is just aggregating regions where it is
appropriate for various log items.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

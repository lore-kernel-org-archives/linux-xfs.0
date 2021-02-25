Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AD6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB3064F3A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhBYWOZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:14:25 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56673 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhBYWOZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:14:25 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3AE8E1ADD99;
        Fri, 26 Feb 2021 09:13:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFOtC-004Kfm-Mo; Fri, 26 Feb 2021 09:13:42 +1100
Date:   Fri, 26 Feb 2021 09:13:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: embed the xlog_op_header in the unmount record
Message-ID: <20210225221342.GR4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-5-david@fromorbit.com>
 <YDdwGqzX+izceTtG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdwGqzX+izceTtG@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=dgOzyCXUVIiSXC5iIxMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 10:38:34AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 24, 2021 at 05:34:50PM +1100, Dave Chinner wrote:
> >  	/* Don't account for regions with embedded ophdrs */
> >  	if (optype && headers > 0) {
> > +		headers--;
> >  		if (optype & XLOG_START_TRANS) {
> > +			ASSERT(headers >= 1);
> > +			headers--;
> 
> A more detailed comment on the magic for XLOG_START_TRANS might be useful
> here.
>
> > @@ -2518,14 +2516,13 @@ xlog_write(
> >  			/*
> >  			 * The XLOG_START_TRANS has embedded ophdrs for the
> >  			 * start record and transaction header. They will always
> > -			 * be the first two regions in the lv chain.
> > +			 * be the first two regions in the lv chain. Commit and
> > +			 * unmount records also have embedded ophdrs.
> >  			 */
> 
> Maybe update this comment to cover the other special cases as well?

Again, these all go away later in the patchset, so I'm not going to
spend any time prettifying this. It's there simply to avoid breaking
the log and leaving bisect landmines...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

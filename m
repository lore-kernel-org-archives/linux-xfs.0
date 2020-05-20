Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB5FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 22:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 969E520873
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 22:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgETWhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 18:37:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33826 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728190AbgETWhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 18:37:17 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4C8413A31C2;
        Thu, 21 May 2020 08:37:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbXKo-0000eE-9T; Thu, 21 May 2020 08:37:10 +1000
Date:   Thu, 21 May 2020 08:37:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520223710.GA2040@dread.disaster.area>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520073358.GX2040@dread.disaster.area>
 <20200520074805.GA21299@infradead.org>
 <20200520202702.GA17627@magnolia>
 <20200520215530.GZ2040@dread.disaster.area>
 <20200520222821.GI17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520222821.GI17627@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=x2yoxxfBxaJTO_HYaXEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 03:28:21PM -0700, Darrick J. Wong wrote:
> On Thu, May 21, 2020 at 07:55:30AM +1000, Dave Chinner wrote:
> > On Wed, May 20, 2020 at 01:27:02PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 20, 2020 at 12:48:05AM -0700, Christoph Hellwig wrote:
> > > > On Wed, May 20, 2020 at 05:33:58PM +1000, Dave Chinner wrote:
> > > > > +	/*
> > > > > +	 * Debug checks outside of the spinlock so they don't lock up the
> > > > > +	 * machine if they fail.
> > > > > +	 */
> > > > > +	ASSERT(mp->m_sb.sb_frextents >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_dblocks >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_agcount >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_rextsize >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_rbmblocks >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_rblocks >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_rextents >= 0);
> > > > > +	ASSERT(mp->m_sb.sb_rextslog >= 0);
> > > 
> > > Except for imax_pct and rextslog, all of these are unsigned quantities,
> > > right?  So the asserts will /never/ trigger?
> > 
> > In truth, I didn't look that far. I just assumed that because all
> > the xfs_sb_mod*() functions used signed math that they could all
> > underflow/overflow.  IOWs, the checking for overflow/underflow was
> > completely wrong in the first place.
> > 
> > Should I just remove the ASSERT()s entirely?
> 
> It causes a bunch of gcc 9.3 warnings, so yes please. :)
> 
> (Granted, I ripped out all the asserts except for the two I mentioned
> above, so if nobody else have complaints then no need to resend.)

Fine by me. FWIW, gcc 9.2 doesn't complain at all about these.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90615C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9E120823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgETVzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 17:55:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59124 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728329AbgETVzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 17:55:48 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5E0997EBF8A;
        Thu, 21 May 2020 07:55:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbWgU-0000Pn-LT; Thu, 21 May 2020 07:55:30 +1000
Date:   Thu, 21 May 2020 07:55:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520215530.GZ2040@dread.disaster.area>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520073358.GX2040@dread.disaster.area>
 <20200520074805.GA21299@infradead.org>
 <20200520202702.GA17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520202702.GA17627@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=WXqzqgKzuLsPc6fZo_IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 01:27:02PM -0700, Darrick J. Wong wrote:
> On Wed, May 20, 2020 at 12:48:05AM -0700, Christoph Hellwig wrote:
> > On Wed, May 20, 2020 at 05:33:58PM +1000, Dave Chinner wrote:
> > > +	/*
> > > +	 * Debug checks outside of the spinlock so they don't lock up the
> > > +	 * machine if they fail.
> > > +	 */
> > > +	ASSERT(mp->m_sb.sb_frextents >= 0);
> > > +	ASSERT(mp->m_sb.sb_dblocks >= 0);
> > > +	ASSERT(mp->m_sb.sb_agcount >= 0);
> > > +	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> > > +	ASSERT(mp->m_sb.sb_rextsize >= 0);
> > > +	ASSERT(mp->m_sb.sb_rbmblocks >= 0);
> > > +	ASSERT(mp->m_sb.sb_rblocks >= 0);
> > > +	ASSERT(mp->m_sb.sb_rextents >= 0);
> > > +	ASSERT(mp->m_sb.sb_rextslog >= 0);
> 
> Except for imax_pct and rextslog, all of these are unsigned quantities,
> right?  So the asserts will /never/ trigger?

In truth, I didn't look that far. I just assumed that because all
the xfs_sb_mod*() functions used signed math that they could all
underflow/overflow.  IOWs, the checking for overflow/underflow was
completely wrong in the first place.

Should I just remove the ASSERT()s entirely?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

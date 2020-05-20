Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38AAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE5DA20756
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgETHDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:03:40 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:37535 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgETHDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:03:39 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7646CD78954;
        Wed, 20 May 2020 17:03:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbIlK-0003Wf-8d; Wed, 20 May 2020 17:03:34 +1000
Date:   Wed, 20 May 2020 17:03:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520070334.GU2040@dread.disaster.area>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520065334.GA25811@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520065334.GA25811@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=5ai-NqfiKQc0xZOBjcMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 11:53:34PM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 07:48:39AM +1000, Dave Chinner wrote:
> > +	/*
> > +	 * Debug checks outside of the spinlock so they don't lock up the
> > +	 * machine if they fail.
> > +	 */
> > +	ASSERT(&mp->m_sb.sb_frextents >= 0);
> > +	ASSERT(&mp->m_sb.sb_dblocks >= 0);
> > +	ASSERT(&mp->m_sb.sb_agcount >= 0);
> 
> To stick to the theme of broken error handling I don't think this
> does what you think as this takes the address of each field, which
> will aways be >= 0.  I like the idea of the patch, though.

Ah, search and replace fail. I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

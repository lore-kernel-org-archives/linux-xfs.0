Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D65C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07D9206A3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgELJLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:11:47 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59026 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgELJLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:11:47 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 05:11:46 EDT
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 63012D78E45;
        Tue, 12 May 2020 19:11:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYQwx-00047N-Uj; Tue, 12 May 2020 19:11:43 +1000
Date:   Tue, 12 May 2020 19:11:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200512091143.GR2040@dread.disaster.area>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-2-david@fromorbit.com>
 <20200512081423.GA7689@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512081423.GA7689@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=kRsO2zt64whqoqbKdR4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 01:14:23AM -0700, Christoph Hellwig wrote:
> I'm surprised the difference is that big.  The moves look obviously
> fine, but why do you put the precalculated fields in the middle
> of struct xfs_mount instead of at the end?

Just because it was the minimum to move about and it clearly
demonstrated the damage the contended cacheline was doing to
performance of code accessing read-only variables.

Really, there's a lot in the xfs_mount that might well be read only
that I didn't consider. I'm thinking that most of the pointers to
structures are read only (e.g. the log, ailp, buftargs, etc) as they
do not change for the life of the structure. I don't really have the
time to dig into this real deep (this is a quick, interesting
diversion!) so I did the 99-percenter and moved on...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

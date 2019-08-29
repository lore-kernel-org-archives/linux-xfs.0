Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E1BC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12E0A2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfH2JbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 05:31:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48653 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfH2JbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 05:31:21 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 56D2F43D073;
        Thu, 29 Aug 2019 19:31:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Glx-0002di-RT; Thu, 29 Aug 2019 19:31:17 +1000
Date:   Thu, 29 Aug 2019 19:31:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829093117.GS1119@dread.disaster.area>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
 <20190829082501.GA18614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829082501.GA18614@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=d3U9ooY5FA7FCOP2F0UA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 01:25:01AM -0700, Christoph Hellwig wrote:
> Actually, another comment:
> 
> > +		/* Scan the free entry array for a large enough free space. */
> > +		do {
> > +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> 
> This could be changed to:
> 
> 			if (bests[findex] != cpu_to_be16(NULLDATAOFF) &&
> 
> which might lead to slightly better code generation.

I don't think it will make any difference because the very next
comparison in the if() statement needs the cpu order bests[findex]
value because its a >= check. Hence we have to calculate it anyway,
and the compiler should be smart enough to only evaluate it once...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

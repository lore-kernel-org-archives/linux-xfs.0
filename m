Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C07C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408276127C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGVGrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:47:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37220 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbhGVGry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:47:54 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D39641044E9E;
        Thu, 22 Jul 2021 17:28:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6T87-009Oxg-St; Thu, 22 Jul 2021 17:28:27 +1000
Date:   Thu, 22 Jul 2021 17:28:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <20210722072827.GM664593@dread.disaster.area>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-4-david@fromorbit.com>
 <YPkZB7aY3foxa594@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPkZB7aY3foxa594@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=FrVtUIc5aP3H6x8FCvoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 08:06:47AM +0100, Christoph Hellwig wrote:
> Due the combination of the code move and the actual change I had
> a really hard time reviewing this.
> 
> > -		trace_xlog_iclog_syncing(iclog, _RET_IP_);
> 
> This tracepoint got lost.

Ah, will fix that.

> Otherwise this looks good.
> 
> As I had to split the move from the technical changes to follow
> the change I might as well share my split, attached below as two
> patches:

Yeah, I haven't got to that point yet - I'm still chasing a wild
goose that is now only showing up once every 3 or 4 hours of
cyclic testing, so I've been trying to capture that in sufficient
detail to be able to diagnose the failure. I wanted to get these out
there so new eyes might see what I'm missing or suggest a better
approach...

I'll add this split into my patchset tomorrow when I go looking at
the corpses overnight testing created...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

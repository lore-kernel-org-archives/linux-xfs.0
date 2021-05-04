Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CC5C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 07:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5106613B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 07:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhEDHV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 03:21:26 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:36283 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229839AbhEDHV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 May 2021 03:21:26 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 0914166D67
        for <linux-xfs@vger.kernel.org>; Tue,  4 May 2021 17:20:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ldpM5-002fzJ-8e
        for linux-xfs@vger.kernel.org; Tue, 04 May 2021 17:20:29 +1000
Date:   Tue, 4 May 2021 17:20:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_ITEM_RELEASE_WHEN_COMMITTED
Message-ID: <20210504072029.GL63242@dread.disaster.area>
References: <20210504042805.50176-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504042805.50176-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=z8V1bbPmqjb9dAYrf3cA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 04, 2021 at 02:28:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Redundant functionality. Returning NULLCOMMITLSN from
> ->iop_committed means "release item as there is no further
> processing to be done", making this flag entirely redundant.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Self NACK on this - I jus t realised I'd snet the wrong branch to
build and test so it "passed" when in fact it doesn't even compile,
let alone work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

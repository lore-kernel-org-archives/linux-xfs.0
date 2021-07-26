Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F48C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097C660240
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhGZVHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:07:08 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:32776 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232252AbhGZVHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 17:07:08 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5472580BB5A;
        Tue, 27 Jul 2021 07:47:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m88Rh-00B8sC-TK; Tue, 27 Jul 2021 07:47:33 +1000
Date:   Tue, 27 Jul 2021 07:47:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: factor out forced iclog flushes
Message-ID: <20210726214733.GS664593@dread.disaster.area>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-6-david@fromorbit.com>
 <20210726174857.GX559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726174857.GX559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=rHjr6lFtAsy1o72OCUoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 10:48:57AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 04:07:11PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We force iclogs in several places - we need them all to have the
> > same cache flush semantics, so start by factoring out the iclog
> > force into a common helper.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks like a pretty simple hoist.
> 
> I also wonder about the removal of the assertion in xlog_unmount_write,
> but I /think/ that's ok because at that point we've turned off
> everything else that could write the log and forced it, which means that
> the log is clean, and therefore all iclogs ought to be in ACTIVE state?

*nod*

As it is, this assert goes away real soon in the "Kill
XLOG_STATE_IOERROR" patch I wanted to get into this cycle, but
progress on that is being held up by working through these g/482
failures. Hence I don't think that it's actually a big issue to lose
assert now...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

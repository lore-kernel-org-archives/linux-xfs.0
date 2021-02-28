Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AFCC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 23:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FFD64E27
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 23:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhB1XrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Feb 2021 18:47:25 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48150 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230214AbhB1XrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Feb 2021 18:47:25 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4AECE1041047;
        Mon,  1 Mar 2021 10:46:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lGVlq-0094MI-H3; Mon, 01 Mar 2021 10:46:42 +1100
Date:   Mon, 1 Mar 2021 10:46:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210228234642.GC4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
 <20210226024828.GN7272@magnolia>
 <YDvGfUIcEhq9hB5t@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDvGfUIcEhq9hB5t@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=1HwpQATvKKftJe36GlsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 28, 2021 at 11:36:13AM -0500, Brian Foster wrote:
> On Thu, Feb 25, 2021 at 06:48:28PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 25, 2021 at 09:34:47AM +0100, Christoph Hellwig wrote:
> > > On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > > > > Also, do you have any idea what was Christoph talking about wrt devices
> > > > > with no-op flushes the last time this patch was posted?  This change
> > > > > seems straightforward to me (assuming the answers to my two question are
> > > > > 'yes') but I didn't grok what subtlety he was alluding to...?
> > > > 
> > > > He was wondering what devices benefited from this. It has no impact
> > > > on highspeed devices that do not require flushes/FUA (e.g. high end
> > > > intel optane SSDs) but those are not the devices this change is
> > > > aimed at. There are no regressions on these high end devices,
> > > > either, so they are largely irrelevant to the patch and what it
> > > > targets...
> > > 
> > > I don't think it is that simple.  Pretty much every device aimed at
> > > enterprise use does not enable a volatile write cache by default.  That
> > > also includes hard drives, arrays and NAND based SSDs.
> > > 
> > > Especially for hard drives (or slower arrays) the actual I/O wait might
> > > matter.  What is the argument against making this conditional?
> > 
> > I still don't understand what you're asking about here --
> > 
> > AFAICT the net effect of this patchset is that it reduces the number of
> > preflushes and FUA log writes.  To my knowledge, on a high end device
> > with no volatile write cache, flushes are a no-op (because all writes
> > are persisted somewhere immediately) and a FUA write should be the exact
> > same thing as a non-FUA write.  Because XFS will now issue fewer no-op
> > persistence commands to the device, there should be no effect at all.
> > 
> 
> Except the cost of the new iowaits used to implement iclog ordering...
> which I think is what Christoph has been asking about..?

And I've already answered - it is largely just noise.

> IOW, considering the storage configuration noted above where the impact
> of the flush/fua optimizations is neutral, the net effect of this change
> is whatever impact is introduced by intra-checkpoint iowaits and iclog
> ordering. What is that impact?

All I've really noticed is that long tail latencies on operations go
down a bit. That seems to correlate with spending less time waiting
for log space when the log is full, but it's a marginal improvement
at best.

Otherwise I cannot measure any significant difference in performance
or behaviour across any of the metrics I monitor during performance
testing.

> Note that it's not clear enough to me to suggest whether that impact
> might be significant or not. Hopefully it's neutral (?), but that seems
> like best case scenario so I do think it's a reasonable question.

Yes, It's a reasonable question, but I answered it entirely and in
great detail the first time.  Repeating the same question multiple
times just with slightly different phrasing does not change the
answer, nor explain to me what the undocumented concern might be...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

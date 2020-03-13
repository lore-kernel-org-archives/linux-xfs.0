Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0F9C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 05:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84D820737
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 05:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCMFAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 01:00:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41073 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgCMFAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 01:00:05 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AF53B3A4915;
        Fri, 13 Mar 2020 16:00:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCcQS-0007Fw-58; Fri, 13 Mar 2020 16:00:00 +1100
Date:   Fri, 13 Mar 2020 16:00:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Takashi Iwai <tiwai@suse.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200313050000.GN10776@dread.disaster.area>
References: <20200311093552.25354-1-tiwai@suse.de>
 <20200311220914.GF10776@dread.disaster.area>
 <s5hsgie5a5r.wl-tiwai@suse.de>
 <20200312222701.GK10776@dread.disaster.area>
 <20200312224342.GQ8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312224342.GQ8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8 a=UfqQ9P9qcMcbpwL7gKEA:9
        a=V2MMLGq5lQxK2cI3:21 a=K7xIE5H-YJGPVNIh:21 a=CjuIK1q_8ugA:10
        a=e2CUPOnPG4QKp8I52DXD:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:43:42PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 12, 2020 at 03:27:01PM -0700, Dave Chinner wrote:
> > 
> > I'm annoyed that every time a fundamental failing or technical debt
> > is uncovered in the kernel, nobody takes responsibility to fix the
> > problem completely, for everyone, for ever.
> > 
> > As Thomas said recently: correctness first.
> > 
> > https://lwn.net/ml/linux-kernel/87v9nc63io.fsf@nanos.tec.linutronix.de/
> > 
> > This is not "good enough" - get rid of snprintf() altogether.
> 
> $ git grep snprintf | wc -l
> 8534
> 
> That's somebody's 20 year project... :/

Or half an hour with sed.

Indeed, not all of them are problematic:

$ git grep "= snprintf" |wc -l
1744
$ git grep "return snprintf"|wc -l
1306

Less than half of them use the return value.

Anything that calls snprintf() without checking the return
value (just to prevent formatting overruning the buffer) can be
converted by search and replace because the behaviour is the
same for both functions in this case.

Further, code written properly to catch a snprintf overrun will also
correctly pick up scnprintf filling the buffer. However, code that
overruns with snprintf()s return value is much more likely to work
correctly with scnprintf as the calculated buffer length won't
overrun into memory beyond the buffer.

And that's likely all of the snprintf() calls dealt with in half an
hour. Now snprintf can be removed.

What's more scary is this:

$ git grep "+= sprintf"  |wc -l
1834

which is indicative of string formatting iterating over buffers with
no protection against the formatting overwriting the end of the
buffer.  Those are much more dangerous (i.e. potential buffer
overflows) than the snprintf problem being fixed here, and those
will need to be checked and fixed manually to use scnprintf().
That's where the really nasty technical debt lies, not snprintf...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

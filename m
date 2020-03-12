Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62078C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4038720637
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgCLW1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:27:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53428 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbgCLW1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 18:27:07 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 712C47E9EAC;
        Fri, 13 Mar 2020 09:27:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCWI9-0004w9-H6; Fri, 13 Mar 2020 09:27:01 +1100
Date:   Fri, 13 Mar 2020 09:27:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200312222701.GK10776@dread.disaster.area>
References: <20200311093552.25354-1-tiwai@suse.de>
 <20200311220914.GF10776@dread.disaster.area>
 <s5hsgie5a5r.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsgie5a5r.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8 a=CPrUJtx3VifpjA6-OccA:9
        a=HB2jc7h5lHCsdRon:21 a=Td3H3O8-iLVQkZkO:21 a=CjuIK1q_8ugA:10
        a=e2CUPOnPG4QKp8I52DXD:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 08:01:36AM +0100, Takashi Iwai wrote:
> On Wed, 11 Mar 2020 23:09:14 +0100,
> Dave Chinner wrote:
> > 
> > On Wed, Mar 11, 2020 at 10:35:52AM +0100, Takashi Iwai wrote:
> > > Since snprintf() returns the would-be-output size instead of the
> > > actual output size, the succeeding calls may go beyond the given
> > > buffer limit.  Fix it by replacing with scnprintf().
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > >  fs/xfs/xfs_stats.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > what about all the other calls to snprintf() in fs/xfs/xfs_sysfs.c
> > and fs/xfs/xfs_error.c that return the "would be written" length to
> > their callers? i.e. we can return a length longer than the buffer
> > provided to the callers...
> > 
> > Aren't they all broken, too?
> 
> The one in xfs_error.c is a oneshot call for a sysfs output with
> PAGE_SIZE limit, so it's obviously safe.

Until the sysfs code changes. Then it's a landmine that explodes.

> OTOH, using snprintf() makes
> no sense as it doesn't return the right value if it really exceeds, so
> it should be either simplified to sprintf() or use scnprintf() to
> align both the truncation and the return value.

Right, we have technical debt here, and lots of it. scnprintf() is
the right thing to use here.

> > A quick survey of random snprintf() calls shows there's an abundance
> > of callers that do not check the return value of snprintf for
> > overflow when outputting stuff to proc/sysfs files. This seems like
> > a case of "snprintf() considered harmful, s/snprintf/scnprintf/
> > kernel wide, remove snprintf()"...
> 
> Yeah, snprintf() is a hard-to-use function if you evaluate the return
> value.  I've submitted many similar patches like this matching a
> pattern like
> 	pos += snprintf(buf + pos, limit - pos, ...)
> which is a higher risk of breakage than a single shot call.
> 
> We may consider flagging snprintf() to be harmful, but I guess it
> wasn't done at the time scnprintf() was introduced just because there
> are too many callers of snprintf().  And some code actually needs the
> size that would be output for catching the overflow explicitly (hence
> warning or resizing after that).

So, after seeing the technical debt the kernel has accumulated, it's
been given a "somebody else's problem to solve" label, rather than
putting in the effort to fix it.

Basically you are saying "we know our software sucks and we don't
care enough to fix it", yes?

> Practically seen, the recent kernel snprintf() already protects the
> negative length with WARN().

That's a truly awful way of handling out of bounds accesses: not
only are we saying we know our software sucks, we're telling the
user and making it their problem. It's a cop-out.

> But it's error-prone and would hit other
> issue if you access to the buffer position by other than snprintf(),
> so please see my patch just as a precaution.

Obviously, but slapping band-aids around like this not a fix for
all the other existing (and future) buggy snprintf code.

I'm annoyed that every time a fundamental failing or technical debt
is uncovered in the kernel, nobody takes responsibility to fix the
problem completely, for everyone, for ever.

As Thomas said recently: correctness first.

https://lwn.net/ml/linux-kernel/87v9nc63io.fsf@nanos.tec.linutronix.de/

This is not "good enough" - get rid of snprintf() altogether.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

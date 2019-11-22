Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEF2C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B2D20721
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVVLg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 16:11:36 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36400 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726568AbfKVVLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 16:11:36 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8FDB13A13FE;
        Sat, 23 Nov 2019 08:11:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iYGDC-0007Vn-0b; Sat, 23 Nov 2019 08:11:30 +1100
Date:   Sat, 23 Nov 2019 08:11:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
Message-ID: <20191122211129.GL4614@dread.disaster.area>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-3-preichl@redhat.com>
 <20191121234159.GI4614@dread.disaster.area>
 <CAJc7PzVBcjXc5uBgyT_XiX1ffaoRTe8jkWmSq-F8pZqezpEnGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzVBcjXc5uBgyT_XiX1ffaoRTe8jkWmSq-F8pZqezpEnGA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=SXAETu5uCDubinsK1MIA:9
        a=i76FUMEFqTmxnmZY:21 a=HQusL8TI5mXhBnH7:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 05:43:55PM +0100, Pavel Reichl wrote:
> On Fri, Nov 22, 2019 at 12:42 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > ---
> > >  mkfs/xfs_mkfs.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index a02d6f66..07b8bd78 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> > >       const uint64_t  step            = (uint64_t)2<<30;
> > >       /* Sector size is 512 bytes */
> > >       const uint64_t  count           = nsectors << 9;
> > > +     uint64_t        prev_done       = (uint64_t) ~0;
> > >
> > >       fd = libxfs_device_to_fd(dev);
> > >       if (fd <= 0)
> > > @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> > >
> > >       while (offset < count) {
> > >               uint64_t        tmp_step = step;
> > > +             uint64_t        done = offset * 100 / count;
> >
> > That will overflow on a EB-scale (2^60 bytes) filesystems, won't it?
> 
> I guess that can happen, sorry. I'll try to come out with computation
> based on a floating point arithmetic. There should not be any
> performance or actual precision problem.
> (well actually I'll drop this line completely, no ratio will be
> computed in the end)

No need to apologise for not realising huge filesystems need to
work. It takes time to get used to having to consider 64 bit
overflows everywhere... :)

Maybe the easiest way to do this sort of thing is to calculate
reporting interval prior to the loop, and every time it is exceeded
issue a report and then reset the report counter to zero. No fancy
math required there. If we want 1% increments:

	report_interval = count / 100;
	
	while (offset < count) {
	....
		offset += tmp_step;
		report_offset += tmp_step;

		if (report_offset > report_interval) {
			report_offset = 0;
			/* issue report */
		}
	}

And this is easy to adjust the number of reports issued (e.g. every
5% or 10% is just changing the report_interval division constant.

Another way of doing it is deciding on the -time- between reports.
e.g. issue a progress report every 60s. Then you can just report
the percentage done  based on offset and count without needing
intermediate accounting.

> > I also suspect that it breaks a few fstests, too, as a some of them
> > capture and filter mkfs output. They'll need filters to drop these
> > new messages.
> >
> > FWIW, a 100 lines of extra mkfs output is going to cause workflow
> > issues. I know it will cause me problems, because I often mkfs 500TB
> > filesystems tens of times a day on a discard enabled device. This
> > extra output will scroll all the context of the previous test run
> > I'm about to compare against off my terminal screen and so now I
> > will have to scroll the terminal to look at the results of
> > back-to-back runs. IOWs, I'm going to immediately want to turn this
> > output off and have it stay off permanently.
> >
> > Hence I think that, by default, just outputting a single "Discard in
> > progress" line before starting the discard would be sufficient
> 
> OK, maybe just one line "Discard in progress" is actually what users
> need. The computing of % done was probably just overkill from my side.
> Sorry about that.

Again, no need to apologise because there are different opinions on
how something should be done. If you didn't put progress reporting
in, I'm sure someone would have suggested it and we'd be having the
same discussion anyway. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

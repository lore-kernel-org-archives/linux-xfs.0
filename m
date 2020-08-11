Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54B0C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 07:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E922080C
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 07:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgHKHFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:05:13 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56177 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728271AbgHKHFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 03:05:12 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 78B1CD5BA4A;
        Tue, 11 Aug 2020 17:05:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5OLJ-0002XG-Tg; Tue, 11 Aug 2020 17:05:05 +1000
Date:   Tue, 11 Aug 2020 17:05:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200811070505.GO2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=_GoX9-eHnmEvp3vwkc4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
> On 8/10/20 8:00 PM, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
> >> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> >>> [cc Jens]
> >>>
> >>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> >>> the bz link below.]
> > 
> > Looks like a io_uring/fio bugs at this point, Jens. All your go fast
> > bits turns the buffered read into a short read, and neither fio nor
> > io_uring async buffered read path handle short reads. Details below.
> 
> It's a fio issue. The io_uring engine uses a different path for short
> IO completions, and that's being ignored by the backend... Hence the
> IO just gets completed and not retried for this case, and that'll then
> trigger verification as if it did complete. I'm fixing it up.

I just updated fio to:

cb7d7abb (HEAD -> master, origin/master, origin/HEAD) io_u: set io_u->verify_offset in fill_io_u()

The workload still reports corruption almost instantly. Only this
time, the trace is not reporting a short read.

File is patterned with:

verify_pattern=0x33333333%o-16

Offset of "bad" data is 0x1240000.

Expected:

00000000:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000010:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000020:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000030:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000040:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000050:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000060:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000070:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000080:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
.....
0000ffd0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
0000ffe0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
0000fff0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............


Received:

00000000:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000010:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000020:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000030:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000040:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000050:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000060:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000070:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000080:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
.....
0000ffd0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
0000ffe0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
0000fff0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............


Looks like the data in the expected buffer is wrong - the data
pattern in the received buffer is correct according the defined
pattern.

Error is 100% reproducable from the same test case. Same bad byte in
the expected buffer dump every single time.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

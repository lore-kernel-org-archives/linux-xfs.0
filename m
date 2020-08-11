Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E19C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 21:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB31F2078B
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 21:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHKV7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 17:59:19 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50353 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbgHKV7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 17:59:19 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 0701BD7ABB1;
        Wed, 12 Aug 2020 07:59:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5cIb-0007qX-B6; Wed, 12 Aug 2020 07:59:13 +1000
Date:   Wed, 12 Aug 2020 07:59:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200811215913.GP2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
 <20200811070505.GO2114@dread.disaster.area>
 <547cde58-26f3-05f1-048c-fa2a94d6e176@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547cde58-26f3-05f1-048c-fa2a94d6e176@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=SZqynGIIb26YLVYWc_UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
> On 8/11/20 1:05 AM, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
> >> On 8/10/20 8:00 PM, Dave Chinner wrote:
> >>> On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
> >>>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> >>>>> [cc Jens]
> >>>>>
> >>>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> >>>>> the bz link below.]
> >>>
> >>> Looks like a io_uring/fio bugs at this point, Jens. All your go fast
> >>> bits turns the buffered read into a short read, and neither fio nor
> >>> io_uring async buffered read path handle short reads. Details below.
> >>
> >> It's a fio issue. The io_uring engine uses a different path for short
> >> IO completions, and that's being ignored by the backend... Hence the
> >> IO just gets completed and not retried for this case, and that'll then
> >> trigger verification as if it did complete. I'm fixing it up.
> > 
> > I just updated fio to:
> > 
> > cb7d7abb (HEAD -> master, origin/master, origin/HEAD) io_u: set io_u->verify_offset in fill_io_u()
> > 
> > The workload still reports corruption almost instantly. Only this
> > time, the trace is not reporting a short read.
> > 
> > File is patterned with:
> > 
> > verify_pattern=0x33333333%o-16
> > 
> > Offset of "bad" data is 0x1240000.
> > 
> > Expected:
> > 
> > 00000000:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000010:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000020:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000030:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000040:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000050:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000060:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000070:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000080:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > .....
> > 0000ffd0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 0000ffe0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 0000fff0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 
> > 
> > Received:
> > 
> > 00000000:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000010:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000020:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000030:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000040:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000050:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000060:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000070:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000080:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > .....
> > 0000ffd0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 0000ffe0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 0000fff0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> > 
> > 
> > Looks like the data in the expected buffer is wrong - the data
> > pattern in the received buffer is correct according the defined
> > pattern.
> > 
> > Error is 100% reproducable from the same test case. Same bad byte in
> > the expected buffer dump every single time.
> 
> What job file are you running? It's not impossible that I broken
> something else in fio, the io_u->verify_offset is a bit risky... I'll
> get it fleshed out shortly.

Details are in the bugzilla I pointed you at. I modified the
original config specified to put per-file and offset identifiers
into the file data rather than using random data. This is
"determining the origin of stale data 101" stuff - the first thing
we _always_ do when trying to diagnose data corruption is identify
where the bad data came from.

Entire config file is below.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


[global]
directory=/mnt/scratch
size=256M
iodepth=16
bs=64k
verify=crc32c
verify_fatal=1
verify_dump=1
verify=pattern
thread=1
loops=200
#direct=1
#unlink=1
buffered=1

[uring_w]
rw=randwrite
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=0
sqthread_poll=0
verify_pattern=0x11111111%o-16

[uring_sqt_w]
rw=randwrite
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=1
sqthread_poll=1
verify_pattern=0x22222222%o-16

[uring_rw]
rw=randrw
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=0
sqthread_poll=0
verify_pattern=0x33333333%o-16

[uring_sqt_rw]
rw=randrw
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=1
sqthread_poll=1
verify_pattern=0x44444444%o-16


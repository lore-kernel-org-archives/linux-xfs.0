Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A063FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 23:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80848206DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 23:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgHKXA5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 19:00:57 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:60736 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgHKXA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 19:00:56 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 348FBD5B8F7;
        Wed, 12 Aug 2020 09:00:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5dGH-0008Fo-7v; Wed, 12 Aug 2020 09:00:53 +1000
Date:   Wed, 12 Aug 2020 09:00:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200811230053.GR2114@dread.disaster.area>
References: <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
 <20200811070505.GO2114@dread.disaster.area>
 <547cde58-26f3-05f1-048c-fa2a94d6e176@kernel.dk>
 <20200811215913.GP2114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811215913.GP2114@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=UBgT98_HpG-eX9WT1LIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:59:13AM +1000, Dave Chinner wrote:
> On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
> > What job file are you running? It's not impossible that I broken
> > something else in fio, the io_u->verify_offset is a bit risky... I'll
> > get it fleshed out shortly.
> 
> Details are in the bugzilla I pointed you at. I modified the
> original config specified to put per-file and offset identifiers
> into the file data rather than using random data. This is
> "determining the origin of stale data 101" stuff - the first thing
> we _always_ do when trying to diagnose data corruption is identify
> where the bad data came from.
> 
> Entire config file is below.

Just as a data point: btrfs fails this test even faster than XFS.
Both with the old 3.21 fio binary and the new one.

Evidence points to this code being very poorly tested. Both
filesystems it is enabled on fail validation with the tool is
supposed to exercise and validate io_uring IO path behaviour.

Regardless of whether this is a tool failure or a kernel code
failure, the fact is that nobody ran data validation tests on this
shiny new code. And for a storage API that is reading and writing
user data, that's a pretty major process failure....

Improvements required, Jens.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

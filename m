Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6FEC18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7024620409
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCXXY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 19:24:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51305 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726257AbgCXXY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 19:24:26 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 88FC73A36AC;
        Wed, 25 Mar 2020 10:24:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGsuG-0005MK-Tj; Wed, 25 Mar 2020 10:24:24 +1100
Date:   Wed, 25 Mar 2020 10:24:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200324232424.GC10776@dread.disaster.area>
References: <20200324165700.7575-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324165700.7575-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=Pxj_UvL8w9lO6SR3jQAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> If the bio_add_page() call fails, we proceed to write out a
> partially constructed log buffer. This corrupts the physical log
> such that log recovery is not possible. Worse, persistent
> occurrences of this error eventually lead to a BUG_ON() failure in
> bio_split() as iclogs wrap the end of the physical log, which
> triggers log recovery on subsequent mount.

I'm a little unclear on how this can happen - the iclogbuf can only
be 256kB - 64 pages - and we always allocation a bio with enough
bvecs to hold 64 pages. And the ic_data buffer we are adding to the
bio is also statically allocated so I'm left to wonder exactly how
this is failing.

i.e. this looks like code that shouldn't ever fail, yet it
apparently is, and I have no idea what is causing that failure...

That said, shutting down on failure is the right thing to do, so the
code looks good. I just want to know how the bio_add_page() failure
is occurring.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

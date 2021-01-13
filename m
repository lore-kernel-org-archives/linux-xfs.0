Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110DEC432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 02:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E03ED2242A
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 02:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbhANCN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:13:26 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39735 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729159AbhAMVqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 16:46:00 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id BB84511042C;
        Thu, 14 Jan 2021 08:44:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kznwS-006ADD-F8; Thu, 14 Jan 2021 08:44:36 +1100
Date:   Thu, 14 Jan 2021 08:44:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210113214436.GH331610@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
 <20210107215444.GG331610@dread.disaster.area>
 <20210108165657.GC893097@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108165657.GC893097@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=HcGIDgX5mWfwRt8FoaAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 11:56:57AM -0500, Brian Foster wrote:
> On Fri, Jan 08, 2021 at 08:54:44AM +1100, Dave Chinner wrote:
> > e.g. we run the first transaction into the CIL, it steals the sapce
> > needed for the cil checkpoint headers for the transaciton. Then if
> > the space returned by the item formatting is negative (because it is
> > in the AIL and being relogged), the CIL checkpoint now doesn't have
> > the space reserved it needs to run a checkpoint. That transaction is
> > a sync transaction, so it forces the log, and now we push the CIL
> > without sufficient reservation to write out the log headers and the
> > items we just formatted....
> > 
> 
> Hmmm... that seems like an odd scenario because I'd expect the space
> usage delta to reflect what might or might not have already been added
> to the CIL context, not necessarily the AIL. IOW, shouldn't a negative
> delta only occur for items being relogged while still CIL resident
> (regardless of AIL residency)?
>
> From a code standpoint, the way a particular log item delta comes out
> negative is from having a shadow lv size smaller than the ->li_lv size.
> Thus, xlog_cil_insert_format_items() subtracts the currently formatted
> lv size from the delta, formats the current state of the item, and
> xfs_cil_prepare_item() adds the new (presumably smaller) size to the
> delta. We reuse ->li_lv in this scenario so both it and the shadow
> buffer remain, but a CIL push pulls ->li_lv from all log items and
> chains them to the CIL context for writing, so I don't see how we could
> have an item return a negative delta on an empty CIL. Hm?

In theory, yes. But like I said, I've made a bunch of assumptions
that this won't happen, and so without actually auditting the code
I'm not actually sure that it won't. i.e. I need to go check what
happens with items being marked stale, how shadow buffer
reallocation interacts with items that end up being smaller than the
existing buffer, etc. I've paged a lot of this detail out of my
brain, so until I spend the time to go over it all again I'm not
going to be able to answer definitively.

> (I was also wondering whether repeated smaller relogs of an item could
> be a vector for this to go wrong, but it looks like
> xlog_cil_insert_format_items() always uses the formatted size of the
> current buffer...).

That's my nagging doubt about all this - that there's an interaction
of this nature that I haven't considered due to the assumptions I've
made that allows underflow to occur. That would be much worse than
the current situation of hanging on a missing wakeup when the CIL is
full and used_space goes backwards....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

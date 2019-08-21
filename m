Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A35BC3A589
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 01:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D157822DA7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 01:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfHUBJZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 21:09:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39623 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbfHUBJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 21:09:25 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 14090361A45;
        Wed, 21 Aug 2019 11:09:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0F6j-0002BY-Hp; Wed, 21 Aug 2019 11:08:13 +1000
Date:   Wed, 21 Aug 2019 11:08:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190821010813.GL1119@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190821002643.GK1119@dread.disaster.area>
 <20190821004413.GB20250@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821004413.GB20250@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=Z7NWzKHzsW-EWR0CCEwA:9 a=QEXdDO2ut3YA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 02:44:13AM +0200, hch@lst.de wrote:
> On Wed, Aug 21, 2019 at 10:26:43AM +1000, Dave Chinner wrote:
> > After thinking on this for a bit, I suspect the better thing to do
> > here is add a KM_ALIGNED flag to the allocation, so if the internal
> > kmem_alloc() returns an unaligned pointer we free it and fall
> > through to vmalloc() to get a properly aligned pointer....
> > 
> > That way none of the other interfaces have to change, and we can
> > then use kmem_alloc_large() everywhere we allocate buffers for IO.
> > And we don't need new infrastructure just to support these debug
> > configurations, either.
> > 
> > Actually, kmem_alloc_io() might be a better idea - keep the aligned
> > flag internal to the kmem code. Seems like a pretty simple solution
> > to the entire problem we have here...
> 
> The interface sounds ok.  The simple try and fallback implementation
> OTOH means we always do two allocations іf slub debugging is enabled,
> which is a little lasty.

Some creative ifdefery could avoid that, but quite frankly it's only
necessary for limited allocation contexts and so the
overhead/interactions would largely be unnoticable compared to the
wider impact of memory debugging...

> I guess the best we can do for 5.3 and
> then figure out a way to avoid for later.

Yeah, it also has the advantage of documenting all the places we
need to be careful of allocation alignment, and it would allow us to
simply plug in whatever future infrastructure comes along that
guarantees allocation alignment without changing any other XFS
code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41ACC3A589
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 00:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD3422DD3
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 00:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfHUAoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 20:44:16 -0400
Received: from verein.lst.de ([213.95.11.211]:33009 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfHUAoP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 20:44:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6F21868B20; Wed, 21 Aug 2019 02:44:13 +0200 (CEST)
Date:   Wed, 21 Aug 2019 02:44:13 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190821004413.GB20250@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de> <20190818173426.GA32311@lst.de> <20190821002643.GK1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821002643.GK1119@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 10:26:43AM +1000, Dave Chinner wrote:
> After thinking on this for a bit, I suspect the better thing to do
> here is add a KM_ALIGNED flag to the allocation, so if the internal
> kmem_alloc() returns an unaligned pointer we free it and fall
> through to vmalloc() to get a properly aligned pointer....
> 
> That way none of the other interfaces have to change, and we can
> then use kmem_alloc_large() everywhere we allocate buffers for IO.
> And we don't need new infrastructure just to support these debug
> configurations, either.
> 
> Actually, kmem_alloc_io() might be a better idea - keep the aligned
> flag internal to the kmem code. Seems like a pretty simple solution
> to the entire problem we have here...

The interface sounds ok.  The simple try and fallback implementation
OTOH means we always do two allocations іf slub debugging is enabled,
which is a little lasty.  I guess the best we can do for 5.3 and
then figure out a way to avoid for later.

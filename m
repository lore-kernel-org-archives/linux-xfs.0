Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B47C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 01:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6684C20575
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 01:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgENBvD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 21:51:03 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56450 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgENBvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 21:51:02 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 790CA108F4B;
        Thu, 14 May 2020 11:50:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jZ31T-0001jR-7i; Thu, 14 May 2020 11:50:55 +1000
Date:   Thu, 14 May 2020 11:50:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context
 counters
Message-ID: <20200514015055.GI2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-4-david@fromorbit.com>
 <20200512140544.GD37029@bfoster>
 <20200512233627.GW2040@dread.disaster.area>
 <20200513120959.GB44225@bfoster>
 <20200513215241.GG2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513215241.GG2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=KVzVXZcqx2d3lZqGfoIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 07:52:41AM +1000, Dave Chinner wrote:
> On Wed, May 13, 2020 at 08:09:59AM -0400, Brian Foster wrote:
> > On Wed, May 13, 2020 at 09:36:27AM +1000, Dave Chinner wrote:
> > > On Tue, May 12, 2020 at 10:05:44AM -0400, Brian Foster wrote:
> > > > Particularly as it relates to percpu functionality. Does
> > > > the window scale with cpu count, for example? It might not matter either
> > > 
> > > Not really. We need a thundering herd to cause issues, and this
> > > occurs after formatting an item so we won't get a huge thundering
> > > herd even when lots of threads block on the xc_ctx_lock waiting for
> > > a push to complete.
> > > 
> > 
> > It would be nice to have some debug code somewhere that somehow or
> > another asserts or warns if the CIL reservation exceeds some
> > insane/unexpected heuristic based on the current size of the context. I
> > don't know what that code or heuristic looks like (i.e. multiple factors
> > of the ctx size?) so I'm obviously handwaving. Just something to think
> > about if we can come up with a way to accomplish that opportunistically.
> 
> I don't think there is a reliable mechanism that can be used here.
> At one end of the scale we have the valid case of a synchronous
> inode modification on a log with a 256k stripe unit. So it's valid
> to have a CIL reservation of ~550kB for a single item that consumes
> ~700 bytes of log space.
> 
> OTOH, we might be freeing extents on a massively fragmented file and
> filesystem, so we're pushing 200kB+ transactions into the CIL for
> every rolling transaction. On a filesystem with a 512 byte log
> sector size and no LSU, the CIL reservations are dwarfed by the
> actual metadata being logged...
> 
> I'd suggest that looking at the ungrant trace for the CIL ticket
> once it has committed will tell us exactly how much the reservation
> was over-estimated, as the unused portion of the reservation will be
> returned to the reserve grant head at this point in time.

Typical for this workload is a CIl ticket that looks like this at
ungrant time:

t_curr_res 13408 t_unit_res 231100
t_curr_res 9240 t_unit_res 140724
t_curr_res 46284 t_unit_res 263964
t_curr_res 29780 t_unit_res 190020
t_curr_res 38044 t_unit_res 342016
t_curr_res 21636 t_unit_res 321476
t_curr_res 21576 t_unit_res 263964
t_curr_res 42200 t_unit_res 411852
t_curr_res 21636 t_unit_res 292720
t_curr_res 62740 t_unit_res 514552
t_curr_res 17456 t_unit_res 284504
t_curr_res 29852 t_unit_res 411852
t_curr_res 13384 t_unit_res 206452
t_curr_res 70956 t_unit_res 518660
t_curr_res 70908 t_unit_res 333800
t_curr_res 50404 t_unit_res 518660
t_curr_res 17480 t_unit_res 321476
t_curr_res 33948 t_unit_res 436500
t_curr_res 17492 t_unit_res 317368
t_curr_res 50392 t_unit_res 489904
t_curr_res 13360 t_unit_res 325584
t_curr_res 66812 t_unit_res 506336
t_curr_res 33924 t_unit_res 366664
t_curr_res 70932 t_unit_res 551524
t_curr_res 29852 t_unit_res 374880
t_curr_res 25720 t_unit_res 494012
t_curr_res 42152 t_unit_res 506336
t_curr_res 21684 t_unit_res 543308
t_curr_res 29840 t_unit_res 440608
t_curr_res 46320 t_unit_res 551524
t_curr_res 21624 t_unit_res 387204
t_curr_res 29840 t_unit_res 522768

So we are looking at a reservation of up to 500KB, and typically
using all but a few 10s of KB of it.

I'll use this as the ballpark for the lockless code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

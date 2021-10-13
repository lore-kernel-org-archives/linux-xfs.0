Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBD3C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 20:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB82861154
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhJMVAD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:00:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37405 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhJMVAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 17:00:03 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 866F51056750;
        Thu, 14 Oct 2021 07:57:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1malJz-005txV-AD; Thu, 14 Oct 2021 07:57:55 +1100
Date:   Thu, 14 Oct 2021 07:57:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Sorting blocks in xfs_buf_delwri_submit_buffers() still
 necessary?
Message-ID: <20211013205755.GJ2361455@dread.disaster.area>
References: <05c69404-cc05-444b-e4b0-1e358deae272@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05c69404-cc05-444b-e4b0-1e358deae272@applied-asynchrony.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61674856
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=8nJEP1OIZ-IA:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=9oMsoIRCxFo-Of0Ew24A:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 07:13:10PM +0200, Holger Hoffstätte wrote:
> Hi,
> 
> Based on what's going on in blk-mq & NVMe land

What's going on in this area that is any different from the past few
years?

> I though I'd check if XFS still
> sorts buffers before sending them down the pipe, and sure enough that still
> happens in xfs_buf.c:xfs_buf_delwri_submit_buffers() (the comparson function
> is directly above). Before I make a fool of myself and try to remove this,
> do we still think this is necessary?

Yes, I do.

A though experiment for you, which you can then back up with actual
simulation with fio:

What is more efficient and faster at the hardware level: 16
individual sequential 4kB IOs or one 64kB IO?

Which of these uses less CPU to dispatch and complete?

Which has less IO in flight and so allows more concurrent IO to be
dispatched to the hardware at the same time?

Answering these questions will give you your answer.

So, play around with AIO to simulate xfs buffer IO - the xfs buffer
cache is really just a high concurrency async IO engine. Use fio to
submit a series of individual sequential 4kB AIO writes with a queue
depth of, say, 128 to a file and time it. Then submit the
same number of sequential 4kB AIO writes as batches of 64 IOs
at a time. Which one is faster? Why is it faster? You'll need to
play around with fio queue batching controls to do this, but you can
simulate it quite easily.

The individual sequential IO fio simulation is the equivalent of
eliding the buffer sort in xfs_buf_delwri_submit_buffers(), whilst
the batched submission is equivalent of what we have now.

Just because your hardware can do a million IOPS, it doesn't mean
the most efficient way to do IO is to dispatch a million IOPS....

> If there's a scheduler it will do the
> same thing, and SSD/NVMe might do the same in HW anyway or not care.
> The only scenario I can think of where this might make a difference is
> rotational RAID without scheduler attached. Not sure.

Schedulers only have a reorder window of a 100-200 individual IOs.
xfs_buf_delwri_submit_buffers() can be passed tens of thousands of
buffers in a single list for IO dispatch that need reordering.

IOWs, the sort+merge window for number of IOs we dispatch from
metadata writeback is often orders of magnitude larger than what the
block layer scheduler can optimise effectively. The IO stack
behaviour is largely GIGO, so anythign we can do at a highly layer
to make the IO submission less garbage-like results in improved
throughput through the software and hardware layers of the storage
stack.

> I'm looking forward to hear what a foolish idea this is.

If the list_sort() is not showing up in profiles, then it is
essentially free. Last time I checked, our biggest overhead was the
CPU overhead of flushing a million inodes/s from the AIL to their
backing buffers - the list_sort() didn't even show up in the top 50
functions in the profile...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

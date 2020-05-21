Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733F3C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4392D207FB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgEUIq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 04:46:56 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54002 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgEUIq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 04:46:56 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C54C07EBE54
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 18:46:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbgqm-00048l-1K
        for linux-xfs@vger.kernel.org; Thu, 21 May 2020 18:46:48 +1000
Date:   Thu, 21 May 2020 18:46:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] Data writeback scalability
Message-ID: <20200521084648.GB2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=vRrGZ9cf-SToGN4qhUkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Topic:	Data writeback scalability

Scope:	Performance
	Generic writeback infrastructure limitations
	Buffered IO sucks.

Proposal:

This is largely a "how do we solve this" discussion topic.

In running small file writeback tests recently, I've realised that
the single biggest performance limitation is the single threaded BDI
flush worker that builds data IOs from the page cache of dirty
inodes. XFS does delayed allocation, so writeback overhead is
largely determined by how many physical allocations need to be done
to write back the dirty data.

It turns out that it's not that many. The BDI flusher becomes
completely CPU bound at about 80-90k allocations per second, which
means we are limited to writing back data to that many spearate
regions per second. If we are writing back small files (say 4kB
each), then the generic data writeback infrastructure cannot clean
more than 100k files/s. I've got a device that can do 1.6M random
4kB write IOPS every second with aio+dio, yet I can't use more than
about 5% of that capacity through the page cache....

SO I gamed the system: I set an extent size hint of the root
directory of 4KB so that delayed allocation is never used. That got
me to 160k files/s in about 40k IOPS and the flusher thread about
70% busy. Everything was still blocking in
balance_dirty_pages_ratelimited(), so there's still a huge amount of
IO performance being left on the table because we just can't flush
dirty pages fast enough to keep modern SSDs busy from a single
thread.

IOWs, this is a discussion topic for how we might work towards using
multiple data flushing threads efficiently for XFS. Most efficient
would be a flusher thread per AG, but that is unrealistic for high
AG count filesystems. Similarly, per-CPU flushers does no good if
we've only got 4 AGs in the filesystem.

This is made more difficult because the high speed collision that
occurred years ago between the BDI infrastructure, dirty inode
tracking, dirty inode writeback and cgroups has left this code a
complex, fragile tangle of esoteric, untestable code. There are
enough subtle race conditions between a single BDI flusher thread,
writeback, mounts and the block device life cycle that everything is
likely to break if we try to add concurrency into this code.

So there's a big architectural question here: do we start again and
try to engineer something for XFS that does everything we need and
then push that towards being a generic solution (like we did with
iomap to replace bufferheads), or do we pull the loose string on the
existing code and try to add IO concurrency into that code without
making the mess worse?

What other options do we have? What other approaches to the problem
are there? Does this interact with SSD specific allocation policies
in some way? Is delayed allocation even relevant anymore with SSDs
that can do millions of IOPS?

Food for thought.

-- 
Dave Chinner
david@fromorbit.com

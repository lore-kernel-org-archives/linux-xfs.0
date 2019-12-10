Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062E2C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 21:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03492073B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 21:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfLJVlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:41:07 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35905 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728940AbfLJVlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 16:41:07 -0500
Received: from dread.disaster.area (pa49-195-139-249.pa.nsw.optusnet.com.au [49.195.139.249])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC63C7E892B;
        Wed, 11 Dec 2019 08:41:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ienFc-0005Xw-58; Wed, 11 Dec 2019 08:41:00 +1100
Date:   Wed, 11 Dec 2019 08:41:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191210214100.GB19256@dread.disaster.area>
References: <20191210132340.11330-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210132340.11330-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=KoypXv6BqLCQNZUs2nCMWg==:117 a=KoypXv6BqLCQNZUs2nCMWg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=BsZaSLXBfCrYZ0r_NfgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> generic/522 (fsx) occasionally fails with a file corruption due to
> an insert range operation. The primary characteristic of the
> corruption is a misplaced insert range operation that differs from
> the requested target offset. The reason for this behavior is a race
> between the extent shift sequence of an insert range and a COW
> writeback completion that causes a front merge with the first extent
> in the shift.

How is the COW writeback completion modifying the extent list while
an extent shift is modifying the extent list?  Both should be
running under XFS_ILOCK_EXCL contexts so there shouldn't be a race
condition here unless we've screwed up the extent list modification
atomicity...

> 
> The shift preparation function flushes and unmaps from the target
> offset of the operation to the end of the file to ensure no
> modifications can be made and page cache is invalidated before file
> data is shifted. An insert range operation then splits the extent at
> the target offset, if necessary, and begins to shift the start
> offset of each extent starting from the end of the file to the start
> offset. The shift sequence operates at extent level and so depends
> on the preparation sequence to guarantee no changes can be made to
> the target range during the shift.

Oh... shifting extents is not an atomic operation w.r.t. other
inode modifications - both insert and collapse run individual
modification transactions and lock/unlock the inode around each
transaction. So, essentially, they aren't atomic when faced with
other *metadata* modifications to the inode.

> If the block immediately prior to
> the target offset was dirty and shared, however, it can undergo
> writeback and move from the COW fork to the data fork at any point
> during the shift. If the block is contiguous with the block at the
> start offset of the insert range, it can front merge and alter the
> start offset of the extent. Once the shift sequence reaches the
> target offset, it shifts based on the latest start offset and
> silently changes the target offset of the operation and corrupts the
> file.

Yup, that's exactly the landmine that non-atomic, multi-transaction
extent range operations have. It might be a COW operation, it might
be something else that ends up manipulating the extent list. But
because the ILOCK is not held across the entire extent shift,
insert/collapse are susceptible to corruption when any other XFs
code concurrently modifies the extent list.

I think insert/collapse need to be converted to work like a
truncate operation instead of a series on individual write
operations. That is, they are a permanent transaction that locks the
inode once and is rolled repeatedly until the entire extent listi
modification is done and then the inode is unlocked.

> To address this problem, update the shift preparation code to
> stabilize the start boundary along with the full range of the
> insert. Also update the existing corruption check to fail if any
> extent is shifted with a start offset behind the target offset of
> the insert range. This prevents insert from racing with COW
> writeback completion and fails loudly in the event of an unexpected
> extent shift.

It looks ok to avoid this particular symptom (backportable point
fix), but I really think we should convert insert/collapse to be
atomic w.r.t other extent list modifications....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C51DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 20:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352452AbiDAUiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352510AbiDAUhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 16:37:41 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A189137F7D
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 13:35:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 22D4A5341FC;
        Sat,  2 Apr 2022 07:35:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1naNzo-00CcMJ-Ld; Sat, 02 Apr 2022 07:35:48 +1100
Date:   Sat, 2 Apr 2022 07:35:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220401203548.GL1544202@dread.disaster.area>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-2-david@fromorbit.com>
 <YkbmQ/fJ+55fNDw9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkbmQ/fJ+55fNDw9@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62476226
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=cz2JYKn0rRJSHHZkEOEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 01, 2022 at 04:47:15AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 30, 2022 at 12:10:41PM +1100, Dave Chinner wrote:
> > xfs_iflush_abort() can be called without the buffer lock being held
> > resulting in inodes being removed from the buffer list while other
> > list operations are occurring. This causes problems with corrupted
> > bp->b_io_list inode lists during filesystem shutdown, leading to
> > traversals that never end, double removals from the AIL, etc.
> > 
> > Fix this by passing the buffer to xfs_iflush_abort() if we have
> > it locked. If the inode is attached to the buffer, we're going to
> > have to remove it from the buffer list and we'd have to get the
> > buffer off the inode log item to do that anyway.
> 
> There is not buffer passed to xfs_iflush_abort.  I think this now
> needs to say

Ah, left over from the original patch and I forgot to update it when
I split the buffer/no buffer aborts into two functions because it
was cleaner than trying to do it conditionally in
xfs_iflush_abort().

> "Fix this by ensuring the inode buffer is locked when calling 
> xfs_iflush_abort if the inode is attached to a buffer."

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

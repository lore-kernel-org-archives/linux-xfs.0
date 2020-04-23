Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BBCC54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D6EC20784
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDWXFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:05:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50055 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgDWXFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:05:21 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E013B3A2D99;
        Fri, 24 Apr 2020 09:05:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRkuB-0006xA-E9; Fri, 24 Apr 2020 09:05:15 +1000
Date:   Fri, 24 Apr 2020 09:05:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
Message-ID: <20200423230515.GZ27860@dread.disaster.area>
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423172325.8595-1-wen.gang.wang@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=_5mIMHqqYSAAGL1o29YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 10:23:25AM -0700, Wengang Wang wrote:
> xfs_reclaim_inodes_ag() do infinate locking on pag_ici_reclaim_lock at the
> 2nd round of walking of all AGs when SYNC_TRYLOCK is set (conditionally).
> That causes dead lock in a special situation:
> 
> 1) In a heavy memory load environment, process A is doing direct memory
> reclaiming waiting for xfs_inode.i_pincount to be cleared while holding
> mutex lock pag_ici_reclaim_lock.
> 
> 2) i_pincount is increased by adding the xfs_inode to journal transection,
> and it's expected to be decreased when the transection related IO is done.
> Step 1) happens after i_pincount is increased and before truansection IO is
> issued.
> 
> 3) Now the transection IO is issued by process B. In the IO path (IO could
> be more complex than you think), memory allocation and memory direct
> reclaiming happened too.

Sure, but IO path allocations are done under GFP_NOIO context, which
means IO path allocations can't recurse back into filesystem reclaim
via direct reclaim. Hence there should be no way for an IO path
allocation to block on XFS inode reclaim and hence there's no
possible deadlock here...

IOWs, I don't think this is the deadlock you are looking for. Do you
have a lockdep report or some other set of stack traces that lead
you to this point?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

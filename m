Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52637 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfDKVp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 17:45:56 -0400
Date: Fri, 12 Apr 2019 07:45:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Deadlock waiting for log space
Message-ID: <20190411214552.GD29573@dread.disaster.area>
References: <20190411161500.43svvbxeqt6wbis2@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411161500.43svvbxeqt6wbis2@macbook-pro-91.dhcp.thefacebook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 11, 2019 at 12:15:01PM -0400, Josef Bacik wrote:
> Hello,
> 
> We're seeing a deadlock on xfs in a few kernels in production and are having a
> hard time figuring out what's happening.  Here is a breakdown of the stack
> traces on a box I could get to before it was rebooted, all the boxes we've found
> have been similar
> 
> 100 hits:
> [<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
> [<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
> [<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
> [<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
> [<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
.....

Which means you've run out of log space, and it's waiting for
metadata writeback to move the tail of the log and release grant
space, at which point these waiters will wake up.

If there is a deadlock, then it's caused by other threads getting
blocked somewhere, not but these ones that are waiting on log space.


> The only "fishy" thing is in our kernels (4.6, 4.11, and 4.16) xfs_vm_writepages
> calls xfs_submit_ioend with the page locked, whereas upstream doesn't.  However
> the change that introduced this is
> 
> 8e1f065bea1b ("xfs: refactor the tail of xfs_writepage_map")

Shouldn't matter. What you are looking for is fixes of this sort:

4df0f7f145f2 xfs: fix transaction allocation deadlock in IO path

which went into 4.17. There's been a few transaction deadlock
vectors fixed since 4.16 (e.g. in how we roll transactions and relog
items that are joined to the them), so we really need to know about
the context of all the other blocked threads rather than just the
ones that are waiting on log space....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

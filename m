Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8A8C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 05:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CADB20781
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 05:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgDWF7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 01:59:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45744 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgDWF7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 01:59:25 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1E9443A42D5;
        Thu, 23 Apr 2020 15:59:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRUtL-0000ux-23; Thu, 23 Apr 2020 15:59:19 +1000
Date:   Thu, 23 Apr 2020 15:59:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 08/13] xfs: elide the AIL lock on log item failure
 tracking
Message-ID: <20200423055919.GO27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-9-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=0BJheLd7CZE14YsAK2kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:24PM -0400, Brian Foster wrote:
> The log item failed flag is used to indicate a log item was flushed
> but the underlying buffer was not successfully written to disk. If
> the error configuration allows for writeback retries, xfsaild uses
> the flag to resubmit the underlying buffer without acquiring the
> flush lock of the item.
> 
> The flag is currently set and cleared under the AIL lock and buffer
> lock in the ->iop_error() callback, invoked via ->b_iodone() at I/O
> completion time. The flag is checked at xfsaild push time under AIL
> lock and cleared under buffer lock before resubmission. If I/O
> eventually succeeds, the flag is cleared in the _done() handler for
> the associated item type, again under AIL lock and buffer lock.

Actually, I think you've missed the relevant lock here: the item's
flush lock. The XFS_LI_FAILED flag is item flush state, and flush
state is protected by the flush lock. When the item has been flushed
and attached to the buffer for completion callbacks, the flush lock
context gets handed to the buffer.

i.e. the buffer owns the flush lock and so while that buffer is
locked for IO we know that the item flush state (and hence the
XFS_LI_FAILED flag) is exclusively owned by the holder of the buffer
lock.

(Note: this is how xfs_ifree_cluster() works - it grabs the buffer
lock then walks the items on the buffer and changes the callback
functions because those items are flush locked and hence holding the
buffer lock gives exclusive access to the flush state of those
items....)

> As far as I can tell, the only reason for holding the AIL lock
> across sets/clears is to manage consistency between the log item
> bitop state and the temporary buffer pointer that is attached to the
> log item. The bit itself is used to manage consistency of the
> attached buffer, but is not enough to guarantee the buffer is still
> attached by the time xfsaild attempts to access it.

Correct. The guarantee that the buffer is still attached to the log
item is what the AIL lock provides us with.

> However since
> failure state is always set or cleared under buffer lock (either via
> I/O completion or xfsaild), this particular case can be handled at
> item push time by verifying failure state once under buffer lock.

In theory, yes, but there's a problem before you get that buffer
lock. That is: what serialises access to lip->li_buf?

The xfsaild does not hold a reference to the buffer and, without the
AIL lock to provide synchronisation, the log item reference to the
buffer can be dropped asynchronously by buffer IO completion. Hence
the buffer could be freed between the xfsaild reading lip->li_buf
and calling xfs_buf_trylock(bp). i.e. this introduces a
use-after-free race condition on the initial buffer access.

IOWs, the xfsaild cannot access lip->li_buf safely unless the
set/clear operations are protected by the same lock the xfsaild
holds. The xfsaild holds neither the buffer lock, a buffer reference
or an item flush lock, hence it's the AIL lock or nothing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

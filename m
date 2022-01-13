Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA45C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 22:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbiAMWUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 17:20:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48675 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237352AbiAMWUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 17:20:00 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 31AF510C135F;
        Fri, 14 Jan 2022 09:19:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n88Rp-00Ex1x-LN; Fri, 14 Jan 2022 09:19:57 +1100
Date:   Fri, 14 Jan 2022 09:19:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc workqueue tasks before cancel
Message-ID: <20220113221957.GF3290465@dread.disaster.area>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113133701.629593-2-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61e0a58f
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=0hmv59I5XRo6iQX3weUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 08:37:00AM -0500, Brian Foster wrote:
> The xfs_inodegc_stop() helper performs a high level flush of pending
> work on the percpu queues and then runs a cancel_work_sync() on each
> of the percpu work tasks to ensure all work has completed before
> returning.  While cancel_work_sync() waits for wq tasks to complete,
> it does not guarantee work tasks have started. This means that the
> _stop() helper can queue and instantly cancel a wq task without
> having completed the associated work. This can be observed by
> tracepoint inspection of a simple "rm -f <file>; fsfreeze -f <mnt>"
> test:
> 
> 	xfs_destroy_inode: ... ino 0x83 ...
> 	xfs_inode_set_need_inactive: ... ino 0x83 ...
> 	xfs_inodegc_stop: ...
> 	...
> 	xfs_inodegc_start: ...
> 	xfs_inodegc_worker: ...
> 	xfs_inode_inactivating: ... ino 0x83 ...
> 
> The first few lines show that the inode is removed and need inactive
> state set, but the inactivation work has not completed before the
> inodegc mechanism stops. The inactivation doesn't actually occur
> until the fs is unfrozen and the gc mechanism starts back up. Note
> that this test requires fsfreeze to reproduce because xfs_freeze
> indirectly invokes xfs_fs_statfs(), which calls xfs_inodegc_flush().
> 
> When this occurs, the workqueue try_to_grab_pending() logic first
> tries to steal the pending bit, which does not succeed because the
> bit has been set by queue_work_on(). Subsequently, it checks for
> association of a pool workqueue from the work item under the pool
> lock. This association is set at the point a work item is queued and
> cleared when dequeued for processing. If the association exists, the
> work item is removed from the queue and cancel_work_sync() returns
> true. If the pwq association is cleared, the remove attempt assumes
> the task is busy and retries (eventually returning false to the
> caller after waiting for the work task to complete).
> 
> To avoid this race, we can flush each work item explicitly before
> cancel. However, since the _queue_all() already schedules each
> underlying work item, the workqueue level helpers are sufficient to
> achieve the same ordering effect. E.g., the inodegc enabled flag
> prevents scheduling any further work in the _stop() case. Use the
> drain_workqueue() helper in this particular case to make the intent
> a bit more self explanatory.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)

Looks good - flush/drain_workqueue() are much nicer was of doing
this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

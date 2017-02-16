Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:57018 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933157AbdBPWhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 17:37:09 -0500
Date: Fri, 17 Feb 2017 09:37:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: bypass dquot reclaim to avoid quotacheck
 deadlock
Message-ID: <20170216223705.GC15349@dastard>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <1487173247-5965-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487173247-5965-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Feb 15, 2017 at 10:40:43AM -0500, Brian Foster wrote:
> Reclaim during quotacheck can lead to deadlocks on the dquot flush lock:
> 
>  - Quotacheck populates a local delwri queue with the physical dquot
>    buffers.
>  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and dirties
>    all of the dquots.
>  - Reclaim kicks in and attempts to flush a dquot whose buffer is
>    already queud on the quotacheck queue. The flush succeeds but
>    queueing to the reclaim delwri queue fails as the backing buffer is
>    already queued. The flush unlock is now deferred to I/O completion of
>    the buffer from the quotacheck queue.
>  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires the
>    flush lock to update the backing buffers with the in-core
>    recalculated values. This deadlocks as the flush lock was acquired by
>    reclaim but the buffer never submitted for I/O as it already resided
>    on the quotacheck queue.
> 
> This is reproduced by running quotacheck on a filesystem with a couple
> million inodes in low memory (512MB-1GB) situations.
> 
> Quotacheck first resets and collects the physical dquot buffers in a
> delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> updates the in-core dquots, flushes the corrected dquots to the backing
> buffers and finally submits the delwri queue for I/O. Since the backing
> buffers are queued across the entire quotacheck operation, dquot reclaim
> cannot possibly complete a dquot flush before quotacheck completes.
> Therefore, dquot reclaim provides no real value during quotacheck.

Which is an OOM vector on systems with lots of dquots and low memory
at mount time. Turning off dquot reclaim doesn't change that.

Address the root cause - the buffer list is never flushed and so
pins the memory quotacheck requires, so we need to flush the buffer
list more often.  We also need to submit the buffer list before the
flush walks begin, thereby unlocking all the dquots before doing the
flush walk and avoiding the deadlock.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

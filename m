Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52855 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbeJMKEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Oct 2018 06:04:37 -0400
Date: Sat, 13 Oct 2018 13:29:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: clear ail delwri queued bufs on unmount of shutdown
 fs
Message-ID: <20181013022914.GX6311@dastard>
References: <20181012174654.2557-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012174654.2557-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 12, 2018 at 01:46:54PM -0400, Brian Foster wrote:
> In the typical unmount case, the AIL is forced out by the unmount
> sequence before the xfsaild task is stopped. Since AIL items are
> removed on writeback completion, this means that the AIL
> ->ail_buf_list delwri queue has been drained. This is not always
> true in the shutdown case, however.
> 
> It's possible for buffers to sit on a delwri queue for a period of
> time across submission attempts if said items are locked or have
> been relogged and pinned since first added to the queue.

Can you add this as a comment to xfs_buf_delwri_submit_nowait() to
document that callers either need to check that everything was
submitted and/or cancel the delwri list before they tear it down?


> If the
> attempt to log such an item results in a log I/O error, the error
> processing can shutdown the fs, remove the item from the AIL, stale
> the buffer (dropping the LRU reference) and clear its delwri queue
> state. The latter bit means the buffer will be released from a
> delwri queue on the next submission attempt, but this might never
> occur if the filesystem has shutdown and the AIL is empty.
> 
> This means that such buffers are held indefinitely by the AIL delwri
> queue across destruction of the AIL. Aside from being a memory leak,
> these buffers can also hold references to in-core perag structures.
> The latter problem manifests as a generic/475 failure, reproducing
> the following asserts at unmount time:
> 
>   XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
> 	file: fs/xfs/xfs_mount.c, line: 151
>   XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
> 	file: fs/xfs/xfs_mount.c, line: 132

Yup, I saw that once a couple of weeks ago, but was not able to
reproduce it to track it down.

> To prevent this problem, clear the AIL delwri queue as a final step
> before xfsaild() exit. The !empty state should never occur in the
> normal case, so add an assert to catch unexpected problems going
> forward.

*nod*.

Apart from needing to document how to use
xfs_buf_delwri_submit_nowait(), this looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

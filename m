Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24155 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbeJOJkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 05:40:33 -0400
Date: Mon, 15 Oct 2018 12:57:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: clear ail delwri queued bufs on unmount of shutdown
 fs
Message-ID: <20181015015727.GA6311@dastard>
References: <20181012174654.2557-1-bfoster@redhat.com>
 <20181013022914.GX6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181013022914.GX6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Oct 13, 2018 at 01:29:14PM +1100, Dave Chinner wrote:
> On Fri, Oct 12, 2018 at 01:46:54PM -0400, Brian Foster wrote:
> > In the typical unmount case, the AIL is forced out by the unmount
> > sequence before the xfsaild task is stopped. Since AIL items are
> > removed on writeback completion, this means that the AIL
> > ->ail_buf_list delwri queue has been drained. This is not always
> > true in the shutdown case, however.
> > 
> > It's possible for buffers to sit on a delwri queue for a period of
> > time across submission attempts if said items are locked or have
> > been relogged and pinned since first added to the queue.
> 
> Can you add this as a comment to xfs_buf_delwri_submit_nowait() to
> document that callers either need to check that everything was
> submitted and/or cancel the delwri list before they tear it down?

I added this comment to the patch when I pulled it in:

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2055,6 +2055,13 @@ xfs_buf_delwri_submit_buffers(
  * is only safely useable for callers that can track I/O completion by higher
  * level means, e.g. AIL pushing as the @buffer_list is consumed in this
  * function.
+ *
+ * Note: this function will skip buffers it would block on, and in doing so
+ * leaves them on @buffer_list so they can be retried on a later pass. As such,
+ * it is up to the caller to ensure that the buffer list is fully submitted or
+ * cancelled appropriately when they are finished with the list. Failure to
+ * cancel or resubmit the list until it is empty will result in leaked buffers
+ * at unmount time.
  */
 int
 xfs_buf_delwri_submit_nowait(

Does that look reasonable?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

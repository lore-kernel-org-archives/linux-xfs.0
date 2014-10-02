Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F16107F51
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 18:00:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE4BC304032
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 16:00:05 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	o0EbI2txmiCGaoZv for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 16:00:01 -0700 (PDT)
Date: Fri, 3 Oct 2014 08:59:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix the xfs_iflush_done callback search
Message-ID: <20141002225958.GC12693@dastard>
References: <20141001191803.153063401@sgi.com> <20141001223456.GV4758@dastard>
	<542D52DB.6090709@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <542D52DB.6090709@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 02, 2014 at 08:27:55AM -0500, Mark Tinguely wrote:
> On 10/01/14 17:34, Dave Chinner wrote:
> >On Wed, Oct 01, 2014 at 04:18:02PM -0500, Mark Tinguely wrote:
> >>Commit "xfs: remove all the inodes on a buffer from the AIL in bulk"
> >>made the xfs inode flush callback more efficient by combining all
> >>the inode writes on the buffer and the deletions of the inode log
> >>item from AIL.
> >>
> >>The initial loop in this patch should be looping through all
> >>the log items on the buffer to see which items have
> >>xfs_iflush_done as their callback function. But currently,
> >>only the log item passed to the function has its callback
> >>compared to xfs_iflush_done. If the log item pointer passed to
> >>the function does have the xfs_iflush_done callback function,
> >>then all the log items on the buffer are removed from the
> >>li_bio_list on the buffer b_fspriv and could be removed from
> >>the AIL eventhough they may have not been written yet.
> >
> >Looks like a bug, but what I don't know from this description is
> >the symptoms and impact of this bug being hit? Is there a risk of
> >filesystem corruption on crash or power loss? Perhaps it's a data
> >loss issue? I can't tell, and for anyone scanning the commit logs to
> >determine if they need to backport the fix will be asking the same
> >questions.
> >
> >Also, is there a reproducable test case for it?
> 
> I was looking in this code for a way an inode could be removed from
> the AIL but not written to disk.
> 
> I have a metadata dump that shows a truncate on two inodes just
> before a clean unmount. The free space btrees are updated but
> neither inode has been updated. A clean shutdown will wait until the
> AIL is empty,

And until all the inodes are reclaimed and buffers written. If the
inode is dirty in reclaim (i.e. has outstanding dirty fields in the
log item) then it will be written - the presence in the AIL is not
necessary for this to occur.  These dirty flags are only cleared
when the inode is flushed to the buffer and attached to it, so the
presence of these fields assumes the inode is in the AIL.

i.e. if reclaim didn't write the inodes out, it means the last
operation that happened on these inodes was xfs_iflush() and they
were cleaned and written to disk correctly.

> so something removed the inode from the AIL but did
> not write the latest changes to disk.  Yes, there were earlier
> changes to inode/chunk in previous pushes.

Let's look at this from a different perspective: how does the inode
get attached to the buffer in the first place so it can be removed
from the AIL in xfs_iflush_done()?  The only way inodes get attached
to the buffer through xfs_buf_attach_iodone() via either
xfs_iflush() or xfs_ifree_cluster().

xfs_iflush() is only called when an inode is either being pushed
from the AIL or being reclaimed and it is dirty. xfs_ifree_cluster()
is only called when an inode chunk is being deallocated.  Hence, any
inode on the buffer iodone list is either currently being written or
the extent it lies in has just been freed and it will never get
written.

When an inode chunk is being freed via xfs_ifree_cluster(), all the
inodes attached to the buffer have their iodone functions changed to
xfs_istale_done(). Hence we have the situation where all the inodes
on a buffer have the same callbacks: either xfs_istale_done() or
xfs_iflush_done(). And on buffer IO completion, all the inodes on
the buffer should be cleaned at the same time, and hence all should
have their completions run.

If the inode is modified by another transaction while the
push is in progress, the inode will be moved forward in the AIL. It
will have a more recent LSN than the flush in progress. Hence this
check in xfs_iflush_done() when determining if the inode should be
removed from the AIL:

                        if (iip->ili_logged &&
                            blip->li_lsn == iip->ili_flush_lsn) {
                                log_items[i++] = blip;
                        }

i.e. it only removes the item from the AIL if the flush LSN is
unchanged from when the inode was flushed to the buffer.

Hence I can't see how the existing code can result in removing a
dirty inode from the AIL without it being written to the buffer
first (and hence cleaned), nor if such a problem occurred how such a
dirty inode can make it through reclaim during unmount without being
seen as dirty and written to disk.

I agree that we should fix the code to be exactly correct, but I
can't see how the code as is stands behaves any differently from the
fixed version, nor how it would be responsible for the problem in
the metadump you analysed....

I'll rework the commit message appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

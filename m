Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A0J2Zi174367 for <xfs@oss.sgi.com>; Sun, 9 Jan 2011 18:19:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D4E6FC70AA
	for <xfs@oss.sgi.com>; Sun,  9 Jan 2011 16:21:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ha7zcvpNscfokC44 for <xfs@oss.sgi.com>;
	Sun, 09 Jan 2011 16:21:13 -0800 (PST)
Date: Mon, 10 Jan 2011 11:21:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix error handling for synchronous writes
Message-ID: <20110110002109.GD28803@dastard>
References: <20110107130223.GB12134@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107130223.GB12134@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 07, 2011 at 08:02:23AM -0500, Christoph Hellwig wrote:
> If we get an IO error on a synchronous superblock write, we attach an
> error release function to it so that when the last reference goes away
> the release function is called and the buffer is invalidated and
> unlocked. The buffer is left locked until the release function is
> called so that other concurrent users of the buffer will be locked out
> until the buffer error is fully processed.
> 
> Unfortunately, for the superblock buffer the filesyetm itself holds a
> reference to the buffer which prevents the reference count from
> dropping to zero and the release function being called. As a result,
> once an IO error occurs on a sync write, the buffer will never be
> unlocked and all future attempts to lock the buffer will hang.
> 
> To make matters worse, this problems is not unique to such buffers;
> if there is a concurrent _xfs_buf_find() running, the lookup will grab
> a reference to the buffer and then wait on the buffer lock, preventing
> the reference count from ever falling to zero and hence unlocking the
> buffer.
> 
> As such, the whole b_relse function implementation is broken because it
> cannot rely on the buffer reference count falling to zero to unlock the
> errored buffer. The synchronous write error path is the only path that
> uses this callback - it is used to ensure that the synchronous waiter
> gets the buffer error before the error state is cleared from the buffer
> by the release function.
> 
> Given that the only sychronous buffer writes now go through xfs_bwrite
> and the error path in question can only occur for a write of a dirty,
> logged buffer, we can move most of the b_relse processing to happen
> inline in xfs_buf_iodone_callbacks, just like a normal I/O completion.
> In addition to that we make sure the error is not cleared in
> xfs_buf_iodone_callbacks, so that xfs_bwrite can reliably check it.
> Given that xfs_bwrite keeps the buffer locked until it has waited for
> it and checked the error this allows to reliably propagate the error
> to the caller, and make sure that the buffer is reliably unlocked.
> 
> Given that xfs_buf_iodone_callbacks was the only instance of the
> b_relse callback we can remove it entirely.
> 
> Based on earlier patches by Dave Chinner and Ajeet Yadav.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

Passes xfsqa fine here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

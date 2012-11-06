Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6Cvsk0059495 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 06:57:54 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CL2QpXF91OLZvmXz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 04:59:50 -0800 (PST)
Date: Tue, 6 Nov 2012 07:59:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121106125949.GA32329@infradead.org>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
	<20121102131326.GG12578@infradead.org>
	<20121102234741.GB29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102234741.GB29378@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Nov 03, 2012 at 10:47:41AM +1100, Dave Chinner wrote:
> I think that's irrelevant here - there will *never* be an IO waiter
> at this point in time.  This processing is in log buffer IO
> completion context, so the buffers are still pinned in memory. Hence
> anyone trying to do IO on it will be waiting in xfs_buf_wait_unpin()
> and never get to xfs_buf_iowait(). And because xfs_buf_wait_unpin()
> is called with the buffer lock held, we'll never do the failure
> handling in xfs_buf_item_unpin until the buffer IO is completed and
> it is unlocked.

How do we manage to submit it synchronously then?  The inode and dquot
reclaim xfs_bwrite calls already wait for an unpin first, so I don't
think these are the problem.  The only other call on a live fs seems
to xfs_qm_shake -> xfs_buf_delwri_submit, but that one does wait
for the complete() call on b_iowait.  I suspect we are hitting that
and due to it skipping the wait if b_ioerror is set and waiting on
multiple buffers that complete together might hide the issue.

__xfs_buf_delwri_submit for the wait == true case also seems to be
the only place that actually skips the ispinned check.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PG9TIh013904 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 10:09:31 -0600
Date: Wed, 25 Jan 2012 11:09:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/12] xfs: split tail_lsn assignments from log space
	wakeups
Message-ID: <20120125160925.GA8360@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.542846138@bombadil.infradead.org>
	<4F15C26A.30408@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F15C26A.30408@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jan 17, 2012 at 12:48:10PM -0600, Mark Tinguely wrote:
> On 01/-10/63 13:59, Christoph Hellwig wrote:
> >Currently xfs_log_move_tail has a tail_lsn argument that is horribly
> >overloaded: it may contain either an actual lsn to assign to the log tail,
> >0 as a special case to use the last sync LSN, or 1 to indicate that no tail
> >LSN assignment should be performed, and we should opportunisticly wake up
> >at least one task waiting for log space.
> 
> I read the code as opportunistically waking at MOST one task per call.

I guess my wording wasn't quite clear - the opportunistic flag makes
sure at least one task is woken per call, but at most one of them
wouldn't otherwise be woken.

> Looks great. Just to be consistent, you could call the above as:
> 
> +		xfs_log_space_wake(ailp->xa_mount, true);

Indeed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

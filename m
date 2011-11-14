Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEK1BKg235496 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 14:01:11 -0600
Date: Mon, 14 Nov 2011 15:01:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] workqueue: make alloc_workqueue() take printf fmt and
	args for name
Message-ID: <20111114200100.GA18155@infradead.org>
References: <20111114194248.GD30922@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111114194248.GD30922@google.com>
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
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, bpm@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 14, 2011 at 11:42:48AM -0800, Tejun Heo wrote:
> Christoph, you probably were seeing the rescuer_task->comm in ps
> output.  wq->name currently is currently only used for error
> reporting.
> 
> I don't really mind this patch going through a different tree as I
> don't have any other wq changes scheduled at this point, so please
> feel free to route this through xfs or -mm.

Ben pointed the bug out in a patch that I'd like to get into 3.2
and -stable.  I'll probably repost it with a local workaround for now,
and will switch to the nicer interface later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

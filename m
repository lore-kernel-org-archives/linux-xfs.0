Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8KJDELD232679 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 14:13:17 -0500
Date: Mon, 20 Sep 2010 15:13:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: -mm: xfs lockdep warning
Message-ID: <20100920191355.GA28443@infradead.org>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100917005227.GJ24409@dastard>
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
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Alex Elder <aelder@sgi.com>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Sep 17, 2010 at 10:52:27AM +1000, Dave Chinner wrote:
> Christoph, this implies an inode that has been marked for reclaim
> that has not passed through xfs_fs_evict_inode() after being
> initialised. If it went through the eviction process, the iolock
> would have been re-initialised to a different context. Can you think
> of any path that can get here without going through ->evict? I can't
> off the top of my head...

I think this could happen if the init_inode_always during
re-initialization of an inode in reclaim fails in iget.  I have a patch
to add that I'll run through xfsqa.  It should only happen very rarely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

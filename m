Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2FE6HE179300 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 10:14:06 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90F191F2D111
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 08:14:05 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id Dp8fHI6CW55XnJ2S for
	<xfs@oss.sgi.com>; Wed, 02 Nov 2011 08:14:05 -0700 (PDT)
Date: Wed, 2 Nov 2011 23:13:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: writeback tree status (for 3.2 merge window)
Message-ID: <20111102151355.GA6717@localhost>
References: <20111101074347.GA23644@localhost>
	<20111102091012.GA25879@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111102091012.GA25879@infradead.org>
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
Cc: Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrea Righi <arighi@develer.com>, LKML <linux-kernel@vger.kernel.org>, Curt Wohlgemuth <curtw@google.com>, linux-mm <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Tang Feng <feng.tang@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Nov 02, 2011 at 05:10:12AM -0400, Christoph Hellwig wrote:
> On Tue, Nov 01, 2011 at 03:43:47PM +0800, Wu Fengguang wrote:
> > Hi,
> > 
> > There are 3 patchsets sitting in the writeback tree.
> > 
> >         1) IO-less dirty throttling v12
> >         https://github.com/fengguang/linux/commits/dirty-throttling-v12
> > 
> >         2) writeback reasons tracing from Curt Wohlgemuth
> >         https://github.com/fengguang/linux/commits/writeback-reason
> > 
> >         3) writeback queuing changes from Jan Kara and me
> >         https://github.com/fengguang/linux/commits/requeue-io-wait
> > 
> > They have been merged into this branch testing in linux-next for a while:
> > 
> > https://github.com/fengguang/linux/commits/writeback-for-next
> > 
> > Since (3) still has an unresolved issue (detailed in the below
> > links), it looks better to hold it back for this merge window.
> 
> Given that we have run into issues so much with it that's proably
> the better idea.
> 
> To fix the originally reported issue with the missing file size updates
> in XFS we plan to simply log all filesize changes in XFS.  Currently I
> had this in the 3.3 queue, but in the worst case we might have to move
> this forward to 3.2.

OK. Anyway I'll report any progress early on (3).

> > The patches from (1,2) together with 2 tracing patches essential for
> > debugging (1) have been pushed to the "writeback-for-linus" branch:
> > 
> >         http://git.kernel.org/?p=linux/kernel/git/wfg/linux.git;a=shortlog;h=refs/heads/writeback-for-linus
> > 
> > If no objections, I'll send a pull request to Linus soon.
> 
> Please do so.  I'm really looking forward to see the I/O-less
> balance_dirty_pages in ASAP.

Done, thanks!

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

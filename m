Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C0J1xf154795 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 19:19:02 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Rax2yLYfEnYQvztO for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 17:18:58 -0700 (PDT)
Date: Tue, 12 Jun 2012 10:18:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check for stale inode before acquiring iflock on push
Message-ID: <20120612001855.GI22848@dastard>
References: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
	<4FD63B60.3070708@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD63B60.3070708@sgi.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 11, 2012 at 01:39:28PM -0500, Mark Tinguely wrote:
> On 06/11/12 09:39, Brian Foster wrote:
> >An inode in the AIL can be flush locked and marked stale if
> >a cluster free transaction occurs at the right time. The
> >inode item is then marked as flushing, which causes xfsaild
> >to spin and leaves the filesystem stalled. This is
> >reproduced by running xfstests 273 in a loop for an
> >extended period of time.
> >
> >Check for stale inodes before the flush lock. This marks
> >the inode as pinned, leads to a log flush and allows the
> >filesystem to proceed.
> >
> >Signed-off-by: Brian Foster<bfoster@redhat.com>
> >---
> >
> >This patch resolves the stall I was reproducing with the 273 loop test.
> >I repeated the test pretty much throughout the weekend. I still hit one
> >hung task timeout message, but the test proceeded through it.
> >
> >Dave, I know you mentioned you were sending a similar patch. Either you
> >didn't get to it or I missed it, but here's what I've been testing....
> >
> >Brian
> >
> 
> 
> Still hangs right away on Linux 3.5rc1 using a very small log and
> the perl test program.
> 
> I will investigate more.
> 
> Darn, the printk routines in Linux 3.5 added a "struct log" and
> crash is finding that definition.

Luckily that's just an internal structure in printk.c. However, I've
been waiting for such a namespace collision to happen for a long
time so perhaps you could write a patch that renames the XFS one to
"struct xlog" to match all the other XFS log codei to avoid
potential problems in the future. Oh, and while you are there, kill
the xlog_t typedef....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

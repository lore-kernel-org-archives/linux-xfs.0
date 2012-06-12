Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C0COT3154283 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 19:12:25 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DPTrWYdMgMgnFHMP for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 17:12:23 -0700 (PDT)
Date: Tue, 12 Jun 2012 10:12:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check for stale inode before acquiring iflock on push
Message-ID: <20120612001221.GH22848@dastard>
References: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2012 at 10:39:43AM -0400, Brian Foster wrote:
> An inode in the AIL can be flush locked and marked stale if
> a cluster free transaction occurs at the right time. The
> inode item is then marked as flushing, which causes xfsaild
> to spin and leaves the filesystem stalled. This is
> reproduced by running xfstests 273 in a loop for an
> extended period of time.
> 
> Check for stale inodes before the flush lock. This marks
> the inode as pinned, leads to a log flush and allows the
> filesystem to proceed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This patch resolves the stall I was reproducing with the 273 loop test.
> I repeated the test pretty much throughout the weekend. I still hit one
> hung task timeout message, but the test proceeded through it.
> 
> Dave, I know you mentioned you were sending a similar patch. Either you
> didn't get to it or I missed it, but here's what I've been testing....

Just didn't get to sending it - it was a holiday yesterday. The
patch is identical, though the commit message is a bit different:

    xfs: inode staleness more important than flushing for AIL

    When we have a dirty stale inode, it must be attached to the
    underlying stale buffer and that means it is flush locked. This
    means that the AIL pushing will only ever see flushing inodes, and
    that means if enough of them are built up at the start of the AIL we
    will never trigger a log force from the AIL to get them moving.

    Hence consider the stale state of inodes more important to report
    than whether they are flushing so as to trigger log forces from the
    AIL more readily in this situation.

Otherwise, consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

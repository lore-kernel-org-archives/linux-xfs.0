Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKr9g165903 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:53 -0600
Subject: Re: [PATCH 8/8] xfs: fix dquot shaker deadlock
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-9-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-9-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:23:17 -0600
Message-ID: <1296076997.1980.945.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
> to unlock the dquot freelist when the number of loop restarts is
> exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
> reclaim. Remove the bogus loop exit check that causes the problem.
> 
> Reported-by: Malcolm Scott <lkml@malc.org.uk>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/quota/xfs_qm.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

I see what Christoph means about the double-increment of
restart in the case where qi_dqlist_lock is not acquired.
That ought to be fixed.  I also agree with his suggested
loop termination condition change.

Also, restarts is pre-incremented in the XFS_DQ_WANT case
at the top, but post-incremented elsewhere for some reason.
I think they all ought to be the same.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

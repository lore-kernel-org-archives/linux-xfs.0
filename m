Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RFQeJf236954 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 09:26:40 -0600
Subject: Re: [PATCH 8/8] xfs: fix dquot shaker deadlock
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1296100401-17135-9-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
	<1296100401-17135-9-git-send-email-david@fromorbit.com>
Date: Thu, 27 Jan 2011 09:29:01 -0600
Message-ID: <1296142141.1973.62.camel@doink>
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

On Thu, 2011-01-27 at 14:53 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
> to unlock the dquot freelist when the number of loop restarts is
> exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
> reclaim. Remove the bogus loop exit check that causes the problem.
> 
> Reported-by: Malcolm Scott <lkml@malc.org.uk>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Still not a pretty loop (and I have no suggestions
to improve it).  But it looks correct.

Please add a mention in the description that the
double-increment issue in the qi_dqlist_lock case
has been fixed.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

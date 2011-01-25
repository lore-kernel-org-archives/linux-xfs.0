Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P9oKX4235817 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:50:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B8B01A1EA04
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:52:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4cFAATTPsIFkI6nZ for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:52:43 -0800 (PST)
Date: Tue, 25 Jan 2011 04:52:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: fix dquot shaker deadlock
Message-ID: <20110125095242.GB23990@infradead.org>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295945444-29488-9-git-send-email-david@fromorbit.com>
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

On Tue, Jan 25, 2011 at 07:50:44PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
> to unlock the dquot freelist when the number of loop restarts is
> exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
> reclaim. Remove the bogus loop exit check that causes the problem.

The fix looks correct, but it's a bit inconsequential about when
to adhere the retry limit and when not.  Shouldn't we just turn the
exit condition into:

	if (dqout || restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
		break;

also the failure to acquite qi_dqlist_lock increments the restart
count twice, which was also added in the same commit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS2B3m0122932 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 20:11:03 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1ZRv24Gke4yb6aFS for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:13:19 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] splice: fix direct IO/splice deadlock
Date: Wed, 28 Nov 2012 13:12:46 +1100
Message-Id: <1354068768-4316-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

Hi Folks,

These two patches have been sitting in my tree for some time. I think I've even
posted them before. Basically, XFS can deadlock when you use splice and direct
IO on the same file concurrently because the splice write inverts the locking
order of the i_mutex and the xfs inode i_iolock. The first patch moves the guts
of the i_mutex protected region of the splice write to an actor function, and
the second uses this structure to enable XFS to provide an actor that uses the
correct locking order and hence avoid the deadlock.

Comments?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

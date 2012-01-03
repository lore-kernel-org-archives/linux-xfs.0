Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q03Nj0FA094564 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 17:45:00 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HKdv8gJeD2Qg2OgF for <xfs@oss.sgi.com>;
	Tue, 03 Jan 2012 15:44:57 -0800 (PST)
Date: Wed, 4 Jan 2012 10:44:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [LSF/MM TOPIC] [ATTEND] xfstests: what do we need to do to make it
	better?
Message-ID: <20120103234455.GU23662@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


Given that more people are using xfstests and developing tests, we
need to consider how to make it friendlier to hack on. The current
structure of the tree is difficult to work with, the way tests are
organised and numbered make it difficult to co-ordinate new tests
and results in patch conflicts, etc.

We also see problems arising from people not really understanding how
the xfstests harness is designed and how it really is supposed to
work, so an overview of the underlying principles of operation would
probably be helpful to a lot of people. It will also save
review and rework time if we can avoid having people make the same
mistakes the first time they submit tests....

I'd also like to discuss some potential infrastructure changes to
make it easier to add new tests without conflicts with others
developing new tests. Some of the ideas Christoph and I have
previously tossed around include:

	- break tests up into groups in their own subdirectories.
	  e.g. generic tests, xfs/ext4/btrfs specific tests, stress
	  tests, performance tests, large FS tests, etc
	- change the way we define groups of tests so we don't have
	  a single registry of tests and their groups
	- allow different naming of tests, such as desciptive text
	  names rather than just plain numbers
	- allow duplicate test names in different groups

I'm sure that other users of xfstests will have some ideas on how to
improve it for the way they run it, so I'd like to gather and
incorporate these ideas into any structural change we make to
xfstests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

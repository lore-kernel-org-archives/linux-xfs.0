Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A2EO5M139928 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 21:14:24 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EB7655E1C5
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 19:14:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QkIQnyJjeL5xOype for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 19:14:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD5Nj-0003tT-AD
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 13:14:19 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD5Ni-0005H0-QZ
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 13:14:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfstests: test different block sizes in a couple of tests
Date: Mon, 10 Oct 2011 13:14:13 +1100
Message-Id: <1318212855-20212-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Recently a problem was reported on test 225 when using a 512 byte
block size. I couldn't reproduce this problem using MKFS_OPTION="-b
size=512". The problem is that some tests use the TEST_DEV and
MKFS_OPTION only applies to the SCRATCH_DEV. To change the block
size of these tests, you need to specifically mkfs the TEST_DEV to
use those block sizes. This is not a typical test config - the
TEST_DEV is not supposed to be remade frequently, as it is designed
to be used for aging and testing aged filesystems.

Change a couple of tests that are testing hole/allocation patterns
to use the scratch device so that we get test coverage on multiple
block sizes, not just the default 4k block size filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

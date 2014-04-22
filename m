Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08B847F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D420D304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CfZQ0jHRSjglvx0v for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:41 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PH-BG
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000nu-AE
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfstests: fixes and new tests
Date: Wed, 23 Apr 2014 08:04:28 +1000
Message-Id: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

In this series, there are a some cleanup patches related to running
small TEST_DEV filesystems out of space on repeated runs. There are
some tests that leave large files lying around that consume space,
so when you have a 4GB TEST_DEV soem of the tests will fail because
they need 3GB of free space.

There is a new test for maximum ACL count support in XFS - I've
removed the ACL count subtest from shared/051 and created a new XFS
specific test that uses the maximum supported number of ACLs for the
given filesystem configuration rather than 25. This new test is what
exposed the transaction overrun when replacing a remote attribute
with an inline attribute.

There is also a patch to remove the DMAPI tests from the auto group
- almost nobody has an XFS/DMAPI enabled kernel that can run these
tests, so they can add "-g dmapi" to their tests runs rather than
have everyone else have to run "-x dmapi" to avoid the "notrun"
noise that is generated.

Finally, there is a xfs_repair filter patch that chops out the new
CRC/corruption detection messages that are emitted when verifiers
detect problems. This makes xfs/030 and xfs/033 pass....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

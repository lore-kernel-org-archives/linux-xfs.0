Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U5Lgac183968 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:21:42 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F352040E92
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:41 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id uLDlriGgb5dqZZKU for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:41 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5U50tHg028779
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:00:55 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5U5Le5T1785982
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5U5LdGV031673 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:40 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/4 v3] XFS TESTS: Fix 252 failure
Date: Wed, 29 Jun 2011 22:23:57 -0700
Message-Id: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

This patch corrects a 252 test failure when run on ext4.  This failure
occures because ext4 and xfs do not handle splitting extents in the same way, 
and do not create the same fiemap outout.

To correct this, this patch set will make test 252 an xfs only test, and a new 
test 255 will be added.  The new test is similar to 252, but uses a weaker fiemap filter
that only shows the location of the hole, and not the extent type.  An
md5 check sum has also been added to the tests to help ensure the contents are
correct.

Also, another patch was submitted that modifies the same code in 242.out.
Assuming that patch will go through, this set was modified to be applied on 
top of Christoph's "[PATCH] xfstests: update test 042 golden output" (06/20/2011). 

I noticed there are some other patches that are trying to add a test 255, so we 
may need another version of this set depending on which ones go in first.

Allison Henderson (4):
  XFS TESTS: Fix 252 Failure: Make 252 xfs only with MD5 checksum
  XFS TESTS: Fix 252 Failure: Update 252 Golden Output
  XFS TESTS: Fix 252 Failure: Update 242 Golden Output
  XFS TESTS: Fix 252 Failure: Add Generic FS Punch Hole Test 255

 242.out      |   17 +++
 252          |    2 +-
 252.out      |   68 +++++++++++++
 255          |   67 +++++++++++++
 255.out      |  307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.punch |   40 ++++++++
 group        |    1 +
 7 files changed, 501 insertions(+), 1 deletions(-)
 create mode 100644 255
 create mode 100644 255.out

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

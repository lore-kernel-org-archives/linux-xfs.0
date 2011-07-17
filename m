Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6HNsEGr065531 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 18:54:15 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADF9C52AA2E
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:54:14 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id SjxDBaKGpkN9LyKx for
	<xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:54:14 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6HNX7HP015032
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 19:33:07 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p6HNpf7d176522 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:41 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6HNpenb027700
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:41 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v8] XFS TESTS: ENOSPC Punch Hole Test
Date: Sun, 17 Jul 2011 16:52:44 -0700
Message-Id: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
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

This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
This test will verify that a hole can be punched even when the disk is full.
Reserved blocks should be used to complete the operation when there is not blocks
to further fragment the file.

Because punching a hole does not always require extra blocks, there needs to 
be several iterations of punching holes, and then filling the file system to 100% 
usage before it is forced to grow the tree in order to handle the fragmentation. 
The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.

Allison Henderson (2):
  XFS TESTS: ENOSPC Punch Hole: Move su routines in 123 to common.rc
  XFS TESTS: Add ENOSPC Hole Punch Test

 123       |   24 ------------
 256       |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 256.out   |    1 +
 common.rc |   81 +++++++++++++++++++++++++++++++++++++++++
 group     |   12 ++++--
 5 files changed, 210 insertions(+), 28 deletions(-)
 create mode 100644 256
 create mode 100644 256.out

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

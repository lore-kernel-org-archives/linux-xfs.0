Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S5Uj1w182639 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:30:45 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B125CE31AAE
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:30:44 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id YMbup8CgQJv6iDip for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:30:44 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S5Rcuh003639
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:27:38 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S5UaiP121248 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:30:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5RNU480022746
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 17:30:07 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/2 v6] XFS TESTS: ENOSPC Punch Hole: Add new test 255
Date: Mon, 27 Jun 2011 22:32:43 -0700
Message-Id: <1309239163-3975-3-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

This patch adds a new test 255 that tests that a hole can be punched even when the
disk is full.  Reserved blocks should be used to allow a punch hole to proceed even
when there is not enough blocks to further fragment the file. To test this, the
file system is fragmented by punching holes in regular intervals and filling
the file system between punches. This will eventually force the file system to use
reserved blocks to proceed with the punch hole operation.

The work in this patch is a continuation from a previous patch set that has been
partially accepted.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---

v5->v6

Test moved out of 252 and put in its own test 255

_fill_fs and _test_full_fs_punch have been moved from common.punch
to test 255 and modified to use the _user_do routines in common.rc

_fill_fs has been optimized to stop once files smaller than a block
cannot be created.

:100644 100644 1f86075... c045e70... M	group
 group |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/group b/group
index 1f86075..c045e70 100644
--- a/group
+++ b/group
@@ -368,3 +368,4 @@ deprecated
 252 auto quick prealloc
 253 auto quick
 254 auto quick
+255 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

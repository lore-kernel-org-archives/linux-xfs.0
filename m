Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IFtJNt202660 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 10:55:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UymALESIeO7ySGAo for
	<xfs@oss.sgi.com>; Mon, 18 Jun 2012 08:55:18 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5IFtHs1004043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 11:55:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: filter out latest xfsdump version messages
Date: Mon, 18 Jun 2012 11:56:03 -0400
Message-Id: <1340034963-24932-1-git-send-email-bfoster@redhat.com>
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
Cc: sandeen@redhat.com

The latest version of xfsdump/restore (3.1.0) causes dump tests
to complain. Fix up the filter to include a wider selection of
version numbers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common.dump |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common.dump b/common.dump
index ca09ec1..61d3f43 100644
--- a/common.dump
+++ b/common.dump
@@ -863,7 +863,7 @@ _dump_filter_main()
       -e 's/1048576/BLOCKSZ/'				\
       -e 's/2097152/BLOCKSZ/'				\
       -e 's/(pid[	 ]*[1-9][0-9]*)/\(pid PID\)/'	\
-      -e '/version 3\.0/d'				\
+      -e '/version [3-9]\.[0-9]/d'				\
       -e 's/\/hw\/module.*$/SCRATCH_DEV/'		\
       -e 's/xfsdump: ino map phase 1: .*/xfsdump: ino map <PHASES>/' \
       -e '/xfsdump: ino map phase [2]/,1d'		\
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

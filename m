Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17JGARF255412 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 13:16:10 -0600
Received: from mail-yw0-f73.google.com (mail-yw0-f73.google.com
	[209.85.213.73]) by cuda.sgi.com with ESMTP id A3cgoBN7YzBXj0eD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 11:16:09 -0800 (PST)
Received: by yhpp61 with SMTP id p61so796855yhp.2
	for <xfs@oss.sgi.com>; Tue, 07 Feb 2012 11:16:08 -0800 (PST)
From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] xfstests: fix msync() call in fsx.c:domapwrite()
Date: Tue,  7 Feb 2012 11:16:06 -0800
Message-Id: <1328642166-389-1-git-send-email-curtw@google.com>
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
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>

This explicitly sends MS_SYNC as the flag to msync() in
fsx.c, in domapwrite().  Without this flag, the memory
written to the mmap'ed region will not be flushed to disk;
in fact, on Linux, calling msync() with a '0' or MS_ASYNC
flag is a no-op.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 ltp/fsx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index b36c201..2f1e3e8 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -779,7 +779,7 @@ domapwrite(unsigned offset, unsigned size)
 		report_failure(202);
 	}
 	memcpy(p + pg_offset, good_buf + offset, size);
-	if (msync(p, map_size, 0) != 0) {
+	if (msync(p, map_size, MS_SYNC) != 0) {
 		prterr("domapwrite: msync");
 		report_failure(203);
 	}
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

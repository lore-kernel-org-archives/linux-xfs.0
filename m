Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q168Sln5114154 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 02:28:48 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id nEk7X512RyOlzgH8 for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 00:28:46 -0800 (PST)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/3][RESEND] xfstests: fix 251's cp -axT problem
Date: Mon, 6 Feb 2012 16:27:47 +0800
Message-Id: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
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
To: linux-btrfs@vger.kernel.org
Cc: hch@infradead.org, xfs@oss.sgi.com

When I ran xfstests, 251 got failed cause I use a symlink and
"cp -axT" did not work as wish:
cp: cannot overwrite directory `/mnt/scratch/1' with non-directory

With this patch, 251 has passed.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 251 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/251 b/251
index fa3d74a..b54e4c3 100755
--- a/251
+++ b/251
@@ -130,7 +130,7 @@ function run_process() {
 
 		# Copy content -> partition.
 		mkdir $SCRATCH_MNT/$p
-		cp -axT $content $SCRATCH_MNT/$p
+		cp -axT $content/ $SCRATCH_MNT/$p/
 		export chpid=$! && wait $chpid &> /dev/null
 
 		check_sums
-- 
1.6.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

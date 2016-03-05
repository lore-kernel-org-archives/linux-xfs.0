Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C449B7CA7
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 14:25:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 865478F8039
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 12:25:06 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Vok9D1hWnYxozPR7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 05 Mar 2016 12:25:04 -0800 (PST)
Date: Sat, 5 Mar 2016 12:25:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/12] xfs/209: filter scratch dir properly
Message-ID: <20160305202502.GI10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/tests/xfs/209 b/tests/xfs/209
index cecd9c7..9bf1f12 100755
--- a/tests/xfs/209
+++ b/tests/xfs/209
@@ -73,7 +73,7 @@ echo "Check cowextsize settings"
 seq 1 2 | while read nr; do
 	seq 1 4 | while read nnr; do
 		file="$testdir/dir-$nr/file-$nnr"
-		$XFS_IO_PROG -c "cowextsize" $file
+		$XFS_IO_PROG -c "cowextsize" $file | _filter_scratch
 	done
 done
 
diff --git a/tests/xfs/209.out b/tests/xfs/209.out
index 109af34..b97fa96 100644
--- a/tests/xfs/209.out
+++ b/tests/xfs/209.out
@@ -3,11 +3,11 @@ Format and mount
 Set extsz and cowextsz on directory
 Create a fake tree structure
 Check cowextsize settings
-[1048576] /opt/test-209/dir-1/file-1
-[1048576] /opt/test-209/dir-1/file-2
-[1048576] /opt/test-209/dir-1/file-3
-[1048576] /opt/test-209/dir-1/file-4
-[1048576] /opt/test-209/dir-2/file-1
-[1048576] /opt/test-209/dir-2/file-2
-[1048576] /opt/test-209/dir-2/file-3
-[1048576] /opt/test-209/dir-2/file-4
+[1048576] SCRATCH_MNT/test-209/dir-1/file-1
+[1048576] SCRATCH_MNT/test-209/dir-1/file-2
+[1048576] SCRATCH_MNT/test-209/dir-1/file-3
+[1048576] SCRATCH_MNT/test-209/dir-1/file-4
+[1048576] SCRATCH_MNT/test-209/dir-2/file-1
+[1048576] SCRATCH_MNT/test-209/dir-2/file-2
+[1048576] SCRATCH_MNT/test-209/dir-2/file-3
+[1048576] SCRATCH_MNT/test-209/dir-2/file-4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

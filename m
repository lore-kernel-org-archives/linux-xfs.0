Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HFE03F176165 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 10:14:01 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dbSW7la5mcXqBiQx for
	<xfs@oss.sgi.com>; Mon, 17 Sep 2012 08:15:10 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8HFFAPc013651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:15:10 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8HFF9Pq023601
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:15:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: fix TEST_MNT typos (should be TEST_DIR)
Date: Mon, 17 Sep 2012 11:15:35 -0400
Message-Id: <1347894935-1495-1-git-send-email-bfoster@redhat.com>
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

We mistakenly use TEST_MNT in tests 222 and 253, which is undefined.
Replace these two instances with TEST_DIR.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 222 |    2 +-
 253 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/222 b/222
index a65c845..df2672f 100755
--- a/222
+++ b/222
@@ -51,7 +51,7 @@ _supported_os Linux
 
 [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
 
-xfs_fsr -d -v $TEST_MNT > $seq.full 2>&1
+xfs_fsr -d -v $TEST_DIR > $seq.full 2>&1
 
 echo "--- silence is golden ---"
 status=0 ; exit
diff --git a/253 b/253
index d8c94a2..4d0b4c2 100755
--- a/253
+++ b/253
@@ -59,7 +59,7 @@ _require_scratch
 # real QA test starts here
 
 OUTPUT_DIR="${SCRATCH_MNT}/test_${seq}"
-METADUMP_FILE="${TEST_MNT}/${seq}_metadump"
+METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
 ORPHANAGE="lost+found"
 
 _supported_fs xfs
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

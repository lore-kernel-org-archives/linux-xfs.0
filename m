Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA8B97F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 01:52:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6927CAC001
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 23:52:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GlpcDdnjNpxkGgmV for
	<xfs@oss.sgi.com>; Sun, 17 Feb 2013 23:52:01 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1I7q1bh014008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 02:52:01 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests 100: do not use scratch
Date: Mon, 18 Feb 2013 08:51:51 +0100
Message-Id: <1361173911-12422-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Test #100 does not use scratch device at all but it still
_require_scratch and _check_scratch_fs. This might also be a problem if
the test before this one failed and corrupted scratch partition.

Remove the _require_scratch() and _check_scratch_fs() from the test.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 100 |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/100 b/100
index f3504ce..ad61823 100755
--- a/100
+++ b/100
@@ -69,7 +69,6 @@ _populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$here/$
 tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$here/$seq.full 2>&1
 
 # create f/s
-_require_scratch
 _setup_testdir
 
 # untar on f/s
@@ -84,7 +83,6 @@ diff -qr $POPULATED_DIR ${testdir}${POPULATED_DIR}
 
 cd /
 _cleanup_testdir
-_check_scratch_fs
 
 status=0
 exit
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

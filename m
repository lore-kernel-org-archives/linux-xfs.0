Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA3A77F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 04:01:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56CB9AC001
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:01:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CqgAzotL9JMlHzzF for
	<xfs@oss.sgi.com>; Sun, 12 May 2013 02:01:44 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4C91iiU013788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 05:01:44 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 1/2] xfstests 200: remove words from output
Date: Sun, 12 May 2013 11:01:12 +0200
Message-Id: <1368349273-23968-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

Remove phrase "block device" from 200.out since mount warning message
does not use it.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 tests/xfs/200.out | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/200.out b/tests/xfs/200.out
index 2629541..27a76c0 100644
--- a/tests/xfs/200.out
+++ b/tests/xfs/200.out
@@ -1,7 +1,7 @@
 QA output created by 200
 setting device read-only
 mounting read-only block device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
 touching file on read-only filesystem (should fail)
 touch: cannot touch `SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
@@ -12,12 +12,12 @@ going down:
 unmounting shutdown filesystem:
 setting device read-only
 mounting filesystem that needs recovery on a read-only device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
-mount: cannot mount block device SCRATCH_DEV read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
+mount: cannot mount SCRATCH_DEV read-only
 unmounting read-only filesystem
 umount: SCRATCH_MNT: not mounted
 mounting filesystem with -o norecovery on a read-only device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
 unmounting read-only filesystem
 setting device read-write
 mounting filesystem that needs recovery with -o ro:
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

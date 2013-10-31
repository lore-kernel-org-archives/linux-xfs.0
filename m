Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05B497F52
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 05:57:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E971F304048
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 03:57:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ogUGEI5j1jeLYKRB for
	<xfs@oss.sgi.com>; Thu, 31 Oct 2013 03:57:42 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9VAvfWr003620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 06:57:41 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: fix _filter_ro_mount and make xfs/200 pass with old
	mount
Date: Thu, 31 Oct 2013 18:55:16 +0800
Message-Id: <1383216916-2211-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

We just want to remove "block device" in _filter_ro_mount(), so add
"mount:" back.

Add one more call of _filter_ro_mount() in xfs/200 to match 200.out.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter | 2 +-
 tests/xfs/200 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/filter b/common/filter
index 2390ec0..e37ce69 100644
--- a/common/filter
+++ b/common/filter
@@ -308,7 +308,7 @@ _filter_fstrim()
 # Older mount output referred to "block device" when mounting RO devices
 # It's gone in newer versions
 _filter_ro_mount() {
-	sed -e "s/mount: block device//g" \
+	sed -e "s/mount: block device/mount:/g" \
 	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
 }
 
diff --git a/tests/xfs/200 b/tests/xfs/200
index f573481..f4db64f 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -58,7 +58,7 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_scratch_mount 2>&1 | _filter_scratch
+_scratch_mount 2>&1 | _filter_scratch | _filter_ro_mount
 
 echo "touching file on read-only filesystem (should fail)"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

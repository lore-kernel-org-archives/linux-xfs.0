Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70F8E7F62
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 09:00:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A800304089
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 07:00:13 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oDfOFX7aeDtABuQy for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 07:00:11 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 505B3A50DE
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 16:00:11 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: skip generic/192 if noatime is set
Date: Wed,  3 Jul 2013 16:00:05 +0200
Message-Id: <1372860005-1016-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Test generic/192 fails if noatime is set

generic/192
    -delta1 - access time after sleep in-core: 40
    -delta2 - access time after sleep on-disk: 40
    +delta1 - access time after sleep in-core: 0
    +delta2 - access time after sleep on-disk: 0

but it's pointless to test atime effects with noatime.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/generic/192 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/generic/192 b/tests/generic/192
index a40c121..2b4e41c 100755
--- a/tests/generic/192
+++ b/tests/generic/192
@@ -38,6 +38,13 @@ _access_time()
 	stat --format=%X $1
 }
 
+is_noatime_set() {
+	case "$MOUNT_OPTIONS" in
+		*noatime*) return 0;;
+	esac
+	return 1
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -52,6 +59,10 @@ _supported_os Linux
 #delay=45
 delay=40
 
+if is_noatime_set; then
+	_notrun "this test makes no sense with noatime"
+fi
+
 testfile=$TEST_DIR/testfile
 rm -f $testfile
 rm -f $seqres.full
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

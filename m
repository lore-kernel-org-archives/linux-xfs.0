Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7F367F58
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A15BAC003
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oqa7hWs1e0vUKuWe for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Pu-GM
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007p8-FQ
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] shared/051: CRC enabled filesystems handle more than 25
	ACLs
Date: Mon, 24 Feb 2014 14:06:13 +1100
Message-Id: <1393211175-30016-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1393211175-30016-1-git-send-email-david@fromorbit.com>
References: <1393211175-30016-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

shared/051 fails on CRC enabled filesystems because it doesn't get
an erro on setting the 26th ACL on a file. CRC enabled filesystems
support more than 25, so there shoul dbe no error.

Allow the test to pass on both non-CRC and CRC enabled filesystems
by detecting the type of filesystem configuration and using that
information to fake the error message so that the golden output
match does not fail. We also need to filter the 26th ACL from the
output otherwise that will cause failures, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/shared/051 | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tests/shared/051 b/tests/shared/051
index e957f86..1d4edfb 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -319,6 +319,14 @@ chacl a::rwx file1
 set +x
 
 #-------------------------------------------------------
+#
+# On CRC enabled filesystems, we can support many more than 25 ACLs, and
+# so we have to detect this case and "fake" the error if CRCs are enabled.
+if [ $FSTYP = "xfs" ]; then
+	xfs_info $TEST_DIR | _filter_mkfs >/dev/null 2> $tmp.info
+	cat $tmp.info >> $seqres.full
+	. $tmp.info
+fi
 
 echo ""
 echo "=== Test out large ACLs  ==="
@@ -343,7 +351,14 @@ getfacl --numeric largeaclfile | _filter_aces
 
 echo "1 above xfs acl max"
 chacl $acl3 largeaclfile
-getfacl --numeric largeaclfile | _filter_aces
+if [ $_fs_has_crcs = "1" ]; then
+	# fake the error message for CRC enabled filesystems. It should succeed,
+	# so if there was any error from the above command we are going to fail
+	# regardless of whether we emit this or not.
+	echo "chacl: cannot set access acl on \"largeaclfile\": Invalid argument"
+fi
+# and filter the extra ACL we might have added.
+getfacl --numeric largeaclfile | _filter_aces | sed -e "/^user:22:rwx/d"
 
 echo "use 16 aces"
 chacl $acl4 largeaclfile
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

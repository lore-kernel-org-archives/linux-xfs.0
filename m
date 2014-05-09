Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2ED1A7F3F
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 14:44:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA50CAC002
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 12:44:36 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id oqlcFmdPAHKgURXz
	for <xfs@oss.sgi.com>; Fri, 09 May 2014 12:44:32 -0700 (PDT)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: filter out selinux xattrs for generic/062
Date: Fri, 9 May 2014 15:44:28 -0400
Message-ID: <1399664668-719-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

If you have selinux enabled getfattr will show the selinux xattrs, which screws
with the golden output of generic/062.  To make matters worse you can't just
greap it out because we'll still get the preamble and newline from getfattr when
the selinux attr is the only attr.  So this is the voodoo I came up with after
way more time than I'm comfortable admitting to make this test pass if you have
selinux enabled.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/filter     | 6 ++++++
 tests/generic/062 | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index 05dbae6..16a01ed 100644
--- a/common/filter
+++ b/common/filter
@@ -323,5 +323,11 @@ _filter_ro_mount() {
 	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
 }
 
+# Filter out selinux xattrs from getfattr, and if selinux is the only xattr in
+# the file simply pretend like there were no xattrs
+_filter_selinux_xattr() {
+	grep -v selinux | sed -e "N; s/^\# file: .*\n$//; /^$/d"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/062 b/tests/generic/062
index 047c930..32f0bca 100755
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -47,7 +47,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 getfattr()
 {
-    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
+    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch | \
+	_filter_selinux_xattr
 }
 
 setfattr()
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

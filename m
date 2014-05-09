Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33A107F3F
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 15:40:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08265304062
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 13:40:32 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id gQ0GVTSBFD2s5UqF
	for <xfs@oss.sgi.com>; Fri, 09 May 2014 13:40:31 -0700 (PDT)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: fix selinux context handling
Date: Fri, 9 May 2014 16:40:27 -0400
Message-ID: <1399668027-12912-1-git-send-email-jbacik@fb.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com

With the new config stuff we lost the selinux options being set for systems with
selinux turned on.  We want the selinux context set all the time, wether we
provide a MOUNT_OPTIONS value or not, so take this logic out of _mount_opts()
and just put it in the body of common/config

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/config | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/common/config b/common/config
index e8bcf48..a2f55cf 100644
--- a/common/config
+++ b/common/config
@@ -217,16 +217,16 @@ case "$HOSTOS" in
         ;;
 esac
 
+# SELinux adds extra xattrs which can mess up our expected output.
+# So, mount with a context, and they won't be created
+# # nfs_t is a "liberal" context so we can use it.
+if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+	export SELINUX_MOUNT_OPTIONS
+fi
+
 _mount_opts()
 {
-	# SELinux adds extra xattrs which can mess up our expected output.
-	# So, mount with a context, and they won't be created
-	# # nfs_t is a "liberal" context so we can use it.
-	if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
-		SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
-		export SELINUX_MOUNT_OPTIONS
-	fi
-
 	case $FSTYP in
 	xfs)
 		export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

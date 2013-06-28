Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72F4A7F52
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:11:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 549328F804C
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:11:14 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id s31aqyy4uWW8ou7t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 08:11:13 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:11:07 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 1/6] create wrappers for converting kuid_t to/from uid_t
Message-ID: <20130628111107.51e3aa88@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_linux.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 800f896..761e4c0 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -159,6 +159,32 @@
 #define MAX(a,b)	(max(a,b))
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
+/* Kernel uid/gid conversion. These are used to convert to/from the on disk
+ * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
+ * The conversion here is type only, the value will remain the same since we
+ * are converting to the init_user_ns. The uid is later mapped to a particular
+ * user namespace value when crossing the kernel/user boundary.
+ */
+static inline __uint32_t xfs_kuid_to_uid(kuid_t uid)
+{
+	return from_kuid(&init_user_ns, uid);
+}
+
+static inline kuid_t xfs_uid_to_kuid(__uint32_t uid)
+{
+	return make_kuid(&init_user_ns, uid);
+}
+
+static inline __uint32_t xfs_kgid_to_gid(kgid_t gid)
+{
+	return from_kgid(&init_user_ns, gid);
+}
+
+static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
+{
+	return make_kgid(&init_user_ns, gid);
+}
+
 /*
  * Various platform dependent calls that don't fit anywhere else
  */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

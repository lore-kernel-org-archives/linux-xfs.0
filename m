Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A0FB7F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AE288F8037
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:49:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id DlWzxEjaocn7Rp9I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 08:49:12 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6PFnB4k006545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:11 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFn9pZ012490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:11 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFn9ZL012480 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:09 GMT
Date: Thu, 25 Jul 2013 11:49:21 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v6 1/7] xfs: create wrappers for converting kuid_t to/from
	uid_t
Message-ID: <20130725114921.0d860cc4@oracle.com>
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
To: xfs@oss.sgi.com

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

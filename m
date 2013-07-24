Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 978307F60
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 23:52:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7587F304064
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:52:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UmevRJItzL0fOsxo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 21:52:18 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6O4qGWu006817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:17 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6O4qGVv026510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:16 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6O4qF6M026500 for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:16 GMT
Date: Wed, 24 Jul 2013 00:52:30 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v5 1/7] xfs: create wrappers for converting kuid_t to/from
	uid_t
Message-ID: <20130724005230.3ec37624@oracle.com>
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

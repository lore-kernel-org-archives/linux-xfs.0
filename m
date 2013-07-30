Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1F807F6B
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 22:07:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C296A304067
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:07:20 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id VpDXmKKgzh2Akthq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 20:07:19 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6U37Jog011996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:19 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6U37IZx015645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:18 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6U37IE6017652 for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:18 GMT
Date: Mon, 29 Jul 2013 23:07:09 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130729230709.11033b2d@oracle.com>
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

>From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17 00:00:00 2001
From: Dwight Engen <dwight.engen@oracle.com>
Date: Tue, 2 Jul 2013 09:52:54 -0400
Subject: [PATCH 7/7] enable building user namespace with xfs

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 init/Kconfig | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..a7bcd87 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1106,7 +1106,6 @@ config IPC_NS
 
 config USER_NS
 	bool "User namespace"
-	depends on UIDGID_CONVERTED
 	select UIDGID_STRICT_TYPE_CHECKS
 
 	default n
@@ -1140,20 +1139,8 @@ config NET_NS
 
 endif # NAMESPACES
 
-config UIDGID_CONVERTED
-	# True if all of the selected software conmponents are known
-	# to have uid_t and gid_t converted to kuid_t and kgid_t
-	# where appropriate and are otherwise safe to use with
-	# the user namespace.
-	bool
-	default y
-
-	# Filesystems
-	depends on XFS_FS = n
-
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
-	depends on UIDGID_CONVERTED
 	default n
 	help
 	 While the nececessary conversions are being added to all subsystems this option allows
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

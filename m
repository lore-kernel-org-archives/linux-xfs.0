Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 972E27F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:49:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26631AC002
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:49:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GxoJGfiBco4bVDhG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 08:49:43 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6PFng73007277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:43 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFne3q017761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:42 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFnd3f020503 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:39 GMT
Date: Thu, 25 Jul 2013 11:49:51 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v6 7/7] enable building user namespace with xfs
Message-ID: <20130725114951.55dac4c0@oracle.com>
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
 init/Kconfig | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..a380f12 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1106,7 +1106,6 @@ config IPC_NS
 
 config USER_NS
 	bool "User namespace"
-	depends on UIDGID_CONVERTED
 	select UIDGID_STRICT_TYPE_CHECKS
 
 	default n
@@ -1140,21 +1139,9 @@ config NET_NS
 
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
-	default n
+	default y
 	help
 	 While the nececessary conversions are being added to all subsystems this option allows
 	 the code to continue to build for unconverted subsystems.
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B2687F76
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:08:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C071304070
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:08:25 -0700 (PDT)
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 7/7] enable building user namespace with xfs
Date: Thu, 15 Aug 2013 14:08:04 -0400
Message-Id: <1376590084-12888-8-git-send-email-dwight.engen@oracle.com>
In-Reply-To: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
References: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
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

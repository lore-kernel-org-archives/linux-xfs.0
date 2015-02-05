Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEB8F8021
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 10:44:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9E908F804B
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:44:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I6BKTPpxAXDddzzZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 08:44:55 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t15GirNO019923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 11:44:54 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t15Gioup016699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 11:44:52 -0500
Message-ID: <54D39E01.3000108@redhat.com>
Date: Thu, 05 Feb 2015 10:44:49 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: fix panic_mask documentation
References: <54D0F858.5010804@redhat.com>
In-Reply-To: <54D0F858.5010804@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

This bit of the docs didn't quite reflect reality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: s/AND/OR/

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 5be51fd..2e56845 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -287,9 +287,9 @@ The following sysctls are available for the XFS filesystem:
 		XFS_ERRLEVEL_LOW:       1
 		XFS_ERRLEVEL_HIGH:      5
 
-  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 127)
+  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 255)
 	Causes certain error conditions to call BUG(). Value is a bitmask;
-	AND together the tags which represent errors which should cause panics:
+	OR together the tags which represent errors which should cause panics:
 
 		XFS_NO_PTAG                     0
 		XFS_PTAG_IFLUSH                 0x00000001
@@ -299,6 +299,7 @@ The following sysctls are available for the XFS filesystem:
 		XFS_PTAG_SHUTDOWN_CORRUPT       0x00000010
 		XFS_PTAG_SHUTDOWN_IOERROR       0x00000020
 		XFS_PTAG_SHUTDOWN_LOGERROR      0x00000040
+		XFS_PTAG_FSBLOCK_ZERO           0x00000080
 
 	This option is intended for debugging only.
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

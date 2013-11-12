Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89BA27F50
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 10:31:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 705AB304043
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 08:31:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5YmCZKoyAuaL1fbq for
	<xfs@oss.sgi.com>; Tue, 12 Nov 2013 08:31:15 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rACGVE3X007654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:31:14 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rACGVCCT015725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:31:14 -0500
Message-ID: <528257D0.7050404@redhat.com>
Date: Tue, 12 Nov 2013 10:31:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove xfs_check references from fsck.xfs script
	& manpage
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

xfs_check is deprecated & slated for removal in June 2014.

We can stop referring to it now, though - pointing fsck.xfs
users to it doesn't make sense at this point.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index c5a96e6..e52969e 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -19,6 +19,6 @@ if $AUTO; then
 	echo "$0: XFS file system."
 else
 	echo "If you wish to check the consistency of an XFS filesystem or"
-	echo "repair a damaged filesystem, see xfs_check(8) and xfs_repair(8)."
+	echo "repair a damaged filesystem, see xfs_repair(8)."
 fi
 exit 0
diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
index b890ad1..ace7252 100644
--- a/man/man8/fsck.xfs.8
+++ b/man/man8/fsck.xfs.8
@@ -20,8 +20,6 @@ simply exits with a zero exit status.
 If you wish to check the consistency of an XFS filesystem,
 or repair a damaged or corrupt XFS filesystem,
 see
-.BR xfs_check (8)
-and
 .BR xfs_repair (8).
 .
 .SH FILES
@@ -30,5 +28,4 @@ and
 .BR fsck (8),
 .BR fstab (5),
 .BR xfs (5),
-.BR xfs_check (8),
 .BR xfs_repair (8).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

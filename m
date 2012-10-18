Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFRQ2S198009 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:27:26 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GPM9KQPqbKCq7ujD for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 08:29:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9IFT4eX024629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 11:29:04 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-113.phx2.redhat.com
	[10.3.113.113])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9IFT3UW013511
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 11:29:04 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Update mount options documentation
Date: Thu, 18 Oct 2012 12:28:58 -0300
Message-Id: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Once inode64 is the default allocation mode now, kernel documentation should be
updated to match this behaviour.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 Documentation/filesystems/xfs.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3fc0c31..1718775 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -72,8 +72,15 @@ When mounting an XFS filesystem, the following options are accepted.
 	Indicates that XFS is allowed to create inodes at any location
 	in the filesystem, including those which will result in inode
 	numbers occupying more than 32 bits of significance.  This is
-	provided for backwards compatibility, but causes problems for
-	backup applications that cannot handle large inode numbers.
+	the default allocation option. Applications which do not handle
+	inode numbers bigger than 32 bits, should use inode32 option.
+
+  inode32
+	Indicates that XFS is limited to create inodes at locations which
+	will not result in inode numbers with more than 32 bits of
+	significance. This is provided for backwards compatibility, since
+	64 bits inode numbers might cause problems for some applications
+	that cannot handle large inode numbers.
 
   largeio/nolargeio
 	If "nolargeio" is specified, the optimal I/O reported in
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

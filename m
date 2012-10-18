Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFf8gD198543 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:41:08 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xP0z0njsdF4t3pwl for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 08:42:47 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9IFghap031263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 11:42:46 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-113.phx2.redhat.com
	[10.3.113.113])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q9IFggte012078
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 11:42:42 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] mkfs: update manpage to match current inode allocation
	behaviour
Date: Thu, 18 Oct 2012 12:42:37 -0300
Message-Id: <1350574957-1044-1-git-send-email-cmaiolino@redhat.com>
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

Once inode64 is the default allocator, mkfs man page needs to be updated to
match the current behaviour.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index fa52152..c33cfb2 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -309,16 +309,17 @@ can be allocated to inodes. The default
 is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
 for filesystems over 50TB.
 .IP
-In the default inode allocation mode, inode blocks are chosen such
+In the inode32 inode allocation mode, inode blocks are chosen such
 that inode numbers will not exceed 32 bits, which restricts the inode
 blocks to the lower portion of the filesystem. The data block
 allocator will avoid these low blocks to accommodate the specified
 maxpct, so a high value may result in a filesystem with nothing but
 inodes in a significant portion of the lower blocks of the filesystem.
-(This restriction is not present when the filesystem is mounted with
+(This restriction is not present in the default inode allocation mode,
+i.e. when the filesystem is mounted with
 the
 .I "inode64"
-option on 64-bit platforms).
+option).
 .IP
 Setting the value to 0 means that essentially all of the filesystem
 can become inode blocks, subject to inode32 restrictions.
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E61827F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 14:10:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D40A6304066
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 12:10:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 38dcYETVbteOJYpf for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 12:09:58 -0700 (PDT)
Message-ID: <52584D04.3020907@sandeen.net>
Date: Fri, 11 Oct 2013 14:09:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs: remove newlines from 3 xfs_alert_tag error strings
References: <52584C8A.1060808@redhat.com>
In-Reply-To: <52584C8A.1060808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

xfs_alert_tag passes the format string to __xfs_printk,
which adds its own "\n".  Having it in the original string
leads to unintentional blank lines from these messages.

Most format strings have no newline, but these 3 do, leading to
i.e.:

[ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
[ 7347.119911] 
[ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
[ 7347.119919] 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index f47e65c..e6b4202 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1482,7 +1482,7 @@ xfs_bmap_search_extents(
 		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 				"Access to block zero in inode %llu "
 				"start_block: %llx start_off: %llx "
-				"blkcnt: %llx extent-state: %x lastx: %x\n",
+				"blkcnt: %llx extent-state: %x lastx: %x",
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)gotp->br_startblock,
 			(unsigned long long)gotp->br_startoff,
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 1123d93..40f2985 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -159,7 +159,7 @@ xfs_error_report(
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
-		"Internal error %s at line %d of file %s.  Caller 0x%p\n",
+		"Internal error %s at line %d of file %s.  Caller 0x%p",
 			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8d4d49b..43e31b0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -110,7 +110,7 @@ xfs_alert_fsblock_zero(
 	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 			"Access to block zero in inode %llu "
 			"start_block: %llx start_off: %llx "
-			"blkcnt: %llx extent-state: %x\n",
+			"blkcnt: %llx extent-state: %x",
 		(unsigned long long)ip->i_ino,
 		(unsigned long long)imap->br_startblock,
 		(unsigned long long)imap->br_startoff,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

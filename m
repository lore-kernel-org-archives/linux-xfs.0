Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE2F77F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 15:04:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E46E3304039
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 13:04:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Il27zWDt221gmYRq for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 13:04:23 -0700 (PDT)
Message-ID: <5398B649.6020600@sandeen.net>
Date: Wed, 11 Jun 2014 15:04:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: indicate default mount options in xfs.5 manpage
References: <5398B5ED.6030703@redhat.com>
In-Reply-To: <5398B5ED.6030703@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Karel Zak <kzak@redhat.com>

Not every pair of mount options indicated which was the
default, so add those.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 1729e38..528d99c 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -137,6 +137,8 @@ Enables/disables the use of block layer write barriers for
 writes into the journal and for data integrity operations.
 This allows for drive level write caching to be enabled, for
 devices that support write barriers.
+.sp
+Barriers are enabled by default.
 .TP
 .BR discard | nodiscard
 Enable/disable the issuing of commands to let the block
@@ -147,7 +149,7 @@ machine images, but may have a performance impact.
 Note: It is currently recommended that you use the fstrim
 application to discard unused blocks rather than the discard
 mount option because the performance impact of this option
-is quite severe.
+is quite severe.  For this reason, nodiscard is the default.
 .TP
 .BR grpid | bsdgroups | nogrpid | sysvgroups
 These options define what group ID a newly created file
@@ -167,7 +169,7 @@ configured to use it.
 When ikeep is specified, XFS does not delete empty inode
 clusters and keeps them around on disk.  When noikeep is
 specified, empty inode clusters are returned to the free
-space pool.
+space pool.  noikeep is the default.
 .TP
 .BR inode32 | inode64
 When inode32 is specified, it indicates that XFS limits
@@ -185,6 +187,8 @@ cause problems for some applications that cannot handle
 large inode numbers.  If applications are in use which do
 not handle inode numbers bigger than 32 bits, the inode32
 option should be specified.
+.sp
+For kernel v3.7 and later, inode64 is the default.
 .TP
 .BR  largeio | nolargeio
 If "nolargeio" is specified, the optimal I/O reported in
@@ -198,7 +202,8 @@ If "largeio" specified, a filesystem that was created with a
 in st_blksize. If the filesystem does not have a "swidth"
 specified but does specify an "allocsize" then "allocsize"
 (in bytes) will be returned instead. Otherwise the behavior
-is the same as if "nolargeio" was specified.
+is the same as if "nolargeio" was specified.  nolargeio
+is the default.
 .TP
 .B logbufs=value
 Set the number of in-memory log buffers.  Valid numbers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

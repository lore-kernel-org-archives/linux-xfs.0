Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 247007F54
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 16:13:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB9A630405F
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 14:13:29 -0800 (PST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id 2QRsDSQ0a9v9fi2G
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Jan 2016 14:13:27 -0800 (PST)
Received: by mail-wm0-f42.google.com with SMTP id l65so171727824wmf.1
	for <xfs@oss.sgi.com>; Sat, 09 Jan 2016 14:13:27 -0800 (PST)
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Fix typos
Date: Sat,  9 Jan 2016 23:13:16 +0100
Message-Id: <1452377596-4379-1-git-send-email-andrea.gelmini@gelma.net>
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
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, darrick.wong@oracle.com

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc    | 8 ++++----
 admin/XFS_Performance_Tuning/xfs_performance_tuning.asciidoc | 4 ++--
 design/XFS_Filesystem_Structure/magic.asciidoc               | 2 +-
 design/xfs-self-describing-metadata.asciidoc                 | 2 +-
 design/xfs-smr-structure.asciidoc                            | 8 ++++----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
index c12981b..30f39bf 100644
--- a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
+++ b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
@@ -35,7 +35,7 @@ units as used on the +mkfs.xfs+ command line to configure these parameters.
 The performance examples given in this section are highly dependent on storage,
 CPU and RAM configuration. They are intended as guidelines to illustrate
 behavioural differences, not the exact performance any configuration will
-acheive.
+achieve.
 =====
 
 === Directory block size
@@ -238,7 +238,7 @@ available for storing attributes.
 When attributes are stored in the literal area of the inode, both attribute
 names and attribute values are limited to a maximum size of 254 bytes. If either
 name or value exceeds 254 bytes in length, or the total space used by the
-atributes exceeds the size of the literal area, the entire set of attributes
+attributes exceeds the size of the literal area, the entire set of attributes
 stored on the inode are pushed to a separate attribute block instead of being
 stored inline.
 
@@ -280,7 +280,7 @@ Therefore, the size of the log determines the concurrency of metadata
 modification operations the filesystem can sustain, as well as how much and how
 frequently metadata writeback occurs.  A smaller log forces data
 write-back more frequently than a larger log, but can result in lower
-synchronisation overhead as there will be fewer changes aggreagted in memory
+synchronisation overhead as there will be fewer changes aggregated in memory
 between synchronisation triggers. Memory pressure also generates synchronisatin
 triggers, so large logs may not benefit systems with limited memory.
 
@@ -364,7 +364,7 @@ between 32KB and 256KB. It can be configured by use of the +logbsize+ mount
 option.
 
 The number of log buffers can also be configured to between 2 and 8. The default
-is 8 log buffersi and can be configured by the use of the +logbufs+ mount
+is 8 log buffers can be configured by the use of the +logbufs+ mount
 option. It is rare that this needs to be configured, and it should only be
 considered if there is limited memory and lots of XFS filesystems such that the
 memory allocated to the log buffers would consume a significant amount of
diff --git a/admin/XFS_Performance_Tuning/xfs_performance_tuning.asciidoc b/admin/XFS_Performance_Tuning/xfs_performance_tuning.asciidoc
index 0310bbd..b249e35 100644
--- a/admin/XFS_Performance_Tuning/xfs_performance_tuning.asciidoc
+++ b/admin/XFS_Performance_Tuning/xfs_performance_tuning.asciidoc
@@ -42,8 +42,8 @@ xref:Knowledge[Knowledge Section].
 
 The xref:Process[Process section] will cover the typical processes used to
 optimise a filesystem for a given workload. If the workload measurements are not
-accurate or reproducable, then no conclusions can be drawn as to whether a
-configuration changes an improvemnt or not. Hence without a robust testing
+accurate or reproducible, then no conclusions can be drawn as to whether a
+configuration changes an improvement or not. Hence without a robust testing
 process, no amount of knowledge or observation will result in a well optimised
 filesystem configuration.
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 301cfa0..35d9c2b 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -82,5 +82,5 @@ XFS can create really big filesystems!
 | Max Dir Size          | 32GiB | 32GiB | 32GiB
 |=====
 
-Linux doesn't suppport files or devices larger than 8EiB, so the block
+Linux doesn't support files or devices larger than 8EiB, so the block
 limitations are largely ignorable.
diff --git a/design/xfs-self-describing-metadata.asciidoc b/design/xfs-self-describing-metadata.asciidoc
index b7dc3ff..d108f7a 100644
--- a/design/xfs-self-describing-metadata.asciidoc
+++ b/design/xfs-self-describing-metadata.asciidoc
@@ -5,7 +5,7 @@ v1.0, Feb 2014: Initial conversion to asciidoc
 == Introduction
 
 The largest scalability problem facing XFS is not one of algorithmic
-scalability, but of verification of the filesystem structure. Scalabilty of the
+scalability, but of verification of the filesystem structure. Scalability of the
 structures and indexes on disk and the algorithms for iterating them are
 adequate for supporting PB scale filesystems with billions of inodes, however it
 is this very scalability that causes the verification problem.
diff --git a/design/xfs-smr-structure.asciidoc b/design/xfs-smr-structure.asciidoc
index dd959ab..3e6c4ec 100644
--- a/design/xfs-smr-structure.asciidoc
+++ b/design/xfs-smr-structure.asciidoc
@@ -142,7 +142,7 @@ Hence we don't actually need any major new data moving functionality in the
 kernel to enable this, except maybe an event channel for the kernel to tell
 xfs_fsr it needs to do some cleaning work.
 
-If we arrange zones into zoen groups, we also have a method for keeping new
+If we arrange zones into zone groups, we also have a method for keeping new
 allocations out of regions we are re-organising. That is, we need to be able to
 mark zone groups as "read only" so the kernel will not attempt to allocate from
 them while the cleaner is running and re-organising the data within the zones in
@@ -173,7 +173,7 @@ it will need ot be packaged by distros.
 
 If mkfs cannot find ensough random write space for the amount of metadata we
 need to track all the space in the sequential write zones and a decent amount of
-internal fielsystem metadata (inodes, etc) then it will need to fail. Drive
+internal filesystem metadata (inodes, etc) then it will need to fail. Drive
 vendors are going to need to provide sufficient space in these regions for us
 to be able to make use of it, otherwise we'll simply not be able to do what we
 need to do.
@@ -193,7 +193,7 @@ bitmaps for verifying used space should already be there.
 THere be dragons waiting for us if we don't have random write zones for
 metadata. If that happens, we cannot repair metadata in place and we will have
 to redesign xfs_repair from the ground up to support such functionality. That's
-jus tnot going to happen, so we'll need drives with a significant amount of
+just not going to happen, so we'll need drives with a significant amount of
 random write space for all our metadata......
 
 == Quantification of Random Write Zone Capacity
@@ -316,7 +316,7 @@ spiral.
 I suspect the best we will be able to do with fallocate based preallocation is
 to mark the region as delayed allocation.
 
-=== Allocation Alignemnt
+=== Allocation Alignment
 
 With zone based write pointers, we lose all capability of write alignment to the
 underlying storage - our only choice to write is the current set of write
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

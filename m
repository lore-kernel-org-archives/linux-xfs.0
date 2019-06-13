Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41724 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbfFMVFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 17:05:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so234887wrm.8
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:05:04 -0700 (PDT)
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Fix typos in xfs-documentation
Date: Thu, 13 Jun 2019 23:04:59 +0200
Message-Id: <20190613210459.52794-1-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>

---
 .../filesystem_tunables.asciidoc                   |  6 +++---
 .../xfs_performance_tuning.asciidoc                |  4 ++--
 .../extended_attributes.asciidoc                   |  2 +-
 .../journaling_log.asciidoc                        |  2 +-
 design/XFS_Filesystem_Structure/magic.asciidoc     |  2 +-
 .../XFS_Filesystem_Structure/refcountbt.asciidoc   |  2 +-
 design/xfs-smr-structure.asciidoc                  | 14 +++++++-------
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
index c12981b..c570406 100644
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
 
@@ -359,7 +359,7 @@ than the maximum, and hence there is no need to reduce the log buffer size for
 fsync heavy workloads.
 
 The default size of the log buffer is 32KB. The maximum size is 256KB and other
-supported sizes are 64KB, 128KB or power of 2 mulitples of the log stripe unit
+supported sizes are 64KB, 128KB or power of 2 multiples of the log stripe unit
 between 32KB and 256KB. It can be configured by use of the +logbsize+ mount
 option.
 
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
 
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 7df2d3d..99f7b35 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -460,7 +460,7 @@ size of these entries is determined dynamically.
 A variable-length array of descriptors of remote attributes.  The location and
 size of these entries is determined dynamically.
 
-On a v5 filesystem, the header becomes +xfs_da3_blkinfo_t+ to accomodate the
+On a v5 filesystem, the header becomes +xfs_da3_blkinfo_t+ to accommodate the
 extra metadata integrity fields:
 
 [source, c]
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 6109458..8421a53 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -810,7 +810,7 @@ missing the +ilf_pad+ field and is 52 bytes long as opposed to 56 bytes.
 This region contains the new contents of a part of an inode, as described in
 the xref:Inode_Log_Item[previous section].  There are no magic numbers.
 
-If +XFS_ILOG_CORE+ is set in +ilf_fields+, the correpsonding data buffer must
+If +XFS_ILOG_CORE+ is set in +ilf_fields+, the corresponding data buffer must
 be in the format +struct xfs_icdinode+, which has the same format as the first
 96 bytes of an xref:On-disk_Inode[inode], but is recorded in host byte order.
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 7e62783..9be26f8 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -92,5 +92,5 @@ XFS can create really big filesystems!
 | Max Dir Size          | 32GiB | 32GiB | 32GiB
 |=====
 
-Linux doesn't suppport files or devices larger than 8EiB, so the block
+Linux doesn't support files or devices larger than 8EiB, so the block
 limitations are largely ignorable.
diff --git a/design/XFS_Filesystem_Structure/refcountbt.asciidoc b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
index 508a9dd..ea8f779 100644
--- a/design/XFS_Filesystem_Structure/refcountbt.asciidoc
+++ b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
@@ -6,7 +6,7 @@ This data structure is under construction!  Details may change.
 
 To support the sharing of file data blocks (reflink), each allocation group has
 its own reference count B+tree, which grows in the allocated space like the
-inode B+trees.  This data could be gleaned by performing an interval query of
+inode B+trees.  This data could be cleaned by performing an interval query of
 the reverse-mapping B+tree, but doing so would come at a huge performance
 penalty.  Therefore, this data structure is a cache of computable information.
 
diff --git a/design/xfs-smr-structure.asciidoc b/design/xfs-smr-structure.asciidoc
index dd959ab..b970224 100644
--- a/design/xfs-smr-structure.asciidoc
+++ b/design/xfs-smr-structure.asciidoc
@@ -67,7 +67,7 @@ next to the metadata zone, but typically metadata writes are not correlated with
 log writes.
 
 Hence the only real functionality we need to add to the log is the tail pushing
-modificaitons to move the tail into the same zone as the head, as well as being
+modifications to move the tail into the same zone as the head, as well as being
 able to trigger and block on zone write pointer reset operations.
 
 The log doesn't actually need to track the zone write pointer, though log
@@ -90,7 +90,7 @@ packed extent allocation only) to ensure that newly written blocks are allocated
 in a sane manner.
 
 We're going to need userspace to be able to see the contents of these inodes;
-read only access wil be needed to analyse the contents of the zone, so we're
+read only access will be needed to analyse the contents of the zone, so we're
 going to need a special directory to expose this information. It would be useful
 to have a ".zones" directory hanging off the root directory that contains all
 the zone allocation inodes so userspace can simply open them.
@@ -112,14 +112,14 @@ also have other benefits...
 While it seems like tracking free space is trivial for the purposes of
 allocation (and it is!), the complexity comes when we start to delete or
 overwrite data. Suddenly zones no longer contain contiguous ranges of valid
-data; they have "freed" extents in the middle of them that contian stale data.
+data; they have "freed" extents in the middle of them that contain stale data.
 We can't use that "stale space" until the entire zone is made up of "stale"
 extents. Hence we need a Cleaner.
 
 === Zone Cleaner
 
 The purpose of the cleaner is to find zones that are mostly stale space and
-consolidate the remaining referenced data into a new, contigious zone, enabling
+consolidate the remaining referenced data into a new, contiguous zone, enabling
 us to then "clean" the stale zone and make it available for writing new data
 again.
 
@@ -129,7 +129,7 @@ parent pointer functionality. This gives us the mechanism by which we can
 quickly re-organise files that have extents in zones that need cleaning.
 
 The key word here is "reorganise". We have a tool that already reorganises file
-layout: xfs_fsr. The "Cleaner" is a finely targetted policy for xfs_fsr -
+layout: xfs_fsr. The "Cleaner" is a finely targeted policy for xfs_fsr -
 instead of trying to minimise fixpel fragments, it finds zones that need
 cleaning by reading their summary info from the /.zones/ directory and analysing
 the free bitmap state if there is a high enough percentage of stale blocks. From
@@ -200,7 +200,7 @@ random write space for all our metadata......
 
 A basic guideline is that for 4k blocks and zones of 256MB, we'll need 8kB of
 bitmap space and two inodes, so call it 10kB per 256MB zone. That's 40MB per TB
-for free space bitmaps. We'll want to suport at least 1 million inodes per TB,
+for free space bitmaps. We'll want to support at least 1 million inodes per TB,
 so that's another 512MB per TB, plus another 256MB per TB for directory
 structures. There's other bits and pieces of metadata as well (attribute space,
 internal freespace btrees, reverse map btrees, etc.
@@ -316,7 +316,7 @@ spiral.
 I suspect the best we will be able to do with fallocate based preallocation is
 to mark the region as delayed allocation.
 
-=== Allocation Alignemnt
+=== Allocation Alignment
 
 With zone based write pointers, we lose all capability of write alignment to the
 underlying storage - our only choice to write is the current set of write
-- 
2.22.0.4.ge77e5b94d2

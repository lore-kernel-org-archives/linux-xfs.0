Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I59n18151029 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 00:09:49 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TGPwSvajHXSRXxSG for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 22:11:26 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] fiemap: add freespace mapping to FS_IOC_FIEMAP
Date: Thu, 18 Oct 2012 16:11:18 +1100
Message-Id: <1350537079-16246-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1350537079-16246-1-git-send-email-david@fromorbit.com>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

fiemap is used to map extents of used space on files. it's just an
array of extents, though, so there's no reason it can only index
*used* space.

Ther eis need for getting freespace layout information into
userspace. For example, defragmentation programs would find it
useful to be able to map the free space in the filesystem to
work out where it is best to move data to defragment it.
Alternatively, knowing where free space is enables us to identify
extents that need to be moved to defragment free space.

Hence, extend fiemap with the FIEMAP_FLAG_FREESPACE to indicate that
the caller wants to map free space in the range fm_start bytes from
the start of the filesystem for fm_length bytes.

Because XFS can report extents in size order without needing to
sort, and this information is useful to xfs_fsr, also add
FIEMAP_FLAG_FREESPACE_SIZE to tell the filesystem to return a
freespace map ordered by extent size rather than offset. If there
are multiple extents of the same size, then they are ordered by
offset.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/fiemap.txt |   37 +++++++++++++++++++++++++++++++---
 include/linux/fiemap.h               |    6 +++++-
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index 1b805a0..45531ba 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -2,9 +2,9 @@
 Fiemap Ioctl
 ============
 
-The fiemap ioctl is an efficient method for userspace to get file
-extent mappings. Instead of block-by-block mapping (such as bmap), fiemap
-returns a list of extents.
+The fiemap ioctl is an efficient method for userspace to get file or
+filesystem extent mappings. Instead of block-by-block mapping (such as
+bmap), fiemap returns a list of extents.
 
 
 Request Basics
@@ -58,6 +58,37 @@ If this flag is set, the kernel will sync the file before mapping extents.
 If this flag is set, the extents returned will describe the inodes
 extended attribute lookup tree, instead of its data tree.
 
+* FIEMAP_FLAG_FREESPACE
+If this flag is set, the extents returned will describe the
+*filesystem's* free space map, with fm_start specifying the start offset
+into the filesystems address range (in bytes) of the region to be
+mapped. fm_length is the the byte range that will be mapped. Free space
+extents will be mapped in ascending offset order.
+
+Filesystems with multiple freespace indexes may return
+FIEMAP_EXTENT_LAST at the end of a specific freespace index map. Hence
+FIEMAP_EXTENT_LAST does not mean there is no more free space to be
+mapped, just that the requested range spanned multiple free space
+indexes.
+
+Hence the caller needs to be aware of the underlying filesystem
+implementation and geometry to make correct use of this call. As such,
+this functionality is only intended for use by filesystem management
+utilities (e.g. defragmentation tools) and not general purpose
+applications.
+
+* FIEMAP_FLAG_FREESPACE_SIZE
+If this flag is set, the filesystem freespace tree will be mapped
+similar to FIEMAP_FLAG_FREESPACE, but extents will be ordered from
+smallest free space extent to largest Where extents have the same size,
+they will be ordered by ascending offset order similar to
+FIEMAP_FLAG_FREESPACE. It is up to the application to track the highest
+offset extent seen by this walk so that if it doesn't see a
+FIEMAP_EXTENT_LAST flag, the application knows what offset to start the
+next mapping from.
+
+The same caveats exist for this call for FIEMAP_EXTENT_LAST as for
+FIEMAP_FLAG_FREESPACE.
 
 Extent Mapping
 --------------
diff --git a/include/linux/fiemap.h b/include/linux/fiemap.h
index d830747..f4fbb9f 100644
--- a/include/linux/fiemap.h
+++ b/include/linux/fiemap.h
@@ -40,8 +40,12 @@ struct fiemap {
 
 #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
 #define FIEMAP_FLAG_XATTR	0x00000002 /* map extended attribute tree */
+#define FIEMAP_FLAG_FREESPACE	0x00000004 /* map fs freespace tree */
+#define FIEMAP_FLAG_FREESPACE_SIZE 0x00000008 /* map freespace in size order */
 
-#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR | \
+				 FIEMAP_FLAG_FREESPACE | \
+				 FIEMAP_FLAG_FREESPACE_SIZE)
 
 #define FIEMAP_EXTENT_LAST		0x00000001 /* Last extent in file. */
 #define FIEMAP_EXTENT_UNKNOWN		0x00000002 /* Data location unknown. */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

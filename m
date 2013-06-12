Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FD9229DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 19:24:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2108C8F8035
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 17:24:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kUXlV4tD61COXP8X for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 17:23:59 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix implicit padding in directory and attr CRC formats
Date: Wed, 12 Jun 2013 10:23:57 +1000
Message-Id: <1370996637-32275-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, mlsemon35@gmail.com

From: Dave Chinner <dchinner@redhat.com>

Michael L. Semon has been testing CRC patches ona 32 bit system and
been seeing assert failures in the directory code from xfs/080.
Thanks to Michael's heroic efforts with printk debugging, we found
that the problem was that the last free space being left in the
directory structure was too small to fit a unused tag structure and
it was being corrupted and attempting to log a region out of bounds.
Hence the assert failure looked something like:

.....
#5 calling xfs_dir2_data_log_unused() 36 32
#1 4092 4095 4096
#2 8182 8183 4096
XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568

Where #1 showed the first region of the dup being logged (i.e. the
last 4 bytes of a directory buffer) and #2 shows the corrupt values
being calculated from the length of the dup entry which overflowed
the size of the buffer.

It turns out that the problem was not in the logging code, nor in
the freespace handling code. It is an initial condition bug that
only shows up on 32 bit systems. When a new buffer is initialised,
where's the freespace that is set up:

[  172.316249] calling xfs_dir2_leaf_addname() from xfs_dir_createname()
[  172.316346] #9 calling xfs_dir2_data_log_unused()
[  172.316351] #1 calling xfs_trans_log_buf() 60 63 4096
[  172.316353] #2 calling xfs_trans_log_buf() 4094 4095 4096

Note the offset of the first region being logged? It's 60 bytes into
the buffer. Once I saw that, I pretty much knew what the bug was
going to be caused by this.

Essentially, all direct entries are rounded to 8 bytes in length,
and all entries start with an 8 byte alignment. This means that we
can decode inplace as variables are naturally aligned. With the
directory data supposedly starting on a 8 byte boundary, and all
entries padded to 8 bytes, the minimum freespace in a directory
block is supposed to be 8 bytes, which is large enough to fit a
unused data entry structure (6 bytes in size). The fact we only have
4 bytes of free space indicates a directory data block alignment
problem.

And what do you know - there's an implicit hole in the directory
data block header for the CRC format, which means the header is 60
byte on 32 bit intel systems and 64 bytes on 64 bit systems. Needs
padding. And while looking at the structures, I found the same
problem in the attr leaf header. Fix them both.

Note that this only affects 32 bit systems with CRCs enabled.
Everything else is just fine. Note that filesystems created before
this fix on such systems will not be readable with this fix applied.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Debugged-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.h   |    1 +
 fs/xfs/xfs_dir2_format.h |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index f9d7846..444a770 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -128,6 +128,7 @@ struct xfs_attr3_leaf_hdr {
 	__u8			holes;
 	__u8			pad1;
 	struct xfs_attr_leaf_map freemap[XFS_ATTR_LEAF_MAPSIZE];
+	__be32			pad2;		/* 64 bit alignment */
 };
 
 #define XFS_ATTR3_LEAF_CRC_OFF	(offsetof(struct xfs_attr3_leaf_hdr, info.crc))
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index 995f1f5..7826782 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -266,6 +266,7 @@ struct xfs_dir3_blk_hdr {
 struct xfs_dir3_data_hdr {
 	struct xfs_dir3_blk_hdr	hdr;
 	xfs_dir2_data_free_t	best_free[XFS_DIR2_DATA_FD_COUNT];
+	__be32			pad;	/* 64 bit alignment */
 };
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
@@ -477,7 +478,7 @@ struct xfs_dir3_leaf_hdr {
 	struct xfs_da3_blkinfo	info;		/* header for da routines */
 	__be16			count;		/* count of entries */
 	__be16			stale;		/* count of stale entries */
-	__be32			pad;
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_icleaf_hdr {
@@ -715,7 +716,7 @@ struct xfs_dir3_free_hdr {
 	__be32			firstdb;	/* db of first entry */
 	__be32			nvalid;		/* count of valid entries */
 	__be32			nused;		/* count of used entries */
-	__be32			pad;		/* 64 bit alignment. */
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_free {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

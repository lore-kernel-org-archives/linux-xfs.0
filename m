Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EEF1E7F50
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 23:13:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD1E6304032
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 21:13:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oUrEAJUibbL8ioll for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 21:13:35 -0700 (PDT)
Date: Mon, 26 Aug 2013 14:13:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
Message-ID: <20130826041330.GU6023@dastard>
References: <52165830.8050006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52165830.8050006@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 22, 2013 at 02:28:00PM -0400, Brian Foster wrote:
> Hi all,
> 
> I hit an assert on a debug kernel while beating on some finobt work and
> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
> hit it through a couple different paths, first while running fsstress on
> a CRC enabled filesystem (with otherwise default mkfs options):
> 
> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
> hosted on a single spindle desktop box).
> 
> crc=1
> fsstress -z -fsymlink=1 -n99999999 -p4 -d /mnt/test
> 
> XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),

Directory buffer overrun.

>  [<ffffffffa031d549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>  [<ffffffffa02e7c1c>] xfs_da3_node_add+0x11c/0x210 [xfs]
>  [<ffffffffa02ea703>] xfs_da3_node_split+0xc3/0x230 [xfs]
>  [<ffffffffa02eaa18>] xfs_da3_split+0x1a8/0x410 [xfs]
>  [<ffffffffa02f743f>] xfs_dir2_node_addname+0x47f/0xde0 [xfs]

During a split.

Easily reproduced with "seq 200000 | xargs touch" as Michael Semon
reported last week.

The fix demonstrates my concerns about modifying directory code -
the CRC changes missed a *fundamental* directory format definition,
and we've only just tripped over it....

> rm -rf /mnt/test
> 
> XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),

Directory buffer overrun.

>  [<ffffffffa032b549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>  [<ffffffffa02f61ff>] xfs_da3_node_unbalance+0xef/0x1d0 [xfs]
>  [<ffffffffa02f98b0>] xfs_da3_join+0x240/0x290 [xfs]
>  [<ffffffffa030659b>] xfs_dir2_node_removename+0x69b/0x8b0 [xfs]

During a merge. Not sure why that is happening on a v4 filesystem.
V5 filesystem, yes, due to the above bug but v4 should not be
affected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix calculation of the number of node entries in a dir3 node

From: Dave Chinner <dchinner@redhat.com>

The calculation doesn't take into account the size of the dir v3
header, so overestimates the hash entries in a node. This causes
directory buffer overruns when splitting and merging nodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.h | 11 +++++++++--
 fs/xfs/xfs_dir2.c     | 16 ++++++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 8cdc77b..b1f2679 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -133,12 +133,19 @@ extern void xfs_da3_node_hdr_to_disk(struct xfs_da_intnode *to,
 				     struct xfs_da3_icnode_hdr *from);
 
 static inline int
-xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
+__xfs_da3_node_hdr_size(bool v3)
 {
-	if (dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC))
+	if (v3)
 		return sizeof(struct xfs_da3_node_hdr);
 	return sizeof(struct xfs_da_node_hdr);
 }
+static inline int
+xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
+{
+	bool	v3 = dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC);
+
+	return __xfs_da3_node_hdr_size(v3);
+}
 
 static inline struct xfs_da_node_entry *
 xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index d3ff96c..edf203a 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -90,6 +90,9 @@ void
 xfs_dir_mount(
 	xfs_mount_t	*mp)
 {
+	int	nodehdr_size;
+
+
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 	ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
 	       XFS_MAX_BLOCKSIZE);
@@ -98,12 +101,13 @@ xfs_dir_mount(
 	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
 	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
 	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
-	mp->m_attr_node_ents =
-		(mp->m_sb.sb_blocksize - (uint)sizeof(xfs_da_node_hdr_t)) /
-		(uint)sizeof(xfs_da_node_entry_t);
-	mp->m_dir_node_ents =
-		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
-		(uint)sizeof(xfs_da_node_entry_t);
+
+	nodehdr_size = __xfs_da3_node_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
+	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
+				(uint)sizeof(xfs_da_node_entry_t);
+	mp->m_dir_node_ents = (mp->m_dirblksize - nodehdr_size) /
+				(uint)sizeof(xfs_da_node_entry_t);
+
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
 	if (xfs_sb_version_hasasciici(&mp->m_sb))
 		mp->m_dirnameops = &xfs_ascii_ci_nameops;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

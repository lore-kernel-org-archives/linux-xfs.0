Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CL3mFH028336 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:03:49 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122105.o1CL51p4026682@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 15:05:01 -0600
Subject: [PATCH] xfsprogs: eliminate some build warnings
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

A few minor changes to get rid of some build warnings.
Also a gratuitous name change.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/check.c             |    4 ++--
 include/xfs_da_btree.h |    2 +-
 include/xfs_types.h    |    2 +-
 libxfs/xfs_da_btree.c  |    9 +++++----
 4 files changed, 9 insertions(+), 8 deletions(-)

Index: b/db/check.c
===================================================================
--- a/db/check.c
+++ b/db/check.c
@@ -3059,7 +3059,7 @@ process_leaf_node_dir_v2(
 	xfs_ino_t		lino;
 	int			nex;
 	xfs_ino_t		parent;
-	int			t;
+	int			t = 0;
 	int			v;
 	int			v2;
 	int			x;
@@ -3403,7 +3403,7 @@ process_quota(
 	xfs_fileoff_t	qbno;
 	char		*s = NULL;
 	int		scicb;
-	int		t;
+	int		t = 0;
 
 	switch (qtype) {
 	case IS_USER_QUOTA:
Index: b/include/xfs_da_btree.h
===================================================================
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -251,7 +251,7 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  xfs_dabuf_t *dead_buf);
 
-uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+uint xfs_da_hashname(const char *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 				const char *name, int len);
 
Index: b/include/xfs_types.h
===================================================================
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -161,7 +161,7 @@ typedef enum {
 } xfs_btnum_t;
 
 struct xfs_name {
-	const char	*name;
+	const uchar_t	*name;
 	int		len;
 };
 
Index: b/libxfs/xfs_da_btree.c
===================================================================
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1476,21 +1476,22 @@ xfs_da_path_shift(xfs_da_state_t *state,
  * This is implemented with some source-level loop unrolling.
  */
 xfs_dahash_t
-xfs_da_hashname(const uchar_t *name, int namelen)
+xfs_da_hashname(const char *name_string, int name_length)
 {
-	xfs_dahash_t hash;
+	xfs_dahash_t  hash;
+	const uchar_t *name = (const uchar_t *) name_string;
 
 	/*
 	 * Do four characters at a time as long as we can.
 	 */
-	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+	for (hash = 0; name_length >= 4; name_length -= 4, name += 4)
 		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
 		       (name[3] << 0) ^ rol32(hash, 7 * 4);
 
 	/*
 	 * Now do the rest of the characters.
 	 */
-	switch (namelen) {
+	switch (name_length) {
 	case 3:
 		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
 		       rol32(hash, 7 * 3);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

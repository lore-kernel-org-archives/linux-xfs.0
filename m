Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A241A7F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:09:13 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:09:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 02/10] xfs: rename XFS_CMP_CASE to XFS_CMP_MATCH
Message-ID: <20140918200910.GD4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

Rename XFS_CMP_CASE to XFS_CMP_MATCH. With unicode filenames and
normalization, different strings will match on other criteria than
case insensitivity.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 fs/xfs/libxfs/xfs_da_btree.h  | 2 +-
 fs/xfs/libxfs/xfs_dir2.c      | 9 ++++++---
 fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6e153e3..9ebcc23 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -52,7 +52,7 @@ struct xfs_da_geometry {
 enum xfs_dacmp {
 	XFS_CMP_DIFFERENT,	/* names are completely different */
 	XFS_CMP_EXACT,		/* names are exactly the same */
-	XFS_CMP_CASE		/* names are same but differ in case */
+	XFS_CMP_MATCH		/* names are same but differ in encoding */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6cef221..32e769b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -74,7 +74,7 @@ xfs_ascii_ci_compname(
 			continue;
 		if (tolower(args->name[i]) != tolower(name[i]))
 			return XFS_CMP_DIFFERENT;
-		result = XFS_CMP_CASE;
+		result = XFS_CMP_MATCH;
 	}
 
 	return result;
@@ -315,8 +315,11 @@ xfs_dir_cilookup_result(
 {
 	if (args->cmpresult == XFS_CMP_DIFFERENT)
 		return -ENOENT;
-	if (args->cmpresult != XFS_CMP_CASE ||
-					!(args->op_flags & XFS_DA_OP_CILOOKUP))
+	if (args->cmpresult == XFS_CMP_EXACT)
+		return -EEXIST;
+	ASSERT(args->cmpresult == XFS_CMP_MATCH);
+	/* Only dup the found name if XFS_DA_OP_CILOOKUP is set. */
+	if (!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
 	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1778c40..9d46e8d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2023,7 +2023,7 @@ xfs_dir2_node_lookup(
 	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
-	else if (rval == -ENOENT && args->cmpresult == XFS_CMP_CASE) {
+	else if (rval == -ENOENT && args->cmpresult == XFS_CMP_MATCH) {
 		/* If a CI match, dup the actual name and return -EEXIST */
 		xfs_dir2_data_entry_t	*dep;
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

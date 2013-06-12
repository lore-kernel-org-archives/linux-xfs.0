Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7BFD7F55
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 08:02:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88843304032
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 06:02:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ikndax02iMngoJxW for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 06:02:50 -0700 (PDT)
Message-ID: <51B87253.8060905@redhat.com>
Date: Wed, 12 Jun 2013 09:06:27 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/27] xfs: current patch queue for 3.11
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/12/2013 06:22 AM, Dave Chinner wrote:
> Hi folks,
> =

> This is an update of my current patch queue for the 3.11 release
> cycle. This series starts on top of the patch series I posted for
> 3.10-rc6, and builds upon the series previously posted last week:
> =

> http://oss.sgi.com/pipermail/xfs/2013-June/027040.html
> =


Just a heads up, I applied this to tot and hit a few minor build errors:

fs/xfs/xfs_dir2_readdir.c:40:1: error: static declaration of
=91xfs_dir2_sf_getdents=92 follows non-static declaration
In file included from fs/xfs/xfs_dir2_readdir.c:34:0:
fs/xfs/xfs_dir2_priv.h:127:12: note: previous declaration of
=91xfs_dir2_sf_getdents=92 was here
fs/xfs/xfs_dir2_readdir.c:143:1: error: static declaration of
=91xfs_dir2_block_getdents=92 follows non-static declaration
In file included from fs/xfs/xfs_dir2_readdir.c:34:0:
fs/xfs/xfs_dir2_priv.h:32:12: note: previous declaration of
=91xfs_dir2_block_getdents=92 was here
fs/xfs/xfs_dir2_readdir.c:455:1: error: static declaration of
=91xfs_dir2_leaf_getdents=92 follows non-static declaration
In file included from fs/xfs/xfs_dir2_readdir.c:34:0:
fs/xfs/xfs_dir2_priv.h:68:12: note: previous declaration of
=91xfs_dir2_leaf_getdents=92 was here

In each case, it looks like patch 14/27 (xfs: move getdents code into
it's own file) moved the associated function and added a STATIC to the
function definition. Given the title of the patch, I removed the
STATIC's and moved on to this one:

fs/xfs/xfs_dir2_data.c:39:1: error: static declaration of
=91xfs_dir2_data_freefind=92 follows non-static declaration
In file included from fs/xfs/xfs_dir2_data.c:31:0:
fs/xfs/xfs_dir2.h:125:35: note: previous declaration of
=91xfs_dir2_data_freefind=92 was here

That one appears to be due to 15/27 (xfs: reshuffle dir2 definitions
around for userspace) adding a header declaration to a static function.

diff appended for reference.

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 804238d..3bef13a 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -122,9 +122,6 @@ extern void xfs_dir2_data_use_free(struct xfs_trans
*tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);

-extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
-		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_unused *dup);
-
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index dcf17cf..ed86deb 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -36,7 +36,7 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"

-STATIC int
+int
 xfs_dir2_sf_getdents(
 	xfs_inode_t		*dp,		/* incore directory inode */
 	void			*dirent,
@@ -139,7 +139,7 @@ xfs_dir2_sf_getdents(
 /*
  * Readdir for block directories.
  */
-STATIC int
+int
 xfs_dir2_block_getdents(
 	xfs_inode_t		*dp,		/* incore inode */
 	void			*dirent,
@@ -451,7 +451,7 @@ out:
  * Getdents (readdir) for leaf and node directories.
  * This reads the data blocks only, so is the same for both forms.
  */
-STATIC int
+int
 xfs_dir2_leaf_getdents(
 	xfs_inode_t		*dp,		/* incore directory inode */
 	void			*dirent,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3R6Im3l134632 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 01:18:48 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E591A2F3CDB
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 23:20:51 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id ZVd9Kj1p83gqloZN for
	<xfs@oss.sgi.com>; Mon, 26 Apr 2010 23:20:51 -0700 (PDT)
From: Tao Ma <tao.ma@oracle.com>
Subject: [PATCH] XFS: Let the broken fiemap work in query mode.
Date: Tue, 27 Apr 2010 14:17:45 +0800
Message-Id: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
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
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
bmv_count to the caller's input buffer, this number query function can't
work any more. As this commit is written to change bmv_count from
MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
much extents the file has, a big number may cause ENOMEM, while a small
one will mask the real extent no.

So this patch try to resolve this problem by adding a temporary getbmapx
in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
the "out" either. Instead, every time we want to use 'out', use '&tmp'
instead.

I know this solution is a bit ugly, but I can't find a way to resolve
this issue while not changing the codes too much. So any good suggestion
is welcomed.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/xfs_bmap.c |   47 +++++++++++++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 98251cd..654d9cf 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5557,13 +5557,14 @@ xfs_getbmap(
 	int			nexleft;	/* # of user extents left */
 	int			subnex;		/* # of bmapi's can do */
 	int			nmap;		/* number of map entries */
-	struct getbmapx		*out;		/* output structure */
+	struct getbmapx		*out = NULL;	/* output structure */
 	int			whichfork;	/* data or attr fork */
 	int			prealloced;	/* this is a file with
 						 * preallocated data space */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 	int			cur_ext = 0;
+	struct getbmapx		tmp, *bmap;
 
 	mp = ip->i_mount;
 	iflags = bmv->bmv_iflags;
@@ -5635,16 +5636,20 @@ xfs_getbmap(
 	}
 
 	nex = bmv->bmv_count - 1;
-	if (nex <= 0)
+	if (nex < 0)
 		return XFS_ERROR(EINVAL);
 	bmvend = bmv->bmv_offset + bmv->bmv_length;
 
 
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
 		return XFS_ERROR(ENOMEM);
-	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out)
-		return XFS_ERROR(ENOMEM);
+	if (nex) {
+		out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx),
+				  KM_MAYFAIL);
+		if (!out)
+			return XFS_ERROR(ENOMEM);
+	} else
+		nex = MAXEXTNUM;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
@@ -5700,35 +5705,37 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out[cur_ext].bmv_oflags = 0;
+			if (out)
+				bmap = &out[cur_ext];
+			else
+				bmap = &tmp;
+			bmap->bmv_oflags = 0;
 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
-				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
+				bmap->bmv_oflags |= BMV_OF_PREALLOC;
 			else if (map[i].br_startblock == DELAYSTARTBLOCK)
-				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
-			out[cur_ext].bmv_offset =
+				bmap->bmv_oflags |= BMV_OF_DELALLOC;
+			bmap->bmv_offset =
 				XFS_FSB_TO_BB(mp, map[i].br_startoff);
-			out[cur_ext].bmv_length =
+			bmap->bmv_length =
 				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			out[cur_ext].bmv_unused1 = 0;
-			out[cur_ext].bmv_unused2 = 0;
+			bmap->bmv_unused1 = 0;
+			bmap->bmv_unused2 = 0;
 			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
 			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
-				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
+				bmap->bmv_oflags |= BMV_OF_LAST;
 				goto out_free_map;
 			}
 
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
+			if (!xfs_getbmapx_fix_eof_hole(ip, bmap,
 					prealloced, bmvend,
 					map[i].br_startblock))
 				goto out_free_map;
 
 			nexleft--;
-			bmv->bmv_offset =
-				out[cur_ext].bmv_offset +
-				out[cur_ext].bmv_length;
+			bmv->bmv_offset = bmap->bmv_offset + bmap->bmv_length;
 			bmv->bmv_length =
 				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
 			bmv->bmv_entries++;
@@ -5746,8 +5753,12 @@ xfs_getbmap(
 	for (i = 0; i < cur_ext; i++) {
 		int full = 0;	/* user array is full */
 
+		if (out)
+			bmap = &out[i];
+		else
+			bmap = &tmp;
 		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
+		error = formatter(&arg, bmap, &full);
 		if (error || full)
 			break;
 	}
-- 
1.6.3.3.334.g916e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BFD07F88
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 13:06:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D3868F8050
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 11:06:27 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id OaqhSp6FZClsHEnI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 24 Nov 2014 11:06:26 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id z107so5649026qgd.33
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 11:06:25 -0800 (PST)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH] xfs: overflow in xfs_iomap_eof_align_last_fsb
Date: Mon, 24 Nov 2014 14:06:13 -0500
Message-Id: <1416855973-6359-1-git-send-email-treestem@gmail.com>
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
Cc: Peter Watkins <treestem@gmail.com>

Someone else may have run into this already, if not please take
a look.

 Peter

If extsize is set and new_last_fsb is larger than 32 bits, the
roundup to extsize will overflow the align variable. Instead,
combine alignments by rounding extsize hint up to stripe size.

Signed-off-by: Peter Watkins <treestem@gmail.com>
Reviewed-by: Nathaniel W. Turner <nate@houseofnate.net>
---
 fs/xfs/xfs_iomap.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index afcf3c9..0c4abfe 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -52,7 +52,7 @@ xfs_iomap_eof_align_last_fsb(
 	xfs_extlen_t	extsize,
 	xfs_fileoff_t	*last_fsb)
 {
-	xfs_fileoff_t	new_last_fsb = 0;
+	xfs_fileoff_t	new_last_fsb;
 	xfs_extlen_t	align = 0;
 	int		eof, error;
 
@@ -70,23 +70,24 @@ xfs_iomap_eof_align_last_fsb(
 		else if (mp->m_dalign)
 			align = mp->m_dalign;
 
-		if (align && XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, align))
-			new_last_fsb = roundup_64(*last_fsb, align);
+		if (align && XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, align))
+			align = 0;
 	}
 
 	/*
-	 * Always round up the allocation request to an extent boundary
-	 * (when file on a real-time subvolume or has di_extsize hint).
+	 * Round up the allocation request to an extent boundary. If
+	 * already aligned to a stripe, round extsize up to a stripe
+	 * boundary.
 	 */
 	if (extsize) {
-		if (new_last_fsb)
-			align = roundup_64(new_last_fsb, extsize);
+		if (align)
+			align = roundup_64(extsize, align);
 		else
 			align = extsize;
-		new_last_fsb = roundup_64(*last_fsb, align);
 	}
 
-	if (new_last_fsb) {
+	if (align) {
+		new_last_fsb = roundup_64(*last_fsb, align);
 		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
 		if (error)
 			return error;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

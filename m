Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D0A27F59
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 16:45:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 898428F80A1
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 14:45:39 -0800 (PST)
Received: from mail-qc0-f175.google.com (mail-qc0-f175.google.com
	[209.85.216.175]) by cuda.sgi.com with ESMTP id
	tzq8XdI2vQzVGZej (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 14:45:38 -0800 (PST)
Received: by mail-qc0-f175.google.com with SMTP id b13so9443520qcw.6
	for <xfs@oss.sgi.com>; Mon, 01 Dec 2014 14:45:37 -0800 (PST)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH v2] xfs: overflow in xfs_iomap_eof_align_last_fsb
Date: Mon,  1 Dec 2014 17:45:28 -0500
Message-Id: <1417473928-447-1-git-send-email-treestem@gmail.com>
In-Reply-To: <1416855973-6359-1-git-send-email-treestem@gmail.com>
References: <1416855973-6359-1-git-send-email-treestem@gmail.com>
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

If extsize is set and new_last_fsb is larger than 32 bits, the
roundup to extsize will overflow the align variable. Instead,
combine alignments by rounding stripe size up to extsize.

Signed-off-by: Peter Watkins <treestem@gmail.com>
Reviewed-by: Nathaniel W. Turner <nate@houseofnate.net>
---
 fs/xfs/xfs_iomap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index afcf3c9..3fad071 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -52,7 +52,6 @@ xfs_iomap_eof_align_last_fsb(
 	xfs_extlen_t	extsize,
 	xfs_fileoff_t	*last_fsb)
 {
-	xfs_fileoff_t	new_last_fsb = 0;
 	xfs_extlen_t	align = 0;
 	int		eof, error;
 
@@ -70,8 +69,8 @@ xfs_iomap_eof_align_last_fsb(
 		else if (mp->m_dalign)
 			align = mp->m_dalign;
 
-		if (align && XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, align))
-			new_last_fsb = roundup_64(*last_fsb, align);
+		if (align && XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, align))
+			align = 0;
 	}
 
 	/*
@@ -79,14 +78,14 @@ xfs_iomap_eof_align_last_fsb(
 	 * (when file on a real-time subvolume or has di_extsize hint).
 	 */
 	if (extsize) {
-		if (new_last_fsb)
-			align = roundup_64(new_last_fsb, extsize);
+		if (align)
+			align = roundup_64(align, extsize);
 		else
 			align = extsize;
-		new_last_fsb = roundup_64(*last_fsb, align);
 	}
 
-	if (new_last_fsb) {
+	if (align) {
+		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);
 		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
 		if (error)
 			return error;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

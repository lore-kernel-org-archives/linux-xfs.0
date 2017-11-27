Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33306 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdK0WsD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 17:48:03 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 811EF3258
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 16:47:37 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs: fix leaks on corruption errors in xfs_bmap.c
Message-ID: <4b6bc004-3a7f-40f7-7d97-d1f358439b88@sandeen.net>
Date: Mon, 27 Nov 2017 16:48:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Use _GOTO instead of _RETURN so we can free the allocated
cursor on error.

Fixes: bf80628 ("xfs: remove xfs_bmse_shift_one")
Fixes-coverity-id: 1423813
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Compile-tested only 

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 08df809..87884aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5662,7 +5662,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 		*done = true;
 		goto del_cursor;
 	}
-	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
+	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
+				del_cursor);
 
 	new_startoff = got.br_startoff - offset_shift_fsb;
 	if (xfs_iext_peek_prev_extent(ifp, &icur, &prev)) {
@@ -5767,7 +5768,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			goto del_cursor;
 		}
 	}
-	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
+	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
+				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
 		error = -EIO;


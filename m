Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ML5IBx255128 for <xfs@oss.sgi.com>; Tue, 22 May 2012 16:05:18 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kkkOpwE8yDB2o7sv for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 15:10:52 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LMAp3L032041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 18:10:51 -0400
Message-ID: <4FBABD6A.6070800@redhat.com>
Date: Mon, 21 May 2012 17:10:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfs_repair: Document & robustify blkmap_next_off()
References: <4FBABCAB.20300@redhat.com>
In-Reply-To: <4FBABCAB.20300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

blkmap_next_off() was cryptic (to me), so document what it does.
Also catch cases when the passed in extent index 't' is beyond
the number of extents in the blkmap, so that:

        ext = blkmap->exts + *t;

doesn't walk off the end of the array into garbage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/bmap.c b/repair/bmap.c
index c43ca7f..85d66dc 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -206,8 +206,25 @@ blkmap_last_off(
 	return ext->startoff + ext->blockcount;
 }
 
-/*
- * Return the next offset in a block map.
+/**
+ * blkmap_next_off - Return next logical block offset in a block map.
+ * @blkmap:	blockmap to use
+ * @o:		current file logical block number
+ * @t:		current extent index into blockmap (in/out)
+ *
+ * Given a logical block offset in a file, return the next mapped logical offset
+ * The map index "t" tracks the current extent number in the block map, and
+ * is updated automatically if the returned offset resides within the next
+ * mapped extent.
+ *
+ * If the blockmap contains no extents, or no more logical offsets are mapped,
+ * or the extent index exceeds the number of extents in the map,
+ * return NULLDFILOFF.
+ *
+ * If offset o is beyond extent index t, the first offset in the next extent
+ * after extent t will be returned.
+ *
+ * Intended to be called starting with offset 0, index 0, and iterated.
  */
 xfs_dfiloff_t
 blkmap_next_off(
@@ -223,10 +240,12 @@ blkmap_next_off(
 		*t = 0;
 		return blkmap->exts[0].startoff;
 	}
+	if (*t >= blkmap->nexts)
+		return NULLDFILOFF;
 	ext = blkmap->exts + *t;
 	if (o < ext->startoff + ext->blockcount - 1)
 		return o + 1;
-	if (*t >= blkmap->nexts - 1)
+	if (*t == blkmap->nexts - 1)
 		return NULLDFILOFF;
 	(*t)++;
 	return ext[1].startoff;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42JREfO074784 for <xfs@oss.sgi.com>; Wed, 2 May 2012 14:27:14 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VIxcV9BfBSgsPaIe for
	<xfs@oss.sgi.com>; Wed, 02 May 2012 12:27:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q42JRBDL030513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 2 May 2012 15:27:12 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q42JRAK5011036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 May 2012 15:27:11 -0400
Message-ID: <4FA18A8E.1010800@redhat.com>
Date: Wed, 02 May 2012 14:27:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: comment & robustify blkmap_next_off()
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
To: xfs-oss <xfs@oss.sgi.com>

When looking at blkmap_next_off I was a little puzzled,
so I started adding comments.  Hopefully this helps.

I also noticed that if you happen to pass in a "t"
beyond the last map, it'll happily go read off the
end of the array and return you something based on what
it finds, seems better to catch that & return something
obvious instead.

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

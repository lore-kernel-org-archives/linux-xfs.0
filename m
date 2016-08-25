Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 91F1E7D01
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54D7B8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:26 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id eWUvtnMoGmrmJGgE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:25 -0700 (PDT)
Subject: [PATCH 6/6] iomap: add a flag to report shared extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:31:20 -0700
Message-ID: <147216788009.525.789325200721590680.stgit@birch.djwong.org>
In-Reply-To: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c            |    2 ++
 include/linux/iomap.h |    1 +
 2 files changed, 3 insertions(+)


diff --git a/fs/iomap.c b/fs/iomap.c
index e9b3f99..ec411a6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -512,6 +512,8 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 
 	if (iomap->flags & IOMAP_F_MERGED)
 		flags |= FIEMAP_EXTENT_MERGED;
+	if (iomap->flags & IOMAP_F_SHARED)
+		flags |= FIEMAP_EXTENT_SHARED;
 
 	return fiemap_fill_next_extent(fi, iomap->offset,
 			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3a56212..c74226a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -22,6 +22,7 @@ struct vm_fault;
  * Flags for iomap mappings:
  */
 #define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
+#define IOMAP_F_SHARED	0x02	/* block shared with another file */
 
 /*
  * Magic value for blkno:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

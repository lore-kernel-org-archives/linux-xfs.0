Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 17:09:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J09qfB019240
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 17:09:53 -0700
Date: Thu, 19 Apr 2007 10:09:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] kill macro noise in xfs_dir2*.h
Message-ID: <20070419000940.GL48531920@melbourne.sgi.com>
References: <20070418175859.GB18315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418175859.GB18315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Apr 18, 2007 at 07:59:00PM +0200, Christoph Hellwig wrote:
> Remove all the macros that just give inline functions uppercase names.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

BTW, you'll need this patch to make debug kernels build....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfsidbg.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-03-30 09:30:01.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-04-19 10:02:29.565671598 +1000
@@ -5490,7 +5490,7 @@ xfs_dir2data(void *addr, int size)
 		/* XFS_DIR2_BLOCK_TAIL_P */
 		tail = (xfs_dir2_block_tail_t *)
 		       ((char *)bb + size - sizeof(xfs_dir2_block_tail_t));
-		l = XFS_DIR2_BLOCK_LEAF_P(tail);
+		l = xfs_dir2_block_leaf_p(tail);
 		t = (char *)l;
 	}
 	for (p = (char *)(h + 1); p < t; ) {
@@ -5500,7 +5500,7 @@ xfs_dir2data(void *addr, int size)
 				(unsigned long) (p - (char *)addr),
 				INT_GET(u->freetag, ARCH_CONVERT),
 				INT_GET(u->length, ARCH_CONVERT),
-				INT_GET(*XFS_DIR2_DATA_UNUSED_TAG_P(u), ARCH_CONVERT));
+				INT_GET(*xfs_dir2_data_unused_tag_p(u), ARCH_CONVERT));
 			p += INT_GET(u->length, ARCH_CONVERT);
 			continue;
 		}
@@ -5511,8 +5511,8 @@ xfs_dir2data(void *addr, int size)
 			e->namelen);
 		for (k = 0; k < e->namelen; k++)
 			kdb_printf("%c", e->name[k]);
-		kdb_printf("\" tag 0x%x\n", INT_GET(*XFS_DIR2_DATA_ENTRY_TAG_P(e), ARCH_CONVERT));
-		p += XFS_DIR2_DATA_ENTSIZE(e->namelen);
+		kdb_printf("\" tag 0x%x\n", INT_GET(*xfs_dir2_data_entry_tag_p(e), ARCH_CONVERT));
+		p += xfs_dir2_data_entsize(e->namelen);
 	}
 	if (INT_GET(h->magic, ARCH_CONVERT) == XFS_DIR2_DATA_MAGIC)
 		return;
@@ -5557,7 +5557,7 @@ xfs_dir2leaf(xfs_dir2_leaf_t *leaf, int 
 		return;
 	/* XFS_DIR2_LEAF_TAIL_P */
 	t = (xfs_dir2_leaf_tail_t *)((char *)leaf + size - sizeof(*t));
-	b = XFS_DIR2_LEAF_BESTS_P(t);
+	b = xfs_dir2_leaf_bests_p(t);
 	for (j = 0; j < INT_GET(t->bestcount, ARCH_CONVERT); j++, b++) {
 		kdb_printf("0x%lx best %d 0x%x\n",
 			(unsigned long) ((char *)b - (char *)leaf), j,
@@ -5578,19 +5578,19 @@ xfsidbg_xdir2sf(xfs_dir2_sf_t *s)
 	int i, j;
 
 	sfh = &s->hdr;
-	ino = XFS_DIR2_SF_GET_INUMBER(s, &sfh->parent);
+	ino = xfs_dir2_sf_get_inumber(s, &sfh->parent);
 	kdb_printf("hdr count %d i8count %d parent %llu\n",
 		sfh->count, sfh->i8count, (unsigned long long) ino);
-	for (i = 0, sfe = XFS_DIR2_SF_FIRSTENTRY(s); i < sfh->count; i++) {
-		ino = XFS_DIR2_SF_GET_INUMBER(s, XFS_DIR2_SF_INUMBERP(sfe));
+	for (i = 0, sfe = xfs_dir2_sf_firstentry(s); i < sfh->count; i++) {
+		ino = xfs_dir2_sf_get_inumber(s, xfs_dir2_sf_inumberp(sfe));
 		kdb_printf("entry %d inumber %llu offset 0x%x namelen %d name \"",
 			i, (unsigned long long) ino,
-			XFS_DIR2_SF_GET_OFFSET(sfe),
+			xfs_dir2_sf_get_offset(sfe),
 			sfe->namelen);
 		for (j = 0; j < sfe->namelen; j++)
 			kdb_printf("%c", sfe->name[j]);
 		kdb_printf("\"\n");
-		sfe = XFS_DIR2_SF_NEXTENTRY(s, sfe);
+		sfe = xfs_dir2_sf_nextentry(s, sfe);
 	}
 }
 

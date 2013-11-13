Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88B167FBA
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C53230406B
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7cAeEDDCfrLzuj4l for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:25 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bl-6F
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006im-5D
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/36] db: rewrite bbmap to use xfs_buf_map
Date: Wed, 13 Nov 2013 17:40:42 +1100
Message-Id: <1384324860-25677-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Use the libxfs struct xfs_buf_map for recording the extent layout of
discontiguous buffers and convert the read/write to decode them
directory and use read_buf/write_buf to do the extent IO. This
brings the physical xfs_db IO code to be very close to the model
that libxfs uses.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/bmap.c | 15 ++++-----------
 db/io.c   | 58 ++++++++++++----------------------------------------------
 db/io.h   |  3 ++-
 3 files changed, 18 insertions(+), 58 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 0ef7a62..3951b9f 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -293,20 +293,13 @@ make_bbmap(
 	int		nex,
 	bmap_ext_t	*bmp)
 {
-	int		d;
-	xfs_dfsbno_t	dfsbno;
 	int		i;
-	int		j;
-	int		k;
 
-	for (i = 0, d = 0; i < nex; i++) {
-		dfsbno = bmp[i].startblock;
-		for (j = 0; j < bmp[i].blockcount; j++, dfsbno++) {
-			for (k = 0; k < blkbb; k++)
-				bbmap->b[d++] =
-					XFS_FSB_TO_DADDR(mp, dfsbno) + k;
-		}
+	for (i = 0; i < nex; i++) {
+		bbmap->b[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
+		bbmap->b[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
+	bbmap->nmaps = nex;
 }
 
 static xfs_fsblock_t
diff --git a/db/io.c b/db/io.c
index fa11646..01a5970 100644
--- a/db/io.c
+++ b/db/io.c
@@ -478,28 +478,16 @@ write_bbs(
 	void            *bufp,
 	bbmap_t		*bbmap)
 {
-	int		c;
-	int		i;
 	int		j;
 	int		rval = EINVAL;	/* initialize for zero `count' case */
 
-	for (j = 0; j < count; j++) {
-		bbno = bbmap->b[j];
-		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
-			rval = errno;
-			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
-			return rval;
-		}
-		c = BBTOB(1);
-		i = (int)write(x.dfd, (char *)bufp + BBTOB(j), c);
-		if (i < 0) {
-			rval = errno;
-		} else if (i < c) {
-			rval = -1;
-		} else
-			rval = 0;
+	for (j = 0; j < count;) {
+		rval = write_buf(bbmap->b[j].bm_bn, bbmap->b[j].bm_len,
+			     (char *)bufp + BBTOB(j));
 		if (rval)
 			break;
+
+		j += bbmap->b[j].bm_len;
 	}
 	return rval;
 }
@@ -512,45 +500,23 @@ read_bbs(
 	bbmap_t		*bbmap)
 {
 	void		*buf;
-	int		c;
-	int		i;
 	int		j;
 	int		rval = EINVAL;
 
 	if (count <= 0)
 		count = 1;
 
-	c = BBTOB(count);
 	if (*bufp == NULL)
-		buf = xmalloc(c);
+		buf = xmalloc(BBTOB(count));
 	else
 		buf = *bufp;
-	for (j = 0; j < count; j++) {
-		bbno = bbmap->b[j];
-		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
-			rval = errno;
-			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
-			if (*bufp == NULL)
-				xfree(buf);
-			buf = NULL;
-		} else {
-			c = BBTOB(1);
-			i = (int)read(x.dfd, (char *)buf + BBTOB(j), c);
-			if (i < 0) {
-				rval = errno;
-				if (*bufp == NULL)
-					xfree(buf);
-				buf = NULL;
-			} else if (i < c) {
-				rval = -1;
-				if (*bufp == NULL)
-					xfree(buf);
-				buf = NULL;
-			} else
-				rval = 0;
-		}
-		if (buf == NULL)
+	for (j = 0; j < count;) {
+		rval = read_buf(bbmap->b[j].bm_bn, bbmap->b[j].bm_len,
+			     (char *)buf + BBTOB(j));
+		if (rval)
 			break;
+
+		j += bbmap->b[j].bm_len;
 	}
 	if (*bufp == NULL)
 		*bufp = buf;
diff --git a/db/io.h b/db/io.h
index 9ea6223..c7641d5 100644
--- a/db/io.h
+++ b/db/io.h
@@ -20,7 +20,8 @@ struct typ;
 
 #define	BBMAP_SIZE		(XFS_MAX_BLOCKSIZE / BBSIZE)
 typedef struct bbmap {
-	__int64_t		b[BBMAP_SIZE];
+	int			nmaps;
+	struct xfs_buf_map	b[BBMAP_SIZE];
 } bbmap_t;
 
 typedef struct iocur {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

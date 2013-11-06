Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 382CE29E2F
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF586AC005
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:45 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zla20X3VKdGaZL6r for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:42 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003OH-8z
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008VH-8S
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/37] db: separate out straight buffer IO from map based IO.
Date: Wed,  6 Nov 2013 12:07:03 +1100
Message-Id: <1383700043-32305-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

Libxfs has two different interfaces for getting and reading buffers.
The first is a block/length interface for reading contiguous
regions, and the second is based on extent based xfs_buf_map arrays
for discontiguous regions. The xfs-db code is solely based on a
basic block array interface regardless of the type of region being
read, and so doesn't match to either libxfs interface.

As a first step to converting xfs_db to the libxfs interfaces, add a
simple block/length buffer API and implement it using pread/pwrite.
Then remove the single region conditionals from the basic block array
based interfaces, and convert all the contiguous block read cases to
use the new API.

This new API is temporary - it will be replaced by the equivalent
libxfs interface calls once all the infrastructure preparation for
the changeover has been completed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c |   7 ++--
 db/io.c   | 125 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 db/io.h   |   5 +--
 3 files changed, 104 insertions(+), 33 deletions(-)

diff --git a/db/init.c b/db/init.c
index 54f3f9e..b93a194 100644
--- a/db/init.c
+++ b/db/init.c
@@ -55,7 +55,7 @@ init(
 	char		**argv)
 {
 	xfs_sb_t	*sbp;
-	void		*bufp = NULL;
+	char		bufp[BBSIZE];
 	int		c;
 
 	setlocale(LC_ALL, "");
@@ -115,15 +115,14 @@ init(
 		exit(1);
 	}
 
-	if (read_bbs(XFS_SB_DADDR, 1, &bufp, NULL)) {
+	if (read_buf(XFS_SB_DADDR, 1, bufp)) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
 	}
 
 	/* copy SB from buffer to in-core, converting architecture as we go */
-	libxfs_sb_from_disk(&xmount.m_sb, bufp);
-	xfree(bufp);
+	libxfs_sb_from_disk(&xmount.m_sb, (struct xfs_dsb *)bufp);
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
diff --git a/db/io.c b/db/io.c
index 39a1827..fa11646 100644
--- a/db/io.c
+++ b/db/io.c
@@ -417,8 +417,61 @@ ring_add(void)
 	}
 }
 
-
 int
+read_buf(
+	xfs_daddr_t	bbno,
+	int		count,
+	void		*bufp)
+{
+	int		err;
+
+	err = pread64(x.dfd, bufp, BBTOB(count), BBTOB(bbno));
+	if (err < 0)
+		err = errno;
+	else if (err < count)
+		err = -1;
+	return err;
+}
+
+static int
+write_buf(
+	xfs_daddr_t	bbno,
+	int		count,
+	void		*bufp)
+{
+	int		err;
+
+	err = pwrite64(x.dfd, bufp, BBTOB(count), BBTOB(bbno));
+	if (err < 0)
+		err = errno;
+	else if (err < count)
+		err = -1;
+	return err;
+}
+
+static void
+write_cur_buf(void)
+{
+	int ret;
+
+	ret = write_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
+
+	if (ret == -1)
+		dbprintf(_("incomplete write, block: %lld\n"),
+			 (iocur_base + iocur_sp)->bb);
+	else if (ret != 0)
+		dbprintf(_("write error: %s\n"), strerror(ret));
+
+	/* re-read buffer from disk */
+	ret = read_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
+	if (ret == -1)
+		dbprintf(_("incomplete read, block: %lld\n"),
+			 (iocur_base + iocur_sp)->bb);
+	else if (ret != 0)
+		dbprintf(_("read error: %s\n"), strerror(ret));
+}
+
+static int
 write_bbs(
 	__int64_t       bbno,
 	int             count,
@@ -430,15 +483,14 @@ write_bbs(
 	int		j;
 	int		rval = EINVAL;	/* initialize for zero `count' case */
 
-	for (j = 0; j < count; j += bbmap ? 1 : count) {
-		if (bbmap)
-			bbno = bbmap->b[j];
+	for (j = 0; j < count; j++) {
+		bbno = bbmap->b[j];
 		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
 			rval = errno;
 			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
 			return rval;
 		}
-		c = BBTOB(bbmap ? 1 : count);
+		c = BBTOB(1);
 		i = (int)write(x.dfd, (char *)bufp + BBTOB(j), c);
 		if (i < 0) {
 			rval = errno;
@@ -452,7 +504,7 @@ write_bbs(
 	return rval;
 }
 
-int
+static int
 read_bbs(
 	__int64_t	bbno,
 	int		count,
@@ -473,9 +525,8 @@ read_bbs(
 		buf = xmalloc(c);
 	else
 		buf = *bufp;
-	for (j = 0; j < count; j += bbmap ? 1 : count) {
-		if (bbmap)
-			bbno = bbmap->b[j];
+	for (j = 0; j < count; j++) {
+		bbno = bbmap->b[j];
 		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
 			rval = errno;
 			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
@@ -483,7 +534,7 @@ read_bbs(
 				xfree(buf);
 			buf = NULL;
 		} else {
-			c = BBTOB(bbmap ? 1 : count);
+			c = BBTOB(1);
 			i = (int)read(x.dfd, (char *)buf + BBTOB(j), c);
 			if (i < 0) {
 				rval = errno;
@@ -506,22 +557,19 @@ read_bbs(
 	return rval;
 }
 
-void
-write_cur(void)
+static void
+write_cur_bbs(void)
 {
 	int ret;
 
-	if (iocur_sp < 0) {
-		dbprintf(_("nothing to write\n"));
-		return;
-	}
 	ret = write_bbs(iocur_top->bb, iocur_top->blen, iocur_top->buf,
-		iocur_top->use_bbmap ? &iocur_top->bbmap : NULL);
+			&iocur_top->bbmap);
 	if (ret == -1)
 		dbprintf(_("incomplete write, block: %lld\n"),
 			 (iocur_base + iocur_sp)->bb);
 	else if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
+
 	/* re-read buffer from disk */
 	ret = read_bbs(iocur_top->bb, iocur_top->blen, &iocur_top->buf,
 		iocur_top->use_bbmap ? &iocur_top->bbmap : NULL);
@@ -533,6 +581,20 @@ write_cur(void)
 }
 
 void
+write_cur(void)
+{
+	if (iocur_sp < 0) {
+		dbprintf(_("nothing to write\n"));
+		return;
+	}
+
+	if (iocur_top->use_bbmap)
+		write_cur_bbs();
+	else
+		write_cur_buf();
+}
+
+void
 set_cur(
 	const typ_t	*t,
 	__int64_t	d,
@@ -549,17 +611,32 @@ set_cur(
 		return;
 	}
 
-#ifdef DEBUG
-	if (bbmap)
-		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
-#endif
 	ino = iocur_top->ino;
 	dirino = iocur_top->dirino;
 	mode = iocur_top->mode;
 	pop_cur();
 	push_cur();
-	if (read_bbs(d, c, &iocur_top->buf, bbmap))
-		return;
+
+	if (bbmap) {
+#ifdef DEBUG
+		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
+#endif
+
+		if (read_bbs(d, c, &iocur_top->buf, bbmap))
+			return;
+		iocur_top->bbmap = *bbmap;
+		iocur_top->use_bbmap = 1;
+	} else {
+		if (!iocur_top->buf) {
+			iocur_top->buf = malloc(BBTOB(c));
+			if (!iocur_top->buf)
+				return;
+		}
+		if (read_buf(d, c, iocur_top->buf))
+			return;
+		iocur_top->use_bbmap = 0;
+	}
+
 	iocur_top->bb = d;
 	iocur_top->blen = c;
 	iocur_top->boff = 0;
@@ -570,8 +647,6 @@ set_cur(
 	iocur_top->ino = ino;
 	iocur_top->dirino = dirino;
 	iocur_top->mode = mode;
-	if ((iocur_top->use_bbmap = (bbmap != NULL)))
-		iocur_top->bbmap = *bbmap;
 
 	/* store location in ring */
 	if (ring_flag)
diff --git a/db/io.h b/db/io.h
index 549aad9..9ea6223 100644
--- a/db/io.h
+++ b/db/io.h
@@ -52,10 +52,7 @@ extern void	off_cur(int off, int len);
 extern void	pop_cur(void);
 extern void	print_iocur(char *tag, iocur_t *ioc);
 extern void	push_cur(void);
-extern int	read_bbs(__int64_t daddr, int count, void **bufp,
-			 bbmap_t *bbmap);
-extern int	write_bbs(__int64_t daddr, int count, void *bufp,
-			  bbmap_t *bbmap);
+extern int	read_buf(__int64_t daddr, int count, void *bufp);
 extern void     write_cur(void);
 extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

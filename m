Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E0ja6A054074 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 18:45:36 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4TTlwocF56YuyaAq for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 16:45:34 -0800 (PST)
Date: Tue, 14 Feb 2012 11:45:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs_io: fix fiemap loop continuation
Message-ID: <20120214004532.GJ7479@dastard>
References: <1328163674-9420-1-git-send-email-david@fromorbit.com>
	<20120213190903.GA12477@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120213190903.GA12477@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 02:09:03PM -0500, Christoph Hellwig wrote:
> This actually seems to break 252 and 255 for me.

Ok, there was some code that expected last_logical to be in FSB
units, not bytes that I failed to convert.

Fixed version below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs_io: fix fiemap loop continuation

From: Dave Chinner <dchinner@redhat.com>

When the fiemap command needs to retrieve more extents from the
kernel via a subsequent IO, it calculates the next logical block to
retrieve in file system block units. the fiemap needs the start
offset in bytes, not filesystem blocks.  Hence if the fiemap command
can loop forever retrieving the same blocks if the logical offset
offset of the next block in filesystem block units is smaller than
the number of bytes in a filessytem block. i.e. it will just loop
retreiving the first 32 extents from offset block zero.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
Version 2
o Fix remaining cases where last_logical was expected to be in FSB
  units rather than bytes.

 io/fiemap.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 066e693..e32a416 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -75,12 +75,14 @@ print_verbose(
 	__u64			*last_logical)
 {
 	__u64			lstart;
+	__u64			llast;
 	__u64			len;
 	__u64			block;
 	char			lbuf[48];
 	char			bbuf[48];
 	char			flgbuf[16];
 
+	llast = *last_logical / blocksize;
 	lstart = extent->fe_logical / blocksize;
 	len = extent->fe_length / blocksize;
 	block = extent->fe_physical / blocksize;
@@ -88,11 +90,11 @@ print_verbose(
 	memset(lbuf, 0, sizeof(lbuf));
 	memset(bbuf, 0, sizeof(bbuf));
 
-	if (lstart != *last_logical) {
-		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", *last_logical,
+	if (lstart != llast) {
+		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
 			 lstart - 1ULL);
 		printf("%4d: %-*s %-*s %*llu\n", *cur_extent, foff_w, lbuf,
-		       boff_w, _("hole"), tot_w, lstart - *last_logical);
+		       boff_w, _("hole"), tot_w, lstart - llast);
 		(*cur_extent)++;
 		memset(lbuf, 0, sizeof(lbuf));
 	}
@@ -108,7 +110,7 @@ print_verbose(
 	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
 
 	(*cur_extent)++;
-	*last_logical = lstart + len;
+	*last_logical = extent->fe_logical + extent->fe_length;
 }
 
 static void
@@ -121,19 +123,20 @@ print_plain(
 	__u64			*last_logical)
 {
 	__u64			lstart;
+	__u64			llast;
 	__u64			block;
 	__u64			len;
 
+	llast = *last_logical / blocksize;
 	lstart = extent->fe_logical / blocksize;
 	len = extent->fe_length / blocksize;
 	block = extent->fe_physical / blocksize;
 
-	if (lstart != *last_logical) {
+	if (lstart != llast) {
 		printf("\t%d: [%llu..%llu]: hole", *cur_extent,
-		       *last_logical, lstart - 1ULL);
+		       llast, lstart - 1ULL);
 		if (lflag)
-			printf(_(" %llu blocks\n"),
-			       lstart - *last_logical);
+			printf(_(" %llu blocks\n"), lstart - llast);
 		else
 			printf("\n");
 		(*cur_extent)++;
@@ -151,7 +154,7 @@ print_plain(
 	else
 		printf("\n");
 	(*cur_extent)++;
-	*last_logical = lstart + len;
+	*last_logical = extent->fe_logical + extent->fe_length;
 }
 
 int
@@ -252,7 +255,7 @@ fiemap_f(
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1;
+		fiemap->fm_length = -1LL;
 		fiemap->fm_extent_count = num_extents;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -281,6 +284,7 @@ fiemap_f(
 				print_plain(extent, lflag, blocksize,
 					    max_extents, &cur_extent,
 					    &last_logical);
+
 			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
 				last = 1;
 				break;
@@ -303,22 +307,21 @@ fiemap_f(
 		return 0;
 	}
 
-	if (cur_extent && last_logical < (st.st_size / blocksize)) {
+	if (cur_extent && last_logical < st.st_size) {
 		char	lbuf[32];
 
 		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
-			 last_logical, (st.st_size / blocksize) - 1);
+			 last_logical / blocksize, (st.st_size / blocksize) - 1);
 		if (vflag) {
 			printf("%4d: %-*s %-*s %*llu\n", cur_extent,
 			       foff_w, lbuf, boff_w, _("hole"), tot_w,
-			       (st.st_size / blocksize) - last_logical);
+			       (st.st_size - last_logical) / blocksize);
 		} else {
 			printf("\t%d: %s %s", cur_extent, lbuf,
 			       _("hole"));
 			if (lflag)
 				printf(_(" %llu blocks\n"),
-				       (st.st_size / blocksize) -
-				       last_logical);
+				       (st.st_size - last_logical) / blocksize);
 			else
 				printf("\n");
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

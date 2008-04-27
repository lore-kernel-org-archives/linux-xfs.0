Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 17:47:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3R0lJwc017867
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 17:47:19 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C58010C03C3
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 17:48:01 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152]) by cuda.sgi.com with ESMTP id dv4yuBZApzD6Lb8y for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 17:48:01 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so3688918fga.8
        for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 17:48:00 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Date: Sun, 27 Apr 2008 02:46:58 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_C08EI5Sq2GBn7oU"
Message-Id: <200804270246.58828.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

--Boundary-00=_C08EI5Sq2GBn7oU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

This patch reduces xfs_page_state_convert() stack usage by 16 bytes
by eliminating some local variables, and reducing the size
of scope for other locals.

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

P.S.

xfs_page_state_convert() carries the following comment:
 * Calling this without startio set means we are being asked to make a dirty
 * page ready for freeing it's buffers.  When called with startio set then
 * we are coming from writepage.
which leads to the following proposal: reimplement it as two
functions, one which work as if startio parameter == 0
and the other as if startio == 1.
This will result in a bit of code duplication, but reduces
stack usage on writepage path and allows for these two functions
to have more descriptive names. (Presently the meaning of this
function needs to be explained in that comment -> function
name is not descriptive enough, because it does different things
depending on startio value).

Do you like this idea?
--
vda

--Boundary-00=_C08EI5Sq2GBn7oU
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk2.diff"

diff -urpN linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_aops.c linux-2.6-xfs1.stk2/fs/xfs/linux-2.6/xfs_aops.c
--- linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_aops.c	2008-04-22 04:06:46.000000000 +0200
+++ linux-2.6-xfs1.stk2/fs/xfs/linux-2.6/xfs_aops.c	2008-04-27 02:38:51.000000000 +0200
@@ -935,17 +935,11 @@ xfs_page_state_convert(
 	unsigned long           p_offset = 0;
 	unsigned int		type;
 	__uint64_t              end_offset;
-	pgoff_t                 end_index, last_index, tlast;
-	ssize_t			size, len;
+	pgoff_t                 end_index, last_index;
 	int			flags, err, iomap_valid = 0, uptodate = 1;
 	int			page_dirty, count = 0;
-	int			trylock = 0;
 	int			all_bh = unmapped;
-
-	if (startio) {
-		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
-			trylock |= BMAPI_TRYLOCK;
-	}
+#define len (1 << inode->i_blkbits)
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
@@ -975,7 +969,6 @@ xfs_page_state_convert(
  	 */
 	end_offset = min_t(unsigned long long,
 			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
-	len = 1 << inode->i_blkbits;
 	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
 					PAGE_CACHE_SIZE);
 	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
@@ -1031,13 +1024,18 @@ xfs_page_state_convert(
 				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
 				type = IOMAP_DELAY;
-				flags = BMAPI_ALLOCATE | trylock;
+				flags = BMAPI_ALLOCATE;
+				if (startio && wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking) {
+					flags = BMAPI_ALLOCATE | BMAPI_TRYLOCK;
+				}
 			} else {
 				type = IOMAP_NEW;
 				flags = BMAPI_WRITE | BMAPI_MMAP;
 			}
 
 			if (!iomap_valid) {
+				ssize_t size;
+
 				/*
 				 * if we didn't have a valid mapping then we
 				 * need to ensure that we put the new mapping
@@ -1082,6 +1080,8 @@ xfs_page_state_convert(
 			 * underneath it. Map the extent by reading it.
 			 */
 			if (!iomap_valid || flags != BMAPI_READ) {
+				ssize_t size;
+
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1129,6 +1129,8 @@ xfs_page_state_convert(
 		xfs_start_page_writeback(page, wbc, 1, count);
 
 	if (ioend && iomap_valid) {
+		pgoff_t tlast;
+
 		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
 					PAGE_CACHE_SHIFT;
 		tlast = min_t(pgoff_t, offset, last_index);
@@ -1156,6 +1158,7 @@ error:
 		ClearPageUptodate(page);
 	}
 	return err;
+#undef len
 }
 
 /*

--Boundary-00=_C08EI5Sq2GBn7oU--

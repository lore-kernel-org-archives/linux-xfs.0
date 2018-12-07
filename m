Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeLGGXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 01:23:50 -0500
Subject: [PATCH 04/12] fsx: always check buffer after each operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 06 Dec 2018 22:23:45 -0800
Message-ID: <154416382576.15344.5225803629460714580.stgit@magnolia>
In-Reply-To: <154416379233.15344.4377231692638417530.stgit@magnolia>
References: <154416379233.15344.4377231692638417530.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new option to make fsx read the file after each operation and
compare it with the good buffer to try to catch corruptions as soon as
they occur.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-By: Allison Henderson <allison.henderson@oracle.com>
---
 ltp/fsx.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 76 insertions(+), 10 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 5601c70c..191a5936 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -160,7 +160,8 @@ int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
 int	insert_range_calls = 1;		/* -I flag disables */
-int 	mapped_reads = 1;		/* -R flag disables it */
+int	mapped_reads = 1;		/* -R flag disables it */
+int	check_file = 0;			/* -X flag enables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -561,7 +562,7 @@ dump_fsync_buffer(void)
 }
 
 void
-check_buffers(unsigned offset, unsigned size)
+check_buffers(char *buf, unsigned offset, unsigned size)
 {
 	unsigned char c, t;
 	unsigned i = 0;
@@ -569,19 +570,19 @@ check_buffers(unsigned offset, unsigned size)
 	unsigned op = 0;
 	unsigned bad = 0;
 
-	if (memcmp(good_buf + offset, temp_buf, size) != 0) {
+	if (memcmp(good_buf + offset, buf, size) != 0) {
 		prt("READ BAD DATA: offset = 0x%x, size = 0x%x, fname = %s\n",
 		    offset, size, fname);
 		prt("OFFSET\tGOOD\tBAD\tRANGE\n");
 		while (size > 0) {
 			c = good_buf[offset];
-			t = temp_buf[i];
+			t = buf[i];
 			if (c != t) {
 			        if (n < 16) {
-					bad = short_at(&temp_buf[i]);
+					bad = short_at(&buf[i]);
 				        prt("0x%05x\t0x%04x\t0x%04x", offset,
 				            short_at(&good_buf[offset]), bad);
-					op = temp_buf[offset & 1 ? i+1 : i];
+					op = buf[offset & 1 ? i+1 : i];
 				        prt("\t0x%05x\n", n);
 					if (op)
 						prt("operation# (mod 256) for "
@@ -725,10 +726,9 @@ doread(unsigned offset, unsigned size)
 			    iret, size);
 		report_failure(141);
 	}
-	check_buffers(offset, size);
+	check_buffers(temp_buf, offset, size);
 }
 
-
 void
 check_eofpage(char *s, unsigned offset, char *p, int size)
 {
@@ -755,6 +755,65 @@ check_eofpage(char *s, unsigned offset, char *p, int size)
 		}
 }
 
+void
+check_contents(void)
+{
+	static char *check_buf;
+	unsigned offset = 0;
+	unsigned size = file_size;
+	unsigned map_offset;
+	unsigned map_size;
+	char *p;
+	off_t ret;
+	unsigned iret;
+
+	if (!check_buf) {
+		check_buf = (char *) malloc(maxfilelen + writebdy);
+		assert(check_buf != NULL);
+		check_buf = round_ptr_up(check_buf, writebdy, 0);
+		memset(check_buf, '\0', maxfilelen);
+	}
+
+	if (o_direct)
+		size -= size % readbdy;
+	if (size == 0)
+		return;
+
+	ret = lseek(fd, (off_t)offset, SEEK_SET);
+	if (ret == (off_t)-1) {
+		prterr("doread: lseek");
+		report_failure(140);
+	}
+
+	iret = fsxread(fd, check_buf, size, offset);
+	if (iret != size) {
+		if (iret == -1)
+			prterr("check_contents: read");
+		else
+			prt("short check read: 0x%x bytes instead of 0x%x\n",
+			    iret, size);
+		report_failure(141);
+	}
+	check_buffers(check_buf, offset, size);
+
+	/* Map eof page, check it */
+	map_offset = size - (size & PAGE_MASK);
+	if (map_offset == size)
+		map_offset -= PAGE_SIZE;
+	map_size  = size - map_offset;
+
+	p = mmap(0, map_size, PROT_READ, MAP_SHARED, fd, map_offset);
+	if (p == MAP_FAILED) {
+	        prterr("check_contents: mmap");
+		report_failure(190);
+	}
+	check_eofpage("check_contents", map_offset, p, map_size);
+
+	if (munmap(p, map_size) != 0) {
+		prterr("check_contents: munmap");
+		report_failure(191);
+	}
+}
 
 void
 domapread(unsigned offset, unsigned size)
@@ -808,7 +867,7 @@ domapread(unsigned offset, unsigned size)
 		report_failure(191);
 	}
 
-	check_buffers(offset, size);
+	check_buffers(temp_buf, offset, size);
 }
 
 
@@ -1624,6 +1683,9 @@ test(void)
 		break;
 	}
 
+	if (check_file && testcalls > simulatedopcount)
+		check_contents();
+
 out:
 	if (sizechecks && testcalls > simulatedopcount)
 		check_size();
@@ -1684,6 +1746,7 @@ usage(void)
 	-P: save .fsxlog .fsxops and .fsxgood files in dirpath (default ./)\n\
 	-S seed: for random # generator (default 1) 0 gets timestamp\n\
 	-W: mapped write operations DISabled\n\
+	-X: Read file and compare to good buffer after every operation.\n\
         -R: read() system calls only (mapped reads disabled)\n\
         -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
 	--replay-ops opsfile: replay ops from recorded .fsxops file\n\
@@ -1880,7 +1943,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ",
+				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2044,6 +2107,9 @@ main(int argc, char **argv)
 			if (!quiet)
 				prt("mapped writes DISABLED\n");
 			break;
+		case 'X':
+			check_file = 1;
+			break;
 		case 'Z':
 			o_direct = O_DIRECT;
 			o_flags |= O_DIRECT;

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 20:30:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAN4UF9W001101
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 20:30:18 -0800
Message-ID: <47465712.1050000@sgi.com>
Date: Fri, 23 Nov 2007 15:29:06 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Fix up xfs_buf_associate_memory()
Content-Type: multipart/mixed;
 boundary="------------030003090509040502010601"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------030003090509040502010601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Fixed a few bugs in xfs_buf_associate_memory() including:

- calculation of 'page_count' was incorrect as it did not
   consider the offset of 'mem' into the first page.  The
   logic to bump 'page_count' didn't work if 'len' was <=
   PAGE_CACHE_SIZE (ie offset = 3k, len = 2k).
- setting b_buffer_length to 'len' is incorrect if
   'offset' is > 0.  Set it to the total length of the
   buffer.
- I suspect that passing a non-aligned address into
   mem_to_page() for the first page may have been causing
   issues - don't know but just tidy up that code anyway.

These fixes prevent an data corruption issue that can
occur during log replay.

Lachlan

--------------030003090509040502010601
Content-Type: text/x-patch;
 name="xfs_buf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_buf.diff"

--- fs/xfs/linux-2.6/xfs_buf.c_1.247	2007-11-23 12:03:16.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_buf.c	2007-11-23 12:02:32.000000000 +1100
@@ -726,14 +726,14 @@ xfs_buf_associate_memory(
 	int			rval;
 	int			i = 0;
 	size_t			ptr;
-	size_t			end, end_cur;
+	size_t			buflen;
 	off_t			offset;
 	int			page_count;
 
-	page_count = PAGE_CACHE_ALIGN(len) >> PAGE_CACHE_SHIFT;
-	offset = (off_t) mem - ((off_t)mem & PAGE_CACHE_MASK);
-	if (offset && (len > PAGE_CACHE_SIZE))
-		page_count++;
+	ptr = (size_t) mem & PAGE_CACHE_MASK;
+	offset = (off_t) mem - (off_t) ptr;
+	buflen = PAGE_CACHE_ALIGN(len + offset);
+	page_count = buflen >> PAGE_CACHE_SHIFT;
 
 	/* Free any previous set of page pointers */
 	if (bp->b_pages)
@@ -747,22 +747,15 @@ xfs_buf_associate_memory(
 		return rval;
 
 	bp->b_offset = offset;
-	ptr = (size_t) mem & PAGE_CACHE_MASK;
-	end = PAGE_CACHE_ALIGN((size_t) mem + len);
-	end_cur = end;
-	/* set up first page */
-	bp->b_pages[0] = mem_to_page(mem);
-
-	ptr += PAGE_CACHE_SIZE;
-	bp->b_page_count = ++i;
-	while (ptr < end) {
-		bp->b_pages[i] = mem_to_page((void *)ptr);
-		bp->b_page_count = ++i;
+
+	while (i < bp->b_page_count) {
+		bp->b_pages[i++] = mem_to_page((void *)ptr);
 		ptr += PAGE_CACHE_SIZE;
 	}
 	bp->b_locked = 0;
 
-	bp->b_count_desired = bp->b_buffer_length = len;
+	bp->b_count_desired = len;
+	bp->b_buffer_length = buflen;
 	bp->b_flags |= XBF_MAPPED;
 
 	return 0;

--------------030003090509040502010601--

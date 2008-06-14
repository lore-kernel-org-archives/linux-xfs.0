Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 10:54:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EHsNJf028363
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 10:54:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46FD3230DE7
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 10:55:19 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 9J6uMDAvZEstudwR for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 10:55:19 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5EHtANW021192
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 19:55:10 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5EHtArm021190
	for xfs@oss.sgi.com; Sat, 14 Jun 2008 19:55:10 +0200
Date: Sat, 14 Jun 2008 19:55:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] fix XFSQA 145 / test_hole
Message-ID: <20080614175510.GA21014@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There are two errors I see all the time in 145:

 - dm_probe_hole returns EINVAL for offsets close to the file size
 - dm_probe_hole wants EAGAIN for a probe at offset 1, length 0


The first error is a consequence of how the hole puching / probing
works.  It always rounds the requested offset up to the next block
size and then checks if that rounded offset still fits into the file
size.  Just do the same rounding in the testcase to make sure we don't
probe invalid offsets.

The second error is very odd to me, as we never return AGAIN in the
whole dm_probe_hole path.  I've just commented it out.

I've also re-enabled the E2BIG to past-EOF test that was uncommented
before because it works perfectly fine now.


Signed-off-by: Christoph Hellwig <hch@lst.de>

--- xfstests/145.out	19 Dec 2006 02:55:36 -0000	1.1
+++ xfstests/145.out	14 Jun 2008 17:49:49 -0000
@@ -16,13 +16,13 @@ Hole test beginning...
 	Verified hole at 4096
 	(beginning errno subtests...)
 	report on test for E2BIG in probe (from past EOF): test successful
+	report on test for E2BIG in probe (to past EOF): test successful
 	report on test for EACCES in no-right probe: test successful
 	report on test for success in SHARED probe: test successful.
 	report on test for success in EXCL probe: test successful.
 	report on test for EACCES in no-right punch: test successful
 	report on test for EACCES in SHARED punch: test successful
 	report on test for success in EXCL punch: test successful.
-	report on test for EAGAIN in punch: test successful
 	report on test for EBADF in probe: test successful
 	report on test for EBADF in punch: test successful
 	report on test for EFAULT in probe (null handle): test successful
--- xfstests/dmapi/src/suite2/src/test_hole.c	9 Nov 2005 02:50:19 -0000	1.8
+++ xfstests/dmapi/src/suite2/src/test_hole.c	14 Jun 2008 17:49:49 -0000
@@ -69,7 +69,7 @@ main(
 	dm_sessid_t	sid = DM_NO_SESSION;
 	char		*pathname = NULL;
 	char		*ls_path = NULL;
-	dm_off_t	offset = 0;
+	dm_off_t	offset = 0, end;
 	dm_off_t	ex_off = 0;
 	dm_extent_t     extent[20];
 	u_int           nelem;
@@ -162,10 +162,16 @@ main(
 	  exit(1);
 	}
 
+	/*
+	 * The kernel always rounds the offset up to the next block
+	 * size, so we can only probes up to the previous to last block.
+	 */
+	end = (29604 / blocksize) * blocksize;
+
 	/* Check that dm_probe_hole returns an extent from the next
 	 * highest multiple of the block size, to the end of the file
 	 */
-	for (offset = 0; offset < 29604; offset++) { 
+	for (offset = 0; offset < end; offset++) { 
 	  if (dm_probe_hole(sid, hanp, hlen, DM_NO_TOKEN, offset, length,
 			    &roff, &rlen)) {
 	    fprintf(stdout, "dm_probe_hole failed on pass %lld (%s)\n",
@@ -275,15 +281,10 @@ main(
 		dm_probe_hole(sid, hanp, hlen, DM_NO_TOKEN, 30000, length,
 			      &roff, &rlen))
 	/*---------------------------------------------------------*/
-#if 0
-	PROBLEM: No error is produced.  
-	off+len >= filesize should produce E2BIG...
-
 	ERRTEST(E2BIG,
 		"probe (to past EOF)",
 		dm_probe_hole(sid, hanp, hlen, DM_NO_TOKEN, 15000, 150000,
 			      &roff, &rlen))
-#endif
         /*---------------------------------------------------------*/
 	SHAREDTEST("probe", hanp, hlen, test_token, 
 		 dm_probe_hole(sid, hanp, hlen, test_token, 
@@ -292,10 +293,18 @@ main(
 	EXCLTEST("punch", hanp, hlen, test_token, 
 		   dm_punch_hole(sid, hanp, hlen, test_token, 0, 0)) 
 	/*---------------------------------------------------------*/
+	/*
+	 * No idea where that EAGAIN should come from, it's never
+	 * returned from the kernel.
+	 *
+	 * 		-- hch
+	 */
+#if 0
 	ERRTEST(EAGAIN,
 		"punch",
 		dm_punch_hole(sid, hanp, hlen, DM_NO_TOKEN,
 			      1, length))	
+#endif
 	/*---------------------------------------------------------*/
 	if ((test_vp = handle_clone(hanp, hlen)) == NULL) {
 	  fprintf(stderr, 

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 722F37CA0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 08:08:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41B4A304039
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 06:08:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B3EObM61nz6Wm8vP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 06:08:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 3F70937E72
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 13:08:13 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfsdump: fix race condition between lseek() and read()/write()
Date: Thu, 21 Apr 2016 21:06:56 +0800
Message-Id: <1461244016-7373-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

There's a race condition in the [get|put]_invtrecord() routines, because
a lseek() followed by a read()/write() is not atmoic, the file offset
might be changed before read()/write().

xfs/302 catches this failure as:
xfsdump: drive 1: INV : Unknown version 0 - Expected version 1
xfsdump: inv_core.c:66: get_counters: Assertion `((invt_counter_t *)(*cntpp))->ic_vernum == (inv_version_t) 1' failed.

And it can be reproduced by running multi-stream dump in a tight loop
  mount /dev/<dev> /mnt/xfs
  mkdir /mnt/xfs/dumpdir
  # populate dumpdir here
  while xfsdump -M l1 -M l2 -f d1 -f d2 -L ses /mnt/xfs -s dumpdir; do
  	:
  done

Fix it by replacing the "lseek(); read()/write()" sequence by
pread()/pwrite(), which make the seek and I/O an atomic operation.

Also convert and remove all *_SEEKCUR routines to "SEEK_SET" variants,
because they depend on the maintenance of current file offset, but
pread()/pwrite() don't change file offset.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

Tested via the reproducer and xfstests "-g dump" run, with both v4 and v5 XFS.

I'm not sure if this is the right fix, perhaps what should be fixed is the
"INVLOCK()", which is now implemented by flock(2), and doesn't work in
multi-thread env, if what it's meant to protect is concurrent accesses from
different threads, not processes.

If so, it seems to me that making INVLOCK() a pthread rw lock could fix the
race condition as well. But the INVLOCK calls are almost everywhere, I didn't
find a simple way to try it.

 common/inventory.c   |  4 ++--
 inventory/inv_api.c  |  5 ++---
 inventory/inv_core.c | 24 ++++--------------------
 inventory/inv_idx.c  |  4 ++--
 inventory/inv_priv.h |  9 ---------
 5 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/common/inventory.c b/common/inventory.c
index d1b810c..0e9c256 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -471,8 +471,8 @@ inv_stream_close(
 	}
 			
 	if (dowrite) {
-		rval = PUT_REC_NOLOCK_SEEKCUR( fd, &strm, sizeof( invt_stream_t ),
-					       (off64_t) -(sizeof( invt_stream_t )) );
+		rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
+				      tok->md_stream_off);
 	}
  end:
 	INVLOCK( fd, LOCK_UN );
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index acca40b..46fdde8 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -409,9 +409,8 @@ inv_stream_close(
 		}
 			
 		if (dowrite) {
-			rval = PUT_REC_NOLOCK_SEEKCUR( fd, &strm, 
-			             sizeof( invt_stream_t ),
-				     -(off64_t)(sizeof( invt_stream_t )) );
+			rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
+					      tok->md_stream_off);
 		}
 	}
 
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index a17c2c9..42d0ac4 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -121,19 +121,10 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 	if ( dolock ) 
 		INVLOCK( fd, LOCK_SH );
 
-	if ( lseek( fd, (off_t)off, whence ) < 0 ) {
-		INV_PERROR( _("Error in reading inventory record "
-			      "(lseek failed): ") );
-		if ( dolock ) 
-			INVLOCK( fd, LOCK_UN );
-		return -1;
-	}
-	
-	nread = read( fd, buf, bufsz );
-
+	nread = pread(fd, buf, bufsz, (off_t)off);
 	if (  nread != (int) bufsz ) {
 		INV_PERROR( _("Error in reading inventory record :") );
-		if ( dolock ) 
+		if ( dolock )
 			INVLOCK( fd, LOCK_UN );
 		return -1;
 	}
@@ -162,15 +153,8 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 	if ( dolock )
 		INVLOCK( fd, LOCK_EX );
 	
-	if ( lseek( fd, (off_t)off, whence ) < 0 ) {
-		INV_PERROR( _("Error in writing inventory record "
-			      "(lseek failed): ") );
-		if ( dolock ) 
-			INVLOCK( fd, LOCK_UN );
-		return -1;
-	}
-	
-	if (( nwritten = write( fd, buf, bufsz ) ) != (int) bufsz ) {
+	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
+	if (nwritten != (int) bufsz ) {
 		INV_PERROR( _("Error in writing inventory record :") );
 		if ( dolock )
 			INVLOCK( fd, LOCK_UN );
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 95529e8..cd9b9cb 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -341,8 +341,8 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 			      ent.ie_timeperiod.tp_start,
 			      ent.ie_timeperiod.tp_end );
 #endif
-	rval = PUT_REC_NOLOCK_SEEKCUR( fd, &ent, sizeof( invt_entry_t ),
-				      -(off64_t)(sizeof( invt_entry_t )));
+	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
+			      tok->sd_invtok->d_invindex_off);
 	
 #ifdef INVT_DEBUG
 	{
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 1690271..cd1b527 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -303,9 +303,6 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 #define GET_REC_NOLOCK( fd, buf, sz, off )  \
                  get_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
 
-#define GET_REC_SEEKCUR( fd, buf, sz, off )  \
-                 get_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
-
 #define GET_ALLHDRS_N_CNTS( fd, h, c, hsz, csz ) \
                  get_headerinfo( fd, h, c, hsz, csz, INVT_DOLOCK )
 
@@ -318,12 +315,6 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 #define PUT_REC_NOLOCK( fd, buf, sz, off )  \
                  put_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
 
-#define PUT_REC_SEEKCUR( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
-
-#define PUT_REC_NOLOCK_SEEKCUR( fd, buf, sz, off )  \
-                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DONTLOCK )
-
 
 #define GET_COUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
 					      sizeof(invt_counter_t) )
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

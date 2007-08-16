Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Aug 2007 13:04:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7GK4Gbm005200
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2007 13:04:17 -0700
Message-ID: <46C4A33C.9000701@sandeen.net>
Date: Thu, 16 Aug 2007 14:19:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] (fill-in-the-blank) : missing modes on O_CREAT opens
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>
Cc: Vlad Apostolov <vapo@sgi.com>

F8 now refuses to build anything that does an open("foo", O_CREAT); with
no mode specified... Vlad, could you please fill in the /* mode */
blanks below?  :)  I think I caught them all...

Thanks,

-Eric

Index: xfsdump-2.2.45/inventory/inv_fstab.c
===================================================================
--- xfsdump-2.2.45.orig/inventory/inv_fstab.c
+++ xfsdump-2.2.45/inventory/inv_fstab.c
@@ -96,7 +96,7 @@ fstab_put_entry( uuid_t *fsidp, char *mn
 		if ( errno != ENOENT ) {
 			return -1;
 		}
-		if ((fd = open( INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT ))
+		if ((fd = open( INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, /* mode */ ))
 		    < 0 ) {
 			INV_PERROR ( INV_FSTAB );
 			return -1;
Index: xfsdump-2.2.45/inventory/inv_idx.c
===================================================================
--- xfsdump-2.2.45.orig/inventory/inv_idx.c
+++ xfsdump-2.2.45/inventory/inv_idx.c
@@ -257,7 +257,7 @@ idx_create( char *fname, inv_oflag_t for
 	   the db for SEARCH_ONLY. */
 	ASSERT( forwhat != INV_SEARCH_ONLY );
 
-	if ((fd = open ( fname , INV_OFLAG(forwhat) | O_CREAT ) ) < 0 ) {
+	if ((fd = open ( fname , INV_OFLAG(forwhat) | O_CREAT, /* mode */ ) ) < 0 ) {
 		INV_PERROR ( fname );
 		return INV_TOKEN_NULL;
 	}
Index: xfsdump-2.2.45/inventory/inv_mgr.c
===================================================================
--- xfsdump-2.2.45.orig/inventory/inv_mgr.c
+++ xfsdump-2.2.45/inventory/inv_mgr.c
@@ -692,7 +692,7 @@ invmgr_lockinit( void )
 {
 	if ( invlock_fd == -1 ) {
 		if (( invlock_fd = open( INV_LOCKFILE, 
-					O_RDONLY | O_CREAT )) < 0 ) {
+					O_RDONLY | O_CREAT, /* mode */ )) < 0 ) {
 			INV_PERROR( INV_LOCKFILE );
 			return BOOL_FALSE;
 		}
Index: xfsdump-2.2.45/inventory/inv_oref.c
===================================================================
--- xfsdump-2.2.45.orig/inventory/inv_oref.c
+++ xfsdump-2.2.45/inventory/inv_oref.c
@@ -429,7 +429,7 @@ oref_resolve_new_invidx(
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	if ((fd = open ( fname , O_RDWR | O_CREAT ) ) < 0 ) {
+	if ((fd = open ( fname , O_RDWR | O_CREAT, /* mode */ ) ) < 0 ) {
 		INV_PERROR ( fname );
 		return INV_ERR;
 	}
Index: xfsdump-2.2.45/inventory/inv_stobj.c
===================================================================
--- xfsdump-2.2.45.orig/inventory/inv_stobj.c
+++ xfsdump-2.2.45/inventory/inv_stobj.c
@@ -527,7 +527,7 @@ stobj_create( char *fname )
 #endif	
 
 	/* create the new storage object */
-	if (( fd = open( fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT )) < 0 ) {
+	if (( fd = open( fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, /* mode */ )) < 0 ) {
 		INV_PERROR ( fname );
 		memset( fname, 0, INV_STRLEN );
 		return -1;
@@ -1083,7 +1083,7 @@ stobj_unpack_sessinfo(  
 
 #ifdef INVT_DELETION
 	{
-		int tmpfd = open( "moids", O_RDWR | O_CREAT );	
+		int tmpfd = open( "moids", O_RDWR | O_CREAT, /* mode */ );	
 		u_int j;
 		invt_mediafile_t *mmf = s->mfiles;
 		for (i=0; i< s->ses->s_cur_nstreams; i++ ) {
Index: xfsdump-2.2.45/invutil/invidx.c
===================================================================
--- xfsdump-2.2.45.orig/invutil/invidx.c
+++ xfsdump-2.2.45/invutil/invidx.c
@@ -275,7 +275,7 @@ invidx_commit(WINDOW *win, node_t *curre
 		return 0;
 	    }
 
-	    new_fd = open(dst_idxfile, O_CREAT|O_RDWR);
+	    new_fd = open(dst_idxfile, O_CREAT|O_RDWR, /* mode */);
 	    if(new_fd < 0) {
 		put_error("Error: unable to open inventory index file");
 		return 0;
@@ -616,7 +616,7 @@ stobj_create( char *fname )
     invt_sescounter_t sescnt;
 
     /* create the new storage object */
-    if (( fd = open( fname, O_RDWR | O_EXCL | O_CREAT )) < 0 ) {
+    if (( fd = open( fname, O_RDWR | O_EXCL | O_CREAT, /* mode */ )) < 0 ) {
 	return -1;
     }
     

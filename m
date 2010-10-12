Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9CLqtjS173497 for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 16:52:55 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09C0F3040DB
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 14:54:01 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id D1EAD7001CC4
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 16:54:00 -0500 (CDT)
Message-Id: <20101012215400.639300973@sgi.com>
Date: Tue, 12 Oct 2010 16:53:24 -0500
From: wkendall@sgi.com
Subject: [PATCH 2/2] xfsrestore: change nrh_t to be 64 bits instead of 32
References: <20101012215322.749700656@sgi.com>
Content-Disposition: inline; filename=namreg_64bit
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

An nrh_t refers to a byte offset in a file containing all the pathname
components from a dump. At an average filename length of 20
characters, an nrh_t would overflow on a dump containing ~214 million
directory entries.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

Index: xfsdump-kernel.org/restore/namreg.h
===================================================================
--- xfsdump-kernel.org.orig/restore/namreg.h
+++ xfsdump-kernel.org/restore/namreg.h
@@ -26,8 +26,8 @@
 
 /* nrh_t - handle to a registered name
  */
-typedef size32_t nrh_t;
-#define NRH_NULL	SIZE32MAX
+typedef size64_t nrh_t;
+#define NRH_NULL	SIZE64MAX
 
 
 /* namreg_init - creates the name registry. resync is TRUE if the
Index: xfsdump-kernel.org/restore/namreg.c
===================================================================
--- xfsdump-kernel.org.orig/restore/namreg.c
+++ xfsdump-kernel.org/restore/namreg.c
@@ -72,26 +72,20 @@ typedef struct namreg_tran namreg_tran_t
  */
 #define CHKBITCNT		2
 #define	CHKBITSHIFT		( NBBY * sizeof( nrh_t ) - CHKBITCNT )
-#define	CHKBITLOMASK		( ( 1 << CHKBITCNT ) - 1 )
+#define	CHKBITLOMASK		( ( 1ULL << CHKBITCNT ) - 1 )
 #define	CHKBITMASK		( CHKBITLOMASK << CHKBITSHIFT )
 #define CHKHDLCNT		CHKBITSHIFT
-#define CHKHDLMASK		( ( 1 << CHKHDLCNT ) - 1 )
-#define CHKGETBIT( h )		( ( h >> CHKBITSHIFT ) & CHKBITLOMASK )
-#define CHKGETHDL( h )		( h & CHKHDLMASK )
-#define CHKMKHDL( c, h )	( ( ( c << CHKBITSHIFT ) & CHKBITMASK )	\
+#define CHKHDLMASK		( ( 1ULL << CHKHDLCNT ) - 1 )
+#define CHKGETBIT( h )		( ( (h) >> CHKBITSHIFT ) & CHKBITLOMASK )
+#define CHKGETHDL( h )		( (h) & CHKHDLMASK )
+#define CHKMKHDL( c, h )	( ( ( (c) << CHKBITSHIFT ) & CHKBITMASK )	\
 				  |					\
-				  ( h & CHKHDLMASK ))
+				  ( (h) & CHKHDLMASK ))
 #define HDLMAX			( ( off64_t )CHKHDLMASK )
 
 #else /* NAMREGCHK */
 
-#define HDLMAX			( ( ( off64_t )1			\
-				    <<					\
-				    ( ( off64_t )NBBY			\
-				      *					\
-				      ( off64_t )sizeof( nrh_t )))	\
-				  -					\
-				  ( off64_t )2 ) /* 2 to avoid NRH_NULL */
+#define HDLMAX			( NRH_NULL - 1 )
 
 #endif /* NAMREGCHK */
 
Index: xfsdump-kernel.org/restore/tree.c
===================================================================
--- xfsdump-kernel.org.orig/restore/tree.c
+++ xfsdump-kernel.org/restore/tree.c
@@ -166,19 +166,18 @@ typedef struct tran tran_t;
 #define NODESZ	48
 
 struct node {
-	xfs_ino_t n_ino;		/* 8  8 ino */
-	nrh_t n_nrh;		/* 4 12 handle to name in name registry */
-	dah_t n_dah;		/* 4 16 handle to directory attributes */
-	nh_t n_hashh;		/* 4 20 hash array */
-	nh_t n_parh;		/* 4 24 parent */
-	nh_t n_sibh;		/* 4 28 sibling list */
-	nh_t n_sibprevh;	/* 4 32 prev sibling list - dbl link list */
-	nh_t n_cldh;		/* 4 36 children list */
-	nh_t n_lnkh;		/* 4 40 hard link list */
-	gen_t n_gen;		/* 2 42 generation count mod 0x10000 */
-	u_char_t n_flags;	/* 1 43 action and state flags */
-	u_char_t n_nodehkbyte;	/* 1 44 given to node abstraction */
-	int32_t pad;		/* 4 48 padding to 8 byte boundary */
+	xfs_ino_t n_ino;	/* 8  8 ino */
+	nrh_t n_nrh;		/* 8 16 handle to name in name registry */
+	dah_t n_dah;		/* 4 20 handle to directory attributes */
+	nh_t n_hashh;		/* 4 24 hash array */
+	nh_t n_parh;		/* 4 28 parent */
+	nh_t n_sibh;		/* 4 32 sibling list */
+	nh_t n_sibprevh;	/* 4 36 prev sibling list - dbl link list */
+	nh_t n_cldh;		/* 4 40 children list */
+	nh_t n_lnkh;		/* 4 44 hard link list */
+	gen_t n_gen;		/* 2 46 generation count mod 0x10000 */
+	u_char_t n_flags;	/* 1 47 action and state flags */
+	u_char_t n_nodehkbyte;	/* 1 48 given to node abstraction */
 };
 
 typedef struct node node_t;
@@ -3393,9 +3392,9 @@ Node_free( nh_t *nhp )
 		namreg_del( np->n_nrh );
 		np->n_nrh = NRH_NULL;
 	}
-	if ( np->n_dah != NRH_NULL ) {
+	if ( np->n_dah != DAH_NULL ) {
 		dirattr_del( np->n_dah );
-		np->n_dah = NRH_NULL;
+		np->n_dah = DAH_NULL;
 	}
 	np->n_flags = 0;
 	np->n_parh = NH_NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

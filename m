Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbeK2D7X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:59:23 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A663A405B
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:57:04 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/4] xfsdump: (style) remove trailing whitespaces
Date: Wed, 28 Nov 2018 17:56:46 +0100
Message-Id: <20181128165649.56853-2-jtulak@redhat.com>
In-Reply-To: <20181128165649.56853-1-jtulak@redhat.com>
References: <20181128165649.56853-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Jan Tulak <jtulak@redhat.com>

There were many trailing whitespaces through the whole code. As the rate
of changes in xfsdump is low, it should not cause trouble if we fix it
in all files at once and avoid issues (unintended changes) with sensibly
configured editors that automatically remove these on a file save.

Can be tested with objdump.

Created by this script:

#!/usr/bin/env bash
# remove trailing whitespaces

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/\s*$//" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/arch_xlate.c     |  24 +--
 common/cleanup.c        |   2 +-
 common/cleanup.h        |   2 +-
 common/content.h        |   2 +-
 common/content_inode.h  |   4 +-
 common/dlog.c           |   2 +-
 common/drive.c          |  12 +-
 common/drive.h          |   8 +-
 common/drive_minrmt.c   |  60 +++----
 common/drive_scsitape.c |  70 ++++----
 common/drive_simple.c   |  10 +-
 common/global.c         |   6 +-
 common/global.h         |   4 +-
 common/hsmapi.c         |   2 +-
 common/inventory.c      | 120 +++++++-------
 common/inventory.h      |  46 +++---
 common/main.c           |  20 +--
 common/media.c          |   4 +-
 common/media_rmvtape.h  |   2 +-
 common/mlog.c           |  16 +-
 common/mlog.h           |   2 +-
 common/qlock.c          |  10 +-
 common/rec_hdr.h        |   2 +-
 common/ring.c           |   4 +-
 common/ring.h           |   2 +-
 common/stream.c         |   2 +-
 common/ts_mtio.h        |  60 +++----
 common/types.h          |   2 +-
 common/util.c           |   8 +-
 common/util.h           |   2 +-
 dump/content.c          |  84 +++++-----
 dump/inomap.c           |   6 +-
 inventory/inv_api.c     | 198 +++++++++++------------
 inventory/inv_core.c    |  30 ++--
 inventory/inv_fstab.c   |  58 +++----
 inventory/inv_idx.c     | 128 +++++++--------
 inventory/inv_mgr.c     | 114 ++++++-------
 inventory/inv_oref.c    |  96 +++++------
 inventory/inv_oref.h    |  12 +-
 inventory/inv_priv.h    |  64 ++++----
 inventory/inv_stobj.c   | 344 ++++++++++++++++++++--------------------
 inventory/inventory.h   |  64 ++++----
 inventory/testmain.c    |  80 +++++-----
 invutil/fstab.c         |   6 +-
 invutil/invidx.c        |  50 +++---
 invutil/invutil.c       |  56 +++----
 invutil/menu.c          |   8 +-
 invutil/screen.c        |   2 +-
 invutil/stobj.c         |   6 +-
 librmt/rmtioctl.c       |  34 ++--
 librmt/rmtlib.h         |   2 +-
 restore/bag.c           |   2 +-
 restore/content.c       | 110 ++++++-------
 restore/dirattr.c       |   4 +-
 restore/inomap.c        |   2 +-
 restore/namreg.c        |   4 +-
 restore/node.c          |   2 +-
 restore/tree.c          |  62 ++++----
 58 files changed, 1069 insertions(+), 1069 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 1b8e687..4043a9d 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -135,12 +135,12 @@ xlate_drive_hdr(drive_hdr_t *dh1, drive_hdr_t *dh2, int dir)
 	     "\tdh_pad1 %s\n"
 	     "\tdh_specific %s\n"
 	     "\tdh_upper %s\n",
-	     ptr1->dh_drivecnt,
+	     ptr1->dh_drivecnt,
 	     ptr1->dh_driveix,
 	     ptr1->dh_strategyid,
 	     ptr1->dh_pad1,
 	     ptr1->dh_specific,
-	     ptr1->dh_upper);
+	     ptr1->dh_upper);

 	mlog(MLOG_NITTY, "xlate_drive_hdr: post-xlate\n"
 	     "\tdh_drivecnt %u\n"
@@ -149,12 +149,12 @@ xlate_drive_hdr(drive_hdr_t *dh1, drive_hdr_t *dh2, int dir)
 	     "\tdh_pad1 %s\n"
 	     "\tdh_specific %s\n"
 	     "\tdh_upper %s\n",
-	     ptr2->dh_drivecnt,
+	     ptr2->dh_drivecnt,
 	     ptr2->dh_driveix,
 	     ptr2->dh_strategyid,
 	     ptr2->dh_pad1,
 	     ptr2->dh_specific,
-	     ptr2->dh_upper);
+	     ptr2->dh_upper);
 }

 /*
@@ -416,7 +416,7 @@ xlate_extenthdr(extenthdr_t *eh1, extenthdr_t *eh2, int dir)
 {
 	extenthdr_t *ptr1 = eh1;
 	extenthdr_t *ptr2 = eh2;
-
+
 	mlog(MLOG_NITTY, "xlate_extenthdr\n");

 	IXLATE(eh1, eh2, eh_sz);
@@ -522,7 +522,7 @@ xlate_direnthdr_v1(direnthdr_v1_t *dh1, direnthdr_v1_t *dh2, int dir)
 	     ptr2->dh_gen,
 	     ptr2->dh_sz,
 	     ptr2->dh_checksum,
-	     ptr2->dh_name );
+	     ptr2->dh_name );
 }

 /*
@@ -550,7 +550,7 @@ xlate_rec_hdr(rec_hdr_t *rh1, rec_hdr_t *rh2, int dir)
 	rec_hdr_t *ptr2 = rh2;

 	mlog(MLOG_NITTY, "xlate_rec_hdr\n");
-
+
 	IXLATE(rh1, rh2, magic);
 	IXLATE(rh1, rh2, version);
 	IXLATE(rh1, rh2, blksize);
@@ -569,7 +569,7 @@ xlate_rec_hdr(rec_hdr_t *rh1, rec_hdr_t *rh2, int dir)

 	BXLATE(pad1);
 	BXLATE(dump_uuid);
-	BXLATE(pad2);
+	BXLATE(pad2);

 	mlog(MLOG_NITTY, "xlate_rec_hdr: pre-xlate\n"
 	     "\tmagic %llu\n"
@@ -582,7 +582,7 @@ xlate_rec_hdr(rec_hdr_t *rh1, rec_hdr_t *rh2, int dir)
 	     "\trec_used %u\n"
 	     "\tchecksum %d\n"
 	     "\tischecksum %d\n",
-	     ptr1->magic,
+	     ptr1->magic,
 	     ptr1->version,
 	     ptr1->blksize,
 	     ptr1->recsize,
@@ -604,7 +604,7 @@ xlate_rec_hdr(rec_hdr_t *rh1, rec_hdr_t *rh2, int dir)
 	     "\trec_used %u\n"
 	     "\tchecksum %d\n"
 	     "\tischecksum %d\n",
-	     ptr2->magic,
+	     ptr2->magic,
 	     ptr2->version,
 	     ptr2->blksize,
 	     ptr2->recsize,
@@ -621,7 +621,7 @@ xlate_rec_hdr(rec_hdr_t *rh1, rec_hdr_t *rh2, int dir)
  */
 void
 xlate_invt_seshdr(invt_seshdr_t *ish1, invt_seshdr_t *ish2, int dir)
-{
+{
 	invt_seshdr_t *ptr1 = ish1;
 	invt_seshdr_t *ptr2 = ish2;

@@ -705,7 +705,7 @@ xlate_invt_stream(invt_stream_t *ist1, invt_stream_t *ist2, int dir)
 		ptr1 = ist2;
 		ptr2 = ist1;
 	}
-
+
 	BXLATE(st_cmdarg);
 	BXLATE(st_padding);

diff --git a/common/cleanup.c b/common/cleanup.c
index 523f164..45339c6 100644
--- a/common/cleanup.c
+++ b/common/cleanup.c
@@ -31,7 +31,7 @@ struct cu {

 /* Cleanup structure flags
  */
-#define CU_EARLY	0x00000001
+#define CU_EARLY	0x00000001
 			/* call cleanup routine before calling killall */

 typedef struct cu cu_t;
diff --git a/common/cleanup.h b/common/cleanup.h
index a22a2db..a54f9db 100644
--- a/common/cleanup.h
+++ b/common/cleanup.h
@@ -30,7 +30,7 @@ extern cleanup_t *cleanup_register( void ( *funcp )( void *arg1, void *arg2 ),
 				    void *arg1,
 				    void *arg2 );

-extern cleanup_t *cleanup_register_early(
+extern cleanup_t *cleanup_register_early(
 				    void ( *funcp )( void *arg1, void *arg2 ),
 				    void *arg1,
 				    void *arg2 );
diff --git a/common/content.h b/common/content.h
index 763c09f..c947474 100644
--- a/common/content.h
+++ b/common/content.h
@@ -59,7 +59,7 @@ struct content_hdr {
 		/* content strategy-specific info */
 };

-typedef struct content_hdr content_hdr_t;
+typedef struct content_hdr content_hdr_t;

 #define CONTENT_QUOTAFILE	"xfsdump_quotas"
 #define CONTENT_PQUOTAFILE	"xfsdump_quotas_proj"
diff --git a/common/content_inode.h b/common/content_inode.h
index 6936e05..38ba2a3 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -151,7 +151,7 @@ typedef struct timestruct timestruct_t;
 /* bstat_t - bulk stat structure
  *
  * used in filehdr_t below. derived from xfs_bstat_t, to achieve independence
- * from changes to xfs_bstat_t.
+ * from changes to xfs_bstat_t.
  */
 #define BSTAT_SZ	128
 #define MODE_SZ		4
@@ -209,7 +209,7 @@ bstat_projid(struct bstat *bs)
  *
  * each fs file placed on dump media begins with a FILEHDR_SZ-byte header.
  * following that are one or more variable-length content extents.
- * the content extents contain the actual data associated with the fs file.
+ * the content extents contain the actual data associated with the fs file.
  */
 #define FILEHDR_SZ	256

diff --git a/common/dlog.c b/common/dlog.c
index 032e6f7..77364a3 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -480,7 +480,7 @@ promptinput( char *buf,
 	 */
 	pthread_sigmask( SIG_SETMASK, &orig_set, NULL );
 	sigemptyset( &dlog_registered_sigs );
-
+
 	/* check for timeout or interrupt
 	 */
 	if ( nread < 0 ) {
diff --git a/common/drive.c b/common/drive.c
index 5fe6867..4b0825f 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -64,7 +64,7 @@ static void drive_allochdrs( drive_t *drivep,
 /* definition of locally defined global variables ****************************/

 drive_t **drivepp;
-size_t drivecnt;
+size_t drivecnt;
 size_t partialmax;

 /* definition of locally defined static variables *****************************/
@@ -115,8 +115,8 @@ drive_init1( int argc, char *argv[ ] )

 	/* initialize the partialmax value.  Each drive can be completing a file
 	 * started in another drive (except for drive 0) and leave one file to
-	 * be completed by another drive.  This value is used to limit the
-	 * search in the list of partially completed files shared between all
+	 * be completed by another drive.  This value is used to limit the
+	 * search in the list of partially completed files shared between all
 	 * restore streams.  Note, if drivecnt is one, then partialmax is zero
 	 * to indicate no partial files can span streams.
 	 */
@@ -167,7 +167,7 @@ drive_init1( int argc, char *argv[ ] )

 		drivecnt = 1;

-		/* Adding this alloc to fix malloc corruption.
+		/* Adding this alloc to fix malloc corruption.
 		 * Bug #393618 - prasadb 04/16/97
 		 * allocate an array to hold ptrs to drive descriptors
 		 */
@@ -177,7 +177,7 @@ drive_init1( int argc, char *argv[ ] )
 		drivepp[ 0 ] = drive_alloc( "stdio", 0 );

 #ifdef DUMP   /* ifdef added around dlog_desist() by prasadb to fix 435626 */
-		dlog_desist( );
+		dlog_desist( );
 #endif
 	}

@@ -347,7 +347,7 @@ drive_display_metrics( void )

 /* definition of locally defined static functions ****************************/

-/* drive_alloc - allocate and initialize the generic portions of a drive
+/* drive_alloc - allocate and initialize the generic portions of a drive
  * descriptor. do NOT allocate hdr buffers.
  */
 static drive_t *
diff --git a/common/drive.h b/common/drive.h
index 89b143e..37258e0 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -194,7 +194,7 @@ typedef void ( * drive_mcbfp_t )( void *context_t,
  *
  * caller allocates and passes ptr to do_set_mark, along with a callback func.
  * callback returns the record, which must be freed by the original caller.
- *
+ *
  */
 struct drive_markrec {
 	drive_mark_t dm_log;		/* identifies position within mfile */
@@ -534,7 +534,7 @@ struct drive_ops {
 				/* if d_capabilities has DRIVE_CAP_BSF set,
 				 * drive has the capability to backward space
 				 * count files. returns the number of actual
-				 * files backed to.
+				 * files backed to.
 				 * can only be invoked when not reading or
 				 * writing (i.e., only after calling end_read
 				 * or end_write, or prior to calling begin_read
@@ -594,8 +594,8 @@ typedef struct drive_ops drive_ops_t;
  * valid after drive_init1() returns successfully
  */
 extern drive_t **drivepp;
-extern size_t drivecnt;
-extern size_t partialmax;
+extern size_t drivecnt;
+extern size_t partialmax;

 /* drive capabilities - bit positions in the capabilities mask
  * DO NOT CHANGE: used in dh_capabilities field of scsi drive hdr.
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 32dc404..59a40a7 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -328,12 +328,12 @@ static void calc_max_lost( drive_t *drivep );
 static void display_ring_metrics( drive_t *drivep, int mlog_flags );
 #ifdef CLRMTAUD
 static uint32_t rewind_and_verify( drive_t *drivep );
-static uint32_t erase_and_verify( drive_t *drivep );
+static uint32_t erase_and_verify( drive_t *drivep );
 static uint32_t bsf_and_verify( drive_t *drivep );
 static uint32_t fsf_and_verify( drive_t *drivep );
 #else /* CLRMTAUD */
 static short rewind_and_verify( drive_t *drivep );
-static short erase_and_verify( drive_t *drivep );
+static short erase_and_verify( drive_t *drivep );
 static short bsf_and_verify( drive_t *drivep );
 static short fsf_and_verify( drive_t *drivep );
 #endif /* CLRMTAUD */
@@ -421,7 +421,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 		return -10;
 	}

-	/* Check if the min rmt flag and block size have
+	/* Check if the min rmt flag and block size have
 	 * been specified.
 	 * If so , this is a non-SGI drive and this is the right
 	 * strategy.
@@ -441,7 +441,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 			    cmdlineblksize = ( uint32_t )atoi( optarg );
 		            errno = 0;
 		            fd = open( drivep->d_pathname, O_RDONLY );
-		            if ( fd < 0 )
+		            if ( fd < 0 )
 			            return -10;
 		            close( fd );
 			    break;
@@ -454,12 +454,12 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 		if (minrmt == BOOL_TRUE) {
 			if (cmdlineblksize != 0)
 				return 20;
-		 	else
+		 	else
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					_("Minimal rmt cannot be used without specifying blocksize. Use -%c\n"),
 					GETOPT_BLOCKSIZE );
 		}
-	}
+	}
 	/* catch all */
 	return -10;
 }
@@ -1018,7 +1018,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		currentoffset += ( off64_t )recoff;
 	}
 	assert( wantedoffset >= currentoffset );
-
+
 	/* if we are currently holding a record and the desired offset
 	 * is not within the current record, eat the current record.
 	 */
@@ -1087,7 +1087,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	     wantedoffset - currentoffset >= ( off64_t )tape_recsz ) {
 		off64_t wantedreccnt;
 		seekmode_t seekmode;
-
+
 		assert( ! contextp->dc_recp );
 		wantedreccnt = wantedoffset / ( off64_t )tape_recsz;
 		if ( contextp->dc_singlethreadedpr ) {
@@ -1701,7 +1701,7 @@ do_begin_write( drive_t *drivep )

 	/* intialize header in new record
 	 */
-	rechdrp = (rec_hdr_t*)contextp->dc_recp;
+	rechdrp = (rec_hdr_t*)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
 	rechdrp->file_offset = contextp->dc_reccnt * ( off64_t )tape_recsz;
@@ -1895,7 +1895,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	 */
 	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 	rechdrp->rec_used = tape_recsz;
-
+
 	/* write out the record buffer and get a new one.
 	 */
 	if ( contextp->dc_singlethreadedpr ) {
@@ -2418,7 +2418,7 @@ do_erase( drive_t *drivep )

 	/* use validating tape erase util func
 	 */
-	( void )erase_and_verify( drivep );
+	( void )erase_and_verify( drivep );

 	/* rewind again
 	 */
@@ -2568,7 +2568,7 @@ read_label( drive_t *drivep )
 	 */
 	if ( nread != ( int )tape_recsz ) {
 		assert( nread < ( int )tape_recsz );
-	}
+	}

 	/* check for an unexpected errno
 	 */
@@ -2584,7 +2584,7 @@ read_label( drive_t *drivep )
 	 */
 	if (( nread == 0 )  /* takes care of sun */
 	      ||            /* now handle SGI */
-	      (nread < 0 && saved_errno == ENOSPC )) {
+	      (nread < 0 && saved_errno == ENOSPC )) {
 		mlog( MLOG_NORMAL | MLOG_DRIVE,
 #ifdef DUMP
 		      _("encountered EOD : assuming blank media\n") );
@@ -2883,8 +2883,8 @@ determine_write_error( int nwritten, int saved_errno )

 		ret = DRIVE_ERROR_DEVICE;
 	} else if (
-			( saved_errno == ENOSPC )
-				||
+			( saved_errno == ENOSPC )
+				||
 			( saved_errno == EIO )
 				||
 			(( saved_errno == 0 ) && ( nwritten >= 0 ))  /* short
@@ -2895,7 +2895,7 @@ determine_write_error( int nwritten, int saved_errno )

 		mlog(MLOG_NORMAL,
 			_("no more data can be written to this tape\n") );
-
+
 		ret = DRIVE_ERROR_EOM;
 	} else if ( saved_errno != 0 ) {
 		ret = DRIVE_ERROR_CORE;
@@ -3256,7 +3256,7 @@ prepare_drive( drive_t *drivep )
 			if (3 == try)
 				/* IRIX rmt returns ENOSPC for blank media */
 				/* It reads to the EOD */
-				return DRIVE_ERROR_BLANK;
+				return DRIVE_ERROR_BLANK;
 			else
 				continue;
 #endif
@@ -3277,7 +3277,7 @@ prepare_drive( drive_t *drivep )
 			  "or foreign media\n" );
 			return DRIVE_ERROR_FOREIGN;
 		}
-
+

 		/* if we fell through the seive, code is wrong.
 		 * display useful info and abort
@@ -3338,7 +3338,7 @@ checkhdr:
 					return DRIVE_ERROR_DEVICE;
 				}
 				return DRIVE_ERROR_FOREIGN;
-			}
+			}
 		} else {
 			drive_hdr_t *drhdrp;
 			rec_hdr_t *tprhdrp;
@@ -3351,7 +3351,7 @@ checkhdr:

 largersize:
 		/* we end up here if we want to try a new larger record size
-		 * because the last one was not big enough for the tape block
+		 * because the last one was not big enough for the tape block
 		 */
 		if ( changedblkszpr ) {
 			mlog( MLOG_NORMAL | MLOG_DRIVE,
@@ -3797,7 +3797,7 @@ Ring_get( ring_t *ringp )

 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: get\n" );
-
+
 	msgp = ring_get( ringp );
 	return msgp;
 }
@@ -3808,7 +3808,7 @@ Ring_put(  ring_t *ringp, ring_msg_t *msgp )
 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: put %d\n",
 	      msgp->rm_op );
-
+
 	ring_put( ringp, msgp );
 }

@@ -3817,7 +3817,7 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
 {
 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: reset\n" );
-
+
 	assert( ringp );

 	ring_reset( ringp, msgp );
@@ -3847,7 +3847,7 @@ display_ring_metrics( drive_t *drivep, int mlog_flags )
 	ring_t *ringp = contextp->dc_ringp;
 	char bufszbuf[ 16 ];
 	char *bufszsfxp;
-
+
 	if ( tape_recsz == STAPE_MIN_MAX_BLKSZ ) {
 		assert( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
 		sprintf( bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400 );
@@ -3899,7 +3899,7 @@ rewind_and_verify( drive_t *drivep )
 		if ( rval ) {
 			sleep( 1 );
 			rval = mt_op( contextp->dc_fd, MTREW, 0 );
-		} else
+		} else
 			return 0;

 		if ( try >= MTOP_TRIES_MAX ) {
@@ -3915,7 +3915,7 @@ static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
-erase_and_verify( drive_t *drivep )
+erase_and_verify( drive_t *drivep )
 {
 	char *tempbufp;
 	int saved_errno;
@@ -3927,7 +3927,7 @@ erase_and_verify( drive_t *drivep )

 	/* Erase is not standard rmt. So we cannot use the line below.

-	( void )mt_op( contextp->dc_fd, MTERASE, 0 );
+	( void )mt_op( contextp->dc_fd, MTERASE, 0 );

 	 * So write a record of zeros to fake erase . Poor man's erase!
 	 * We put the ERASE_MAGIC string at the beginning so we can
@@ -3974,9 +3974,9 @@ set_best_blk_and_rec_sz( drive_t *drivep )
 	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;

 	if ( contextp->dc_isQICpr == BOOL_TRUE )
-		tape_recsz = STAPE_MIN_MAX_BLKSZ;
+		tape_recsz = STAPE_MIN_MAX_BLKSZ;
 	else
-		tape_recsz = cmdlineblksize;
+		tape_recsz = cmdlineblksize;

 	return BOOL_TRUE;
 }
@@ -4000,6 +4000,6 @@ isxfsdumperasetape( drive_t *drivep )
 {
 	if ( !strcmp( ( char * )drivep->d_greadhdrp, ERASE_MAGIC ) )
 		return BOOL_TRUE;
-	else
+	else
 		return BOOL_FALSE;
 }
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 56b8c2d..c360f9c 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -459,7 +459,7 @@ is_scsi_driver(char *pathname)
 	int dev_major;

 	if (realpath(pathname, rp) == NULL) {
-		return BOOL_FALSE;
+		return BOOL_FALSE;
 	}

 	if ( stat64( pathname, &statbuf ) == -1) {
@@ -497,7 +497,7 @@ is_scsi_driver(char *pathname)
 		return BOOL_TRUE;
 	}
 	else if (dev_major == get_driver_character_major("ts") ||
-	         dev_major == get_driver_character_major("tmf")) {
+	         dev_major == get_driver_character_major("tmf")) {
 		TS_ISDRIVER = 1;
 		return BOOL_TRUE;
 	}
@@ -1131,7 +1131,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		currentoffset += ( off64_t )recoff;
 	}
 	assert( wantedoffset >= currentoffset );
-
+
 	/* if we are currently holding a record and the desired offset
 	 * is not within the current record, eat the current record.
 	 */
@@ -1200,7 +1200,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	     wantedoffset - currentoffset >= ( off64_t )tape_recsz ) {
 		off64_t wantedreccnt;
 		seekmode_t seekmode;
-
+
 		assert( ! contextp->dc_recp );
 		wantedreccnt = wantedoffset / ( off64_t )tape_recsz;
 		if ( contextp->dc_singlethreadedpr ) {
@@ -1851,7 +1851,7 @@ do_begin_write( drive_t *drivep )

 	/* intialize header in new record
 	 */
-	rechdrp = (rec_hdr_t*)contextp->dc_recp;
+	rechdrp = (rec_hdr_t*)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
 	rechdrp->file_offset = contextp->dc_reccnt * ( off64_t )tape_recsz;
@@ -2045,7 +2045,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	 */
 	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 	rechdrp->rec_used = tape_recsz;
-
+
 	/* write out the record buffer and get a new one.
 	 */
 	if ( contextp->dc_singlethreadedpr ) {
@@ -2763,7 +2763,7 @@ do_quit( drive_t *drivep )
 	     &&
 	     ! contextp->dc_isQICpr
 	     &&
-	     contextp->dc_cansetblkszpr
+	     contextp->dc_cansetblkszpr
 	     &&
 	     ( contextp->dc_origcurblksz != 0 ) ) {
 		( void )set_fixed_blksz( drivep, contextp->dc_origcurblksz );
@@ -2804,7 +2804,7 @@ percent64( off64_t num, off64_t denom )
  * in IRIX and Linux.
  * The 1st read() below is made prior to calling read_label().
  * The 2nd read() is the one made inside read_label().
- * Extraneous status flags, such as online, are not mentioned.
+ * Extraneous status flags, such as online, are not mentioned.
  *
  * -----------------------------------------
  * Full tape (incomplete dump - over >1 tapes)
@@ -2818,16 +2818,16 @@ percent64( off64_t num, off64_t denom )
  *    read->-1 (ENOSPC) <eod, ew>
  * -----------------------------------------
  * Partial tape (complete dump - just 1 tape)
- *
+ *
  * Linux
  *    read->0 <fmk>
  *    read->0 <eod>
- *
+ *
  * IRIX
  *    read->0 <fmk>
  *    read->-1 (ENOSPC) <eod>
  * -----------------------------------------
- */
+ */


 static int
@@ -3166,7 +3166,7 @@ set_fixed_blksz( drive_t *drivep, size_t blksz )
                 /* issue call to set block size
                  */
                 if ( mt_op( contextp->dc_fd,
-                            MTSETBLK,
+                            MTSETBLK,
                             ( int )blksz ) ) {
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
 			      "MTSETBLK %u failed: %s (%d)\n",
@@ -3265,7 +3265,7 @@ Need to find equivalent in Linux.
 			}
 #endif
 		}
-	}
+	}

 	set_recommended_sizes( drivep );

@@ -3317,7 +3317,7 @@ set_recommended_sizes( drive_t *drivep )
 /* mt_blkinfo
  *	In IRIX, issue MTIOGETBLKINFO ioctl operation to the tape device.
  *      There is no equivalent call in Linux at the moment.
- *      However, the minblks and maxblks are stored internally in
+ *      However, the minblks and maxblks are stored internally in
  *      the scsi/st.c driver and may be exported in the future.
  *      The current blk size comes from the mt_dsreg field.
  *
@@ -3453,7 +3453,7 @@ mt_op(int fd, int sub_op, int param )

 static bool_t
 mt_get_fileno( drive_t *drivep, long *fileno)
-{
+{
 	struct mtget 	mt_stat;
 	drive_context_t *contextp;

@@ -3532,8 +3532,8 @@ mt_get_status( drive_t *drivep, long *status)
 	*status = mt_stat.mt_gstat;

 	/* print out symbolic form of tape status */
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-		"tape status = %s%s%s%s%s%s%s\n",
+	mlog( MLOG_DEBUG | MLOG_DRIVE,
+		"tape status = %s%s%s%s%s%s%s\n",
 		IS_BOT(*status)?   "bot ":"",
 		IS_FMK(*status)?   "fmk ":"",
 		IS_EOD(*status)?   "eod ":"",
@@ -4037,7 +4037,7 @@ retry:
 	 * and the record size we tried initially was not less than
 	 * the minmax block size, change the block size to minmax and
 	 * try to read a one block record again.
-	 *
+	 *
 	 * **************
 	 * LINUX WARNING:
 	 * **************
@@ -4265,7 +4265,7 @@ retry:

 		if ( nread == 0
 		     &&
-		     ! contextp->dc_isvarpr
+		     ! contextp->dc_isvarpr
 		     &&
 		     IS_EOD( mtstat )
 		     &&
@@ -4284,7 +4284,7 @@ retry:

 		if ( nread == 0
 		     &&
-		     ! contextp->dc_isvarpr
+		     ! contextp->dc_isvarpr
 		     &&
 		     IS_EOD( mtstat )
 		     &&
@@ -4302,7 +4302,7 @@ retry:

 		if ( nread == 0
 		     &&
-		     ! contextp->dc_isvarpr
+		     ! contextp->dc_isvarpr
 		     &&
 		     IS_EOT( mtstat )
 		     &&
@@ -4320,7 +4320,7 @@ retry:

 		if ( nread == 0
 		     &&
-		     ! contextp->dc_isvarpr
+		     ! contextp->dc_isvarpr
 		     &&
 		     ! IS_EOD( mtstat )
 		     &&
@@ -4433,7 +4433,7 @@ retry:
 			  "indicates wrong blocksize\n" );
 			goto newsize;
 		}
-
+
 		if ( nread == ( int )tape_recsz
 		     &&
 		     ! contextp->dc_isvarpr ) {
@@ -4485,7 +4485,7 @@ retry:
 		    mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_DRIVE,
 			_("either try using a smaller block size with "
 			"the -b option, or increase max_sg_segs for "
-			"the scsi tape driver\n"));
+			"the scsi tape driver\n"));
 		}


@@ -4544,7 +4544,7 @@ checkhdr:
 			tape_recsz = ( size_t )tprhdrp->recsize;
 			mlog( MLOG_DEBUG | MLOG_DRIVE,
 			      "tape record size set to header's "
-			      "record size = %d\n", tape_recsz);
+			      "record size = %d\n", tape_recsz);
 			break;
 		}

@@ -4589,7 +4589,7 @@ newsize:

 largersize:
 		/* we end up here if we want to try a new larger record size
-		 * because the last one was not big enough for the tape block
+		 * because the last one was not big enough for the tape block
 		 */
 		if ( changedblkszpr ) {
 			mlog( MLOG_NORMAL | MLOG_DRIVE,
@@ -5077,7 +5077,7 @@ Ring_get( ring_t *ringp )

 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: get\n" );
-
+
 	msgp = ring_get( ringp );
 	return msgp;
 }
@@ -5088,7 +5088,7 @@ Ring_put(  ring_t *ringp, ring_msg_t *msgp )
 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: put %d\n",
 	      msgp->rm_op );
-
+
 	ring_put( ringp, msgp );
 }

@@ -5097,7 +5097,7 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
 {
 	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: reset\n" );
-
+
 	assert( ringp );

 	ring_reset( ringp, msgp );
@@ -5127,7 +5127,7 @@ display_ring_metrics( drive_t *drivep, int mlog_flags )
 	ring_t *ringp = contextp->dc_ringp;
 	char bufszbuf[ 16 ];
 	char *bufszsfxp;
-
+
 	if ( tape_recsz == STAPE_MIN_MAX_BLKSZ ) {
 		assert( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
 		sprintf( bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400 );
@@ -5178,7 +5178,7 @@ rewind_and_verify( drive_t *drivep )
 	for ( try = 1 ; ; try++ ) {
 		mtstat_t mtstat;
 		bool_t ok;
-
+
 		if ( rval ) {
 			sleep( 1 );
 			rval = mt_op( contextp->dc_fd, MTREW, 0 );
@@ -5233,7 +5233,7 @@ bsf_and_verify( drive_t *drivep )
 		( void )mt_op( contextp->dc_fd, MTBSF, 1 );
 		for ( try = 1 ; ; try++ ) {
 			mtstat_t mtstat;
-
+
 			ok = mt_get_status( drivep, &mtstat );
 			if ( ! ok ) {
 				mtstat = 0;
@@ -5286,7 +5286,7 @@ status:		ok = mt_get_status( drivep, &mtstat );
 				return 0;
 			}
 			try++;
-			sleep( 1 );
+			sleep( 1 );
 			goto status;
 		}
 		return mtstat;
@@ -5304,7 +5304,7 @@ fsf_and_verify( drive_t *drivep )
 	for ( try = 1 ; ; try++ ) {
 		mtstat_t mtstat;
 		bool_t ok;
-
+
 		ok = mt_get_status( drivep, &mtstat );
 		if ( ! ok ) {
 			mtstat = 0;
@@ -5394,7 +5394,7 @@ isefsdump( drive_t *drivep )
  * General purpose routine which dredges through procfs trying to
  * match up device driver names with the associated major numbers
  * being used in the running kernel. (This routine is based on
- * the get_driver_block_major() routine in the libdisk library.)
+ * the get_driver_block_major() routine in the libdisk library.)
  */
 static int
 get_driver_character_major( const char *driver )
diff --git a/common/drive_simple.c b/common/drive_simple.c
index b4e41da..54a3058 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -342,7 +342,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 			      drivep->d_pathname,
 			      strerror( errno ));
 			return BOOL_FALSE;
-
+
 		}
 		oflags = O_RDONLY;
 		switch( statbuf.st_mode & S_IFMT ) {
@@ -495,7 +495,7 @@ do_begin_read( drive_t *drivep )
 		return rval;
 	}
 	assert( ( size_t )nread == GLOBAL_HDR_SZ );
-
+
 	mlog(MLOG_NITTY, "do_begin_read: global_hdr\n"
 	     "\tgh_magic %.100s\n"
 	     "\tgh_version %u\n"
@@ -771,7 +771,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	if ( strmoff > mark ) {
 		return DRIVE_ERROR_CORE;
 	}
-
+
 	/* use read_buf util func to eat up difference
 	 */
 	nreadneeded64 = mark - strmoff;
@@ -897,7 +897,7 @@ do_begin_write( drive_t *drivep )
 	/* indicate in the header that there is no recorded mark.
 	 */
 	*( ( off64_t * )dwhdrp->dh_specific ) = 0;
-
+
 	/* prepare the drive context. initially the caller does not own
 	 * any of the write buffer, so the next portion of the buffer to
 	 * be supplied is the top of the buffer. emptyp never changes;
@@ -1491,7 +1491,7 @@ do_erase( drive_t *drivep )
 /* get_media_class()
  */
 /* ARGSUSED */
-static int
+static int
 do_get_device_class( drive_t *drivep )
 {
 	mlog( MLOG_NITTY | MLOG_DRIVE,
diff --git a/common/global.c b/common/global.c
index e70b8a0..73efd55 100644
--- a/common/global.c
+++ b/common/global.c
@@ -163,7 +163,7 @@ global_hdr_alloc( int argc, char *argv[ ] )
                                 usage( );
                                 return 0;
                         }
-
+
 			if ( ! uuid_parse( optarg, ghdrp->gh_dumpid ) ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR,
 				      _("-%c argument not a valid uuid\n"),
@@ -275,10 +275,10 @@ global_hdr_checksum_check( global_hdr_t *hdrp )
 	return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
 }

-/* global_version_check - if we know this version number, return BOOL_TRUE
+/* global_version_check - if we know this version number, return BOOL_TRUE
  * else return BOOL_FALSE
  */
-bool_t
+bool_t
 global_version_check( uint32_t version )
 {
 	switch (version) {
diff --git a/common/global.h b/common/global.h
index 0b738de..53351a1 100644
--- a/common/global.h
+++ b/common/global.h
@@ -32,7 +32,7 @@
 	 * version 2 adds encoding of holes and a change to on-tape inventory format.
 	 * version 1 adds extended file attribute dumping.
 	 * version 0 xfsrestore can't handle media produced
-	 * by version 1 xfsdump.
+	 * by version 1 xfsdump.
 	 */
 #define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_3

@@ -93,7 +93,7 @@ extern void global_hdr_checksum_set( global_hdr_t *hdrp );
  */
 extern bool_t global_hdr_checksum_check( global_hdr_t *hdrp );

-/* global_version_check - if we know this version number, return BOOL_TRUE
+/* global_version_check - if we know this version number, return BOOL_TRUE
  * else return BOOL_FALSE
  */

diff --git a/common/hsmapi.c b/common/hsmapi.c
index 0709dbe..7a3584d 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -528,7 +528,7 @@ const	xfs_bstat_t	*statp)
 		dmf_f_ctxtp->candidate = 1;
 		dmf_f_ctxtp->filesize = statp->bs_size;
 		break;
-
+
 	default:
 		break;
 	}
diff --git a/common/inventory.c b/common/inventory.c
index 0e9c256..552f594 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -50,9 +50,9 @@ inv_open( inv_predicate_t bywhat, void *pred )
 	char uuname[ INV_STRLEN ];
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
 	invt_sescounter_t *sescnt = 0;
-
+
 	int index = 0;
-
+
 	assert ( pred );
 	if ((fd = init_idb ( pred, bywhat, uuname, &tok )) < 0 )
 		return tok;
@@ -86,9 +86,9 @@ inv_open( inv_predicate_t bywhat, void *pred )
 		printf("$ creating a new storage obj & index entry. \n" );
 #endif
 		close (stobjfd);
-
+
 		stobjfd = create_invindex_entry( &tok, fd, uuname, BOOL_FALSE );
-		free ( sescnt );
+		free ( sescnt );
 		if ( stobjfd < 0 ) {
 			close( fd );
 			close( sesslock_fd );
@@ -97,13 +97,13 @@ inv_open( inv_predicate_t bywhat, void *pred )
 		}
 		return tok;
 	}
-
+
 	free ( sescnt );
 	tok = get_token( fd, stobjfd );
 	tok->d_invindex_off = INVINDEX_HDR_OFFSET( index - 1 );
-
+
 	return tok;
-
+
 }


@@ -124,7 +124,7 @@ inv_close( inv_idbtoken_t tok )
 	destroy_token( tok );
 	close( sesslock_fd );
 	sesslock_fd = -1;
-
+
 	return BOOL_TRUE;
 }

@@ -141,7 +141,7 @@ inv_close( inv_idbtoken_t tok )
 /*----------------------------------------------------------------------*/

 bool_t
-inv_lasttime_level_lessthan(
+inv_lasttime_level_lessthan(
 	inv_idbtoken_t  tok,
 	u_char level,
 	time32_t **tm )
@@ -166,7 +166,7 @@ inv_lasttime_level_lessthan(
 /*----------------------------------------------------------------------*/

 bool_t
-inv_lastsession_level_lessthan(
+inv_lastsession_level_lessthan(
 	inv_idbtoken_t 	tok,
 	u_char		level,
 	inv_session_t 	**ses )
@@ -174,7 +174,7 @@ inv_lastsession_level_lessthan(
 	int 	rval;
 	assert ( tok != INV_TOKEN_NULL );

-	rval = search_invt( tok, level, (void **) ses,
+	rval = search_invt( tok, level, (void **) ses,
 			  (search_callback_t) lastsess_level_lessthan );

 	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
@@ -193,14 +193,14 @@ inv_lastsession_level_lessthan(


 bool_t
-inv_lastsession_level_equalto(
-	inv_idbtoken_t 	tok,
+inv_lastsession_level_equalto(
+	inv_idbtoken_t 	tok,
 	u_char		level,
 	inv_session_t	**ses )
 {
 	int 	rval;
 	assert ( tok != INV_TOKEN_NULL );
-	rval = search_invt( tok, level, (void **) ses,
+	rval = search_invt( tok, level, (void **) ses,
 			  (search_callback_t) lastsess_level_equalto );

 	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
@@ -220,7 +220,7 @@ inv_lastsession_level_equalto(
 /*----------------------------------------------------------------------*/

 inv_sestoken_t
-inv_writesession_open(
+inv_writesession_open(
 	inv_idbtoken_t tok, 	/* token obtained by inventory_open() */
 	uuid_t		*fsid,
 	uuid_t		*sesid,
@@ -256,25 +256,25 @@ inv_writesession_open(
 	/* copy the session information to store */
 	memcpy( &ses->s_sesid, sesid, sizeof( uuid_t ) );
 	memcpy( &ses->s_fsid, fsid, sizeof( uuid_t ) );
-	strcpy( ses->s_label, label );
-	strcpy( ses->s_mountpt, mntpt );
-	strcpy( ses->s_devpath, devpath );
+	strcpy( ses->s_label, label );
+	strcpy( ses->s_mountpt, mntpt );
+	strcpy( ses->s_devpath, devpath );
 	ses->s_max_nstreams = nstreams;


 	/* s_curstream_off will be set in create_session() */

 	fd = tok->d_stobj_fd;
-
+
 	assert ( fd > 0 );

 	hdr.sh_time = time;
-	hdr.sh_level = level;
+	hdr.sh_level = level;
 	/* sh_streams_off and sh_sess_off will be set in create_session() */
-
+
 	sestok = get_sesstoken( tok );

-	/* we need to put the new session in the appropriate place in
+	/* we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */

 	INVLOCK( fd, LOCK_EX );
@@ -285,14 +285,14 @@ inv_writesession_open(
 		return INV_TOKEN_NULL;
 	}

-	/* create the writesession, and get ready for the streams to come
+	/* create the writesession, and get ready for the streams to come
 	   afterwards */
 	rval = create_session( sestok, fd, sescnt, ses, &hdr );
 	assert (rval > 0);


 	INVLOCK( fd, LOCK_UN );
-
+
 	sestok->sd_sesstime = time;

 	if ( tok->d_update_flag & NEW_INVINDEX ) {
@@ -325,7 +325,7 @@ bool_t
 inv_writesession_close( inv_sestoken_t tok )
 {
 	int		rval;
-
+
 	assert ( tok != INV_TOKEN_NULL );

 	/* now update end_time in the inv index header */
@@ -357,22 +357,22 @@ inv_stream_open(
 	int fd;

 	assert ( tok != INV_TOKEN_NULL );
-
+
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_FALSE;

-
+
 	/* XXX yukk... make the token descriptors not pointers */
 	stok = ( inv_stmtoken_t ) malloc( sizeof( invt_strdesc_entry_t ) );
-
+
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
-
+
 	/* get the session to find out where the stream is going to go */
-	fd = tok->sd_invtok->d_stobj_fd;
+	fd = tok->sd_invtok->d_stobj_fd;

 	sess_lock();
-
+
 	INVLOCK( fd, LOCK_SH );
 	/* get the session header first */
 	if ( GET_REC_NOLOCK( fd, &seshdr, sizeof( invt_seshdr_t ),
@@ -397,13 +397,13 @@ inv_stream_open(

 	if ( ses.s_cur_nstreams < ses.s_max_nstreams ) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
+		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
 					         ses.s_cur_nstreams )
 			                         + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
-
+
 		/* write it back. this locks and unlocks fd EXclusively */
-		if ( PUT_REC( fd, &ses, sizeof( ses ),
+		if ( PUT_REC( fd, &ses, sizeof( ses ),
 			      tok->sd_session_off ) < 0 ) {
 			free ( stok );
 			sess_unlock();
@@ -419,7 +419,7 @@ inv_stream_open(
 	sess_unlock();

 	stream.st_firstmfile = stream.st_lastmfile = stok->md_stream_off;
-
+
 	/* now put the stream header on to the disk */
 	if ( PUT_REC( fd, &stream, sizeof( invt_stream_t ),
 		      stok->md_stream_off ) < 0 ) {
@@ -450,16 +450,16 @@ inv_stream_close(
 	bool_t dowrite = BOOL_FALSE;

 	INVLOCK( fd, LOCK_EX );
-	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
+	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
 			       tok->md_stream_off )) < 0 )
 		goto end;   /* eek :-)   */
-
+
 	if ( strm.st_interrupted != wasinterrupted ) {
 		strm.st_interrupted = wasinterrupted;
 		dowrite = BOOL_TRUE;
 	}

-	/* get the last media file to figure out what our last ino was.
+	/* get the last media file to figure out what our last ino was.
 	   we have a pointer to that in the stream token */
 	if ( tok->md_lastmfile ){
 		if ( strm.st_endino.ino != tok->md_lastmfile->mf_endino.ino ||
@@ -469,7 +469,7 @@ inv_stream_close(
 			strm.st_endino = tok->md_lastmfile->mf_endino;
 		}
 	}
-
+
 	if (dowrite) {
 		rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
 				      tok->md_stream_off);
@@ -483,7 +483,7 @@ inv_stream_close(

 	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
 }
-
+



@@ -494,9 +494,9 @@ inv_stream_close(
 /*----------------------------------------------------------------------*/

 bool_t
-inv_put_mediafile(
-	inv_stmtoken_t 	tok,
-	uuid_t 		*moid,
+inv_put_mediafile(
+	inv_stmtoken_t 	tok,
+	uuid_t 		*moid,
 	char 		*label,
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
@@ -512,15 +512,15 @@ inv_put_mediafile(
 	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );

 	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
-
+
 	/* copy the media file information */
 	memcpy( &mf->mf_moid, moid, sizeof( uuid_t ) );
-	strcpy( mf->mf_label, label );
+	strcpy( mf->mf_label, label );
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
 	mf->mf_endino.ino = endino;
 	mf->mf_endino.offset = endino_offset;
-
+
 	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX );
 	rval = put_mediafile( tok, mf );
 	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN );
@@ -555,30 +555,30 @@ inv_get_inolist(
 	invt_entry_t	*iarr = NULL;
 	invt_counter_t	*icnt = NULL;
 	int	     	nindices, i;
-	struct stat64	statbuf;
+	struct stat64	statbuf;
 	inv_inolist_t 	*curitem;

-#ifdef NOTDEF
+#ifdef NOTDEF
 	*inolist = NULL;
 	curitem = malloc( sizeof( inv_inolist_t ) );
-
+
 	/* get the array of all indices in the invindex */
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
-					      (void **)&icnt,
+	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+					      (void **)&icnt,
 					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
+					      sizeof( invt_counter_t ))
 	      ) <= 0 ) {
 		return -1;
 	}
 	free( icnt );
-
+
 	/* attach all the StObjs */
 	for (i = nindices - 1; i >= 0; i--) {
 		if ( stat64( iarr[i].ie_filename, &statbuf ) < 0 ) {
 			perror( iarr[i].ie_filename );
 			return -1;
 		}
-
+
 		create_inolist_item( curitem, statbuf.st_ino );
 	}
 	/* The inventory index */
@@ -594,7 +594,7 @@ inv_get_inolist(
 			return -1;
 		}
 	create_inolist_item( curitem, statbuf.st_ino );
-
+
 	/* sesslock file */
 	if ( stat64( SESSLOCK_FILE, &statbuf ) < 0 ) {
 			perror( SESSLOCK_FILE );
@@ -604,7 +604,7 @@ inv_get_inolist(
 #endif

 	return 1;
-
+
 }


@@ -634,7 +634,7 @@ inv_get_session(

 	/* First get the session header, and the session information. Then
 	   we can figure out how much space to allocate */
-
+
 }


@@ -644,12 +644,12 @@ inv_get_session(

 /* This prints out all the sessions of a filesystem that are in the inventory */
 bool_t
-inv_DEBUG_printallsessions(
-	inv_idbtoken_t 	tok,
+inv_DEBUG_printallsessions(
+	inv_idbtoken_t 	tok,
 	inv_session_t	**ses )
 {
 	int 	rval;
-	rval = search_invt( tok, 0, (void **) ses,
+	rval = search_invt( tok, 0, (void **) ses,
 			  (search_callback_t) DEBUG_displayallsessions );

 	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
diff --git a/common/inventory.h b/common/inventory.h
index f9fcb19..d5c182a 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -28,8 +28,8 @@
  * knowledge of the functionalities, some abstractions, and even typical queries
  * of dump() and restore() and uses this knowledge in formulating its storage
  * structure on disk. All these things, of course, are completely abstract with
- * respect to the clients of the inventory.
- *
+ * respect to the clients of the inventory.
+ *
  */

 #define INV_DIRPATH		inv_dirpath()
@@ -76,7 +76,7 @@ typedef enum {

 typedef struct inv_stream {
 	bool_t		st_interrupted;	/* was this stream interrupted ? */
-
+
 	/* duplicate info from mediafiles for speed */
 	xfs_ino_t	st_startino;	/* the starting pt */
 	off64_t		st_startino_off;
@@ -88,11 +88,11 @@ typedef struct inv_stream {
 } inv_stream_t;


-/*
- * inventory_session_t
+/*
+ * inventory_session_t
  * all the information that is kept on a single dump session of a single
  * file system in the inventory.
- *
+ *
  */

 typedef struct inv_session {
@@ -107,8 +107,8 @@ typedef struct inv_session {
 	char		 s_mountpt[INV_STRLEN];/* path to the mount point */
 	char		 s_devpath[INV_STRLEN];/* path to the device */
 } inv_session_t;
-
-
+
+
 /* Is there anything else that you need here, Chuck? */
 typedef struct inv_mediafile {
 	uuid_t		 m_moid;	/* media object id */
@@ -142,13 +142,13 @@ typedef struct invt_strdesc_entry	*inv_stmtoken_t;
 /* inventory_open - initializes access to the inventory
  */
 extern inv_idbtoken_t
-inv_open(
-	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
+inv_open(
+	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
 	 void 		 *pred );/* uuid_t *,char * mntpt, or char *dev */


 extern bool_t
-inv_close(
+inv_close(
 	inv_idbtoken_t tok );


@@ -165,7 +165,7 @@ inv_writesession_open(
 	char		*devpath );

 extern bool_t
-inv_writesession_close(
+inv_writesession_close(
 	inv_sestoken_t  tok );

 extern inv_stmtoken_t
@@ -178,9 +178,9 @@ inv_stream_close(
 	bool_t 		wasinterrupted );

 extern bool_t
-inv_put_mediafile(
-	inv_stmtoken_t 	tok,
-	uuid_t 		*moid,
+inv_put_mediafile(
+	inv_stmtoken_t 	tok,
+	uuid_t 		*moid,
 	char 		*label,
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
@@ -190,23 +190,23 @@ inv_put_mediafile(
 /* lasttime_level_lessthan - finds the time of the last dump of the
  * specified file system at a level less than the specified level.
  * if never dumped below the current level, *time is set to NULL.
- *
+ *
  */
 extern bool_t
-inv_lasttime_level_lessthan(
+inv_lasttime_level_lessthan(
 	inv_idbtoken_t 		tok,
 	u_char  		level,
 	time32_t		**time );/* out */

 extern bool_t
-inv_lastsession_level_lessthan(
-	inv_idbtoken_t 		tok,
+inv_lastsession_level_lessthan(
+	inv_idbtoken_t 		tok,
 	u_char  		level,
 	inv_session_t		**ses );/* out */

 extern bool_t
-inv_lastsession_level_equalto(
-	inv_idbtoken_t 		tok,
+inv_lastsession_level_equalto(
+	inv_idbtoken_t 		tok,
 	u_char  		level,
 	inv_session_t		**ses );/* out */

@@ -231,8 +231,8 @@ inv_put_session(
 #ifdef DEBUG

 bool_t
-inv_DEBUG_printallsessions(
-	inv_idbtoken_t 	tok,
+inv_DEBUG_printallsessions(
+	inv_idbtoken_t 	tok,
 	inv_session_t	**ses );

 #endif /* ifdef DEBUG */
diff --git a/common/main.c b/common/main.c
index d3bdcf3..b3605d1 100644
--- a/common/main.c
+++ b/common/main.c
@@ -204,7 +204,7 @@ main( int argc, char *argv[] )
 	if ( ! ok ) {
 		return mlog_exit(EXIT_ERROR, RV_OPT);
 	}
-
+
 	/* initialize message logging (stage 1)
 	 */
 	ok = mlog_init1( argc, argv );
@@ -698,7 +698,7 @@ main( int argc, char *argv[] )
 			prbcld_xc = xc;
 			stop_requested = BOOL_TRUE;
 		}
-
+
 		/* all children died normally. break out.
 		 */
 		if ( cldmgr_remainingcnt( ) == 0 ) {
@@ -743,7 +743,7 @@ main( int argc, char *argv[] )
 				}
 				stop_timeout = STOP_TIMEOUT;
 			}
-
+
 			/* important that this appear after dialog.
 			 * allows dialog to be terminated with SIGINT,
 			 * without infinite loop.
@@ -793,7 +793,7 @@ main( int argc, char *argv[] )
 				coredump_requested = BOOL_TRUE;
 			}
 		}
-
+
 		/* see if need to initiate a stop
 		 */
 		if ( stop_requested && ! stop_in_progress ) {
@@ -806,7 +806,7 @@ main( int argc, char *argv[] )
 			assert( stop_timeout >= 0 );
 			stop_deadline = now + ( time32_t )stop_timeout;
 		}
-
+
 		/* set alarm if needed (note time stands still during dialog)
 		 */
 		if ( stop_in_progress ) {
@@ -1381,7 +1381,7 @@ loadoptfile( int *argcp, char ***argvp )
 	return BOOL_TRUE;
 }

-/* parent and children share this handler.
+/* parent and children share this handler.
  */
 static void
 sighandler( int signo )
@@ -2012,7 +2012,7 @@ sigintstr( void )
 		      strerror( errno ));
 		return 0;
 	}
-
+
 	intchr = termios.c_cc[ VINTR ];
 	mlog( MLOG_NITTY | MLOG_PROC,
 	      "tty fd: %d; terminal interrupt character: %c (0%o)\n",
@@ -2071,7 +2071,7 @@ set_rlimits( size64_t *vmszp )

 	vmsz = ( size64_t )rlimit64.rlim_cur;
 #endif /* RESTORE */
-
+
 	assert( minstacksz <= maxstacksz );
 	rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
 	assert( ! rval );
@@ -2175,7 +2175,7 @@ set_rlimits( size64_t *vmszp )
 	      "RLIMIT_DATA org cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
 	      rlimit64.rlim_max );
-
+
 	rval = getrlimit64( RLIMIT_FSIZE, &rlimit64 );
 	assert( ! rval );
 	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
@@ -2192,7 +2192,7 @@ set_rlimits( size64_t *vmszp )
 	      "RLIMIT_FSIZE now cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
 	      rlimit64.rlim_max );
-
+
 	rval = getrlimit64( RLIMIT_CPU, &rlimit64 );
 	assert( ! rval );
 	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
diff --git a/common/media.c b/common/media.c
index 02fde9c..817e99e 100644
--- a/common/media.c
+++ b/common/media.c
@@ -196,7 +196,7 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 		mediap->m_strategyp = chosen_sp;
 		mediap->m_writehdrp->mh_strategyid = chosen_sp->ms_id;
 	}
-
+
 	/* initialize the strategy. this will cause each of the managers
 	 * to be initialized as well. if error, return 0.
 	 */
@@ -250,7 +250,7 @@ media_get_upper_hdrs( media_t *mediap,

 /* definition of locally defined static functions ****************************/

-/* media_alloc - allocate and initialize the generic portions of a media
+/* media_alloc - allocate and initialize the generic portions of a media
  * descriptor and read and write media headers
  */
 static media_t *
diff --git a/common/media_rmvtape.h b/common/media_rmvtape.h
index 46d25f8..61e80e1 100644
--- a/common/media_rmvtape.h
+++ b/common/media_rmvtape.h
@@ -21,7 +21,7 @@
 /* media_rmvtape.h - removalable tape media abstraction
  */

-/* This structure is overlayed on the mh_specific field of the media_hdr
+/* This structure is overlayed on the mh_specific field of the media_hdr
  * structure. If is a maximum of 128 byptes long.
  */
 struct media_rmvtape_spec {
diff --git a/common/mlog.c b/common/mlog.c
index b520131..0924bf2 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -64,7 +64,7 @@ static int mlog_sym_lookup( char * );

 static size_t mlog_streamcnt;

-static char mlog_levelstr[ 3 ];
+static char mlog_levelstr[ 3 ];

 #define MLOG_SS_NAME_MAX	15
 #ifdef DUMP
@@ -201,7 +201,7 @@ mlog_init1( int argc, char *argv[ ] )
 				int suboptix;
 				char *valstr;

-				suboptix = getsubopt( &options,
+				suboptix = getsubopt( &options,
 						      (constpp)suboptstrs,
 						      &valstr );
 				if ( suboptix < 0 ) {
@@ -349,7 +349,7 @@ mlog_override_level( int levelarg )
 	level = levelarg & MLOG_LEVELMASK;
 	ss = ( ix_t )( ( levelarg & MLOG_SS_MASK ) >> MLOG_SS_SHIFT );

-	if (ss == MLOG_SS_GEN) { /* do level for all subsys */
+	if (ss == MLOG_SS_GEN) { /* do level for all subsys */
 	    for (ss = 0 ; ss < MLOG_SS_CNT ; ss++ ) {
 		mlog_level_ss[ ss ] = level;
 	    }
@@ -381,7 +381,7 @@ mlog_va( int levelarg, char *fmt, va_list args )
 	if ( level > mlog_level_ss[ ss ] ) {
 		return;
 	}
-
+
 	if ( ! ( levelarg & MLOG_NOLOCK )) {
 		mlog_lock( );
 	}
@@ -473,7 +473,7 @@ struct rv_map {
 static struct rv_map
 rvs[_RV_NUM] = {
        /* Return Code	Displayed Code	Explanation */
-	{ RV_OK,	"OK",		"success" },
+	{ RV_OK,	"OK",		"success" },
 	{ RV_NOTOK,	"ERASE_FAILED",	"media erase request denied" },
 	{ RV_NOMORE,	"NOMORE",	"no more work to do" },
 	{ RV_EOD,	"EOD",		"ran out of data" },
@@ -502,7 +502,7 @@ rvs[_RV_NUM] = {
 	{ RV_UNKNOWN,	"UNKNOWN",	"unknown error" },
 };

-static struct rv_map
+static struct rv_map
 rv_unknown = {
 	  _RV_NUM,	"???",		"unknown error code"
 };
@@ -638,7 +638,7 @@ _mlog_exit_hint( const char *file, int line, rv_t rv )

 	tid = pthread_self();
 	rvp = rv_getdesc(rv);
-
+
 	mlog( MLOG_DEBUG | MLOG_NOLOCK,
 	      "%s: %d: mlog_exit_hint called: "
 	      "hint: %s (%s)\n",
@@ -660,7 +660,7 @@ _mlog_exit_hint( const char *file, int line, rv_t rv )

 	if ( pthread_equal( tid, parenttid ) )
 		mlog_main_exit_hint = rv;
-	else
+	else
 		stream_set_hint( tid, rv );

 }
diff --git a/common/mlog.h b/common/mlog.h
index e080f9e..628dd28 100644
--- a/common/mlog.h
+++ b/common/mlog.h
@@ -57,7 +57,7 @@
 #define MLOG_SS_TREE	5		/* restore tree */
 #endif /* RESTORE */
 #define MLOG_SS_EXCLFILES 6		/* list excluded files */
-#define MLOG_SS_CNT	7		/* NOTE! bump this when adding ss */
+#define MLOG_SS_CNT	7		/* NOTE! bump this when adding ss */

 #define MLOG_SS_SHIFT	8
 #define MLOG_SS_MASK	( 0xff << MLOG_SS_SHIFT )
diff --git a/common/qlock.c b/common/qlock.c
index c770116..1db461d 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -105,7 +105,7 @@ qlock_lock( qlockh_t qlockh )
 	pthread_t tid;
 	/* REFERENCED */
 	int rval;
-
+
 	/* get the caller's tid
 	 */
 	tid = pthread_self();
@@ -148,7 +148,7 @@ qlock_unlock( qlockh_t qlockh )
 	qlock_t *qlockp = ( qlock_t * )qlockh;
 	/* REFERENCED */
 	int rval;
-
+
 	/* verify lock is held by this thread
 	 */
 	assert( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
@@ -156,7 +156,7 @@ qlock_unlock( qlockh_t qlockh )
 	/* clear lock's ord from thread's ord map
 	 */
 	QLOCK_ORDMAP_CLR( thread_ordmap, qlockp->ql_ord );
-
+
 	/* release the lock
 	 */
 	rval = pthread_mutex_unlock( &qlockp->ql_mutex );
@@ -203,7 +203,7 @@ qsemP( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
 	int rval;
-
+
 	/* "P" the semaphore
 	 */
 	rval = sem_wait( semp );
@@ -215,7 +215,7 @@ qsemV( qsemh_t qsemh )
 {
 	sem_t *semp = ( sem_t * )qsemh;
 	int rval;
-
+
 	/* "V" the semaphore
 	 */
 	rval = sem_post( semp );
diff --git a/common/rec_hdr.h b/common/rec_hdr.h
index 552447c..1ab783c 100644
--- a/common/rec_hdr.h
+++ b/common/rec_hdr.h
@@ -33,7 +33,7 @@
 /*
  * This structure is used by both drive_minrmt and drive_scsi.  New
  * strategies should define their own here if they need a different
- * structure, and add a endian conversion function to arch_xlate.c
+ * structure, and add a endian conversion function to arch_xlate.c
  */
 struct rec_hdr {
 	uint64_t magic;			/*   8   8 */
diff --git a/common/ring.c b/common/ring.c
index f5055ee..70c0f45 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -210,7 +210,7 @@ ring_put( ring_t *ringp, ring_msg_t *msgp )
 	ringp->r_active_in_ix = ( ringp->r_active_in_ix + 1 )
 				%
 				ringp->r_len;
-
+
 	/* bump the semaphore for the active queue ("V")
 	 */
 	qsemV( ringp->r_active_qsemh );
@@ -395,7 +395,7 @@ ring_slave_put( ring_t *ringp, ring_msg_t *msgp )
 	ringp->r_ready_in_ix = ( ringp->r_ready_in_ix + 1 )
 			       %
 			       ringp->r_len;
-
+
 	/* bump the semaphore for the ready queue ("V")
 	 */
 	qsemV( ringp->r_ready_qsemh );
diff --git a/common/ring.h b/common/ring.h
index 4a1cc54..6126b77 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -150,7 +150,7 @@ struct ring {
 };

 typedef struct ring ring_t;
-
+

 /* ring_create - creates a ring. parameters supply the length of the ring,
  * the read/write buffer size, the drive index, a function for reading, a
diff --git a/common/stream.c b/common/stream.c
index 3047886..eadaaea 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -277,7 +277,7 @@ stream_cnt( void )
 	size_t bitix;

 	assert( sizeof( ixmap ) * NBBY >= STREAM_SIMMAX );
-
+
 	lock();
 	for ( ; p < ep ; p++ ) {
 		if ( p->s_state == S_RUNNING ) {
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 40c273c..92fd889 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -25,19 +25,19 @@ typedef unsigned int    minor_t;
  * have been defined in sys/mtio.h and are supported in ST as well.
  * See sys/mtio.h for details.
  *
- *  operations (mt_op values for MTIOCTOP)
+ *  operations (mt_op values for MTIOCTOP)
  *
- * #define MTFSF	1	 forward space file
- * #define MTBSF	2	 backward space file
- * #define MTFSR	3	 forward space record
- * #define MTBSR	4	 backward space record
+ * #define MTFSF	1	 forward space file
+ * #define MTBSF	2	 backward space file
+ * #define MTFSR	3	 forward space record
+ * #define MTBSR	4	 backward space record
  * #define MTWEOF	5	 write an end-of-file record
- * #define MTREW	6	 rewind
- * #define MTOFFL	7	 rewind and put the drive offline
- * #define MTNOP	8	 no operation, sets status only
- * #define MTRETEN	9	 retention operation
- * #define MTEOM	12	 space to end of recorded data
- * #define MTERASE	13	 erase tape from current position to EOT
+ * #define MTREW	6	 rewind
+ * #define MTOFFL	7	 rewind and put the drive offline
+ * #define MTNOP	8	 no operation, sets status only
+ * #define MTRETEN	9	 retention operation
+ * #define MTEOM	12	 space to end of recorded data
+ * #define MTERASE	13	 erase tape from current position to EOT
  * #define MTSETBLK	20	 set block length
  * #define MTSEEK	22	 Seek to the given block number.  Not all
  *				 drives support this option.  For drives
@@ -48,19 +48,19 @@ typedef unsigned int    minor_t;
  *				 799 decimal) the program #).  For seeking
  *				 to times in audio mode, see MTSETAUDIO.
  * #define MTWSM	27	 write mt_count setmarks (DAT)
- * #define MTUNLOAD	31	 unload tape from drive
+ * #define MTUNLOAD	31	 unload tape from drive
  * #define MTSETPART	33	 skip to partition in mt_count (DAT); for
  * 				 DDS format DAT drives (only ones
  * 				 supported current), partition 1 is the
  * 				 first partition on the tape (nearest
  * 				 BOT), and partition 0 is the remainder of
- * 				 the tape.
+ * 				 the tape.
  * #define MTMKPART	34	 create partition (DAT), count is
  * 				 multiplied by 1 Mybte (2^20 bytes) to
  * 				 give the size of partition 1; if 0, then
  * 				 changes tape to a single partition
- * 				 tape.
- *
+ * 				 tape.
+ *
  */

 #define MTRET		MTRETEN	/* retention operation */
@@ -82,8 +82,8 @@ typedef unsigned int    minor_t;
 				 * now). Remains set until same ioctl is
 				 * reused, or until reboot. */

-/* MTSPECOP - special drive specific operations.
- * These use the mtop structure.
+/* MTSPECOP - special drive specific operations.
+ * These use the mtop structure.
  * MTSPECOP subcodes start at 0x6000.
  */
 #define MTSCSI_CIPHER_SEC_ON	0x6001	/* enable reporting of recovered
@@ -137,7 +137,7 @@ struct	mtget_sgi	{
 	/* the following two registers are device dependent */
 	unsigned short	mt_dsreg;	/* ``drive status'' register */
 	short	mt_erreg;		/* ``error'' register */
-	short	mt_resid;		/* residual count; for SCSI, this is
+	short	mt_resid;		/* residual count; for SCSI, this is
 					 * used to report the current partition
 					 * # for DAT tapes that are partitioned
 					 */
@@ -242,7 +242,7 @@ struct	mtvid {
 	A value of 0 indicates no limit
 	When using the variable block size device, the lastread
 	field is determined by reading one block and then spacing
-	backwards, if no i/o has yet been done to this tape.  Unlike
+	backwards, if no i/o has yet been done to this tape.  Unlike
 	MTIOCGETBLKSIZE, all quantities are in bytes.
 */
 struct mtblkinfo {
@@ -283,13 +283,13 @@ typedef	struct	irix5_mtscsi_rdlog {
 	unsigned short	mtlen;		/* Size of buffer receiving log	*/
 	app32_ptr_t	mtarg;		/* Buffer pointer		*/
 } irix5_mtscsi_rdlog_t;
-#endif /* _KERNEL */
+#endif /* _KERNEL */



 /* structure and defines for MT[GS]ETAUDIO.
  * When using SETAUDIO to locate to a particular point, the type
- * should be set to one of the MTAUDPOSN_* values,
+ * should be set to one of the MTAUDPOSN_* values,
  * and only the corresponding fields need be filled in.  See the DAT
  * audio spec for more detail on the definitions of the different times.
  * There are 34 frames per second, legal values are 0 through 33.  The
@@ -354,16 +354,16 @@ struct mt_capablity  {
         are also used in tpsc.h */

 /* The expected relative behaviour of MT_EW, MT_EOT and MTANSI can be
-   described as follows.
+   described as follows.
    - writing from BOT, with MTANSI disabled, when LEOT is encountered,
      MT_EW and MT_EOT are set. If MTANSI is now enabled, MT_EOT will be
      reset and writing will be permitted until PEOT is encountered,
      whereupon MT_EOT will again be set and will remain so until the
      tape is repositioned.
    - reading from BOT, MT_EOT will be set when PEOT is
-     encountered. LEOT is not normally reported by the drive, and therefore
-     MT_EW will normally not be set, unless the drive supports the REW mode
-     bit. (few do)
+     encountered. LEOT is not normally reported by the drive, and therefore
+     MT_EW will normally not be set, unless the drive supports the REW mode
+     bit. (few do)
 */

 #define MT_EOT		0x01	/* tape is at end of media */
@@ -621,8 +621,8 @@ struct mt_capablity  {
 #define MTCAN_LDREW	0x1000000 /* Issue Rewind instead of Load command. Used
 				   * in conjunction with MTCANT_LOAD. */

-/*
- * Definitions for MTGETATTR
+/*
+ * Definitions for MTGETATTR
  */

 /* Definition of MTGETATTR return struct */
@@ -663,7 +663,7 @@ struct mt_fpmsg {
 			char   display_type;	/* Display Type: Set to 0x80 */
 			char   msg_type:3,      /* Message type: 0x00 = General
 						 * Status message */
-		               msg_cntrl:3,     /* Message control:
+		               msg_cntrl:3,     /* Message control:
 						   0 = Display message 0
 						   1 = Display message 1
 						   2 = Flash message 0
@@ -677,7 +677,7 @@ struct mt_fpmsg {
 			char   msg2[8];	        /* message 2 */
 		} ibm3590;
 		struct {		/* Format for Fujitsu Diana 1,2,3 */
-			char   display_mode:3,
+			char   display_mode:3,
 		               display_len:1,
 		               flash:1,
 		               half_msg:1,
@@ -706,7 +706,7 @@ struct mt_fpmsg {
 #define diana_msg2		u.diana.msg2

 /* Definition of MTGETPOS/MTSETPOS structure */
-#define MAX_VEND_POS_SIZE	256	/* Maximum vendor specific position
+#define MAX_VEND_POS_SIZE	256	/* Maximum vendor specific position
 					 * data size. */
 struct	vendor_specific_pos
 {
diff --git a/common/types.h b/common/types.h
index 424b47a..50c841e 100644
--- a/common/types.h
+++ b/common/types.h
@@ -149,7 +149,7 @@ typedef struct stat64 stat64_t;
 typedef struct getbmapx getbmapx_t;
 typedef struct fsdmidata fsdmidata_t;

-/* flg definitions for preemptchk
+/* flg definitions for preemptchk
  */
 #define PREEMPT_FULL		0
 #define PREEMPT_PROGRESSONLY	1
diff --git a/common/util.c b/common/util.c
index bbca758..70b17eb 100644
--- a/common/util.c
+++ b/common/util.c
@@ -73,7 +73,7 @@ write_buf( char *bufp,

 int
 read_buf( char *bufp,
-	  size_t bufsz,
+	  size_t bufsz,
 	  void *contextp,
 	  rfp_t read_funcp,
 	  rrbfp_t return_read_buf_funcp,
@@ -230,7 +230,7 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 				      "bulkstat seeked to EOS\n");
 				return 0;
 			}
-
+
 			mlog( MLOG_DEBUG,
 			      "bulkstat seeked to %llu\n", lastino);

@@ -397,7 +397,7 @@ diriter( jdm_fshandle_t *fshandlep,
 		assert( cbrval == 0 );

 		nread = getdents_wrap( fd, (char *)gdp, gdsz );
-
+
 		/* negative count indicates something very bad happened;
 		 * try to gracefully end this dir.
 		 */
@@ -511,7 +511,7 @@ diriter( jdm_fshandle_t *fshandlep,
 	}
 }

-int
+int
 cvtnum( int blocksize, char *s )
 {
 	int i;
diff --git a/common/util.h b/common/util.h
index 558bf7e..07fdd36 100644
--- a/common/util.h
+++ b/common/util.h
@@ -60,7 +60,7 @@ typedef char * ( *rfp_t )( void *contextp, size_t wantedsz, size_t *szp, int *st
 typedef void ( * rrbfp_t )( void *contextp, char *bufp, size_t bufsz );

 extern int read_buf( char *bufp,
-			  size_t bufsz,
+			  size_t bufsz,
 			  void *contextp,
 			  rfp_t read_funcp,
 			  rrbfp_t return_read_buf_funcp,
diff --git a/dump/content.c b/dump/content.c
index 6540d7c..ecc867d 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -695,7 +695,7 @@ content_init( int argc,
 				return BOOL_FALSE;
 			}
 			baseuuidstr = optarg;
-
+
 			if ( uuid_parse( baseuuidstr, baseuuid ) < 0 ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument not a valid "
@@ -936,7 +936,7 @@ content_init( int argc,
 						      p->dr_end.sp_ino,
 						      p->dr_end.sp_offset );
 					} else {
-						p->dr_end.sp_flags = STARTPT_FLAGS_END;
+						p->dr_end.sp_flags = STARTPT_FLAGS_END;
 						mlog( MLOG_DEBUG,
 						      "resume range stream %u "
 						      "ino %llu:%lld to "
@@ -1082,7 +1082,7 @@ content_init( int argc,
 					      p->dr_end.sp_ino,
 					      p->dr_end.sp_offset );
 				} else {
-					p->dr_end.sp_flags = STARTPT_FLAGS_END;
+					p->dr_end.sp_flags = STARTPT_FLAGS_END;
 					mlog( MLOG_DEBUG,
 					      "resume range stream %u "
 					      "ino %llu:%lld to "
@@ -1420,7 +1420,7 @@ baseuuidbypass:
 			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
 			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
-
+
 	/* alloc a file system handle, to be used with the jdm_open()
 	 * functions.
 	 */
@@ -1481,7 +1481,7 @@ baseuuidbypass:
 	if ( ! ok ) {
 		return BOOL_FALSE;
 	}
-
+
 	/* ask var to ask inomap to skip files under var if var is in
 	 * the fs being dumped
 	 */
@@ -1555,7 +1555,7 @@ baseuuidbypass:
 	if (drivecnt > 1) {
 	    mlog( MLOG_VERBOSE, _(
 		  "estimated dump size per stream: %llu bytes\n"),
-		    hdr_mfilesz + (filesz + datasz) / drivecnt);
+		    hdr_mfilesz + (filesz + datasz) / drivecnt);
 	}
 	mlog( MLOG_DEBUG,
 	      "estimated dump header size: %llu bytes\n",
@@ -2010,7 +2010,7 @@ mark_set( drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags )
 		      ino,
 		      offset );
 	}
-
+
 	markp->startpt.sp_ino = ino;
 	markp->startpt.sp_offset = offset;
 	markp->startpt.sp_flags = flags;
@@ -2175,7 +2175,7 @@ content_stream_dump( ix_t strmix )
 	 * in the progress stats
 	 */
 	contextp->cc_stat_lastino = 0;
-
+
 	/* used to detect generation of an empty media file;
 	 * contains at most an inomap and dirdump and null file hdr.
 	 */
@@ -2895,7 +2895,7 @@ dump_dirs( ix_t strmix,
 					continue;
 				}
 				if ( !p->bs_nlink || !p->bs_mode || !p->bs_ino ) {
-					mlog( MLOG_TRACE,
+					mlog( MLOG_TRACE,
 					      "failed to get valid bulkstat information for inode %llu\n",
 					      p->bs_ino );
 					continue;
@@ -2904,7 +2904,7 @@ dump_dirs( ix_t strmix,
 			if ( ( p->bs_mode & S_IFMT ) != S_IFDIR ) {
 				continue;
 			}
-
+
 			rv = dump_dir( strmix, sc_fshandlep, sc_fsfd, p );
 			if ( rv != RV_OK ) {
 				return rv;
@@ -2998,7 +2998,7 @@ dump_dir( ix_t strmix,
 		      statp->bs_ino );
 		return RV_OK; /* continue anyway */
 	}
-
+
 	mlog( MLOG_TRACE,
 	      "dumping directory ino %llu\n",
 	      statp->bs_ino );
@@ -3020,7 +3020,7 @@ dump_dir( ix_t strmix,
 		close( fd );
 		return rv;
 	}
-
+
 	/* dump dirents - lots of buffering done here, to achieve OS-
 	 * independence. if proves to be to much overhead, can streamline.
 	 */
@@ -3030,7 +3030,7 @@ dump_dir( ix_t strmix,
 		register size_t reclen;

 		nread = getdents_wrap( fd, (char *)gdp, gdsz );
-
+
 		/* negative count indicates something very bad happened;
 		 * try to gracefully end this dir.
 		 */
@@ -3112,7 +3112,7 @@ dump_dir( ix_t strmix,
 			if ( inomap_get_gen( NULL, p->d_ino, &gen) ) {
 				xfs_bstat_t statbuf;
 				int scrval;
-
+
 				scrval = bigstat_one( fsfd,
 						      p->d_ino,
 						      &statbuf );
@@ -3361,7 +3361,7 @@ dump_extattr_list( drive_t *drivep,
 		/* Either the retrieve buffer is full, the dump buffer is full,
 		 * or we just put the last attribute into the dump buffer.  In
 		 * any case, fill in the values for any attributes added so far.
-		 */
+		 */

 		rtrvcnt = rtrvix;
 		if (rtrvcnt > 0) {
@@ -3735,7 +3735,7 @@ dump_file( void *arg1,
 		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as no links for ino %llu\n",
+		mlog( MLOG_DEBUG, "skip as no links for ino %llu\n",
 			statp->bs_ino);
 		return RV_OK;
 	}
@@ -3746,7 +3746,7 @@ dump_file( void *arg1,
 		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as ino %llu is prior to starpoint\n",
+		mlog( MLOG_DEBUG, "skip as ino %llu is prior to starpoint\n",
 			statp->bs_ino);
 		return RV_OK;
 	}
@@ -3760,7 +3760,7 @@ dump_file( void *arg1,
 				if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
-				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
+				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
 					statp->bs_ino);
 				return RV_NOMORE;
 			}
@@ -3769,7 +3769,7 @@ dump_file( void *arg1,
 				if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
-				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
+				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
 					statp->bs_ino);
 				return RV_NOMORE;
 			}
@@ -3796,9 +3796,9 @@ dump_file( void *arg1,
 		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as ino %llu is not marked as changed in inomap\n",
+		mlog( MLOG_DEBUG, "skip as ino %llu is not marked as changed in inomap\n",
 			statp->bs_ino);
-		mlog( MLOG_DEBUG, "ino %llu is in state %d\n",
+		mlog( MLOG_DEBUG, "ino %llu is in state %d\n",
 			statp->bs_ino, state);
 		return RV_OK;
 	}
@@ -3992,7 +3992,7 @@ dump_file_reg( drive_t *drivep,
 		}
 		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
 	}
-
+
 	/* determine the offset within the file where the dump should end.
 	 * only significant if this is an inode spanning a startpoint.
 	 */
@@ -4303,7 +4303,7 @@ init_extent_group_context( jdm_fshandle_t *fshandlep,
 		return RV_ERROR;
 	}

-	/* Check if a mandatory lock is set on the file to try and
+	/* Check if a mandatory lock is set on the file to try and
 	 * avoid blocking indefinitely on the reads later. Note that
 	 * someone could still set a mandatory lock and hose xfsdump
 	 * after this check but before all reads have completed.
@@ -4597,7 +4597,7 @@ dump_extent_group( drive_t *drivep,
 				continue;
 			}
 		}
-
+
 		/* if the new bmap entry begins beyond the end of the file,
 		 * we are done.
 		 */
@@ -4609,7 +4609,7 @@ dump_extent_group( drive_t *drivep,
 			*cmpltflgp = BOOL_TRUE;
 			return RV_OK;
 		}
-
+
 		/* if the new bmap entry begins at or above the stop offset,
 		 * stop. we are done.
 		 */
@@ -4621,7 +4621,7 @@ dump_extent_group( drive_t *drivep,
 			*cmpltflgp = BOOL_TRUE;
 			return RV_OK;
 		}
-
+
 		/* if the new entry begins below the range of
 		 * interest, modify offset to begin at the
 		 * beginning of the range of interest, and shorten
@@ -4640,13 +4640,13 @@ dump_extent_group( drive_t *drivep,
 		assert( extsz > 0 );

 		/* if the resultant extent would put us over maxcnt,
-		 * shorten it, and round up to the next BBSIZE (round
+		 * shorten it, and round up to the next BBSIZE (round
 		 * upto d_miniosz for realtime).
 		 */
 		if ( extsz > maxcnt - ( bytecnt + sizeof( extenthdr_t ))) {
 			int iosz;

-			if (isrealtime)
+			if (isrealtime)
 				iosz = da.d_miniosz;
 			else
 				iosz = BBSIZE;
@@ -4990,7 +4990,7 @@ dump_filehdr( drive_t *drivep,
 			  ( void * )drivep,
 			  ( gwbfp_t )dop->do_get_write_buf,
 			  ( wfp_t )dop->do_write );
-
+
 	switch ( rval ) {
 	case 0:
 		rv = RV_OK;
@@ -5027,16 +5027,16 @@ dump_extenthdr( drive_t *drivep,
 	char typestr[20];

 	switch( type )  {
-		case EXTENTHDR_TYPE_LAST:
+		case EXTENTHDR_TYPE_LAST:
 			strcpy( typestr, "LAST" );
 			break;
-		case EXTENTHDR_TYPE_ALIGN:
+		case EXTENTHDR_TYPE_ALIGN:
 			strcpy( typestr, "ALIGN" );
 			break;
-		case EXTENTHDR_TYPE_DATA:
+		case EXTENTHDR_TYPE_DATA:
 			strcpy( typestr, "DATA" );
 			break;
-		case EXTENTHDR_TYPE_HOLE:
+		case EXTENTHDR_TYPE_HOLE:
 			strcpy( typestr, "HOLE" );
 			break;
 		default:
@@ -5717,7 +5717,7 @@ position:
 				if ( status == DRIVE_ERROR_DEVICE ) {
 					mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
 					      "encountered media error "
-					      "attempting BSF\n") );
+					      "attempting BSF\n") );
 					goto changemedia;
 				}
 				if ( mrhdrp->mh_mediafileix == 0 ) {
@@ -5778,7 +5778,7 @@ position:

 				goto write;
 			}
-
+
 		case DRIVE_ERROR_OVERWRITE:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
@@ -5937,14 +5937,14 @@ erasemedia:
 	virginmediapr = BOOL_UNKNOWN;
 	mediawrittentopr = BOOL_FALSE;
 	goto position;
-
+
 changemedia:
 	/* if the drive does not support media change, quit.
 	 */
 	if ( ! ( dcaps & DRIVE_CAP_REMOVABLE )) {
 		return RV_ERROR;
 	}
-
+
 	/* first eject the current media object if capability supported
 	 */
 	assert( mediapresentpr != BOOL_UNKNOWN );
@@ -5963,10 +5963,10 @@ changemedia:
 		return RV_QUIT; /* this return value will cause approp. msg */
 	}

-	/* If an alert program has been specified , run it
+	/* If an alert program has been specified , run it
 	 */
 	if (media_change_alert_program != NULL)
-	   system(media_change_alert_program);
+	   system(media_change_alert_program);

 	/* if media change prompt declined or times out,
 	 * we are done
@@ -6121,9 +6121,9 @@ write:
 					     sizeof( mwhdrp->mh_medialabel ));
 		}
 	}
-
+
 	mediawrittentopr = BOOL_TRUE;
-
+
 	/* write hdr is prepared. place it on media
 	 */
 	if ( intr_allowed && cldmgr_stop_requested( )) {
@@ -6614,7 +6614,7 @@ save_quotas( char *mntpnt, quota_info_t *quotainfo )
                 return BOOL_FALSE;
             }
         }
-
+
         sprintf( buf,
 		 "%s -x -c 'dump %s %s' %s 2> /dev/null",
 		 REPQUOTA,
diff --git a/dump/inomap.c b/dump/inomap.c
index 1dacf35..238fcaf 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -354,7 +354,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			     bstatbufp,
 			     bstatbuflen );
 	*inomap_statphasep = 0;
-
+
 	if ( rval ) {
 		cb_context_free();
 		free( ( void * )bstatbufp );
@@ -704,7 +704,7 @@ supprt_prune( void *arg1,	/* ancestors marked as changed? */
 		if ( state != MAP_DIR_CHANGE &&
                      state != MAP_DIR_NOCHNG &&
 		     state != MAP_DIR_SUPPRT) {
-			/*
+			/*
 			 * if file is now a dir then it has
 			 * certainly changed.
 			 */
@@ -752,7 +752,7 @@ supprt_prune( void *arg1,	/* ancestors marked as changed? */
 	state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
 	if ( state != MAP_NDR_CHANGE &&
 	     state != MAP_NDR_NOCHNG ) {
-		/*
+		/*
 		 * if dir is now a file then it has
 		 * certainly changed.
 		 */
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 46fdde8..eee128e 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -54,13 +54,13 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 	invt_sescounter_t *sescnt = 0;

 	int index = 0;
-
+
 	assert ( pred );
 	fd = retval = init_idb ( pred, bywhat, forwhat, &tok );

-	if ( retval == I_DONE )
+	if ( retval == I_DONE )
 		return tok;
-
+
 	/* if we just want to search the db, all we need is the invidx.
 	   at this point, we know that a tok wasnt created in init_idb() */
 	if ( forwhat == INV_SEARCH_ONLY ) {
@@ -83,7 +83,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )

 	/* Now we need to make sure that this has enough space */
 	INVLOCK( stobjfd, LOCK_SH );
-
+
 	num = GET_SESCOUNTERS( stobjfd, &sescnt );
 	if ( num < 0 ) {
 		close( fd );
@@ -92,7 +92,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 		return INV_TOKEN_NULL;
 	}

-	/* create another storage object ( and, an inv_index entry for it
+	/* create another storage object ( and, an inv_index entry for it
 	   too ) if we've filled this one up */

 	if ( (uint) num >= sescnt->ic_maxnum ) {
@@ -105,14 +105,14 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 		stobjfd = idx_create_entry( &tok, fd, BOOL_FALSE );
 		INVLOCK( fd, LOCK_UN );

-		free ( sescnt );
+		free ( sescnt );
 		if ( stobjfd < 0 ) {
 			close( fd );
 			return INV_TOKEN_NULL;
 		}
 		return tok;
 	}
-
+
 	INVLOCK( stobjfd, LOCK_UN );

 	free ( sescnt );
@@ -120,7 +120,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 	tok->d_invindex_off = IDX_HDR_OFFSET( index - 1 );
 	tok->d_oflag = forwhat;
 	return tok;
-
+
 }


@@ -137,7 +137,7 @@ bool_t
 inv_close( inv_idbtoken_t tok )
 {
 	close ( tok->d_invindex_fd );
-	if ( tok->d_stobj_fd >= 0 )
+	if ( tok->d_stobj_fd >= 0 )
 		close ( tok->d_stobj_fd );
 	destroy_token( tok );
 	return BOOL_TRUE;
@@ -156,7 +156,7 @@ inv_close( inv_idbtoken_t tok )
 /*----------------------------------------------------------------------*/

 inv_sestoken_t
-inv_writesession_open(
+inv_writesession_open(
 	inv_idbtoken_t tok, 	/* token obtained by inventory_open() */
 	uuid_t		*fsid,
 	uuid_t		*sesid,
@@ -198,21 +198,21 @@ inv_writesession_open(
 	memset( (void *)&ses, 0, sizeof( ses ) );	/* paranoia */
 	memcpy( &ses.s_sesid, sesid, sizeof( uuid_t ) );
 	memcpy( &ses.s_fsid, fsid, sizeof( uuid_t ) );
-	strcpy( ses.s_label, label );
-	strcpy( ses.s_mountpt, mntpt );
-	strcpy( ses.s_devpath, devpath );
+	strcpy( ses.s_label, label );
+	strcpy( ses.s_mountpt, mntpt );
+	strcpy( ses.s_devpath, devpath );
 	ses.s_max_nstreams = nstreams;

         hdr.sh_pruned = 0; /* session is not pruned by invutil */
 	hdr.sh_time = time;
-	hdr.sh_level = level;
+	hdr.sh_level = level;
 	hdr.sh_flag = (ispartial) ? INVT_PARTIAL: 0;
 	hdr.sh_flag |= (isresumed) ? INVT_RESUMED : 0;
 	/* sh_streams_off and sh_sess_off will be set in create_session() */
-
+
 	sestok = get_sesstoken( tok );

-	/* we need to put the new session in the appropriate place in
+	/* we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */

 	INVLOCK( fd, LOCK_EX );
@@ -222,14 +222,14 @@ inv_writesession_open(
 		return INV_TOKEN_NULL;
 	}

-	/* create the writesession, and get ready for the streams to come
+	/* create the writesession, and get ready for the streams to come
 	   afterwards */
 	rval = stobj_create_session( sestok, fd, sescnt, &ses, &hdr );
 	assert (rval > 0);


 	INVLOCK( fd, LOCK_UN );
-
+
 	sestok->sd_sesstime = time;

 	if ( tok->d_update_flag & NEW_INVINDEX ) {
@@ -262,7 +262,7 @@ bool_t
 inv_writesession_close( inv_sestoken_t tok )
 {
 	int		rval;
-
+
 	assert ( tok != INV_TOKEN_NULL );

 	/* now update end_time in the inv index header */
@@ -295,7 +295,7 @@ inv_stream_open(
 	bool_t err = BOOL_FALSE;

 	assert ( tok != INV_TOKEN_NULL );
-
+
 	/* this memset is needed as a dump interrupted/crashed very soon
 	 * after starting results in an inventory with exteremely large
 	 * starting/ending inodes or offsets. This can be misleading.
@@ -309,29 +309,29 @@ inv_stream_open(

 	/* XXX yukk... make the token descriptors not pointers */
 	stok = ( inv_stmtoken_t ) malloc( sizeof( invt_strdesc_entry_t ) );
-
+
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
-
+
 	/* get the session to find out where the stream is going to go */
-	fd = tok->sd_invtok->d_stobj_fd;
+	fd = tok->sd_invtok->d_stobj_fd;

 	INVLOCK( fd, LOCK_EX );

 	/* get the session header and the session */
-	if ( stobj_get_sessinfo( tok, &seshdr, &ses ) <= 0 )
+	if ( stobj_get_sessinfo( tok, &seshdr, &ses ) <= 0 )
 		err = BOOL_TRUE;

 	if ( ( ! err )  && ses.s_cur_nstreams < ses.s_max_nstreams ) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
+		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
 					         ses.s_cur_nstreams )
 			                         + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
-
+
 		/* write it back. */
-		if ( PUT_REC_NOLOCK( fd, &ses, sizeof( ses ),
-				     tok->sd_session_off ) < 0 )
+		if ( PUT_REC_NOLOCK( fd, &ses, sizeof( ses ),
+				     tok->sd_session_off ) < 0 )
 			err = BOOL_TRUE;
 	} else if ( ! err ) {
 		mlog ( MLOG_NORMAL, _(
@@ -340,10 +340,10 @@ inv_stream_open(
 		err = BOOL_TRUE;
 	}

-	if ( ! err ) {
-		stream.st_firstmfile = stream.st_lastmfile =
+	if ( ! err ) {
+		stream.st_firstmfile = stream.st_lastmfile =
 			               stok->md_stream_off;
-
+
 		/* now write the stream header on to the disk */
 		if ( PUT_REC_NOLOCK( fd, &stream, sizeof( invt_stream_t ),
 				    stok->md_stream_off ) > 0 ) {
@@ -357,7 +357,7 @@ inv_stream_open(
 	free ( stok );
 	INVLOCK( fd, LOCK_UN );
 	return INV_TOKEN_NULL;
-
+
 }


@@ -378,25 +378,25 @@ inv_stream_close(
 	int fd = tok->md_sesstok->sd_invtok->d_stobj_fd;
 	int rval;
 	bool_t dowrite = BOOL_FALSE;
-
+
 	rval = idx_put_sesstime( tok->md_sesstok, INVT_ENDTIME );
 	if (rval < 0)
 		mlog( MLOG_NORMAL | MLOG_INV, _(
 		      "INV: idx_put_sesstime failed in "
 		      "inv_stream_close() \n") );
 	INVLOCK( fd, LOCK_EX );
-	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
+	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
 			       tok->md_stream_off )) > 0 ) {
-
+
 		if ( strm.st_interrupted != wasinterrupted ) {
 			strm.st_interrupted = wasinterrupted;
 			dowrite = BOOL_TRUE;
 		}

-		/* get the last media file to figure out what our last
+		/* get the last media file to figure out what our last
 		   ino was. we have a pointer to that in the stream token */
 		if ( tok->md_lastmfile ){
-			if ( strm.st_endino.ino !=
+			if ( strm.st_endino.ino !=
 			      tok->md_lastmfile->mf_endino.ino ||
 			     strm.st_endino.offset !=
 			      tok->md_lastmfile->mf_endino.offset) {
@@ -407,7 +407,7 @@ inv_stream_close(
 			      strm.st_endino = tok->md_lastmfile->mf_endino;
 			}
 		}
-
+
 		if (dowrite) {
 			rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
 					      tok->md_stream_off);
@@ -424,7 +424,7 @@ inv_stream_close(

 	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
 }
-
+



@@ -435,9 +435,9 @@ inv_stream_close(
 /*----------------------------------------------------------------------*/

 bool_t
-inv_put_mediafile(
-	inv_stmtoken_t 	tok,
-	uuid_t 		*moid,
+inv_put_mediafile(
+	inv_stmtoken_t 	tok,
+	uuid_t 		*moid,
 	char 		*label,
 	uint		mfileindex,
 	xfs_ino_t	startino,
@@ -457,10 +457,10 @@ inv_put_mediafile(
 	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );

 	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
-
+
 	/* copy the media file information */
 	memcpy( &mf->mf_moid, moid, sizeof( uuid_t ) );
-	strcpy( mf->mf_label, label );
+	strcpy( mf->mf_label, label );
 	mf->mf_mfileidx = mfileindex;
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
@@ -468,7 +468,7 @@ inv_put_mediafile(
 	mf->mf_endino.offset = endino_offset;
 	mf->mf_size = size;
 	mf->mf_flag = 0;
-	if ( isgood )
+	if ( isgood )
 		mf->mf_flag |= INVT_MFILE_GOOD;

 	/* This flag is used to indicate the media file that contains the
@@ -476,7 +476,7 @@ inv_put_mediafile(
 	   media file */
 	if ( isinvdump )
 		mf->mf_flag |= INVT_MFILE_INVDUMP;
-
+
 	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX );
 	rval = stobj_put_mediafile( tok, mf );
 	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN );
@@ -490,7 +490,7 @@ inv_put_mediafile(

 }

-
+



@@ -558,13 +558,13 @@ bool_t
 inv_put_sessioninfo( invt_sessinfo_t *s )
 {
 	static bool_t invdir_ok = BOOL_FALSE;
-
+
 	if ( !invdir_ok ) {
 		if ( make_invdirectory( INV_SEARCH_N_MOD ) < 0 )
 			return BOOL_FALSE;
 		else
 			invdir_ok = BOOL_TRUE;
-	}
+	}

       	return insert_session( s );

@@ -572,10 +572,10 @@ inv_put_sessioninfo( invt_sessinfo_t *s )



-
+
 /*----------------------------------------------------------------------*/
 /* inv_free_session							*/
-/* 									*/
+/* 									*/
 /* free the inv_session structure allocated as a result of calls to     */
 /* inv_get_session_byuuid, etc.						*/
 /*----------------------------------------------------------------------*/
@@ -584,7 +584,7 @@ inv_free_session(
 	inv_session_t **ses)
 {
 	uint i;
-
+
 	assert(ses);
 	assert(*ses);

@@ -592,10 +592,10 @@ inv_free_session(
 		/* the array of mediafiles is contiguous */
 		free ((*ses)->s_streams[i].st_mediafiles);
 	}
-
+
 	/* all streams are contiguous too */
 	free ((*ses)->s_streams);
-
+
 	free (*ses);
 	*ses = NULL;
 }
@@ -612,7 +612,7 @@ inv_free_session(
 /*----------------------------------------------------------------------*/

 bool_t
-inv_lasttime_level_lessthan(
+inv_lasttime_level_lessthan(
 	uuid_t		*fsidp,
 	inv_idbtoken_t	tok,
 	u_char		level,
@@ -626,7 +626,7 @@ inv_lasttime_level_lessthan(

 		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
-
+
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid ptr */
 					 (void *)&level, /* in */
 					 (void **)tm,	 /* out */
@@ -645,7 +645,7 @@ inv_lasttime_level_lessthan(
 /*----------------------------------------------------------------------*/

 bool_t
-inv_lastsession_level_lessthan(
+inv_lastsession_level_lessthan(
 	uuid_t		*fsidp,
 	inv_idbtoken_t	tok,
 	u_char		level,
@@ -680,7 +680,7 @@ inv_lastsession_level_lessthan(


 bool_t
-inv_lastsession_level_equalto(
+inv_lastsession_level_equalto(
 	uuid_t		*fsidp,
 	inv_idbtoken_t	tok,
 	u_char		level,
@@ -694,7 +694,7 @@ inv_lastsession_level_equalto(

 		return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 	}
-
+
 	return invmgr_query_all_sessions(fsidp,		 /* fs uuid */
 					 (void *)&level, /* in */
 					 (void **)ses,	 /* out */
@@ -775,12 +775,12 @@ inv_delete_mediaobj( uuid_t *moid )
 			        if ( --s.nstreams == 0 )
 			            delete-session (s)
 			     }
-			 }
+			 }
 		      }
 		 }
 	      }
 	*/
-
+
 	invt_counter_t *cnt;
 	invt_fstab_t *arr;
 	int numfs, i, fd, invfd;
@@ -791,12 +791,12 @@ inv_delete_mediaobj( uuid_t *moid )
 		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
 		return BOOL_FALSE;
 	}
-
+
 	close( fd );

 	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid,
-				      fname,
+		if ( fstab_get_fname( &arr[i].ft_uuid,
+				      fname,
 				      (inv_predicate_t)INV_BY_UUID,
 				      forwhat
 				     )
@@ -809,7 +809,7 @@ inv_delete_mediaobj( uuid_t *moid )
 		invfd = open( fname, INV_OFLAG(forwhat));
 		if ( invfd < 0 ) {
 			mlog( MLOG_NORMAL | MLOG_INV, _(
-			     "INV: Open failed on %s\n"),
+			     "INV: Open failed on %s\n"),
 			     fname );
 			return BOOL_FALSE;
 		}
@@ -819,9 +819,9 @@ inv_delete_mediaobj( uuid_t *moid )
 		    < 0 )
 			return BOOL_FALSE;
 		/* we have to delete the session, etc */
-		close( invfd );
+		close( invfd );
 	}
-
+
 	return BOOL_TRUE;
 }

@@ -832,24 +832,24 @@ inv_delete_mediaobj( uuid_t *moid )
 #define I_IERR		0x04


-static const char *myopts[] = {
+static const char *myopts[] = {
 #define OPT_MNT		0
-	"mnt",
+	"mnt",

 #define OPT_FSID	1
-	"fsid",
+	"fsid",

 #define OPT_DEV		2
-	"dev",
+	"dev",

 #define OPT_DEPTH	3
-	"depth",
+	"depth",

 #define OPT_MOBJID	4
 	"mobjid",

 #define OPT_MOBJLABEL	5
-	"mobjlabel",
+	"mobjlabel",

 #define OPT_FSTAB	6
 	"fstab",
@@ -868,14 +868,14 @@ static const char *myopts[] = {


 int
-inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
+inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 {
 	int rval = 0;
 	void *fs = 0;
 	char *options, *value;
 	extern char *optarg;
 	extern int optind, opterr;
-
+
 	inv_predicate_t bywhat = -1;
 	int c, d;
 	uuid_t fsid;
@@ -883,13 +883,13 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 	int npreds2 = 0;
 	char invoptstring[128], *rptr, *wptr;
 	optind = 1;
-	opterr = 0;
-
-	/*
+	opterr = 0;
+
+	/*
 	 * getopt doesn't handle both '-I' and '-I w/subopts' so...
-	 * First set I_IFOUND if -I is set at all (with or without
+	 * First set I_IFOUND if -I is set at all (with or without
 	 * any suboptions).  Do this by taking out the ':' so getopt
-	 * accepts it.  Later, reset opts and go through again to
+	 * accepts it.  Later, reset opts and go through again to
 	 * pick off any subopts.
 	 */
 	strcpy(invoptstring, GETOPT_CMDSTRING);
@@ -916,7 +916,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		switch ( c ) {
 		case GETOPT_INVPRINT:
 			rval |= I_IFOUND ;
-			if ((options = optarg) == NULL)
+			if ((options = optarg) == NULL)
 				break;

 			while (*options != '\0') {
@@ -926,34 +926,34 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					continue;
 				switch( d ) {
 					/* process mntpt option */
-				      case OPT_MNT:
+				      case OPT_MNT:
 					bywhat = (inv_predicate_t) INV_BY_MOUNTPT;
 					fs = value;
 					npreds++;
 					break;
-
+
 					/* process fsid option */
-				      case OPT_FSID:
+				      case OPT_FSID:
 					bywhat = (inv_predicate_t) INV_BY_UUID;
 					npreds++;
-
+
 					uuid_parse(value, fsid);
 					fs = fsid;
 					break;

 				      case OPT_DEV: /* process dev option */
 					bywhat = (inv_predicate_t) INV_BY_DEVPATH;
-					fs = value;
+					fs = value;
 					npreds++;
 					break;

 				      case OPT_DEPTH:
-					prctx->depth = atoi(value);
-					if (prctx->depth < 0 ||
+					prctx->depth = atoi(value);
+					if (prctx->depth < 0 ||
 					    prctx->depth > 4 )
 						prctx->depth = 0;
 					break;
-
+
 				      case OPT_MOBJID:
 					{
 					uuid_t *u;
@@ -970,7 +970,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					prctx->mobj.value = (void *)value;
 					npreds2++;
 					break;
-
+
 				      case OPT_FSTAB:
 					prctx->fstab = BOOL_TRUE;
 					break;
@@ -1004,7 +1004,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		}

 	}
-
+
 	if (npreds > 1) {
 		mlog( MLOG_NORMAL | MLOG_INV, _(
 		     "INV: Only one of mnt=,dev= and fsid=value can be used.\n")
@@ -1017,14 +1017,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		     );
 		rval |= I_IERR;
 	}
-	else if ( (rval & I_IFOUND) && !(rval & I_IERR) && fs
+	else if ( (rval & I_IFOUND) && !(rval & I_IERR) && fs
 		 && ! prctx->fstab && ! prctx->invcheck) {
 		inv_idbtoken_t tok;

 		/* A filesystem could be backed up, mkfs'ed then restored
 		 * to a new UUID value.  Therefore, we can't simply stop
 		 * when we find the first matching mount point (pv564234).
-		 * This code loops through all filesystems and does the
+		 * This code loops through all filesystems and does the
 		 * comparison by hand. */
 		if (bywhat == INV_BY_MOUNTPT) {
 			int fd, numfs, i;
@@ -1039,7 +1039,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)

 			if ( fd >= 0 ) {
 				for ( i = 0; i < numfs; i++ ) {
-					tok = inv_open(
+					tok = inv_open(
 						(inv_predicate_t )INV_BY_UUID,
 						INV_SEARCH_ONLY,
 						&arr[i].ft_uuid );
@@ -1047,7 +1047,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 						break;
 					if ( STREQL( arr[i].ft_mountpt, fs) ) {
 						prctx->index = i;
-						invmgr_inv_print(
+						invmgr_inv_print(
 						          tok->d_invindex_fd,
 							  prctx );
 						rval &= ~(I_IERR);
@@ -1069,7 +1069,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		tok = inv_open( bywhat, INV_SEARCH_ONLY, fs);
 		if ( tok != INV_TOKEN_NULL ) {
 			prctx->index = 0;
-			invmgr_inv_print(tok->d_invindex_fd, prctx);
+			invmgr_inv_print(tok->d_invindex_fd, prctx);
 			inv_close( tok );
 			rval |= I_IDONE;
 		} else {
@@ -1085,7 +1085,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)

 /* This prints out all the sessions of a filesystem that are in the inventory */
 bool_t
-inv_DEBUG_print( int argc, char **argv )
+inv_DEBUG_print( int argc, char **argv )
 {
 	invt_counter_t *cnt = NULL;
 	invt_fstab_t *arr = NULL;
@@ -1118,7 +1118,7 @@ inv_DEBUG_print( int argc, char **argv )
 			 if (! prctx.invidx)
 				 return BOOL_FALSE;
 		 }
-
+
 		for ( i = 0; i < numfs; i++ ) {
 			tok = inv_open( ( inv_predicate_t )INV_BY_UUID,
 					forwhat,
@@ -1137,7 +1137,7 @@ inv_DEBUG_print( int argc, char **argv )
 			}
 			else {
 				prctx.index = i;
-				invmgr_inv_print( tok->d_invindex_fd,
+				invmgr_inv_print( tok->d_invindex_fd,
 						 &prctx );
 			}
 			inv_close( tok );
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 5ef519c..f9866a5 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -60,7 +60,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 		*cntpp = NULL;
 		return -1;
 	}
-
+
 	num = ((invt_counter_t *)(*cntpp))->ic_curnum;

 	if ( ( (invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION ) {
@@ -70,7 +70,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
 		      (int) INV_VERSION );
 		assert ( ((invt_counter_t *)(*cntpp))->ic_vernum ==
 			INV_VERSION );
-	}
+	}

 	return (int) num;
 }
@@ -100,7 +100,7 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 		*hdrs = NULL;
 		return -1;
 	}
-
+
 	return 1;
 }

@@ -111,14 +111,14 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
 /*----------------------------------------------------------------------*/

 int
-get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
+get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 		bool_t dolock )
 {
 	int  nread;
-
+
 	assert ( fd >= 0 );
-
-	if ( dolock )
+
+	if ( dolock )
 		INVLOCK( fd, LOCK_SH );

 	nread = pread(fd, buf, bufsz, (off_t)off);
@@ -129,7 +129,7 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
 		return -1;
 	}

-	if ( dolock )
+	if ( dolock )
 		INVLOCK( fd, LOCK_UN );

 	return nread;
@@ -148,10 +148,10 @@ int
 put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
 {
 	int nwritten;
-
+
 	if ( dolock )
 		INVLOCK( fd, LOCK_EX );
-
+
 	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
 	if (nwritten != (int) bufsz ) {
 		INV_PERROR( _("Error in writing inventory record :") );
@@ -179,8 +179,8 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
 int
 get_headerinfo( int fd, void **hdrs, void **cnt,
 	        size_t hdrsz, size_t cntsz, bool_t dolock )
-{
-	int num;
+{
+	int num;

 	/* get a lock on the table for reading */
 	if ( dolock ) INVLOCK( fd, LOCK_SH );
@@ -207,17 +207,17 @@ get_headerinfo( int fd, void **hdrs, void **cnt,

 int
 get_lastheader( int fd, void **ent, size_t hdrsz, size_t cntsz )
-{
+{
 	int	     	 nindices;
 	void	 	 *arr = NULL;
 	invt_counter_t	 *cnt = NULL;
 	char 		 *pos;
 	/* get the entries in the inv_index */
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( fd, &arr, (void **)&cnt,
+	if ( ( nindices = GET_ALLHDRS_N_CNTS( fd, &arr, (void **)&cnt,
 					 hdrsz, cntsz )) <= 0 ) {
 		return -1;
 	}
-
+
 	/* if there's space anywhere at all, then it must be in the last
 	   entry */
 	*ent = malloc( hdrsz );
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 56d6b8f..5f7e734 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -55,28 +55,28 @@ fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 	int fd;

 	fd = open ( INV_FSTAB, INV_OFLAG(forwhat) );
-
-	if ( fd < 0 )
+
+	if ( fd < 0 )
 		return -1; /* if ENOENT, fstab_put_entry will CREAT */
-
+
 	INVLOCK( fd, LOCK_EX );
-	if (( *numfs = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void**) arr,
-						 (void **)cnt,
-						 sizeof( invt_fstab_t ),
+	if (( *numfs = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void**) arr,
+						 (void **)cnt,
+						 sizeof( invt_fstab_t ),
 						 sizeof( invt_counter_t ) )
 	     ) < 0 ) {
 		mlog( MLOG_NORMAL | MLOG_INV, _(
 			"INV: couldn't get fstab headers\n") );
 	}
-#ifdef INVT_DEBUG
-	mlog( MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
+#ifdef INVT_DEBUG
+	mlog( MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
 	      *numfs );
 #endif
 	/* fstab is left locked EX on exit. The caller takes does
 	   the unlocking */
 	return fd;
 }
-
+

 /*----------------------------------------------------------------------*/
 /*                                                                      */
@@ -108,10 +108,10 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 			INV_PERROR ( INV_FSTAB );
 			return -1;
 		}
-
+
 		INVLOCK( fd, LOCK_EX );
 		fchmod( fd, INV_PERMS );
-
+
 		cnt = (invt_counter_t *) malloc( sizeof ( invt_counter_t ) );

 		cnt->ic_maxnum = -1;
@@ -119,18 +119,18 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 		cnt->ic_vernum = INV_VERSION;

 	} else if ( numfs > 0 ) {
-
+
 		for (i = 0; i < numfs; i++) {
 		    if ( uuid_compare( *fsidp, arr[ i ].ft_uuid ) == 0 ) {
-
+
 /*			if ( ( STREQL( arr[i].ft_mountpt, mntpt ) ) &&
-			    ( STREQL( arr[i].ft_devpath, dev ) ) )
+			    ( STREQL( arr[i].ft_devpath, dev ) ) )
 */
 				free ( arr );
 				free ( cnt );
 				close( fd );
 				return 1;
-
+
 		}
 	    }
 	    /* entry not found. just follow thru to create a new one */
@@ -146,15 +146,15 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
 		memcpy( &ent.ft_uuid, fsidp, sizeof( uuid_t ) );
 		strcpy( ent.ft_mountpt, mntpt );
 		strcpy( ent.ft_devpath, dev );
-
+
 		/* increase the number of entries first */
 #ifdef INVT_DEBUG
 		mlog( MLOG_NITTY | MLOG_INV,"INV: putting new fstab entry for %s ....\n",
 		      mntpt);
 #endif
 		cnt->ic_curnum++;
-		hoff = (off64_t) ( sizeof( invt_counter_t ) +
-				 (size_t)( cnt->ic_curnum - 1 ) *
+		hoff = (off64_t) ( sizeof( invt_counter_t ) +
+				 (size_t)( cnt->ic_curnum - 1 ) *
 				           sizeof( invt_fstab_t ) );

 		rval = PUT_COUNTERS( fd, cnt );
@@ -164,7 +164,7 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )

 	}
 	INVLOCK( fd, LOCK_UN );
-	free ( cnt );
+	free ( cnt );
 	close ( fd );
 	return rval;
 }
@@ -174,8 +174,8 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )


 int
-fstab_get_fname( void *pred,
-		 char *fname,
+fstab_get_fname( void *pred,
+		 char *fname,
 		 inv_predicate_t bywhat,
 		 inv_oflag_t forwhat)
 {
@@ -205,7 +205,7 @@ fstab_get_fname( void *pred,
 		/* first get hold of the uuid for this mount point/device */

 		for (i = 0; i < numfs; i++) {
-			if ( ( bywhat == INV_BY_MOUNTPT &&
+			if ( ( bywhat == INV_BY_MOUNTPT &&
 			     ( STREQL( arr[i].ft_mountpt, pred ) )) ||
 			     ( bywhat == INV_BY_DEVPATH &&
 			     ( STREQL( arr[i].ft_devpath, pred ) )) ) {
@@ -214,16 +214,16 @@ fstab_get_fname( void *pred,
 				break;
 			}
 		}
-#ifdef INVT_DEBUG
+#ifdef INVT_DEBUG
 		if (! uuidp )
 			mlog( MLOG_DEBUG | MLOG_INV,"INV: get_fname: unable to find %s"
 			      " in the inventory\n", (char *)pred);
 #endif
-
+
 	} else {
 		uuidp = (uuid_t *)pred;
 	}
-
+
 	if (! uuidp )
 		return -1;

@@ -232,14 +232,14 @@ fstab_get_fname( void *pred,
 	strncpy ( fname, INV_DIRPATH, INV_STRLEN );
 	strcat ( fname, "/" );
 	strcat ( fname, uuidstr);
-
-	if ( bywhat != INV_BY_UUID )
+
+	if ( bywhat != INV_BY_UUID )
 		free ( arr );

 	assert( (int) strlen( fname ) < INV_STRLEN );
 	return 1;
-}
-
+}
+

 void
 fstab_DEBUG_print( invt_fstab_t *arr, int num )
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index cd9b9cb..b33983d 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -53,7 +53,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 /*	invt_entry_t ient;
 	ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
-
+
 	/* If time period of the new entry is before our first invindex,
 	   we have to insert a new invindex in the first slot */
 	if ( iarr[0].ie_timeperiod.tp_start > tm ) {
@@ -72,7 +72,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
 			return i;
 		}
-		if ( iarr[i].ie_timeperiod.tp_end == 0  &&
+		if ( iarr[i].ie_timeperiod.tp_end == 0  &&
 		     iarr[i].ie_timeperiod.tp_start  == 0 ) {
 #ifdef INVT_DEBUG
 			mlog( MLOG_DEBUG | MLOG_INV, "INV: end = start \n" );
@@ -80,10 +80,10 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 			     iarr[i].ie_timeperiod.tp_start,
 			     iarr[i].ie_timeperiod.tp_end );
 #endif
-
-			iarr[i].ie_timeperiod.tp_start =
+
+			iarr[i].ie_timeperiod.tp_start =
 				iarr[i].ie_timeperiod.tp_end = tm;
-			PUT_REC_NOLOCK( fd, iarr,
+			PUT_REC_NOLOCK( fd, iarr,
 				       icnt->ic_curnum * sizeof(invt_entry_t),
 				       (off64_t) sizeof( invt_counter_t ) );
 #ifdef INVT_DEBUG
@@ -93,57 +93,57 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 #endif
 			*stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
 			return i;
-		}
+		}



-		/* if it is beyond the end of this timeperiod, see if we
+		/* if it is beyond the end of this timeperiod, see if we
 		   belong to a timeperiod that doesn't have an entry */
 		if ( iarr[i].ie_timeperiod.tp_end < tm ) {
 			/* see if we're the last entry here */
 			if ( i == icnt->ic_curnum - 1 ) {
-				/* our slot is (i+1)th entry. Make the
+				/* our slot is (i+1)th entry. Make the
 				   timeperiod's the same as it was. As far
-				   as I can see there is no way that
+				   as I can see there is no way that
 				   timeperiods can overlap.
-
-				   insert the new entry and write back
+
+				   insert the new entry and write back
 				   icnt and invindex entry */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
+				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
 							     icnt, &ient );*/
 			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
 			      return i;
 			}
 			/* see if the next entry starts later than us */
 			if ( iarr[i+1].ie_timeperiod.tp_start > tm ) {
-
-
+
+
 				/* We have the option of pushing entries
-				   after (i) forward by one slot, and
+				   after (i) forward by one slot, and
 				   taking the (i+1)th slot, OR just hooking
-				   up with the next entry.
+				   up with the next entry.
 				   We choose the former. */
-
+
 				/* the timeperiods had better not overlap */
 				assert(( tm > iarr[i].ie_timeperiod.tp_end ) &&
 				       ( tm < iarr[i+1].ie_timeperiod.tp_start ));

-				/* shift everything from (i+1) onwards by
+				/* shift everything from (i+1) onwards by
 				   one. Then insert the new entry and write
 				   back icnt and invindex entries */
-				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
+				/* *stobjfd = idx_put_newentry( fd, i+1, iarr,
 							     icnt, &ient );*/
 			      *stobjfd = open( iarr[i].ie_filename, INV_OFLAG(forwhat) );
 				return i;
 			}
-		}
-	}
+		}
+	}

 	/* We couldnt find anything that fits */
 	assert( 0 );	/* We can't get here ! */
 	return -1;

-
+
 }


@@ -154,13 +154,13 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
 /*----------------------------------------------------------------------*/

 int
-idx_put_newentry(
-	invt_idxinfo_t *idx,
+idx_put_newentry(
+	invt_idxinfo_t *idx,
 	invt_entry_t *ient )
 {
 	invt_entry_t	*idxarr;
 	int stobjfd;
-
+
 	int fd = idx->invfd; 	/* kept locked EX by caller */
 	uint index = idx->index + 1;
 	invt_entry_t *iarr = idx->iarr;
@@ -172,25 +172,25 @@ idx_put_newentry(

 	icnt->ic_curnum++; /* there is no maximum */

-	idxarr = ( invt_entry_t * ) calloc ( icnt->ic_curnum,
+	idxarr = ( invt_entry_t * ) calloc ( icnt->ic_curnum,
 					     sizeof( invt_entry_t ) );
 	memcpy( idxarr, iarr, ( size_t ) ( sizeof( invt_entry_t ) * index ) );

 	/* shift everything from (i+1) onwards by one */
-	if ( index <  icnt->ic_curnum - 1 )
-		memcpy( &idxarr[ index + 1 ], &iarr[ index ],
+	if ( index <  icnt->ic_curnum - 1 )
+		memcpy( &idxarr[ index + 1 ], &iarr[ index ],
 		       ( size_t ) ( ( icnt->ic_curnum - index - 1 ) *
 				    sizeof( invt_entry_t ) ) );
 	/* insert the new entry */
 	memcpy( &idxarr[ index ], ient, sizeof( invt_entry_t ) );

-
+
 	if ( ( PUT_COUNTERS( fd, icnt ) < 0 ) ||
-		( PUT_REC_NOLOCK( fd, idxarr,
-				  icnt->ic_curnum * sizeof( invt_entry_t ),
+		( PUT_REC_NOLOCK( fd, idxarr,
+				  icnt->ic_curnum * sizeof( invt_entry_t ),
 				  sizeof( invt_counter_t ) ) < 0 ) ) {
 			/* XXX delete the stobj that we just created */
-
+
 			memset( ient->ie_filename, 0 , INV_STRLEN );
 			free( idxarr );
 			return -1;
@@ -199,7 +199,7 @@ idx_put_newentry(
 	free( iarr );
 	idx->iarr = idxarr;
 	return stobjfd;
-
+
 }


@@ -222,8 +222,8 @@ idx_find_stobj( invt_idxinfo_t *idx,
 	/* since sessions can be inserted in random order, the invindex
 	   table can contain time-periods that don't have corresponding
 	   entries for */
-	if ( GET_ALLHDRS_N_CNTS_NOLOCK( idx->invfd, (void **)&idx->iarr,
-						     (void **)&idx->icnt,
+	if ( GET_ALLHDRS_N_CNTS_NOLOCK( idx->invfd, (void **)&idx->iarr,
+						     (void **)&idx->icnt,
 						     sizeof( invt_entry_t ),
 				sizeof( invt_counter_t ) ) < 0 ) {
 		return -1;
@@ -236,7 +236,7 @@ idx_find_stobj( invt_idxinfo_t *idx,

 	/* Now figure out where we are going to insert this stobj among the
 	   invindices and put it there */
-	idx->index = idx_insert_newentry( idx->invfd, &stobjfd, idx->iarr,
+	idx->index = idx_insert_newentry( idx->invfd, &stobjfd, idx->iarr,
 						 idx->icnt, tm );

 	return stobjfd;
@@ -267,17 +267,17 @@ idx_create( char *fname, inv_oflag_t forwhat )
 		INV_PERROR ( fname );
 		return INV_TOKEN_NULL;
 	}
-
+
 	INVLOCK( fd, LOCK_EX );
 	fchmod( fd, INV_PERMS );

 #ifdef INVT_DEBUG
 	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
 #endif
-
+
 	/* create the first entry in the new inv_index */
 	stobjfd = idx_create_entry( &tok, fd, BOOL_TRUE );
-
+
 	INVLOCK( fd, LOCK_UN );

 	if ( stobjfd < 0 )
@@ -298,11 +298,11 @@ idx_recons_time( time32_t tm, invt_idxinfo_t *idx )
 	if ( tp->tp_start && IS_WITHIN( tp, tm ) )
 		return 1;

-	if ( tm > tp->tp_end || tp->tp_end == 0 )
+	if ( tm > tp->tp_end || tp->tp_end == 0 )
 		tp->tp_end =  tm;
 	if ( tm < tp->tp_start || tp->tp_start == 0 )
 		tp->tp_start = tm;
-	PUT_REC_NOLOCK( idx->invfd,  &idx->iarr[idx->index],
+	PUT_REC_NOLOCK( idx->invfd,  &idx->iarr[idx->index],
 		        sizeof( invt_entry_t ), IDX_HDR_OFFSET(idx->index) );
 	return 1;
 }
@@ -332,7 +332,7 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 		return -1;
 	}
 	ent.ie_timeperiod.tp_end = tok->sd_sesstime;
-
+
 	if ( whichtime == INVT_STARTTIME || ent.ie_timeperiod.tp_start == 0 ) {
 		ent.ie_timeperiod.tp_start = tok->sd_sesstime;
 	}
@@ -343,18 +343,18 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 #endif
 	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
 			      tok->sd_invtok->d_invindex_off);
-
+
 #ifdef INVT_DEBUG
 	{
 		int nindices;
 		invt_entry_t *iarr = NULL;
 		invt_counter_t *icnt = NULL;
-		if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
-						     (void **)&iarr,
-						     (void **)&icnt,
+		if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+						     (void **)&iarr,
+						     (void **)&icnt,
 						sizeof( invt_entry_t ),
 				sizeof( invt_counter_t ))) < 0 ) {
-			return -1;
+			return -1;
 		}
 		idx_DEBUG_printinvindices( iarr, (uint) nindices );
 		free( iarr );
@@ -381,8 +381,8 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 /*----------------------------------------------------------------------*/

 int
-idx_create_entry(
-	inv_idbtoken_t *tok,
+idx_create_entry(
+	inv_idbtoken_t *tok,
 	int invfd, 	/* kept locked EX  by caller */
 	bool_t firstentry )
 {
@@ -392,7 +392,7 @@ idx_create_entry(


 	memset ( &ent, 0, sizeof( ent ) );
-
+
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
 	stobj_makefname( ent.ie_filename );
@@ -422,10 +422,10 @@ idx_create_entry(
 		if ( GET_COUNTERS( invfd, &cnt )  < 0 ) {
 			return -1;
 		}
-
-		/* XXX check if there are too many indices. if so, create
+
+		/* XXX check if there are too many indices. if so, create
 		   another and leave a pointer to that in here */
-
+
 		/* create the new storage object */
 		fd = stobj_create( ent.ie_filename );
 		if ( fd < 0 ) {
@@ -446,7 +446,7 @@ idx_create_entry(
 #endif
 		if (PUT_REC_NOLOCK( invfd, &ent, sizeof( ent ), hoff) < 0 )
 			return -1;
-
+
 	}

 	*tok = get_token( invfd, fd );
@@ -476,14 +476,14 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )

 	/* if there's space anywhere at all, then it must be in the last
 	   entry. get_lastheader() does the locking */
-
-	if ((*index = get_lastheader( invfd, (void **)&ent,
+
+	if ((*index = get_lastheader( invfd, (void **)&ent,
 				       sizeof(invt_entry_t),
 				       sizeof(invt_counter_t) ) ) < 0 )
 		return -1;
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
+	assert ( ent != NULL );
 	assert ( ent->ie_filename );

 	fd = open( ent->ie_filename, INV_OFLAG(forwhat) );
@@ -510,14 +510,14 @@ idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num )
 		strncpy( s, (char *) iarr[i].ie_filename + k -
 			( INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8 );
 		s[8]= 0;
-		printf("%d. %s \t( %d - %d )\n", i, s,
+		printf("%d. %s \t( %d - %d )\n", i, s,
 		       iarr[i].ie_timeperiod.tp_start,
 		       iarr[i].ie_timeperiod.tp_end );
 	}
 #undef INV_UUID_STR_LEN
 	printf( "\n ==================================\n");
 	return 1;
-
+
 }

 int
@@ -526,12 +526,12 @@ idx_DEBUG_print ( int fd )
 	int nindices;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
-	if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
-						    (void **)&iarr,
-						    (void **)&icnt,
+	if ( ( nindices = GET_ALLHDRS_N_CNTS_NOLOCK( fd,
+						    (void **)&iarr,
+						    (void **)&icnt,
 						    sizeof( invt_entry_t ),
 				         sizeof( invt_counter_t ))) < 0 ) {
-		return -1;
+		return -1;
 	}
 	idx_DEBUG_printinvindices( iarr, (uint) nindices );
 	free( iarr );
@@ -553,7 +553,7 @@ DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
 	DEBUG_sessionprint( ses, ref, prctx);
 	free( ses->s_streams );
 	free( ses );
-
+
 	return 0;
 }

diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 79d4bb1..f175c02 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -71,7 +71,7 @@ init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 		if (errno != ENOENT) {
 			INV_PERROR ( fname );
 		} else if (forwhat == INV_SEARCH_N_MOD) {
-			*tok = idx_create( fname, forwhat );
+			*tok = idx_create( fname, forwhat );
 		} else {
 			/* this happens when the inv is empty and the user
 			   wants to do a search. this is legal - not an error */
@@ -79,7 +79,7 @@ init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 		}
 		return I_DONE; /* we are done whether token's NULL or not */
 	}
-
+
 	/* we've got to do more housekeeping stuff. so signal that */
 	return fd;
 }
@@ -95,7 +95,7 @@ get_token( int invfd, int stobjfd  )

 	desc = (invt_desc_entry_t *) malloc
 		( sizeof( invt_desc_entry_t ) );
-
+
 	desc->d_invindex_fd = invfd;
 	desc->d_stobj_fd  = stobjfd;
 	desc->d_update_flag = 0;
@@ -156,7 +156,7 @@ invmgr_query_all_sessions (
 	bool_t ret = BOOL_FALSE;

 	/* if on return, this is still null, the search failed */
-	*outarg = NULL;
+	*outarg = NULL;
 	assert(inarg);

 	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
@@ -168,11 +168,11 @@ invmgr_query_all_sessions (
 		mlog( MLOG_NORMAL | MLOG_INV, _("INV: Error in fstab\n") );
 		return ret;
 	}
-
+
 	close( fd );

 	for ( i = 0; i < numfs; i++) {
-		if ( fstab_get_fname( &arr[i].ft_uuid, fname,
+		if ( fstab_get_fname( &arr[i].ft_uuid, fname,
 				     (inv_predicate_t)INV_BY_UUID,
 				     forwhat) < 0 ) {
 			mlog( MLOG_NORMAL | MLOG_INV, _(
@@ -190,7 +190,7 @@ invmgr_query_all_sessions (
 			continue;
 		}
 		result = search_invt(fsidp, invfd, inarg, &objectfound, func);
-		close(invfd);
+		close(invfd);

 		/* if error return BOOL_FALSE */
 		if (result < 0) {
@@ -204,7 +204,7 @@ invmgr_query_all_sessions (
 			ret = BOOL_TRUE;
 		}
 	}
-
+
 	/* return val indicates if there was an error or not. *buf
 	   says whether the search was successful */
 	return ret;
@@ -222,7 +222,7 @@ invmgr_query_all_sessions (
 /*----------------------------------------------------------------------*/

 int
-search_invt(
+search_invt(
 	uuid_t			*fsidp,
 	int			invfd,
 	void			*arg,
@@ -234,7 +234,7 @@ search_invt(
 	invt_entry_t	*iarr = NULL;
 	invt_counter_t	*icnt = NULL;
 	int	     	nindices;
-
+

 	if (invfd == I_EMPTYINV)
 		return -1;
@@ -245,10 +245,10 @@ search_invt(
 	 */
 	*( char ** )buf = NULL;

-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
-					      (void **)&icnt,
+	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+					      (void **)&icnt,
 					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
+					      sizeof( invt_counter_t ))
 	      ) <= 0 ) {
 		return -1;
 	}
@@ -271,8 +271,8 @@ search_invt(
 		INVLOCK( fd, LOCK_SH );

 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
-						  (void **)&scnt,
+		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+						  (void **)&scnt,
 						  sizeof( invt_seshdr_t ),
 						 sizeof( invt_sescounter_t ))
 		     ) < 0 ) {
@@ -286,11 +286,11 @@ search_invt(
 		for (j = nsess - 1; j >= 0; j--) {
 			invt_session_t ses;

-			/* fd is kept locked until we return from the
+			/* fd is kept locked until we return from the
 			   callback routine */

-			/* Check to see if this session has been pruned
-			 * by xfsinvutil before checking it.
+			/* Check to see if this session has been pruned
+			 * by xfsinvutil before checking it.
 			 */
 			if (harr[j].sh_pruned) {
 				continue;
@@ -312,7 +312,7 @@ search_invt(

 			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
 			if (! found ) continue;
-
+
 			/* we found what we need; just return */
 			INVLOCK( fd, LOCK_UN );
 			close( fd );
@@ -320,11 +320,11 @@ search_invt(

 			return found; /* == -1 or 1 */
 		}
-
+
 		INVLOCK( fd, LOCK_UN );
 		close( fd );
 	}
-
+
 	return 0;
 }

@@ -339,7 +339,7 @@ search_invt(

 int
 invmgr_inv_print(
-	int 		invfd,
+	int 		invfd,
 	invt_pr_ctx_t 	*prctx)
 {

@@ -351,16 +351,16 @@ invmgr_inv_print(

 	if (invfd == I_EMPTYINV)
 		return 0;
-
-
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
-					      (void **)&icnt,
+
+
+	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+					      (void **)&icnt,
 					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
+					      sizeof( invt_counter_t ))
 	      ) <= 0 ) {
 		return -1;
 	}
-
+
 	free( icnt );

 	if (prctx->invidx) {
@@ -385,8 +385,8 @@ invmgr_inv_print(
 		INVLOCK( fd, LOCK_SH );

 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
-						  (void **)&scnt,
+		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+						  (void **)&scnt,
 						  sizeof( invt_seshdr_t ),
 						 sizeof( invt_sescounter_t ))
 		     ) < 0 ) {
@@ -397,11 +397,11 @@ invmgr_inv_print(
 		}
 		free ( scnt );
 		for( s = 0; s < nsess; s++ ) {
-			/* fd is kept locked until we return from the
+			/* fd is kept locked until we return from the
 			   callback routine */

-			/* Check to see if this session has been pruned
-			 * by xfsinvutil before returning it.
+			/* Check to see if this session has been pruned
+			 * by xfsinvutil before returning it.
 			 */
 			if ( harr[s].sh_pruned ) {
 				continue;
@@ -410,11 +410,11 @@ invmgr_inv_print(
 			(void)DEBUG_displayallsessions( fd, &harr[ s ],
 						        ref++, prctx);
 		}
-
+
 		INVLOCK( fd, LOCK_UN );
 		close( fd );
 	}
-
+
 	free (iarr);
 	return 0;
 }
@@ -440,11 +440,11 @@ invmgr_inv_check(

 	if (invfd == I_EMPTYINV)
 		return 0;
-
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
-					      (void **)&icnt,
+
+	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+					      (void **)&icnt,
 					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
+					      sizeof( invt_counter_t ))
 	      ) <= 0 ) {
 		return -1;
 	}
@@ -466,8 +466,8 @@ invmgr_inv_check(
 		INVLOCK( fd, LOCK_SH );

 		/* Now see if we can find the session we're looking for */
-		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
-						  (void **)&scnt,
+		if (( nsess = GET_ALLHDRS_N_CNTS_NOLOCK( fd, (void **)&harr,
+						  (void **)&scnt,
 						  sizeof( invt_seshdr_t ),
 						 sizeof( invt_sescounter_t ))
 		     ) < 0 ) {
@@ -477,7 +477,7 @@ invmgr_inv_check(
 			continue;
 		}
 		free ( scnt );
-
+
 		if ((iarr[i].ie_timeperiod.tp_start != harr[0].sh_time) ||
 		    (iarr[i].ie_timeperiod.tp_end != harr[nsess-1].sh_time)) {
 			printf(_("INV: Check %d failed.\n"), i+1);
@@ -496,7 +496,7 @@ invmgr_inv_check(
 		INVLOCK( fd, LOCK_UN );
 		close( fd );
 	}
-
+
 	return 0;
 }

@@ -518,7 +518,7 @@ tm_level_lessthan( int fd, invt_seshdr_t *hdr, void *arg,
 		return 0;
 	if (hdr->sh_level < level ) {
 #ifdef INVT_DEBUG
-		mlog( MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
+		mlog( MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
 		     level );
 #endif
 		*tm = calloc( 1, sizeof( time32_t ) );
@@ -597,7 +597,7 @@ lastsess_level_equalto( int fd, invt_seshdr_t *hdr,
 /*----------------------------------------------------------------------*/
 bool_t
 insert_session( invt_sessinfo_t *s)
-{
+{
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
 	int invfd, stobjfd = -1;
 	invt_idxinfo_t	  idx;
@@ -605,7 +605,7 @@ insert_session( invt_sessinfo_t *s)
 	inv_oflag_t       forwhat = INV_SEARCH_N_MOD;

 	/* initialize the inventory */
-	if ( ( invfd = init_idb ( (void *) s->ses->s_fsid,
+	if ( ( invfd = init_idb ( (void *) s->ses->s_fsid,
 				  (inv_predicate_t) INV_BY_UUID,
  				  forwhat,
 				  &tok ) ) < 0 ) {
@@ -616,14 +616,14 @@ insert_session( invt_sessinfo_t *s)
 #endif
 			return BOOL_FALSE;
 		}
-
+
 		invfd = tok->d_invindex_fd;
 		close( tok->d_stobj_fd );
 		destroy_token( tok );
 	}
-
+
 	/* at this point we know that invindex has at least one entry
-
+
 	   First we need to find out if this session is in the inventory
 	   already. To find the storage object that can possibly
 	   contain this session, it suffices to sequentially search the
@@ -644,7 +644,7 @@ insert_session( invt_sessinfo_t *s)
 	if ( ( stobj_insert_session( &idx, stobjfd, s ) < 0 ) ||
 		( idx_recons_time ( s->seshdr->sh_time, &idx ) < 0 ) )
 			ret = BOOL_TRUE;
-
+
 	INVLOCK( stobjfd, LOCK_UN );
 	INVLOCK( invfd, LOCK_UN );

@@ -660,7 +660,7 @@ insert_session( invt_sessinfo_t *s)

 	/* and we are done */
 	return BOOL_TRUE;
-
+
 }


@@ -717,7 +717,7 @@ bool_t
 invmgr_lockinit( void )
 {
 	if ( invlock_fd == -1 ) {
-		if (( invlock_fd = open( INV_LOCKFILE,
+		if (( invlock_fd = open( INV_LOCKFILE,
 					O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
 			INV_PERROR( INV_LOCKFILE );
 			return BOOL_FALSE;
@@ -726,14 +726,14 @@ invmgr_lockinit( void )
 	}
 	return BOOL_TRUE;
 }
-
-
+
+
 bool_t
 invmgr_trylock( invt_mode_t mode )
 {
 	int md;
 	assert( invlock_fd >= 0 );
-
+
 	md = (mode == INVT_RECONSTRUCT) ? LOCK_EX: LOCK_SH;

 	if (INVLOCK( invlock_fd, md | LOCK_NB ) < 0)
@@ -746,8 +746,8 @@ void
 invmgr_unlock( void )
 {
 	assert( invlock_fd >= 0 );
-
-	INVLOCK( invlock_fd, LOCK_UN );
+
+	INVLOCK( invlock_fd, LOCK_UN );

 }

diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 66a03f4..56ac5e5 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -57,7 +57,7 @@ oref_resolve_(
 		assert(0);
 		break;
 	}
-
+
 	return rval;
 }

@@ -66,12 +66,12 @@ oref_resolve_(


 /*
- * Resolve an object reference upto a specified point
+ * Resolve an object reference upto a specified point
  */

 int
 oref_resolve_upto(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	invt_objtype_t	type)
 {
 	int rval = INV_OK;
@@ -101,7 +101,7 @@ oref_resolve_upto(
 	if (type >= INVT_RES_MFILES && rval != INV_ERR) {
 		rval = oref_resolve_mfiles(obj);
 	}
-
+
 	return rval;
 }

@@ -137,7 +137,7 @@ oref_resolve_entries(
 	}

 	OREF_SET_TYPE(obj, INVT_RES_COUNTERS);
-
+
 	return INV_OK;
 }

@@ -173,7 +173,7 @@ oref_resolve_counters(
 	}

 	OREF_SET_TYPE(obj, INVT_RES_COUNTERS);
-
+
 	return INV_OK;
 }

@@ -181,7 +181,7 @@ oref_resolve_counters(

 int
 oref_sync(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	invt_objtype_t	type)
 {
 	int rval;
@@ -194,34 +194,34 @@ oref_sync(

 	switch (type) {
 	      case INVT_RES_COUNTERS:
-		rval = PUT_REC_NOLOCK(obj->fd,
-				      OREF_CNT(obj),
+		rval = PUT_REC_NOLOCK(obj->fd,
+				      OREF_CNT(obj),
 				      sizeof(*OREF_CNT(obj)),
 				      (off64_t) 0);
-
+
 		break;

 	      case INVT_RES_ENTRIES:
 		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));

-		rval = PUT_REC_NOLOCK(obj->fd,
-				      OREF_ENTRIES(obj),
+		rval = PUT_REC_NOLOCK(obj->fd,
+				      OREF_ENTRIES(obj),
 				      sizeof(*OREF_ENTRIES(obj)),
 				      (off64_t) sizeof(*OREF_CNT(obj)));
-
+
 		break;

 	      default:
 		assert(0);
 		break;
 	}
-
+
 	return rval;
 }

 int
 oref_sync_append(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	invt_objtype_t	type,
 	void		*entry,
 	size_t		entsz)
@@ -236,22 +236,22 @@ oref_sync_append(
 	switch (type) {
 	      case INVT_RES_ENTRIES:
 		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
-
-		rval = PUT_REC_NOLOCK(obj->fd,
+
+		rval = PUT_REC_NOLOCK(obj->fd,
 				      entry,
 				      entsz,
 				      IDX_HDR_OFFSET(OREF_CNT_CURNUM(obj) - 1));
-		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
+		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
 			free((oref)->eu_ent);
 		OREF_UNSET_TYPE(obj, INVT_RES_ENTRIES);
-
+
 		break;

 	      default:
 		assert(0);
 		break;
 	}
-
+
 	return rval;
 }

@@ -259,18 +259,18 @@ oref_sync_append(

 void
 _oref_free(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	bool_t 		freethis)
 {
-	/*
+	/*
 	 * Unlock the object *if* it is locked.
 	 * We dont want to actually close the fd because,
 	 * the tokens still need it.
 	 */
-	OREF_UNLOCK(obj);
+	OREF_UNLOCK(obj);

 	if (OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ) ){
-		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
+		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_sescnt);
 		if (OREF_ISRESOLVED(obj, INVT_RES_HDRS))
 			free((oref)->eu_hdr);
@@ -282,15 +282,15 @@ _oref_free(
 			free((oref)->eu_mfile);
 	}
 	else if (OREF_ISRESOLVED(obj, INVT_OTYPE_INVIDX)) {
-		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
+		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_cnt);
-		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
+		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
 			free((oref)->eu_ent);
 	}
 	else if (OREF_ISRESOLVED(obj, INVT_OTYPE_FSTAB)) {
-		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
+		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_cnt);
-		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
+		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
 			free((oref)->eu_fstabent);
 	}
 	OREF_INIT(obj);
@@ -318,7 +318,7 @@ oref_resolve(
 	int		index;

 	assert(! OREF_ISRESOLVED(invidx, INVT_OTYPE_MASK));
-
+
 	OREF_SET_TYPE(invidx, INVT_OTYPE_INVIDX);

 	/* come up with the unique file suffix that refers to this
@@ -336,7 +336,7 @@ oref_resolve(
 			return INV_ERR;
 		}
 		/* create the invidx */
-		return oref_resolve_new_invidx(invidx, fname);
+		return oref_resolve_new_invidx(invidx, fname);
 	}

 	invidx->fd = fd;
@@ -351,27 +351,27 @@ oref_resolve(

 	/* Now we need to make sure that this has enough space */
 	OREF_LOCK(stobj, LOCK_SH);
-
+
 	if (oref_resolve_upto(stobj, INVT_RES_COUNTERS) == INV_ERR) {
 		OREF_UNLOCK(stobj);
 		OREF_UNLOCK(invidx);
 		return INV_ERR;
 	}

-	/* create another storage object ( and, an inv_index entry for it
+	/* create another storage object ( and, an inv_index entry for it
 	   too ) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
 		int 	rval;
 #ifdef INVT_DEBUG
 		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
 		      "index entry. \n" );
-#endif
+#endif
 		/* Close(), Destroy() and mark unresolved */
 		OREF_UNRESOLVE_CHILD(invidx);
 		rval = oref_resolve_new_stobj(invidx, BOOL_FALSE);
 		/* rval = oref_idx_create_entry(invidx, BOOL_FALSE); */
 		OREF_UNLOCK(invidx);
-
+
 		return rval;
 	}

@@ -380,7 +380,7 @@ oref_resolve(

 	tok = get_token(invidx->fd, stobj->fd);
 	tok->d_invindex_off = IDX_HDR_OFFSET(index - 1);
-
+
 	OREF_SET_TOKEN(tok);
 	return INV_OK;

@@ -398,14 +398,14 @@ oref_resolve_child(
 	invt_entry_t 	*ent;
 	assert(OREF_IS_LOCKED(invidx));

-	if (oref_resolve_upto(invidx, INVT_RES_ENTRIES) == INV_ERR)
+	if (oref_resolve_upto(invidx, INVT_RES_ENTRIES) == INV_ERR)
 		return INV_ERR;
-
+
 	ent = OREF_ENTRIES(invidx);
-
+
 	/* at this point we know that there should be at least one invindex
 	   entry present */
-	assert ( ent != NULL );
+	assert ( ent != NULL );
 	assert ( ent->ie_filename );

 	fd = open( ent->ie_filename, O_RDWR );
@@ -442,7 +442,7 @@ oref_resolve_new_invidx(

 #ifdef INVT_DEBUG
 	mlog( MLOG_NITTY | MLOG_INV, "creating InvIndex %s\n", fname);
-#endif
+#endif
 	/* create the new stobj as its first entry */
 	rval = oref_resolve_new_stobj(invidx, IS_EMPTY);

@@ -470,7 +470,7 @@ oref_resolve_new_stobj(
 	memset ( &ent, 0, sizeof( ent ) );
 	stobj = calloc(1, sizeof(invt_oref_t));
 	OREF_SET_CHILD(invidx, stobj);
-
+
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
 	stobj_makefname( ent.ie_filename );
@@ -482,7 +482,7 @@ oref_resolve_new_stobj(
 		cnt->ic_maxnum = INVT_MAX_INVINDICES;
 		cnt->ic_curnum = 1;
 		cnt->ic_vernum = INV_VERSION;
-
+
 		fd = stobj_create( ent.ie_filename );
 		if ( fd < 0 ) {
 			free(cnt);
@@ -499,7 +499,7 @@ oref_resolve_new_stobj(
 	else {
 		if (oref_resolve_upto(invidx, INVT_RES_COUNTERS) == INV_ERR)
 			return INV_ERR;
-
+
 		/* create the new storage object */
 		fd = stobj_create( ent.ie_filename );
 		if ( fd < 0 ) {
@@ -508,21 +508,21 @@ oref_resolve_new_stobj(

 		stobj->fd = fd;
 		OREF_CNT_CURNUM(invidx)++;
-
+
 		if ((oref_sync(invidx, INVT_RES_COUNTERS) == INV_ERR)
 		    ||
-		    (oref_sync_append(invidx, INVT_RES_ENTRIES,
+		    (oref_sync_append(invidx, INVT_RES_ENTRIES,
 				      &ent, sizeof(ent)) == INV_ERR))
 			return INV_ERR;
-
+
 	}
 	tok = get_token( invfd, fd );
 	tok->d_invindex_off = IDX_HDR_OFFSET(OREF_CNT_CURNUM(invidx) - 1);
 	tok->d_update_flag |= NEW_INVINDEX;
-
+
 	OREF_SET_TOKEN(invidx, tok);
 	return INV_OK;
-
+
 }


diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 38303a4..0061722 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -51,14 +51,14 @@ typedef uint32_t	invt_objtype_t;
 #define INVT_LOCKED		0x0001

 typedef struct invt_oref {
-	int				 fd;
+	int				 fd;

 	/* counters - contains curnum, maxnum, etc */
 	union {
 		invt_sescounter_t 	 *sescnt;
 		invt_counter_t		 *cnt;
 	} oref_cnt_u;
-
+
 	/* entries pointing at other invt objects */
 	union {
 		invt_entry_t 		 *ent;
@@ -94,7 +94,7 @@ typedef struct invt_oref {
 #define ku_stobj	oref_kin_u.stobj

 /*
- *	See if the object has been resolved to the given level.
+ *	See if the object has been resolved to the given level.
  */

 #define OREF_ISRESOLVED(oref, to_this_type) \
@@ -110,7 +110,7 @@ typedef struct invt_oref {
 	  else if (OREF_ISRESOLVED(oref, INVT_RES_PARENT)) \
 		  _oref_free((oref)->ku_invidx, BOOL_TRUE); \
           _oref_free(oref, BOOL_FALSE); }
-
+
 #define OREF_COPY(src_oref, dst_oref) \
 	(bcopy((src_oref), (dst_oref), sizeof(invt_oref_t)))

@@ -239,7 +239,7 @@ oref_resolve(

 int
 oref_resolve_upto(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	invt_objtype_t	type);

 int
@@ -252,7 +252,7 @@ oref_resolve_counters(

 void
 _oref_free(
-	invt_oref_t 	*obj,
+	invt_oref_t 	*obj,
 	bool_t 		freethis);


diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 5f2256d..ed50782 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -60,7 +60,7 @@
 #define INVT_DOLOCK		BOOL_TRUE
 #define INVT_DONTLOCK		BOOL_FALSE

-#define INVLOCK( fd, m )	flock( fd, m )
+#define INVLOCK( fd, m )	flock( fd, m )

 /* return values */
 #define INV_OK			(int) 1
@@ -110,14 +110,14 @@ typedef struct invt_session {
 	char		 s_devpath[INV_STRLEN];/* path to the device */
 	uint		 s_cur_nstreams;/* number of streams created under
 					   this session so far */
-	uint		 s_max_nstreams;/* number of media streams in
+	uint		 s_max_nstreams;/* number of media streams in
 					   the session */
 	char		 s_padding[16];
-} invt_session_t;
-
+} invt_session_t;
+
 typedef struct invt_seshdr {
 	off64_t		sh_sess_off;    /* offset to rest of the sessioninfo */
-	off64_t		sh_streams_off; /* offset to start of the set of
+	off64_t		sh_streams_off; /* offset to start of the set of
 					   stream hdrs */
 	time32_t	sh_time;        /* time of the dump */
 	uint32_t	sh_flag;        /* for misc flags */
@@ -129,7 +129,7 @@ typedef struct invt_seshdr {

 /* Each session consists of a number of media streams. While it is given that
    there won't be multiple writesessions (ie. dumpsessions) concurrently,
-   there can be multiple media streams operating on a single file system,
+   there can be multiple media streams operating on a single file system,
    each writing media files within its own stream. Hence, we have a linked
    list of media files, that the stream keeps track of. */

@@ -159,7 +159,7 @@ typedef struct invt_mediafile {
 	uuid_t		 mf_moid;	/* media object id */
 	char		 mf_label[INV_STRLEN];	/* media file label */
 	invt_breakpt_t	 mf_startino;	/* file that we started out with */
-	invt_breakpt_t	 mf_endino;	/* the dump file we ended this
+	invt_breakpt_t	 mf_endino;	/* the dump file we ended this
 					   media file with */
 	off64_t		 mf_nextmf;	/* links to other mfiles */
 	off64_t		 mf_prevmf;
@@ -200,7 +200,7 @@ typedef struct invt_sescounter {
 	INVT_COUNTER_FIELDS
 	off64_t	       ic_eof;   /* current end of the file, where the next
 				 media file or stream will be written to */
-	char 	       ic_padding[0x20 - ( INVT_COUNTER_FIELDS_SIZE +
+	char 	       ic_padding[0x20 - ( INVT_COUNTER_FIELDS_SIZE +
 					   sizeof( off64_t) )];
 } invt_sescounter_t;

@@ -225,7 +225,7 @@ typedef struct invt_desc_entry {
 				   this file system or not and also if
 				   we had to create a new invindex file */
 	inv_oflag_t d_oflag;    /* the open mode (SEARCH_ONLY, SEARCH_N_MOD) */
-	off64_t	d_invindex_off; /* for every session, we need a reference
+	off64_t	d_invindex_off; /* for every session, we need a reference
 				   to its invindex entry, so that when we
 				   close a session, we know which one */
 } invt_desc_entry_t;
@@ -235,23 +235,23 @@ typedef struct invt_sesdesc_entry {
 	invt_desc_entry_t *sd_invtok;	/* generic inventory token */
 	off64_t		   sd_session_off;
 	off64_t		   sd_sesshdr_off;
-	time32_t	   sd_sesstime;	/* time that session started.
+	time32_t	   sd_sesstime;	/* time that session started.
 					   needed for closing the session */
 } invt_sesdesc_entry_t;
-
+
 struct invt_mediafile;

 typedef struct invt_strdesc_entry {
 	invt_sesdesc_entry_t  *md_sesstok;   /* the session token */
-	off64_t		       md_stream_off;/* offset to the media stream
-						header */
+	off64_t		       md_stream_off;/* offset to the media stream
+						header */
 	struct invt_mediafile *md_lastmfile; /* just so that we dont have
 						to get it back from disk
 						when we add the next mfile
 						to the linked list */

 } invt_strdesc_entry_t;
-
+



@@ -262,7 +262,7 @@ typedef struct invt_strdesc_entry {

 typedef struct invt_sessinfo {
 	int 		  stobjfd;
-	invt_seshdr_t    *seshdr;
+	invt_seshdr_t    *seshdr;
 	invt_session_t   *ses;
 	invt_stream_t    *strms;
 	invt_mediafile_t *mfiles;
@@ -332,7 +332,7 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 #define GET_SESHEADERS( fd, hdrs, n ) get_headers( fd, (void**)(hdrs), \
 				   (size_t) ( n * sizeof(invt_seshdr_t ) ),\
 				          sizeof( invt_sescounter_t )  )
-
+
 #define GET_ENTRIES(fd, hdrs, n, sz) get_headers(fd, (void**)(hdrs), \
 				   (size_t) (n * sz), sizeof(invt_counter_t))

@@ -358,7 +358,7 @@ int
 idx_find_stobj( invt_idxinfo_t *idx, time32_t tm );

 uint
-idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr,
+idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr,
 		     invt_counter_t *icnt,
 		     time32_t tm );
 int
@@ -382,23 +382,23 @@ int
 stobj_create( char *fname );

 int
-stobj_create_session( inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
+stobj_create_session( inv_sestoken_t tok, int fd, invt_sescounter_t *sescnt,
 		      invt_session_t *ses, invt_seshdr_t *hdr );

 int
 stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf );

 off64_t
-stobj_put_session(
-	int fd,
-	invt_sescounter_t *sescnt,
-	invt_session_t *ses,
+stobj_put_session(
+	int fd,
+	invt_sescounter_t *sescnt,
+	invt_session_t *ses,
 	invt_seshdr_t *hdr,
 	invt_stream_t *strms,
 	invt_mediafile_t *mfiles );

 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles );

@@ -412,7 +412,7 @@ uint
 stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm );

 int
-stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
+stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	     invt_sessinfo_t *newsess );
 bool_t
 stobj_replace_session( int fd, invt_sescounter_t *sescnt, invt_session_t *ses,
@@ -427,7 +427,7 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 		     void  **bufpp, size_t *bufszp );

 bool_t
-stobj_unpack_sessinfo(
+stobj_unpack_sessinfo(
         void              *bufp,
         size_t             bufsz,
 	invt_sessinfo_t   *s );
@@ -454,7 +454,7 @@ int
 stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr );

 int
-stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		    inv_session_t **buf);

 void
@@ -471,7 +471,7 @@ stobj_getsession_bylabel(int fd, invt_seshdr_t *hdr, void *label, void **buf);


 void
-stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
+stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 		      invt_seshdr_t *hdr);

 void
@@ -486,14 +486,14 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo);
 /*----------------------------------------------------------------------*/

 int
-fstab_get_fname( void *pred, char *fname, inv_predicate_t bywhat,
+fstab_get_fname( void *pred, char *fname, inv_predicate_t bywhat,
 		 inv_oflag_t forwhat );

 int
 fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat );

 int
-fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
+fstab_getall( invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 	      inv_oflag_t forwhat );

 void
@@ -563,14 +563,14 @@ bool_t
 lastsess_level_equalto( int fd, invt_seshdr_t *hdr,  void *arg, void **buf );

 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
+DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx);

 int
 make_invdirectory( inv_oflag_t forwhat );

 bool_t
-init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
+init_idb( void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 	 inv_idbtoken_t *tok );

 int
@@ -582,6 +582,6 @@ insert_session( invt_sessinfo_t *s);
 /* To reconstruct a complete inventory from dumped inventories */
 extern bool_t
 inv_put_sessioninfo( invt_sessinfo_t *s );
-
+

 #endif
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 9619476..25df2fe 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -54,7 +54,7 @@ stobj_insert_session( invt_idxinfo_t *idx,
 		      invt_sessinfo_t *s )
 {
 	invt_sescounter_t *sescnt = NULL;
-
+
 	if ( GET_SESCOUNTERS( fd, &sescnt ) < 0 ) {
 		INVLOCK( fd, LOCK_UN );
 		return -1;
@@ -64,11 +64,11 @@ stobj_insert_session( invt_idxinfo_t *idx,
 	   duplicating this session */
 	if ( sescnt->ic_curnum > 0 ) {
 		uint i;
-		invt_session_t	*sessions = calloc( sescnt->ic_curnum,
+		invt_session_t	*sessions = calloc( sescnt->ic_curnum,
 				   sizeof( invt_session_t ) );
 		if ( GET_REC_NOLOCK( fd, sessions, sescnt->ic_curnum *
-				     sizeof( invt_session_t ),
-				     (off64_t) ( sizeof( *sescnt ) +
+				     sizeof( invt_session_t ),
+				     (off64_t) ( sizeof( *sescnt ) +
          		sescnt->ic_maxnum * sizeof( invt_seshdr_t ))) < 0 ) {
 			free ( sescnt );
 			free ( sessions );
@@ -76,14 +76,14 @@ stobj_insert_session( invt_idxinfo_t *idx,
 		}

 		for( i = 0; i <  sescnt->ic_curnum; i++ ) {
-			if ( uuid_compare( sessions[i].s_sesid,
+			if ( uuid_compare( sessions[i].s_sesid,
 					   s->ses->s_sesid ) == 0 )
 				break;

 		}
 		free ( sessions );
 		if ( i < sescnt->ic_curnum ) {
-			mlog( MLOG_DEBUG | MLOG_INV,
+			mlog( MLOG_DEBUG | MLOG_INV,
 			      "INV: attempt to insert an "
 			      "existing session.\n"
 			     );
@@ -100,15 +100,15 @@ stobj_insert_session( invt_idxinfo_t *idx,
 		}
 		free( sescnt );
 		return 1;
-
+
 	}
-
+
 	if ( stobj_put_session( fd, sescnt, s->ses, s->seshdr, s->strms,
 			        s->mfiles ) < 0 ){
 		free ( sescnt);
 		return -1;
 	}
-
+
 	free ( sescnt);
 	return 1;
 }
@@ -139,17 +139,17 @@ stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
 	}


-	/* All the entries have the same sh_time. It's not clear if that's
+	/* All the entries have the same sh_time. It's not clear if that's
 	   really possible, but either way, we split at the last entry.
 	   This will impact the guarantee that invindex tries to give - that
 	   there's always a unique stobj for every session. */
 	mlog( MLOG_VERBOSE | MLOG_INV, _(
 	      "INV: failed to find a different sh_time to split\n")
 	     );
-
+
 	return ns - 1;
-
-
+
+

 }

@@ -162,7 +162,7 @@ stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
 /*----------------------------------------------------------------------*/

 int
-stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
+stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	     invt_sessinfo_t *newsess )
 {
 	invt_seshdr_t 	*harr = NULL;
@@ -174,24 +174,24 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,

 	if ( GET_SESHEADERS( fd, &harr, ns ) < 0 )
 		return -1;
-
+
 	assert( harr != NULL );

-	if ( ( ix = stobj_find_splitpoint( fd, harr, ns,
+	if ( ( ix = stobj_find_splitpoint( fd, harr, ns,
 				       newsess->seshdr->sh_time ) ) == 0 )
 		return -1;
-
+
 	if ( ix == ns ) {
-		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
+		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
 			 newsess->seshdr->sh_time;
 	} else {
-		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
+		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
 		harr[ix].sh_time;
 		if ( harr[ix - 1].sh_time >  newsess->seshdr->sh_time )
-			idx->iarr[idx->index].ie_timeperiod.tp_end
+			idx->iarr[idx->index].ie_timeperiod.tp_end
 				= harr[ix - 1].sh_time;
 		else
-			idx->iarr[idx->index].ie_timeperiod.tp_end
+			idx->iarr[idx->index].ie_timeperiod.tp_end
 				= newsess->seshdr->sh_time;
 	}

@@ -201,7 +201,7 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	newsess->stobjfd = idx_put_newentry( idx, &ient );
 	if ( newsess->stobjfd < 0 )
 		return -1;
-
+
 	if ( ix == ns ) {
 		invt_sescounter_t *scnt = NULL;
 		off64_t rval;
@@ -209,19 +209,19 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		/* We dont need to split. So, just put the new session in
 		   the new stobj, and rest in peace */
 		idx->index++;
-
+
 		if ( GET_SESCOUNTERS( newsess->stobjfd, &scnt ) < 0 )
 			return -1;
-
-		rval = stobj_put_session( newsess->stobjfd, scnt,
+
+		rval = stobj_put_session( newsess->stobjfd, scnt,
 				        newsess->ses,
-				        newsess->seshdr, newsess->strms,
+				        newsess->seshdr, newsess->strms,
 				        newsess->mfiles );
 		free( scnt );
 		return (rval < 0)? -1: 1;
 	}
-
-
+
+

 	for ( i = ix; i < ns; i++ ) {
 		invt_session_t session;
@@ -229,7 +229,7 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		bufszp = 0;

 		newsess->seshdr->sh_sess_off = harr[i].sh_sess_off;
-
+
 		if ( GET_REC_NOLOCK( fd, &session, sizeof( invt_session_t ),
 			     harr[i].sh_sess_off ) < 0 )
 			return -1;
@@ -243,11 +243,11 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,

 		/* There is no chance of a recursion here */
 		if ( stobj_insert_session( idx, newsess->stobjfd, &sesinfo )
-		     < 0 )
+		     < 0 )
 			return -1;
-
+
 		/* Now delete that session from this StObj */
-		if (! stobj_delete_sessinfo( fd, sescnt, &session,
+		if (! stobj_delete_sessinfo( fd, sescnt, &session,
 					     &harr[i] ) )
 			return -1;
 		free( bufpp );
@@ -255,14 +255,14 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	/* Put the new session in the stobj that we just split. Make
 	   sure that we use the updated sescnt and not the stale stuff
 	   from disk. stobj_put_session() writes sescnt and sessinfo to
-	   disk */
-	if ( stobj_put_session( fd, sescnt, newsess->ses, newsess->seshdr,
+	   disk */
+	if ( stobj_put_session( fd, sescnt, newsess->ses, newsess->seshdr,
 			        newsess->strms, newsess->mfiles ) < 0 ) {
 		free ( sescnt);
 		return -1;
-	}
+	}
+

-
 	return 1;
 }

@@ -288,10 +288,10 @@ stobj_delete_sessinfo( int fd, /* kept locked EX by caller */
 		       invt_sescounter_t *sescnt,
 		       invt_session_t *ses, invt_seshdr_t *hdr )
 {
-	/* we change the sescnt here, but dont write it back to disk
+	/* we change the sescnt here, but dont write it back to disk
 	   until later */
 	sescnt->ic_curnum--;
-
+
 	/* there is really no need to take out / zero out the deleted
 	   session. The seshdr and session will be over-written, but
 	   space taken by the streams and mediafiles will be wasted. */
@@ -308,23 +308,23 @@ stobj_delete_sessinfo( int fd, /* kept locked EX by caller */


 off64_t
-stobj_put_session(
-	int fd,
-	invt_sescounter_t *sescnt,
-	invt_session_t *ses,
+stobj_put_session(
+	int fd,
+	invt_sescounter_t *sescnt,
+	invt_session_t *ses,
 	invt_seshdr_t *hdr,
 	invt_stream_t *strms,
 	invt_mediafile_t *mfiles )
 {
 	off64_t hoff;
-
+
 	/* figure out the place where the header will go */
 	hoff =  STOBJ_OFFSET( sescnt->ic_curnum, 0 );

 	/* figure out where the session information is going to go. */
 	if ( hdr->sh_sess_off < 0 )
-		hdr->sh_sess_off = STOBJ_OFFSET( sescnt->ic_maxnum,
-						 sescnt->ic_curnum );
+		hdr->sh_sess_off = STOBJ_OFFSET( sescnt->ic_maxnum,
+						 sescnt->ic_curnum );
 	sescnt->ic_curnum++;

 #ifdef INVT_DEBUG
@@ -334,43 +334,43 @@ stobj_put_session(
 	       (int) sescnt->ic_eof );
 #endif

-	/* we need to know where the streams begin, and where the
+	/* we need to know where the streams begin, and where the
 	   media files will begin, at the end of the streams */
 	hdr->sh_streams_off = sescnt->ic_eof;

 	if ( strms == NULL ) {
-		sescnt->ic_eof += (off64_t)( ses->s_max_nstreams *
+		sescnt->ic_eof += (off64_t)( ses->s_max_nstreams *
 					     sizeof( invt_stream_t ) );
 	} else {
 		uint i;
 		size_t nmf = 0;
-		sescnt->ic_eof += (off64_t)( ses->s_cur_nstreams *
+		sescnt->ic_eof += (off64_t)( ses->s_cur_nstreams *
 					     sizeof( invt_stream_t ) );
-		for (i=0; i<ses->s_cur_nstreams; i++)
+		for (i=0; i<ses->s_cur_nstreams; i++)
 			nmf += ( size_t ) strms[i].st_nmediafiles;
-
-		sescnt->ic_eof += (off64_t)( sizeof( invt_mediafile_t )
+
+		sescnt->ic_eof += (off64_t)( sizeof( invt_mediafile_t )
 					     * nmf );
 		if ( stobj_put_streams( fd, hdr, ses, strms, mfiles ) < 0 )
-			return -1;
+			return -1;

 	}
-
+
 	/* we write back the counters of this storage object first */
 	if ( PUT_SESCOUNTERS( fd, sescnt ) < 0 )
 		return -1;
-
+
 	/* write the header next; lseek to the right position */
 	if ( PUT_REC_NOLOCK( fd, hdr, sizeof( invt_seshdr_t ), hoff ) < 0 ) {
 		return -1;
 	}

 	/* write the header information to the storage object */
-	if ( PUT_REC_NOLOCK( fd, ses, sizeof( invt_session_t ),
+	if ( PUT_REC_NOLOCK( fd, ses, sizeof( invt_session_t ),
 			     hdr->sh_sess_off ) < 0 ) {
 		return -1;
 	}
-
+
 	if ( strms != NULL )
 		stobj_sortheaders( fd, sescnt->ic_curnum );

@@ -407,8 +407,8 @@ stobj_sortheaders( int fd, uint num )
 	printf("\nBEF\n" );
 	for (i=0; i<(int)num; i++)
 		printf("%ld\n", (long) hdrs[i].sh_time );
-#endif
-	qsort( (void*) hdrs, (size_t) num,
+#endif
+	qsort( (void*) hdrs, (size_t) num,
 	      sizeof( invt_seshdr_t ), stobj_hdrcmp );

 #ifdef INVT_DEBUG
@@ -420,7 +420,7 @@ stobj_sortheaders( int fd, uint num )
 		free ( hdrs );
 		return -1;
 	}
-
+
 	free ( hdrs );
 	return 1;

@@ -437,7 +437,7 @@ stobj_sortheaders( int fd, uint num )
 /*----------------------------------------------------------------------*/

 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
 {
@@ -453,39 +453,39 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		  (off64_t) ((size_t) nmfiles * sizeof( invt_mediafile_t ) );
 		/* now fix the offsets in mediafiles */
 		for ( j = 0; j < strms[i].st_nmediafiles; j++ ) {
-
+
 			/* no need to fix the last element's next ptr */
 			if ( j < strms[i].st_nmediafiles - 1 )
-				mfiles[ nmfiles + j ].mf_nextmf =
-				        strms[i].st_firstmfile +
+				mfiles[ nmfiles + j ].mf_nextmf =
+				        strms[i].st_firstmfile +
 			      (off64_t) ((j+1) * sizeof( invt_mediafile_t ));

 			/* no need to fix the first element's prev ptr */
 			if ( j )
-				mfiles[ nmfiles + j ].mf_prevmf =
-				        strms[i].st_firstmfile +
+				mfiles[ nmfiles + j ].mf_prevmf =
+				        strms[i].st_firstmfile +
 			    (off64_t) ((j-1) * sizeof( invt_mediafile_t ));
 		}

-		/* adjust the offsets of the first and the last elements
+		/* adjust the offsets of the first and the last elements
 		   in the mediafile chain */
 		mfiles[ nmfiles ].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
 		mfiles[ nmfiles - 1 ].mf_nextmf = 0;
-
+
 	}

 	/* first put the streams. hdr already points at the right place */
-	if ( PUT_REC_NOLOCK( fd, strms, nstm * sizeof( invt_stream_t ),
+	if ( PUT_REC_NOLOCK( fd, strms, nstm * sizeof( invt_stream_t ),
 			     off ) < 0 )
 		return -1;
-
-	if ( PUT_REC_NOLOCK( fd, mfiles, nmfiles * sizeof( invt_mediafile_t ),
+
+	if ( PUT_REC_NOLOCK( fd, mfiles, nmfiles * sizeof( invt_mediafile_t ),
 			     mfileoff ) < 0 )
 		return -1;

 	return 1;
-
+
 }


@@ -499,14 +499,14 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,

 void
 stobj_makefname( char *fname )
-{
+{
 	/* come up with a new unique name */
 	uuid_t	fn;
 	char str[UUID_STR_LEN + 1];

 	uuid_generate( fn );
         uuid_unparse( fn, str );
-
+
 	strcpy( fname, INV_DIRPATH );
 	strcat( fname, "/" );
 	strcat( fname, str );
@@ -516,7 +516,7 @@ stobj_makefname( char *fname )
 }


-
+



@@ -525,13 +525,13 @@ stobj_makefname( char *fname )
 int
 stobj_create( char *fname )
 {
-	int fd;
+	int fd;
 	invt_sescounter_t sescnt;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;

 #ifdef INVT_DEBUG
 	mlog( MLOG_VERBOSE | MLOG_INV, "INV: creating storage obj %s\n", fname);
-#endif
+#endif

 	/* create the new storage object */
 	if (( fd = open( fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
@@ -539,10 +539,10 @@ stobj_create( char *fname )
 		memset( fname, 0, INV_STRLEN );
 		return -1;
 	}
-
+
 	INVLOCK( fd, LOCK_EX );
 	fchmod( fd, INV_PERMS );
-
+
 	sescnt.ic_vernum = INV_VERSION;
 	sescnt.ic_curnum = 0; /* there are no sessions as yet */
 	sescnt.ic_maxnum = INVT_STOBJ_MAXSESSIONS;
@@ -554,7 +554,7 @@ stobj_create( char *fname )
 		close( fd );
 		return -1;
 	}
-
+
 	INVLOCK( fd, LOCK_UN );
 	return fd;
 }
@@ -569,21 +569,21 @@ stobj_create( char *fname )


 int
-stobj_create_session(
-	inv_sestoken_t tok,
+stobj_create_session(
+	inv_sestoken_t tok,
 	int fd, /* kept locked EX by caller */
-	invt_sescounter_t *sescnt,
-	invt_session_t *ses,
+	invt_sescounter_t *sescnt,
+	invt_session_t *ses,
 	invt_seshdr_t *hdr )
 {
 	off64_t hoff;
-
+
 	assert( tok && sescnt && ses && hdr );

 	hdr->sh_sess_off = -1;
 	ses->s_cur_nstreams = 0;
-
-	if ((hoff = stobj_put_session( fd, sescnt, ses, hdr, NULL, NULL ))
+
+	if ((hoff = stobj_put_session( fd, sescnt, ses, hdr, NULL, NULL ))
 	    < 0) {
 		return -1;
 	}
@@ -630,7 +630,7 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 	   we also need to link the new mediafile into the linked-list of
 	   media files of this stream */

-	if ( GET_REC_NOLOCK( fd, &stream, sizeof( stream ),
+	if ( GET_REC_NOLOCK( fd, &stream, sizeof( stream ),
 			     tok->md_stream_off ) < 0 )
 		return -1;

@@ -648,34 +648,34 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 #ifdef INVT_DEBUG
 	mlog (MLOG_VERBOSE, "#################### mediafile #%d "
 	      "###################\n", stream.st_nmediafiles);
-#endif
+#endif
 	/* add the new mediafile at the tail of the list */
-
-	mf->mf_nextmf = tok->md_stream_off;
+
+	mf->mf_nextmf = tok->md_stream_off;
 	mf->mf_prevmf = stream.st_lastmfile;

-
+
 	if ( tok->md_lastmfile )
-		tok->md_lastmfile->mf_nextmf = pos;
+		tok->md_lastmfile->mf_nextmf = pos;
 	else {
 		stream.st_firstmfile = pos;
 	}

 	stream.st_lastmfile = pos;

-
+
 	/* write the stream to disk */
-	if ( PUT_REC_NOLOCK( fd, &stream, sizeof( stream ),
+	if ( PUT_REC_NOLOCK( fd, &stream, sizeof( stream ),
 			     tok->md_stream_off ) < 0 )
 		return -1;
-
+
 	/* write the prev media file to disk too */
 	if ( tok->md_lastmfile ) {
-		rval = PUT_REC_NOLOCK( fd, tok->md_lastmfile,
-				       sizeof( invt_mediafile_t ),
+		rval = PUT_REC_NOLOCK( fd, tok->md_lastmfile,
+				       sizeof( invt_mediafile_t ),
 				       mf->mf_prevmf );
 		free (  tok->md_lastmfile );
-		if ( rval < 0 )
+		if ( rval < 0 )
 			return -1;
 	}

@@ -709,11 +709,11 @@ stobj_put_mediafile( inv_stmtoken_t tok, invt_mediafile_t *mf )
 /*----------------------------------------------------------------------*/

 int
-stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr,
+stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr,
 		     invt_session_t *ses )
 {
 	int rval;
-	int fd = tok->sd_invtok->d_stobj_fd;
+	int fd = tok->sd_invtok->d_stobj_fd;

 	/* get the session header first */
 	if ( ( rval = GET_REC_NOLOCK( fd, hdr, sizeof( invt_seshdr_t ),
@@ -721,7 +721,7 @@ stobj_get_sessinfo ( inv_sestoken_t tok, invt_seshdr_t *hdr,
 		rval = GET_REC_NOLOCK( fd, ses, sizeof( invt_session_t ),
 			     tok->sd_session_off );
 	}
-
+
 	return rval;
 }

@@ -759,9 +759,9 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 		free ( strms );
 		return BOOL_FALSE;
 	}
-
+
 	for ( i = 0; i < ses->s_cur_nstreams; i++ )
-		sessz += sizeof( invt_mediafile_t ) *
+		sessz += sizeof( invt_mediafile_t ) *
 			 (size_t) strms[i].st_nmediafiles;

 	/* Now we know how big this entire thing is going to be */
@@ -770,15 +770,15 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,

 	/* Copy everything. Note that we don't bother to adjust the offsets
 	   either in the seshdr or in the mediafiles, because we don't need
-	   those in order to restore this session ( since everything's
+	   those in order to restore this session ( since everything's
 	   contiguous ) */

-	/* magic cookie that we put for sanity checking in case of an
+	/* magic cookie that we put for sanity checking in case of an
 	   earthquake or something :) */
-	strcpy( sesbuf, INVTSESS_COOKIE );
+	strcpy( sesbuf, INVTSESS_COOKIE );
 	sesbuf += (size_t)( strlen( INVTSESS_COOKIE ) * sizeof( char ) );
-
-	/* This was originally INV_VERSION. Changed it to mean packed inventory
+
+	/* This was originally INV_VERSION. Changed it to mean packed inventory
 	 * version number and added another inv_version_t to contain the INV_VERSION.
 	 * The primary intent of this change was to make everything 64 bit aligned,
 	 * but we also got the advantage of separating the packed inv version from
@@ -805,11 +805,11 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	/* now append all the mediafiles */
 	for ( i = 0; i < ses->s_cur_nstreams; i++ ) {
 		off = strms[i].st_firstmfile;
-		for ( j = 0; j < strms[i].st_nmediafiles;
-		     j++,
+		for ( j = 0; j < strms[i].st_nmediafiles;
+		     j++,
 		     off = mf.mf_nextmf ) {
 			assert( off );
-			if ( GET_REC_NOLOCK( fd, &mf,
+			if ( GET_REC_NOLOCK( fd, &mf,
 					     sizeof( invt_mediafile_t ),
 					     off ) <= 0 ) {
 				free( strms );
@@ -837,8 +837,8 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,

 bool_t
 stobj_getsession_byuuid(
-	int fd,
-	invt_seshdr_t *hdr,
+	int fd,
+	invt_seshdr_t *hdr,
 	void *sesid,
 	void **buf )
 {
@@ -848,19 +848,19 @@ stobj_getsession_byuuid(
 	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
 			     hdr->sh_sess_off ) < 0 )
 		return -1;
-
+
 	/* now see if this is the one that caller is askin for */
 	if (uuid_compare(ses.s_sesid, *((uuid_t *)sesid))) {
-		return BOOL_FALSE;
+		return BOOL_FALSE;
 	}

-	/* yay. we found the session. so, make the session struct and
+	/* yay. we found the session. so, make the session struct and
 	   put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);

 	return BOOL_TRUE;
-
-}
+
+}



@@ -873,8 +873,8 @@ stobj_getsession_byuuid(

 bool_t
 stobj_getsession_bylabel(
-	int fd,
-	invt_seshdr_t *hdr,
+	int fd,
+	invt_seshdr_t *hdr,
 	void *seslabel,
 	void **buf )
 {
@@ -887,16 +887,16 @@ stobj_getsession_bylabel(

 	/* now see if this is the one that caller is askin for */
 	if (! STREQL(ses.s_label, (char *)seslabel)) {
-		return BOOL_FALSE;
+		return BOOL_FALSE;
 	}

-	/* yay. we found the session. so, make the session struct and
+	/* yay. we found the session. so, make the session struct and
 	   put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);

 	return BOOL_TRUE;
-
-}
+
+}


 /*----------------------------------------------------------------------*/
@@ -907,8 +907,8 @@ stobj_getsession_bylabel(

 /* ARGSUSED */
 bool_t
-stobj_delete_mobj(int fd,
-		  invt_seshdr_t *hdr,
+stobj_delete_mobj(int fd,
+		  invt_seshdr_t *hdr,
 		  void *arg ,
 		  void **buf )
 {
@@ -928,28 +928,28 @@ stobj_delete_mobj(int fd,

 	/* now get all the streams of this session */
 	strms = calloc ( ses.s_cur_nstreams, sizeof( invt_stream_t ) );
-	if ( GET_REC_NOLOCK( fd, strms,
-			     sizeof( invt_stream_t ) * ses.s_cur_nstreams,
+	if ( GET_REC_NOLOCK( fd, strms,
+			     sizeof( invt_stream_t ) * ses.s_cur_nstreams,
 			     hdr->sh_streams_off ) < 0 ) {
 		free ( strms );
 		return BOOL_FALSE;
 	}
-
+
 	/* now look at all the mediafiles in all the streams */
 	for ( i = 0; i < ses.s_cur_nstreams; i++ ) {
 		off = strms[i].st_firstmfile;
 		nmfiles = strms[i].st_nmediafiles;
 		mfiles = mf = calloc( nmfiles, sizeof( invt_mediafile_t ) );
-		for ( j = 0; j < nmfiles;
-		     j++,
+		for ( j = 0; j < nmfiles;
+		     j++,
 		     off = mf->mf_nextmf,
 		     mf++ ) {
-
+
 /*  The prob is that we need to keep track of where we got these mfiles from
     as we get them, or we wont know how to put them back if they are dirty.
 */
 			assert( off );
-			if ( GET_REC_NOLOCK( fd, mf,
+			if ( GET_REC_NOLOCK( fd, mf,
 					     sizeof( invt_mediafile_t ),
 					     off ) <= 0 ) {
 				free( strms );
@@ -969,7 +969,7 @@ stobj_delete_mobj(int fd,
 				printf(" found one\n" );
 #endif

-/*                                dirty = BOOL_TRUE;
+/*                                dirty = BOOL_TRUE;

 				if ( j == 0 )
 				       strms[i].st_firstmfile = mf->mf_nextmf;
@@ -1003,7 +1003,7 @@ stobj_delete_mobj(int fd,
 /*----------------------------------------------------------------------*/

 bool_t
-stobj_unpack_sessinfo(
+stobj_unpack_sessinfo(
         void              *bufp,
         size_t             bufsz,
 	invt_sessinfo_t   *s )
@@ -1011,9 +1011,9 @@ stobj_unpack_sessinfo(
 	uint 		 i;
 	char	         *tmpbuf;
 	char 		 *p = (char *)bufp;
-
+
 	assert ( bufp );
-
+
 	tmpbuf = (char *)malloc(bufsz);

 	/* first make sure that the magic cookie at the beginning is right.
@@ -1038,16 +1038,16 @@ stobj_unpack_sessinfo(
 		p += sizeof( inv_version_t );

 		/* We hit a 64 bit alignment issue at this point leading to a
-		 * SIGBUS and core dump. The best way to handle it is to
+		 * SIGBUS and core dump. The best way to handle it is to
 		 * bcopy the remaining part of bufp to a new malloc'ed area
 		 * which will be 64 bit aligned. This is a memory leak , but not much.
 		 * Have to do this because xfsrestore does another round of
 		 * unpack later , so can't disturb the original data.
-		 * This is fixed in PACKED_INV_VERSION_2 by adding another (inv_version_t) to
+		 * This is fixed in PACKED_INV_VERSION_2 by adding another (inv_version_t) to
 		 * have the INV_VERSION. This makes everything 64 bit aligned.
 		 */

-		tempsz = bufsz - (strlen( INVTSESS_COOKIE ) * sizeof( char ))
+		tempsz = bufsz - (strlen( INVTSESS_COOKIE ) * sizeof( char ))
 			       - sizeof( inv_version_t ) ;
 		temp_p = calloc(1, tempsz);
 		bcopy(p, temp_p, tempsz);
@@ -1063,7 +1063,7 @@ stobj_unpack_sessinfo(
 		      "INV: inv_put_session: unknown packed inventory version"
 		      " %d\n"), *( inv_version_t *) p);
 		return BOOL_FALSE;
-	}
+	}

 	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
 	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
@@ -1071,7 +1071,7 @@ stobj_unpack_sessinfo(
 	/* get the seshdr and then, the remainder of the session */
 	s->seshdr = (invt_seshdr_t *)p;
 	s->seshdr->sh_sess_off = -1;
-	p += sizeof( invt_seshdr_t );
+	p += sizeof( invt_seshdr_t );


 	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
@@ -1094,11 +1094,11 @@ stobj_unpack_sessinfo(
 		uint j;
 		invt_mediafile_t *mmf = s->mfiles;
 		for (i=0; i< s->ses->s_cur_nstreams; i++ ) {
-			for (j=0; j< s->strms[ i ].st_nmediafiles;
+			for (j=0; j< s->strms[ i ].st_nmediafiles;
 			     j++, mmf++ )
 				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
 				bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
-				put_invtrecord( tmpfd, &mmf->mf_moid,
+				put_invtrecord( tmpfd, &mmf->mf_moid,
 					 sizeof( uuid_t ), 0, SEEK_END, 0 );
 		}
 		close( tmpfd );
@@ -1108,16 +1108,16 @@ stobj_unpack_sessinfo(
 		p += (size_t) ( s->strms[ i ].st_nmediafiles )
 			* sizeof( invt_mediafile_t );
 	}
-
-	/* sanity check the size of the buffer given to us vs. the size it
+
+	/* sanity check the size of the buffer given to us vs. the size it
 	   should be */
 	if ( (size_t) ( p - (char *) bufp ) != bufsz ) {
-		mlog( MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
+		mlog( MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
 		      (int)( p - (char *) bufp ), (int) bufsz,
 	      (int) ( sizeof( invt_entry_t ) ) );
 	}
 	assert( (size_t) ( p - (char *) bufp ) == bufsz );
-
+
 	return BOOL_TRUE;
 }

@@ -1138,7 +1138,7 @@ stobj_make_invsess( int fd, inv_session_t **buf, invt_seshdr_t *hdr )
 	    < 0 ) {
 		return -1;
 	}
-
+
 	return stobj_copy_invsess(fd, hdr, &ses, buf);
 }

@@ -1168,7 +1168,7 @@ stobj_convert_strm(inv_stream_t *expstrm, invt_stream_t *strm)

 	expstrm->st_interrupted = strm->st_interrupted;
 	expstrm->st_startino = strm->st_startino.ino;
-	expstrm->st_startino_off =
+	expstrm->st_startino_off =
 		strm->st_startino.offset;
 	expstrm->st_endino = strm->st_endino.ino;
 	expstrm->st_endino_off = strm->st_endino.offset;
@@ -1181,7 +1181,7 @@ stobj_convert_strm(inv_stream_t *expstrm, invt_stream_t *strm)
 }

 void
-stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
+stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 		      invt_seshdr_t *hdr)
 {
 	ises->s_time = hdr->sh_time;
@@ -1208,7 +1208,7 @@ stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 /*----------------------------------------------------------------------*/

 int
-stobj_copy_invsess(int fd,
+stobj_copy_invsess(int fd,
 		   invt_seshdr_t *hdr,
 		   invt_session_t *ses,
 		   inv_session_t **buf)
@@ -1218,11 +1218,11 @@ stobj_copy_invsess(int fd,
 	int i;
 	invt_mediafile_t mf;

-	strms = calloc ( ses->s_cur_nstreams, sizeof( invt_stream_t ) );
+	strms = calloc ( ses->s_cur_nstreams, sizeof( invt_stream_t ) );

 	/* load in all the stream-headers */
-	if ( GET_REC_NOLOCK( fd, strms,
-			     ses->s_cur_nstreams * sizeof( invt_stream_t ),
+	if ( GET_REC_NOLOCK( fd, strms,
+			     ses->s_cur_nstreams * sizeof( invt_stream_t ),
 			     hdr->sh_streams_off ) < 0 ) {
 		free (strms);
 		return -1;
@@ -1231,13 +1231,13 @@ stobj_copy_invsess(int fd,
 	ises = calloc( 1, sizeof( inv_session_t ) );
 	stobj_convert_session(ises, ses, hdr);
 	ises->s_streams = calloc(ses->s_cur_nstreams, sizeof( inv_stream_t ));
-
+
 	/* fill in the stream structures too */
 	i = (int) ses->s_cur_nstreams;
 	while ( i-- ) {
 		off64_t		 off;
 		uint            j, nmf;
-
+
 		stobj_convert_strm(&ises->s_streams[i], &strms[i]);
 		nmf = strms[i].st_nmediafiles;
 		off = strms[i].st_firstmfile;
@@ -1247,11 +1247,11 @@ stobj_copy_invsess(int fd,
 						    sizeof( inv_mediafile_t ) );
 		assert( !nmf || ises->s_streams[i].st_mediafiles );

-		for ( j = 0; j < nmf;
-		      j++,
+		for ( j = 0; j < nmf;
+		      j++,
 		      off = mf.mf_nextmf ) {
 			assert( off );
-			if ( GET_REC_NOLOCK( fd, &mf,
+			if ( GET_REC_NOLOCK( fd, &mf,
 					     sizeof( invt_mediafile_t ),
 					     off ) <= 0 ) {
 				INV_PERROR( "stobj::make_invsess\n" );
@@ -1272,9 +1272,9 @@ stobj_copy_invsess(int fd,
 				return -1;
 			}
 		}
-
+
 	}
-
+

 	free( strms );
 	*buf = ises;
@@ -1314,7 +1314,7 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 					     mf++ );
 		}
 	}
-
+
 	*buf = ises;
 }

@@ -1323,7 +1323,7 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 int
 stobj_hdrcmp( const void *h1, const void *h2 )
 {
-	return (int) ( ((invt_seshdr_t *)h1)->sh_time -
+	return (int) ( ((invt_seshdr_t *)h1)->sh_time -
 		       ((invt_seshdr_t *)h2)->sh_time );
 }

@@ -1354,21 +1354,21 @@ mobj_eql ( inv_mediafile_t *mfp, invt_mobjinfo_t *mobj )
 {

 	if ( mobj->type == INVT_MOID ) {
-		if ( !uuid_compare( *((uuid_t*) mobj->value),
+		if ( !uuid_compare( *((uuid_t*) mobj->value),
 			      mfp->m_moid) ) {
 			return BOOL_TRUE;
 		}
 	} else {
-		if ( STREQL( (char*) mobj->value,
+		if ( STREQL( (char*) mobj->value,
 			    mfp->m_label ) ) {
 			return BOOL_TRUE;
 		}
 	}
-
+
 	return BOOL_FALSE;
 }

-
+
 bool_t
 check_for_mobj ( inv_session_t *ses, invt_mobjinfo_t *mobj )
 {
@@ -1405,7 +1405,7 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 		if (!check_for_mobj (ses, mobj))
 			return;
 	}
-
+
 	if ( ref == 0 || fsidxprinted != (uint) prctx->index ) {
 		fsidxprinted = (uint) prctx->index;

@@ -1413,7 +1413,7 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 		uuid_unparse( ses->s_fsid, str );
 		printf("\tfs id:\t\t%s\n", str);
 	}
-
+
 	if (prctx->depth == PR_FSONLY)
 		return;

@@ -1431,7 +1431,7 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 	printf("\t\tresumed:\t%s\n", ses->s_isresumed ? "YES" : "NO" );
 	printf( "\t\tsubtree:\t%s\n", ses->s_ispartial ? "YES" : "NO" );
 	printf("\t\tstreams:\t%d\n", ses->s_nstreams );
-
+
 	if (prctx->depth == PR_SESSONLY )
 		return;

@@ -1474,7 +1474,7 @@ DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 			}
 			printf( "\t\t\t\tmfile size:\t%llu\n",
 				(unsigned long long)mfp->m_size);
-
+
 			if (! mfp->m_isinvdump) {
 				printf( "\t\t\t\tmfile start:"
 					"\tino %llu offset %lld\n",
diff --git a/inventory/inventory.h b/inventory/inventory.h
index c1d7403..076b83e 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -30,8 +30,8 @@
  * knowledge of the functionalities, some abstractions, and even typical queries
  * of dump() and restore() and uses this knowledge in formulating its storage
  * structure on disk. All these things, of course, are completely abstract with
- * respect to the clients of the inventory.
- *
+ * respect to the clients of the inventory.
+ *
  */

 #define INV_DIRPATH		inv_dirpath()
@@ -45,12 +45,12 @@

 typedef uint32_t		inv_version_t;

-/* This is the general inventory version.
+/* This is the general inventory version.
  */
-#define INV_VERSION		(inv_version_t) 1
+#define INV_VERSION		(inv_version_t) 1

 /* This is the version of the on-tape (packed) inventory.
- * version 2 has an extra inv_version_t in it to make everything
+ * version 2 has an extra inv_version_t in it to make everything
  * 64 bit aligned.
  */
 #define PACKED_INV_VERSION_1	(inv_version_t) 1
@@ -106,13 +106,13 @@ typedef enum {
 	INV_BY_DEVPATH
 } inv_predicate_t;

-
+
 typedef enum {
 	INV_SEARCH_ONLY,
 	INV_SEARCH_N_MOD
 } inv_oflag_t;

-
+
 typedef struct inv_mediafile {
 	uuid_t		 m_moid;	/* media object id */
 	uint		 m_mfile_index; /* index within the media object */
@@ -122,7 +122,7 @@ typedef struct inv_mediafile {
 	off64_t		 m_endino_off;	/* .. media file with. */
 	off64_t		 m_size;	/* size of mediafile in bytes */
 	bool_t           m_isgood;      /* distinguishes good mfiles */
-	bool_t		 m_isinvdump;	/* is this the mfile that has the dump
+	bool_t		 m_isinvdump;	/* is this the mfile that has the dump
 					   of the rest of the session? */
 	char		 m_label[INV_STRLEN];	/* media file label */
 } inv_mediafile_t;
@@ -130,12 +130,12 @@ typedef struct inv_mediafile {

 typedef struct inv_stream {
 	bool_t		st_interrupted;	/* was this stream interrupted ? */
-
+
 	/* duplicate info from mediafiles for speed */
 	xfs_ino_t	st_startino;	/* the starting pt */
 	off64_t		st_startino_off;
-	xfs_ino_t	st_endino;  	/* where we actually ended up. this
-					   means we've written upto but not
+	xfs_ino_t	st_endino;  	/* where we actually ended up. this
+					   means we've written upto but not
 					   including this breakpoint. */
 	off64_t		st_endino_off;
 	char            st_cmdarg[INV_STRLEN]; /* the driver path user entered */
@@ -144,11 +144,11 @@ typedef struct inv_stream {
 } inv_stream_t;


-/*
- * inventory_session_t
+/*
+ * inventory_session_t
  * all the information that is kept on a single dump session of a single
  * file system in the inventory.
- *
+ *
  */

 typedef struct inv_session {
@@ -164,11 +164,11 @@ typedef struct inv_session {
 	uint		 s_nstreams;	/* num of media streams recorded */
 	inv_stream_t	*s_streams;	/* array of streams */
         uint            s_refnum;      /* storage location dependent ref.
-					   used in displaying the session and
+					   used in displaying the session and
 					   nowhere else */
-
+
 } inv_session_t;
-
+


 struct invt_desc_entry;
@@ -186,14 +186,14 @@ typedef struct invt_strdesc_entry	*inv_stmtoken_t;
 /* inventory_open - initializes access to the inventory
  */
 extern inv_idbtoken_t
-inv_open(
-	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
+inv_open(
+	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
 	 inv_oflag_t      forwhat,/* SEARCH_ONLY, SEARCH_N_MOD */
 	 void 		 *pred );/* uuid_t *,char * mntpt, or char *dev */


 extern bool_t
-inv_close(
+inv_close(
 	inv_idbtoken_t	tok );


@@ -209,16 +209,16 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath );
+	char		*devpath );

 extern bool_t
-inv_writesession_close(
+inv_writesession_close(
 	inv_sestoken_t  tok );

 extern inv_stmtoken_t
 inv_stream_open(
 	inv_sestoken_t 	tok,
-	char		*cmdarg );
+	char		*cmdarg );

 extern bool_t
 inv_stream_close(
@@ -226,9 +226,9 @@ inv_stream_close(
 	bool_t 		wasinterrupted );

 extern bool_t
-inv_put_mediafile(
-	inv_stmtoken_t 	tok,
-	uuid_t 		*moid,
+inv_put_mediafile(
+	inv_stmtoken_t 	tok,
+	uuid_t 		*moid,
 	char 		*label,
 	uint		mfileindex,
 	xfs_ino_t	startino,
@@ -243,26 +243,26 @@ inv_put_mediafile(
 /* lasttime_level_lessthan - finds the time of the last dump of the
  * specified file system at a level less than the specified level.
  * if never dumped below the current level, *time is set to NULL.
- *
+ *
  */
 extern bool_t
-inv_lasttime_level_lessthan(
+inv_lasttime_level_lessthan(
 	uuid_t			*fsidp,
 	inv_idbtoken_t 		tok,
 	u_char			level,
 	time32_t		**time); /* out */

 extern bool_t
-inv_lastsession_level_lessthan(
+inv_lastsession_level_lessthan(
 	uuid_t			*fsidp,
-	inv_idbtoken_t 		tok,
+	inv_idbtoken_t 		tok,
 	u_char  		level,
 	inv_session_t		**ses); /* out */

 extern bool_t
-inv_lastsession_level_equalto(
+inv_lastsession_level_equalto(
 	uuid_t			*fsidp,
-	inv_idbtoken_t 		tok,
+	inv_idbtoken_t 		tok,
 	u_char  		level,
 	inv_session_t		**ses); /* out */

diff --git a/inventory/testmain.c b/inventory/testmain.c
index 05e3c02..e43e392 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -90,13 +90,13 @@ recons_test( int howmany )
 {
 	int fd, i, rval = 1;
 	off64_t off = 0;
-
+
 	ses sarr[ SESLIM];
-
+
 	fd = open( sesfile, O_RDONLY );
-
+
 	for ( i=0; i<howmany && i < SESLIM; i++ ){
-		rval = get_invtrecord( fd, &sarr[i],
+		rval = get_invtrecord( fd, &sarr[i],
 				       sizeof( uuid_t ) + sizeof( size_t ), off,
 				       BOOL_FALSE );
 		assert( rval > 0 );
@@ -108,9 +108,9 @@ recons_test( int howmany )
 		assert( rval > 0 );
 		off += sarr[i].sz;
 	}
-
-
-
+
+
+
 	for ( i=0; i<howmany && i < SESLIM; i++ ){
 		if ( inv_put_sessioninfo( sarr[i].buf, sarr[i].sz ) < 0)
 			printf("$ insert failed.\n");
@@ -134,13 +134,13 @@ delete_test( int n )

 	fd = open( "moids", O_RDONLY );
 	if ( fd < 0 ) return -1;
-
+
 	get_invtrecord( fd, &moid, sizeof(uuid_t), (n-1)* sizeof( uuid_t), 0 );
 	uuid_to_string( &moid, &str, &stat );
 	printf("Searching for Moid = %s\n", str );
 	free( str );
 	if (! inv_delete_mediaobj( &moid ) ) return -1;
-
+
 	return 1;

 }
@@ -200,7 +200,7 @@ query_test( int level )
 	time_t *tm;
 	inv_session_t *ses;
 	invt_pr_ctx_t prctx;
-
+
 	if (level == -2) {
 		printf("mount pt %s\n",sesfile);
 		tok = inv_open( INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile );
@@ -208,7 +208,7 @@ query_test( int level )
 		idx_DEBUG_print (tok->d_invindex_fd);
 		return 1;
 	}
-
+
 	for (i = 7; i<8; i++) {
 		printf("\n\n\n----------------------------------\n"
 		       "$ Searching fs %s\n", mnt_str[7-i] );
@@ -239,8 +239,8 @@ query_test( int level )
 		inv_close( tok );
 	}
 	return 1;
-}
-
+}
+

 /*----------------------------------------------------------------------*/
 /*                                                                      */
@@ -256,7 +256,7 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 	uuid_t *fsidp;
 	inv_idbtoken_t tok1;
 	inv_sestoken_t tok2;
-	inv_stmtoken_t tok3;
+	inv_stmtoken_t tok3;
 	char *dev, *mnt;
 	char label[120];
 	uuid_t fsidarr[8], labelid;
@@ -314,13 +314,13 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 		free (str);
 		strbuf[8] = '\0';
 		sprintf(label,"%s_%s (%d)\0","SESSION_LABEL", strbuf, i );
-
+
 		tok2 = inv_writesession_open(tok1, fsidp,
 					     &labelid,
-					     label,
+					     label,
 					     (bool_t)i%2,
 					     (bool_t)i%2,
-					     dumplevel, nstreams,
+					     dumplevel, nstreams,
 					     time(NULL),
 					     mnt, dev );
 		assert (tok2 != INV_TOKEN_NULL );
@@ -333,7 +333,7 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 					      k*100 + 99 );
 			inv_stream_close( tok3, BOOL_TRUE );
 		}
-
+
 #ifdef RECONS
 		if (inv_get_sessioninfo( tok2, &bufp, &sz ) == BOOL_TRUE ) {
 			put_invtrecord( rfd, fsidp, sizeof( uuid_t ), off,
@@ -351,8 +351,8 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
 #endif
 		inv_writesession_close( tok2 );
 		inv_close( tok1 );
-	}
-#ifdef RECONS
+	}
+#ifdef RECONS
 	close( rfd );
 #endif
 	return 1;
@@ -375,10 +375,10 @@ mp_test(int nstreams)

 	tok2 = inv_writesession_open(tok1, fsidp,
 				     &labelid,
-				     label,
+				     label,
 				     (bool_t)i%2,
 				     (bool_t)i%2,
-				     dumplevel, nstreams,
+				     dumplevel, nstreams,
 				     time(NULL),
 				     mnt, dev );
 	assert (tok2 != INV_TOKEN_NULL );
@@ -392,7 +392,7 @@ mp_test(int nstreams)
 					      k*100 + 99 );
 			inv_stream_close( tok3, BOOL_TRUE );
 		}
-#endif
+#endif
 }


@@ -404,7 +404,7 @@ mp_test(int nstreams)
 /*                                                                      */
 /*----------------------------------------------------------------------*/

-
+
 main(int argc, char *argv[])
 {
 	int rval = -1, nsess = 8, nmedia = 2, nstreams = 3, level = 0;
@@ -418,12 +418,12 @@ main(int argc, char *argv[])
 	progname = argv[0];
 	sesfile = "sessions";
 	assert( argc > 1 );
-
+
 	mlog_init( argc, argv );

 	if (! inv_DEBUG_print(argc, argv))
 		return 0;
-
+
 	optind = 1;
 	optarg = 0;

@@ -433,21 +433,21 @@ main(int argc, char *argv[])
 			op = WRI;
 			break;
 		      case 'r':
-			op = REC;
+			op = REC;
 			break;
-
+
 		      case 'q':
-			op = QUE;
+			op = QUE;
 			break;
-
+
 		      case 'd':
-			op = DEL;
+			op = DEL;
 			break;

 		      case 'z':
 			op = MP;
 			break;
-
+
 		      case 'g':
 			op = QUE2;
 			break;
@@ -463,7 +463,7 @@ main(int argc, char *argv[])
 		      case 's':
 			nsess = atoi(optarg);
 			break;
-
+
 		      case 'l':
 			level = atoi(optarg);
 			break;
@@ -471,24 +471,24 @@ main(int argc, char *argv[])
 		      case 't':
 			nstreams = atoi(optarg);
 			break;
-
+
 		      case 'm':
 			nmedia = atoi( optarg );
 			break;
 		      case 'v':
 			break;
-
+
 		      case 'f':
 			sesfile = optarg;
 			break;

 		      default:
-			usage();
+			usage();
 			break;
 		}
 	}
-
-
+
+
 	if ( op == WRI )
 		rval = write_test( nsess, nstreams, nmedia, level );
 	else if ( op == QUE )
@@ -504,10 +504,10 @@ main(int argc, char *argv[])
 			rval = sess_queries_byuuid(uuid);
 		else if (label)
 			rval = sess_queries_bylabel(label);
-		}
+		}
 	else
 		usage();
-
+
 	if (rval < 0 )
 		printf( "aborted\n");
 	else
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 4284cd1..a4333ad 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -87,7 +87,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 	    memmove(fstabentry,
 		    fstabentry + 1,
 		    (sizeof(invt_fstab_t) * (fstab_file[fidx].counter->ic_curnum - fstabentry_idx - 1)));
-
+
 	    fstab_file[fidx].data[d->data_idx] = NULL;

 	    for(i = d->data_idx + 1; i < fstab_file[fidx].numrecords; i++) {
@@ -119,7 +119,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)

 	/* copy new data to mmap */
 	memmove(dest, fstabentry, sizeof(*fstabentry));
-
+
 	/* increment counter */
 	fstab_file[0].counter->ic_curnum++;
     }
@@ -137,7 +137,7 @@ fstab_select(WINDOW *win, node_t *current, node_t *list)
 	return 0;
     }
     d = (data_t *)(current->data);
-
+
     if(d->expanded == TRUE) {
 	return menu_collapse(win, current, list);
     }
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 82d89d9..5e540a3 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -156,7 +156,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 				&ses,
 				&strms,
 				&mfiles);
-
+
 		    insert_stobj_into_stobjfile(dst_fileidx,
 		    		stobj_filename,
 				stobj_fd,
@@ -180,7 +180,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		tmp_parent = ((data_t *)(dst_n->data))->parent;
 		while(dst_n != NULL) {
 		    node_t *tmp_n1;
-
+
 		    dst_d = dst_n->data;

 		    /* close affected invidx file and stobj files */
@@ -221,10 +221,10 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		else {
 		    dest = invidx_file[dst_fileidx].data[invidx_file[dst_fileidx].counter->ic_curnum - 1] + 1;
 		}
-
+
 		/* copy new data to mmap */
 		memmove(dest, inv_entry, sizeof(*inv_entry));
-
+
 		/* increment counter */
 		invidx_file[dst_fileidx].counter->ic_curnum++;

@@ -249,13 +249,13 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		    put_error("Error: unable to copy stobj file: file exists");
 		    return 0;
 		}
-
+
 		snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
 		if(system(cmd) != 0) {
 		    put_error("Error: unable to copy stobj file: cp failed");
 		    return 0;
 		}
-
+
 		open_stobj(dst_stobjfile);
 		return 0;
 	    }
@@ -319,13 +319,13 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		put_error("Error: unable to copy stobj file: file exists");
 		return 0;
 	    }
-
+
 	    snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
 	    if(system(cmd) != 0) {
 		put_error("Error: unable to copy stobj file: cp failed");
 		return 0;
 	    }
-
+
 	    open_stobj(dst_stobjfile);
 	    return 0;
 	}
@@ -335,7 +335,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 }

 int
-create_stobjfile(int invidx_fileidx, char *filename, int fname_len,
+create_stobjfile(int invidx_fileidx, char *filename, int fname_len,
 	invt_seshdr_t *hdr, invt_session_t *ses, invt_stream_t *strms,
 	invt_mediafile_t *mfiles)
 {
@@ -386,7 +386,7 @@ read_stobj_info(int fd, int idx, invt_seshdr_t **out_hdr,
 	else {
 	    mfiles = NULL;
 	}
-    }
+    }
     else {
 	strms = NULL;
 	mfiles = NULL;
@@ -396,7 +396,7 @@ read_stobj_info(int fd, int idx, invt_seshdr_t **out_hdr,
     *out_ses = ses;
     *out_strms = strms;
     *out_mfiles = mfiles;
-
+
     return fd;
 }

@@ -461,7 +461,7 @@ update_invidx_entry(int fd, char *filename, int stobj_fd)
     /* find the start and stop in stobj file */
     lseek(stobj_fd, 0, SEEK_SET);
     read_n_bytes(stobj_fd, &sescnt, sizeof(sescnt), "stobj file");
-
+
     memset(&hdr, 0, sizeof(hdr));
     first_offset = STOBJ_OFFSET(0,0);
     lseek(stobj_fd, first_offset, SEEK_SET);
@@ -488,7 +488,7 @@ update_invidx_entry(int fd, char *filename, int stobj_fd)
 	    return i;
 	}
     }
-
+
     entry.ie_timeperiod.tp_start = start_time;
     entry.ie_timeperiod.tp_end = end_time;
     strcpy(entry.ie_filename, filename);
@@ -534,7 +534,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,

 	for(i = pos; i < sescnt.ic_curnum; i++) {
 	    read_stobj_info(fd, i, &s_hdr, &s_ses, &s_strms, &s_mfiles);
-
+
 	    insert_stobj_into_stobjfile(invidx_fileidx, new_filename, new_fd, s_hdr, s_ses, s_strms, s_mfiles);

 	    free(s_hdr); free(s_ses); free(s_strms); free(s_mfiles);
@@ -585,7 +585,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,

 static void
 stobj_makefname_len( char *fname, int fname_len )
-{
+{
     /* come up with a new unique name */
     uuid_t	fn;
     char	str[UUID_STR_LEN + 1];
@@ -599,14 +599,14 @@ stobj_makefname_len( char *fname, int fname_len )
 int
 stobj_create( char *fname )
 {
-    int fd;
+    int fd;
     invt_sescounter_t sescnt;

     /* create the new storage object */
     if (( fd = open( fname, O_RDWR | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR )) < 0 ) {
 	return -1;
     }
-
+
     INVLOCK( fd, LOCK_EX );
     fchmod( fd, INV_PERMS );

@@ -618,13 +618,13 @@ stobj_create( char *fname )

     lseek(fd, 0, SEEK_SET);
     write_n_bytes ( fd, (char *)&sescnt, sizeof(sescnt), "new stobj file" );
-
+
     INVLOCK( fd, LOCK_UN );
     return fd;
 }

 int
-stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
+stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
 {
@@ -639,7 +639,7 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 	strms[i].st_firstmfile = mfileoff + (off64_t) ((size_t) nmfiles * sizeof( invt_mediafile_t ) );
 	/* now fix the offsets in mediafiles */
 	for ( j = 0; j < strms[i].st_nmediafiles; j++ ) {
-
+
 	    /* no need to fix the last element's next ptr */
 	    if ( j < strms[i].st_nmediafiles - 1 )
 		mfiles[ nmfiles + j ].mf_nextmf =  strms[i].st_firstmfile + (off64_t) ((j+1) * sizeof( invt_mediafile_t ));
@@ -649,11 +649,11 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		mfiles[ nmfiles + j ].mf_prevmf = strms[i].st_firstmfile + (off64_t) ((j-1) * sizeof( invt_mediafile_t ));
 	}

-	/* adjust the offsets of the first and the last elements
+	/* adjust the offsets of the first and the last elements
 	   in the mediafile chain */
 	mfiles[ nmfiles ].mf_prevmf = 0;
 	nmfiles += strms[i].st_nmediafiles;
-	mfiles[ nmfiles - 1 ].mf_nextmf = 0;
+	mfiles[ nmfiles - 1 ].mf_nextmf = 0;
     }

     /* first put the streams. hdr already points at the right place */
@@ -663,7 +663,7 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
     lseek(fd, mfileoff, SEEK_SET);
     write_n_bytes( fd, mfiles, nmfiles * sizeof( invt_mediafile_t ), "stobj file" );

-    return 1;
+    return 1;
 }

 /*ARGSUSED*/
@@ -771,7 +771,7 @@ find_invidx_node(node_t *list, int inv_fileidx)
 {
     node_t *n;
     data_t *d;
-
+
     n = list;
     while(n != NULL && n->data != NULL) {
     	d = n->data;
@@ -783,7 +783,7 @@ find_invidx_node(node_t *list, int inv_fileidx)
 	}
 	n = n->next;
     }
-
+
     return NULL;
 }

diff --git a/invutil/invutil.c b/invutil/invutil.c
index 06bdeda..e06b1f4 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -112,7 +112,7 @@ main(int argc, char *argv[])
 	    break;
 	case GETOPT_UUID:
 	    if (check_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_CHECKPRUNEFSTAB,
 			 c );
@@ -133,14 +133,14 @@ main(int argc, char *argv[])
 	    break;
 	case GETOPT_CHECKPRUNEFSTAB:
 	    if (mntpnt_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_PRUNEMNT,
 			 c );
 		usage();
 	    }
 	    if (uuid_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_UUID,
 			 c );
@@ -167,7 +167,7 @@ main(int argc, char *argv[])
 	    break;
 	case GETOPT_PRUNEMNT:
 	    if (check_option) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
 			 g_programName,
 			 GETOPT_CHECKPRUNEFSTAB,
 			 c );
@@ -355,10 +355,10 @@ ParseDate(char *strDate)
         "%b %d",
         "%B %d",
         "%m%d%H",
-        "%m%d",
+        "%m%d",
         0};

-    for (fmt = &templateStr[0]; *fmt != NULL; fmt++) {
+    for (fmt = &templateStr[0]; *fmt != NULL; fmt++) {
         memset (&tm, 0, sizeof (struct tm)); /* ensure fields init'ed */
         if (strptime(strDate, *fmt, &tm) != NULL)
             break;
@@ -371,15 +371,15 @@ ParseDate(char *strDate)

     if (*fmt == NULL || (date = mktime(&tm)) < 0) {
         fprintf(stderr, "%s: bad date, \"%s\"\n", g_programName, strDate );
-        usage();
+        usage();
     }

-    /* HACK to ensure tm_isdst is set BEFORE calling mktime(3) */
+    /* HACK to ensure tm_isdst is set BEFORE calling mktime(3) */
     if (tm.tm_isdst) {
         int dst = tm.tm_isdst;
         memset (&tm, 0, sizeof (struct tm));
         tm.tm_isdst = dst;
-        (void)strptime(strDate, *fmt, &tm);
+        (void)strptime(strDate, *fmt, &tm);
         tm.tm_isdst = dst;
         date = mktime(&tm);
     }
@@ -423,7 +423,7 @@ GetNameOfInvIndex (char *inv_path, uuid_t uuid)
     char *name;

     uuid_unparse( uuid, str );
-    name = (char *) malloc( strlen( inv_path ) + 1  + strlen( str )
+    name = (char *) malloc( strlen( inv_path ) + 1  + strlen( str )
 			     + strlen( INV_INVINDEX_PREFIX ) + 1);
     strcpy( name, inv_path );
     strcat( name, "/" );
@@ -506,7 +506,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 		break;
 	    }
 	}
-
+
 	if (!removeflag)
 	{
 	    bool_t IdxCheckOnly = BOOL_TRUE;
@@ -514,7 +514,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	    invname = GetNameOfInvIndex(inv_path, fstabentry[i].ft_uuid);

 #ifdef INV_DEBUG
-	    printf("INV_DEBUG: ft_mountpt = %s, mountPt = %s, r_mf_label = %s\n",
+	    printf("INV_DEBUG: ft_mountpt = %s, mountPt = %s, r_mf_label = %s\n",
 		   fstabentry[i].ft_mountpt, mountPt,
 		   (r_mf_label ? r_mf_label : "(NULL)"));
 #endif
@@ -560,7 +560,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	    }
 	    counter->ic_curnum--;
 	}
-	else
+	else
 	    i++; /* next entry if this entry not removed */
     }

@@ -599,7 +599,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 			   char *idxFileName,
 			   uuid_t *sessionp,
 			   time32_t prunetime,
-			   char *r_mf_label)
+			   char *r_mf_label)
 {
     char	*temp;
     int		fd;
@@ -651,7 +651,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 		   invIndexEntry[i].ie_filename, idxFileName);
 	    printf("         removing index entry \n");
 	    removeflag = BOOL_TRUE;
-	}
+	}

 	if (CheckAndPruneStObjFile(checkonly, invIndexEntry[i].ie_filename,
 		    sessionp, prunetime, r_mf_label) == -1) {
@@ -667,7 +667,7 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
 	    }
 	    counter->ic_curnum--;
 	}
-	else
+	else
 	    i++; /* next entry if this entry not removed */
     }

@@ -712,7 +712,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
 			char *StObjFileName,
 			uuid_t *sessionp,
 			time32_t prunetime,
-		        char *r_mf_label)
+		        char *r_mf_label)
 {
     char	response[GEN_STRLEN];
     char	*temp;
@@ -759,9 +759,9 @@ CheckAndPruneStObjFile( bool_t checkonly,
 	removeflag = BOOL_FALSE;
 	if (StObjhdr->sh_pruned)
 	    prunedcount++;
-
+
 	if (! StObjhdr->sh_pruned) {
-	    printf("            Session %d: %s %s",
+	    printf("            Session %d: %s %s",
 		   sescount++,
 		   StObjses->s_mountpt,
 		   ctime32(&StObjhdr->sh_time));
@@ -783,7 +783,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
 	    invt_mediafile_t *StObjmed;

 	    if (StObjhdr->sh_pruned)
-		printf("            Pruned Session: %s %s",
+		printf("            Pruned Session: %s %s",
 		       StObjses->s_mountpt,
 		       ctime32(&StObjhdr->sh_time));
 	    printf("\t\tdevice:\t\t%s\n", StObjses->s_devpath);
@@ -794,7 +794,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
 	    printf("\t\tstreams:\t%d\n", StObjses->s_cur_nstreams );
 	    for ( i = 0; i < (int) StObjses->s_cur_nstreams; i++ ) {
 		printf( "\t\tstream %d:\n", i);
-		StObjstrm = (invt_stream_t *)(temp +
+		StObjstrm = (invt_stream_t *)(temp +
 					      StObjhdr->sh_streams_off +
 					      (i * sizeof(invt_stream_t)));
 		printf( "\t\t\tpathname:\t%s\n",
@@ -808,7 +808,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
 		printf( "\t\t\tmedia files:\t%d\n",
 			StObjstrm->st_nmediafiles);
 		for ( j = 0; j < StObjstrm->st_nmediafiles; j++) {
-		    StObjmed = (invt_mediafile_t *)(temp +
+		    StObjmed = (invt_mediafile_t *)(temp +
 						    StObjstrm->st_firstmfile +
 						    (j * sizeof(invt_mediafile_t)));
 		    printf( "\t\t\tmfile file %d:\n", j);
@@ -828,7 +828,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
         printf("INV_DEBUG: sh_time = %d, prunetime = %d\n",
 	       StObjhdr->sh_time, prunetime);
         printf("INV_DEBUG: checkonly = %d, sh_pruned = %d\n",
-               checkonly, StObjhdr->sh_pruned);
+               checkonly, StObjhdr->sh_pruned);
 #endif

 	session_match = !uuid_compare(*sessionp, StObjses->s_sesid);
@@ -843,7 +843,7 @@ CheckAndPruneStObjFile( bool_t checkonly,
 	    bool_t GotResponse = BOOL_FALSE;

 	    uuid_unparse( StObjses->s_sesid, str );
-
+
 	    if(force) {
 		printf("-------------------------------------------------\n");
 		printf("Pruning this matching entry:\n");
@@ -868,9 +868,9 @@ CheckAndPruneStObjFile( bool_t checkonly,

 		    printf("\nDo you want to prune this entry: [y/n] ");
 		    fgets( response, GEN_STRLEN, stdin );
-		    chp = strchr( response, '\n');
+		    chp = strchr( response, '\n');
 		    if (chp)
-			*chp = '\0';
+			*chp = '\0';
 		    if (strcasecmp( response, "Y" ) == 0) {
 			removeflag = BOOL_TRUE;
 			GotResponse = BOOL_TRUE;
@@ -944,7 +944,7 @@ uses_specified_mf_label(
 	for ( m = 0; m < StObjstrm->st_nmediafiles; m++, num_media_objects++) {
 	    StObjmed = (invt_mediafile_t *)
 		(temp + StObjstrm->st_firstmfile + (m * sizeof(invt_mediafile_t)));
-	    if (!strncmp(StObjmed->mf_label, r_mf_label,
+	    if (!strncmp(StObjmed->mf_label, r_mf_label,
 			sizeof(StObjmed->mf_label))) {
 		printf("\t\tSpecified media label \"%s\" found - "
 			"pruning session \"%s\"\n",
@@ -1150,7 +1150,7 @@ mmap_n_bytes(int fd, size_t count, bool_t checkonly, char *path)
     temp = mmap( NULL, count,
 		 (checkonly == BOOL_TRUE) ? PROT_READ : PROT_READ|PROT_WRITE,
 		 MAP_SHARED, fd, 0 );
-
+
     if (temp == (void *)-1) {
 	fprintf( stderr, "%s: error in mmap of %ld bytes for file %s\n",
 		 g_programName, (long) count, path);
diff --git a/invutil/menu.c b/invutil/menu.c
index f81f9b6..81baa42 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -109,7 +109,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
     int last_line;
     int size;

-    current = list;
+    current = list;
     last = current;
     current_line = 0;
     last_line = current_line;
@@ -184,7 +184,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		node_t *n = current->prev;

 		while(n != NULL) {
-		    d = ((data_t *)(n->data));
+		    d = ((data_t *)(n->data));
 		    if(d == NULL) {
 			n = n->prev;
 			continue;
@@ -208,7 +208,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		node_t *n = current->next;

 		while(n != NULL) {
-		    d = ((data_t *)(n->data));
+		    d = ((data_t *)(n->data));
 		    if(d == NULL) {
 			n = n->next;
 			continue;
@@ -258,7 +258,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		}
 		i = current_line - 1;
 		while(n != NULL) {
-		    d = ((data_t *)(n->data));
+		    d = ((data_t *)(n->data));
 		    if(d == NULL) {
 			n = n->prev;
 			continue;
diff --git a/invutil/screen.c b/invutil/screen.c
index 6e913a7..5e478c9 100644
--- a/invutil/screen.c
+++ b/invutil/screen.c
@@ -83,6 +83,6 @@ get_string(WINDOW *win, char *prompt, char *response, int len)
     echo();
     wgetnstr(stdscr, response, len);
     noecho();
-
+
     return 0;
 }
diff --git a/invutil/stobj.c b/invutil/stobj.c
index f389c53..582858f 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -454,7 +454,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)

 	parent_session = n;
 	for ( j = 0; j < (int) StObjses->s_cur_nstreams; j++ ) {
-	    StObjstrm = (invt_stream_t *)(stobj_file[idx].mapaddr +
+	    StObjstrm = (invt_stream_t *)(stobj_file[idx].mapaddr +
 					  StObjhdr->sh_streams_off +
 					  (j * sizeof(invt_stream_t)));

@@ -487,10 +487,10 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)

 	    parent_stream = n;
 	    for ( k = 0; k < StObjstrm->st_nmediafiles; k++) {
-		StObjmed = (invt_mediafile_t *)(stobj_file[idx].mapaddr +
+		StObjmed = (invt_mediafile_t *)(stobj_file[idx].mapaddr +
 						StObjstrm->st_firstmfile +
 						(k * sizeof(invt_mediafile_t)));
-
+
 		len = strlen(StObjmed->mf_label) + 26;
 		txt = malloc(len);
 		if(txt == NULL) {
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index bd6f887..edcd611 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -139,7 +139,7 @@ static int _rmt_ioctl(int, unsigned int, void *);
 /*
  *	Do ioctl on file.  Looks just like ioctl(2) to caller.
  */
-
+
 int
 rmtioctl(int fildes, unsigned int request, void *arg)
 {
@@ -159,9 +159,9 @@ rmtioctl(int fildes, unsigned int request, void *arg)
 /*
  * WARNING: MTIOCGET code is highly dependent on the format
  *          of mtget on different platforms
- *          We only support Linux 32/ia64 and IRIX 32/64 for this case.
- *          We use the result of uname(1) (in rmtopen()) and
- *          the size of the mtget structure to determine which
+ *          We only support Linux 32/ia64 and IRIX 32/64 for this case.
+ *          We use the result of uname(1) (in rmtopen()) and
+ *          the size of the mtget structure to determine which
  *          architecture it is.
  */

@@ -178,7 +178,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 	static int onetrip = 0;

 	if (!onetrip) {
-		onetrip = 1;
+		onetrip = 1;
 		init_mtop_map();
 	}

@@ -226,7 +226,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		 *  Grab the status and read it directly into the structure.
 		 *  Since the data is binary data, and the other machine might
 		 *  be IRIX or Linux of a different byte-order,
-		 *  we have to be careful in converting the data.
+		 *  we have to be careful in converting the data.
 		 *
 		 *  NOTE: the original /etc/rmt did NOT support a newline after
 		 *  the S command, and Sun still does not.  Neither does the
@@ -243,7 +243,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		 * and the size of the get structure.
 		 * If we know our rmt host, then verify that the
 		 * structure is the correct size for the supported ones
-		 */
+		 */
  		switch (RMTHOST(fildes)) {
 		    case UNAME_UNDEFINED:
 			_rmt_msg(RMTWARN,
@@ -262,10 +262,10 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			break;
 		    case UNAME_LINUX:
 			if (sizeof(struct linux32_mtget) == rc) {
-			    islinux32 = 1;
+			    islinux32 = 1;
 			}
 			else if (sizeof(struct linux64_mtget) == rc) {
-			    islinux32 = 0;
+			    islinux32 = 0;
 			}
 			else {
 			    _rmt_msg(RMTWARN,
@@ -316,9 +316,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			struct irix_mtget *irixp = (struct irix_mtget *)irixget;

 			if (irixp->mt_type > 0xff) {
-			    /* assume that mt_type should fit in 1 byte */
+			    /* assume that mt_type should fit in 1 byte */

-			    irixp->mt_type   = INT_SWAP(irixp->mt_type, irixp->mt_type);
+			    irixp->mt_type   = INT_SWAP(irixp->mt_type, irixp->mt_type);
 			    irixp->mt_dsreg  = INT_SWAP(irixp->mt_dsreg, irixp->mt_dsreg);
 			    irixp->mt_erreg  = INT_SWAP(irixp->mt_erreg, irixp->mt_erreg);
 			    irixp->mt_resid  = INT_SWAP(irixp->mt_resid, irixp->mt_resid);
@@ -330,9 +330,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			struct linux32_mtget *linuxp = (struct linux32_mtget *)linux32get;

 			if (linuxp->mt_type > 0xffff) {
-			    /* assume that mt_type should fit in 2 bytes */
+			    /* assume that mt_type should fit in 2 bytes */

-			    linuxp->mt_type   = INT_SWAP(linuxp->mt_type, linuxp->mt_type);
+			    linuxp->mt_type   = INT_SWAP(linuxp->mt_type, linuxp->mt_type);
 			    linuxp->mt_dsreg  = INT_SWAP(linuxp->mt_dsreg, linuxp->mt_dsreg);
 			    linuxp->mt_erreg  = INT_SWAP(linuxp->mt_erreg, linuxp->mt_erreg);
 			    linuxp->mt_resid  = INT_SWAP(linuxp->mt_resid, linuxp->mt_resid);
@@ -346,9 +346,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			struct linux64_mtget *linuxp = (struct linux64_mtget *)linux64get;

 			if (linuxp->mt_type > 0xffff) {
-			    /* assume that mt_type should fit in 2 bytes */
+			    /* assume that mt_type should fit in 2 bytes */

-			    linuxp->mt_type   = INT_SWAP(linuxp->mt_type, linuxp->mt_type);
+			    linuxp->mt_type   = INT_SWAP(linuxp->mt_type, linuxp->mt_type);
 			    linuxp->mt_dsreg  = INT_SWAP(linuxp->mt_dsreg, linuxp->mt_dsreg);
 			    linuxp->mt_erreg  = INT_SWAP(linuxp->mt_erreg, linuxp->mt_erreg);
 			    linuxp->mt_resid  = INT_SWAP(linuxp->mt_resid, linuxp->mt_resid);
@@ -359,8 +359,8 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			}
 		}

-		/*
-		 * now mtget has the correct (byte-swapped if needed) data,
+		/*
+		 * now mtget has the correct (byte-swapped if needed) data,
                  * so we just need to copy over the fields which are possibly
                  * of different length and different semantics.
 		 */
diff --git a/librmt/rmtlib.h b/librmt/rmtlib.h
index 1f877ca..6373075 100644
--- a/librmt/rmtlib.h
+++ b/librmt/rmtlib.h
@@ -51,7 +51,7 @@
  *
  *	READ --- Return the number of the read side file descriptor
  *	WRITE --- Return the number of the write side file descriptor
- *	RMTHOST --- Return an id which says host type from uname
+ *	RMTHOST --- Return an id which says host type from uname
  */

 /* rmt msg types */
diff --git a/restore/bag.c b/restore/bag.c
index 55bba73..dfe7aa5 100644
--- a/restore/bag.c
+++ b/restore/bag.c
@@ -116,7 +116,7 @@ bag_find( bag_t *bagp,
 	      ;
 	      p = p->be_nextp )
 		;
-
+
 	if ( ! p || p->be_key != key ) {
 		*payloadpp = 0;
 		return 0;
diff --git a/restore/content.c b/restore/content.c
index 7c4a81f..078c6b8 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -491,7 +491,7 @@ struct pers {

 		partial_rest_t parrest[ STREAM_SIMMAX * 2 - 2 ];
 			/* record of bytes restored to partially restored files.
-			 * Max possible is two per stream except the first
+			 * Max possible is two per stream except the first
 			 * drive will never finish another drives file and the
 			 * last drive will never leave a file for another to
 			 * complete.
@@ -911,7 +911,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	int rval;
 	bool_t fullpr;

-	/* Calculate the size needed for the persistent inventory
+	/* Calculate the size needed for the persistent inventory
 	 */
 	for ( perssz = pgsz; perssz < sizeof(pers_t); perssz += pgsz )
 		;
@@ -1289,7 +1289,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * destination directory, unless this is a toc, in which case
 	 * it will be placed in the current directory. in either case, an
 	 * alternate directory may be specified on the command line.
-	 * if this is toconly, modify the housekeeping dir's name with
+	 * if this is toconly, modify the housekeeping dir's name with
 	 * the pid.
 	 */
 	if ( ! tranp->t_hkdir ) {
@@ -1580,7 +1580,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			      GETOPT_SETDM );
 			return BOOL_FALSE;
 		}
-		if ( ! restoreextattrpr &&
+		if ( ! restoreextattrpr &&
 		       persp->a.restoreextattrpr != restoreextattrpr) {
 			mlog( MLOG_NORMAL | MLOG_ERROR, _(
 			     "-%c cannot reset flag from previous restore\n"),
@@ -2759,7 +2759,7 @@ content_statline( char **linespp[ ] )
 			 (unsigned long long)tranp->t_direntcnt,
 			 elapsed );
 		assert( strlen( statline[ 0 ] ) < STATLINESZ );
-
+
 		return 1;
 	}

@@ -2799,7 +2799,7 @@ content_statline( char **linespp[ ] )
 		 percent,
 		 elapsed );
 	assert( strlen( statline[ 0 ] ) < STATLINESZ );
-
+
 	/* return buffer to caller
 	 */
 	return 1;
@@ -3547,7 +3547,7 @@ applynondirdump( drive_t *drivep,
 			 */
 			( * dop->do_get_mark )( drivep, &drivemark );

-			/* read the file header.
+			/* read the file header.
 			 */
 			rv = read_filehdr( drivep, fhdrp, fhcs );
 			switch( rv ) {
@@ -3751,7 +3751,7 @@ Inv_validate_cmdline( void )
 	if ( ok && sessp ) {
 		uuid_t baseid;

-		uuid_clear(baseid);
+		uuid_clear(baseid);
                 askinvforbaseof( baseid, sessp );
 		if ( ! dumpcompat( sessp->s_isresumed,
 				   ( ix_t )( sessp->s_level ),
@@ -3834,13 +3834,13 @@ Media_atnondir( Media_t *Mediap )
  * dump ID. smart enough to know that if purpose was search but is now dir,
  * current media file can be returned again. same for other transitions.
  * always traverses the media object in a forward direction, beginning with
- * current media file, wrapping around to beginning of media if necessary.
+ * current media file, wrapping around to beginning of media if necessary.
  * also supplies fresh hdr pointers and drive manager. in current
  * implementation these do not change, but will when we use new TLM. does
  * fine positioning within media file according to purpose of request.
  *
- * Note:
- * The difference between rval and rv.
+ * Note:
+ * The difference between rval and rv.
  * rval is used for the drive_* functions (e.g. do_begin_read)
  * and will take on values such as DRIVE_ERROR_*.
  * However, it also set to 0 for no error and 1 for error.
@@ -4103,7 +4103,7 @@ Media_mfile_next( Media_t *Mediap,
  * pv: 766024; tes@engr
  * The setting of emptypr, in my opinion, should only happen
  * in the case that the drive does not have a tape online.
- * This corresponds to a couple of cases in prepare_drive().
+ * This corresponds to a couple of cases in prepare_drive().
  * Otherwise, when we go to a newmedia we won't be able to eject
  * the tape when we want/need to.
  * This may need to be reviewed in the future.
@@ -4292,7 +4292,7 @@ validate:
 				return RV_NOMORE;
 			}
 		}
-
+
 		/* if this media file is not part of the desired dump session,
 		 * and preceeding media files on this object were, decide if
 		 * we need to rewind and look at the beginning of the object.
@@ -4699,7 +4699,7 @@ newmedia:
 			return RV_DONE;
 		}

-		/* if media not removable, just return
+		/* if media not removable, just return
 		 */
 		if ( ( * dop->do_get_device_class )( drivep )
 		     ==
@@ -5486,7 +5486,7 @@ pi_addfile( Media_t *Mediap,
 					      "incorporating on-media session "
 					      "inventory into online "
 					      "inventory\n") );
-					inv_put_sessioninfo( &sessinfo );
+					inv_put_sessioninfo( &sessinfo );
 				}

 				/* convert into pi format
@@ -5807,7 +5807,7 @@ pi_seeobjstrmend( ix_t strmix, ix_t mediaix )
 	      ix++,
 	      objh = DH2O( objh )->o_nexth )
 		;
-
+
 	/* if an empty object (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
@@ -5816,7 +5816,7 @@ pi_seeobjstrmend( ix_t strmix, ix_t mediaix )
 		return;
 	}

-
+
 	/* set object flag
 	 */
 	DH2O( objh )->o_lmfknwnpr = BOOL_TRUE;
@@ -6177,7 +6177,7 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 	 * object containing the media file has not been IDed.
 	 */
 	knownobjmissingpr = BOOL_FALSE;
-
+
 	tailegrp.eg_ino = 0;
 	tailegrp.eg_off = 0;

@@ -6459,7 +6459,7 @@ pi_hiteod( ix_t strmix, ix_t objix )
 		;
 	assert( objcnt != 0 );
 	lastobjix = objcnt - 1;
-
+
 	pi_unlock( );

 	/* can't possibly happen, but check for case where pi indicates
@@ -6522,7 +6522,7 @@ pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
 		;
 	assert( objcnt != 0 );
 	lastobjix = objcnt - 1;
-
+
 	pi_unlock( );

 	/* can't possibly happen, but check for case where pi indicates
@@ -6581,7 +6581,7 @@ pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
 	      objh = DH2O( objh )->o_nexth )
 		;
 	assert( objh != DH_NULL );
-
+
 	/* if don't know last media file on object, return FALSE
 	 */
 	if ( ! DH2O( objh )->o_lmfknwnpr ) {
@@ -6617,7 +6617,7 @@ pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
 			}
 		}
 	}
-
+
 	pi_unlock( );
 	return BOOL_TRUE;
 }
@@ -6660,7 +6660,7 @@ pi_know_no_more_beyond_on_object( purp_t purp,
 	      objh = DH2O( objh )->o_nexth )
 		;
 	assert( objh != DH_NULL );
-
+
 	/* if don't know last media file on object, return FALSE
 	 */
 	if ( ! DH2O( objh )->o_lmfknwnpr ) {
@@ -6701,7 +6701,7 @@ pi_know_no_more_beyond_on_object( purp_t purp,
 			}
 		}
 	}
-
+
 	pi_unlock( );
 	return BOOL_TRUE;
 }
@@ -7483,7 +7483,7 @@ restore_reg( drive_t *drivep,
 	oflags = O_CREAT | O_RDWR;
 	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
 		oflags |= O_DIRECT;
-
+
 	*fdp = open( path, oflags, S_IRUSR | S_IWUSR );
 	if ( *fdp < 0 ) {
 		mlog( MLOG_NORMAL | MLOG_WARNING,
@@ -7654,7 +7654,7 @@ restore_extent_group( drive_t *drivep,
 	}

 	/* The extent group has been restored.  If the file is not
-	 * complete, we may need to co-ordinate with other restore
+	 * complete, we may need to co-ordinate with other restore
 	 * streams to time the restoration of extended attributes
 	 * and certain extended inode flags. Register the portion
 	 * of the file completed here in the persistent state.
@@ -8027,7 +8027,7 @@ restore_symlink( drive_t *drivep,
 	if ( ! tranp->t_toconlypr && path ) {
 		/* create the symbolic link
 		 */
-		/* NOTE: There is no direct way to set mode for
+		/* NOTE: There is no direct way to set mode for
 		 * sym links. Do it using umask.
 		 * No way of setting times for sym links.
 		 */
@@ -8067,7 +8067,7 @@ restore_symlink( drive_t *drivep,

 		if ( persp->a.restoredmpr) {
 		fsdmidata_t fssetdm;
-
+
 		/*	Restore DMAPI fields. */

 		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
@@ -8580,15 +8580,15 @@ restore_extent( filehdr_t *fhdrp,
 					    (remaining % da.d_miniosz != 0 ||
 					     remaining < da.d_miniosz) ) {
 						/*
-						 * Since the ring and static
-						 * buffers from the different
+						 * Since the ring and static
+						 * buffers from the different
 						 * drives are always large, we
-						 * just need to write to the
-						 * end of the next block
+						 * just need to write to the
+						 * end of the next block
 						 * boundry and truncate.
 						 */
 						rttrunc = remaining;
-						remaining += da.d_miniosz -
+						remaining += da.d_miniosz -
 						   (remaining % da.d_miniosz);
 					}
 					/*
@@ -8784,9 +8784,9 @@ restore_extattr( drive_t *drivep,
 		if ( onlydoreadpr || tranp->t_toconlypr )
 			continue;

-		/* NOTE: In the cases below, if we get errors then we issue warnings
+		/* NOTE: In the cases below, if we get errors then we issue warnings
 		 * but we do not stop the restoration.
-		 * We can still restore the file possibly without the
+		 * We can still restore the file possibly without the
 		 * extended attributes.
 		 */
 		if ( isdirpr ) {
@@ -8817,7 +8817,7 @@ restore_extattr( drive_t *drivep,
 static bool_t
 restore_dir_extattr_cb( char *path, dah_t dah )
 {
-        /*
+        /*
          * directory extattr's are built during the directory phase
          * by 1 thread so we only need one extattr buffer
          * -> we pick the 0th one
@@ -8919,14 +8919,14 @@ dump_partials(void)
 				printf("\tino=%llu ",
 				       (unsigned long long)isptr->is_ino);
 				for (j=0, bsptr=isptr->is_bs;
-				     j < drivecnt;
+				     j < drivecnt;
 				     j++, bsptr++)
 				{
 					if (bsptr->endoffset > 0) {
 						printf("%d:%lld-%lld ",
 						   j, (long long)bsptr->offset,
 						   (long long)bsptr->endoffset);
-					}
+					}
 				}
 				printf( "\n");
 			}
@@ -8965,19 +8965,19 @@ check_valid_partials(void)

 				isptr = &persp->a.parrest[i];
 				for (j=0, bsptr=isptr->is_bs;
-				     j < drivecnt;
+				     j < drivecnt;
 				     j++, bsptr++)
 				{
 					if (bsptr->endoffset > 0) {
 					    num_partials[j]++;
 					    if (num_partials[j] > 2) {
 						pi_unlock();
-						mlog( MLOG_NORMAL | MLOG_WARNING,
+						mlog( MLOG_NORMAL | MLOG_WARNING,
 		  "partial_reg: Too many partials (>2) for drive: %d\n", j);
 						dump_partials();
 						exit(EXIT_ERROR);
 					    }
-					}
+					}
 				}
 			}
 		}
@@ -8991,7 +8991,7 @@ check_valid_partials(void)
  * a dump stream into the persistent state.
  *
  * This is done because DMAPI extended attributes must not be set until
- * the entire file has been restored in order to co-ordinate with the
+ * the entire file has been restored in order to co-ordinate with the
  * Data Migration Facility (DMF) daemons.  Since extended attributes are
  * recorded with each extent group in the dump, this registry is used to
  * make sure only the final dump stream applies the extended attributes.
@@ -9000,10 +9000,10 @@ check_valid_partials(void)
  * should only be set after all data for a file has been restored.
  */
 static void
-partial_reg( ix_t d_index,
-	     xfs_ino_t ino,
-	     off64_t fsize,
-	     off64_t offset,
+partial_reg( ix_t d_index,
+	     xfs_ino_t ino,
+	     off64_t fsize,
+	     off64_t offset,
 	     off64_t sz)
 {
 	off64_t	endoffset;
@@ -9012,7 +9012,7 @@ partial_reg( ix_t d_index,
 	int i;

 	mlog(MLOG_NITTY, "partial_reg: d_index = %d, ino = %llu, "
-                           "fsize = %lld, offset = %lld, sz = %lld\n",
+                           "fsize = %lld, offset = %lld, sz = %lld\n",
                            d_index, ino, fsize, offset, sz);

 	endoffset = offset + sz;
@@ -9023,7 +9023,7 @@ partial_reg( ix_t d_index,
 	pi_lock();

 	/* Search for a matching inode.  Gaps can exist so we must search
-	 * all entries.
+	 * all entries.
 	 */
 	for (i=0; i < partialmax; i++ ) {
 		if (persp->a.parrest[i].is_ino == ino) {
@@ -9126,7 +9126,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 	}

 	/* Search for the inode.  Gaps can exist so we must search
-	 * all entries.
+	 * all entries.
 	 */
 	for (i=0; i < partialmax; i++ ) {
 		if (persp->a.parrest[i].is_ino == ino) {
@@ -9171,9 +9171,9 @@ gapsearch:
 	 * so the search is repeated from the start each time.
 	 */
 	for (i=0, bsptr=isptr->is_bs; i < drivecnt; i++, bsptr++) {
-		if (bsptr->endoffset > 0 &&
-		    bsptr->offset <= curoffset &&
-		    bsptr->endoffset > curoffset)
+		if (bsptr->endoffset > 0 &&
+		    bsptr->offset <= curoffset &&
+		    bsptr->endoffset > curoffset)
 		{
 			curoffset = bsptr->endoffset;
 			goto gapsearch;
@@ -9237,7 +9237,7 @@ content_overwrite_ok( char *path,
 		return BOOL_FALSE;
 	}

-	/* if newer time specified, compare
+	/* if newer time specified, compare
 	 */
 	if ( persp->a.newerpr ) {
 		if ( ( time32_t )ctime < persp->a.newertime ) {
@@ -9661,7 +9661,7 @@ display_needed_objects( purp_t purp,
 	if ( knownholespr ) {
 		if ( purp == PURP_DIR ) {
 			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
-			      bagp ?
+			      bagp ?
 			      _("\nthere are additional unidentified media "
 			      "objects containing media files not yet tried "
 			      "for directory hierarchy restoral:\n")
@@ -9690,7 +9690,7 @@ display_needed_objects( purp_t purp,
 			      _("\nthere may be unidentified media "
 			      "objects containing media files not yet tried "
 			      "for directory hierarchy restoral:\n") );
-
+
 		}
 		if ( purp == PURP_NONDIR ) {
 			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 7a423ab..f057b78 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -105,7 +105,7 @@
 struct dirattr {
 #ifdef DIRATTRCHK
 	uint16_t d_unq;
-	uint16_t d_sum;
+	uint16_t d_sum;
 #endif /* DIRATTRCHK */
 	mode_t d_mode;
 	uid_t d_uid;
@@ -395,7 +395,7 @@ dirattr_add( filehdr_t *fhdrp )
 	uint16_t sum;
 #endif /* DIRATTRCHK */
 	dah_t dah;
-
+
 	/* sanity checks
 	 */
 	assert( dtp );
diff --git a/restore/inomap.c b/restore/inomap.c
index fd55907..5f81897 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -427,7 +427,7 @@ inomap_sync_pers( char *hkdir )
 						 SEGPERHNK * ( hnkcnt - 1 )
 						 -
 						 1 ) ];
-
+
 	/* now all inomap operators will work
 	 */
 	return BOOL_TRUE;
diff --git a/restore/namreg.c b/restore/namreg.c
index 97e6524..8e7ff76 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -261,7 +261,7 @@ namreg_add( char *name, size_t namelen )
 	off64_t oldoff;
 	unsigned char c;
 	nrh_t nrh;
-
+
 	/* sanity checks
 	 */
 	assert( ntp );
@@ -476,7 +476,7 @@ namreg_get( nrh_t nrh,
 	/* null-terminate the string if room
 	 */
 	bufp[ len ] = 0;
-
+
 	unlock( );

 	return ( int )len;
diff --git a/restore/node.c b/restore/node.c
index 92a21ce..b6b6906 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -376,7 +376,7 @@ node_init( int fd,
 		  node_hdrp->nh_firstsegoff,
 		  segsz,
 		  winmapmax );
-
+
 	/* announce the results
 	 */
 	mlog( MLOG_DEBUG | MLOG_TREE,
diff --git a/restore/tree.c b/restore/tree.c
index 0336e77..bc948fc 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -65,7 +65,7 @@

 /* structure definitions used locally ****************************************/

-/* name of persistent state file
+/* name of persistent state file
  */
 #define PERS_NAME	"tree"

@@ -228,7 +228,7 @@ typedef struct node node_t;
 	 * longer exists or it has not changed. if it is referenced, we assume
 	 * it exists, in which case if it is not dumped then all of its entries
 	 * are referenced as well.
-	 */
+	 */
 #define NF_NEWORPH	( 1 << 6 )
 	/* cleared from all nodes in the orphanage before a dump is applied.
 	 * set if a dir is seen in the dirdump but no node exists for it.
@@ -462,7 +462,7 @@ tree_init( char *hkdir,
 	assert( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
 	nodeoff = ( off64_t )PERSSZ + ( off64_t )persp->p_hashsz;
 	assert( vmsz > ( size64_t )nodeoff );
-	ok = node_init( tranp->t_persfd,
+	ok = node_init( tranp->t_persfd,
 		        nodeoff,
 		        NODESZ,
 			 ( ix_t )offsetofmember( node_t, n_nodehkbyte ),
@@ -875,7 +875,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
 			nh_t renameh;
 			node_t *renamep;
 			/* REFERENCED */
-			int namebuflen;
+			int namebuflen;

 			hardp->n_flags |= NF_REFED;
 			if ( hardp->n_parh == persp->p_orphh ) {
@@ -1620,7 +1620,7 @@ mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
 				      "mkdir %s failed: %s\n"),
 				      path,
 				      strerror( errno ));
-
+
 			} else {
 				cldp = Node_map( cldh );
 				cldp->n_flags |= NF_REAL;
@@ -1644,7 +1644,7 @@ mkdirs_recurse( nh_t parh, nh_t cldh, char *path )
 		 */
 		cldh = nextcldh;
 	}
-
+
 	return BOOL_TRUE;
 }

@@ -1845,7 +1845,7 @@ tree_cb_links( xfs_ino_t ino,
 				if ( ! tranp->t_toconlypr && exists ) {
 					rval = unlink( path );
 					if ( rval && errno != ENOENT ) {
-						mlog( MLOG_NORMAL |
+						mlog( MLOG_NORMAL |
 						      MLOG_WARNING, _(
 						      "unable to unlink "
 						      "current file prior to "
@@ -1904,17 +1904,17 @@ tree_cb_links( xfs_ino_t ino,
 			 * with 'orphanage' the file is one of two
 			 * things:
 			 * 1) It's a file that really is an
-			 * orphanage file from a previous restore
+			 * orphanage file from a previous restore
 			 * that has now ended up on this dump tape.
 			 * We don't really want to restore this file
-			 * but, it's harmless to do so, it should
-			 * happen rarely, and the path name is
+			 * but, it's harmless to do so, it should
+			 * happen rarely, and the path name is
 			 * indistinguishable from ...
 			 * 2) A file whose name was never resolved
 			 * from root because of file corruption.
-			 * Some granparent dir (parent dir of it's
-			 * parent dir) was corrupted so the code that
-			 * walks the trees was thus never able to set
+			 * Some granparent dir (parent dir of it's
+			 * parent dir) was corrupted so the code that
+			 * walks the trees was thus never able to set
 			 * the NF_SUBTREE flag.  It then ends up here
 			 * with a non-resolved name but a valid
 			 * hard reference.  We really need to give
@@ -1923,7 +1923,7 @@ tree_cb_links( xfs_ino_t ino,
 			 * make the whole tree of data
 			 * unreachable.  pv698761
 			 */
-			if ( persp->p_ignoreorphpr || (strncmp(ORPH_NAME, path,
+			if ( persp->p_ignoreorphpr || (strncmp(ORPH_NAME, path,
 					    strlen(ORPH_NAME)) != 0)) {
 				mlog( MLOG_DEBUG | MLOG_TREE,
 				      "discarding %llu %u\n",
@@ -1947,12 +1947,12 @@ tree_cb_links( xfs_ino_t ino,
 				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 				      "ino %llu salvaging file,"
 				      " placing in %s\n"), ino, path1);
-				ok = ( * funcp )( contextp, path == path2,
+				ok = ( * funcp )( contextp, path == path2,
 					path1, path2 );
 				if ( ! ok ) {
 					return RV_NOTOK;
 				}
-			}
+			}
 		} else {
 			mlog( MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 			      "ino %llu gen %u not referenced: "
@@ -1967,7 +1967,7 @@ tree_cb_links( xfs_ino_t ino,
 			if (nh == NH_NULL) {
 				mlog( MLOG_ERROR | MLOG_TREE, _(
 				"node allocation failed when placing ino %llu"
-				" in orphanage\n"), ino);
+				" in orphanage\n"), ino);
 				return RV_ERROR; /* allocation failed */
 			}
 			link_in( nh );
@@ -2117,7 +2117,7 @@ tree_extattr_recurse( nh_t parh,
 	} else {
 		ok = BOOL_TRUE;
 	}
-
+
 	return ok;
 }

@@ -2148,7 +2148,7 @@ proc_hardlinks( char *path1, char *path2 )
 /* called for every hard head
  *
  * tes@sgi.com:
- * This code processes the hardlinks, extracting out a
+ * This code processes the hardlinks, extracting out a
  * src_list - real & !ref
  * dest_list - !real & ref
  * The src_list are the entries to delete and the dst_list
@@ -2224,7 +2224,7 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 			Node_free( &nh );
 			continue;
 		}
-
+
 		/* not real, refed, but not selected, can't help
 		 */
 		if ( ! isrealpr &&   isrefpr && ! isselpr ) {
@@ -2356,7 +2356,7 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
 			successpr = BOOL_TRUE;
 		}

-		/* tes@sgi.com: note: loop of one iteration only
+		/* tes@sgi.com: note: loop of one iteration only
 		 */
 		while ( ! successpr && lnsrch != NH_NULL ) {
 			ok = Node2path( lnsrch, phcbp->path1, _("link") );
@@ -2813,7 +2813,7 @@ restart:
 		mlog( MLOG_NORMAL, _("Unmark and quit\n") );
 		selsubtree( persp->p_rooth , BOOL_FALSE );
 	}
-
+
 	return BOOL_TRUE;
 }

@@ -3668,7 +3668,7 @@ disown( nh_t cldh )
 		parp->n_cldh = cldp->n_sibh;
 		if ( cldp->n_sibh != NH_NULL ) {
 			node_t *sibp = Node_map( cldp->n_sibh );
-			sibp->n_sibprevh = NH_NULL;
+			sibp->n_sibprevh = NH_NULL;
 			Node_unmap( cldp->n_sibh, &sibp );
 		}
 	} else {
@@ -3681,13 +3681,13 @@ disown( nh_t cldh )
 		prevcldp = Node_map( prevcldh );

 		/* fix up previous */
-		prevcldp->n_sibh = cldp->n_sibh;
+		prevcldp->n_sibh = cldp->n_sibh;
 		Node_unmap( prevcldh, &prevcldp  );

 		/* fix up next */
 		if ( cldp->n_sibh != NH_NULL ) {
 			node_t *sibp = Node_map( cldp->n_sibh );
-			sibp->n_sibprevh = prevcldh;
+			sibp->n_sibprevh = prevcldh;
 			Node_unmap( cldp->n_sibh, &sibp );
 		}
 	}
@@ -4027,7 +4027,7 @@ link_iter_next( link_iter_context_t *link_iter_contextp )
 	if ( link_iter_contextp->li_donepr == BOOL_TRUE ) {
 		return NH_NULL;
 	}
-
+
 	/* if no hardhead, done
 	 */
 	if ( link_iter_contextp->li_headh == NH_NULL ) {
@@ -4242,7 +4242,7 @@ hash_in( nh_t nh )
 	/* get ino from node
 	 */
 	ino = np->n_ino;
-
+
 	/* assert not already in
 	 */
 	assert( hash_find( np->n_ino, np->n_gen ) == NH_NULL );
@@ -4292,7 +4292,7 @@ hash_out( nh_t nh )
 	 */
 	hashheadh = *entryp;
 	assert( hashheadh != NH_NULL );
-
+
 	/* if node is first in list, replace entry with following node.
 	 * otherwise, walk the list until found.
 	 */
@@ -4339,7 +4339,7 @@ hash_find( xfs_ino_t ino, gen_t gen )
 #ifdef TREE_DEBUG
 	mlog(MLOG_DEBUG | MLOG_TREE,
 	     "hash_find(%llu,%u): traversing hash link list\n",
-		ino, gen);
+		ino, gen);
 #endif

 	/* walk the list until found.
@@ -4842,9 +4842,9 @@ collapse_white( char *string, char *liter )
 	for ( s = string, l = liter ; is_white( *s ) && ! *l ; s++, l++ ) {
 		cnt++;
 	}
-
+
 	string[ 0 ] = ' ';
-
+
 	if ( cnt > 1 ) {
 		shrink( &string[ 1 ], cnt - 1 );
 		shrink( &liter[ 1 ], cnt - 1 );
--
2.19.1

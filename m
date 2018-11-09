Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33333 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbeKJAMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:40 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 46D2758E30
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:49 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/24] xfsdump: (style) remove a space in ptr dereferences
Date: Fri,  9 Nov 2018 15:29:48 +0100
Message-Id: <20181109143004.24963-9-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Created by this script:

#!/usr/bin/env bash
# remove spaces from dereferences

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/(\* /(*/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/cldmgr.c       |  6 ++---
 common/cldmgr.h       |  2 +-
 common/cleanup.c      | 12 ++++-----
 common/dlog.c         |  2 +-
 common/dlog.h         |  4 +--
 common/drive.c        | 14 +++++------
 common/drive.h        | 50 ++++++++++++++++++-------------------
 common/drive_simple.c |  2 +-
 common/global.c       |  2 +-
 common/main.c         | 14 +++++------
 common/media.c        |  8 +++---
 common/ring.h         |  4 +--
 common/util.c         | 14 +++++------
 common/util.h         |  8 +++---
 dump/content.c        | 26 +++++++++----------
 dump/var.c            |  2 +-
 inventory/inv_mgr.c   |  2 +-
 invutil/cmenu.h       | 24 +++++++++---------
 restore/content.c     | 58 +++++++++++++++++++++----------------------
 restore/dirattr.c     |  4 +--
 restore/dirattr.h     |  2 +-
 restore/inomap.c      |  2 +-
 restore/inomap.h      |  2 +-
 restore/tree.c        | 52 +++++++++++++++++++-------------------
 restore/tree.h        |  4 +--
 25 files changed, 160 insertions(+), 160 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index ebe9101..c7f8a45 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -47,7 +47,7 @@ struct cld {
 	int c_exit_code;
 	pthread_t c_tid;
 	ix_t c_streamix;
-	int (* c_entry)(void *arg1);
+	int (*c_entry)(void *arg1);
 	void * c_arg1;
 };
 
@@ -73,7 +73,7 @@ cldmgr_init(void)
 }
 
 bool_t
-cldmgr_create(int (* entry)(void *arg1),
+cldmgr_create(int (*entry)(void *arg1),
 	       ix_t streamix,
 	       char *descstr,
 	       void *arg1)
@@ -234,7 +234,7 @@ cldmgr_entry(void *arg1)
 	      "thread %lu created for stream %d\n",
 	      tid,
 	      cldp->c_streamix);
-	cldp->c_exit_code = (* cldp->c_entry)(cldp->c_arg1);
+	cldp->c_exit_code = (*cldp->c_entry)(cldp->c_arg1);
 
 	pthread_cleanup_pop(1);
 
diff --git a/common/cldmgr.h b/common/cldmgr.h
index ce3a382..3dc74a6 100644
--- a/common/cldmgr.h
+++ b/common/cldmgr.h
@@ -29,7 +29,7 @@ extern bool_t cldmgr_init(void);
 /* cldmgr_create - creates a child thread. returns FALSE if trouble
  * encountered
  */
-extern bool_t cldmgr_create(int (* entry)(void *arg1),
+extern bool_t cldmgr_create(int (*entry)(void *arg1),
 			     ix_t streamix,
 			     char *descstr,
 			     void *arg1);
diff --git a/common/cleanup.c b/common/cleanup.c
index 572355f..8c7fa80 100644
--- a/common/cleanup.c
+++ b/common/cleanup.c
@@ -22,7 +22,7 @@
 #include "cleanup.h"
 
 struct cu {
-	void (* cu_funcp)(void *arg1, void *arg2);
+	void (*cu_funcp)(void *arg1, void *arg2);
 	void *cu_arg1;
 	void *cu_arg2;
 	int  cu_flags;
@@ -45,7 +45,7 @@ cleanup_init(void)
 }
 
 static cleanup_t *
-cleanup_register_base(void (* funcp)(void *arg1, void *arg2),
+cleanup_register_base(void (*funcp)(void *arg1, void *arg2),
 		  void *arg1,
 		  void *arg2)
 {
@@ -64,7 +64,7 @@ cleanup_register_base(void (* funcp)(void *arg1, void *arg2),
 }
 
 cleanup_t *
-cleanup_register(void (* funcp)(void *arg1, void *arg2),
+cleanup_register(void (*funcp)(void *arg1, void *arg2),
 		  void *arg1,
 		  void *arg2)
 {
@@ -76,7 +76,7 @@ cleanup_register(void (* funcp)(void *arg1, void *arg2),
 }
 
 cleanup_t *
-cleanup_register_early(void (* funcp)(void *arg1, void *arg2),
+cleanup_register_early(void (*funcp)(void *arg1, void *arg2),
 		  void *arg1,
 		  void *arg2)
 {
@@ -118,7 +118,7 @@ cleanup(void)
 {
 	while (cu_rootp) {
 		cu_t *p = cu_rootp;
-		(* p->cu_funcp)(p->cu_arg1, p->cu_arg2);
+		(*p->cu_funcp)(p->cu_arg1, p->cu_arg2);
 		cu_rootp = p->cu_nextp;
 		free((void *)p);
 	}
@@ -136,7 +136,7 @@ cleanup_early(void)
 		cu_t *cunextp = cuptr->cu_nextp;
 
 		if (cuptr->cu_flags & CU_EARLY) {
-			(* cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
+			(*cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
 			free((void *)cuptr);
 			if (cuprevp)  {
 				cuprevp->cu_nextp = cunextp;
diff --git a/common/dlog.c b/common/dlog.c
index f62f374..d5b0443 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -303,7 +303,7 @@ dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
 	/* call the caller's callback with his context, print context, and
 	 * print operator
 	 */
-	(* ucb)(uctxp, dlog_string_query_print, 0);
+	(*ucb)(uctxp, dlog_string_query_print, 0);
 
 	/* if called for, print the timeout and a newline.
 	 * if not, print just a newline
diff --git a/common/dlog.h b/common/dlog.h
index 7f0e41d..4c76f31 100644
--- a/common/dlog.h
+++ b/common/dlog.h
@@ -78,8 +78,8 @@ extern void dlog_multi_ack(char *ackstr[], size_t ackcnt);
  * received, sigquitix if SIGQUIT received. if any of the exception indices
  * are set to IXMAX by the caller, those events will be ignored.
  */
-typedef void (* dlog_pcbp_t)(void *pctxp, char *s, ...);
-typedef void (* dlog_ucbp_t)(void *uctxp, dlog_pcbp_t pcb, void *pctxp);
+typedef void (*dlog_pcbp_t)(void *pctxp, char *s, ...);
+typedef void (*dlog_ucbp_t)(void *uctxp, dlog_pcbp_t pcb, void *pctxp);
 extern ix_t dlog_string_query(dlog_ucbp_t ucb, /* user's print func */
 			       void *uctxp,	/* user's context for above */
 			       char *bufp,	/* typed string returned in */
diff --git a/common/drive.c b/common/drive.c
index 17aae6c..02a0f1f 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -210,7 +210,7 @@ drive_init1(int argc, char *argv[])
 		for (six = 0; six < scnt; six++) {
 			drive_strategy_t *sp = strategypp[six];
 			int score;
-			score = (* sp->ds_match)(argc,
+			score = (*sp->ds_match)(argc,
 						    argv,
 						    drivep);
 			if (! bestsp || score > bestscore) {
@@ -225,7 +225,7 @@ drive_init1(int argc, char *argv[])
 		mlog(MLOG_VERBOSE,
 		      _("using %s strategy\n"),
 		      bestsp->ds_description);
-		ok = (* bestsp->ds_instantiate)(argc,
+		ok = (*bestsp->ds_instantiate)(argc,
 						   argv,
 						   drivep);
 		if (! ok) {
@@ -255,7 +255,7 @@ drive_init2(int argc,
 		bool_t ok;
 
 		drive_allochdrs(drivep, gwhdrtemplatep, driveix);
-		ok = (* drivep->d_opsp->do_init)(drivep);
+		ok = (*drivep->d_opsp->do_init)(drivep);
 		if (! ok) {
 			return BOOL_FALSE;
 		}
@@ -277,7 +277,7 @@ drive_init3(void)
 		drive_t *drivep = drivepp[driveix];
 		bool_t ok;
 
-		ok = (* drivep->d_opsp->do_sync)(drivep);
+		ok = (*drivep->d_opsp->do_sync)(drivep);
 		if (! ok) {
 			return BOOL_FALSE;
 		}
@@ -303,7 +303,7 @@ drive_mark_commit(drive_t *drivep, off64_t ncommitted)
 	;
 	) {
 		drivep->d_markrecheadp = dmp->dm_nextp;
-		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_TRUE);
+		(*dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_TRUE);
 		dmp = drivep->d_markrecheadp;
 	}
 }
@@ -323,7 +323,7 @@ drive_mark_discard(drive_t *drivep)
 	;
 	drivep->d_markrecheadp = dmp->dm_nextp, dmp = dmp->dm_nextp) {
 
-		(* dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
+		(*dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
 	}
 }
 
@@ -339,7 +339,7 @@ drive_display_metrics(void)
 		drive_t *drivep = drivepp[driveix];
 		drive_ops_t *dop = drivep->d_opsp;
 		if (dop->do_display_metrics) {
-			(* dop->do_display_metrics)(drivep);
+			(*dop->do_display_metrics)(drivep);
 		}
 	}
 }
diff --git a/common/drive.h b/common/drive.h
index 4b4fcf8..adecaab 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -138,13 +138,13 @@ struct drive_strategy {
 	char *ds_description;
 		    /* a short char string describing strategy
 		     */
-	int (* ds_match)(int argc,
+	int (*ds_match)(int argc,
 				 char *argv[],
 				 struct drive *drivep);
 		    /* returns degree of match. drivep has been pre-allocated
 		     * and initialized with generic info.
 		     */
-	bool_t (* ds_instantiate)(int argc,
+	bool_t (*ds_instantiate)(int argc,
 				     char *argv[],
 				     struct drive *drivep);
 		    /* creates a drive manager instance, by filling in the
@@ -186,7 +186,7 @@ typedef off64_t drive_mark_t;
  * was NOT committed.
  */
 struct drive_markrec; /* forward decl */
-typedef void (* drive_mcbfp_t)(void *context_t,
+typedef void (*drive_mcbfp_t)(void *context_t,
 				  struct drive_markrec *markrecp,
 				  bool_t committed);
 
@@ -257,17 +257,17 @@ struct drive {
 typedef struct drive drive_t;
 
 struct drive_ops {
-	bool_t (* do_init)(drive_t *drivep);
+	bool_t (*do_init)(drive_t *drivep);
 				/* initializes drive, and begins async
 				 * determination of media object presence
 				 * returns FALSE if session should be aborted.
 				 */
-	bool_t (* do_sync)(drive_t *drivep);
+	bool_t (*do_sync)(drive_t *drivep);
 				/* synchronizes with the activity kicked off
 				 * by do_init. returns FALSE if session should
 				 * be aborted.
 				 */
-	int (* do_begin_read)(drive_t *drivep);
+	int (*do_begin_read)(drive_t *drivep);
 				/* prepares the drive manager for reading.
 				 * if the media is positioned at BOM or just
 				 * after a file mark, current media file is
@@ -306,7 +306,7 @@ struct drive_ops {
 				 * begin_read. if successful, caller MUST call
 				 * end_read prior to next begin_read.
 				 */
-	char * (* do_read)(drive_t *drivep,
+	char * (*do_read)(drive_t *drivep,
 			      size_t wanted_bufsz,
 			      size_t *actual_bufszp,
 			      int *statp);
@@ -341,7 +341,7 @@ struct drive_ops {
 				 * valid data (although the buffer size may
 				 * be zero!).
 				 */
-	void (* do_return_read_buf)(drive_t *drivep,
+	void (*do_return_read_buf)(drive_t *drivep,
 				       char *bufp,
 				       size_t bufsz);
 				/* returns the buffer obtained
@@ -349,14 +349,14 @@ struct drive_ops {
 				 * the entire buffer must be returned
 				 * in one shot.
 				 */
-	void (* do_get_mark)(drive_t *drivep,
+	void (*do_get_mark)(drive_t *drivep,
 				drive_mark_t *drivemarkp);
 				/* returns (by reference) a mark corresponding
 				 * to the next byte which will be read by a
 				 * call to do_read(). will be used in a later
 				 * session to seek to that position.
 				 */
-	int (* do_seek_mark)(drive_t *drivep,
+	int (*do_seek_mark)(drive_t *drivep,
 				     drive_mark_t *drivemarkp);
 				/* searches for the specified mark within the
 				 * current file. returns zero if the mark
@@ -367,7 +367,7 @@ struct drive_ops {
 				 *	CORRUPTION - encountered corrupt data;
 				 *	DEVICE - device error;
 				 */
-	int (* do_next_mark)(drive_t *drivep);
+	int (*do_next_mark)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_NEXTMARK set,
 				 * drive has the capability to
 				 * seek forward to the next mark. returns
@@ -385,7 +385,7 @@ struct drive_ops {
 				 * will position the media at the next media
 				 * file.
 				 */
-	int (* do_begin_write)(drive_t *drivep);
+	int (*do_begin_write)(drive_t *drivep);
 				/* begins a write media file for writing.
 				 * asserts the media is positioned at BOM or
 				 * just after a file mark. write header will
@@ -396,7 +396,7 @@ struct drive_ops {
 				 *	DEVICE - device error;
 				 *	CORE  - driver error
 				 */
-	void (* do_set_mark)(drive_t *drivep,
+	void (*do_set_mark)(drive_t *drivep,
 				drive_mcbfp_t cbfuncp,
 				void *cbcontextp,
 				drive_markrec_t *markrecp);
@@ -426,7 +426,7 @@ struct drive_ops {
 				 * last committed marked point in the write
 				 * stream.
 				 */
-	char * (* do_get_write_buf)(drive_t *drivep,
+	char * (*do_get_write_buf)(drive_t *drivep,
 				       size_t wanted_bufsz,
 				       size_t *actual_bufszp);
 				/* asks the drive manager for a buffer.
@@ -443,7 +443,7 @@ struct drive_ops {
 				 * be larger or smaller than the wanted bufsz,
 				 * but will be at least 1 byte in length.
 				 */
-	int (* do_write)(drive_t *drivep,
+	int (*do_write)(drive_t *drivep,
 				 char *bufp,
 				 size_t bufsz);
 				/* asks the drive manager to write bufsz
@@ -473,7 +473,7 @@ struct drive_ops {
 				 * instead, the caller must get another buffer
 				 * using do_get_write_buf().
 				 */
-	size_t (* do_get_align_cnt)(drive_t *drivep);
+	size_t (*do_get_align_cnt)(drive_t *drivep);
 				/* used during writing. returns the number
 				 * of bytes which should be written to
 				 * page-align the next do_get_write_buf()
@@ -481,7 +481,7 @@ struct drive_ops {
 				 * alignment will be maintained after the
 				 * initial alignment done using this info.
 				 */
-	int (* do_end_write)(drive_t *drivep, off64_t *ncommittedp);
+	int (*do_end_write)(drive_t *drivep, off64_t *ncommittedp);
 				/* terminates a media file write sequence.
 				 * flushes any buffered data not yet committed
 				 * to media, and calls callbacks for all marks
@@ -502,7 +502,7 @@ struct drive_ops {
 				 * an error, do_end_write will not do any
 				 * I/O, and will return 0.
 				 */
-	int (* do_fsf)(drive_t *drivep,
+	int (*do_fsf)(drive_t *drivep,
 			      int count,
 			      int *statp);
 				/* if d_capabilities has DRIVE_CAP_FSF set,
@@ -528,7 +528,7 @@ struct drive_ops {
 				 * behaves as if position is at most recent
 				 * file mark or BOT.
 				 */
-	int (* do_bsf)(drive_t *drivep,
+	int (*do_bsf)(drive_t *drivep,
 			       int count,
 			       int *statp);
 				/* if d_capabilities has DRIVE_CAP_BSF set,
@@ -554,35 +554,35 @@ struct drive_ops {
 				 *	BOM - hit beginning of recorded data;
 				 *	DEVICE - device error;
 				 */
-	int (* do_rewind)(drive_t *drivep);
+	int (*do_rewind)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_REWIND set,
 				 * drive has the capability to
 				 * position at beginning of recorded data
 				 *	DEVICE - device error;
 				 */
-	int (* do_erase)(drive_t *drivep);
+	int (*do_erase)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_ERASE set,
 				 * drive has the capability to
 				 * erase: all content of media object is
 				 * eradicated.
 				 *	DEVICE - device error;
 				 */
-	int (* do_eject_media)(drive_t *drivep);
+	int (*do_eject_media)(drive_t *drivep);
 				/* if d_capabilities has DRIVE_CAP_EJECT set,
 				 * drive has capability
 				 * to eject media, and will do so when called.
 				 *	DEVICE - device error;
 				 */
-	int (* do_get_device_class)(drive_t *drivep);
+	int (*do_get_device_class)(drive_t *drivep);
 				/* returns the media class of the device
 				 * (see below).
 				 */
-	void (* do_display_metrics)(drive_t *drivep);
+	void (*do_display_metrics)(drive_t *drivep);
 				/* use BARE mlog to print useful throughput
 				 * and performance info. set to NULL if
 				 * nothing to say.
 				 */
-	void (* do_quit)(drive_t * drivep);
+	void (*do_quit)(drive_t * drivep);
 				/* tells the drive manager to de-allocate
 				 * resources, INCLUDING the slave process.
 				 */
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 697a597..f71a2cf 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -1155,7 +1155,7 @@ do_set_mark(drive_t *drivep,
 	 */
 	if (contextp->dc_nextp == contextp->dc_buf) {
 		assert(drivep->d_markrecheadp == 0);
-		(* cbfuncp)(cbcontextp, markrecp, BOOL_TRUE);
+		(*cbfuncp)(cbcontextp, markrecp, BOOL_TRUE);
 		return;
 	} else {
 		markrecp->dm_cbfuncp = cbfuncp;
diff --git a/common/global.c b/common/global.c
index 42bfc3d..5ba237f 100644
--- a/common/global.c
+++ b/common/global.c
@@ -308,7 +308,7 @@ prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
 	/* query: ask for a dump label
 	 */
-	(* pcb)(pctxp,
+	(*pcb)(pctxp,
 		   _("please enter label for this dump session"));
 }
 
diff --git a/common/main.c b/common/main.c
index 3f3ce0c..7d40b48 100644
--- a/common/main.c
+++ b/common/main.c
@@ -1222,7 +1222,7 @@ loadoptfile(int *argcp, char ***argvp)
 			i++; /* to skip option argument */
 			continue;
 		}
-		sz += strlen((* argvp)[i]) + 1;
+		sz += strlen((*argvp)[i]) + 1;
 	}
 
 	/* add in the size of the option file (plus one byte in case
@@ -1239,8 +1239,8 @@ loadoptfile(int *argcp, char ***argvp)
 	 */
 	p = argbuf;
 	i = 0;
-	sprintf(p, "%s ", (* argvp)[i]);
-	p += strlen((* argvp)[i]) + 1;
+	sprintf(p, "%s ", (*argvp)[i]);
+	p += strlen((*argvp)[i]) + 1;
 	i++;
 
 	/* copy the options file into the buffer after the given args
@@ -1266,8 +1266,8 @@ loadoptfile(int *argcp, char ***argvp)
 			i++; /* to skip option argument */
 			continue;
 		}
-		sprintf(p, "%s ", (* argvp)[i]);
-		p += strlen((* argvp)[i]) + 1;
+		sprintf(p, "%s ", (*argvp)[i]);
+		p += strlen((*argvp)[i]) + 1;
 	}
 
 	/* null-terminate the entire buffer
@@ -1468,7 +1468,7 @@ childmain(void *arg1)
 	/* let the drive manager shut down its slave thread
 	 */
 	drivep = drivepp[stix];
-	(* drivep->d_opsp->do_quit)(drivep);
+	(*drivep->d_opsp->do_quit)(drivep);
 
 	return exitcode;
 }
@@ -1480,7 +1480,7 @@ prompt_prog_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
 	/* query: ask for a dump label
 	 */
-	(* pcb)(pctxp,
+	(*pcb)(pctxp,
 		   progrpt_enabledpr
 		   ?
 		   _("please enter seconds between progress reports, "
diff --git a/common/media.c b/common/media.c
index 2337a84..bc1fbbd 100644
--- a/common/media.c
+++ b/common/media.c
@@ -169,7 +169,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 				mediap->m_strategyp = *spp;
 				mediap->m_writehdrp->mh_strategyid = id;
 			}
-			if ((* (*spp)->ms_match)(argc, argv, dsp)) {
+			if ((*(*spp)->ms_match)(argc, argv, dsp)) {
 				chosen_sp = *spp;
 			}
 		}
@@ -200,7 +200,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 	/* initialize the strategy. this will cause each of the managers
 	 * to be initialized as well. if error, return 0.
 	 */
-	ok = (* chosen_sp->ms_create)(chosen_sp, argc, argv);
+	ok = (*chosen_sp->ms_create)(chosen_sp, argc, argv);
 	if (! ok) {
 		return 0;
 	}
@@ -215,7 +215,7 @@ media_init(media_strategy_t *msp, int argc, char *argv[])
 {
 	bool_t ok;
 
-	ok = (* msp->ms_init)(msp, argc, argv);
+	ok = (*msp->ms_init)(msp, argc, argv);
 
 	return ok;
 }
@@ -223,7 +223,7 @@ media_init(media_strategy_t *msp, int argc, char *argv[])
 void
 media_complete(media_strategy_t *msp)
 {
-	(* msp->ms_complete)(msp);
+	(*msp->ms_complete)(msp);
 }
 
 /* media_get_upper_hdrs - supply pointers to portion of media file headers
diff --git a/common/ring.h b/common/ring.h
index be4ae69..6535af8 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -168,8 +168,8 @@ extern ring_t *ring_create(size_t ringlen,
 			    size_t bufsz,
 			    bool_t pinpr,
 			    ix_t drive_index,
-			    int (* readfunc)(void *clientctxp, char *bufp),
-			    int (* writefunc)(void *clientctxp, char *bufp),
+			    int (*readfunc)(void *clientctxp, char *bufp),
+			    int (*writefunc)(void *clientctxp, char *bufp),
 			    void *clientctxp,
 			    int *rvalp);
 
diff --git a/common/util.c b/common/util.c
index 621d340..7ca5fbe 100644
--- a/common/util.c
+++ b/common/util.c
@@ -58,7 +58,7 @@ write_buf(char *bufp,
 		} else {
 			(void)memset((void *)mbufp, 0, mbufsz);
 		}
-		rval = (* write_funcp)(contextp, mbufp, mbufsz);
+		rval = (*write_funcp)(contextp, mbufp, mbufsz);
 		if (rval) {
 			return rval;
 		}
@@ -86,7 +86,7 @@ read_buf(char *bufp,
 	nread = 0;
 	*statp = 0;
 	while (bufsz) {
-		mbufp = (* read_funcp)(contextp, bufsz, &mbufsz, statp);
+		mbufp = (*read_funcp)(contextp, bufsz, &mbufsz, statp);
 		if (*statp) {
 			break;
 		}
@@ -97,7 +97,7 @@ read_buf(char *bufp,
 		}
 		bufsz -= mbufsz;
 		nread += (int)mbufsz;
-		(* return_read_buf_funcp)(contextp, mbufp, mbufsz);
+		(*return_read_buf_funcp)(contextp, mbufp, mbufsz);
 	}
 
 	return nread;
@@ -210,7 +210,7 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 					continue;
 				}
 			}
-			rval = (* fp)(cb_arg1, fshandlep, fsfd, p);
+			rval = (*fp)(cb_arg1, fshandlep, fsfd, p);
 			if (rval) {
 				*statp = rval;
 				return 0;
@@ -272,7 +272,7 @@ bigstat_one(int fsfd,
 #define INOGRPLEN	256
 int
 inogrp_iter(int fsfd,
-	     int (* fp)(void *arg1,
+	     int (*fp)(void *arg1,
 				int fsfd,
 				xfs_inogrp_t *inogrp),
 	     void * arg1,
@@ -311,7 +311,7 @@ inogrp_iter(int fsfd,
 		for (p = igrp, endp = igrp + inogrpcnt; p < endp; p++) {
 			int rval;
 
-			rval = (* fp)(arg1, fsfd, p);
+			rval = (*fp)(arg1, fsfd, p);
 			if (rval) {
 				*statp = rval;
 				free(igrp);
@@ -476,7 +476,7 @@ diriter(jdm_fshandle_t *fshandlep,
 
 			/* invoke the callback
 			 */
-			cbrval = (* cbfp)(arg1,
+			cbrval = (*cbfp)(arg1,
 					     fshandlep,
 					     fsfd,
 					     &statbuf,
diff --git a/common/util.h b/common/util.h
index ab43739..cba4ca8 100644
--- a/common/util.h
+++ b/common/util.h
@@ -32,8 +32,8 @@
  *
  * if bufp is null, writes bufsz zeros.
  */
-typedef char * (* gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
-typedef int (* wfp_t)(void *contextp, char *bufp, size_t bufsz);
+typedef char * (*gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
+typedef int (*wfp_t)(void *contextp, char *bufp, size_t bufsz);
 
 extern int write_buf(char *bufp,
 			   size_t bufsz,
@@ -57,7 +57,7 @@ extern int write_buf(char *bufp,
  * *statp will be zero.
  */
 typedef char * (*rfp_t)(void *contextp, size_t wantedsz, size_t *szp, int *statp);
-typedef void (* rrbfp_t)(void *contextp, char *bufp, size_t bufsz);
+typedef void (*rrbfp_t)(void *contextp, char *bufp, size_t bufsz);
 
 extern int read_buf(char *bufp,
 			  size_t bufsz,
@@ -110,7 +110,7 @@ extern int bigstat_one(int fsfd,
 			     xfs_bstat_t *statp);
 
 extern int inogrp_iter(int fsfd,
-			     int (* fp)(void *arg1,
+			     int (*fp)(void *arg1,
 				     		int fsfd,
 						xfs_inogrp_t *inogrp),
 			     void * arg1,
diff --git a/dump/content.c b/dump/content.c
index 7627b8a..5743cf7 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -2014,7 +2014,7 @@ mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
 	markp->startpt.sp_ino = ino;
 	markp->startpt.sp_offset = offset;
 	markp->startpt.sp_flags = flags;
-	(* dop->do_set_mark)(drivep,
+	(*dop->do_set_mark)(drivep,
 				mark_callback,
 				(void *)drivep->d_index,
 				(drive_markrec_t *)markp);
@@ -4734,7 +4734,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (isrealtime || extsz >= PGALIGNTHRESH * PGSZ) {
 			size_t cnt_to_align;
-			cnt_to_align = (* dop->do_get_align_cnt)(drivep);
+			cnt_to_align = (*dop->do_get_align_cnt)(drivep);
 			if ((size_t)cnt_to_align < 2*sizeof(extenthdr_t)) {
 				cnt_to_align += PGSZ;
 			}
@@ -4807,7 +4807,7 @@ dump_extent_group(drive_t *drivep,
 				INTGENMAX
 				:
 				(size_t)extsz;
-			bufp = (* dop->do_get_write_buf)(drivep,
+			bufp = (*dop->do_get_write_buf)(drivep,
 							    reqsz,
 							    &actualsz);
 			assert(actualsz <= reqsz);
@@ -4853,7 +4853,7 @@ dump_extent_group(drive_t *drivep,
 					actualsz - (size_t)nread);
 			}
 
-			rval = (* dop->do_write)(drivep,
+			rval = (*dop->do_write)(drivep,
 						    bufp,
 						    actualsz);
 			switch (rval) {
@@ -5635,7 +5635,7 @@ position:
 
 		/* do a begin_read to see the disposition of the drive/media.
 		 */
-		rval = (* dop->do_begin_read)(drivep);
+		rval = (*dop->do_begin_read)(drivep);
 
 		/* update cc_Media_useterminatorpr after every begin_read,
 		 * since begin_read will cause some unknown drive params
@@ -5679,7 +5679,7 @@ position:
 			 * media object a virgin.
 			 * also, check for erase option.
 			 */
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 
 			switch(Media_erasechk(drivep,
 						dcaps,
@@ -5712,7 +5712,7 @@ position:
 				assert(contextp->cc_Media_useterminatorpr);
 				assert(dcaps & DRIVE_CAP_BSF); /* redundant */
 				status = 0;
-				rval = (* dop->do_bsf)(drivep, 0, &status);
+				rval = (*dop->do_bsf)(drivep, 0, &status);
 				assert(rval == 0);
 				if (status == DRIVE_ERROR_DEVICE) {
 					mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
@@ -5768,7 +5768,7 @@ position:
 				      "repositioning to overwrite\n"));
 				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
-				rval = (* dop->do_bsf)(drivep, 0, &status);
+				rval = (*dop->do_bsf)(drivep, 0, &status);
 				assert(rval == 0);
 				if (status == DRIVE_ERROR_DEVICE) {
 					return RV_DRIVE;
@@ -5904,7 +5904,7 @@ position:
 				mlog_exit_hint(RV_CORRUPT);
 				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
-				rval = (* dop->do_bsf)(drivep, 0, &status);
+				rval = (*dop->do_bsf)(drivep, 0, &status);
 				assert(rval == 0);
 				if (status == DRIVE_ERROR_DEVICE) {
 					return RV_DRIVE;
@@ -5928,7 +5928,7 @@ position:
 erasemedia:
 	mlog(MLOG_VERBOSE | MLOG_WARNING | MLOG_MEDIA, _(
 	      "erasing media\n"));
-	rval = (* dop->do_erase)(drivep);
+	rval = (*dop->do_erase)(drivep);
 	if (rval) {
 		return RV_DRIVE;
 	}
@@ -5950,7 +5950,7 @@ changemedia:
 	assert(mediapresentpr != BOOL_UNKNOWN);
 	if (mediapresentpr == BOOL_TRUE) {
 		if (dcaps & DRIVE_CAP_EJECT) {
-			rval = (* dop->do_eject_media)(drivep);
+			rval = (*dop->do_eject_media)(drivep);
 			if (rval) {
 				return RV_DRIVE;
 			}
@@ -6129,7 +6129,7 @@ write:
 	if (intr_allowed && cldmgr_stop_requested()) {
 		return RV_INTR;
 	}
-	rval = (* dop->do_begin_write)(drivep);
+	rval = (*dop->do_begin_write)(drivep);
 	switch(rval) {
 	case 0:
 		return RV_OK;
@@ -6444,7 +6444,7 @@ Media_prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 
 	/* query: ask for a label
 	 */
-	(* pcb)(pctxp,
+	(*pcb)(pctxp,
 		   "please enter label for media in "
 		   "drive %u",
 		   drivep->d_index);
diff --git a/dump/var.c b/dump/var.c
index c9f251a..8ea38af 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -132,7 +132,7 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 	      "excluding %s from dump\n",
 	      base);
 
-	(* cb)(statbuf.st_ino);
+	(*cb)(statbuf.st_ino);
 
 	if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
 		return;
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 078798f..7e73667 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -310,7 +310,7 @@ search_invt(
 					continue;
 			}
 
-			found = (* do_chkcriteria)(fd, &harr[j], arg, buf);
+			found = (*do_chkcriteria)(fd, &harr[j], arg, buf);
 			if (! found) continue;
 
 			/* we found what we need; just return */
diff --git a/invutil/cmenu.h b/invutil/cmenu.h
index f3c205f..075bcf3 100644
--- a/invutil/cmenu.h
+++ b/invutil/cmenu.h
@@ -44,18 +44,18 @@ typedef enum {
 } alignment_t;
 
 typedef struct menu_ops_s {
-    int (* op_delete) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_undelete) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_saveexit) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_select) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_collapse) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_expand) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_collapseall) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_expandall) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_highlight) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_unhighlight) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_commit) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_prune) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
+    int (*op_delete) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_undelete) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_saveexit) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_select) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_collapse) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_expand) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_collapseall) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_expandall) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_highlight) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_unhighlight) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_commit) (WINDOW *win, node_t *current, node_t *list);
+    int (*op_prune) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
 } menu_ops_t;
 
 typedef struct {
diff --git a/restore/content.c b/restore/content.c
index 8da57ed..47a9c21 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -3502,7 +3502,7 @@ applynondirdump(drive_t *drivep,
 			rv = RV_OK;
 			goto applynondirdump_out;
 		case RV_CORRUPT:
-			rval = (* dop->do_next_mark)(drivep);
+			rval = (*dop->do_next_mark)(drivep);
 			if (rval) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "unable to resync media file: "
@@ -3545,7 +3545,7 @@ applynondirdump(drive_t *drivep,
 		do {
 			/* get a mark for the next read, in case we restart here
 			 */
-			(* dop->do_get_mark)(drivep, &drivemark);
+			(*dop->do_get_mark)(drivep, &drivemark);
 
 			/* read the file header.
 			 */
@@ -3557,7 +3557,7 @@ applynondirdump(drive_t *drivep,
 				rv = RV_OK;
 				goto applynondirdump_out;
 			case RV_CORRUPT:
-				rval = (* dop->do_next_mark)(drivep);
+				rval = (*dop->do_next_mark)(drivep);
 				if (rval) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to resync media file: "
@@ -3926,7 +3926,7 @@ Media_mfile_next(Media_t *Mediap,
 		     Mediap->M_pos == POS_INDIR
 		     ||
 		     Mediap->M_pos == POS_ATNONDIR) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 		}
@@ -4031,7 +4031,7 @@ Media_mfile_next(Media_t *Mediap,
 			}
 			mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 			      "rewinding\n"));
-			(* drivep->d_opsp->do_rewind)(drivep);
+			(*drivep->d_opsp->do_rewind)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			if (cldmgr_stop_requested()) {
 				return RV_INTR;
@@ -4050,7 +4050,7 @@ Media_mfile_next(Media_t *Mediap,
 		 * bail if catastrophic. also, tell pi about EOD/EOM
 		 * if appropriate.
 		 */
-		rval = (* drivep->d_opsp->do_begin_read)(drivep);
+		rval = (*drivep->d_opsp->do_begin_read)(drivep);
 		switch (rval) {
 		case 0:
 			mlog_lock();
@@ -4154,7 +4154,7 @@ validate:
 			     Mediap->M_pos == POS_INDIR
 			     ||
 			     Mediap->M_pos == POS_ATNONDIR) {
-				(* dop->do_end_read)(drivep);
+				(*dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 			}
@@ -4286,7 +4286,7 @@ validate:
 		      &&
 		      Mediap->M_lmfix > Mediap->M_fsfix) {
 			if (pi_alldone()) {
-				(* dop->do_end_read)(drivep);
+				(*dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				return RV_NOMORE;
@@ -4302,13 +4302,13 @@ validate:
 		     Mediap->M_fsfixvalpr
 		     &&
 		     Mediap->M_fmfix <= Mediap->M_fsfix) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			if (dcaps & DRIVE_CAP_REWIND) {
 				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "rewinding\n"));
-				(* drivep->d_opsp->do_rewind)(drivep);
+				(*drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			} else {
 				goto newmedia;
@@ -4319,7 +4319,7 @@ validate:
 		 * and the above conditions were not met, then keep looking
 		 */
 		if (! partofdumppr) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			continue;
@@ -4363,7 +4363,7 @@ validate:
 		/* if purp is nondir, we may be done.
 		 */
 		if (purp == PURP_NONDIR && pi_alldone()) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			return RV_NOMORE;
 		}
@@ -4376,7 +4376,7 @@ validate:
 			     Mediap->M_fmfix <= Mediap->M_fsfix
 			     &&
 			     Mediap->M_lmfix < Mediap->M_fmfix) {
-				(* dop->do_end_read)(drivep);
+				(*dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				goto newmedia;
@@ -4386,7 +4386,7 @@ validate:
 			     Mediap->M_pmfix < Mediap->M_fmfix
 			     &&
 			     Mediap->M_lmfix > Mediap->M_fmfix) {
-				(* dop->do_end_read)(drivep);
+				(*dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				goto newmedia;
@@ -4404,7 +4404,7 @@ validate:
 		     scrhdrp->cih_mediafiletype
 		     ==
 		     CIH_MEDIAFILETYPE_INVENTORY) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			if (pi_know_no_more_on_object(purp,
@@ -4418,7 +4418,7 @@ validate:
 				pi_note_underhead(objh, DH_NULL);
 				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 					"rewinding\n"));
-				(* drivep->d_opsp->do_rewind)(drivep);
+				(*drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			}
 			goto newmedia;
@@ -4433,7 +4433,7 @@ validate:
 		     (Mediap->M_pos != POS_ATHDR
 		       ||
 		       DH2F(fileh)->f_dirtriedpr)) {
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			if (pi_know_no_more_beyond_on_object(purp,
@@ -4451,7 +4451,7 @@ validate:
 					pi_note_underhead(objh, DH_NULL);
 					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 						"rewinding\n"));
-					(* drivep->d_opsp->do_rewind)(drivep);
+					(*drivep->d_opsp->do_rewind)(drivep);
 					continue;
 				}
 				goto newmedia;
@@ -4498,7 +4498,7 @@ validate:
 				DH2F(fileh)->f_nondirdonepr = BOOL_TRUE;
 			}
 			pi_unlock();
-			(* dop->do_end_read)(drivep);
+			(*dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			if (pi_know_no_more_beyond_on_object(purp,
@@ -4516,7 +4516,7 @@ validate:
 					pi_note_underhead(objh, DH_NULL);
 					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 						"rewinding\n"));
-					(* drivep->d_opsp->do_rewind)(drivep);
+					(*drivep->d_opsp->do_rewind)(drivep);
 					continue;
 				}
 				goto newmedia;
@@ -4564,7 +4564,7 @@ validate:
 			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "seeking past portion of media file "
 				  "already restored\n"));
-			    rval = (* dop->do_seek_mark)(drivep,
+			    rval = (*dop->do_seek_mark)(drivep,
 							    &chkpnt);
 			    if (! rval) {
 				    rv_t rv;
@@ -4583,7 +4583,7 @@ validate:
 			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "seeking past media file "
 				  "directory dump\n"));
-			    rval = (* dop->do_next_mark)(drivep);
+			    rval = (*dop->do_next_mark)(drivep);
 			    if (! rval) {
 				    rv_t rv;
 				    rv = read_filehdr(drivep,
@@ -4650,7 +4650,7 @@ validate:
 		 * media files on this object? if so, continue; if not, get
 		 * more media.
 		 */
-		(* dop->do_end_read)(drivep);
+		(*dop->do_end_read)(drivep);
 		Mediap->M_pos = POS_UNKN;
 		fileh = DH_NULL;
 		assert(purp == PURP_NONDIR);
@@ -4669,7 +4669,7 @@ validate:
 				pi_note_underhead(objh, DH_NULL);
 				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 					"rewinding\n"));
-				(* drivep->d_opsp->do_rewind)(drivep);
+				(*drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			}
 			goto newmedia;
@@ -4701,7 +4701,7 @@ newmedia:
 
 		/* if media not removable, just return
 		 */
-		if ((* dop->do_get_device_class)(drivep)
+		if ((*dop->do_get_device_class)(drivep)
 		     ==
 		     DEVICE_NONREMOVABLE)
 		{
@@ -4770,7 +4770,7 @@ newmedia:
 				}
 			}
 			if (dcaps & DRIVE_CAP_EJECT) {
-				(* dop->do_eject_media)(drivep);
+				(*dop->do_eject_media)(drivep);
 			}
 		}
 
@@ -4863,7 +4863,7 @@ Media_end(Media_t *Mediap)
 	     Mediap->M_pos == POS_INDIR
 	     ||
 	     Mediap->M_pos == POS_ATNONDIR) {
-		(* dop->do_end_read)(drivep);
+		(*dop->do_end_read)(drivep);
 		Mediap->M_pos = POS_UNKN;
 	}
 }
@@ -8494,7 +8494,7 @@ restore_extent(filehdr_t *fhdrp,
 		size_t ntowrite;
 
 		req_bufsz = (size_t)min((off64_t)INTGENMAX, sz);
-		bufp = (* dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
+		bufp = (*dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
 		if (rval) {
 			rv_t rv;
 			char *reasonstr;
@@ -8639,7 +8639,7 @@ restore_extent(filehdr_t *fhdrp,
 		} else {
 			nwritten = 0;
 		}
-		(* dop->do_return_read_buf)(drivep, bufp, sup_bufsz);
+		(*dop->do_return_read_buf)(drivep, bufp, sup_bufsz);
 		if ((size_t)nwritten != ntowrite) {
 			if (nwritten < 0) {
 				mlog(MLOG_NORMAL, _(
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 864facb..36b60dc 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -621,7 +621,7 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 
 bool_t
 dirattr_cb_extattr(dah_t dah,
-		    bool_t (* cbfunc)(extattrhdr_t *ahdrp,
+		    bool_t (*cbfunc)(extattrhdr_t *ahdrp,
 				         void *ctxp),
 		    extattrhdr_t *ahdrp,
 		    void *ctxp)
@@ -735,7 +735,7 @@ dirattr_cb_extattr(dah_t dah,
 
 		/* call the callback func
 		 */
-		ok = (* cbfunc)(ahdrp, ctxp);
+		ok = (*cbfunc)(ahdrp, ctxp);
 		if (! ok) {
 			return BOOL_FALSE;
 		}
diff --git a/restore/dirattr.h b/restore/dirattr.h
index dd37a98..232822e 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -83,7 +83,7 @@ extern void dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp);
  * else returns TRUE.
  */
 extern bool_t dirattr_cb_extattr(dah_t dah,
-				  bool_t (* cbfunc)(extattrhdr_t *ahdrp,
+				  bool_t (*cbfunc)(extattrhdr_t *ahdrp,
 						       void *ctxp),
 				  extattrhdr_t *ahdrp,
 				  void *ctxp);
diff --git a/restore/inomap.c b/restore/inomap.c
index 8ab588d..22142cd 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -585,7 +585,7 @@ begin:
  */
 void
 inomap_cbiter(int statemask,
-	       bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
+	       bool_t (*cbfunc)(void *ctxp, xfs_ino_t ino),
 	       void *ctxp)
 {
 	hnk_t *hnkp;
diff --git a/restore/inomap.h b/restore/inomap.h
index 93f982c..55f9d07 100644
--- a/restore/inomap.h
+++ b/restore/inomap.h
@@ -80,7 +80,7 @@ extern void inomap_rst_add(xfs_ino_t ino);
 extern void inomap_rst_del(xfs_ino_t ino);
 extern rv_t inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp);
 extern void inomap_cbiter(int mapstatemask,
-			   bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
+			   bool_t (*cbfunc)(void *ctxp, xfs_ino_t ino),
 			   void *ctxp);
 
 #endif /* INOMAP_H */
diff --git a/restore/tree.c b/restore/tree.c
index 58b88ff..024e26b 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -287,7 +287,7 @@ static nh_t link_nexth(nh_t nh);
 static nh_t link_matchh(nh_t hardh, nh_t parh, char *name);
 static void link_in(nh_t nh);
 static void link_out(nh_t nh);
-static void link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh),
+static void link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh),
 			   void *contextp);
 static void link_iter_init(link_iter_context_t *link_iter_contextp,
 			    nh_t hardheadh);
@@ -302,7 +302,7 @@ static inline size_t hash_val(xfs_ino_t ino, size_t hashmask);
 static void hash_in(nh_t nh);
 static void hash_out(nh_t nh);
 static nh_t hash_find(xfs_ino_t ino, gen_t gen);
-static void hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh),
+static void hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh),
 		       void *contextp);
 static void setdirattr(dah_t dah, char *path);
 static bool_t tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
@@ -1744,7 +1744,7 @@ tree_cb_links(xfs_ino_t ino,
 	       gen_t gen,
 	       int32_t ctime,
 	       int32_t mtime,
-	       bool_t (* funcp)(void *contextp,
+	       bool_t (*funcp)(void *contextp,
 				   bool_t linkpr,
 				   char *path1,
 				   char *path2),
@@ -1876,7 +1876,7 @@ tree_cb_links(xfs_ino_t ino,
 			      ino,
 			      gen);
 		}
-		ok = (* funcp)(contextp, path == path2, path1, path2);
+		ok = (*funcp)(contextp, path == path2, path1, path2);
 		if (! ok) {
 			return RV_NOTOK;
 		}
@@ -1929,7 +1929,7 @@ tree_cb_links(xfs_ino_t ino,
 				      "discarding %llu %u\n",
 				      ino,
 				      gen);
-				ok = (* funcp)(contextp, BOOL_FALSE, 0, 0);
+				ok = (*funcp)(contextp, BOOL_FALSE, 0, 0);
 				if (! ok) {
 					return RV_NOTOK;
 				}
@@ -1947,7 +1947,7 @@ tree_cb_links(xfs_ino_t ino,
 				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 				      "ino %llu salvaging file,"
 				      " placing in %s\n"), ino, path1);
-				ok = (* funcp)(contextp, path == path2,
+				ok = (*funcp)(contextp, path == path2,
 					path1, path2);
 				if (! ok) {
 					return RV_NOTOK;
@@ -1974,7 +1974,7 @@ tree_cb_links(xfs_ino_t ino,
 			adopt(persp->p_orphh, nh, NRH_NULL);
 			ok = Node2path(nh, path1, _("orphan"));
 			assert(ok);
-			(void)(* funcp)(contextp, BOOL_FALSE, path1,path2);
+			(void)(*funcp)(contextp, BOOL_FALSE, path1,path2);
 		}
 	}
 	return RV_OK;
@@ -2035,12 +2035,12 @@ tree_adjref_recurse(nh_t cldh,
 
 static bool_t tree_extattr_recurse(nh_t parh,
 				    nh_t cldh,
-				    bool_t (* cbfunc)(char *path,
+				    bool_t (*cbfunc)(char *path,
 							 dah_t dah),
 				    char *path);
 
 bool_t
-tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah), char *path)
+tree_extattr(bool_t (*cbfunc)(char *path, dah_t dah), char *path)
 {
 	node_t *rootp;
 	nh_t cldh;
@@ -2057,7 +2057,7 @@ tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah), char *path)
 static bool_t
 tree_extattr_recurse(nh_t parh,
 		      nh_t cldh,
-		      bool_t (* cbfunc)(char *path, dah_t dah),
+		      bool_t (*cbfunc)(char *path, dah_t dah),
 		      char *path)
 {
 	node_t *parp;
@@ -2113,7 +2113,7 @@ tree_extattr_recurse(nh_t parh,
 		return BOOL_TRUE;
 	}
 	if (dah != DAH_NULL) {
-		ok = (* cbfunc)(path, dah);
+		ok = (*cbfunc)(path, dah);
 	} else {
 		ok = BOOL_TRUE;
 	}
@@ -2833,14 +2833,14 @@ tsi_cmd_pwd(void *ctxp,
 	/* special case root
 	 */
 	if (tranp->t_inter.i_cwdh == persp->p_rooth) {
-		(* pcb)(pctxp, "cwd is fs root\n");
+		(*pcb)(pctxp, "cwd is fs root\n");
 		return;
 	}
 
 	/* ascend tree recursively, print path on way back
 	 */
 	tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, tranp->t_inter.i_cwdh);
-	(* pcb)(pctxp, "\n");
+	(*pcb)(pctxp, "\n");
 }
 
 static void
@@ -2864,14 +2864,14 @@ tsi_cmd_pwd_recurse(void *ctxp,
 	if (parh != persp->p_rooth) {
 		tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, parh);
 			/* RECURSION */
-		(* pcb)(pctxp, "/");
+		(*pcb)(pctxp, "/");
 	}
 	assert(nrh != NRH_NULL);
 	namelen = namreg_get(nrh,
 			      tranp->t_inter.i_name,
 			      sizeof(tranp->t_inter.i_name));
 	assert(namelen > 0);
-	(* pcb)(pctxp, tranp->t_inter.i_name);
+	(*pcb)(pctxp, tranp->t_inter.i_name);
 }
 
 /* ARGSUSED */
@@ -2912,7 +2912,7 @@ tsi_cmd_ls(void *ctxp,
 	/* if named is not a dir, just display named
 	 */
 	if (! isdirpr) {
-		(* pcb)(pctxp,
+		(*pcb)(pctxp,
 			   "    %s %10llu %s%s\n",
 			   isselpr ? "*" : " ",
 			   ino,
@@ -2943,7 +2943,7 @@ tsi_cmd_ls(void *ctxp,
 					      tranp->t_inter.i_name,
 					      sizeof(tranp->t_inter.i_name));
 			assert(namelen > 0);
-			(* pcb)(pctxp,
+			(*pcb)(pctxp,
 				   "    %s %10llu %s%s\n",
 				   isselpr ? "*" : " ",
 				   ino,
@@ -2993,7 +2993,7 @@ tsi_cmd_cd(void *ctxp,
 	 */
 	if (! isdirpr) {
 		assert(arg);
-		(* pcb)(pctxp,
+		(*pcb)(pctxp,
 			   _("%s is not a directory\n"),
 			   arg);
 
@@ -3186,9 +3186,9 @@ tsi_cmd_help(void *ctxp,
 				 /
 				 sizeof(tsi_cmd_tbl[0]);
 
-	(* pcb)(pctxp, _("the following commands are available:\n"));
+	(*pcb)(pctxp, _("the following commands are available:\n"));
 	for (; tblp < tblendp; tblp++) {
-		(* pcb)(pctxp,
+		(*pcb)(pctxp,
 			   "\t%s %s\n",
 			   tblp->tct_pattern,
 			   tblp->tct_help);
@@ -3304,7 +3304,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 		 */
 		if (! isdirpr) {
 			if (pcb) {
-				(* pcb)(pctxp, _(
+				(*pcb)(pctxp, _(
 					   "parent of %s is not a directory\n"),
 					   arg);
 			}
@@ -3325,7 +3325,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 		if (! strcmp(nbuf, "..")) {
 			if (parh == NH_NULL) {
 				if (pcb) {
-					(* pcb)(pctxp, _(
+					(*pcb)(pctxp, _(
 						   "%s above root\n"),
 						   arg);
 				}
@@ -3379,7 +3379,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 		 */
 		if (sibh == NH_NULL) {
 			if (pcb) {
-				(* pcb)(pctxp, _(
+				(*pcb)(pctxp, _(
 					   "%s not found\n"),
 					   arg);
 			}
@@ -3999,7 +3999,7 @@ link_out(nh_t nh)
  * iteration aborted if callback returns FALSE
  */
 static void
-link_headiter(bool_t (* cbfp)(void *contextp, nh_t hardh), void *contextp)
+link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh), void *contextp)
 {
 	hash_iter(cbfp, contextp);
 }
@@ -4369,7 +4369,7 @@ hash_find(xfs_ino_t ino, gen_t gen)
  * must figure next node prior to calling callback.
  */
 static void
-hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
+hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh), void *contextp)
 {
 	ix_t hix;
 	size64_t hashlen = persp->p_hashsz / sizeof(nh_t);
@@ -4386,7 +4386,7 @@ hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
 			nexth = np->n_hashh;
 			Node_unmap(nh, &np);
 
-			ok = (* cbfp)(contextp, nh);
+			ok = (*cbfp)(contextp, nh);
 			if (! ok) {
 				return;
 			}
diff --git a/restore/tree.h b/restore/tree.h
index 6c9551b..4f9ffe8 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -97,7 +97,7 @@ extern rv_t tree_cb_links(xfs_ino_t ino,
 			   gen_t gen,
 			   int32_t ctime,
 			   int32_t mtime,
-			   bool_t (* funcp)(void *contextp,
+			   bool_t (*funcp)(void *contextp,
 					       bool_t linkpr,
 					       char *path1,
 					       char *path2),
@@ -115,7 +115,7 @@ extern bool_t tree_setattr(char *path);
 extern bool_t tree_delorph(void);
 extern bool_t tree_subtree_inter(void);
 
-extern bool_t tree_extattr(bool_t (* cbfunc)(char *path, dah_t dah),
+extern bool_t tree_extattr(bool_t (*cbfunc)(char *path, dah_t dah),
 			    char *path);
 	/* does a depthwise bottom-up traversal of the tree, calling
 	 * the supplied callback for all directories with a non-NULL dirattr
-- 
2.19.1

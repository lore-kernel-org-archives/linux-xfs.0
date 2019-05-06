Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfEFLwi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 07:52:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67C60A405A
        for <linux-xfs@vger.kernel.org>; Mon,  6 May 2019 11:52:38 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsdump: (style) remove spaces in front of commas/semicolons
Date: Mon,  6 May 2019 13:52:12 +0200
Message-Id: <20190506115212.9876-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys,

Here is another xfsdump cleaning patch.
Git stat: 31 files changed, 206 insertions(+), 206 deletions(-)

Cheers,
Jan

---

Turn all the "x , y , z" into "x, y, z" and "for (moo ; foo ; bar)"
to "for (moo; foo; bar)".

When doing a clean build, no new warning is produced or existing one
removed.

Changed macros:
__arch__swab[16,32,64] in include/swab.h.

Created by this script:
*****
set -euo pipefail

find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
    $0 = gensub(/^([^"]*[^[:space:]][^"]*) ,/, "\\1,", "g")
    $0 = gensub(/^([^"]*[^[:space:]][^"]*) ;/, "\\1;", "g")
    $0 = gensub(/^(.*[^[:space:]].*) ,([^"]*)$/, "\\1,\\2", "g")
    $0 = gensub(/(.*[^[:space:]].*) ;([^"]*)$/, "\\1;\\2", "g")
}; {print }' {} \;
*****

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/cldmgr.c         |  8 +++----
 common/dlog.c           | 14 +++++------
 common/drive.c          | 10 ++++----
 common/drive_minrmt.c   | 34 +++++++++++++--------------
 common/drive_scsitape.c | 36 ++++++++++++++--------------
 common/drive_simple.c   |  4 ++--
 common/fs.c             |  4 ++--
 common/global.c         |  4 ++--
 common/hsmapi.c         |  2 +-
 common/main.c           | 30 ++++++++++++------------
 common/media.c          |  8 +++----
 common/mlog.c           | 18 +++++++-------
 common/path.c           | 10 ++++----
 common/ring.c           |  6 ++---
 common/stream.c         | 12 +++++-----
 common/ts_mtio.h        |  2 +-
 common/util.c           |  6 ++---
 dump/content.c          | 52 ++++++++++++++++++++---------------------
 dump/inomap.c           | 18 +++++++-------
 include/swab.h          |  6 ++---
 inventory/inv_api.c     |  8 +++----
 inventory/inv_idx.c     |  4 ++--
 inventory/inv_oref.c    |  2 +-
 inventory/inv_stobj.c   | 20 ++++++++--------
 invutil/invutil.c       |  8 +++----
 librmt/rmtfstat.c       |  2 +-
 restore/content.c       | 42 ++++++++++++++++-----------------
 restore/dirattr.c       |  2 +-
 restore/inomap.c        |  8 +++----
 restore/node.c          |  2 +-
 restore/tree.c          | 30 ++++++++++++------------
 31 files changed, 206 insertions(+), 206 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index ecd31f8..3702f71 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -133,7 +133,7 @@ cldmgr_join(void)
 	int xc = EXIT_NORMAL;
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->c_state == C_EXITED) {
 			if ((int)(p->c_streamix) >= 0) {
 				stream_dead(p->c_tid);
@@ -173,7 +173,7 @@ cldmgr_remainingcnt(void)
 
 	cnt = 0;
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->c_state == C_ALIVE) {
 			cnt++;
 		}
@@ -190,7 +190,7 @@ cldmgr_otherstreamsremain(ix_t streamix)
 	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->c_state == C_ALIVE && p->c_streamix != streamix) {
 			unlock();
 			return BOOL_TRUE;
@@ -208,7 +208,7 @@ cldmgr_getcld(void)
 	cld_t *ep = cld + sizeof(cld) / sizeof(cld[0]);
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->c_state == C_AVAIL) {
 			p->c_state = C_ALIVE;
 			break;
diff --git a/common/dlog.c b/common/dlog.c
index 3626568..ee2654f 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -88,7 +88,7 @@ dlog_init(int argc, char *argv[])
 	}
 #ifdef RESTORE
 	/* look to see if restore source coming in on
-	 * stdin. If so , try to open /dev/tty for dialogs.
+	 * stdin. If so, try to open /dev/tty for dialogs.
 	 */
 	if (optind < argc && ! strcmp(argv[optind ], "-")) {
 		dlog_ttyfd = open("/dev/tty", O_RDWR);
@@ -150,7 +150,7 @@ dlog_begin(char *preamblestr[], size_t preamblecnt)
 	size_t ix;
 
 	mlog_lock();
-	for (ix = 0 ; ix < preamblecnt ; ix++) {
+	for (ix = 0; ix < preamblecnt; ix++) {
 		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      preamblestr[ix]);
 	}
@@ -161,7 +161,7 @@ dlog_end(char *postamblestr[], size_t postamblecnt)
 {
 	size_t ix;
 
-	for (ix = 0 ; ix < postamblecnt ; ix++) {
+	for (ix = 0; ix < postamblecnt; ix++) {
 		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      postamblestr[ix]);
 	}
@@ -193,14 +193,14 @@ dlog_multi_query(char *querystr[],
 
 	/* display query description strings
 	 */
-	for (ix = 0 ; ix < querycnt ; ix++) {
+	for (ix = 0; ix < querycnt; ix++) {
 		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      querystr[ix]);
 	}
 
 	/* display the choices: NOTE: display is 1-based, code intfs 0-based!
 	 */
-	for (ix = 0 ; ix < choicecnt ; ix++) {
+	for (ix = 0; ix < choicecnt; ix++) {
 		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      "%u: %s",
 		      ix + 1,
@@ -231,7 +231,7 @@ dlog_multi_query(char *querystr[],
 	/* read the tty until we get a proper answer or are interrupted
 	 */
 	prepromptstr = "";
-	for (; ;) {
+	for (;;) {
 		ix_t exceptionix;
 		bool_t ok;
 
@@ -275,7 +275,7 @@ dlog_multi_ack(char *ackstr[], size_t ackcnt)
 {
 	size_t ix;
 
-	for (ix = 0 ; ix < ackcnt ; ix++) {
+	for (ix = 0; ix < ackcnt; ix++) {
 		mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE,
 		      ackstr[ix]);
 	}
diff --git a/common/drive.c b/common/drive.c
index b01b916..a3514a9 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -200,7 +200,7 @@ drive_init1(int argc, char *argv[])
 	/* run each drive past each strategy, pick the best match
 	 * and instantiate a drive manager.
 	 */
-	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+	for (driveix = 0; driveix < drivecnt; driveix++) {
 		drive_t *drivep = drivepp[driveix];
 		int bestscore = 0 - INTGENMAX;
 		ix_t six;
@@ -208,7 +208,7 @@ drive_init1(int argc, char *argv[])
 		drive_strategy_t *bestsp = 0;
 		bool_t ok;
 
-		for (six = 0 ; six < scnt ; six++) {
+		for (six = 0; six < scnt; six++) {
 			drive_strategy_t *sp = strategypp[six];
 			int score;
 			score = (* sp->ds_match)(argc,
@@ -251,7 +251,7 @@ drive_init2(int argc,
 {
 	ix_t driveix;
 
-	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+	for (driveix = 0; driveix < drivecnt; driveix++) {
 		drive_t *drivep = drivepp[driveix];
 		bool_t ok;
 
@@ -274,7 +274,7 @@ drive_init3(void)
 {
 	ix_t driveix;
 
-	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+	for (driveix = 0; driveix < drivecnt; driveix++) {
 		drive_t *drivep = drivepp[driveix];
 		bool_t ok;
 
@@ -336,7 +336,7 @@ drive_display_metrics(void)
 {
 	ix_t driveix;
 
-	for (driveix = 0 ; driveix < drivecnt ; driveix++) {
+	for (driveix = 0; driveix < drivecnt; driveix++) {
 		drive_t *drivep = drivepp[driveix];
 		drive_ops_t *dop = drivep->d_opsp;
 		if (dop->do_display_metrics) {
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index e9be114..9fd1009 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -269,7 +269,7 @@ static int ds_instantiate(int, char *[], drive_t *);
 static bool_t do_init(drive_t *);
 static bool_t do_sync(drive_t *);
 static int do_begin_read(drive_t *);
-static char *do_read(drive_t *, size_t , size_t *, int *);
+static char *do_read(drive_t *, size_t, size_t *, int *);
 static void do_return_read_buf(drive_t *, char *, size_t);
 static void do_get_mark(drive_t *, drive_mark_t *);
 static int do_seek_mark(drive_t *, drive_mark_t *);
@@ -278,12 +278,12 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t , size_t *);
+static char * do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
-static int do_fsf(drive_t *, int , int *);
-static int do_bsf(drive_t *, int , int *);
+static int do_fsf(drive_t *, int, int *);
+static int do_bsf(drive_t *, int, int *);
 static int do_rewind(drive_t *);
 static int do_erase(drive_t *);
 static int do_eject_media(drive_t *);
@@ -293,7 +293,7 @@ static void do_quit(drive_t *);
 
 /* misc. local utility funcs
  */
-static int	mt_op(int , int , int);
+static int	mt_op(int, int, int);
 static int determine_write_error(int, int);
 static int read_label(drive_t *);
 static bool_t tape_rec_checksum_check(drive_context_t *, char *);
@@ -423,7 +423,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
 
 	/* Check if the min rmt flag and block size have
 	 * been specified.
-	 * If so , this is a non-SGI drive and this is the right
+	 * If so, this is a non-SGI drive and this is the right
 	 * strategy.
 	 */
 	{
@@ -757,7 +757,7 @@ do_begin_read(drive_t *drivep)
 			return rval;
 		}
 	} else {
-		rval = read_label(drivep) ;
+		rval = read_label(drivep);
 		if (rval) {
 			if (! contextp->dc_singlethreadedpr) {
 			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
@@ -1330,7 +1330,7 @@ do_next_mark(drive_t *drivep)
 	}
 
 noerrorsearch:
-	for (; ;) {
+	for (;;) {
 		rval = getrec(drivep);
 		if (rval == DRIVE_ERROR_CORRUPTION) {
 			goto resetring;
@@ -2230,7 +2230,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
 	assert(count);
 	assert(contextp->dc_mode == OM_NONE);
 
-	for (i = 0 ; i < count; i++) {
+	for (i = 0; i < count; i++) {
 		done = 0;
 		opcount = 2;
 
@@ -2328,7 +2328,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
 
 	/* now loop, skipping media files
 	 */
-	for (skipped = 0 ; skipped < count ; skipped++) {
+	for (skipped = 0; skipped < count; skipped++) {
 
 		/* move to the left of the next file mark on the left.
 		 * check for BOT.
@@ -2932,7 +2932,7 @@ tape_rec_checksum_set(drive_context_t *contextp, char *bufp)
 	INT_SET(rechdrp->ischecksum, ARCH_CONVERT, 1);
 	rechdrp->checksum = 0;
 	accum = 0;
-	for (p = beginp ; p < endp ; p++) {
+	for (p = beginp; p < endp; p++) {
 	        accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	INT_SET(rechdrp->checksum, ARCH_CONVERT, (int32_t)(~accum + 1));
@@ -2949,7 +2949,7 @@ tape_rec_checksum_check(drive_context_t *contextp, char *bufp)
 
 	if (contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
 		accum = 0;
-		for (p = beginp ; p < endp ; p++) {
+		for (p = beginp; p < endp; p++) {
 	       		accum += INT_GET(*p, ARCH_CONVERT);
 		}
 		return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
@@ -3088,7 +3088,7 @@ prepare_drive(drive_t *drivep)
 	 * if not present or write-protected during dump, return.
 	 */
 	maxtries = 15;
-	for (try = 1 ; ; sleep(10), try++) {
+	for (try = 1;; sleep(10), try++) {
 		if (cldmgr_stop_requested()) {
 			return DRIVE_ERROR_STOP;
 		}
@@ -3139,7 +3139,7 @@ prepare_drive(drive_t *drivep)
 	else
 		tape_recsz = tape_blksz;
 
-	/* if the overwrite option was specified , return.
+	/* if the overwrite option was specified, return.
 	 */
 	if (contextp->dc_overwritepr) {
 		mlog(MLOG_DEBUG | MLOG_DRIVE,
@@ -3157,7 +3157,7 @@ prepare_drive(drive_t *drivep)
 	maxtries = 5;
 	changedblkszpr = BOOL_FALSE;
 
-	for (try = 1 ; ; try++) {
+	for (try = 1;; try++) {
 		int nread;
 		int saved_errno;
 
@@ -3896,7 +3896,7 @@ rewind_and_verify(drive_t *drivep)
 	int rval;
 
 	rval = mt_op(contextp->dc_fd, MTREW, 0);
-	for (try = 1 ; ; try++) {
+	for (try = 1;; try++) {
 		if (rval) {
 			sleep(1);
 			rval = mt_op(contextp->dc_fd, MTREW, 0);
@@ -3935,7 +3935,7 @@ erase_and_verify(drive_t *drivep)
 	 * detect if we have erased the tape.
 	 */
 
-	tempbufp = (char *) calloc(1 , (size_t)tape_recsz);
+	tempbufp = (char *) calloc(1, (size_t)tape_recsz);
 	strcpy(tempbufp, ERASE_MAGIC);
 	Write(drivep, tempbufp, tape_recsz, &saved_errno);
 	free(tempbufp);
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 5c9ee89..fee5699 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -311,7 +311,7 @@ static int ds_instantiate(int, char *[], drive_t *);
 static bool_t do_init(drive_t *);
 static bool_t do_sync(drive_t *);
 static int do_begin_read(drive_t *);
-static char *do_read(drive_t *, size_t , size_t *, int *);
+static char *do_read(drive_t *, size_t, size_t *, int *);
 static void do_return_read_buf(drive_t *, char *, size_t);
 static void do_get_mark(drive_t *, drive_mark_t *);
 static int do_seek_mark(drive_t *, drive_mark_t *);
@@ -320,12 +320,12 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t , size_t *);
+static char * do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
-static int do_fsf(drive_t *, int , int *);
-static int do_bsf(drive_t *, int , int *);
+static int do_fsf(drive_t *, int, int *);
+static int do_bsf(drive_t *, int, int *);
 static int do_rewind(drive_t *);
 static int do_erase(drive_t *);
 static int do_eject_media(drive_t *);
@@ -335,8 +335,8 @@ static void do_quit(drive_t *);
 
 /* misc. local utility funcs
  */
-static int	mt_op(int , int , int);
-static int mt_blkinfo(int , struct mtblkinfo *);
+static int	mt_op(int, int, int);
+static int mt_blkinfo(int, struct mtblkinfo *);
 static bool_t mt_get_fileno(drive_t *, long *);
 static bool_t mt_get_status(drive_t *, mtstat_t *);
 static int determine_write_error(drive_t *, int, int);
@@ -1445,7 +1445,7 @@ do_next_mark(drive_t *drivep)
 	}
 
 noerrorsearch:
-	for (; ;) {
+	for (;;) {
 		rval = getrec(drivep);
 		if (rval == DRIVE_ERROR_CORRUPTION) {
 			goto resetring;
@@ -2403,7 +2403,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
 		return 0;
 	}
 
-	for (i = 0 ; i < count; i++) {
+	for (i = 0; i < count; i++) {
 		done = 0;
 		opcount = 2;
 
@@ -2559,7 +2559,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
 
 	/* now loop, skipping media files
 	 */
-	for (skipped = 0 ; skipped < count ; skipped++) {
+	for (skipped = 0; skipped < count; skipped++) {
 
 		/* move to the left of the next file mark on the left.
 		 * check for BOT.
@@ -3146,7 +3146,7 @@ set_fixed_blksz(drive_t *drivep, size_t blksz)
 
 	/* give it two tries: first without rewinding, second with rewinding
 	 */
-	for (try = 1 ; try <= 2 ; try++) {
+	for (try = 1; try <= 2; try++) {
 		struct mtblkinfo mtinfo;
 
 		/* set the tape block size. requires re-open
@@ -3624,7 +3624,7 @@ tape_rec_checksum_set(drive_context_t *contextp, char *bufp)
 	INT_SET(rechdrp->ischecksum, ARCH_CONVERT, 1);
 	rechdrp->checksum = 0;
 	accum = 0;
-	for (p = beginp ; p < endp ; p++) {
+	for (p = beginp; p < endp; p++) {
 	        accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	INT_SET(rechdrp->checksum, ARCH_CONVERT, (int32_t)(~accum + 1));
@@ -3641,7 +3641,7 @@ tape_rec_checksum_check(drive_context_t *contextp, char *bufp)
 
 	if (contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
 		accum = 0;
-		for (p = beginp ; p < endp ; p++) {
+		for (p = beginp; p < endp; p++) {
 	       		accum += INT_GET(*p, ARCH_CONVERT);
 		}
 		return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
@@ -3878,7 +3878,7 @@ retry:
 	 * if not present or write-protected during dump, return.
 	 */
 	maxtries = 15;
-	for (try = 1 ; ; sleep(10), try++) {
+	for (try = 1;; sleep(10), try++) {
 		if (cldmgr_stop_requested()) {
 			return DRIVE_ERROR_STOP;
 		}
@@ -3990,7 +3990,7 @@ retry:
 		return DRIVE_ERROR_INVAL;
 	}
 
-	/* if the overwrite option was specified , set the best blocksize
+	/* if the overwrite option was specified, set the best blocksize
 	 * we can and return.
 	 */
 	if (contextp->dc_overwritepr) {
@@ -4051,7 +4051,7 @@ retry:
  	 */
 	maxtries = 5;
 	changedblkszpr = BOOL_FALSE;
-	for (try = 1 ; ; try++) {
+	for (try = 1;; try++) {
 		bool_t wasatbotpr;
 		int nread;
 		int saved_errno;
@@ -5175,7 +5175,7 @@ rewind_and_verify(drive_t *drivep)
 	int rval;
 
 	rval = mt_op(contextp->dc_fd, MTREW, 0);
-	for (try = 1 ; ; try++) {
+	for (try = 1;; try++) {
 		mtstat_t mtstat;
 		bool_t ok;
 
@@ -5231,7 +5231,7 @@ bsf_and_verify(drive_t *drivep)
 	/* Can't do with LINUX ST driver, as GMT_EOF never set for left of fmk */
 	if (TS_ISDRIVER) {
 		(void)mt_op(contextp->dc_fd, MTBSF, 1);
-		for (try = 1 ; ; try++) {
+		for (try = 1;; try++) {
 			mtstat_t mtstat;
 
 			ok = mt_get_status(drivep, &mtstat);
@@ -5301,7 +5301,7 @@ fsf_and_verify(drive_t *drivep)
 	ix_t try;
 
 	(void)mt_op(contextp->dc_fd, MTFSF, 1);
-	for (try = 1 ; ; try++) {
+	for (try = 1;; try++) {
 		mtstat_t mtstat;
 		bool_t ok;
 
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 2d802d3..fd1a958 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -116,7 +116,7 @@ static int ds_instantiate(int, char *[], drive_t *);
 static bool_t do_init(drive_t *);
 static bool_t do_sync(drive_t *);
 static int do_begin_read(drive_t *);
-static char *do_read(drive_t *, size_t , size_t *, int *);
+static char *do_read(drive_t *, size_t, size_t *, int *);
 static void do_return_read_buf(drive_t *, char *, size_t);
 static void do_get_mark(drive_t *, drive_mark_t *);
 static int do_seek_mark(drive_t *, drive_mark_t *);
@@ -125,7 +125,7 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t , size_t *);
+static char * do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
diff --git a/common/fs.c b/common/fs.c
index 4880db9..5c2b266 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -333,7 +333,7 @@ fs_tab_lookup_blk(char *blks)
 {
 	fs_tab_ent_t *tep;
 
-	for (tep = fs_tabp ; tep ; tep = tep->fte_nextp) {
+	for (tep = fs_tabp; tep; tep = tep->fte_nextp) {
 		struct stat64 stata;
 		bool_t aok;
 		struct stat64 statb;
@@ -361,7 +361,7 @@ fs_tab_lookup_mnt(char *mnts)
 {
 	fs_tab_ent_t *tep;
 
-	for (tep = fs_tabp ; tep ; tep = tep->fte_nextp) {
+	for (tep = fs_tabp; tep; tep = tep->fte_nextp) {
 		if (tep->fte_mnts && ! strcmp(tep->fte_mnts, mnts)) {
 			return tep;
 		}
diff --git a/common/global.c b/common/global.c
index 62a00c3..881042b 100644
--- a/common/global.c
+++ b/common/global.c
@@ -250,7 +250,7 @@ global_hdr_checksum_set(global_hdr_t *hdrp)
 
 	hdrp->gh_checksum = 0;
 	accum = 0;
-	for (p = beginp ; p < endp ; p++) {
+	for (p = beginp; p < endp; p++) {
 		accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	INT_SET(hdrp->gh_checksum, ARCH_CONVERT, (int32_t)(~accum + 1));
@@ -269,7 +269,7 @@ global_hdr_checksum_check(global_hdr_t *hdrp)
 	uint32_t accum;
 
 	accum = 0;
-	for (p = beginp ; p < endp ; p++) {
+	for (p = beginp; p < endp; p++) {
 		accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 24bb924..e3e18a7 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -871,7 +871,7 @@ HsmEndRestoreFile(
 	 */
 	if (*hsm_flagp) {
 		int rv;
-		rv = attr_removef(fd, DMF_ATTR_NAME , ATTR_ROOT);
+		rv = attr_removef(fd, DMF_ATTR_NAME, ATTR_ROOT);
 		if (rv) {
 			mlog(MLOG_NORMAL | MLOG_WARNING,
 			     _("error removing temp DMF attr on %s: %s\n"),
diff --git a/common/main.c b/common/main.c
index 1edfae4..3193142 100644
--- a/common/main.c
+++ b/common/main.c
@@ -656,7 +656,7 @@ main(int argc, char *argv[])
 	 * drive.h, initialized by drive_init[12]
 	 */
 	if (! init_error) {
-		for (stix = 0 ; stix < drivecnt ; stix++) {
+		for (stix = 0; stix < drivecnt; stix++) {
 			ok = cldmgr_create(childmain,
 					    stix,
 					    "child",
@@ -673,7 +673,7 @@ main(int argc, char *argv[])
 	if (progrpt_enabledpr) {
 		(void)alarm((uint)progrpt_interval);
 	}
-	for (; ;) {
+	for (;;) {
 		time32_t now;
 		bool_t stop_requested = BOOL_FALSE;
 		int stop_timeout = -1;
@@ -839,7 +839,7 @@ main(int argc, char *argv[])
 				char **statline;
 				ix_t i;
 				statlinecnt = content_statline(&statline);
-				for (i = 0 ; i < statlinecnt ; i++) {
+				for (i = 0; i < statlinecnt; i++) {
 					mlog(MLOG_NORMAL,
 					      statline[i]);
 				}
@@ -1054,7 +1054,7 @@ preemptchk(int flg)
 			char **statline;
 			ix_t i;
 			statlinecnt = content_statline(&statline);
-			for (i = 0 ; i < statlinecnt ; i++) {
+			for (i = 0; i < statlinecnt; i++) {
 				mlog(MLOG_NORMAL,
 				      statline[i]);
 			}
@@ -1217,7 +1217,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 * skip the GETOPT_OPTFILE option which put us here!
 	 */
 	sz = 0;
-	for (i =  0 ; i < *argcp ; i++) {
+	for (i =  0; i < *argcp; i++) {
 		if (i == (int)optfileix) {
 			i++; /* to skip option argument */
 			continue;
@@ -1261,7 +1261,7 @@ loadoptfile(int *argcp, char ***argvp)
 
 	/* copy the remaining command line args into the buffer
 	 */
-	for (; i < *argcp ; i++) {
+	for (; i < *argcp; i++) {
 		if (i == (int)optfileix) {
 			i++; /* to skip option argument */
 			continue;
@@ -1277,7 +1277,7 @@ loadoptfile(int *argcp, char ***argvp)
 
 	/* change newlines and carriage returns into spaces
 	 */
-	for (p = argbuf ; *p ; p++) {
+	for (p = argbuf; *p; p++) {
 		if (strchr("\n\r", ( int)( *p))) {
 			*p = ' ';
 		}
@@ -1287,7 +1287,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 */
 	tokencnt = 0;
 	p = argbuf;
-	for (; ;) {
+	for (;;) {
 		/* start at the first non-separator character
 		 */
 		while (*p && strchr(sep, (int)(*p))) {
@@ -1331,7 +1331,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 * extracting quotes and escapes
 	 */
 	p = argbuf;
-	for (i = 0 ; ; i++) {
+	for (i = 0;; i++) {
 		char *endp = 0;
 
 		/* start at the first non-separator character
@@ -1547,7 +1547,7 @@ sigint_dialog(void)
 	preamblestr[preamblecnt++] = fold;
 	preamblestr[preamblecnt++ ] = "\n";
 	preamblestr[preamblecnt++ ] = "\n";
-	for (i = 0 ; i < statlinecnt ; i++) {
+	for (i = 0; i < statlinecnt; i++) {
 		preamblestr[preamblecnt++] = statline[i];
 	}
 	if (stop_in_progress) {
@@ -1649,7 +1649,7 @@ sigint_dialog(void)
 		choicecnt = 0;
 		/* number of lines must match number of subsystems
 		 */
-		for (choicecnt = 0 ; choicecnt < MLOG_SS_CNT ; choicecnt++) {
+		for (choicecnt = 0; choicecnt < MLOG_SS_CNT; choicecnt++) {
 			choicestr[choicecnt] = mlog_ss_names[choicecnt];
 		}
 		allix = choicecnt;
@@ -2264,7 +2264,7 @@ sig_numstring(int num)
 			       (sizeof(sig_printmap)
 			         /
 			         sizeof(sig_printmap[0]));
-	for (; p < endp ; p++) {
+	for (; p < endp; p++) {
 		if (p->num == num) {
 			return p->string;
 		}
@@ -2279,7 +2279,7 @@ strpbrkquotes(char *p, const char *sep)
 	bool_t prevcharwasbackslash = BOOL_FALSE;
 	bool_t inquotes = BOOL_FALSE;
 
-	for (; ; p++) {
+	for (;; p++) {
 		if (*p == 0) {
 			return 0;
 		}
@@ -2337,7 +2337,7 @@ stripquotes(char *p)
 	endp = p + len;
 	justremovedbackslash = BOOL_FALSE;
 
-	for (nextp = p ; nextp < endp ;) {
+	for (nextp = p; nextp < endp;) {
 		if (*nextp == '\\' && ! justremovedbackslash) {
 			shiftleftby1(nextp, endp);
 			endp--;
@@ -2354,7 +2354,7 @@ stripquotes(char *p)
 static void
 shiftleftby1(char *p, char *endp)
 {
-	for (; p < endp ; p++) {
+	for (; p < endp; p++) {
 		*p = p[1];
 	}
 }
diff --git a/common/media.c b/common/media.c
index 15c0478..2337a84 100644
--- a/common/media.c
+++ b/common/media.c
@@ -144,7 +144,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 	mediacnt = dsp->ds_drivecnt;
 	mediapp = (media_t **)calloc(mediacnt, sizeof(media_t *));
 	assert(mediapp);
-	for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+	for (mediaix = 0; mediaix < mediacnt; mediaix++) {
 		mediapp[mediaix] = media_alloc(dsp->ds_drivep[mediaix],
 					 	  medialabel);
 	}
@@ -156,7 +156,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 	 * media_strategy_t as well as the write headers.
 	 */
 	chosen_sp = 0;
-	for (id = 0 ; spp < epp ; spp++, id++) {
+	for (id = 0; spp < epp; spp++, id++) {
 		(*spp)->ms_id = id;
 		if (! chosen_sp) {
 			/* lend the media_t array to the strategy
@@ -164,7 +164,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 			(*spp)->ms_mediap = mediapp;
 			(*spp)->ms_dsp = dsp;
 			(*spp)->ms_mediacnt = mediacnt;
-			for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+			for (mediaix = 0; mediaix < mediacnt; mediaix++) {
 				media_t *mediap = mediapp[mediaix];
 				mediap->m_strategyp = *spp;
 				mediap->m_writehdrp->mh_strategyid = id;
@@ -191,7 +191,7 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 
 	/* give the media_t array to the chosen strategy
 	 */
-	for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+	for (mediaix = 0; mediaix < mediacnt; mediaix++) {
 		media_t *mediap = mediapp[mediaix];
 		mediap->m_strategyp = chosen_sp;
 		mediap->m_writehdrp->mh_strategyid = chosen_sp->ms_id;
diff --git a/common/mlog.c b/common/mlog.c
index e3cf69d..32fcc32 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -138,7 +138,7 @@ mlog_init0(void)
 	 */
 	mlog_streamcnt = 1;
 
-	for(i = 0 ; i < MLOG_SS_CNT ; i++) {
+	for(i = 0; i < MLOG_SS_CNT; i++) {
 		mlog_level_ss[i] = MLOG_VERBOSE;
 	}
 }
@@ -160,12 +160,12 @@ mlog_init1(int argc, char *argv[])
 	suboptstrs = (char **)calloc(MLOG_SS_CNT + vsymcnt + 1,
 					sizeof(char *));
 	assert(suboptstrs);
-	for (soix = 0 ; soix < MLOG_SS_CNT ; soix++) {
+	for (soix = 0; soix < MLOG_SS_CNT; soix++) {
 		assert(strlen(mlog_ss_names[soix]) <= MLOG_SS_NAME_MAX);
 			/* unrelated, but opportunity to chk */
 		suboptstrs[soix] = mlog_ss_names[soix];
 	}
-	for (; soix < MLOG_SS_CNT + vsymcnt ; soix++) {
+	for (; soix < MLOG_SS_CNT + vsymcnt; soix++) {
 		suboptstrs[soix] = mlog_sym[soix - MLOG_SS_CNT].sym;
 	}
 	suboptstrs[soix] = 0;
@@ -174,7 +174,7 @@ mlog_init1(int argc, char *argv[])
 	 * subsystems where explicitly called out. those which weren't will
 	 * be given the "general" level.
 	 */
-	for (ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++) {
+	for (ssix = 0; ssix < MLOG_SS_CNT; ssix++) {
 		mlog_level_ss[ssix] = -1;
 	}
 	mlog_level_ss[MLOG_SS_GEN] = MLOG_VERBOSE;
@@ -273,7 +273,7 @@ mlog_init1(int argc, char *argv[])
 
 	/* give subsystems not explicitly called out the "general" verbosity
 	 */
-	for (ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++) {
+	for (ssix = 0; ssix < MLOG_SS_CNT; ssix++) {
 		if (mlog_level_ss[ssix] < 0) {
 			assert(mlog_level_ss[ssix] == -1);
 			assert(mlog_level_ss[MLOG_SS_GEN] >= 0);
@@ -350,7 +350,7 @@ mlog_override_level(int levelarg)
 	ss = (ix_t)((levelarg & MLOG_SS_MASK) >> MLOG_SS_SHIFT);
 
 	if (ss == MLOG_SS_GEN) { /* do level for all subsys */
-	    for (ss = 0 ; ss < MLOG_SS_CNT ; ss++) {
+	    for (ss = 0; ss < MLOG_SS_CNT; ss++) {
 		mlog_level_ss[ss] = level;
 	    }
 	}
@@ -792,7 +792,7 @@ mlog_sym_lookup(char *sym)
 			 +
 			 sizeof(mlog_sym) / sizeof(mlog_sym[0]);
 
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (! strcmp(sym, p->sym)) {
 			return p->level;
 		}
@@ -827,7 +827,7 @@ fold_init(fold_t fold, char *infostr, char c)
 
 	assert(p < endp);
 	*p++ = ' ';
-	for (cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++) {
+	for (cnt = 0; cnt < predashlen && p < endp; cnt++, p++) {
 		*p = c;
 	}
 	assert(p < endp);
@@ -839,7 +839,7 @@ fold_init(fold_t fold, char *infostr, char c)
 	assert(p < endp);
 	*p++ = ' ';
 	assert(p < endp);
-	for (cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++) {
+	for (cnt = 0; cnt < postdashlen && p < endp; cnt++, p++) {
 		*p = c;
 	}
 	assert(p <= endp);
diff --git a/common/path.c b/common/path.c
index fb1fcf0..f34f2f2 100644
--- a/common/path.c
+++ b/common/path.c
@@ -64,7 +64,7 @@ path_diff(char *path, char *base)
 		return 0;
 	}
 
-	for (; *base && *path == *base ; path++, base++)
+	for (; *base && *path == *base; path++, base++)
 		;
 
 	if (*path == 0) {
@@ -202,7 +202,7 @@ pem_next(pem_t *pemp)
 	/* if end of string encountered, place next next at end of string
 	 */
 	if (! nextnext) {
-		for (nextnext = pemp->pem_next ; *nextnext ; nextnext++)
+		for (nextnext = pemp->pem_next; *nextnext; nextnext++)
 			;
 	}
 
@@ -246,7 +246,7 @@ pa_free(pa_t *pap)
 {
 	int i;
 
-	for (i = 0 ; i < pap->pa_cnt ; i++) {
+	for (i = 0; i < pap->pa_cnt; i++) {
 		free((void *)pap->pa_array[i]);
 	}
 
@@ -288,7 +288,7 @@ pa_gen(pa_t *pap)
 	char *p;
 
 	sz = 0;
-	for (i = 0 ; i < pap->pa_cnt ; i++) {
+	for (i = 0; i < pap->pa_cnt; i++) {
 		sz += strlen(pap->pa_array[i]) + 1;
 	}
 	if (i == 0)
@@ -302,7 +302,7 @@ pa_gen(pa_t *pap)
 		sprintf(retp, "/");
 	} else {
 		p = retp;
-		for (i = 0 ; i < pap->pa_cnt ; i++) {
+		for (i = 0; i < pap->pa_cnt; i++) {
 			sprintf(p, "/%s", pap->pa_array[ i]);
 			p += strlen(p);
 		}
diff --git a/common/ring.c b/common/ring.c
index d1fbcb7..faef34f 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -90,7 +90,7 @@ ring_create(size_t ringlen,
 
 	/* allocate the buffers and initialize the messages
 	 */
-	for (mix = 0 ; mix < ringlen ; mix++) {
+	for (mix = 0; mix < ringlen; mix++) {
 		ring_msg_t *msgp = &ringp->r_msgp[mix];
 		msgp->rm_mix = mix;
 		msgp->rm_op = RING_OP_NONE;
@@ -264,7 +264,7 @@ ring_reset(ring_t *ringp, ring_msg_t *msgp)
 	ringp->r_active_out_ix = 0;
 	ringp->r_client_cnt = 0;
 	ringp->r_slave_cnt = 0;
-	for (mix = 0 ; mix < ringp->r_len ; mix++) {
+	for (mix = 0; mix < ringp->r_len; mix++) {
 		ring_msg_t *msgp = &ringp->r_msgp[mix];
 		msgp->rm_mix = mix;
 		msgp->rm_op = RING_OP_NONE;
@@ -420,7 +420,7 @@ ring_slave_entry(void *ringctxp)
 
 	/* loop reading and precessing messages until told to die
 	 */
-	for (loopmode = LOOPMODE_NORMAL ; loopmode != LOOPMODE_DIE ;) {
+	for (loopmode = LOOPMODE_NORMAL; loopmode != LOOPMODE_DIE;) {
 		ring_msg_t *msgp;
 		int rval;
 
diff --git a/common/stream.c b/common/stream.c
index 64a112a..2860021 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -69,7 +69,7 @@ stream_register(pthread_t tid, int streamix)
 	assert(streamix < STREAM_SIMMAX);
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->s_state == S_FREE) {
 			p->s_state = S_RUNNING;
 			break;
@@ -94,7 +94,7 @@ stream_dead(pthread_t tid)
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
-	for (; p < ep ; p++)
+	for (; p < ep; p++)
 		if (pthread_equal(p->s_tid, tid)) {
 			p->s_state = S_ZOMBIE;
 			break;
@@ -109,7 +109,7 @@ stream_free(pthread_t tid)
 	spm_t *ep = spm + N(spm);
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (pthread_equal(p->s_tid, tid)) {
 			(void) memset((void *) p, 0, sizeof(spm_t));
 			p->s_state = S_FREE;
@@ -154,7 +154,7 @@ stream_find(pthread_t tid, stream_state_t s[], int nstates)
 	assert(nstates > 0);
 
 	/* note we don't lock the stream array in this function */
-	for (; p < ep ; p++)
+	for (; p < ep; p++)
 		if (pthread_equal(p->s_tid, tid)) {
 			/* check state */
 			for (i = 0; i < nstates; i++)
@@ -279,7 +279,7 @@ stream_cnt(void)
 	assert(sizeof(ixmap) * NBBY >= STREAM_SIMMAX);
 
 	lock();
-	for (; p < ep ; p++) {
+	for (; p < ep; p++) {
 		if (p->s_state == S_RUNNING) {
 			ixmap |= (size_t)1 << p->s_ix;
 		}
@@ -287,7 +287,7 @@ stream_cnt(void)
 	unlock();
 
 	ixcnt = 0;
-	for (bitix = 0 ; bitix < STREAM_SIMMAX ; bitix++) {
+	for (bitix = 0; bitix < STREAM_SIMMAX; bitix++) {
 		if (ixmap & ((size_t)1 << bitix)) {
 			ixcnt++;
 		}
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 9e4ae4c..9b31d25 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -146,7 +146,7 @@ struct	mtget_sgi	{
 	int	mt_blkno;	/* block number of current position */
 };
 
-/* old mtget structure , still keep it around for compatibility reason */
+/* old mtget structure, still keep it around for compatibility reason */
 /* the librmt and /etc/rmt code uses it */
 struct	old_mtget	{
 	short	mt_type;	/* type of magtape device */
diff --git a/common/util.c b/common/util.c
index 081a40f..25056a2 100644
--- a/common/util.c
+++ b/common/util.c
@@ -175,7 +175,7 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 		      "bulkstat returns buflen %d ino %llu\n",
 		      buflenout,
 		      buf->bs_ino);
-		for (p = buf, endp = buf + buflenout ; p < endp ; p++) {
+		for (p = buf, endp = buf + buflenout; p < endp; p++) {
 			int rval;
 
 			if (p->bs_ino == 0)
@@ -308,7 +308,7 @@ inogrp_iter(int fsfd,
 			free(igrp);
 			return 0;
 		}
-		for (p = igrp, endp = igrp + inogrpcnt ; p < endp ; p++) {
+		for (p = igrp, endp = igrp + inogrpcnt; p < endp; p++) {
 			int rval;
 
 			rval = (* fp)(arg1, fsfd, p);
@@ -388,7 +388,7 @@ diriter(jdm_fshandle_t *fshandlep,
 	 */
 	scrval = 0;
 	cbrval = 0;
-	for (gdcnt = 1 ; ; gdcnt++) {
+	for (gdcnt = 1;; gdcnt++) {
 		struct dirent *p;
 		int nread;
 		register size_t reclen;
diff --git a/dump/content.c b/dump/content.c
index 43f51db..72ff7c4 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -888,7 +888,7 @@ content_init(int argc,
 			return BOOL_FALSE;
 		}
 		strcnt =  (ix_t)sessp->s_nstreams;
-		for (strix = 0 ; strix < strcnt ; strix++) {
+		for (strix = 0; strix < strcnt; strix++) {
 			bsp = &sessp->s_streams[strix];
 			if (bsp->st_interrupted) {
 				interruptedpr = BOOL_TRUE;
@@ -908,7 +908,7 @@ content_init(int argc,
 			sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
 								sizeof(drange_t));
 			assert(sc_resumerangep);
-			for (strmix = 0 ; strmix < sc_resumerangecnt ; strmix++) {
+			for (strmix = 0; strmix < sc_resumerangecnt; strmix++) {
 				inv_stream_t *bsp;
 				inv_stream_t *esp;
 				drange_t *p = &sc_resumerangep[strmix];
@@ -1009,7 +1009,7 @@ content_init(int argc,
 			underpartialpr = sessp->s_ispartial;
 			underinterruptedpr = BOOL_FALSE;
 			strcnt =  (ix_t)sessp->s_nstreams;
-			for (strix = 0 ; strix < strcnt ; strix++) {
+			for (strix = 0; strix < strcnt; strix++) {
 				bsp = &sessp->s_streams[strix];
 				if (bsp->st_interrupted) {
 					underinterruptedpr = BOOL_TRUE;
@@ -1054,7 +1054,7 @@ content_init(int argc,
 		sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
 						        sizeof(drange_t));
 		assert(sc_resumerangep);
-		for (strmix = 0 ; strmix < sc_resumerangecnt ; strmix++) {
+		for (strmix = 0; strmix < sc_resumerangecnt; strmix++) {
 			inv_stream_t *bsp;
 			inv_stream_t *esp;
 			drange_t *p = &sc_resumerangep[strmix];
@@ -1578,7 +1578,7 @@ baseuuidbypass:
 	 */
 	sc_contextp = (context_t *)calloc(drivecnt, sizeof(context_t));
 	assert(sc_contextp);
-	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+	for (strmix = 0; strmix < drivecnt; strmix++) {
 		context_t *contextp = &sc_contextp[strmix];
 
 		contextp->cc_filehdrp =
@@ -1720,7 +1720,7 @@ baseuuidbypass:
 		ix_t endix = sizeof(sc_mcflag)
 			     /
 			     sizeof(sc_mcflag[0]);
-		for (ix = 0 ; ix < endix ; ix++) {
+		for (ix = 0; ix < endix; ix++) {
 			sc_mcflag[ix] = BOOL_FALSE;
 		}
 	}
@@ -1730,7 +1730,7 @@ baseuuidbypass:
 	 */
 	{
 		ix_t driveix;
-		for (driveix = 0 ; driveix < STREAM_SIMMAX ; driveix++) {
+		for (driveix = 0; driveix < STREAM_SIMMAX; driveix++) {
 			sc_stat_pds[driveix].pds_phase = PDS_NULL;
 		}
 	}
@@ -1756,7 +1756,7 @@ content_statline(char **linespp[])
 
 	/* build and supply the line array
 	 */
-	for (i = 0 ; i < STREAM_SIMMAX + 1 ; i++) {
+	for (i = 0; i < STREAM_SIMMAX + 1; i++) {
 		statline[i] = &statlinebuf[i][0];
 	}
 	*linespp = statline;
@@ -1864,7 +1864,7 @@ content_statline(char **linespp[])
 	/* optionally create stat lines for each drive
 	 */
 	statlinecnt = 1;
-	for (i = 0 ; i < drivecnt ; i++) {
+	for (i = 0; i < drivecnt; i++) {
 		pds_t *pdsp = &sc_stat_pds[i];
 		if (pdsp->pds_phase == PDS_NULL
 		     ||
@@ -1968,7 +1968,7 @@ create_inv_session(
 	sc_inv_stmtokenp = (inv_stmtoken_t *)
 				calloc(drivecnt, sizeof(inv_stmtoken_t));
 	assert(sc_inv_stmtokenp);
-	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+	for (strmix = 0; strmix < drivecnt; strmix++) {
 		drive_t *drivep = drivepp[strmix];
 		char *drvpath;
 
@@ -2195,7 +2195,7 @@ content_stream_dump(ix_t strmix)
 	 * The current startpoint will be updated each time a media mark
 	 * is committed.
 	 */
-	for (; ;) {
+	for (;;) {
 		xfs_ino_t startino;
 		bool_t stop_requested;
 		bool_t hit_eom;
@@ -2747,7 +2747,7 @@ content_mediachange_query(void)
 	querystr[querycnt++ ] = "select a drive to acknowledge media change\n";
 	choicecnt = 0;
 	maxdrvchoiceix = 0;
-	for (thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++) {
+	for (thrdix = 0; thrdix < STREAM_SIMMAX; thrdix++) {
 		if (sc_mcflag[thrdix]) {
 			choicetothrdmap[choicecnt].thrdix = thrdix;
 			sprintf(choicetothrdmap[choicecnt].choicestr,
@@ -2819,7 +2819,7 @@ dump_dirs(ix_t strmix,
 	/* begin iteration at ino zero
 	 */
 	lastino = 0;
-	for (bulkstatcallcnt = 0 ; ; bulkstatcallcnt++) {
+	for (bulkstatcallcnt = 0;; bulkstatcallcnt++) {
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 		__s32 buflenout;
@@ -3024,7 +3024,7 @@ dump_dir(ix_t strmix,
 	/* dump dirents - lots of buffering done here, to achieve OS-
 	 * independence. if proves to be to much overhead, can streamline.
 	 */
-	for (gdcnt = 1, rv = RV_OK ; rv == RV_OK ; gdcnt++) {
+	for (gdcnt = 1, rv = RV_OK; rv == RV_OK; gdcnt++) {
 		struct dirent *p;
 		int nread;
 		register size_t reclen;
@@ -3295,7 +3295,7 @@ dump_extattr_list(drive_t *drivep,
 	 */
 	dumpbufp = contextp->cc_extattrdumpbufp;
 	endp = dumpbufp;
-	for (nameix = 0 ; nameix < listlen ;) {
+	for (nameix = 0; nameix < listlen;) {
 		ix_t rtrvix;
 		size_t rtrvcnt;
 
@@ -3382,7 +3382,7 @@ dump_extattr_list(drive_t *drivep,
 				return RV_OK;
 			}
 
-			for (rtrvix = 0 ; rtrvix < rtrvcnt ; rtrvix++) {
+			for (rtrvix = 0; rtrvix < rtrvcnt; rtrvix++) {
 				attr_multiop_t *opp;
 				opp = &contextp->cc_extattrrtrvarrayp[rtrvix];
 				if (opp->am_error) {
@@ -3976,7 +3976,7 @@ dump_file_reg(drive_t *drivep,
 		size_t drangecnt = sc_resumerangecnt;
 		size_t drangeix;
 
-		for (drangeix = 0 ; drangeix < drangecnt ; drangeix++) {
+		for (drangeix = 0; drangeix < drangecnt; drangeix++) {
 			drange_t *rp = &drangep[drangeix];
 			if (statp->bs_ino == rp->dr_begin.sp_ino) {
 				register time32_t mtime = statp->bs_mtime.tv_sec;
@@ -4051,7 +4051,7 @@ dump_file_reg(drive_t *drivep,
 	cmpltflg = BOOL_FALSE;
 
 	rv = RV_OK;
-	for (; ;) {
+	for (;;) {
 		off64_t bytecnt = 0;
 		off64_t bc;
 
@@ -4377,7 +4377,7 @@ dump_extent_group(drive_t *drivep,
 	bytecnt = 0;
 	assert((nextoffset & (BBSIZE - 1)) == 0);
 
-	for (; ;) {
+	for (;;) {
 		off64_t offset;
 		off64_t extsz;
 
@@ -4829,7 +4829,7 @@ dump_extent_group(drive_t *drivep,
 				     ((s.f_flag & ST_LOCAL) != 0))
 				   mlog(MLOG_NORMAL, _(
 		"can't read ino %llu at offset %d (act=%d req=%d) rt=%d\n"),
-		statp->bs_ino, new_off, actualsz , reqsz, isrealtime);
+		statp->bs_ino, new_off, actualsz, reqsz, isrealtime);
 #endif /* HIDDEN */
 
 				nread = 0;
@@ -5240,7 +5240,7 @@ dump_session_inv(drive_t *drivep,
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
-	for (done = BOOL_FALSE ; ! done ;) {
+	for (done = BOOL_FALSE; ! done;) {
 		uuid_t mediaid;
 		char medialabel[GLOBAL_HDR_STRING_SZ];
 		bool_t partial;
@@ -5390,7 +5390,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
-	for (done = BOOL_FALSE ; ! done ;) {
+	for (done = BOOL_FALSE; ! done;) {
 		bool_t partial;
 		rv_t rv;
 
@@ -5626,7 +5626,7 @@ position:
 	 * be concatenated but not jumbled. a dump stream must be virtually
 	 * contiguous.
 	 */
-	for (; ;) {
+	for (;;) {
 		/* check if a stop has been requested
 		 */
 		if (intr_allowed && cldmgr_stop_requested()) {
@@ -5963,7 +5963,7 @@ changemedia:
 		return RV_QUIT; /* this return value will cause approp. msg */
 	}
 
-	/* If an alert program has been specified , run it
+	/* If an alert program has been specified, run it
 	 */
 	if (media_change_alert_program != NULL)
 	   system(media_change_alert_program);
@@ -6549,7 +6549,7 @@ clr_mcflag(ix_t thrdix)
 {
 	lock();
 	sc_mcflag[thrdix] = BOOL_FALSE;
-	for (thrdix = 0 ; thrdix < drivecnt ; thrdix++) {
+	for (thrdix = 0; thrdix < drivecnt; thrdix++) {
 		if (sc_mcflag[thrdix]) {
 			unlock();
 			return;
@@ -6565,7 +6565,7 @@ check_complete_flags(void)
 	ix_t strmix;
 	bool_t completepr = BOOL_TRUE;
 
-	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+	for (strmix = 0; strmix < drivecnt; strmix++) {
 		context_t *contextp = &sc_contextp[strmix];
 		if (! contextp->cc_completepr) {
 			completepr = BOOL_FALSE;
diff --git a/dump/inomap.c b/dump/inomap.c
index 4c8d490..7841157 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -363,7 +363,7 @@ inomap_build(jdm_fshandle_t *fshandlep,
 
 	if (startptcnt > 1) {
 		ix_t startptix;
-		for (startptix = 0 ; startptix < startptcnt ; startptix++) {
+		for (startptix = 0; startptix < startptcnt; startptix++) {
 			startpt_t *p;
 			startpt_t *ep;
 
@@ -643,7 +643,7 @@ cb_inoinresumerange(xfs_ino_t ino)
 {
 	register size_t streamix;
 
-	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
 		register drange_t *rp = &cb_resumerangep[streamix];
 		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
@@ -668,7 +668,7 @@ cb_inoresumed(xfs_ino_t ino)
 {
 	size_t streamix;
 
-	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
 		drange_t *rp = &cb_resumerangep[streamix];
 		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
@@ -1283,7 +1283,7 @@ inomap_iter(void *contextp, int statemask)
 
 			ino = segp->base + addrp->inooff;
 			endino = segp->base + INOPERSEG;
-			for (; ino < endino ; ino++, addrp->inooff++) {
+			for (; ino < endino; ino++, addrp->inooff++) {
 				int st;
 				st = SEG_GET_BITS(segp, ino);
 				if (statemask & (1 << st)) {
@@ -1427,8 +1427,8 @@ inomap_dump(drive_t *drivep)
 
 	/* use write_buf to dump the hunks
 	 */
-	for (addr.hnkoff = 0 ;
-	      addr.hnkoff <= inomap.lastseg.hnkoff ;
+	for (addr.hnkoff = 0;
+	      addr.hnkoff <= inomap.lastseg.hnkoff;
 	      addr.hnkoff++) {
 		int rval;
 		rv_t rv;
@@ -1484,7 +1484,7 @@ subtreelist_parse(jdm_fshandle_t *fshandlep,
 
 	/* do a recursive descent for each subtree specified
 	 */
-	for (subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++) {
+	for (subtreeix = 0; subtreeix < subtreecnt; subtreeix++) {
 		int cbrval = 0;
 		char *currentpath = subtreebuf[subtreeix];
 		assert(*currentpath != '/');
@@ -1658,7 +1658,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 		return 0;
 	}
 
-	for (; ;) {
+	for (;;) {
 		int eix;
 		int rval;
 
@@ -1678,7 +1678,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 			return offset_next;
 		}
 
-		for (eix = 1 ; eix <= bmap[0].bmv_entries ; eix++) {
+		for (eix = 1; eix <= bmap[0].bmv_entries; eix++) {
 			getbmapx_t *bmapp = &bmap[eix];
 			off64_t qty_new;
 			if (bmapp->bmv_block == -1) {
diff --git a/include/swab.h b/include/swab.h
index abfeeb6..234e7d8 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -61,13 +61,13 @@
  * provide defaults when no architecture-specific optimization is detected
  */
 #ifndef __arch__swab16
-#  define __arch__swab16(x) ({ __u16 __tmp = (x) ; ___swab16(__tmp); })
+#  define __arch__swab16(x) ({ __u16 __tmp = (x); ___swab16(__tmp); })
 #endif
 #ifndef __arch__swab32
-#  define __arch__swab32(x) ({ __u32 __tmp = (x) ; ___swab32(__tmp); })
+#  define __arch__swab32(x) ({ __u32 __tmp = (x); ___swab32(__tmp); })
 #endif
 #ifndef __arch__swab64
-#  define __arch__swab64(x) ({ __u64 __tmp = (x) ; ___swab64(__tmp); })
+#  define __arch__swab64(x) ({ __u64 __tmp = (x); ___swab64(__tmp); })
 #endif
 
 #ifndef __arch__swab16p
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index a5cb4df..a8f65ff 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -301,7 +301,7 @@ inv_stream_open(
 	 * starting/ending inodes or offsets. This can be misleading.
 	 * See bug #463702 for an example.
 	 */
-	memset((void *)&stream, 0 , sizeof(invt_stream_t));
+	memset((void *)&stream, 0, sizeof(invt_stream_t));
 
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_TRUE; /* fix for 353197 */
@@ -706,7 +706,7 @@ inv_lastsession_level_equalto(
 /*----------------------------------------------------------------------*/
 /* inv_getsession_byuuid                                                */
 /*                                                                      */
-/* Given a file system uuid and a session uuid , ses is populated with	*/
+/* Given a file system uuid and a session uuid, ses is populated with	*/
 /* the session that contains the matching system uuid.			*/
 /*									*/
 /* Returns FALSE on an error, TRUE if the session was found.		*/
@@ -903,7 +903,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 			switch (c) {
 			case GETOPT_INVPRINT:
 				prctx->depth = 0;
-				rval |= I_IFOUND ;
+				rval |= I_IFOUND;
 				break;
 			}
 		}
@@ -915,7 +915,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 		switch (c) {
 		case GETOPT_INVPRINT:
-			rval |= I_IFOUND ;
+			rval |= I_IFOUND;
 			if ((options = optarg) == NULL)
 				break;
 
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 7f50a2b..a54cfd7 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -191,7 +191,7 @@ idx_put_newentry(
 				  sizeof(invt_counter_t)) < 0)) {
 			/* XXX delete the stobj that we just created */
 
-			memset(ient->ie_filename, 0 , INV_STRLEN);
+			memset(ient->ie_filename, 0, INV_STRLEN);
 			free(idxarr);
 			return -1;
 		}
@@ -263,7 +263,7 @@ idx_create(char *fname, inv_oflag_t forwhat)
 	   the db for SEARCH_ONLY. */
 	assert(forwhat != INV_SEARCH_ONLY);
 
-	if ((fd = open (fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+	if ((fd = open (fname, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
 		INV_PERROR (fname);
 		return INV_TOKEN_NULL;
 	}
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index a2e08d6..ba5061f 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -432,7 +432,7 @@ oref_resolve_new_invidx(
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	if ((fd = open (fname , O_RDWR | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+	if ((fd = open (fname, O_RDWR | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
 		INV_PERROR (fname);
 		return INV_ERR;
 	}
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 74893d3..6339e4e 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -909,7 +909,7 @@ stobj_getsession_bylabel(
 bool_t
 stobj_delete_mobj(int fd,
 		  invt_seshdr_t *hdr,
-		  void *arg ,
+		  void *arg,
 		  void **buf)
 {
 	/* XXX fd needs to be locked EX, not SH */
@@ -977,7 +977,7 @@ stobj_delete_mobj(int fd,
 				       mfiles[j-1].mf_nextmf = mf->mf_nextmf;
 
 				if (j == nmfiles - 1)
-				       strms[i].st_lastmfile = ;
+				       strms[i].st_lastmfile =;
 */
 			}
 
@@ -1026,7 +1026,7 @@ stobj_unpack_sessinfo(
 	/* skip the cookie */
 	p += strlen(INVTSESS_COOKIE) * sizeof(char);
 
-	/* Check the packing version number. In version 1 , this was the only version number.
+	/* Check the packing version number. In version 1, this was the only version number.
 	 * see the comment in stobj_pack_sessinfo().
 	 */
 	if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_1) {
@@ -1040,15 +1040,15 @@ stobj_unpack_sessinfo(
 		/* We hit a 64 bit alignment issue at this point leading to a
 		 * SIGBUS and core dump. The best way to handle it is to
 		 * bcopy the remaining part of bufp to a new malloc'ed area
-		 * which will be 64 bit aligned. This is a memory leak , but not much.
+		 * which will be 64 bit aligned. This is a memory leak, but not much.
 		 * Have to do this because xfsrestore does another round of
-		 * unpack later , so can't disturb the original data.
+		 * unpack later, so can't disturb the original data.
 		 * This is fixed in PACKED_INV_VERSION_2 by adding another (inv_version_t) to
 		 * have the INV_VERSION. This makes everything 64 bit aligned.
 		 */
 
 		tempsz = bufsz - (strlen(INVTSESS_COOKIE) * sizeof(char))
-			       - sizeof(inv_version_t) ;
+			       - sizeof(inv_version_t);
 		temp_p = calloc(1, tempsz);
 		bcopy(p, temp_p, tempsz);
 		p = temp_p;
@@ -1056,7 +1056,7 @@ stobj_unpack_sessinfo(
 	        mlog(MLOG_DEBUG | MLOG_INV,"INV: packed inventory version = 2\n");
 
 		p += sizeof(inv_version_t); /* skip the packed inventory version */
-		/* At this point , don't care about the INV_VERSION. Maybe in future */
+		/* At this point, don't care about the INV_VERSION. Maybe in future */
 		p += sizeof(inv_version_t); /* skip the inventory version */
 	} else {
 	        mlog(MLOG_NORMAL | MLOG_INV, _(
@@ -1303,7 +1303,7 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 	ises->s_streams = calloc(ises->s_nstreams, sizeof(inv_stream_t));
 	mf = sinfo->mfiles;
 	nstreams = (int) ises->s_nstreams;
-	for (i = 0 ; i < nstreams ; i++) {
+	for (i = 0; i < nstreams; i++) {
 		stobj_convert_strm(&ises->s_streams[i], &sinfo->strms[i]);
 		nmf = (int) ises->s_streams[i].st_nmediafiles;
 		ises->s_streams[i].st_mediafiles = calloc((uint) nmf,
@@ -1377,7 +1377,7 @@ check_for_mobj (inv_session_t *ses, invt_mobjinfo_t *mobj)
 	inv_mediafile_t *mfp;
 
 	for (i = 0; i < (int) ses->s_nstreams; i++) {
-		for (j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++) {
+		for (j = 0; j < ses->s_streams[i].st_nmediafiles; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
 			if (mobj_eql(mfp, mobj))
 				return BOOL_TRUE;
@@ -1453,7 +1453,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 		if (prctx->depth == PR_STRMSONLY)
 			continue;
 
-		for (j = 0 ; j < ses->s_streams[i].st_nmediafiles ; j++) {
+		for (j = 0; j < ses->s_streams[i].st_nmediafiles; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
 			if (moidsearch) {
 				if (! mobj_eql(mfp, mobj))
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 242574f..a002d56 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -260,7 +260,7 @@ main(int argc, char *argv[])
     }
     else if (session_option) {
 	CheckAndPruneFstab(
-		    inventory_path, BOOL_FALSE , mntPoint, &uuid,
+		    inventory_path, BOOL_FALSE, mntPoint, &uuid,
 		    &session, (time32_t)0, r_mf_label);
     }
     else if (uuid_option || mntpnt_option) {
@@ -272,7 +272,7 @@ main(int argc, char *argv[])
 	}
 	else {
 	    CheckAndPruneFstab(
-		    inventory_path, BOOL_FALSE , mntPoint, &uuid,
+		    inventory_path, BOOL_FALSE, mntPoint, &uuid,
 		    &session, timeSecs, r_mf_label);
 	}
     }
@@ -496,9 +496,9 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
     {
 	removeflag = BOOL_FALSE;
 
-	printf("   Found entry for %s\n" , fstabentry[i].ft_mountpt);
+	printf("   Found entry for %s\n", fstabentry[i].ft_mountpt);
 
-	for (j = i +1 ; j < counter->ic_curnum ; j++) {
+	for (j = i +1; j < counter->ic_curnum; j++) {
 	    if (uuid_compare(fstabentry[i].ft_uuid, fstabentry[j].ft_uuid) == 0)
 	    {
 		printf("     duplicate fstab entry\n");
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 8bfaea7..7c21219 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -73,7 +73,7 @@ _rmt_fstat(int fildes, char *arg)
 
 	/* adjust read count to prevent overflow */
 
-	adj_rc = (rc > sizeof(struct stat)) ? sizeof(struct stat) : rc ;
+	adj_rc = (rc > sizeof(struct stat)) ? sizeof(struct stat) : rc;
 	rc -= adj_rc;
 
 	for (; adj_rc > 0; adj_rc -= cnt, arg += cnt)
diff --git a/restore/content.c b/restore/content.c
index 930a76c..cc68472 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -344,7 +344,7 @@ typedef struct stdesc stdesc_t;
 struct bytespan {
 	off64_t	offset;
 	off64_t	endoffset;
-} ;
+};
 
 typedef struct bytespan bytespan_t;
 
@@ -1902,7 +1902,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		ix_t endix = sizeof(mcflag)
 			     /
 			     sizeof(mcflag[0]);
-		for (ix = 0 ; ix < endix ; ix++) {
+		for (ix = 0; ix < endix; ix++) {
 			mcflag[ix] = BOOL_FALSE;
 		}
 	}
@@ -2715,7 +2715,7 @@ content_statline(char **linespp[])
 
 	/* build and supply the line array
 	 */
-	for (i = 0 ; i < 1 ; i++) {
+	for (i = 0; i < 1; i++) {
 		statline[i] = &statlinebuf[i][0];
 	}
 	*linespp = statline;
@@ -2868,7 +2868,7 @@ content_mediachange_query(void)
 		_("select a drive to acknowledge media change\n");
 	choicecnt = 0;
 	maxdrvchoiceix = 0;
-	for (thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++) {
+	for (thrdix = 0; thrdix < STREAM_SIMMAX; thrdix++) {
 		if (mcflag[thrdix]) {
 			choicetothrdmap[choicecnt].thrdix = thrdix;
 			sprintf(choicetothrdmap[choicecnt].choicestr,
@@ -3050,12 +3050,12 @@ applydirdump(drive_t *drivep,
 				return RV_INTR;
 			}
 
-			/* if in a pipeline , call preemptchk() to
+			/* if in a pipeline, call preemptchk() to
 			 * print status reports
 			 */
 			if (pipeline)
 			{
-				mlog(MLOG_DEBUG ,
+				mlog(MLOG_DEBUG,
 					"preemptchk( )\n");
 				preemptchk();
 			}
@@ -3091,7 +3091,7 @@ applydirdump(drive_t *drivep,
 			 * tree with them. we can tell when we are done
 			 * by looking for a null dirent.
 			 */
-			for (; ;) {
+			for (;;) {
 				register direnthdr_t *dhdrp =
 						    (direnthdr_t *)direntbuf;
 				register size_t namelen;
@@ -3247,7 +3247,7 @@ eatdirdump(drive_t *drivep,
 		 * we can tell when we are done
 		 * by looking for a null dirent.
 		 */
-		for (; ;) {
+		for (;;) {
 			register direnthdr_t *dhdrp =
 					    (direnthdr_t *)direntbuf;
 			/* REFERENCED */
@@ -3448,7 +3448,7 @@ applynondirdump(drive_t *drivep,
 	strctxp->sc_ownerset = BOOL_FALSE;
 
 
-	for (; ;) {
+	for (;;) {
 		drive_ops_t *dop = drivep->d_opsp;
 		drive_mark_t drivemark;
 		bstat_t *bstatp = &fhdrp->fh_stat;
@@ -3590,12 +3590,12 @@ applynondirdump(drive_t *drivep,
 				       fhdrp->fh_offset);
 		}
 
-		/* if in a pipeline , call preemptchk() to
+		/* if in a pipeline, call preemptchk() to
 		 * print status reports
 		 */
 		if (pipeline)
 		{
-			mlog(MLOG_DEBUG ,
+			mlog(MLOG_DEBUG,
 				"preemptchk( )\n");
 			preemptchk();
 		}
@@ -3936,7 +3936,7 @@ Media_mfile_next(Media_t *Mediap,
 	/* loop searching for an acceptable media file.
 	 * change media as necessary.
 	 */
-	for (; ;) {
+	for (;;) {
 		bool_t emptypr; /* begin_read says drive empty */
 		bool_t partofdumppr;
 		bool_t hassomepr;
@@ -4791,7 +4791,7 @@ newmedia:
 		 * which may contain useful media files
 		 */
 		if (dlog_allowed()) {
-			/* If an alert program has been specified , run it.
+			/* If an alert program has been specified, run it.
 			 */
 			if (media_change_alert_program != NULL)
 				system(media_change_alert_program);
@@ -5026,7 +5026,7 @@ pi_insertfile(ix_t drivecnt,
 	/* first alloc stream descriptors if needed
 	 */
 	if (persp->s.strmheadh == DH_NULL) {
-		for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+		for (strmix = 0; strmix < drivecnt; strmix++) {
 			ok = pi_allocdesc(&strmh);
 			if (! ok) {
 				pi_unlock();
@@ -5053,7 +5053,7 @@ pi_insertfile(ix_t drivecnt,
 	 * object list, up to the desired object
 	 */
 	objh = prevobjh = DH_NULL;
-	for (objix = 0 ; objix <= mediaix ; objix++) {
+	for (objix = 0; objix <= mediaix; objix++) {
 		prevobjh = objh;
 		if (objix == 0) {
 			objh = DH2S(strmh)->s_cldh;
@@ -5171,7 +5171,7 @@ pi_insertfile(ix_t drivecnt,
 	 * file list, up to the desired file
 	 */
 	fileh = DH_NULL;
-	for (fileix = 0 ; fileix <= dumpmediafileix ; fileix++) {
+	for (fileix = 0; fileix <= dumpmediafileix; fileix++) {
 		prevfileh = fileh;
 		if (fileix == 0) {
 			fileh = DH2O(objh)->o_cldh;
@@ -5516,7 +5516,7 @@ pi_transcribe(inv_session_t *sessp)
 	/* traverse inventory, transcribing into pers inv.
 	 */
 	strmcnt =  (size_t)sessp->s_nstreams;
-	for (strmix = 0 ; strmix < strmcnt ; strmix++) {
+	for (strmix = 0; strmix < strmcnt; strmix++) {
 		inv_stream_t *strmp;
 		size_t fileix;
 		size_t filecnt;
@@ -5535,7 +5535,7 @@ pi_transcribe(inv_session_t *sessp)
 		/* insert all media files from this stream. note that
 		 * the media object representation is inverted
 		 */
-		for (fileix = 0 ; fileix < filecnt ; fileix++) {
+		for (fileix = 0; fileix < filecnt; fileix++) {
 			inv_mediafile_t *filep;
 			bool_t fileszvalpr;
 
@@ -7579,7 +7579,7 @@ restore_extent_group(drive_t *drivep,
 
 	/* copy data extents from media to the file
 	 */
-	for (; ;) {
+	for (;;) {
 		/* read the extent header
 		 */
 		rv = read_extenthdr(drivep, &ehdr, ehcs);
@@ -8734,7 +8734,7 @@ restore_extattr(drive_t *drivep,
 
 	/* peel off extattrs until null hdr hit
 	 */
-	for (; ;) {
+	for (;;) {
 		size_t recsz;
 		/* REFERENCED */
 		int nread;
@@ -9274,7 +9274,7 @@ clr_mcflag(ix_t thrdix)
 {
 	lock();
 	mcflag[thrdix] = BOOL_FALSE;
-	for (thrdix = 0 ; thrdix < drivecnt ; thrdix++) {
+	for (thrdix = 0; thrdix < drivecnt; thrdix++) {
 		if (mcflag[thrdix]) {
 			unlock();
 			return;
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 5368664..cd9cad0 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -1114,7 +1114,7 @@ calcdixcum(dix_t dix)
 
 	nibcnt = (sizeof(dah_t) / HDLSUMCNT) - 1;
 	sum = 0;
-	for (nibix = 0 ; nibix < nibcnt ; nibix++) {
+	for (nibix = 0; nibix < nibcnt; nibix++) {
 		sum += (uint16_t)(dix & HDLSUMLOMASK);
 		dix >>= HDLSUMCNT;
 	}
diff --git a/restore/inomap.c b/restore/inomap.c
index 1b03779..868244b 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -527,11 +527,11 @@ inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
 
 	/* find the hunk/seg containing first ino or any ino beyond
 	 */
-	for (hnkp = roothnkp ; hnkp != 0 ; hnkp = hnkp->nextp) {
+	for (hnkp = roothnkp; hnkp != 0; hnkp = hnkp->nextp) {
 		if (firstino > hnkp->maxino) {
 			continue;
 		}
-		for (segp = hnkp->seg; segp < hnkp->seg + SEGPERHNK ; segp++){
+		for (segp = hnkp->seg; segp < hnkp->seg + SEGPERHNK; segp++){
 			if (hnkp == tailhnkp && segp > lastsegp) {
 				return BOOL_FALSE;
 			}
@@ -545,13 +545,13 @@ inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
 begin:
 	/* search until at least one ino is needed or until beyond last ino
 	 */
-	for (; ;) {
+	for (;;) {
 		xfs_ino_t ino;
 
 		if (segp->base > lastino) {
 			return BOOL_FALSE;
 		}
-		for (ino = segp->base ; ino < segp->base + INOPERSEG ; ino++){
+		for (ino = segp->base; ino < segp->base + INOPERSEG; ino++){
 			int state;
 			if (ino < firstino) {
 				continue;
diff --git a/restore/node.c b/restore/node.c
index f720730..cd9385c 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -513,7 +513,7 @@ node_alloc(void)
 		return NH_NULL;
 	}
 #ifdef NODECHK
-	node_map_internal(nh , (void **)&p);
+	node_map_internal(nh, (void **)&p);
 	if (p == NULL)
 		abort();
 	hkpp = p + (int)node_hdrp->nh_nodehkix;
diff --git a/restore/tree.c b/restore/tree.c
index 3f3084e..9806777 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1769,7 +1769,7 @@ tree_cb_links(xfs_ino_t ino,
 	/* loop through all hard links, attempting to restore/link
 	 */
 	path = path1;
-	for (nh = hardh ; nh != NH_NULL ; nh = link_nexth(nh)) {
+	for (nh = hardh; nh != NH_NULL; nh = link_nexth(nh)) {
 		node_t *np;
 		u_char_t flags;
 		char *reasonstr;
@@ -2811,7 +2811,7 @@ restart:
          * any selected directories and return */
 	if (cmdp == tsi_cmd_quit) {
 		mlog(MLOG_NORMAL, _("Unmark and quit\n"));
-		selsubtree(persp->p_rooth , BOOL_FALSE);
+		selsubtree(persp->p_rooth, BOOL_FALSE);
 	}
 
 	return BOOL_TRUE;
@@ -3149,7 +3149,7 @@ tsi_cmd_match(void)
 		return 0;
 	}
 
-	for (; tblp < tblendp ; tblp++) {
+	for (; tblp < tblendp; tblp++) {
 		if (! strncmp(tranp->t_inter.i_argv[0],
 				tblp->tct_pattern,
 				strlen(tranp->t_inter.i_argv[0]))) {
@@ -3187,7 +3187,7 @@ tsi_cmd_help(void *ctxp,
 				 sizeof(tsi_cmd_tbl[0]);
 
 	(* pcb )(pctxp, _("the following commands are available:\n"));
-	for (; tblp < tblendp ; tblp++) {
+	for (; tblp < tblendp; tblp++) {
 		(* pcb)(pctxp,
 			   "\t%s %s\n",
 			   tblp->tct_pattern,
@@ -3259,7 +3259,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 	 *	isdirpr - TRUE if named node is a directory;
 	 *	cldh - the first child in the named node's cld list.
 	 */
-	for (; ;) {
+	for (;;) {
 		size_t namelen;
 		char *strpatchp;
 		nh_t sibh;
@@ -4168,7 +4168,7 @@ hash_init(size64_t vmsz,
 
 	/* initialize the hash array to all NULL node handles
 	 */
-	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+	for (hix = 0; hix < (ix_t)hashlen; hix++) {
 		tranp->t_hashp[hix] = NH_NULL;
 	}
 
@@ -4374,7 +4374,7 @@ hash_iter(bool_t (* cbfp)(void *contextp, nh_t hashh), void *contextp)
 	ix_t hix;
 	size64_t hashlen = persp->p_hashsz / sizeof(nh_t);
 
-	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+	for (hix = 0; hix < (ix_t)hashlen; hix++) {
 		nh_t nh = tranp->t_hashp[hix];
 
 		while (nh != NH_NULL) {
@@ -4491,7 +4491,7 @@ tree_chk(void)
 
 	okaccum = BOOL_TRUE;
 
-	for (hix = 0 ; hix < (ix_t)hashlen ; hix++) {
+	for (hix = 0; hix < (ix_t)hashlen; hix++) {
 		nh_t hashh = tranp->t_hashp[hix];
 
 		mlog(MLOG_NITTY + 1 | MLOG_TREE,
@@ -4653,7 +4653,7 @@ parse(int slotcnt, char **slotbuf, char *string)
 	/* pass 1: collapse escape sequences, identifying characters which
 	 * are to be interpreted literally
 	 */
-	for (s = string, l = liter ; *s ; s++, l++) {
+	for (s = string, l = liter; *s; s++, l++) {
 		if (*s == '\\' && ! *l) {
 			fix_escape(s, l);
 		}
@@ -4662,7 +4662,7 @@ parse(int slotcnt, char **slotbuf, char *string)
 	/* pass 2: collapse quoted spans, identifying characters which
 	 * are to be interpreted literally
 	 */
-	for (s = string, l = liter ; *s ; s++, l++) {
+	for (s = string, l = liter; *s; s++, l++) {
 		if (*s == '\"' && ! *l) {
 			fix_quoted_span(s, l);
 		}
@@ -4670,7 +4670,7 @@ parse(int slotcnt, char **slotbuf, char *string)
 
 	/* pass 3: collapse white space spans into a single space
 	 */
-	for (s = string, l = liter ; *s ; s++, l++) {
+	for (s = string, l = liter; *s; s++, l++) {
 		if (is_white(*s) && ! *l) {
 			collapse_white(s, l);
 		}
@@ -4737,7 +4737,7 @@ fix_escape(char *string, char *liter)
 	endep = escape_table + (sizeof(escape_table)
 			         /
 			         sizeof(escape_table[0]));
-	for (; ep < endep ; ep++) {
+	for (; ep < endep; ep++) {
 		if (string[1] == ep->sequence) {
 			string[0] = ep->substitute;
 			liter[0] = (char)1;
@@ -4821,7 +4821,7 @@ fix_quoted_span(char *string, char *liter)
 	/* scan for the next non-literal quote, marking all
 	 * characters in between as literal
 	 */
-	for (s = string, l = liter ; *s && (*s != '\"' || *l) ; s++, l++) {
+	for (s = string, l = liter ; *s && (*s != '\"' || *l); s++, l++) {
 		*l = (char)1;
 	}
 
@@ -4839,7 +4839,7 @@ collapse_white(char *string, char *liter)
 	size_t cnt;
 
 	cnt = 0;
-	for (s = string, l = liter ; is_white(*s) && ! *l ; s++, l++) {
+	for (s = string, l = liter; is_white(*s) && ! *l; s++, l++) {
 		cnt++;
 	}
 
@@ -4856,7 +4856,7 @@ distance_to_space(char *s, char *l)
 {
 	size_t cnt;
 
-	for (cnt = 0 ; *s && (! is_white(*s) || *l) ; s++, l++) {
+	for (cnt = 0; *s && (! is_white(*s) || *l); s++, l++) {
 		cnt++;
 	}
 
-- 
2.21.0

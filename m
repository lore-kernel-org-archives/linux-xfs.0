Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57883 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbeKJAMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:43 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C029930841DE
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:52 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/24] xfsdump: (style) add a space after if, switch, for, do, while
Date: Fri,  9 Nov 2018 15:29:51 +0100
Message-Id: <20181109143004.24963-12-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

There should be a space in "if(" -> "if (", etc...

Created by this script:

#!/usr/bin/env bash
# add a space after some keywords: for, while, ... so we get 'for (' instead of 'for('

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/\(for\|while\|if\|switch\)(/\1 (/g" \
    -e "s/do{/do {/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/arch_xlate.c     |   2 +-
 common/drive_minrmt.c   |   8 +--
 common/drive_scsitape.c |  10 +--
 common/drive_simple.c   |   4 +-
 common/hsmapi.c         |   2 +-
 common/mlog.c           |   2 +-
 common/ring.c           |   2 +-
 common/util.c           |   2 +-
 dump/content.c          |  56 +++++++--------
 dump/inomap.c           |   2 +-
 inventory/inv_api.c     |   2 +-
 inventory/inv_mgr.c     |   4 +-
 inventory/inv_stobj.c   |   2 +-
 inventory/testmain.c    |   2 +-
 invutil/cmenu.c         | 106 +++++++++++++--------------
 invutil/fstab.c         |  72 +++++++++----------
 invutil/invidx.c        | 154 ++++++++++++++++++++--------------------
 invutil/invutil.c       |  28 ++++----
 invutil/list.c          |  34 ++++-----
 invutil/menu.c          |  70 +++++++++---------
 invutil/screen.c        |   6 +-
 invutil/stobj.c         |  82 ++++++++++-----------
 librmt/rmtopen.c        |   2 +-
 restore/content.c       |  34 ++++-----
 restore/inomap.c        |   8 +--
 25 files changed, 348 insertions(+), 348 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 46d525f..1844836 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -290,7 +290,7 @@ xlate_hnk(hnk_t *h1, hnk_t *h2, int dir)
 
 	mlog(MLOG_NITTY, "pre - xlate_hnk\n");
 
-	for(i = 0; i < SEGPERHNK; i++) {
+	for (i = 0; i < SEGPERHNK; i++) {
 		IXLATE(h1, h2, seg[i].base);
 		IXLATE(h1, h2, seg[i].lobits);
 		IXLATE(h1, h2, seg[i].mebits);
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 89d3f5e..01bbd74 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -1914,7 +1914,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
 		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 		last_rec_wrtn_wo_err = contextp->dc_msgp->rm_user;
-		switch(contextp->dc_msgp->rm_stat) {
+		switch (contextp->dc_msgp->rm_stat) {
 		case RING_STAT_OK:
 		case RING_STAT_INIT:
 			rval = 0;
@@ -2087,7 +2087,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
 				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
 				rval = 0;
@@ -2132,7 +2132,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
 			if (contextp->dc_msgp->rm_op == RING_OP_TRACE) {
 				break;
 			}
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
 				assert(rval == 0);
@@ -3719,7 +3719,7 @@ getrec(drive_t *drivep)
 			}
 		} else {
 			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 				contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 				break;
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 54a6797..79a21f2 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -2065,7 +2065,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
 		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 		last_rec_wrtn_wo_err = contextp->dc_msgp->rm_user;
-		switch(contextp->dc_msgp->rm_stat) {
+		switch (contextp->dc_msgp->rm_stat) {
 		case RING_STAT_OK:
 		case RING_STAT_INIT:
 			rval = 0;
@@ -2238,7 +2238,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
 				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
 				rval = 0;
@@ -2283,7 +2283,7 @@ do_end_write(drive_t *drivep, off64_t *ncommittedp)
 			if (contextp->dc_msgp->rm_op == RING_OP_TRACE) {
 				break;
 			}
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
 				assert(rval == 0);
@@ -2585,7 +2585,7 @@ do_bsf(drive_t *drivep, int count, int *statp)
 	/* finally, move to the right side of the file mark
 	 */
 	mtstat = fsf_and_verify(drivep);
-	if(IS_EOT(mtstat)) {
+	if (IS_EOT(mtstat)) {
 		*statp = DRIVE_ERROR_EOM;
 	}
 	if (! IS_FMK(mtstat)) {
@@ -4999,7 +4999,7 @@ getrec(drive_t *drivep)
 			}
 		} else {
 			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
-			switch(contextp->dc_msgp->rm_stat) {
+			switch (contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 				contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 				break;
diff --git a/common/drive_simple.c b/common/drive_simple.c
index f71a2cf..28e6e5b 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -309,7 +309,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
 			oflags = O_RDWR | O_CREAT;
 
 		} else {
-			switch(statbuf.st_mode & S_IFMT) {
+			switch (statbuf.st_mode & S_IFMT) {
 			case S_IFREG:
 				drivep->d_capabilities |= DRIVE_CAP_ERASE;
 				drivep->d_capabilities |= DRIVE_CAP_REWIND;
@@ -345,7 +345,7 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
 
 		}
 		oflags = O_RDONLY;
-		switch(statbuf.st_mode & S_IFMT) {
+		switch (statbuf.st_mode & S_IFMT) {
 		case S_IFREG:
 		case S_IFCHR:
 		case S_IFBLK:
diff --git a/common/hsmapi.c b/common/hsmapi.c
index e3e18a7..2762aa4 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -505,7 +505,7 @@ const	xfs_bstat_t	*statp)
 	if (dmfattrp->fsys != FSYS_TYPE_XFS)
 		return 0; /* unsupported filesystem version */
 
-	switch(dmfattrp->version) {
+	switch (dmfattrp->version) {
 	case DMF_ATTR_FORMAT_0:
 		if (dmf_f_ctxtp->attrlen != sizeof(XFSattrvalue0_t))
 			return 0; /* wrong size */
diff --git a/common/mlog.c b/common/mlog.c
index e09c16c..5dc8dd9 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -138,7 +138,7 @@ mlog_init0(void)
 	 */
 	mlog_streamcnt = 1;
 
-	for(i = 0; i < MLOG_SS_CNT; i++) {
+	for (i = 0; i < MLOG_SS_CNT; i++) {
 		mlog_level_ss[i] = MLOG_VERBOSE;
 	}
 }
diff --git a/common/ring.c b/common/ring.c
index faef34f..1b3b51b 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -427,7 +427,7 @@ ring_slave_entry(void *ringctxp)
 		msgp = ring_slave_get(ringp);
 		msgp->rm_rval = 0;
 
-		switch(msgp->rm_op) {
+		switch (msgp->rm_op) {
 		case RING_OP_READ:
 			if (loopmode == LOOPMODE_IGNORE) {
 				msgp->rm_stat = RING_STAT_IGNORE;
diff --git a/common/util.c b/common/util.c
index 7ca5fbe..6443489 100644
--- a/common/util.c
+++ b/common/util.c
@@ -187,7 +187,7 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 				      "ino %llu needed second bulkstat\n",
 				      p->bs_ino);
 
-				if(bigstat_one(fsfd, p->bs_ino, p) < 0) {
+				if (bigstat_one(fsfd, p->bs_ino, p) < 0) {
 				    mlog(MLOG_WARNING,
 					  _("failed to get bulkstat information for inode %llu\n"),
 					  p->bs_ino);
diff --git a/dump/content.c b/dump/content.c
index 0f46563..f351e78 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -831,16 +831,16 @@ content_init(int argc,
 	uuid_copy(cwhdrtemplatep->ch_fsid, fsid);
 
 	/* write quota information */
-	if(sc_savequotas) {
+	if (sc_savequotas) {
 
 		sc_savequotas = BOOL_FALSE;
-		for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
+		for (i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
 			quotas[i].savequotas = BOOL_FALSE;
 			qstat = getxfsqstat(fsdevice);
 			if (qstat > 0 && (qstat & quotas[i].statflag)) {
 				sprintf(quotas[i].quotapath, "%s/%s", mntpnt, quotas[i].quotafile);
-				if(save_quotas(mntpnt, &quotas[i])) {
-					if(subtreecnt) {
+				if (save_quotas(mntpnt, &quotas[i])) {
+					if (subtreecnt) {
 						subtreecnt++;
 						subtreep = (char **) realloc(subtreep,
 								subtreecnt * sizeof(char *));
@@ -1897,7 +1897,7 @@ content_statline(char **linespp[])
 				 "drive %u: ",
 				 (unsigned int)i);
 		}
-		switch(pdsp->pds_phase) {
+		switch (pdsp->pds_phase) {
 		case PDS_INOMAP:
 			strcat(statline[statlinecnt],
 				"dumping inomap");
@@ -2701,9 +2701,9 @@ content_complete(void)
 	      sc_stat_datadone);
 
 	if (completepr) {
-		if(sc_savequotas) {
-			for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
-				if(quotas[i].savequotas && unlink(quotas[i].quotapath) < 0) {
+		if (sc_savequotas) {
+			for (i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
+				if (quotas[i].savequotas && unlink(quotas[i].quotapath) < 0) {
 					mlog(MLOG_ERROR, _(
 					"unable to remove %s: %s\n"),
 					quotas[i].quotapath,
@@ -3857,7 +3857,7 @@ dump_file(void *arg1,
 
 	/* pass on to specific dump function
 	 */
-	switch(statp->bs_mode & S_IFMT) {
+	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:
 		/* ordinary file
 		 */
@@ -5046,7 +5046,7 @@ dump_extenthdr(drive_t *drivep,
 	rv_t rv;
 	char typestr[20];
 
-	switch(type)  {
+	switch (type)  {
 		case EXTENTHDR_TYPE_LAST:
 			strcpy(typestr, "LAST");
 			break;
@@ -5273,7 +5273,7 @@ dump_session_inv(drive_t *drivep,
 
 		partial = BOOL_FALSE;
 		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
-		switch(rv) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_TIMEOUT:
@@ -5331,7 +5331,7 @@ dump_session_inv(drive_t *drivep,
 				      mwhdrp,
 				      &ncommitted,
 				      partial);
-		switch(rv) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_EOM:
@@ -5419,7 +5419,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 
 		partial = BOOL_FALSE;
 		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
-		switch(rv) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_TIMEOUT:
@@ -5453,7 +5453,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 				      mwhdrp,
 				      &ncommitted,
 				      BOOL_FALSE);
-		switch(rv) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_EOM:
@@ -5663,7 +5663,7 @@ position:
 		 */
 		update_cc_Media_useterminatorpr(drivep, contextp);
 
-		switch(rval) {
+		switch (rval) {
 		case 0:
 			mlog_lock();
 			mlog(MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
@@ -5701,7 +5701,7 @@ position:
 			 */
 			(*dop->do_end_read)(drivep);
 
-			switch(Media_erasechk(drivep,
+			switch (Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
 						prevmediapresentpr)) {
@@ -5755,7 +5755,7 @@ position:
 			      "at beginning of media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
-			switch(Media_erasechk(drivep,
+			switch (Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
 						prevmediapresentpr)) {
@@ -5836,7 +5836,7 @@ position:
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 
-			switch(Media_erasechk(drivep,
+			switch (Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
 						prevmediapresentpr)) {
@@ -5864,7 +5864,7 @@ position:
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 			      "encountered EOM: media is full\n"));
 
-			switch(Media_erasechk(drivep,
+			switch (Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
 						prevmediapresentpr)) {
@@ -5889,7 +5889,7 @@ position:
 			      "assuming corrupted media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
-			switch(Media_erasechk(drivep,
+			switch (Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
 						prevmediapresentpr)) {
@@ -6150,7 +6150,7 @@ write:
 		return RV_INTR;
 	}
 	rval = (*dop->do_begin_write)(drivep);
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		return RV_OK;
 	case DRIVE_ERROR_EOM:
@@ -6194,7 +6194,7 @@ Media_mfile_end(drive_t *drivep,
 		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
 		return RV_EOM;
 	}
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		contextp->cc_Media_begin_entrystate = BES_ENDOK;
 		return RV_OK;
@@ -6601,7 +6601,7 @@ is_quota_file(ino_t ino)
 {
 	int i;
 
-	for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
+	for (i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
 		if (quotas[i].savequotas && ino == quotas[i].quotaino)
 			return BOOL_TRUE;
 	}
@@ -6622,11 +6622,11 @@ save_quotas(char *mntpnt, quota_info_t *quotainfo)
         mlog(MLOG_VERBOSE, _(
 		"saving %s information for: %s\n"), quotainfo->desc, mntpnt);
 
-        if(unlink(quotainfo->quotapath) == 0) {
+        if (unlink(quotainfo->quotapath) == 0) {
             mlog(MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
         }
         else {
-            if(errno != ENOENT) {
+            if (errno != ENOENT) {
                 mlog(MLOG_ERROR, _(
                       "unable to remove %s: %s\n"),
                       quotainfo->quotapath,
@@ -6645,20 +6645,20 @@ save_quotas(char *mntpnt, quota_info_t *quotainfo)
         mlog(MLOG_NITTY, "saving quotas: %s\n", buf);
 
         sts = system(buf);
-        if(sts != 0) {
+        if (sts != 0) {
             mlog(MLOG_ERROR, _(
                   "%s failed with exit status: %d\n"), REPQUOTA,
 		  sts == -1 ? -1 : WEXITSTATUS(sts));
             return BOOL_FALSE;
         }
-        if((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
+        if ((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
             mlog(MLOG_ERROR, _(
                   "open failed %s: %s\n"),
                   quotainfo->quotapath,
                   strerror(errno));
             return BOOL_FALSE;
         }
-        if(fstat(fd, &statb) < 0) {
+        if (fstat(fd, &statb) < 0) {
             mlog(MLOG_ERROR, _(
                   "stat failed %s: %s\n"),
                   quotainfo->quotapath,
diff --git a/dump/inomap.c b/dump/inomap.c
index b6acd3c..ca287d8 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -980,7 +980,7 @@ SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
-	switch(state) {
+	switch (state) {
 	case 0:
 		segp->lobits &= clrmask;
 		segp->mebits &= clrmask;
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 3a9cc5a..f34b92a 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -924,7 +924,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				if (value == NULL && d != OPT_FSTAB &&
 				     d != OPT_INVIDX && d != OPT_INVCHECK)
 					continue;
-				switch(d) {
+				switch (d) {
 					/* process mntpt option */
 				      case OPT_MNT:
 					bywhat = (inv_predicate_t) INV_BY_MOUNTPT;
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 7e73667..b2664ab 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -396,7 +396,7 @@ invmgr_inv_print(
 			continue;
 		}
 		free (scnt);
-		for(s = 0; s < nsess; s++) {
+		for (s = 0; s < nsess; s++) {
 			/* fd is kept locked until we return from the
 			   callback routine */
 
@@ -485,7 +485,7 @@ invmgr_inv_check(
 			       i+1,
 			       iarr[i].ie_timeperiod.tp_start,
 			       iarr[i].ie_timeperiod.tp_end);
-			for(s = 0; s < nsess; s++) {
+			for (s = 0; s < nsess; s++) {
 				printf(_("tm (%d)\t%d\n"), s, harr[s].sh_time);
 			}
 		}
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 2b86376..f86c978 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -75,7 +75,7 @@ stobj_insert_session(invt_idxinfo_t *idx,
 			return -1;
 		}
 
-		for(i = 0; i <  sescnt->ic_curnum; i++) {
+		for (i = 0; i <  sescnt->ic_curnum; i++) {
 			if (uuid_compare(sessions[i].s_sesid,
 					   s->ses->s_sesid) == 0)
 				break;
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 09b9bd6..273fe37 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -428,7 +428,7 @@ main(int argc, char *argv[])
 	optind = 1;
 	optarg = 0;
 
-	while((cc = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+	while ((cc = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 		switch (cc) {
 		      case 'w':
 			op = WRI;
diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index e60fd22..a1704ed 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -60,7 +60,7 @@ menukey_t keyv[] = {
 void
 signal_handler(int s)
 {
-    switch(s) {
+    switch (s) {
     case SIGWINCH:
 	signal(SIGWINCH, signal_handler);
 	delwin(mainmenu);
@@ -88,9 +88,9 @@ menu_commit(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
 
     n = list;
-    while(n != NULL && n->data != NULL) {
+    while (n != NULL && n->data != NULL) {
 	d = n->data;
-	if(d->ops != NULL && d->ops->op_commit != NULL && d->commited == BOOL_FALSE) {
+	if (d->ops != NULL && d->ops->op_commit != NULL && d->commited == BOOL_FALSE) {
 	    d->ops->op_commit(win, n, list);
 	    d->commited = BOOL_TRUE;
 	}
@@ -98,7 +98,7 @@ menu_commit(WINDOW *win, node_t *current, node_t *list)
     }
 
     n = list;
-    while(n != NULL) {
+    while (n != NULL) {
 	next = n->next;
 	node_free(list_del(n));
 	n = next;
@@ -110,7 +110,7 @@ menu_commit(WINDOW *win, node_t *current, node_t *list)
 node_t *
 get_lastnode(node_t *node)
 {
-    while(node->next != NULL) {
+    while (node->next != NULL) {
 	node = node->next;
     }
 
@@ -126,36 +126,36 @@ menu_import(WINDOW *win, node_t *current, node_t *list)
     char *fstabname;
     data_t *d;
 
-    for(;;) {
+    for (;;) {
 	inv_path[0] = '\0';
 
-	if(get_string(win, "Path to inventory to be imported: ", inv_path, MAXPATHLEN) == ERR) {
+	if (get_string(win, "Path to inventory to be imported: ", inv_path, MAXPATHLEN) == ERR) {
 	    put_error("Error: invalid input");
 	    continue;
 	}
-	if(strlen(inv_path) == 0) {
+	if (strlen(inv_path) == 0) {
 	    clear_line(stdscr, LINES - 1);
 	    return BOOL_FALSE;
 	}
-	if(stat(inv_path, &s) < 0 || !S_ISDIR(s.st_mode)) {
+	if (stat(inv_path, &s) < 0 || !S_ISDIR(s.st_mode)) {
 	    put_error("Error: invalid path");
 	    continue;
 	}
 	clear_line(stdscr, LINES - 1);
 
 	fstabname = GetFstabFullPath(inv_path);
-	if(fstabname == NULL) {
+	if (fstabname == NULL) {
 	    put_footer("internal memory error: import inventory", ALIGN_LEFT);
 	    exit(1);
 	}
 
-	while(current->next != NULL) {
+	while (current->next != NULL) {
 	    current = current->next;
 	}
 	generate_fstab_menu(inv_path, current, 0, fstabname);
 	free(fstabname);
 
-	while(current->next != NULL) {
+	while (current->next != NULL) {
 	    current = current->next;
 	    d = current->data;
 	    d->text[1] = 'I';
@@ -182,12 +182,12 @@ menu_select(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = (data_t *)(current->data);
 
-    if(d->ops != NULL && d->ops->op_select != NULL) {
+    if (d->ops != NULL && d->ops->op_select != NULL) {
 	return d->ops->op_select(win, current, list);
     }
 
@@ -201,14 +201,14 @@ expand_node(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return NULL;
     }
     d = node->data;
 
     d->expanded = BOOL_TRUE;
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	((data_t *)(d->children[i]->data))->hidden = BOOL_FALSE;
     }
 
@@ -220,12 +220,12 @@ menu_expand(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = current->data;
 
-    if(d->ops != NULL && d->ops->op_expand != NULL) {
+    if (d->ops != NULL && d->ops->op_expand != NULL) {
 	return d->ops->op_expand(win, current, list);
     }
 
@@ -242,7 +242,7 @@ expand_tree(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return NULL;
     }
     d = node->data;
@@ -250,7 +250,7 @@ expand_tree(node_t *node)
     d->hidden = BOOL_FALSE;
     d->expanded = BOOL_TRUE;
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	expand_tree(d->children[i]);
     }
 
@@ -262,12 +262,12 @@ menu_expandall(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = (data_t *)(current->data);
 
-    if(d->ops != NULL && d->ops->op_expandall != NULL) {
+    if (d->ops != NULL && d->ops->op_expandall != NULL) {
 	return d->ops->op_expandall(win, current, list);
     }
 
@@ -284,17 +284,17 @@ collapse_node(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return NULL;
     }
     d = node->data;
 
-    if(d->expanded == BOOL_FALSE)
+    if (d->expanded == BOOL_FALSE)
 	return node;
 
     d->expanded = BOOL_FALSE;
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	((data_t *)(d->children[i]->data))->hidden = BOOL_TRUE;
 	collapse_node(d->children[i]);
     }
@@ -307,12 +307,12 @@ menu_collapse(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = current->data;
 
-    if(d->ops != NULL && d->ops->op_collapse != NULL) {
+    if (d->ops != NULL && d->ops->op_collapse != NULL) {
 	return d->ops->op_collapse(win, current, list);
     }
 
@@ -329,17 +329,17 @@ menu_collapseall(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     node_t *n;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = current->data;
 
-    if(d->ops != NULL && d->ops->op_collapseall != NULL) {
+    if (d->ops != NULL && d->ops->op_collapseall != NULL) {
 	return d->ops->op_collapseall(win, current, list);
     }
 
     n = current;
-    while(d->parent != NULL) {
+    while (d->parent != NULL) {
 	n = d->parent;
 	d = n->data;
     }
@@ -356,12 +356,12 @@ menu_delete(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = (data_t *)(current->data);
 
-    if(d->ops != NULL && d->ops->op_delete != NULL) {
+    if (d->ops != NULL && d->ops->op_delete != NULL) {
 	return d->ops->op_delete(win, current, list);
     }
 
@@ -376,12 +376,12 @@ menu_undelete(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
     d = (data_t *)(current->data);
 
-    if(d->ops != NULL && d->ops->op_undelete != NULL) {
+    if (d->ops != NULL && d->ops->op_undelete != NULL) {
 	return d->ops->op_undelete(win, current, list);
     }
 
@@ -397,12 +397,12 @@ menu_saveexit(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_TRUE;
     }
     d = (data_t *)(current->data);
 
-    if(d->ops != NULL && d->ops->op_saveexit != NULL) {
+    if (d->ops != NULL && d->ops->op_saveexit != NULL) {
 	return d->ops->op_saveexit(win, current, list);
     }
 
@@ -415,7 +415,7 @@ delete_node(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return NULL;
     }
     d = node->data;
@@ -423,7 +423,7 @@ delete_node(node_t *node)
     d->deleted = BOOL_TRUE;
     d->text[0] = 'D';
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	delete_node(d->children[i]);
     }
 
@@ -434,7 +434,7 @@ delete_node(node_t *node)
 int
 list_delete(node_t *current, node_t *list)
 {
-    if(current == NULL && current->data == NULL) {
+    if (current == NULL && current->data == NULL) {
 	return 0;
     }
 
@@ -448,7 +448,7 @@ undelete_node(node_t *node)
 {
     data_t *d;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return NULL;
     }
     d = node->data;
@@ -456,7 +456,7 @@ undelete_node(node_t *node)
     d->deleted = BOOL_FALSE;
     d->text[0] = ' ';
 
-    if(d->parent != NULL) {
+    if (d->parent != NULL) {
 	undelete_node(d->parent);
     }
 
@@ -467,7 +467,7 @@ undelete_node(node_t *node)
 void
 list_undelete(node_t *current, node_t *list)
 {
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return;
     }
 
@@ -481,12 +481,12 @@ list_prune(node_t *menulist, char *mountpt, uuid_t *uuidp, time32_t prunetime)
     data_t *d;
 
     n = menulist;
-    while(n != NULL) {
+    while (n != NULL) {
 	d = (data_t *)(n->data);
 
-	if(d != NULL && d->ops != NULL && d->ops->op_prune != NULL) {
-	    if(d->ops->op_prune(mountpt, uuidp, prunetime, n, menulist) == BOOL_TRUE) {
-		if(d->ops->op_delete == NULL) {
+	if (d != NULL && d->ops != NULL && d->ops->op_prune != NULL) {
+	    if (d->ops->op_prune(mountpt, uuidp, prunetime, n, menulist) == BOOL_TRUE) {
+		if (d->ops->op_delete == NULL) {
 		    list_delete(n, menulist);
 		}
 		else {
@@ -494,7 +494,7 @@ list_prune(node_t *menulist, char *mountpt, uuid_t *uuidp, time32_t prunetime)
 		}
 	    }
 	    else {
-		if(d->ops->op_undelete == NULL) {
+		if (d->ops->op_undelete == NULL) {
 		    list_undelete(n, menulist);
 		}
 		else {
@@ -515,7 +515,7 @@ generate_menu(char *inv_path)
     node_t *list;
 
     fstabname = GetFstabFullPath(inv_path);
-    if(fstabname == NULL) {
+    if (fstabname == NULL) {
 	fprintf(stderr, "%s: internal memory error: general_menu\n",
 		g_programName);
 	exit(1);
@@ -538,7 +538,7 @@ create_windows()
     keypad(stdscr, TRUE);
     signal(SIGWINCH, signal_handler);
 
-    if(LINES < 7) {
+    if (LINES < 7) {
 	endwin();
 	fprintf(stderr, "%s: window too small for curses interactive mode: LINES = %d\n",
 		g_programName, LINES);
@@ -550,7 +550,7 @@ create_windows()
     notimeout(mainmenu, TRUE);
 
     menusize = (LINES - 2) - INFO_SIZE;
-    if(menusize <= 0)
+    if (menusize <= 0)
 	menusize = 1;
 
     prefresh(mainmenu,
@@ -559,7 +559,7 @@ create_windows()
 	     menusize, COLS - 1);
 
     infosize = INFO_SIZE;
-    if(infosize <= 0)
+    if (infosize <= 0)
 	infosize = 1;
 
     infowin = newwin(infosize, COLS, menusize + 1, 0);
@@ -576,12 +576,12 @@ invutil_interactive(char *inv_path, char *mountpt, uuid_t *uuidp, time32_t timeS
     node_t	*menulist;
 
     menulist = generate_menu(inv_path);
-    if(menulist == NULL) {
+    if (menulist == NULL) {
 	fprintf(stderr, "%s: abnormal termination\n", g_programName);
 	exit(1);
     }
 
-    if(timeSecs > 0) {
+    if (timeSecs > 0) {
 	list_prune(menulist, mountpt, uuidp, timeSecs);
     }
 
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 88d849e..3dcb9bf 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -68,15 +68,15 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
     int fstabentry_idx;
 
     n = current;
-    if(n == NULL || n->data == NULL)
+    if (n == NULL || n->data == NULL)
 	return 0;
 
     d = ((data_t *)(n->data));
     fidx = d->file_idx;
     fstabentry = fstab_file[fidx].data[d->data_idx];
 
-    if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
-	for(i = 0; i < d->nbr_children; i++) {
+    if (d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
+	for (i = 0; i < d->nbr_children; i++) {
 	    invidx_commit(win, d->children[i], list);
 	}
 	mark_all_children_commited(current);
@@ -90,26 +90,26 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 
 	    fstab_file[fidx].data[d->data_idx] = NULL;
 
-	    for(i = d->data_idx + 1; i < fstab_file[fidx].numrecords; i++) {
-		if(fstab_file[fidx].data[i] != NULL)
+	    for (i = d->data_idx + 1; i < fstab_file[fidx].numrecords; i++) {
+		if (fstab_file[fidx].data[i] != NULL)
 		    fstab_file[fidx].data[i]--;
 	    }
 	}
 	fstab_file[fidx].counter->ic_curnum--;
     }
-    else if(d->imported == BOOL_TRUE) {
+    else if (d->imported == BOOL_TRUE) {
 	invt_fstab_t *dest;
 
-	for(i = 0; i < d->nbr_children; i++) {
+	for (i = 0; i < d->nbr_children; i++) {
 	    invidx_commit(win, d->children[i], list);
 	}
 	mark_all_children_commited(current);
 
-	if(find_matching_fstab(0, fstabentry) >= 0) {
+	if (find_matching_fstab(0, fstabentry) >= 0) {
 	    return 0;
 	}
 
-	if(fstab_file[0].counter->ic_curnum < fstab_file[0].nEntries) {
+	if (fstab_file[0].counter->ic_curnum < fstab_file[0].nEntries) {
 	    dest = fstab_file[0].data[fstab_file[0].counter->ic_curnum - 1] + 1;
 	}
 	else {
@@ -133,12 +133,12 @@ fstab_select(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
 
-    if(d->expanded == TRUE) {
+    if (d->expanded == TRUE) {
 	return menu_collapse(win, current, list);
     }
 
@@ -154,7 +154,7 @@ fstab_highlight(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_fstab_t *fstabentry;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -181,17 +181,17 @@ fstab_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node
     data_t		*d;
     invt_fstab_t	*fstabentry;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return BOOL_FALSE;
     }
 
     d = (data_t *)(node->data);
     fstabentry = fstab_file[d->file_idx].data[d->data_idx];
 
-    if(mountpt != NULL && mntpnt_equal(mountpt, fstabentry->ft_mountpt)) {
+    if (mountpt != NULL && mntpnt_equal(mountpt, fstabentry->ft_mountpt)) {
 	return BOOL_TRUE;
     }
-    if((!uuid_is_null(*uuidp))
+    if ((!uuid_is_null(*uuidp))
        && (uuid_compare(*uuidp, fstabentry->ft_uuid) == 0)) {
 	return BOOL_TRUE;
     }
@@ -202,9 +202,9 @@ fstab_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node
 int
 add_fstab_data(int fidx, invt_fstab_t *data)
 {
-    if(fstab_file[fidx].numrecords == 0) {
+    if (fstab_file[fidx].numrecords == 0) {
 	fstab_file[fidx].data = malloc(sizeof(*fstab_file[fidx].data));
-	if(fstab_file[fidx].data == NULL) {
+	if (fstab_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: fstab data allocation\n", g_programName);
 	    exit(1);
 	}
@@ -213,7 +213,7 @@ add_fstab_data(int fidx, invt_fstab_t *data)
 	fstab_file[fidx].data = realloc(fstab_file[fidx].data,
 					sizeof(*fstab_file[fidx].data)
 					* (fstab_file[fidx].numrecords + 1));
-	if(fstab_file[fidx].data == NULL) {
+	if (fstab_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: fstab data reallocation\n", g_programName);
 	    exit(1);
 	}
@@ -236,16 +236,16 @@ generate_fstab_menu(char * inv_path, node_t *startnode, int level, char *fstabna
     node_t	*n;
     invt_fstab_t *fstab_entry;
 
-    if((idx = open_fstab(fstabname)) < 0) {
+    if ((idx = open_fstab(fstabname)) < 0) {
 	return NULL;
     }
     fstab_entry = (invt_fstab_t *)(fstab_file[idx].mapaddr + sizeof(invt_counter_t));
 
     n = startnode;
-    for(i=0; i < fstab_file[idx].counter->ic_curnum; i++) {
+    for (i=0; i < fstab_file[idx].counter->ic_curnum; i++) {
 	len = strlen(fstab_entry[i].ft_mountpt) + strlen(fstab_entry[i].ft_devpath) + 40;
 	txt = malloc(len);
-	if(txt == NULL) {
+	if (txt == NULL) {
 	    fprintf(stderr, "%s: internal memory error: fstab_text\n", g_programName);
 	    exit(1);
 	}
@@ -262,10 +262,10 @@ generate_fstab_menu(char * inv_path, node_t *startnode, int level, char *fstabna
 				    NULL,	/* children */
 				    0,		/* nbr_children */
 				    i));	/* data_idx */
-	if(i == 0) {
+	if (i == 0) {
 	    list = n;
 	}
-	if(n == NULL) {
+	if (n == NULL) {
 	    fprintf(stderr, "%s: internal memory error: list_add: node_create: fstab\n", g_programName);
 	    exit(1);
 	}
@@ -284,19 +284,19 @@ add_fstab(char *name, int fd, int nEntries, char *mapaddr, invt_counter_t *count
 {
     static int highwatermark = 10;
 
-    if(fstab_numfiles == 0) {
+    if (fstab_numfiles == 0) {
 	fstab_file = malloc(sizeof(*fstab_file) * highwatermark);
-	if(fstab_file == NULL) {
+	if (fstab_file == NULL) {
 	    fprintf(stderr, "%s: internal memory error: malloc fstab_file\n", g_programName);
 	    exit(1);
 	}
     }
     else {
-	if(fstab_numfiles >= highwatermark - 1) {
+	if (fstab_numfiles >= highwatermark - 1) {
 	    highwatermark += highwatermark;
 
 	    fstab_file = realloc(fstab_file, sizeof(*fstab_file) * highwatermark);
-	    if(fstab_file == NULL) {
+	    if (fstab_file == NULL) {
 		fprintf(stderr, "%s: internal memory error: realloc fstab\n", g_programName);
 		exit(1);
 	    }
@@ -319,13 +319,13 @@ add_fstab(char *name, int fd, int nEntries, char *mapaddr, invt_counter_t *count
 int
 fstab_equal(invt_fstab_t *f1, invt_fstab_t *f2)
 {
-    if(strcmp(f1->ft_mountpt, f2->ft_mountpt) != 0)
+    if (strcmp(f1->ft_mountpt, f2->ft_mountpt) != 0)
 	return BOOL_FALSE;
 
-    if(strcmp(f1->ft_devpath, f2->ft_devpath) != 0)
+    if (strcmp(f1->ft_devpath, f2->ft_devpath) != 0)
 	return BOOL_FALSE;
 
-    if(uuid_compare(f1->ft_uuid, f2->ft_uuid) != 0)
+    if (uuid_compare(f1->ft_uuid, f2->ft_uuid) != 0)
 	return BOOL_FALSE;
 
     return BOOL_TRUE;
@@ -336,8 +336,8 @@ find_matching_fstab(int fidx, invt_fstab_t *fstabentry)
 {
     int i;
 
-    for(i = 0; i < fstab_file[fidx].numrecords; i++) {
-	if(fstab_equal(fstab_file[fidx].data[i], fstabentry) == BOOL_TRUE) {
+    for (i = 0; i < fstab_file[fidx].numrecords; i++) {
+	if (fstab_equal(fstab_file[fidx].data[i], fstabentry) == BOOL_TRUE) {
 	    return i;
 	}
     }
@@ -374,8 +374,8 @@ remmap_fstab(int fidx, int num)
 
     /* regenerate the data index for the file given the new mapping */
     fstab_entry = (invt_fstab_t *)(fstab_file[fidx].mapaddr + sizeof(invt_counter_t));
-    for(i=0; i < nEntries; i++) {
-    	if(i >= fstab_file[fidx].numrecords) {
+    for (i=0; i < nEntries; i++) {
+    	if (i >= fstab_file[fidx].numrecords) {
 	    add_fstab_data(fidx, &(fstab_entry[i]));
 	}
 	else {
@@ -402,7 +402,7 @@ open_fstab(char *fstabname)
     }
 
     name = strdup(fstabname);
-    if(name == NULL) {
+    if (name == NULL) {
 	fprintf(stderr, "%s: internal memory error:  strdup fstabname\n", g_programName);
 	exit(1);
     }
@@ -451,7 +451,7 @@ close_all_fstab()
 {
     int i;
 
-    for(i = 0; i < fstab_numfiles; i++) {
+    for (i = 0; i < fstab_numfiles; i++) {
 	close_fstab(i);
     }
 
diff --git a/invutil/invidx.c b/invutil/invidx.c
index c8caa48..e723110 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -77,7 +77,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
     invt_entry_t *inv_entry;
 
     n = current;
-    if(n == NULL || n->data == NULL)
+    if (n == NULL || n->data == NULL)
 	return 0;
 
     d = ((data_t *)(n->data));
@@ -87,9 +87,9 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
     idx = (int)(((long)inv_entry - (long)invidx_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_entry_t));
 
 
-    if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
+    if (d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
 	/* shortcut - just close and unlink stobj files */
-	for(i = 0; i < d->nbr_children; i++) {
+	for (i = 0; i < d->nbr_children; i++) {
 	    close_stobj_file(((data_t *)(d->children[i]->data))->file_idx, BOOL_TRUE);
 	}
 	mark_all_children_commited(current);
@@ -100,14 +100,14 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		    (sizeof(invt_entry_t) * (invidx_file[fidx].counter->ic_curnum - idx - 1)));
 
 	    invidx_file[fidx].data[idx]=NULL;
-	    for(i = idx + 1; i < invidx_file[fidx].numrecords; i++) {
-		if(invidx_file[fidx].data[i] != NULL)
+	    for (i = idx + 1; i < invidx_file[fidx].numrecords; i++) {
+		if (invidx_file[fidx].data[i] != NULL)
 		    invidx_file[fidx].data[i]--;
 	    }
 	}
 	invidx_file[fidx].counter->ic_curnum--;
     }
-    else if(d->imported == BOOL_TRUE) {
+    else if (d->imported == BOOL_TRUE) {
 	int dst_fileidx;
 	int dst_invpos;
 	int dst_invidx;
@@ -120,10 +120,10 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	snprintf(dst_idxfile, sizeof(dst_idxfile), "%s/%s", inventory_path, basename(invidx_file[fidx].name));
 
 	/* append if we have the target open already, else write to a possibly new file */
-	if((dst_fileidx = find_matching_invidxfile(dst_idxfile)) >= 0) {
+	if ((dst_fileidx = find_matching_invidxfile(dst_idxfile)) >= 0) {
 	    invt_entry_t *dest = NULL;
 
-	    if((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0) {
+	    if ((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0) {
 	    	char *stobj_filename = NULL;
 		int stobj_fd = -1;
 		int stobj_fileidx;
@@ -140,7 +140,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		last_dst_invidx = -1;
 		i = d->nbr_children - 1;
 		do {
-		    if(dst_invidx != last_dst_invidx) {
+		    if (dst_invidx != last_dst_invidx) {
 			stobj_fileidx = find_matching_stobjfile(invidx_file[dst_fileidx].data[dst_invidx]->ie_filename);
 			stobj_filename = stobj_file[stobj_fileidx].name;
 			stobj_fd = stobj_file[stobj_fileidx].fd;
@@ -167,10 +167,10 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 
 		    free(hdr); free(ses); free(strms); free(mfiles);
 
-		    if(--i < 0)
+		    if (--i < 0)
 		    	break;
 		}
-		while((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0);
+		while ((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0);
 
 		mark_all_children_commited(current);
 
@@ -178,13 +178,13 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		/* find node for dst_fileidx */
 		dst_n = find_invidx_node(list, dst_fileidx);
 		tmp_parent = ((data_t *)(dst_n->data))->parent;
-		while(dst_n != NULL) {
+		while (dst_n != NULL) {
 		    node_t *tmp_n1;
 
 		    dst_d = dst_n->data;
 
 		    /* close affected invidx file and stobj files */
-		    for(i = 0; i < dst_d->nbr_children; i++) {
+		    for (i = 0; i < dst_d->nbr_children; i++) {
 		        close_stobj_file(((data_t *)(dst_d->children[i]->data))->file_idx, BOOL_FALSE);
 		    }
 
@@ -199,7 +199,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		/* generate invidx menu for the parent node */
 		dst_n = generate_invidx_menu(inventory_path, tmp_parent, 1, dst_idxfile);
 
-		if(dst_n != tmp_parent) {
+		if (dst_n != tmp_parent) {
 		    /* mark all its children commited */
 		    mark_all_children_commited(dst_n);
 		}
@@ -208,12 +208,12 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	    }
 	    else {
 		/* insert new invidx entry, and copy over stobj file */
-		if(invidx_file[dst_fileidx].counter->ic_curnum >= invidx_file[dst_fileidx].nEntries) {
+		if (invidx_file[dst_fileidx].counter->ic_curnum >= invidx_file[dst_fileidx].nEntries) {
 		    dest = remmap_invidx(dst_fileidx, 1);
 		}
 
 		dst_invpos = find_invidx_insert_pos(dst_fileidx, inv_entry);
-		if(dst_invpos >= 0) {
+		if (dst_invpos >= 0) {
 		    memmove(invidx_file[dst_fileidx].data[dst_invpos + 1],
 			    invidx_file[dst_fileidx].data[dst_invpos],
 			    sizeof(*inv_entry) * (invidx_file[dst_fileidx].counter->ic_curnum - dst_invpos));
@@ -232,15 +232,15 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 
 		/* shortcut - just copy stobj file over */
 		stobjfile = get_inventry_stobjfile(d);
-		if(stobjfile == NULL) {
+		if (stobjfile == NULL) {
 		    put_error("Error: unable to work out stobj filename");
 		    return 0;
 		}
 
 		snprintf(dst_stobjfile, sizeof(dst_stobjfile), "%s/%s", inventory_path, basename(stobjfile));
 
-		if(stat(dst_stobjfile, &s) < 0) {
-		    if(errno != ENOENT) {
+		if (stat(dst_stobjfile, &s) < 0) {
+		    if (errno != ENOENT) {
 			put_error("Error: unable to copy stobj file: stat error");
 			return 0;
 		    }
@@ -251,7 +251,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 		}
 
 		snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
-		if(system(cmd) != 0) {
+		if (system(cmd) != 0) {
 		    put_error("Error: unable to copy stobj file: cp failed");
 		    return 0;
 		}
@@ -272,8 +272,8 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 
 	    mark_all_children_commited(current);
 
-	    if(stat(dst_idxfile, &s) < 0) {
-		if(errno != ENOENT) {
+	    if (stat(dst_idxfile, &s) < 0) {
+		if (errno != ENOENT) {
 		    put_error("Error: unable to stat inventory index file");
 		    return 0;
 		}
@@ -284,7 +284,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	    }
 
 	    new_fd = open(dst_idxfile, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR);
-	    if(new_fd < 0) {
+	    if (new_fd < 0) {
 		put_error("Error: unable to open inventory index file");
 		return 0;
 	    }
@@ -302,15 +302,15 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 
 	    /* shortcut - just copy stobj file over */
 	    stobjfile = get_inventry_stobjfile(d);
-	    if(stobjfile == NULL) {
+	    if (stobjfile == NULL) {
 		put_error("Error: unable to work out stobj filename");
 		return 0;
 	    }
 
 	    snprintf(dst_stobjfile, sizeof(dst_stobjfile), "%s/%s", inventory_path, basename(stobjfile));
 
-	    if(stat(dst_stobjfile, &s) < 0) {
-		if(errno != ENOENT) {
+	    if (stat(dst_stobjfile, &s) < 0) {
+		if (errno != ENOENT) {
 		    put_error("Error: unable to copy stobj file: stat error");
 		    return 0;
 		}
@@ -321,7 +321,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	    }
 
 	    snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
-	    if(system(cmd) != 0) {
+	    if (system(cmd) != 0) {
 		put_error("Error: unable to copy stobj file: cp failed");
 		return 0;
 	    }
@@ -369,17 +369,17 @@ read_stobj_info(int fd, int idx, invt_seshdr_t **out_hdr,
     ses = malloc(sizeof(*ses));
     read_n_bytes(fd, (char *)ses, sizeof(*ses), "stobj file");
 
-    if(ses->s_cur_nstreams > 0) {
+    if (ses->s_cur_nstreams > 0) {
 	lseek(fd, hdr->sh_streams_off, SEEK_SET);
 	strms = malloc(sizeof(*strms) * ses->s_cur_nstreams);
 	read_n_bytes(fd, (char *)strms, sizeof(*strms) * ses->s_cur_nstreams, "stobj file");
 
 	nmfiles = 0;
-	for(i = 0; i < ses->s_cur_nstreams; i++) {
+	for (i = 0; i < ses->s_cur_nstreams; i++) {
 	    nmfiles += strms[i].st_nmediafiles;
 	}
 
-	if(nmfiles > 0) {
+	if (nmfiles > 0) {
 	    mfiles = malloc(sizeof(*mfiles) * nmfiles);
 	    read_n_bytes(fd, (char *)mfiles, sizeof(*mfiles) * nmfiles, "stobj file");
 	}
@@ -435,9 +435,9 @@ find_stobj_insert_point(int fd, invt_seshdr_t *hdr)
     lseek(fd, 0, SEEK_SET);
     read_n_bytes(fd, (char *)&sescnt, sizeof(sescnt), "stobj file");
 
-    for(i = 0; i < sescnt.ic_curnum; i++) {
+    for (i = 0; i < sescnt.ic_curnum; i++) {
 	read_n_bytes(fd, (char *)&tmphdr, sizeof(tmphdr), "stobj file");
-	if(hdr->sh_time <= tmphdr.sh_time) {
+	if (hdr->sh_time <= tmphdr.sh_time) {
 	    break;
 	}
     }
@@ -477,10 +477,10 @@ update_invidx_entry(int fd, char *filename, int stobj_fd)
     lseek(fd, 0, SEEK_SET);
     read_n_bytes(fd, &cnt, sizeof(cnt), "invidx file");
 
-    for(i = 0; i < cnt.ic_curnum; i++) {
+    for (i = 0; i < cnt.ic_curnum; i++) {
     	lseek(fd, IDX_HDR_OFFSET(i), SEEK_SET);
 	read_n_bytes(fd, &entry, sizeof(entry), "invidx file");
-	if(strcmp(entry.ie_filename, filename) == 0) {
+	if (strcmp(entry.ie_filename, filename) == 0) {
 	    entry.ie_timeperiod.tp_start = start_time;
 	    entry.ie_timeperiod.tp_end = end_time;
 	    lseek(fd, IDX_HDR_OFFSET(i), SEEK_SET);
@@ -513,7 +513,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,
     char *buf;
     int invidx_fd = invidx_file[invidx_fileidx].fd;
 
-    if(hdr == NULL || ses == NULL || strms == NULL || mfiles == NULL)
+    if (hdr == NULL || ses == NULL || strms == NULL || mfiles == NULL)
 	return 0;
 
     lseek(fd, 0, SEEK_SET);
@@ -522,7 +522,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,
     pos = find_stobj_insert_point(fd, hdr);
 
     /* if stobj file is full, we need to split it */
-    if(sescnt.ic_curnum >= sescnt.ic_maxnum) {
+    if (sescnt.ic_curnum >= sescnt.ic_maxnum) {
 	int new_fd;
 	char new_filename[INV_STRLEN];
 	invt_seshdr_t *s_hdr;
@@ -532,7 +532,7 @@ insert_stobj_into_stobjfile(int invidx_fileidx, char *filename, int fd,
 
 	new_fd = create_stobjfile(invidx_fileidx, new_filename, sizeof(new_filename), hdr, ses, strms, mfiles);
 
-	for(i = pos; i < sescnt.ic_curnum; i++) {
+	for (i = pos; i < sescnt.ic_curnum; i++) {
 	    read_stobj_info(fd, i, &s_hdr, &s_ses, &s_strms, &s_mfiles);
 
 	    insert_stobj_into_stobjfile(invidx_fileidx, new_filename, new_fd, s_hdr, s_ses, s_strms, s_mfiles);
@@ -672,12 +672,12 @@ invidx_select(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
 
-    if(d->expanded == TRUE) {
+    if (d->expanded == TRUE) {
 	return menu_collapse(win, current, list);
     }
 
@@ -692,7 +692,7 @@ invidx_highlight(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_entry_t *invtentry;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -723,7 +723,7 @@ invidx_undelete(WINDOW *win, node_t *current, node_t *list)
     node_t *n;
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
 
@@ -731,7 +731,7 @@ invidx_undelete(WINDOW *win, node_t *current, node_t *list)
 
     d = ((data_t *)(current->data));
     n = current->next;
-    while(n != NULL && n->data != NULL && ((data_t *)(n->data))->level > d->level) {
+    while (n != NULL && n->data != NULL && ((data_t *)(n->data))->level > d->level) {
 	((data_t *)(n->data))->deleted = BOOL_FALSE;
 	((data_t *)(n->data))->text[0] = ' ';
 	n = n->next;
@@ -749,17 +749,17 @@ invidx_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, nod
     data_t *d;
     invt_entry_t *invidx_entry;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return BOOL_FALSE;
     }
     d = ((data_t *)(node->data));
 
     invidx_entry = invidx_file[d->file_idx].data[d->data_idx];
-    if(invidx_entry == NULL) {
+    if (invidx_entry == NULL) {
 	return BOOL_FALSE;
     }
 
-    if(invidx_entry->ie_timeperiod.tp_start < prunetime) {
+    if (invidx_entry->ie_timeperiod.tp_start < prunetime) {
 	return BOOL_TRUE;
     }
 
@@ -773,11 +773,11 @@ find_invidx_node(node_t *list, int inv_fileidx)
     data_t *d;
 
     n = list;
-    while(n != NULL && n->data != NULL) {
+    while (n != NULL && n->data != NULL) {
     	d = n->data;
 	/* is this an invidx entry we're looking at? */
-	if(d->ops == &invidx_ops) {
-	    if(d->file_idx == inv_fileidx) {
+	if (d->ops == &invidx_ops) {
+	    if (d->file_idx == inv_fileidx) {
 	    	return n;
 	    }
 	}
@@ -792,7 +792,7 @@ get_inventry_stobjfile(data_t *d)
 {
     data_t *child_data;
 
-    if(d->nbr_children <= 0) {
+    if (d->nbr_children <= 0) {
 	return NULL;
     }
 
@@ -810,9 +810,9 @@ find_overlapping_invidx(int fidx, invt_entry_t *inv_entry)
     int i = 0;
     invt_entry_t *entry;
 
-    for(i = 0; i < invidx_file[fidx].numrecords; i++) {
+    for (i = 0; i < invidx_file[fidx].numrecords; i++) {
 	entry = invidx_file[fidx].data[i];
-	if(entry->ie_timeperiod.tp_end < inv_entry->ie_timeperiod.tp_start
+	if (entry->ie_timeperiod.tp_end < inv_entry->ie_timeperiod.tp_start
 	   || entry->ie_timeperiod.tp_start > inv_entry->ie_timeperiod.tp_end) {
 	    continue;
 	}
@@ -829,11 +829,11 @@ find_invidx_insert_pos(int fidx, invt_entry_t *inv_entry)
     invt_entry_t *entry;
     invt_entry_t *next_entry;
 
-    for(i = 0; i < invidx_file[fidx].numrecords - 1; i++) {
+    for (i = 0; i < invidx_file[fidx].numrecords - 1; i++) {
 	entry = invidx_file[fidx].data[i];
 	next_entry = invidx_file[fidx].data[i+1];
 
-	if(inv_entry->ie_timeperiod.tp_start > entry->ie_timeperiod.tp_end
+	if (inv_entry->ie_timeperiod.tp_start > entry->ie_timeperiod.tp_end
 	   && inv_entry->ie_timeperiod.tp_end < next_entry->ie_timeperiod.tp_start) {
 	    return i;
 	}
@@ -847,10 +847,10 @@ find_matching_stobjfile(char *filename)
 {
     int i = 0;
 
-    for(i = 0; i < stobj_numfiles; i++) {
-	if(stobj_file[i].name == NULL)
+    for (i = 0; i < stobj_numfiles; i++) {
+	if (stobj_file[i].name == NULL)
 	    continue;
-	if(strcmp(stobj_file[i].name, filename) == 0) {
+	if (strcmp(stobj_file[i].name, filename) == 0) {
 	    return i;
 	}
     }
@@ -863,10 +863,10 @@ find_matching_invidxfile(char *filename)
 {
     int i = 0;
 
-    for(i = 0; i < invidx_numfiles; i++) {
-	if(invidx_file[i].name == NULL)
+    for (i = 0; i < invidx_numfiles; i++) {
+	if (invidx_file[i].name == NULL)
 	    continue;
-	if(strcmp(invidx_file[i].name, filename) == 0) {
+	if (strcmp(invidx_file[i].name, filename) == 0) {
 	    return i;
 	}
     }
@@ -877,9 +877,9 @@ find_matching_invidxfile(char *filename)
 int
 add_invidx_data(int fidx, invt_entry_t *data)
 {
-    if(invidx_file[fidx].numrecords == 0) {
+    if (invidx_file[fidx].numrecords == 0) {
 	invidx_file[fidx].data = malloc(sizeof(*invidx_file[fidx].data));
-	if(invidx_file[fidx].data == NULL) {
+	if (invidx_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: invidx data allocation\n",
 		    g_programName);
 	    exit(1);
@@ -889,7 +889,7 @@ add_invidx_data(int fidx, invt_entry_t *data)
 	invidx_file[fidx].data = realloc(invidx_file[fidx].data,
 					 sizeof(*invidx_file[fidx].data)
 					 * (invidx_file[fidx].numrecords + 1));
-	if(invidx_file[fidx].data == NULL) {
+	if (invidx_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: invidx data reallocation\n",
 		    g_programName);
 	    exit(1);
@@ -912,7 +912,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
     invt_entry_t	*invidx_entry;
     char		*stobjname;
 
-    if((idx = open_invidx(idxFileName)) < 0) {
+    if ((idx = open_invidx(idxFileName)) < 0) {
 	return startnode;
     }
 
@@ -922,7 +922,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
     for (i=0; i < invidx_file[idx].counter->ic_curnum; i++) {
 	len = strlen(invidx_entry[i].ie_filename) + 54;
 	txt = malloc(len);
-	if(txt == NULL) {
+	if (txt == NULL) {
 	    fprintf(stderr, "%s: internal memory error: invidx_text\n", g_programName);
 	    exit(1);
 	}
@@ -939,7 +939,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
 				    NULL,	/* children */
 				    0,		/* nbr_children */
 				    i));	/* data_idx */
-	if(n == NULL) {
+	if (n == NULL) {
 	    fprintf(stderr, "%s: internal memory error: list_add: node_create: invidx\n",
 		    g_programName);
 	    exit(1);
@@ -959,19 +959,19 @@ add_invidx(char *name, int fd, int nEntries, char *mapaddr, invt_counter_t *coun
 {
     static int highwatermark = 10;
 
-    if(invidx_numfiles == 0) {
+    if (invidx_numfiles == 0) {
 	invidx_file = malloc(sizeof(*invidx_file) * highwatermark);
-	if(invidx_file == NULL) {
+	if (invidx_file == NULL) {
 	    fprintf(stderr, "%s: internal memory error: malloc invidx_file\n", g_programName);
 	    exit(1);
 	}
     }
     else {
-	if(invidx_numfiles >= highwatermark - 1) {
+	if (invidx_numfiles >= highwatermark - 1) {
 	    highwatermark += highwatermark;
 
 	    invidx_file = realloc(invidx_file, sizeof(*invidx_file) * highwatermark);
-	    if(invidx_file == NULL) {
+	    if (invidx_file == NULL) {
 		fprintf(stderr, "%s: internal memory error: realloc invidx\n", g_programName);
 		exit(1);
 	    }
@@ -1020,8 +1020,8 @@ remmap_invidx(int fidx, int num)
 
     /* regenerate the data index for the file given the new mapping */
     inv_entry = (invt_entry_t *)(invidx_file[fidx].mapaddr + sizeof(invt_counter_t));
-    for(i=0; i < nEntries; i++) {
-    	if(i >= invidx_file[fidx].numrecords) {
+    for (i=0; i < nEntries; i++) {
+    	if (i >= invidx_file[fidx].numrecords) {
 	    add_invidx_data(fidx, &(inv_entry[i]));
 	}
 	else {
@@ -1048,7 +1048,7 @@ open_invidx(char *idxFileName)
     }
 
     name = strdup(idxFileName);
-    if(name == NULL) {
+    if (name == NULL) {
 	fprintf(stderr, "%s: internal memory error:  strdup idxFileName\n", g_programName);
 	exit(1);
     }
@@ -1071,21 +1071,21 @@ close_invidx(int idx)
 {
     int nEntries;
 
-    if(idx >= invidx_numfiles || invidx_file[idx].fd < 0)
+    if (idx >= invidx_numfiles || invidx_file[idx].fd < 0)
 	return 0;
 
     nEntries = invidx_file[idx].counter->ic_curnum;
     munmap(invidx_file[idx].mapaddr,
 	    (invidx_file[idx].nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
-    if(nEntries != 0 && nEntries != invidx_file[idx].nEntries) {
+    if (nEntries != 0 && nEntries != invidx_file[idx].nEntries) {
 	ftruncate(invidx_file[idx].fd,
 		  sizeof(invt_counter_t) + (nEntries * sizeof(invt_entry_t)));
     }
 
     close(invidx_file[idx].fd);
 
-    if(nEntries == 0) {
+    if (nEntries == 0) {
 	unlink(invidx_file[idx].name);
     }
     free(invidx_file[idx].name);
@@ -1103,8 +1103,8 @@ close_all_invidx()
 {
     int i;
 
-    for(i = 0; i < invidx_numfiles; i++) {
-	if(invidx_file[i].fd < 0)
+    for (i = 0; i < invidx_numfiles; i++) {
+	if (invidx_file[i].fd < 0)
 	    continue;
 	close_invidx(i);
     }
diff --git a/invutil/invutil.c b/invutil/invutil.c
index a744d58..26fb630 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -78,8 +78,8 @@ main(int argc, char *argv[])
     uuid_clear(uuid);
     uuid_clear(session);
 
-    while((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
-	switch(c) {
+    while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+	switch (c) {
 	case GETOPT_DEBUG:
 	    debug = BOOL_TRUE;
 	    break;
@@ -297,7 +297,7 @@ get_mntpnt(char *txt)
     char *p;
 
     p = strchr(txt, ':');
-    if(p == NULL)
+    if (p == NULL)
         return txt;
 
     return p+1;
@@ -306,7 +306,7 @@ get_mntpnt(char *txt)
 int
 mntpnt_equal(char *s1, char *s2)
 {
-    if(strchr(s1, ':') == NULL || strchr(s2, ':') == NULL) {
+    if (strchr(s1, ':') == NULL || strchr(s2, ':') == NULL) {
         s1 = get_mntpnt(s1);
         s2 = get_mntpnt(s2);
     }
@@ -520,16 +520,16 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 #endif
 
 	    if (checkonly == BOOL_FALSE) {
-		if(mountPt != NULL && strcmp(mountPt, fstabentry[i].ft_mountpt) == 0) {
+		if (mountPt != NULL && strcmp(mountPt, fstabentry[i].ft_mountpt) == 0) {
 		    printf("     Match on hostname and path\n");
 		    IdxCheckOnly = BOOL_FALSE;
 		}
-		else if((!uuid_is_null(*uuidp))
+		else if ((!uuid_is_null(*uuidp))
 		   && (uuid_compare(*uuidp, fstabentry[i].ft_uuid) == 0)) {
 		    printf("     Match on UUID only\n");
 		    IdxCheckOnly = BOOL_FALSE;
 		}
-		else if(mountPt != NULL && mntpnt_equal(mountPt, fstabentry[i].ft_mountpt)) {
+		else if (mountPt != NULL && mntpnt_equal(mountPt, fstabentry[i].ft_mountpt)) {
 		    printf("     Match on directory name only: %s\n", mountPt);
 		    IdxCheckOnly = BOOL_FALSE;
 		}
@@ -570,7 +570,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	    (nEntries*sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
     if ((fstabEntries != 0)  && (fstabEntries != nEntries)) {
-	if(debug) {
+	if (debug) {
 	    printf("ftruncate fstab from %d to %d (%ld bytes)\n",
 		   nEntries,
 		   fstabEntries,
@@ -585,7 +585,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 
     if (fstabEntries == 0)
     {
-	if(debug) {
+	if (debug) {
 	    printf("unlink fstab file %s\n", fstabname);
 	}
 	unlink(fstabname);
@@ -676,7 +676,7 @@ CheckAndPruneInvIndexFile(bool_t checkonly,
     munmap(temp, (nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
     if ((validEntries != 0)  && (validEntries != nEntries)) {
-	if(debug) {
+	if (debug) {
 	    printf("ftruncate idx from %d to %d (%ld bytes)\n",
 		   nEntries,
 		   validEntries,
@@ -697,7 +697,7 @@ CheckAndPruneInvIndexFile(bool_t checkonly,
 
     if (validEntries == 0)
     {
-	if(debug) {
+	if (debug) {
 	    printf("unlink idx file %s\n", idxFileName);
 	}
 	unlink(idxFileName);
@@ -844,7 +844,7 @@ CheckAndPruneStObjFile(bool_t checkonly,
 
 	    uuid_unparse(StObjses->s_sesid, str);
 
-	    if(force) {
+	    if (force) {
 		printf("-------------------------------------------------\n");
 		printf("Pruning this matching entry:\n");
 		printf("UUID\t\t:\t%s\nMOUNT POINT\t:\t%s\n"
@@ -994,7 +994,7 @@ inv_DEBUG_lock_str(int c)
     };
 
     for (i = 0; lockinfo[i].str; i++) {
-	if(lockinfo[i].cmd == c) {
+	if (lockinfo[i].cmd == c) {
 	    return lockinfo[i].str;
 	}
     }
@@ -1088,7 +1088,7 @@ open_and_lock(char * path, Open_t open_type, uint lock_wait_flag)
     if (debug) {
 	char    *lstr;
 
-	switch(lock_mode) {
+	switch (lock_mode) {
 	case LOCK_EX: lstr = inv_DEBUG_lock_str(lock_mode); break;
 	default:       lstr = "NO_LOCK";
 	}
diff --git a/invutil/list.c b/invutil/list.c
index 46fb291..f8e1b07 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -28,7 +28,7 @@ parent_add_child(node_t *parent, node_t *child)
 {
     data_t *d;
 
-    if(parent == NULL || child == NULL)
+    if (parent == NULL || child == NULL)
 	return parent;
 
     d = parent->data;
@@ -48,11 +48,11 @@ node_create(int hidden, int expanded, int level, int deleted, int file_idx, char
     data_t *newdata;
 
     newnode = malloc(sizeof(*newnode));
-    if(newnode == NULL)
+    if (newnode == NULL)
 	return NULL;
 
     newdata = malloc(sizeof(*newdata));
-    if(newdata == NULL)
+    if (newdata == NULL)
 	return NULL;
 
     newdata->hidden = hidden;
@@ -69,7 +69,7 @@ node_create(int hidden, int expanded, int level, int deleted, int file_idx, char
     newdata->commited = BOOL_FALSE;
     newdata->imported = BOOL_FALSE;
 
-    if(deleted == BOOL_TRUE) {
+    if (deleted == BOOL_TRUE) {
 	newdata->text[0] = 'D';
     }
 
@@ -83,9 +83,9 @@ node_create(int hidden, int expanded, int level, int deleted, int file_idx, char
 void
 node_free(node_t *node)
 {
-    if(node != NULL) {
-	if(node->data != NULL) {
-	    if(((data_t *)(node->data))->text != NULL) {
+    if (node != NULL) {
+	if (node->data != NULL) {
+	    if (((data_t *)(node->data))->text != NULL) {
 	        free(((data_t *)(node->data))->text);
 	        free(((data_t *)(node->data))->children);
 	    }
@@ -98,15 +98,15 @@ node_free(node_t *node)
 node_t *
 list_add(node_t *prevnode, node_t *newnode)
 {
-    if(newnode == NULL)
+    if (newnode == NULL)
 	return NULL;
 
-    if(prevnode != NULL) {
+    if (prevnode != NULL) {
 	newnode->next = prevnode->next;
 	prevnode->next = newnode;
 
 	newnode->prev = prevnode;
-	if(newnode->next != NULL) {
+	if (newnode->next != NULL) {
 	    newnode->next->prev = newnode;
 	}
     }
@@ -115,7 +115,7 @@ list_add(node_t *prevnode, node_t *newnode)
 	newnode->prev = NULL;
     }
 
-    if(((data_t *)(newnode->data))->parent != NULL) {
+    if (((data_t *)(newnode->data))->parent != NULL) {
 	parent_add_child(((data_t *)(newnode->data))->parent, newnode);
     }
 
@@ -125,10 +125,10 @@ list_add(node_t *prevnode, node_t *newnode)
 node_t *
 list_del(node_t *node)
 {
-    if(node->prev != NULL) {
+    if (node->prev != NULL) {
 	node->prev->next = node->next;
     }
-    if(node->next != NULL) {
+    if (node->next != NULL) {
 	node->next->prev = node->prev;
     }
     node->next = NULL;
@@ -143,12 +143,12 @@ free_all_children(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL)
+    if (node == NULL || node->data == NULL)
 	return NULL;
 
     d = (data_t *)(node->data);
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	node_free(list_del(free_all_children(d->children[i])));
     }
     d->children = NULL;
@@ -164,12 +164,12 @@ mark_all_children_commited(node_t *node)
     int i;
     data_t *d;
 
-    if(node == NULL || node->data == NULL)
+    if (node == NULL || node->data == NULL)
 	return NULL;
 
     d = (data_t *)(node->data);
 
-    for(i = 0; i < d->nbr_children; i++) {
+    for (i = 0; i < d->nbr_children; i++) {
 	mark_all_children_commited(d->children[i]);
     }
     d->commited = BOOL_TRUE;
diff --git a/invutil/menu.c b/invutil/menu.c
index 81baa42..c167bf1 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -36,13 +36,13 @@ put_all_options(WINDOW *win, node_t *list, node_t *current)
 
     i = 0;
     node = list;
-    while(node != NULL) {
+    while (node != NULL) {
 	d = ((data_t *)(node->data));
-	if(d->hidden == BOOL_TRUE) {
+	if (d->hidden == BOOL_TRUE) {
 	    node = node->next;
 	    continue;
 	}
-	if(node == current) {
+	if (node == current) {
 	    attr = A_REVERSE;
         }
         else {
@@ -65,7 +65,7 @@ put_helpscreen(int keyc, menukey_t *keyv)
     WINDOW *helpscreen;
 
     winline = LINES - (keyc + 5);
-    if(winline < 0)
+    if (winline < 0)
 	winline = 0;
 
     helpscreen = newwin(keyc + 4, 29, winline, COLS - 30);
@@ -78,8 +78,8 @@ put_helpscreen(int keyc, menukey_t *keyv)
     wmove(helpscreen, 2, 0);
     waddstr(helpscreen, "|                           |");
     l = 3;
-    for(k = 0; k < keyc + 1; k++) {
-	if(keyv[k].text == NULL)
+    for (k = 0; k < keyc + 1; k++) {
+	if (keyv[k].text == NULL)
 	    continue;
 	wmove(helpscreen, l, 0);
 	waddstr(helpscreen, keyv[k].text);
@@ -117,17 +117,17 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
     redraw_screen = BOOL_TRUE;
 
     quit = BOOL_FALSE;
-    while(quit != BOOL_TRUE) {
-	if(current == NULL && current->data == NULL) {
+    while (quit != BOOL_TRUE) {
+	if (current == NULL && current->data == NULL) {
 	    current = list;
 	}
 	d = (data_t *)(current->data);
 
-	if(redraw_screen == BOOL_TRUE) {
+	if (redraw_screen == BOOL_TRUE) {
 	    wclear(win);
 	    snprintf(txt, sizeof(txt), "%s: %s", g_programName, g_programVersion);
 	    put_header(txt, ALIGN_LEFT);
-	    if(d->hidden == BOOL_TRUE) {
+	    if (d->hidden == BOOL_TRUE) {
 		current = list;
 		current_line = 0;
 		d = (data_t *)(current->data);
@@ -135,7 +135,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 	    put_all_options(win, list, current);
 	    redraw_screen = BOOL_FALSE;
 
-	    if(d->ops != NULL && d->ops->op_highlight != NULL) {
+	    if (d->ops != NULL && d->ops->op_highlight != NULL) {
 		quit = d->ops->op_highlight(win, current, list);
 	    }
 	}
@@ -145,11 +145,11 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 
 	    redraw_options = BOOL_FALSE;
 
-	    if(((data_t *)(last->data))->ops != NULL
+	    if (((data_t *)(last->data))->ops != NULL
 	       && ((data_t *)(last->data))->ops->op_unhighlight != NULL) {
 		quit = ((data_t *)(last->data))->ops->op_unhighlight(win, current, list);
 	    }
-	    if(d->ops != NULL && d->ops->op_highlight != NULL) {
+	    if (d->ops != NULL && d->ops->op_highlight != NULL) {
 		quit = d->ops->op_highlight(win, current, list);
 	    }
 	}
@@ -165,11 +165,11 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		 line, col,
 		 size, COLS - 1);
 
-	if(quit == BOOL_TRUE)
+	if (quit == BOOL_TRUE)
 	    continue;
 
 	c=wgetch(win);
-	switch(c) {
+	switch (c) {
         case '?':
 	case KEY_F(1):
 	    /* online help */
@@ -183,18 +183,18 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		data_t *d;
 		node_t *n = current->prev;
 
-		while(n != NULL) {
+		while (n != NULL) {
 		    d = ((data_t *)(n->data));
-		    if(d == NULL) {
+		    if (d == NULL) {
 			n = n->prev;
 			continue;
 		    }
-		    if(d->hidden == BOOL_FALSE) {
+		    if (d->hidden == BOOL_FALSE) {
 			break;
 		    }
 		    n = n->prev;
 		}
-		if(n != NULL) {
+		if (n != NULL) {
 		    current = n;
 		    current_line--;
 		}
@@ -207,18 +207,18 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		data_t *d;
 		node_t *n = current->next;
 
-		while(n != NULL) {
+		while (n != NULL) {
 		    d = ((data_t *)(n->data));
-		    if(d == NULL) {
+		    if (d == NULL) {
 			n = n->next;
 			continue;
 		    }
-		    if(d->hidden == BOOL_FALSE) {
+		    if (d->hidden == BOOL_FALSE) {
 			break;
 		    }
 		    n = n->next;
 		}
-		if(n != NULL) {
+		if (n != NULL) {
 		    current = n;
 		    current_line++;
 		}
@@ -231,12 +231,12 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		node_t *n = current->next;
 		int l;
 
-		if(current != NULL && ((data_t *)(current->data)) == NULL) {
+		if (current != NULL && ((data_t *)(current->data)) == NULL) {
 		    break;
 		}
 		l = ((data_t *)(current->data))->level;
-		if(n != NULL && ((data_t *)(n->data)) != NULL && ((data_t *)(n->data))->level > l) {
-		    if(((data_t *)(n->data))->hidden == BOOL_TRUE) {
+		if (n != NULL && ((data_t *)(n->data)) != NULL && ((data_t *)(n->data))->level > l) {
+		    if (((data_t *)(n->data))->hidden == BOOL_TRUE) {
 			menu_expand(win, current, list);
 		    }
 		    current = n;
@@ -253,41 +253,41 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		int l = 0;
 		int i;
 
-		if(current != NULL && ((data_t *)(current->data)) != NULL) {
+		if (current != NULL && ((data_t *)(current->data)) != NULL) {
 		    l = ((data_t *)(current->data))->level;
 		}
 		i = current_line - 1;
-		while(n != NULL) {
+		while (n != NULL) {
 		    d = ((data_t *)(n->data));
-		    if(d == NULL) {
+		    if (d == NULL) {
 			n = n->prev;
 			continue;
 		    }
-		    if(d->hidden == BOOL_TRUE) {
+		    if (d->hidden == BOOL_TRUE) {
 			n = n->prev;
 			continue;
 		    }
-		    if(d->level < l) {
+		    if (d->level < l) {
 			break;
 		    }
 		    n = n->prev;
 		    i--;
 		}
-		if(n != NULL) {
+		if (n != NULL) {
 		    current = n;
 		    current_line = i;;
 		}
 	    }
 	    break;
 	case ERR:
-	    if(errno == EINTR) {
+	    if (errno == EINTR) {
 		/* mainmenu window has been recreated - use new one */
 		win = mainmenu;
 	    }
 	    break;
 	default:
-	    for(k = 0; k < keyc; k++) {
-		if(c == keyv[k].key || tolower(c) == keyv[k].key) {
+	    for (k = 0; k < keyc; k++) {
+		if (c == keyv[k].key || tolower(c) == keyv[k].key) {
 		    if (keyv[k].fn != NULL) {
 			quit = keyv[k].fn(win, current, list);
 			break;
diff --git a/invutil/screen.c b/invutil/screen.c
index 5e478c9..923552a 100644
--- a/invutil/screen.c
+++ b/invutil/screen.c
@@ -36,14 +36,14 @@ put_line(WINDOW *win, int line, char *msg, int attr, alignment_t alignment)
 
     cols = getmaxx(win);
     cols--;
-    if(cols > 255) {
+    if (cols > 255) {
 	cols = 255;
     }
     msglen = strlen(msg);
-    if(msglen > cols)
+    if (msglen > cols)
 	msglen = cols;
 
-    switch(alignment) {
+    switch (alignment) {
     case ALIGN_CENTRE:
 	c = (cols - msglen) / 2;
 	break;
diff --git a/invutil/stobj.c b/invutil/stobj.c
index 2912e0c..2931ddc 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -92,7 +92,7 @@ stobjmed_commit(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -106,7 +106,7 @@ stobjstrm_commit(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -120,7 +120,7 @@ stobjmed_delete(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -134,7 +134,7 @@ stobjstrm_delete(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -149,7 +149,7 @@ stobjsess_commit(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_seshdr_t *stobjhdr;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -157,7 +157,7 @@ stobjsess_commit(WINDOW *win, node_t *current, node_t *list)
 
     mark_all_children_commited(current);
 
-    if(d->deleted == BOOL_TRUE) {
+    if (d->deleted == BOOL_TRUE) {
 	stobjhdr->sh_pruned = 1;
     }
     else {
@@ -177,7 +177,7 @@ stobjsess_highlight(WINDOW *win, node_t *current, node_t *list)
     invt_seshdr_t *stobjhdr;
     invt_session_t *stobjses;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -214,7 +214,7 @@ stobjstrm_highlight(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_stream_t *stobjstrm;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -251,7 +251,7 @@ stobjmed_highlight(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_mediafile_t *stobjmed;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
@@ -284,12 +284,12 @@ stobj_select(WINDOW *win, node_t *current, node_t *list)
 {
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return 0;
     }
     d = (data_t *)(current->data);
 
-    if(d->expanded == TRUE) {
+    if (d->expanded == TRUE) {
 	return menu_collapse(win, current, list);
     }
 
@@ -305,7 +305,7 @@ stobj_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node
     invt_seshdr_t *stobj_header;
     invt_session_t *stobj_session;
 
-    if(node == NULL || node->data == NULL) {
+    if (node == NULL || node->data == NULL) {
 	return BOOL_FALSE;
     }
     d = (data_t *)(node->data);
@@ -313,17 +313,17 @@ stobj_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node
     stobj_header = stobj->header;
     stobj_session = stobj->session;
 
-    if(stobj_header == NULL || stobj_session == NULL) {
+    if (stobj_header == NULL || stobj_session == NULL) {
 	return BOOL_FALSE;
     }
-    if(stobj_header->sh_pruned) {
+    if (stobj_header->sh_pruned) {
 	return BOOL_TRUE;
     }
-    if(stobj_header->sh_time < prunetime) {
-	if(mountpt != NULL && mntpnt_equal(mountpt, stobj_session->s_mountpt)) {
+    if (stobj_header->sh_time < prunetime) {
+	if (mountpt != NULL && mntpnt_equal(mountpt, stobj_session->s_mountpt)) {
 	    return BOOL_TRUE;
 	}
-	if((!uuid_is_null(*uuidp))
+	if ((!uuid_is_null(*uuidp))
 	   && (uuid_compare(*uuidp, stobj_session->s_fsid) == 0)) {
 	    return BOOL_TRUE;
 	}
@@ -339,7 +339,7 @@ stobj_undelete(WINDOW *win, node_t *current, node_t *list)
     node_t *n;
     data_t *d;
 
-    if(current == NULL || current->data == NULL) {
+    if (current == NULL || current->data == NULL) {
 	return BOOL_FALSE;
     }
 
@@ -347,7 +347,7 @@ stobj_undelete(WINDOW *win, node_t *current, node_t *list)
 
     d = ((data_t *)(current->data));
     n = current->next;
-    while(n != NULL && n->data != NULL && ((data_t *)(n->data))->level > d->level) {
+    while (n != NULL && n->data != NULL && ((data_t *)(n->data))->level > d->level) {
 	((data_t *)(n->data))->deleted = BOOL_FALSE;
 	((data_t *)(n->data))->text[0] = ' ';
 	n = n->next;
@@ -361,9 +361,9 @@ stobj_undelete(WINDOW *win, node_t *current, node_t *list)
 int
 add_stobj_data(int fidx, void *data)
 {
-    if(stobj_file[fidx].numrecords == 0) {
+    if (stobj_file[fidx].numrecords == 0) {
 	stobj_file[fidx].data = malloc(sizeof(*stobj_file[fidx].data));
-	if(stobj_file[fidx].data == NULL) {
+	if (stobj_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: stobj data allocation\n",
 		    g_programName);
 	    exit(1);
@@ -373,7 +373,7 @@ add_stobj_data(int fidx, void *data)
 	stobj_file[fidx].data = realloc(stobj_file[fidx].data,
 					sizeof(*stobj_file[fidx].data)
 					* (stobj_file[fidx].numrecords + 1));
-	if(stobj_file[fidx].data == NULL) {
+	if (stobj_file[fidx].data == NULL) {
 	    fprintf(stderr, "%s: internal memory error: stobj data reallocation\n",
 		    g_programName);
 	    exit(1);
@@ -405,7 +405,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
     invt_stream_t	*StObjstrm;
     invt_mediafile_t	*StObjmed;
 
-    if((idx = open_stobj(StObjFileName)) < 0) {
+    if ((idx = open_stobj(StObjFileName)) < 0) {
 	return startnode;
     }
 
@@ -416,7 +416,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
     n = startnode;
     for (i=0; i < stobj_file[idx].counter->ic_curnum;) {
 	session = malloc(sizeof(*session));
-	if(session == NULL) {
+	if (session == NULL) {
 	    fprintf(stderr, "%s: internal memory error: session malloc\n", g_programName);
 	    exit(1);
 	}
@@ -425,7 +425,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 
 	len = 60+strlen(session->session->s_label);
 	txt = malloc(len);
-	if(txt == NULL) {
+	if (txt == NULL) {
 	    fprintf(stderr, "%s: internal memory error: invidx_text\n", g_programName);
 	    exit(1);
 	}
@@ -444,7 +444,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 				    NULL,	/* children */
 				    0,		/* nbr_children */
 				    data_idx));
-	if(n == NULL) {
+	if (n == NULL) {
 	    fprintf(stderr, "%s: internal memory error: list_add: node_create: session\n", g_programName);
 	    exit(1);
 	}
@@ -460,7 +460,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 
 	    len = strlen(StObjstrm->st_cmdarg) + 33;
 	    txt = malloc(len);
-	    if(txt == NULL) {
+	    if (txt == NULL) {
 		fprintf(stderr, "%s: internal memory error: invidx_text\n", g_programName);
 		exit(1);
 	    }
@@ -477,7 +477,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 					NULL,		/* children */
 					0,		/* nbr_children */
 					data_idx));
-	    if(n == NULL) {
+	    if (n == NULL) {
 		fprintf(stderr, "%s: internal memory error: list_add: node_create: StObjstrm\n", g_programName);
 		exit(1);
 	    }
@@ -493,7 +493,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 
 		len = strlen(StObjmed->mf_label) + 26;
 		txt = malloc(len);
-		if(txt == NULL) {
+		if (txt == NULL) {
 		    fprintf(stderr, "%s: internal memory error: invidx_text\n", g_programName);
 		    exit(1);
 		}
@@ -510,7 +510,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 					    NULL,	/* children */
 					    0,		/* nbr_children */
 					    data_idx));
-		if(n == NULL) {
+		if (n == NULL) {
 		    fprintf(stderr, "%s: internal memory error: list_add: node_create: StObjmed\n", g_programName);
 		    exit(1);
 		}
@@ -535,19 +535,19 @@ add_stobj(char *name, int fd, off_t size, char *mapaddr, invt_sescounter_t *coun
 {
     static int highwatermark = 20;
 
-    if(stobj_numfiles == 0) {
+    if (stobj_numfiles == 0) {
 	stobj_file     = malloc(sizeof(*stobj_file) * highwatermark);
-	if(stobj_file == NULL) {
+	if (stobj_file == NULL) {
 	    fprintf(stderr, "%s: internal memory error: malloc stobj_file\n", g_programName);
 	    exit(1);
 	}
     }
     else {
-	if(stobj_numfiles >= highwatermark - 1) {
+	if (stobj_numfiles >= highwatermark - 1) {
 	    highwatermark += highwatermark;
 
 	    stobj_file = realloc(stobj_file, sizeof(*stobj_file) * highwatermark);
-	    if(stobj_file == NULL) {
+	    if (stobj_file == NULL) {
 		fprintf(stderr, "%s: internal memory error: realloc stobj_file\n", g_programName);
 		exit(1);
 	    }
@@ -596,7 +596,7 @@ open_stobj(char *StObjFileName)
     mapaddr = mmap_n_bytes(fd, size, BOOL_FALSE, StObjFileName);
 
     name = strdup(StObjFileName);
-    if(name == NULL) {
+    if (name == NULL) {
 	fprintf(stderr, "%s: internal memory error: strdup stobj_name\n", g_programName);
 	exit(1);
     }
@@ -607,14 +607,14 @@ open_stobj(char *StObjFileName)
 int
 close_stobj_file(int fidx, int unlink_ok)
 {
-    if(fidx >= stobj_numfiles || stobj_file[fidx].fd < 0)
+    if (fidx >= stobj_numfiles || stobj_file[fidx].fd < 0)
 	return 0;
 
     munmap(stobj_file[fidx].mapaddr, stobj_file[fidx].size);
     close(stobj_file[fidx].fd);
     stobj_file[fidx].fd = -1;
 
-    if(unlink_ok == BOOL_TRUE) {
+    if (unlink_ok == BOOL_TRUE) {
 	unlink(stobj_file[fidx].name);
     }
 
@@ -635,15 +635,15 @@ close_all_stobj()
     invt_seshdr_t *StObjhdr;
     int unlink_ok;
 
-    for(i = 0; i < stobj_numfiles; i++) {
+    for (i = 0; i < stobj_numfiles; i++) {
 
-	if(stobj_file[i].fd < 0)
+	if (stobj_file[i].fd < 0)
 	    continue;
 
 	unlink_ok = BOOL_TRUE;
 	StObjhdr = (invt_seshdr_t *)(stobj_file[i].mapaddr + sizeof(invt_sescounter_t));
-	for(j = 0; j < stobj_file[i].counter->ic_curnum;) {
-	    if(StObjhdr->sh_pruned != 1) {
+	for (j = 0; j < stobj_file[i].counter->ic_curnum;) {
+	    if (StObjhdr->sh_pruned != 1) {
 		unlink_ok = BOOL_FALSE;
 		break;
 	    }
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 2f46324..ea6e218 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -197,7 +197,7 @@ static int _rmt_open (char *path, int oflag, int mode)
 		    uname[len-1] = '\0'; /* chomp the '\n' */
 	    }
 
-	    for(p = &uname_table[0]; p->name != 0; p++) {
+	    for (p = &uname_table[0]; p->name != 0; p++) {
 		if (strncmp(p->name, uname, strlen(p->name)) == 0)
 		    break;
 	    }
diff --git a/restore/content.c b/restore/content.c
index 5b45906..b616eda 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -1812,7 +1812,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		void	*fshanp;
 		size_t	fshlen=0;
 
-		if(path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
+		if (path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
 			mlog(MLOG_NORMAL,
 				_("unable to construct a file "
 				  "system handle for %s: %s\n"),
@@ -3516,7 +3516,7 @@ applynondirdump(drive_t *drivep,
 					      &rv);
 		}
 
-		switch(rv) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_EOD:
@@ -3571,7 +3571,7 @@ applynondirdump(drive_t *drivep,
 			/* read the file header.
 			 */
 			rv = read_filehdr(drivep, fhdrp, fhcs);
-			switch(rv) {
+			switch (rv) {
 			case RV_OK:
 				break;
 			case RV_EOD:
@@ -4578,7 +4578,7 @@ validate:
 		       :
 		       BOOL_FALSE;
 		canseeknextpr = dcaps & DRIVE_CAP_NEXTMARK;
-		switch(Mediap->M_pos) {
+		switch (Mediap->M_pos) {
 		case POS_ATHDR:
 		case POS_INDIR:
 			if (resumepr) {
@@ -4741,7 +4741,7 @@ newmedia:
 
 		/* check if we are done.
 		 */
-		switch(purp) {
+		switch (purp) {
 		case PURP_SEARCH:
 			knownholespr = BOOL_TRUE;
 			maybeholespr = BOOL_FALSE;
@@ -5458,7 +5458,7 @@ pi_addfile(Media_t *Mediap,
 						  (rfp_t)dop->do_read,
 					    (rrbfp_t)dop->do_return_read_buf,
 						  &rval);
-				switch(rval) {
+				switch (rval) {
 				case 0:
 					assert(nread == (int)bufszincr);
 					buflen += (size_t)nread;
@@ -5880,7 +5880,7 @@ pi_scanfileendino(dh_t fileh)
 		     ;
 		      nexth = DH2F(nexth)->f_nexth) {
 
-		    switch(mode) {
+		    switch (mode) {
 		    case 0:
 			if (nexth == fileh) {
 				mode = 1;
@@ -7309,7 +7309,7 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 
 		/* call type-specific function to create the file
 		 */
-		switch(bstatp->bs_mode & S_IFMT) {
+		switch (bstatp->bs_mode & S_IFMT) {
 		case S_IFREG:
 			ok = restore_reg(drivep, fhdrp, rvp, path1);
 			if (!ok)
@@ -8014,7 +8014,7 @@ restore_symlink(drive_t *drivep,
 			  (rrbfp_t)dop->do_return_read_buf,
 			  &rval);
 	if (rval) {
-		switch(rval) {
+		switch (rval) {
 		case DRIVE_ERROR_EOF:
 		case DRIVE_ERROR_EOD:
 		case DRIVE_ERROR_EOM:
@@ -8120,7 +8120,7 @@ read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs)
 			  &rval);
 	xlate_filehdr(&tmpfh, fhdrp, 1);
 
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8179,7 +8179,7 @@ read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs)
 			  &rval);
 	xlate_extenthdr(&tmpeh, ehdrp, 1);
 
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8247,7 +8247,7 @@ read_dirent(drive_t *drivep,
 			  (rrbfp_t)
 			  dop->do_return_read_buf,
 			  &rval);
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8324,7 +8324,7 @@ read_dirent(drive_t *drivep,
 				  (rrbfp_t)
 				  dop->do_return_read_buf,
 				  &rval);
-		switch(rval) {
+		switch (rval) {
 		case 0:
 			break;
 		case DRIVE_ERROR_EOD:
@@ -8364,7 +8364,7 @@ read_extattrhdr(drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs)
 			  &rval);
 	xlate_extattrhdr(&tmpah, ahdrp, 1);
 
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8433,7 +8433,7 @@ discard_padding(size_t sz, drive_t *drivep)
 			  (rfp_t)dop->do_read,
 			  (rrbfp_t)dop->do_return_read_buf,
 			  &rval);
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		assert((size_t)nread == sz);
 		return RV_OK;
@@ -8519,7 +8519,7 @@ restore_extent(filehdr_t *fhdrp,
 		if (rval) {
 			rv_t rv;
 			char *reasonstr;
-			switch(rval) {
+			switch (rval) {
 			case DRIVE_ERROR_EOF:
 				rv = RV_EOD;
 				reasonstr = _("end of media file");
@@ -8780,7 +8780,7 @@ restore_extattr(drive_t *drivep,
 				  (rfp_t)dop->do_read,
 				  (rrbfp_t)dop->do_return_read_buf,
 				  &rval);
-		switch(rval) {
+		switch (rval) {
 		case 0:
 			break;
 		case DRIVE_ERROR_EOD:
diff --git a/restore/inomap.c b/restore/inomap.c
index 22142cd..44083ca 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -111,7 +111,7 @@ SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
-	switch(state) {
+	switch (state) {
 	case 0:
 		segp->lobits &= clrmask;
 		segp->mebits &= clrmask;
@@ -261,7 +261,7 @@ inomap_restore_pers(drive_t *drivep,
 			  &rval);
 
 	pershnkp = (hnk_t *)((char *)persp + PERSSZ);
-	for(i = 0; i < hnkcnt; i++) {
+	for (i = 0; i < hnkcnt; i++) {
 		xlate_hnk(&tmphnkp[i], &pershnkp[i], 1);
 	}
 	free(tmphnkp);
@@ -282,7 +282,7 @@ inomap_restore_pers(drive_t *drivep,
 
 	/* check the return code from read
 	 */
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		assert((size_t)nread == sizeof(hnk_t) * (size_t)hnkcnt);
 		ok = inomap_sync_pers(hkdir);
@@ -329,7 +329,7 @@ inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
 			  &rval);
 	/* check the return code from read
 	 */
-	switch(rval) {
+	switch (rval) {
 	case 0:
 		assert((size_t)nread == sizeof(hnk_t) * (size_t)hnkcnt);
 		return RV_OK;
-- 
2.19.1

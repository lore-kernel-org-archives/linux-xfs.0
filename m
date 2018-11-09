Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64939 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJAMv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:51 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 819F4C0669A3
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:00 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 15/24] xfsdump: (4/4)(style) add first empty line for multiline comments
Date: Fri,  9 Nov 2018 15:29:55 +0100
Message-Id: <20181109143004.24963-16-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Change the multiline comment style from /* foo to /*
 * foo

Created by this script:

#!/usr/bin/env bash
# change the multiline comment style from /* foo to /*
 * foo

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/^\(\s*\)\/\* \(.\+[^*][^/]\)$/\1\/*
\1 * \2/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/swab.h        |  3 +-
 inventory/getopt.h    |  3 +-
 inventory/inv_api.c   | 36 ++++++++++++++-------
 inventory/inv_core.c  |  3 +-
 inventory/inv_files.c |  3 +-
 inventory/inv_fstab.c |  6 ++--
 inventory/inv_idx.c   | 45 +++++++++++++++++---------
 inventory/inv_mgr.c   | 33 ++++++++++++-------
 inventory/inv_oref.c  |  9 ++++--
 inventory/inv_oref.h  |  3 +-
 inventory/inv_priv.h  |  3 +-
 inventory/inv_stobj.c | 75 ++++++++++++++++++++++++++++---------------
 inventory/inventory.h | 15 ++++++---
 invutil/invidx.c      |  6 ++--
 invutil/invutil.c     | 15 ++++++---
 librmt/rmtioctl.c     |  3 +-
 16 files changed, 174 insertions(+), 87 deletions(-)

diff --git a/include/swab.h b/include/swab.h
index 234e7d8..ce183bf 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -1,7 +1,8 @@
 #ifndef SWAB_H
 #define SWAB_H
 
-/* casts are necessary for constants, because we never know how for sure
+/*
+ * casts are necessary for constants, because we never know how for sure
  * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
  */
 #define ___swab16(x) \
diff --git a/inventory/getopt.h b/inventory/getopt.h
index 4ae23e4..8df7a03 100644
--- a/inventory/getopt.h
+++ b/inventory/getopt.h
@@ -18,7 +18,8 @@
 #ifndef GETOPT_H
 #define GETOPT_H
 
-/* getopt.h	common getopt  command string
+/*
+ * getopt.h	common getopt  command string
  *
  * several modules parse the command line looking for arguments specific to
  * that module. Unfortunately, each of the getopt(3) calls needs the
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index f34b92a..1ebd982 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -61,7 +61,8 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 	if (retval == I_DONE)
 		return tok;
 
-	/* if we just want to search the db, all we need is the invidx.
+	/*
+	 * if we just want to search the db, all we need is the invidx.
 	   at this point, we know that a tok wasnt created in init_idb() */
 	if (forwhat == INV_SEARCH_ONLY) {
 		/* fd == I_EMPTYINV or fd == valid fd */
@@ -70,7 +71,8 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 		return tok;
 	}
 
-	/* XXX also, see if it is too full. if so, make another and leave a
+	/*
+	 * XXX also, see if it is too full. if so, make another and leave a
 	   reference to the new file in the old one */
 
 	stobjfd = idx_get_stobj(fd, forwhat, &index);
@@ -92,7 +94,8 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 		return INV_TOKEN_NULL;
 	}
 
-	/* create another storage object (and, an inv_index entry for it
+	/*
+	 * create another storage object (and, an inv_index entry for it
 	   too) if we've filled this one up */
 
 	if ((uint) num >= sescnt->ic_maxnum) {
@@ -212,7 +215,8 @@ inv_writesession_open(
 
 	sestok = get_sesstoken(tok);
 
-	/* we need to put the new session in the appropriate place in
+	/*
+	 * we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */
 
 	INVLOCK(fd, LOCK_EX);
@@ -222,7 +226,8 @@ inv_writesession_open(
 		return INV_TOKEN_NULL;
 	}
 
-	/* create the writesession, and get ready for the streams to come
+	/*
+	 * create the writesession, and get ready for the streams to come
 	   afterwards */
 	rval = stobj_create_session(sestok, fd, sescnt, &ses, &hdr);
 	assert (rval > 0);
@@ -296,7 +301,8 @@ inv_stream_open(
 
 	assert (tok != INV_TOKEN_NULL);
 
-	/* this memset is needed as a dump interrupted/crashed very soon
+	/*
+	 * this memset is needed as a dump interrupted/crashed very soon
 	 * after starting results in an inventory with exteremely large
 	 * starting/ending inodes or offsets. This can be misleading.
 	 * See bug #463702 for an example.
@@ -393,7 +399,8 @@ inv_stream_close(
 			dowrite = BOOL_TRUE;
 		}
 
-		/* get the last media file to figure out what our last
+		/*
+		 * get the last media file to figure out what our last
 		   ino was. we have a pointer to that in the stream token */
 		if (tok->md_lastmfile){
 			if (strm.st_endino.ino !=
@@ -471,7 +478,8 @@ inv_put_mediafile(
 	if (isgood)
 		mf->mf_flag |= INVT_MFILE_GOOD;
 
-	/* This flag is used to indicate the media file that contains the
+	/*
+	 * This flag is used to indicate the media file that contains the
 	   dump of the sessioninfo structure that contains all but this
 	   media file */
 	if (isinvdump)
@@ -481,7 +489,8 @@ inv_put_mediafile(
 	rval = stobj_put_mediafile(tok, mf);
 	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN);
 
-	/* we dont free the mfile here. we always keep the last mfile
+	/*
+	 * we dont free the mfile here. we always keep the last mfile
 	   around, inside the inv_stmtoken, and when we add a new mfile,
 	   we free the previous one. The last one is freed in stream_close()
 	   */
@@ -526,7 +535,8 @@ inv_get_sessioninfo(
 
 	INVLOCK(fd, LOCK_SH);
 
-	/* Next we get the session header, and the session information. Then
+	/*
+	 * Next we get the session header, and the session information. Then
 	   we can figure out how much space to allocate */
 	if (stobj_get_sessinfo(tok, &hdr, &ses) <= 0) {
 		INVLOCK(fd, LOCK_UN);
@@ -762,7 +772,8 @@ inv_delete_mediaobj(uuid_t *moid)
 {
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
-	/* forall fsids (fs) in fstab {
+	/*
+	 * forall fsids (fs) in fstab {
 	       open invindex table (t)
 	       forall indices (i) in t {
 	          open stobj (st)
@@ -1021,7 +1032,8 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 		 && ! prctx->fstab && ! prctx->invcheck) {
 		inv_idbtoken_t tok;
 
-		/* A filesystem could be backed up, mkfs'ed then restored
+		/*
+		 * A filesystem could be backed up, mkfs'ed then restored
 		 * to a new UUID value.  Therefore, we can't simply stop
 		 * when we find the first matching mount point (pv564234).
 		 * This code loops through all filesystems and does the
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 006b41b..1a711fd 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -218,7 +218,8 @@ get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 		return -1;
 	}
 
-	/* if there's space anywhere at all, then it must be in the last
+	/*
+	 * if there's space anywhere at all, then it must be in the last
 	   entry */
 	*ent = malloc(hdrsz);
 	pos = (char *) arr + ((uint)nindices - 1) * hdrsz;
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index ae4642d..ebc8035 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -102,7 +102,8 @@ inv_setup_base(void)
 	else
 		inv_base = old_inv_base;
 
-	/* also setup the dependent paths now
+	/*
+	 * also setup the dependent paths now
 	 */
 	strcpy(inv_dirpathp, inv_base);
 	strcat(inv_dirpathp, MGR_DIRPATH);
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 5afec57..f9bf2b3 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -72,7 +72,8 @@ fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 	mlog(MLOG_NITTY | MLOG_INV, "INV: number of filesystems in fstab %d\n",
 	      *numfs);
 #endif
-	/* fstab is left locked EX on exit. The caller takes does
+	/*
+	 * fstab is left locked EX on exit. The caller takes does
 	   the unlocking */
 	return fd;
 }
@@ -137,7 +138,8 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 	    free (arr);
 	}
 
-	/* make a new fstab entry and insert it at the end. the table
+	/*
+	 * make a new fstab entry and insert it at the end. the table
 	   is locked EXclusively at this point */
 	{
 		invt_fstab_t ent;
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 28e402d..b29bcdc 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -54,7 +54,8 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 /*	invt_entry_t ient;
 	ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
 
-	/* If time period of the new entry is before our first invindex,
+	/*
+	 * If time period of the new entry is before our first invindex,
 	   we have to insert a new invindex in the first slot */
 	if (iarr[0].ie_timeperiod.tp_start > tm) {
 		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient); */
@@ -63,7 +64,8 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 	}
 
 	for (i = 0; i < icnt->ic_curnum; i++) {
-		/* if our time is nicely within an existing entry's time
+		/*
+		 * if our time is nicely within an existing entry's time
 		   period, hellalujah */
 		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm) ) {
 #ifdef INVT_DEBUG
@@ -97,19 +99,22 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 
 
 
-		/* if it is beyond the end of this timeperiod, see if we
+		/*
+		 * if it is beyond the end of this timeperiod, see if we
 		   belong to a timeperiod that doesn't have an entry */
 		if (iarr[i].ie_timeperiod.tp_end < tm) {
 			/* see if we're the last entry here */
 			if (i == icnt->ic_curnum - 1) {
-				/* our slot is (i+1)th entry. Make the
+				/*
+				 * our slot is (i+1)th entry. Make the
 				   timeperiod's the same as it was. As far
 				   as I can see there is no way that
 				   timeperiods can overlap.
 
 				   insert the new entry and write back
 				   icnt and invindex entry */
-				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+				/*
+				 * *stobjfd = idx_put_newentry(fd, i+1, iarr,
 							     icnt, &ient); */
 			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			      return i;
@@ -118,7 +123,8 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 			if (iarr[i+1].ie_timeperiod.tp_start > tm) {
 
 
-				/* We have the option of pushing entries
+				/*
+				 * We have the option of pushing entries
 				   after (i) forward by one slot, and
 				   taking the (i+1)th slot, OR just hooking
 				   up with the next entry.
@@ -128,10 +134,12 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 				assert((tm > iarr[i].ie_timeperiod.tp_end) &&
 				       (tm < iarr[i+1].ie_timeperiod.tp_start));
 
-				/* shift everything from (i+1) onwards by
+				/*
+				 * shift everything from (i+1) onwards by
 				   one. Then insert the new entry and write
 				   back icnt and invindex entries */
-				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
+				/*
+				 * *stobjfd = idx_put_newentry(fd, i+1, iarr,
 							     icnt, &ient); */
 			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
@@ -219,7 +227,8 @@ idx_find_stobj(invt_idxinfo_t *idx,
 
 	int 		stobjfd;
 
-	/* since sessions can be inserted in random order, the invindex
+	/*
+	 * since sessions can be inserted in random order, the invindex
 	   table can contain time-periods that don't have corresponding
 	   entries for */
 	if (GET_ALLHDRS_N_CNTS_NOLOCK(idx->invfd, (void **)&idx->iarr,
@@ -234,7 +243,8 @@ idx_find_stobj(invt_idxinfo_t *idx,
 	idx_DEBUG_printinvindices(idx->iarr, idx->icnt->ic_curnum);
 #endif
 
-	/* Now figure out where we are going to insert this stobj among the
+	/*
+	 * Now figure out where we are going to insert this stobj among the
 	   invindices and put it there */
 	idx->index = idx_insert_newentry(idx->invfd, &stobjfd, idx->iarr,
 						 idx->icnt, tm);
@@ -259,7 +269,8 @@ idx_create(char *fname, inv_oflag_t forwhat)
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	/* This is not to be called when the user wants to open
+	/*
+	 * This is not to be called when the user wants to open
 	   the db for SEARCH_ONLY. */
 	assert(forwhat != INV_SEARCH_ONLY);
 
@@ -368,7 +379,8 @@ idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime)
 
 
 
-/* an inventory index entry keeps track of a single storage object;
+/*
+ * an inventory index entry keeps track of a single storage object;
    it knows about its name (ie filename) and the timeperiod that the
    it contains dump sessions for.
    note that each file system has its own (set of) inventory indices.
@@ -423,7 +435,8 @@ idx_create_entry(
 			return -1;
 		}
 
-		/* XXX check if there are too many indices. if so, create
+		/*
+		 * XXX check if there are too many indices. if so, create
 		   another and leave a pointer to that in here */
 
 		/* create the new storage object */
@@ -474,14 +487,16 @@ idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 	invt_entry_t 	*ent = 0;
 	int	     	 fd;
 
-	/* if there's space anywhere at all, then it must be in the last
+	/*
+	 * if there's space anywhere at all, then it must be in the last
 	   entry. get_lastheader() does the locking */
 
 	if ((*index = get_lastheader(invfd, (void **)&ent,
 				       sizeof(invt_entry_t),
 				       sizeof(invt_counter_t)) ) < 0)
 		return -1;
-	/* at this point we know that there should be at least one invindex
+	/*
+	 * at this point we know that there should be at least one invindex
 	   entry present */
 	assert (ent != NULL);
 	assert (ent->ie_filename);
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index b2664ab..3d18742 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -57,7 +57,8 @@ init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 	if (make_invdirectory(forwhat) < 0)
 		return I_DONE;
 
-	/* come up with the unique file suffix that refers to this
+	/*
+	 * come up with the unique file suffix that refers to this
 	   filesystem */
 	if (fstab_get_fname(pred, uuname, bywhat, forwhat) < 0) {
 		return I_DONE;
@@ -73,7 +74,8 @@ init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 		} else if (forwhat == INV_SEARCH_N_MOD) {
 			*tok = idx_create(fname, forwhat);
 		} else {
-			/* this happens when the inv is empty and the user
+			/*
+			 * this happens when the inv is empty and the user
 			   wants to do a search. this is legal - not an error */
 			return I_EMPTYINV;
 		}
@@ -205,7 +207,8 @@ invmgr_query_all_sessions (
 		}
 	}
 
-	/* return val indicates if there was an error or not. *buf
+	/*
+	 * return val indicates if there was an error or not. *buf
 	   says whether the search was successful */
 	return ret;
 }
@@ -239,7 +242,8 @@ search_invt(
 	if (invfd == I_EMPTYINV)
 		return -1;
 
-	/* set the caller's buffer pointer to NULL initially.
+	/*
+	 * set the caller's buffer pointer to NULL initially.
 	 * if no session found, the caller will expect to see
 	 * NULL.
 	 */
@@ -255,7 +259,8 @@ search_invt(
 
 	free(icnt);
 
-	/* we need to get all the invindex headers and seshdrs in reverse
+	/*
+	 * we need to get all the invindex headers and seshdrs in reverse
 	   order */
 	for (i = nindices - 1; i >= 0; i--) {
 		int			nsess, j;
@@ -286,17 +291,20 @@ search_invt(
 		for (j = nsess - 1; j >= 0; j--) {
 			invt_session_t ses;
 
-			/* fd is kept locked until we return from the
+			/*
+			 * fd is kept locked until we return from the
 			   callback routine */
 
-			/* Check to see if this session has been pruned
+			/*
+			 * Check to see if this session has been pruned
 			 * by xfsinvutil before checking it.
 			 */
 			if (harr[j].sh_pruned) {
 				continue;
 			}
 
-			/* if we need to check the fs uuid's and they don't
+			/*
+			 * if we need to check the fs uuid's and they don't
 			 * match or we fail to get the session record,
 			 * then keep looking
 			 */
@@ -397,10 +405,12 @@ invmgr_inv_print(
 		}
 		free (scnt);
 		for (s = 0; s < nsess; s++) {
-			/* fd is kept locked until we return from the
+			/*
+			 * fd is kept locked until we return from the
 			   callback routine */
 
-			/* Check to see if this session has been pruned
+			/*
+			 * Check to see if this session has been pruned
 			 * by xfsinvutil before returning it.
 			 */
 			if (harr[s].sh_pruned) {
@@ -622,7 +632,8 @@ insert_session(invt_sessinfo_t *s)
 		destroy_token(tok);
 	}
 
-	/* at this point we know that invindex has at least one entry
+	/*
+	 * at this point we know that invindex has at least one entry
 
 	   First we need to find out if this session is in the inventory
 	   already. To find the storage object that can possibly
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index d2f1515..1b26d03 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -321,7 +321,8 @@ oref_resolve(
 
 	OREF_SET_TYPE(invidx, INVT_OTYPE_INVIDX);
 
-	/* come up with the unique file suffix that refers to this
+	/*
+	 * come up with the unique file suffix that refers to this
 	   filesystem */
 	if (fstab_get_fname(pred, uuname, bywhat) < 0) {
 		return INV_ERR;
@@ -358,7 +359,8 @@ oref_resolve(
 		return INV_ERR;
 	}
 
-	/* create another storage object (and, an inv_index entry for it
+	/*
+	 * create another storage object (and, an inv_index entry for it
 	   too) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
 		int 	rval;
@@ -403,7 +405,8 @@ oref_resolve_child(
 
 	ent = OREF_ENTRIES(invidx);
 
-	/* at this point we know that there should be at least one invindex
+	/*
+	 * at this point we know that there should be at least one invindex
 	   entry present */
 	assert (ent != NULL);
 	assert (ent->ie_filename);
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 3118b38..d54c0df 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -38,7 +38,8 @@
 
 #define INVT_RES_MASK		0x0FF0
 
-/* Indicates if either its child or its parent has been resolved.
+/*
+ * Indicates if either its child or its parent has been resolved.
    Only one kin per object can exist. i.e. a child cant have children.*/
 #define INVT_RES_CHILD		0x1000
 #define INVT_RES_PARENT		0x2000
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 554c983..7fffc36 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -127,7 +127,8 @@ typedef struct invt_seshdr {
 } invt_seshdr_t;
 
 
-/* Each session consists of a number of media streams. While it is given that
+/*
+ * Each session consists of a number of media streams. While it is given that
    there won't be multiple writesessions (ie. dumpsessions) concurrently,
    there can be multiple media streams operating on a single file system,
    each writing media files within its own stream. Hence, we have a linked
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index f86c978..d745f8b 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -60,7 +60,8 @@ stobj_insert_session(invt_idxinfo_t *idx,
 		return -1;
 	}
 
-	/* Check the existing sessions to make sure that we're not
+	/*
+	 * Check the existing sessions to make sure that we're not
 	   duplicating this session */
 	if (sescnt->ic_curnum > 0) {
 		uint i;
@@ -139,7 +140,8 @@ stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm)
 	}
 
 
-	/* All the entries have the same sh_time. It's not clear if that's
+	/*
+	 * All the entries have the same sh_time. It's not clear if that's
 	   really possible, but either way, we split at the last entry.
 	   This will impact the guarantee that invindex tries to give - that
 	   there's always a unique stobj for every session. */
@@ -195,7 +197,8 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 				= newsess->seshdr->sh_time;
 	}
 
-	/* Get the new stobj to put the 'spilling' sessinfo in. We know the
+	/*
+	 * Get the new stobj to put the 'spilling' sessinfo in. We know the
 	   idx of the current stobj, and by definition, the new stobj
 	   should come right afterwards. */
 	newsess->stobjfd = idx_put_newentry(idx, &ient);
@@ -206,7 +209,8 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		invt_sescounter_t *scnt = NULL;
 		off64_t rval;
 
-		/* We dont need to split. So, just put the new session in
+		/*
+		 * We dont need to split. So, just put the new session in
 		   the new stobj, and rest in peace */
 		idx->index++;
 
@@ -236,7 +240,8 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		if (! stobj_pack_sessinfo(fd, &session, &harr[i], &bufpp,
 					   &bufszp))
 			return -1;
-		/* Now we need to put this in the new StObj. So, first
+		/*
+		 * Now we need to put this in the new StObj. So, first
 		   unpack it. */
 		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo) )
 			return -1;
@@ -252,7 +257,8 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 			return -1;
 		free(bufpp);
 	}
-	/* Put the new session in the stobj that we just split. Make
+	/*
+	 * Put the new session in the stobj that we just split. Make
 	   sure that we use the updated sescnt and not the stale stuff
 	   from disk. stobj_put_session() writes sescnt and sessinfo to
 	   disk */
@@ -288,11 +294,13 @@ stobj_delete_sessinfo(int fd, /* kept locked EX by caller */
 		       invt_sescounter_t *sescnt,
 		       invt_session_t *ses, invt_seshdr_t *hdr)
 {
-	/* we change the sescnt here, but dont write it back to disk
+	/*
+	 * we change the sescnt here, but dont write it back to disk
 	   until later */
 	sescnt->ic_curnum--;
 
-	/* there is really no need to take out / zero out the deleted
+	/*
+	 * there is really no need to take out / zero out the deleted
 	   session. The seshdr and session will be over-written, but
 	   space taken by the streams and mediafiles will be wasted. */
 	return BOOL_TRUE;
@@ -334,7 +342,8 @@ stobj_put_session(
 	       (int) sescnt->ic_eof);
 #endif
 
-	/* we need to know where the streams begin, and where the
+	/*
+	 * we need to know where the streams begin, and where the
 	   media files will begin, at the end of the streams */
 	hdr->sh_streams_off = sescnt->ic_eof;
 
@@ -467,7 +476,8 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 			    (off64_t) ((j-1) * sizeof(invt_mediafile_t));
 		}
 
-		/* adjust the offsets of the first and the last elements
+		/*
+		 * adjust the offsets of the first and the last elements
 		   in the mediafile chain */
 		mfiles[nmfiles].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
@@ -612,7 +622,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 	int fd =  sestok->sd_invtok->d_stobj_fd;
 	off64_t pos;
 
-	/* first we need to find out where the current write-position is.
+	/*
+	 * first we need to find out where the current write-position is.
 	   so, we first read the sescounter that is at the top of this
 	   storage object */
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0)
@@ -626,7 +637,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 	if (PUT_SESCOUNTERS(fd, sescnt) < 0)
 		return -1;
 
-	/* get the stream information, and update number of mediafiles.
+	/*
+	 * get the stream information, and update number of mediafiles.
 	   we also need to link the new mediafile into the linked-list of
 	   media files of this stream */
 
@@ -634,7 +646,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 			     tok->md_stream_off) < 0)
 		return -1;
 
-	/* We need to update the last ino of this STREAM, which is now the
+	/*
+	 * We need to update the last ino of this STREAM, which is now the
 	   last ino of the new mediafile. If this is the first mediafile, we
 	   have to update the startino as well. Note that ino is a <ino, off>
 	   tuple */
@@ -768,17 +781,20 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	sesbufcp = sesbuf = calloc(1, sessz);
 	assert(sesbuf);
 
-	/* Copy everything. Note that we don't bother to adjust the offsets
+	/*
+	 * Copy everything. Note that we don't bother to adjust the offsets
 	   either in the seshdr or in the mediafiles, because we don't need
 	   those in order to restore this session (since everything's
 	   contiguous) */
 
-	/* magic cookie that we put for sanity checking in case of an
+	/*
+	 * magic cookie that we put for sanity checking in case of an
 	   earthquake or something :) */
 	strcpy(sesbuf, INVTSESS_COOKIE);
 	sesbuf += (size_t)(strlen(INVTSESS_COOKIE) * sizeof(char) );
 
-	/* This was originally INV_VERSION. Changed it to mean packed inventory
+	/*
+	 * This was originally INV_VERSION. Changed it to mean packed inventory
 	 * version number and added another inv_version_t to contain the INV_VERSION.
 	 * The primary intent of this change was to make everything 64 bit aligned,
 	 * but we also got the advantage of separating the packed inv version from
@@ -854,7 +870,8 @@ stobj_getsession_byuuid(
 		return BOOL_FALSE;
 	}
 
-	/* yay. we found the session. so, make the session struct and
+	/*
+	 * yay. we found the session. so, make the session struct and
 	   put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
@@ -890,7 +907,8 @@ stobj_getsession_bylabel(
 		return BOOL_FALSE;
 	}
 
-	/* yay. we found the session. so, make the session struct and
+	/*
+	 * yay. we found the session. so, make the session struct and
 	   put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
@@ -945,7 +963,8 @@ stobj_delete_mobj(int fd,
 		     off = mf->mf_nextmf,
 		     mf++) {
 
-/*  The prob is that we need to keep track of where we got these mfiles from
+/*
+ *  The prob is that we need to keep track of where we got these mfiles from
     as we get them, or we wont know how to put them back if they are dirty.
 */
 			assert(off);
@@ -958,7 +977,8 @@ stobj_delete_mobj(int fd,
 			}
 		}
 
-		/* We have all the media files of this stream. Make another
+		/*
+		 * We have all the media files of this stream. Make another
 		   pass, checking to see if we need to remove any mfiles */
  		dirty = BOOL_FALSE;
 
@@ -969,7 +989,8 @@ stobj_delete_mobj(int fd,
 				printf(" found one\n");
 #endif
 
-/*                                dirty = BOOL_TRUE;
+/*
+ *                                dirty = BOOL_TRUE;
 
 				if (j == 0)
 				       strms[i].st_firstmfile = mf->mf_nextmf;
@@ -1016,7 +1037,8 @@ stobj_unpack_sessinfo(
 
 	tmpbuf = (char *)malloc(bufsz);
 
-	/* first make sure that the magic cookie at the beginning is right.
+	/*
+	 * first make sure that the magic cookie at the beginning is right.
 	   this isn't null-terminated */
 	if (strncmp(p, INVTSESS_COOKIE, strlen(INVTSESS_COOKIE) ) != 0) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
@@ -1026,7 +1048,8 @@ stobj_unpack_sessinfo(
 	/* skip the cookie */
 	p += strlen(INVTSESS_COOKIE) * sizeof(char);
 
-	/* Check the packing version number. In version 1, this was the only version number.
+	/*
+	 * Check the packing version number. In version 1, this was the only version number.
 	 * see the comment in stobj_pack_sessinfo().
 	 */
 	if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_1) {
@@ -1037,7 +1060,8 @@ stobj_unpack_sessinfo(
 
 		p += sizeof(inv_version_t);
 
-		/* We hit a 64 bit alignment issue at this point leading to a
+		/*
+		 * We hit a 64 bit alignment issue at this point leading to a
 		 * SIGBUS and core dump. The best way to handle it is to
 		 * bcopy the remaining part of bufp to a new malloc'ed area
 		 * which will be 64 bit aligned. This is a memory leak, but not much.
@@ -1109,7 +1133,8 @@ stobj_unpack_sessinfo(
 			* sizeof(invt_mediafile_t);
 	}
 
-	/* sanity check the size of the buffer given to us vs. the size it
+	/*
+	 * sanity check the size of the buffer given to us vs. the size it
 	   should be */
 	if ((size_t) (p - (char *) bufp) != bufsz) {
 		mlog(MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
diff --git a/inventory/inventory.h b/inventory/inventory.h
index e81f153..cc1fe12 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -20,7 +20,8 @@
 
 #include "types.h"
 
-/* abstract interface to the inventory sub system of xfsdump
+/*
+ * abstract interface to the inventory sub system of xfsdump
  *
  * the inventory contains a description of every xfsdump ever
  * done, unless explicitly deleted. It provides simple and specific
@@ -45,11 +46,13 @@
 
 typedef uint32_t		inv_version_t;
 
-/* This is the general inventory version.
+/*
+ * This is the general inventory version.
  */
 #define INV_VERSION		(inv_version_t) 1
 
-/* This is the version of the on-tape (packed) inventory.
+/*
+ * This is the version of the on-tape (packed) inventory.
  * version 2 has an extra inv_version_t in it to make everything
  * 64 bit aligned.
  */
@@ -183,7 +186,8 @@ typedef struct invt_strdesc_entry	*inv_stmtoken_t;
 
 
 
-/* inventory_open - initializes access to the inventory
+/*
+ * inventory_open - initializes access to the inventory
  */
 extern inv_idbtoken_t
 inv_open(
@@ -240,7 +244,8 @@ inv_put_mediafile(
 				     files from others */
 	bool_t		isinv_dump);
 
-/* lasttime_level_lessthan - finds the time of the last dump of the
+/*
+ * lasttime_level_lessthan - finds the time of the last dump of the
  * specified file system at a level less than the specified level.
  * if never dumped below the current level, *time is set to NULL.
  *
diff --git a/invutil/invidx.c b/invutil/invidx.c
index e723110..ca6e1c2 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -649,7 +649,8 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		mfiles[nmfiles + j].mf_prevmf = strms[i].st_firstmfile + (off64_t) ((j-1) * sizeof(invt_mediafile_t));
 	}
 
-	/* adjust the offsets of the first and the last elements
+	/*
+	 * adjust the offsets of the first and the last elements
 	   in the mediafile chain */
 	mfiles[nmfiles].mf_prevmf = 0;
 	nmfiles += strms[i].st_nmediafiles;
@@ -796,7 +797,8 @@ get_inventry_stobjfile(data_t *d)
 	return NULL;
     }
 
-    /* all the children will be from the same stobj file, so we can just
+    /*
+     * all the children will be from the same stobj file, so we can just
        get the name for the first */
 
     child_data = d->children[0]->data;
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 26fb630..774602d 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -242,7 +242,8 @@ main(int argc, char *argv[])
 	    }
     }
 
-    /* sanity check the inventory database directory, setup global paths
+    /*
+     * sanity check the inventory database directory, setup global paths
      */
     if (!inv_setup_base()) {
         fprintf(stderr,
@@ -287,7 +288,8 @@ main(int argc, char *argv[])
     return 0;
 }
 
-/* get_mntpnt & mntpnt_equal are used to allow matching of mountpoints if
+/*
+ * get_mntpnt & mntpnt_equal are used to allow matching of mountpoints if
  * no hostname is supplied
  */
 
@@ -384,7 +386,8 @@ ParseDate(char *strDate)
         date = mktime(&tm);
     }
 
-    /* xfsdump inventory uses time32_t for portability.
+    /*
+     * xfsdump inventory uses time32_t for portability.
      * make sure the given date did not overflow... */
     date32 = date;
     if (date32 != date) {
@@ -767,7 +770,8 @@ CheckAndPruneStObjFile(bool_t checkonly,
 		   ctime32(&StObjhdr->sh_time));
 	}
 	if (debug) {
-	    /* Note that the DMF people use some of this debug
+	    /*
+	     * Note that the DMF people use some of this debug
 	     * output for their interface to the inventory.
 	     * They care about the following fields:
 	     *	media label:
@@ -917,7 +921,8 @@ CheckAndPruneStObjFile(bool_t checkonly,
     return(0);
 }
 
-/* If any of the media objects have a label which matches the one supplied
+/*
+ * If any of the media objects have a label which matches the one supplied
  * by the user, or if none is supplied, or if the session has no media
  * objects, say the session is prunable.
  * Otherwise, say it should be bypassed.
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index 536069c..3e7a7ed 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -239,7 +239,8 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			return(-1);
 
 
-		/* If undefined then try and define it by looking
+		/*
+		 * If undefined then try and define it by looking
 		 * and the size of the get structure.
 		 * If we know our rmt host, then verify that the
 		 * structure is the correct size for the supported ones
-- 
2.19.1

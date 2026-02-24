Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF7364041
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917465; cv=none; b=QSKuFOKyK5hnsThSGm1RPxwj4VdTfuTiWerkm3px/SDDSZRsCwEKv1qpBVNYyS9cHLOoQ7I/4mOgo+4IU0iyaa/wdXkF8PJ4T8lI7g1yXJAjnz4qmMaHlLwB5XhzcXKSBE/hX+Rpln7i74K7HZG0/ByRU+eJQv7YZ88O00d5kxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917465; c=relaxed/simple;
	bh=HCWRDO10Q5Nu0Ji5iCcq4eFgQVZqub4XGJPDQjDaVaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JIJ4Cldsq5yig68OUYg0NxOxJ0qgDb+45mcoOgIWG6Tx1wJPnmlkKGaFEPmG3LAF3rRm4qBGs3MF2NRyTTowTkkwSDqGBEjlA7QKGQXAJbv9TgBNoaAMzvUL56bF0TzOX/6valTIkjZ3SppznrZ0/ARIVVNKfsNOSOFejIuFSZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUXgFTV2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahktBZNM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUXgFTV2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahktBZNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJsrJqDUiA+qg66a+rAEURU8rq1zAn5NVbjgLiw4olc=;
	b=RUXgFTV2NSGUHbhqOvTzXNvmACHE+09RZEldY0pqYmWKYuJ3r4LW0gYUjpb4+eEeQh9HpE
	a/1bYrOVoERbyToBQIPTtgxFVjytzbt7lYIc7ImPHuc/uyRaxhMpx/FgIdrNhAGsW7T0WJ
	CkDewbSlQw1pXI7poXRGPEX4iloQFxg=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-2IloBb1vPL65Rzf_8jMXcw-1; Tue, 24 Feb 2026 02:17:40 -0500
X-MC-Unique: 2IloBb1vPL65Rzf_8jMXcw-1
X-Mimecast-MFC-AGG-ID: 2IloBb1vPL65Rzf_8jMXcw_1771917459
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6b1b22b134so3166950a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917459; x=1772522259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJsrJqDUiA+qg66a+rAEURU8rq1zAn5NVbjgLiw4olc=;
        b=ahktBZNM+R40eHGnjMbKuGJWwjrb0WjO4/7fjfIdo1Lypso/Gt9/7/FV/6Idj92gV0
         vp8lFmvQrvZR4CVzwjqAzUbN1wc0F1ZDl3HvA3IKPbDD/+HC1b+d95l5QUjClb9iC1vP
         iJOTamgi+HSJ8CkTpwJy1WYoOuarhj3W31r3yNqh/NXdeND/2ezyUMD01kcoqKfAVXiy
         cbG3E5pH4MdX4cugG9aqVeXNoi1BG9pg4iXtcp2Wv5FYvMSxy/e114l24RKK21uxRb8v
         Cnc07yuhDSvBzKE0YYBEMzjWCC+ixw7d41YtUVnI6P81qHiS4Q3FRNHY3Rr1BAxRcTCG
         yWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917459; x=1772522259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FJsrJqDUiA+qg66a+rAEURU8rq1zAn5NVbjgLiw4olc=;
        b=qKZ42w4EurZQj6wA0/UeAk6H0n4pRm2LOYpERCJe4bHIUyBt6RB+WBnWKKl6DL0lPt
         6Y6pDuuEl/CUQ1+unW3ClYzd+uIkYUkcs7/v2mdAk9lkhNIx86izaXR5Q9MTik6C5MTB
         6t0UP0G+GO5ey2G0x7lJD/ij89jZc5hJkLchS5RsFSugVsjsMfgOgcXguVp+nG3DLliy
         Z26ovAALkc7gJu+zSuyCfaYnc7IfLjyXKF1IMRXkrcdbQ5Jf9o1LPrICZT55r9v58CRi
         MAvnbAxCVIdM3OjdwkIR6njgzAVQwZgjm05R3iXX3NfpMMf78gG03XaJ1oSGS/KqYSmV
         BFRg==
X-Gm-Message-State: AOJu0Yx8/alvjDcnevVYM/S16XnxB6K7t9RGANnF5m0YWFYMvEyDXoUC
	pKS7jV3nYw6Zwz5O13NBRrOnmobGtFf2Q7SlX9FrSOGAm9ixuWCtAAWdcy3s6Py29XlkfvQaJ7E
	GK51HSBC1n6b5s4LbNMvtdv+XItqjbqDyil8+Y1x1v2LcAOVihhGRHawjeePe0uT5Cdg146dFi3
	5Cbxj8SVNacPKVXECYFMOq5zSpOc0ivtUr8dUvNzLZ7eu2uw==
X-Gm-Gg: AZuq6aILH3LbSzF0n9QGWio80kE3fU+swvD4rxIxcrgEgMNUVQzXI6lSqYQ7m6dem3O
	zdikS0XzWEu8pnJGc5bduwCtHAY2Yfhmfdsygf7oxUZn8vspJkEYzBLK3pDjmkqejhSJjDuyzs0
	FjLyrmS5jIBX0n6tSgDQjX1VGAGw5UNKnxM4OWXd86PhawCCJm5zaOUHRWOOMOfrs7UTpXWO/Y9
	ph1bJbNH3JoIol5WboxO5Xm34g8fqCwbCyzAHwC1zo/Yl/bhLQjAaiSQEIm8N5OWRKi3vUJS+sa
	q7+rr4CHgrGjRMwpkf6SFn6zsZj9ztcG0o6PgV0npgxDaOBnXU6w9IobYueBoF31W1bjoYxUQOk
	Zn1oiackB4MFbXReFlXxuiymxPa7UNFj1tA==
X-Received: by 2002:a05:6a20:12ce:b0:38e:676a:f3e with SMTP id adf61e73a8af0-39545ead6c8mr9898218637.29.1771917458938;
        Mon, 23 Feb 2026 23:17:38 -0800 (PST)
X-Received: by 2002:a05:6a20:12ce:b0:38e:676a:f3e with SMTP id adf61e73a8af0-39545ead6c8mr9898183637.29.1771917458219;
        Mon, 23 Feb 2026 23:17:38 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:37 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 2/5] annotate variables only used for assert
Date: Tue, 24 Feb 2026 18:17:09 +1100
Message-ID: <20260224071712.1014075-3-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building with NDEBUG defined we see warnings on variables only used
for assert(3).

  warning: variable ‘rval’ set but not used [-Wunused-but-set-variable]

Annotate these with __attribute__((unused)) and remove any REFERENCED
comment style annotations that no longer work.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 common/drive_minrmt.c   |  5 ++---
 common/drive_scsitape.c |  5 ++---
 common/drive_simple.c   |  9 +++------
 common/main.c           |  6 ++----
 common/mlog.c           |  6 ++----
 common/qlock.c          | 18 ++++++++----------
 common/ring.c           |  2 +-
 dump/content.c          |  8 +++-----
 restore/content.c       | 30 ++++++++++--------------------
 restore/dirattr.c       |  3 +--
 restore/inomap.c        |  9 +++------
 restore/tree.c          | 36 ++++++++++++------------------------
 restore/win.c           |  3 +--
 13 files changed, 50 insertions(+), 90 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 0cbf235..ced2b21 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -880,8 +880,7 @@ static void
 do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
 {
 	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
-	/* REFERENCED */
-	size_t ownedcnt;
+	__attribute__((unused)) size_t ownedcnt;
 
 	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: return read buf: sz %d (0x%x)\n",
@@ -1230,7 +1229,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 		assert(wantedoffset - currentoffset < (off64_t)tape_recsz);
 		wantedcnt = (size_t)(wantedoffset - currentoffset);
 		if (contextp->dc_recp) {
-			uint32_t recoff;
+			__attribute__((unused)) uint32_t recoff;
 #ifdef DEBUG
 			rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 #endif
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 878a5d7..e50bbf9 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -993,8 +993,7 @@ static void
 do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
 {
 	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
-	/* REFERENCED */
-	size_t ownedcnt;
+	__attribute__((unused)) size_t ownedcnt;
 
 	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: return read buf: sz %d (0x%x)\n",
@@ -1343,7 +1342,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 		assert(wantedoffset - currentoffset < (off64_t)tape_recsz);
 		wantedcnt = (size_t)(wantedoffset - currentoffset);
 		if (contextp->dc_recp) {
-			uint32_t recoff;
+			__attribute__((unused)) uint32_t recoff;
 #ifdef DEBUG
 			rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 #endif
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 5c3ed4b..a085df0 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -682,8 +682,7 @@ static void
 do_return_read_buf(drive_t *drivep, char *retp, size_t retcnt)
 {
 	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
-	/* REFERENCED */
-	size_t ownedcnt;
+	__attribute__((unused)) size_t ownedcnt;
 
 	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple return_read_buf( returning %u )\n",
@@ -745,8 +744,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 	off64_t mark = *(off64_t *)markp;
 	off64_t nextoff;
 	off64_t strmoff;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	off64_t nreadneeded64;
 	int nreadneeded;
 	int rval;
@@ -1058,8 +1056,7 @@ do_set_mark(drive_t *drivep,
 			global_hdr_t		*gwhdrp = drivep->d_gwritehdrp;
 			drive_hdr_t		*dwhdrp = drivep->d_writehdrp;
 			off64_t			newoff;
-			/* REFERENCED */
-			int		nwritten;
+			__attribute__((unused)) int nwritten;
 
 			/* assert the header has been flushed
 			 */
diff --git a/common/main.c b/common/main.c
index 6141ffb..c064fca 100644
--- a/common/main.c
+++ b/common/main.c
@@ -162,8 +162,7 @@ main(int argc, char *argv[])
 	int prbcld_xc = EXIT_NORMAL;
 	int xc;
 	bool_t ok;
-	/* REFERENCED */
-	int rval;
+	__attribute__((unused)) int rval;
 	int err;
 
 	/* sanity checks
@@ -2050,8 +2049,7 @@ set_rlimits(size64_t *vmszp)
 #ifdef RESTORE
 	size64_t vmsz;
 #endif /* RESTORE */
-	/* REFERENCED */
-	int rval;
+        __attribute__((unused)) int rval;
 
 	assert(minstacksz <= maxstacksz);
 
diff --git a/common/mlog.c b/common/mlog.c
index 7f8640b..e5915b0 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -669,8 +669,7 @@ rv_t
 mlog_get_hint(void)
 {
 	stream_state_t states[] = { S_RUNNING };
-	/* REFERENCED */
-	bool_t ok;
+	__attribute__((unused)) bool_t ok;
 	rv_t hint;
 
 	if (pthread_equal(pthread_self(), parenttid))
@@ -727,8 +726,7 @@ mlog_exit_flush(void)
 			int streamix;
 			int exit_code;
 			rv_t exit_return, exit_hint;
-			/* REFERENCED */
-			bool_t ok;
+			__attribute__((unused)) bool_t ok;
 
 			ok = stream_get_exit_status(tids[i],
 						    states,
diff --git a/common/qlock.c b/common/qlock.c
index 81a0e0b..bc0f11b 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -103,8 +103,7 @@ qlock_lock(qlockh_t qlockh)
 {
 	qlock_t *qlockp = (qlock_t *)qlockh;
 	pthread_t tid;
-	/* REFERENCED */
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* get the caller's tid
 	 */
@@ -146,8 +145,7 @@ void
 qlock_unlock(qlockh_t qlockh)
 {
 	qlock_t *qlockp = (qlock_t *)qlockh;
-	/* REFERENCED */
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* verify lock is held by this thread
 	 */
@@ -167,7 +165,7 @@ qsemh_t
 qsem_alloc(ix_t cnt)
 {
 	sem_t *semp;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* allocate a semaphore
 	 */
@@ -186,7 +184,7 @@ void
 qsem_free(qsemh_t qsemh)
 {
 	sem_t *semp = (sem_t *)qsemh;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* destroy the mutex and condition
 	 */
@@ -202,7 +200,7 @@ void
 qsemP(qsemh_t qsemh)
 {
 	sem_t *semp = (sem_t *)qsemh;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* "P" the semaphore
 	 */
@@ -214,7 +212,7 @@ void
 qsemV(qsemh_t qsemh)
 {
 	sem_t *semp = (sem_t *)qsemh;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	/* "V" the semaphore
 	 */
@@ -227,7 +225,7 @@ qsemPwouldblock(qsemh_t qsemh)
 {
 	sem_t *semp = (sem_t *)qsemh;
 	int count;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	rval = sem_getvalue(semp, &count);
 	assert(!rval);
@@ -240,7 +238,7 @@ qsemPavail(qsemh_t qsemh)
 {
 	sem_t *semp = (sem_t *)qsemh;
 	int count;
-	int rval;
+	__attribute__((unused)) int rval;
 
 	rval = sem_getvalue(semp, &count);
 	assert(!rval);
diff --git a/common/ring.c b/common/ring.c
index 7c6b499..ba15dfe 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -45,7 +45,7 @@ ring_create(size_t ringlen,
 	     void *clientctxp,
 	     int *rvalp)
 {
-	bool_t ok;
+	__attribute__((unused)) bool_t ok;
 	ring_t *ringp;
 	size_t mix;
 
diff --git a/dump/content.c b/dump/content.c
index 6462267..62a0f3f 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1082,8 +1082,7 @@ content_init(int argc,
 	 * values not dumped.
 	 */
 	if (inv_idbt != INV_TOKEN_NULL) {
-		/* REFERENCED */
-		bool_t ok1;
+		__attribute__((unused)) bool_t ok1;
 		ok = inv_lastsession_level_equalto(&fsid,
 						   inv_idbt,
 						   (u_char_t)sc_level,
@@ -1968,7 +1967,7 @@ create_inv_session(
 		ix_t subtreecnt,
 		size_t strmix)
 {
-	int rval;
+	__attribute__((unused)) int rval;
 	char *qmntpnt;
 	char *qfsdevice;
 
@@ -5504,8 +5503,7 @@ write_pad(drive_t *drivep, size_t sz)
 static void
 inv_cleanup(void)
 {
-	/* REFERENCED */
-	bool_t ok;
+	__attribute__((unused)) bool_t ok;
 
 	if (sc_inv_stmtokenp && sc_contextp) {
 		size_t strmix;
diff --git a/restore/content.c b/restore/content.c
index b916e39..b91e5f0 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -3246,8 +3246,7 @@ eatdirdump(drive_t *drivep,
 		for (;;) {
 			register direnthdr_t *dhdrp =
 					    (direnthdr_t *)direntbuf;
-			/* REFERENCED */
-			register size_t namelen;
+			__attribute__((unused)) size_t namelen;
 
 			rv = read_dirent(drivep,
 					  dhdrp,
@@ -3696,8 +3695,7 @@ wipepersstate(void)
 	}
 
 	while ((direntp = readdir64(dirp)) != 0) {
-		/* REFERENCED */
-		int len;
+		__attribute__((unused)) int len;
 		if (!strcmp(direntp->d_name, ".")) {
 			continue;
 		}
@@ -4924,8 +4922,7 @@ pi_allocdesc(dh_t *deschp)
 		ix_t newdescpgcnt = olddescpgcnt + DAU;
 		ix_t descppg = pgsz / PERS_DESCSZ;
 		ix_t descix;
-		/* REFERENCED */
-		int rval;
+		__attribute__((unused)) int rval;
 
 		/* first unmap if any existing descriptors
 		 */
@@ -8029,8 +8026,7 @@ read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	drive_ops_t *dop = drivep->d_opsp;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 	filehdr_t tmpfh;
 
@@ -8088,8 +8084,7 @@ static rv_t
 read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs)
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 	extenthdr_t tmpeh;
 
@@ -8151,8 +8146,7 @@ read_dirent(drive_t *drivep,
 {
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_ops_t *dop = drivep->d_opsp;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 	direnthdr_t tmpdh;
 	char *namep;    // beginning of name following the direnthdr_t
@@ -8273,8 +8267,7 @@ static rv_t
 read_extattrhdr(drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs)
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 	extattrhdr_t tmpah;
 
@@ -8345,8 +8338,7 @@ static rv_t
 discard_padding(size_t sz, drive_t *drivep)
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 
 	nread = read_buf(0,
@@ -8644,8 +8636,7 @@ restore_extattr(drive_t *drivep,
 	 */
 	for (;;) {
 		size_t recsz;
-		/* REFERENCED */
-		int nread;
+		__attribute__((unused)) int nread;
 		int rval;
 		rv_t rv;
 
@@ -9185,8 +9176,7 @@ static void
 pi_show(char *introstring)
 {
 	char strbuf[100];
-	/* REFERENCED */
-	int strbuflen;
+	__attribute__((unused)) int strbuflen;
 	fold_t fold;
 
 	if (mlog_level_ss[MLOG_SS_MEDIA] < MLOG_NITTY + 1) {
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 1f44cc0..b50384f 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -332,8 +332,7 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 void
 dirattr_cleanup(void)
 {
-	/* REFERENCED */
-	int rval;
+	__attribute__((unused)) int rval;
 
 	if (!dtp) {
 		return;
diff --git a/restore/inomap.c b/restore/inomap.c
index 13e1247..39c5ca0 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -191,11 +191,9 @@ inomap_restore_pers(drive_t *drivep,
 	hnk_t *pershnkp;
 	hnk_t *tmphnkp;
 	int fd;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
-	/* REFERENCED */
-	int rval1;
+	__attribute__((unused)) int rval1;
 	int i;
 	bool_t ok;
 
@@ -311,8 +309,7 @@ inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	uint64_t tmphnkcnt;
-	/* REFERENCED */
-	int nread;
+	__attribute__((unused)) int nread;
 	int rval;
 
 	/* get inomap info from media hdr
diff --git a/restore/tree.c b/restore/tree.c
index 4707fdc..7e79ef2 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -910,8 +910,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		if (hardp->n_flags & NF_ISDIR) {
 			nh_t renameh;
 			node_t *renamep;
-			/* REFERENCED */
-			int namebuflen;
+			__attribute__((unused)) int namebuflen;
 
 			hardp->n_flags |= NF_REFED;
 			if (hardp->n_parh == persp->p_orphh) {
@@ -1425,8 +1424,7 @@ noref_elim_recurse(nh_t parh,
 						path2,
 						_("tmp dir rename dst"));
 				if (!ok) {
-					/* REFERENCED */
-					nrh_t dummynrh;
+					__attribute__((unused)) nrh_t dummynrh;
 					dummynrh = disown(cldh);
 					assert(dummynrh == NRH_NULL);
 					adopt(parh, cldh, nrh);
@@ -1439,8 +1437,7 @@ noref_elim_recurse(nh_t parh,
 				      path2);
 				rval = rename(path1, path2);
 				if (rval) {
-					/* REFERENCED */
-					nrh_t dummynrh;
+					__attribute__((unused)) nrh_t dummynrh;
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to rename dir %s "
 					      "to dir %s: %s\n"),
@@ -1543,8 +1540,7 @@ noref_elim_recurse(nh_t parh,
 						path2,
 						_("tmp nondir rename dst"));
 				if (!ok) {
-					/* REFERENCED */
-					nrh_t dummynrh;
+					__attribute__((unused)) nrh_t dummynrh;
 					dummynrh = disown(cldh);
 					assert(dummynrh == NRH_NULL);
 					adopt(parh, cldh, nrh);
@@ -1557,8 +1553,7 @@ noref_elim_recurse(nh_t parh,
 				      path2);
 				rval = rename(path1, path2);
 				if (rval) {
-					/* REFERENCED */
-					nrh_t dummynrh;
+					__attribute__((unused)) nrh_t dummynrh;
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to rename nondir %s "
 					      "to nondir %s: %s\n"),
@@ -1577,8 +1572,7 @@ noref_elim_recurse(nh_t parh,
 				Node_unmap(cldh, &cldp);
 			}
 			if (canunlinkpr) {
-				/* REFERENCED */
-				nrh_t nrh;
+				__attribute__((unused)) nrh_t nrh;
 
 				assert(!mustorphpr);
 				if (isrealpr) {
@@ -1699,8 +1693,7 @@ rename_dirs(nh_t cldh,
 {
 	while (cldh != NH_NULL) {
 		node_t *cldp;
-		/* REFERENCED */
-		nh_t parh;
+		__attribute__((unused)) nh_t parh;
 		bool_t isdirpr;
 		nh_t renameh;
 		bool_t isrenamepr;
@@ -1720,8 +1713,7 @@ rename_dirs(nh_t cldh,
 		if (isrenamepr) {
 			node_t *renamep;
 			int rval;
-			/* REFERENCED */
-			nrh_t dummynrh;
+			__attribute__((unused)) nrh_t dummynrh;
 			bool_t ok;
 
 			renamep = Node_map(renameh);
@@ -2870,8 +2862,7 @@ tsi_cmd_pwd_recurse(void *ctxp,
 {
 	node_t *np;
 	register nh_t parh;
-	/* REFERENCED */
-	register int namelen;
+	__attribute__((unused)) int namelen;
 	nrh_t nrh;
 
 	assert(nh != NH_NULL);
@@ -2956,8 +2947,7 @@ tsi_cmd_ls(void *ctxp,
 		ino = cldp->n_ino;
 		Node_unmap(cldh, &cldp);
 		if (cldh != persp->p_orphh) {
-			/* REFERENCED */
-			int namelen;
+		__attribute__((unused))  int namelen;
 			namelen = namreg_get(nrh,
 					      tranp->t_inter.i_name,
 					      sizeof(tranp->t_inter.i_name));
@@ -3370,8 +3360,7 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			node_t *sibp;
 			nh_t nextsibh;
 			nrh_t nrh;
-			/* REFERENCED */
-			int siblen;
+			__attribute__((unused)) int siblen;
 
 			sibp = Node_map(sibh);
 			nrh = sibp->n_nrh;
@@ -3907,8 +3896,7 @@ link_matchh(nh_t hardh, nh_t parh, char *name)
 		nh_t nexth;
 		np = Node_map(hardh);
 		if (np->n_parh == parh) {
-			/* REFERENCED */
-			int namelen;
+		__attribute__((unused))	int namelen;
 			namelen = namreg_get(np->n_nrh,
 					      tranp->t_namebuf,
 					      sizeof(tranp->t_namebuf));
diff --git a/restore/win.c b/restore/win.c
index 5d40592..64dae1a 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -246,8 +246,7 @@ win_map(segix_t segix, void **pp)
 		assert(winp);
 		tranp->t_wincnt++;
 	} else if (tranp->t_lruheadp) {
-		/* REFERENCED */
-		int rval;
+		__attribute__((unused)) int rval;
 #ifdef TREE_DEBUG
 		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): get head from lru freelist & unmap\n");
-- 
2.47.3


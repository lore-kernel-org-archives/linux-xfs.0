Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA582C47E49
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BFF20867
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrJshMrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJZLSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:18:51 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37739 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfJZLSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 07:18:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so3466551pfo.4;
        Sat, 26 Oct 2019 04:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=lLv8EgteSH3j3fSA5Kfy8q7uu4MJGHgaBzCq1ot8+80=;
        b=VrJshMrswVNsknjHcE/7DINLBePyiy/OxT+RbVXLk+C4faVZDpyufCcmMDNuQZKf5/
         tT5dv74yLqeyPhctU9vZID7LYZQkBO3HQ1EZSUsEJ7hIivXMszpRbRqzO/e/InwGekew
         y8ATNlMNY2OCYhz2Fq0YEN4WcRHri04kAsDeDPFj8yTBC3XzEni/IMV0cRQgxZdm2J67
         Vr3wmx20MgGzpr3EVxXKFjZbfHIIApHIJzVkNCU0io3AuC8M31hqC5bzGZhwJ7ArLZM7
         MkW2IwCf9SPb2hFYBOQ7Nky3bFkhwVh8i2c71OC6dLwicblLvwTEmvgwnfgbBWjNmPF3
         7bpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=lLv8EgteSH3j3fSA5Kfy8q7uu4MJGHgaBzCq1ot8+80=;
        b=rF3PKuBR+pWlRmcv1WN0hoPUrGsdf2TXIaPr/y0RYjklDdpeL1j4VHWHsAh3gSDeIy
         kHgNI3E8UyZx8DAtMrFrPzVdkg26r8XBaNigRmOg2/PYIIVbnV2bW+tyYOqWKx1a0oX2
         +wEejldr0H1+QL6uvExkgllHOl17GN0BDxdBNXaf4IwzOt/otKNdwljfT7IWV08JMHGQ
         C6RPJqTocLXgy+5q6zcy2Ag79hiV6rHy0DXpZpb2cR6DKJFBA40sSB0jHPF7nZ4xOv+9
         3IRlZ7Hge/IgCBuP/ceTG5rpn1ZuGqv7+/7OkSwNu7inZBlNHG6uLkqLG9wzuw79M6CR
         HxUA==
X-Gm-Message-State: APjAAAXwwFGtD70v4h0KcWUmAAvMBf57BTMayI6CQQDFOpb8EacNKz86
        Y1wkv7AOkGTUDF9nYfGoXZmt2Jg=
X-Google-Smtp-Source: APXvYqyncMVZBIBkUpXsYVb1l4QfRf9ECTAEvzPNaL+5tFCB19OFbJVfOPaQ0iW9OzSSU2FbwSw48A==
X-Received: by 2002:a17:90a:86c7:: with SMTP id y7mr9877327pjv.82.1572088729681;
        Sat, 26 Oct 2019 04:18:49 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y2sm6104534pfe.126.2019.10.26.04.18.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 04:18:49 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v2 3/4] fsstress: add EXCHANGE renameat2 support
Date:   Sat, 26 Oct 2019 19:18:37 +0800
Message-Id: <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the EXCHANGE renameat2 syscall in fsstress.

In order to maintain filelist/filename integrity, we restrict
rexchange to files of the same type.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 ltp/fsstress.c | 92 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 21 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index ecc1adc..83d6337 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
 #ifndef RENAME_NOREPLACE
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
 #ifndef RENAME_WHITEOUT
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 #endif
@@ -115,6 +118,7 @@ typedef enum {
 	OP_REMOVEFATTR,
 	OP_RENAME,
 	OP_RNOREPLACE,
+	OP_REXCHANGE,
 	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
@@ -235,6 +239,7 @@ void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
 void	rnoreplace_f(int, long);
+void	rexchange_f(int, long);
 void	rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
@@ -296,6 +301,7 @@ opdesc_t	ops[] = {
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
 	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
 	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
@@ -371,7 +377,7 @@ void	del_from_flist(int, int);
 int	dirid_to_name(char *, int);
 void	doproc(void);
 int	fent_to_name(pathname_t *, flist_t *, fent_t *);
-void	fix_parent(int, int);
+void	fix_parent(int, int, bool);
 void	free_pathname(pathname_t *);
 int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
 int	generate_xattr_name(int, char *, int);
@@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
 }
 
 void
-fix_parent(int oldid, int newid)
+fix_parent(int oldid, int newid, bool swap)
 {
 	fent_t	*fep;
 	flist_t	*flp;
@@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
 		for (j = 0, fep = flp->fents; j < flp->nfiles; j++, fep++) {
 			if (fep->parent == oldid)
 				fep->parent = newid;
+			else if (swap && fep->parent == newid)
+				fep->parent = oldid;
 		}
 	}
 }
@@ -4256,6 +4264,7 @@ out:
 
 struct print_flags renameat2_flags [] = {
 	{ RENAME_NOREPLACE, "NOREPLACE"},
+	{ RENAME_EXCHANGE, "EXCHANGE"},
 	{ RENAME_WHITEOUT, "WHITEOUT"},
 	{ -1, NULL}
 };
@@ -4291,41 +4300,76 @@ do_renameat2(int opno, long r, int mode)
 		return;
 	}
 
-	/* get an existing directory for the destination parent directory name */
-	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
-		parid = -1;
-	else
-		parid = dfep->id;
-	v |= v1;
+	/*
+	 * Both pathnames must exist for the RENAME_EXCHANGE, and in
+	 * order to maintain filelist/filename integrity, we should
+	 * restrict exchange operation to files of the same type.
+	 */
+	if (mode == RENAME_EXCHANGE) {
+		which = 1 << (flp - flist);
+		init_pathname(&newf);
+		if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
+			if (v)
+				printf("%d/%d: rename - no target filename\n",
+					procid, opno);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+		v |= v1;
+		id = dfep->id;
+		parid = dfep->parent;
+	} else {
+		/*
+		 * Get an existing directory for the destination parent
+		 * directory name.
+		 */
+		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
+			parid = -1;
+		else
+			parid = dfep->id;
+		v |= v1;
 
-	/* generate a new path using an existing parent directory in name */
-	init_pathname(&newf);
-	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
-	v |= v1;
-	if (!e) {
-		if (v) {
-			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
-			printf("%d/%d: rename - no filename from %s\n",
-				procid, opno, f.path);
+		/*
+		 * Generate a new path using an existing parent directory
+		 * in name.
+		 */
+		init_pathname(&newf);
+		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
+		v |= v1;
+		if (!e) {
+			if (v) {
+				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
+				printf("%d/%d: rename - no filename from %s\n",
+					procid, opno, f.path);
+			}
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
 		}
-		free_pathname(&newf);
-		free_pathname(&f);
-		return;
 	}
 	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
+		bool swap = (mode == RENAME_EXCHANGE) ? true : false;
 
 		oldid = fep->id;
 		oldparid = fep->parent;
 
+		/*
+		 * Swap the parent ids for RENAME_EXCHANGE, and replace the
+		 * old parent id for the others.
+		 */
 		if (flp - flist == FT_DIR)
-			fix_parent(oldid, id);
+			fix_parent(oldid, id, swap);
 
 		if (mode == RENAME_WHITEOUT) {
 			fep->xattr_counter = 0;
 			add_to_flist(flp - flist, id, parid, xattr_counter);
+		} else if (mode == RENAME_EXCHANGE) {
+			fep->xattr_counter = dfep->xattr_counter;
+			dfep->xattr_counter = xattr_counter;
 		} else {
 			del_from_flist(flp - flist, fep - flp->fents);
 			add_to_flist(flp - flist, id, parid, xattr_counter);
@@ -4359,6 +4403,12 @@ rnoreplace_f(int opno, long r)
 }
 
 void
+rexchange_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_EXCHANGE);
+}
+
+void
 rwhiteout_f(int opno, long r)
 {
 	do_renameat2(opno, r, RENAME_WHITEOUT);
-- 
1.8.3.1


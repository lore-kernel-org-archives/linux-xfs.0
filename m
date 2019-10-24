Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2006CA9EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA23721D7E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACwS+YRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391402AbfJXOVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:21:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41294 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393910AbfJXOVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 10:21:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id l3so888666pgr.8;
        Thu, 24 Oct 2019 07:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=xVuudhrUPQOKU6TpXvgcEqgxHYwWQz+YQhLeG2kax1Q=;
        b=ACwS+YROyTlrF9WJJ1ndhb2gtcxRoYIcyrk70pqSLgYb13hNWeXOIEtzbUnDeK2oup
         t4qsLA/cSgQdA/U/pcwkXNfrOfK5dFX1XKliIOAo1rTRtRZK8tk0EAS1wPx08zkYyCHE
         81h0XE71pJmwaKjPVkVGCYcz7P0j20Rk4uFPa8EQk4AgD9w20q7xDalPHK1tNXVwbobl
         RGSK7pr6xYpHPdd4ueliSIgWLVjtGbkAInskivlZW9qvuZ3kXt97P5LPsAFibFoiKAhc
         nJ0D8qtcu/E9wTVHpX21NsK2kCP1wjwEzuaoxKcP2YImvCtB9J1JTK+u62dRh+J1MbBJ
         r2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=xVuudhrUPQOKU6TpXvgcEqgxHYwWQz+YQhLeG2kax1Q=;
        b=qRmZhGa+uRX8/s20MlT9qbzeTExHH2bV2qiR4JSLmkTLae0bQhx0WzAEIv3cv3gIHu
         ZJrmBF+7OMH2WLVLLaxVa47y1wU3/hyOEKUs0kMWjOrLE3hBI0fKOeyI/xYvDxZHnBRc
         a99ybmBKTumDxkXrI0FK0JwmBAs15yz9tzH/k8slCroEkX9VyvDKRitOnWr2DzF1MRTc
         FREFX4g50d/tAmHSv6ZXNmXYqJxHSwPjZg6WjKFDLeNRgmPQNJym+i0dqhtsIaCpvgA/
         GLK57nwYX4ocCO2BsOW/8KdOhnWKN/LOpzTua6/yiHCqnS8sH6/k8QrD+vJCim9mWpvm
         76Wg==
X-Gm-Message-State: APjAAAXKlOMtRWjCgfHmSAMBRX5zZICmlDXoftEB8mGhpq97iKa7L5SF
        bm1qu/WJfvFPtClpwNn2JFys8iQd+HQa
X-Google-Smtp-Source: APXvYqz4DOQiTaSouNXUp48eMY2SNTBxOSh4F4W0rRs/CSoPh7MCgHU1FeXEwTsHcQDQ5zpPAh6d4A==
X-Received: by 2002:a63:1606:: with SMTP id w6mr2032811pgl.245.1571926859795;
        Thu, 24 Oct 2019 07:20:59 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id i11sm24368284pgd.7.2019.10.24.07.20.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:20:59 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH 3/4] fsstress: add EXCHANGE renameat2 support
Date:   Thu, 24 Oct 2019 22:20:50 +0800
Message-Id: <71744e89979dfd25f1bffc44c70f6df214a5477b.1571926791.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the EXCHANGE renameat2 syscall in fsstress.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 ltp/fsstress.c | 86 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 5059639..958adf9 100644
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
+void	fix_parent(int, int, int);
 void	free_pathname(pathname_t *);
 int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
 int	generate_xattr_name(int, char *, int);
@@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
 }
 
 void
-fix_parent(int oldid, int newid)
+fix_parent(int oldid, int newid, int swap)
 {
 	fent_t	*fep;
 	flist_t	*flp;
@@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
 		for (j = 0, fep = flp->fents; j < flp->nfiles; j++, fep++) {
 			if (fep->parent == oldid)
 				fep->parent = newid;
+			if (swap && fep->parent == newid)
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
@@ -4291,41 +4300,68 @@ do_renameat2(int opno, long r, int mode)
 		return;
 	}
 
-	/* get an existing directory for the destination parent directory name */
-	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
-		parid = -1;
-	else
-		parid = dfep->id;
-	v |= v1;
+	/* Both pathnames must exist for the RENAME_EXCHANGE */
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
+		 * get an existing directory for the destination parent
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
+		 * generate a new path using an existing parent directory
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
+		int swap = (mode == RENAME_EXCHANGE) ? 1 : 0;
 
 		oldid = fep->id;
 		oldparid = fep->parent;
 
 		if (flp - flist == FT_DIR)
-			fix_parent(oldid, id);
+			fix_parent(oldid, id, swap);
 
 		if (mode == RENAME_WHITEOUT)
 			add_to_flist(flp - flist, id, parid, xattr_counter);
-		else {
+		else if (mode == RENAME_EXCHANGE) {
+			fep->xattr_counter = dfep->xattr_counter;
+			dfep->xattr_counter = xattr_counter;
+		} else {
 			del_from_flist(flp - flist, fep - flp->fents);
 			add_to_flist(flp - flist, id, parid, xattr_counter);
 		}
@@ -4358,6 +4394,12 @@ rnoreplace_f(int opno, long r)
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


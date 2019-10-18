Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B17CA9EA1
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 09:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF605222C5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 09:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JL92D3z0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392761AbfJRJ6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:58:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38734 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389081AbfJRJ6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Oct 2019 05:58:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so3557785pfe.5;
        Fri, 18 Oct 2019 02:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pL8ykawI17LOx8kqE9qCutKPqKIeU/yxymH4rv3Qa/4=;
        b=JL92D3z02/UimOm+n4rHH5bmQ2yRVbO/tthJGonmxKAlLfFO4Tzo2lp7osf9Kmn9qC
         Vvnu+oUKjI1RTOAi8956VLJJWwZ+H8/3uN3kMrU3bUH6p+SUClo7AKWzTWLqirv78hYk
         1blAKAT+lVj/r7x67O1MhexHYIDsTv8i4RSfMQ8UuFvCmqOGyi7TxIhOLZC+HWKSMNrv
         xEYlC++byu5M8nN17z2//P2PPjgZt92Iky7Wru+DKNvbAsZm3SPjqWsDkHuYOkAXGMYd
         oQFGHh7aDTD1tw7qVAYd96PXXsnLfifH/aF7N1xF+t+0C94Kmzpp6p2eW2vd8kDMWzQC
         3cxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pL8ykawI17LOx8kqE9qCutKPqKIeU/yxymH4rv3Qa/4=;
        b=KrHycN0ouxzhGA91HDqheqOJgHvmf+W968dWfKniaNJ+2CtoaVcaE5k74wKW5XeUee
         m//7hqgJk0IWRrtMA00JDDZz9w0V+vW18SAIV0YudKWT8kfPOa3PwT4AHszcd2BV1bTh
         THwbmNKT3zthZNsw2x4G7fnORiXlnlqi5fBANK9xaxtPfMgnZ7JicBEwJXB2evtn4TT0
         YkdKXjou4SPi8TT63pjYx+JmULzmXsEhDg31mjGHoiTGRCckVBWVfDxLbRzxxH0t0Ap9
         78BhR1gMlo9hfc5nNQw9yQMmpnRHB2It5ybU5+7oXhMDiVIoJbyeloUr53n9kWm9WmDc
         XR7g==
X-Gm-Message-State: APjAAAXpIyD3Bo5egdiJe8wG4mDL3krnRa/YYjqdqgjKHhz+275Szl5a
        0ksP5wfLYHZ866dA51VgpA==
X-Google-Smtp-Source: APXvYqypgj0latnjQn6uJNRm9DH4PH3/o3lx8CfhXokSWXU4EZLUt/ClojEZFII9H0GZMjyFUjRmUg==
X-Received: by 2002:aa7:838f:: with SMTP id u15mr5506672pfm.13.1571392680956;
        Fri, 18 Oct 2019 02:58:00 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id p11sm5435221pgs.51.2019.10.18.02.57.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 02:58:00 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v4] fsstress: add renameat2 support
Message-ID: <5df7cc7b-31b4-69e2-f623-83a2c90bfca7@gmail.com>
Date:   Fri, 18 Oct 2019 17:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the renameat2 syscall in fsstress.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
Changes in v4:
 -Fix long line((> 80 characters) problem.
 -Fix the RENAME_WHITEOUT RENAME_EXCHANGE file flist problem.

 ltp/fsstress.c | 174 +++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 143 insertions(+), 31 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..f268a5a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -44,6 +44,38 @@ io_context_t	io_ctx;
 #define IOV_MAX 1024
 #endif
 
+#ifndef HAVE_RENAMEAT2
+#if !defined(SYS_renameat2) && defined(__x86_64__)
+#define SYS_renameat2 316
+#endif
+
+#if !defined(SYS_renameat2) && defined(__i386__)
+#define SYS_renameat2 353
+#endif
+
+static int renameat2(int dfd1, const char *path1,
+		     int dfd2, const char *path2,
+		     unsigned int flags)
+{
+#ifdef SYS_renameat2
+	return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+#endif
+
+#ifndef RENAME_NOREPLACE
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+#endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#endif
+
 #define FILELEN_MAX		(32*4096)
 
 typedef enum {
@@ -85,6 +117,9 @@ typedef enum {
 	OP_READV,
 	OP_REMOVEFATTR,
 	OP_RENAME,
+	OP_RNOREPLACE,
+	OP_REXCHANGE,
+	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
@@ -203,6 +238,9 @@ void	readlink_f(int, long);
 void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
+void    rnoreplace_f(int, long);
+void    rexchange_f(int, long);
+void    rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
@@ -262,6 +300,9 @@ opdesc_t	ops[] = {
 	/* remove (delete) extended attribute */
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
+	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
+	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
@@ -354,7 +395,7 @@ int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
 int	readlink_path(pathname_t *, char *, size_t);
-int	rename_path(pathname_t *, pathname_t *);
+int	rename_path(pathname_t *, pathname_t *, int);
 int	rmdir_path(pathname_t *);
 void	separate_pathname(pathname_t *, char *, pathname_t *);
 void	show_ops(int, char *);
@@ -1519,7 +1560,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 }
 
 int
-rename_path(pathname_t *name1, pathname_t *name2)
+rename_path(pathname_t *name1, pathname_t *name2, int mode)
 {
 	char		buf1[NAME_MAX + 1];
 	char		buf2[NAME_MAX + 1];
@@ -1528,14 +1569,18 @@ rename_path(pathname_t *name1, pathname_t *name2)
 	pathname_t	newname2;
 	int		rval;
 
-	rval = rename(name1->path, name2->path);
+	if (mode == 0)
+		rval = rename(name1->path, name2->path);
+	else
+		rval = renameat2(AT_FDCWD, name1->path,
+				 AT_FDCWD, name2->path, mode);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name1, buf1, &newname1);
 	separate_pathname(name2, buf2, &newname2);
 	if (strcmp(buf1, buf2) == 0) {
 		if (chdir(buf1) == 0) {
-			rval = rename_path(&newname1, &newname2);
+			rval = rename_path(&newname1, &newname2, mode);
 			assert(chdir("..") == 0);
 		}
 	} else {
@@ -1555,7 +1600,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1608,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,10 +4260,21 @@ out:
 	free_pathname(&f);
 }
 
+struct print_flags renameat2_flags [] = {
+	{ RENAME_NOREPLACE, "NOREPLACE"},
+	{ RENAME_EXCHANGE, "EXCHANGE"},
+	{ RENAME_WHITEOUT, "WHITEOUT"},
+	{ -1, NULL}
+};
+
+#define translate_renameat2_flags(mode)	\
+	({translate_flags(mode, "|", renameat2_flags);})
+
 void
-rename_f(int opno, long r)
+do_renameat2(int opno, long r, int mode)
 {
 	fent_t		*dfep;
+	flist_t		*dflp;
 	int		e;
 	pathname_t	f;
 	fent_t		*fep;
@@ -4234,33 +4290,56 @@ rename_f(int opno, long r)
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
 		if (v1)
-			printf("%d/%d: rename - no filename\n", procid, opno);
+			printf("%d/%d: rename - no source filename\n",
+				procid, opno);
 		free_pathname(&f);
 		return;
 	}
+	/* Both pathnames must exist for the RENAME_EXCHANGE */
+	if (mode == RENAME_EXCHANGE) {
+		init_pathname(&newf);
+		if (!get_fname(FT_ANYm, random(), &newf, &dflp, &dfep, &v)) {
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
 
-	/* get an existing directory for the destination parent directory name */
-	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
-		parid = -1;
-	else
-		parid = dfep->id;
-	v |= v1;
-
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
-	e = rename_path(&f, &newf) < 0 ? errno : 0;
+
+	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
@@ -4269,16 +4348,26 @@ rename_f(int opno, long r)
 			oldid = fep->id;
 			fix_parent(oldid, id);
 		}
+
+		if (mode == RENAME_WHITEOUT)
+			add_to_flist(FT_DEV, fep->id, fep->parent, 0);
+		else if (mode == RENAME_EXCHANGE) {
+			del_from_flist(dflp - flist, dfep - dflp->fents);
+			add_to_flist(dflp - flist, fep->id, fep->parent,
+				     dfep->xattr_counter);
+		}
+
 		del_from_flist(flp - flist, fep - flp->fents);
 		add_to_flist(flp - flist, id, parid, xattr_counter);
 	}
 	if (v) {
-		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
+		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
+			opno, translate_renameat2_flags(mode), f.path,
 			newf.path, e);
 		if (e == 0) {
-			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
 				procid, opno, fep->id, fep->parent);
-			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
 				procid, opno, id, parid);
 		}
 	}
@@ -4287,6 +4376,29 @@ rename_f(int opno, long r)
 }
 
 void
+rename_f(int opno, long r)
+{
+	do_renameat2(opno, r, 0);
+}
+void
+rnoreplace_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_NOREPLACE);
+}
+
+void
+rexchange_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_EXCHANGE);
+}
+
+void
+rwhiteout_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_WHITEOUT);
+}
+
+void
 resvsp_f(int opno, long r)
 {
 	int		e;
-- 
1.8.3.1

-- 
kaixuxia

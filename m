Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321F3CA9EBE
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0969C20867
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGqenShq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfJZLSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:18:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38757 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfJZLSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 07:18:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so3364063pgt.5;
        Sat, 26 Oct 2019 04:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HsvcNjNluqtfPfMVqS46MCGIHAgDYavZFQOkbT5TXhU=;
        b=jGqenShqc4sBV6AClDtuAKImPAvglAXH4pkjYXBShn47DamcM8dlIKlnnPW1P73mIF
         VWCxsSNvDwi1MlTiduuVfUcFd82ANUxVfgcD9hX5qxcQu/bjZgmmn3PY0FbzYkxliWsg
         k/HJwVt+uxGPQWOQwVtgMbbIB3XjjPIoHw/drYVUNMOkvA70wkhOxEkVqXTw0A2E6uGy
         YCQQuARzp2UQSvbSSFsi5mBCBe2QtPu/OjrgpNQaRrrWFRPwi8yhrmrlTPNp9bfdt4IP
         uB1+OMT+4DaYZdxoR1ZHKDvqeaIf58WbW7vBbcgsP0K46ctF8q63dNKM0JVWY07ZDs03
         Hcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HsvcNjNluqtfPfMVqS46MCGIHAgDYavZFQOkbT5TXhU=;
        b=XBGeeYuNcQyKVypBfWILiLQVQU6hL+J3rVgq9EIiQz3eWwe5nF1v8s/DRZ0Nfvr16E
         ZNgMYsbNTdPg6jyjJLPsde9UTCjLcBYTKTZ0xVp6D4d9bQ3+DtwZog4N5ZGzlxMGny9C
         93kTnAijYYNCdYIavfHnMaYp3daOuEhSNMotzChcltSoWMXEAf1zrz3GRRDeCM+blc+T
         vv+ZuIbLasqKlsTVYpI+RPdWHQA89xi9BJ6Le6B+3TSdEFvjuaa7MtihJF6ul88cqBL/
         oBzSPbWfYipr/nQUWYPkgSJHVZoSj8+gyVWfN+AJpxPmaUJGVxlKqHDfAPJkp8uVOzAD
         aNOg==
X-Gm-Message-State: APjAAAWNz+TUcC4ownYoKYLNdGpkZ3NDZLnwN57OJm1RO8IWYkm7q4MN
        vPNY4VGhZZSYuWR+bzPwPF0bNrw=
X-Google-Smtp-Source: APXvYqyAFB0Uu6/koQuMmmFVz0O4/xiK2JYAHxGo3RabouVCJMWSxHkGnLRHOiJj3e43WBmVR/pOqg==
X-Received: by 2002:a63:1e1f:: with SMTP id e31mr240351pge.303.1572088728882;
        Sat, 26 Oct 2019 04:18:48 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y2sm6104534pfe.126.2019.10.26.04.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 04:18:48 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v2 2/4] fsstress: add NOREPLACE and WHITEOUT renameat2 support
Date:   Sat, 26 Oct 2019 19:18:36 +0800
Message-Id: <f7b2754cc5648b70379357d6210a4dc194e44de0.1572057903.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the renameat2(NOREPLACE and WHITEOUT) syscall in fsstress.

The fent id correlates with filename and the filename correlates
to type in flist, and the RWHITEOUT operation would leave a dev
node around with whatever the name of the source file was, so in
order to maintain filelist/filename integrity, we should restrict
RWHITEOUT source file to device nodes.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 ltp/fsstress.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 90 insertions(+), 15 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 95285f1..ecc1adc 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -44,6 +44,35 @@ io_context_t	io_ctx;
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
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#endif
+
 #define FILELEN_MAX		(32*4096)
 
 typedef enum {
@@ -85,6 +114,8 @@ typedef enum {
 	OP_READV,
 	OP_REMOVEFATTR,
 	OP_RENAME,
+	OP_RNOREPLACE,
+	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
@@ -203,6 +234,8 @@ void	readlink_f(int, long);
 void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
+void	rnoreplace_f(int, long);
+void	rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
@@ -262,6 +295,8 @@ opdesc_t	ops[] = {
 	/* remove (delete) extended attribute */
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
+	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
@@ -354,7 +389,7 @@ int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
 int	readlink_path(pathname_t *, char *, size_t);
-int	rename_path(pathname_t *, pathname_t *);
+int	rename_path(pathname_t *, pathname_t *, int);
 int	rmdir_path(pathname_t *);
 void	separate_pathname(pathname_t *, char *, pathname_t *);
 void	show_ops(int, char *);
@@ -1519,7 +1554,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 }
 
 int
-rename_path(pathname_t *name1, pathname_t *name2)
+rename_path(pathname_t *name1, pathname_t *name2, int mode)
 {
 	char		buf1[NAME_MAX + 1];
 	char		buf2[NAME_MAX + 1];
@@ -1528,14 +1563,18 @@ rename_path(pathname_t *name1, pathname_t *name2)
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
@@ -1555,7 +1594,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1602,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,8 +4254,17 @@ out:
 	free_pathname(&f);
 }
 
+struct print_flags renameat2_flags [] = {
+	{ RENAME_NOREPLACE, "NOREPLACE"},
+	{ RENAME_WHITEOUT, "WHITEOUT"},
+	{ -1, NULL}
+};
+
+#define translate_renameat2_flags(mode)        \
+	({translate_flags(mode, "|", renameat2_flags);})
+
 void
-rename_f(int opno, long r)
+do_renameat2(int opno, long r, int mode)
 {
 	fent_t		*dfep;
 	int		e;
@@ -4228,14 +4276,17 @@ rename_f(int opno, long r)
 	int		oldid;
 	int		parid;
 	int		oldparid;
+	int		which;
 	int		v;
 	int		v1;
 
 	/* get an existing path for the source of the rename */
 	init_pathname(&f);
-	if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
+	which = (mode == RENAME_WHITEOUT) ? FT_DEVm : FT_ANYm;
+	if (!get_fname(which, r, &f, &flp, &fep, &v1)) {
 		if (v1)
-			printf("%d/%d: rename - no filename\n", procid, opno);
+			printf("%d/%d: rename - no source filename\n",
+				procid, opno);
 		free_pathname(&f);
 		return;
 	}
@@ -4261,7 +4312,7 @@ rename_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
-	e = rename_path(&f, &newf) < 0 ? errno : 0;
+	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
@@ -4272,16 +4323,22 @@ rename_f(int opno, long r)
 		if (flp - flist == FT_DIR)
 			fix_parent(oldid, id);
 
-		del_from_flist(flp - flist, fep - flp->fents);
-		add_to_flist(flp - flist, id, parid, xattr_counter);
+		if (mode == RENAME_WHITEOUT) {
+			fep->xattr_counter = 0;
+			add_to_flist(flp - flist, id, parid, xattr_counter);
+		} else {
+			del_from_flist(flp - flist, fep - flp->fents);
+			add_to_flist(flp - flist, id, parid, xattr_counter);
+		}
 	}
 	if (v) {
-		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
+		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
+			opno, translate_renameat2_flags(mode), f.path,
 			newf.path, e);
 		if (e == 0) {
-			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
 				procid, opno, oldid, oldparid);
-			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
 				procid, opno, id, parid);
 		}
 	}
@@ -4290,6 +4347,24 @@ rename_f(int opno, long r)
 }
 
 void
+rename_f(int opno, long r)
+{
+	do_renameat2(opno, r, 0);
+}
+
+void
+rnoreplace_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_NOREPLACE);
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


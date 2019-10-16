Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB1FFA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 12:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A56E321925
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 12:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhjqyHs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfJPM2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:28:50 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39112 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJPM2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 08:28:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so11205618plp.6;
        Wed, 16 Oct 2019 05:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1wCk9XUoI3BdIB/CiMTBuCvX8NBvPhCPWNLOU20CrRg=;
        b=HhjqyHs3z2VsozG6RJWoXbJIlgyoR+kSwzcpiVPiSlKmT7NOOaNJk1TZckqmnmexde
         u4UClrZPVopyppK5zK5IfPGCr9ccYQUiefT0YOl80XGIPVam2TOvTSw1yHndxKG1yyL/
         GuFL4IJ4wudnVKu3XylSx0oUDE+bVymtL1V/N+UftgId/DqfqW0Cmwbv/H9E7PbeLepq
         F2Cm+5gO0LRcjv6hmkQnyTc6jy6onPeKvaDlwaN7Thr6HnHpSQ78/PI3TRQ/E1p6OMX+
         IaI9hgfrJwFDmAgNFEEXX6dJFG467P2qdQPZWaro7ygZVVax1gkHBxBZzZvx8CIpPY+H
         5UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1wCk9XUoI3BdIB/CiMTBuCvX8NBvPhCPWNLOU20CrRg=;
        b=BxP75N6XMUa1ssmqtE45h0aGfKGWhKQGiGqPTWtIx7gQJ1xbsJgIPZ+G8otZRLwOQt
         xRvh98qGNtzpmkRTJp5B45Ro0SW4yU1Yux+7MPkKNHqBJxHaDejgFK6ZN1H5pVht0uYL
         DjXN9eDhIPc+Uqs2wj0Zhwo070bhT4YyTz35GcJazOnDJLhNWrFDreZKo7MuuoIXqX/M
         LbWtKqLS3TrPy1p9bive3nFs1wnxGvpKs7fvbEKMbbm0xhOwtRLg0FUXHqakrbgMJM8x
         qLFvVLB579KA5vQ6uq3Fr7DDOhEvFAxCobr84vInH53UaOzR1EOdScT3G1Rfuw0WMOze
         B4kg==
X-Gm-Message-State: APjAAAXGZM3y3GrGGLakJkrr8Wm0Ta1u7OVE9Jq/Ky9fCIQYMBcTR0lH
        CzqBufPHbBfZ/m3diGkILw==
X-Google-Smtp-Source: APXvYqw3DrOYAe4/UrqN9uJ7+xRl4oo/pycoytmv2pggKl6blKlzbJmQpwveteOdxfhCSUESzphcmw==
X-Received: by 2002:a17:902:b94b:: with SMTP id h11mr40770719pls.21.1571228927462;
        Wed, 16 Oct 2019 05:28:47 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id r18sm33094774pfc.3.2019.10.16.05.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:28:47 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v2] fsstress: add renameat2 support
Message-ID: <92911289-a58a-8f16-e003-d6a1cea3720b@gmail.com>
Date:   Wed, 16 Oct 2019 20:28:44 +0800
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
 ltp/fsstress.c | 155 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 122 insertions(+), 33 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..5d39695 100644
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
@@ -1528,14 +1569,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
 	pathname_t	newname2;
 	int		rval;
 
-	rval = rename(name1->path, name2->path);
+	rval = renameat2(AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);
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
@@ -1555,7 +1596,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1604,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,8 +4256,18 @@ out:
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
 	int		e;
@@ -4234,35 +4285,49 @@ rename_f(int opno, long r)
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
 		if (v1)
-			printf("%d/%d: rename - no filename\n", procid, opno);
+			printf("%d/%d: rename - no source filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-
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
+	/* Both pathnames must exist for the RENAME_EXCHANGE */
+	if (mode == RENAME_EXCHANGE) {
+		init_pathname(&newf);
+		if (!get_fname(FT_ANYm, random(), &newf, NULL, &dfep, &v1)) {
+			if (v1)
+				printf("%d/%d: rename - no target filename\n", procid, opno);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+		id = dfep->id;
+		parid = dfep->parent;
+	} else {
+		/* get an existing directory for the destination parent directory name */
+		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
+			parid = -1;
+		else
+			parid = dfep->id;
+		v |= v1;
+
+		/* generate a new path using an existing parent directory in name */
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
-	if (e == 0) {
+	if (e == 0 && mode != RENAME_EXCHANGE) {
 		int xattr_counter = fep->xattr_counter;
 
 		if (flp - flist == FT_DIR) {
@@ -4273,12 +4338,13 @@ rename_f(int opno, long r)
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
@@ -4287,6 +4353,29 @@ rename_f(int opno, long r)
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

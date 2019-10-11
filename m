Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4ECC47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 07:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472DD21D7D
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 07:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWeZGAeE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfJKH4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 03:56:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45582 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfJKH4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 03:56:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so4121930pgj.12;
        Fri, 11 Oct 2019 00:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A/9gFRCb7LHRiD9Prqgmme6FxhbIhRheSsCOGcqKehM=;
        b=LWeZGAeEPr1see5wqeeCyGtLp9eQTQ9zuLKmrUcg10JHnAh7nWllI8VH0KpVkZNQJ6
         +RHe2nINHpDKNVUqr/wsnpPFpY3WCbUhjVxmJ2rnE4+nxWbJzosffBJSYcUMwIIQuan8
         TeHSBfyngvcUZn62YYuKcMmyjxY3lEzSlBuP3imQl2PfgQBuOA5nH0Eoj/O+Gx6sjK84
         0vG0M8yhCKQnT7VGGfMrMKToJVVhZaxgV0yyFRIW36jEIsChGQ5Ew5vSFb5BhmAWYKEf
         xmFzVnXR3G6/+KO4igrFoKWMz1PH70UH5vaF+VN+7pVS8nlGQApQGvVlbCmOrLgcGXaK
         2jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A/9gFRCb7LHRiD9Prqgmme6FxhbIhRheSsCOGcqKehM=;
        b=CqCpo7RhsC/FF/esaWaI0mLd7sYRYDCLaT+I0sBRwMbN2YpPI4yYmNcuJN8o3dAL5S
         jlpaPYVgEIpbmL7keghJJlW1EtE+KwK5bB0WBX8MHptTjlCHOCtCHXtvf9EA+IzzM6f9
         tp0JEynOgnED00mWJhXABzmZAWqYG5sdgk2yD8JkevI29Y2SJ0hHfVlw9wqidFJFOQuB
         8T+t+DtD2cOb8XNLpUsiVhjMqYwfa1uRHvM6+hB/pHaNvQOBrn9vG/pXmanidTPkqmga
         Thq2Qy8lCzV2ZqtMjqr0jUmaepi/ccHwQExMFo6vCj3sv/v/xJFn1TxnU1XDSwLS8syN
         wa+A==
X-Gm-Message-State: APjAAAV0/fnNl1lZW5aO/74wSlP23gTJ6XEHnVCbjUlxCnqMSzg4bGyO
        tidFPTAO4l5F3kP+lnY6vQ==
X-Google-Smtp-Source: APXvYqyr6EB6mLW9N6cH47ifZZ8nru0JlTcBRG9xrO4iYQnk/J6XvkKA7qErtHUO0pbvlkvPQaVBAA==
X-Received: by 2002:a63:f5a:: with SMTP id 26mr2934559pgp.63.1570780566390;
        Fri, 11 Oct 2019 00:56:06 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id v12sm6983527pgr.31.2019.10.11.00.56.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 00:56:05 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] fsstress: add renameat2 support
Message-ID: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
Date:   Fri, 11 Oct 2019 15:56:01 +0800
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
 ltp/fsstress.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 11 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..21529a2 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -44,6 +44,16 @@ io_context_t	io_ctx;
 #define IOV_MAX 1024
 #endif
 
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
@@ -85,6 +95,9 @@ typedef enum {
 	OP_READV,
 	OP_REMOVEFATTR,
 	OP_RENAME,
+	OP_RNOREPLACE,
+	OP_REXCHANGE,
+	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
@@ -203,6 +216,9 @@ void	readlink_f(int, long);
 void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
+void    rnoreplace_f(int, long);
+void    rexchange_f(int, long);
+void    rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
@@ -262,6 +278,9 @@ opdesc_t	ops[] = {
 	/* remove (delete) extended attribute */
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
+	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
+	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
@@ -354,7 +373,7 @@ int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
 int	readlink_path(pathname_t *, char *, size_t);
-int	rename_path(pathname_t *, pathname_t *);
+int	rename_path(pathname_t *, pathname_t *, int);
 int	rmdir_path(pathname_t *);
 void	separate_pathname(pathname_t *, char *, pathname_t *);
 void	show_ops(int, char *);
@@ -1519,7 +1538,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 }
 
 int
-rename_path(pathname_t *name1, pathname_t *name2)
+rename_path(pathname_t *name1, pathname_t *name2, int mode)
 {
 	char		buf1[NAME_MAX + 1];
 	char		buf2[NAME_MAX + 1];
@@ -1528,14 +1547,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
 	pathname_t	newname2;
 	int		rval;
 
-	rval = rename(name1->path, name2->path);
+	rval = syscall(__NR_renameat2, AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);
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
@@ -1555,7 +1574,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1582,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,8 +4234,18 @@ out:
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
@@ -4229,6 +4258,7 @@ rename_f(int opno, long r)
 	int		parid;
 	int		v;
 	int		v1;
+	int		fd;
 
 	/* get an existing path for the source of the rename */
 	init_pathname(&f);
@@ -4260,7 +4290,21 @@ rename_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
-	e = rename_path(&f, &newf) < 0 ? errno : 0;
+	/* Both pathnames must exist for the RENAME_EXCHANGE */
+	if (mode == RENAME_EXCHANGE) {
+		fd = creat_path(&newf, 0666);
+		e = fd < 0 ? errno : 0;
+		check_cwd();
+		if (fd < 0) {
+			if (v)
+				printf("%d/%d: renameat2 - creat %s failed %d\n",
+					procid, opno, newf.path, e);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+	}
+	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
@@ -4273,12 +4317,13 @@ rename_f(int opno, long r)
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
@@ -4287,6 +4332,29 @@ rename_f(int opno, long r)
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

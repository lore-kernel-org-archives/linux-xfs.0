Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C497AC47E49
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 12:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE4A21928
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 12:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rbbi6vSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbfJVMTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 08:19:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35868 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387675AbfJVMTm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 08:19:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so9850420pgk.3;
        Tue, 22 Oct 2019 05:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5TWIVz7dgKnzZqk1U/p/q+JiLakN6F7Bx/i+wT50caM=;
        b=rbbi6vShoSRaGNU2h3v+gwDu4PmD2V+k69qbZhziaRkK6bYJ1G5o9W14eWdCcejk3U
         uJSgZ44ZKuEv44s9WCEghU8f5wF/7UyPGzW3Bz2/U964EKAbhA53qj2CUgj/WjLPhfaJ
         Q7GTTKrpCyRTBOXyfTQouAIlSvqDaG1ZVuEUEf+kceAlR421Q44CepAn91VkiWx69CPb
         u15ehIFaZadwsl/VqqlBeblNGWRoKiVv3JfCPwTqyfZrGq/1m01yZ7ftKM5OofK/8T4w
         QqGXW1inGsSpxfLE9bKq4GGbJ2IJBTtpJCoAmQ9T/ADbaGev4gcCYUNgm87D7VnVY9fO
         adKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5TWIVz7dgKnzZqk1U/p/q+JiLakN6F7Bx/i+wT50caM=;
        b=cf/N/PD0v9iNdpT7RAQJsQwFQ9WygSDiamGcwNAy7De6LuZejBUk1R6dF7ac8com9T
         /IHw/PKiHJxhN+mRaXojbDt0eLb90uiBhaHfkEcrb3U9mpwyRx/lTrNLpljIaYXuHQOa
         KSXwwyl00LdwOlW3t3ZblSh9HGGThOUCb9STzy41b1nkBMnY5B0kK+MLrTITnJCz6wxF
         TW4Do1AQWeaCWqKUHpuyu1Nvov4xDVmZQIYQpPH23hliQRPsIVAYcGWzeAMEBYbDg46g
         H4t5A6APvNBHNIpHSfTjDlGKkOsVwGJxkhF6t9sZE0RL5zB7cwhBRLwGqYh7q+TOz35m
         lwag==
X-Gm-Message-State: APjAAAVn18ufoxUdD+UeCh0hLePHvY3xdWyKicCYkAJb6r5OAYe54MAQ
        I9aYK8rgmvC16gthXDkAXQ==
X-Google-Smtp-Source: APXvYqxG0twRUtGj2kmngxbid8m7ForXO/IP5qnpsggjyEHXH5+yEu+aHBGkVerCbZSPLGocW72r1g==
X-Received: by 2002:aa7:87d9:: with SMTP id i25mr4074261pfo.244.1571746781641;
        Tue, 22 Oct 2019 05:19:41 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id x11sm33728446pja.3.2019.10.22.05.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 05:19:41 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v5] fsstress: add renameat2 support
Message-ID: <a602433c-ec36-a607-e1bc-6e532e3ebaca@gmail.com>
Date:   Tue, 22 Oct 2019 20:19:37 +0800
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
Changes in v5:
 - Fix the RENAME_EXCHANGE flist fents swap problem.

 ltp/fsstress.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 169 insertions(+), 33 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..7c59f2d 100644
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
@@ -321,6 +362,7 @@ int		execute_freq = 1;
 struct print_string	flag_str = {0};
 
 void	add_to_flist(int, int, int, int);
+void	swap_flist_fents(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
 int	attr_remove_path(pathname_t *, const char *, int);
@@ -354,7 +396,7 @@ int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
 int	readlink_path(pathname_t *, char *, size_t);
-int	rename_path(pathname_t *, pathname_t *);
+int	rename_path(pathname_t *, pathname_t *, int);
 int	rmdir_path(pathname_t *);
 void	separate_pathname(pathname_t *, char *, pathname_t *);
 void	show_ops(int, char *);
@@ -758,6 +800,24 @@ add_to_flist(int ft, int id, int parent, int xattr_counter)
 }
 
 void
+swap_flist_fents(int ft, int slot, int dft, int dslot)
+{
+	flist_t *ftp;
+	flist_t *dftp;
+	fent_t	tmpfent;
+
+	ftp = &flist[ft];
+	dftp = &flist[dft];
+	if (ft == FT_DIR)
+		dcache_purge(ftp->fents[slot].id);
+	if (dft == FT_DIR)
+		dcache_purge(dftp->fents[dslot].id);
+	tmpfent = ftp->fents[slot];
+	ftp->fents[slot] = dftp->fents[dslot];
+	dftp->fents[dslot] = tmpfent;
+}
+
+void
 append_pathname(pathname_t *name, char *str)
 {
 	int	len;
@@ -1519,7 +1579,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 }
 
 int
-rename_path(pathname_t *name1, pathname_t *name2)
+rename_path(pathname_t *name1, pathname_t *name2, int mode)
 {
 	char		buf1[NAME_MAX + 1];
 	char		buf2[NAME_MAX + 1];
@@ -1528,14 +1588,18 @@ rename_path(pathname_t *name1, pathname_t *name2)
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
@@ -1555,7 +1619,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1627,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,10 +4279,21 @@ out:
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
@@ -4234,33 +4309,56 @@ rename_f(int opno, long r)
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
@@ -4269,16 +4367,31 @@ rename_f(int opno, long r)
 			oldid = fep->id;
 			fix_parent(oldid, id);
 		}
-		del_from_flist(flp - flist, fep - flp->fents);
-		add_to_flist(flp - flist, id, parid, xattr_counter);
+
+		if (mode == RENAME_WHITEOUT) {
+			add_to_flist(FT_DEV, fep->id, fep->parent, 0);
+			del_from_flist(flp - flist, fep - flp->fents);
+			add_to_flist(flp - flist, id, parid, xattr_counter);
+		} else if (mode == RENAME_EXCHANGE) {
+			if (dflp - flist == FT_DIR) {
+				oldid = dfep->id;
+				fix_parent(oldid, fep->id);
+			}
+			swap_flist_fents(flp - flist, fep - flp->fents,
+					 dflp - flist, dfep - dflp->fents);
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
 				procid, opno, fep->id, fep->parent);
-			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
 				procid, opno, id, parid);
 		}
 	}
@@ -4287,6 +4400,29 @@ rename_f(int opno, long r)
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

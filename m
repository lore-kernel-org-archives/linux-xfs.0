Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847DDC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 06:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiDZG1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 02:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiDZG1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 02:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988F1229E3;
        Mon, 25 Apr 2022 23:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2E5961336;
        Tue, 26 Apr 2022 06:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64ED9C385A0;
        Tue, 26 Apr 2022 06:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650954254;
        bh=oBGzozlfGdoefzvo4o2VgjZakYj4nO8/IRv+9s2WxLM=;
        h=From:To:Cc:Subject:Date:From;
        b=b+rwiIjZvp9XG1ctgJA2mccjYLB8G83irGYJUTAaH29ypa/hMBfEuue3Z/oB10GUO
         ArWMoqw1VozvxVyLMrGrpiu1R7lLCCEoH64JJvMug1vYqYHYd+2bUvDRZcGvE6ltsM
         kOGOA8t6joEMnTz/qDqX0v+QOqNTPx9SiLQmGLc1ht/9fEGeXv+lIVGGdHbsKBZ7xp
         ePwVro9q8cC4GNoVWVl3xi+Ot2ucC3dmf6KJS5fwISuzlAB/GK/N4FRUY+9koUVcTi
         mgADj/35EX1Uli4XXkCJKWWs05hma/F9+IR1FQGWrbye3qp+qOjwOcRhN9A8cGcGgg
         4yZSztsP/Ystg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] fsstress: remove ALLOCSP and FREESP operations entirely
Date:   Tue, 26 Apr 2022 14:24:11 +0800
Message-Id: <20220426062411.3119027-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zorro Lang <zlang@redhat.com>

Due to upstream linux has removed ALLOCSP/FREESP ioctls by commit:
4d1b97f9ce7c0 ("xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls"), so
let's remove ALLOCSP/FREESP testing from fsstress, to avoid more
mismatch problems.

Due to g/070 specified "-f allocsp" and "-f freesp=0", so remove
these two lines too.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsstress.c    | 117 ----------------------------------------------
 tests/generic/070 |   2 -
 2 files changed, 119 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 23188467..b395bc4d 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -86,7 +86,6 @@ static int renameat2(int dfd1, const char *path1,
 
 typedef enum {
 	OP_AFSYNC,
-	OP_ALLOCSP,
 	OP_AREAD,
 	OP_ATTR_REMOVE,
 	OP_ATTR_SET,
@@ -103,7 +102,6 @@ typedef enum {
 	OP_FALLOCATE,
 	OP_FDATASYNC,
 	OP_FIEMAP,
-	OP_FREESP,
 	OP_FSYNC,
 	OP_GETATTR,
 	OP_GETDENTS,
@@ -216,7 +214,6 @@ struct print_string {
 #define XATTR_NAME_BUF_SIZE 18
 
 void	afsync_f(opnum_t, long);
-void	allocsp_f(opnum_t, long);
 void	aread_f(opnum_t, long);
 void	attr_remove_f(opnum_t, long);
 void	attr_set_f(opnum_t, long);
@@ -233,7 +230,6 @@ void	dwrite_f(opnum_t, long);
 void	fallocate_f(opnum_t, long);
 void	fdatasync_f(opnum_t, long);
 void	fiemap_f(opnum_t, long);
-void	freesp_f(opnum_t, long);
 void	fsync_f(opnum_t, long);
 char	*gen_random_string(int);
 void	getattr_f(opnum_t, long);
@@ -281,7 +277,6 @@ char	*xattr_flag_to_string(int);
 struct opdesc	ops[OP_LAST]	= {
      /* [OP_ENUM]	   = {"name",	       function,	freq, iswrite }, */
 	[OP_AFSYNC]	   = {"afsync",	       afsync_f,	0, 1 },
-	[OP_ALLOCSP]	   = {"allocsp",       allocsp_f,	1, 1 },
 	[OP_AREAD]	   = {"aread",	       aread_f,		1, 0 },
 	[OP_ATTR_REMOVE]   = {"attr_remove",   attr_remove_f,	0, 1 },
 	[OP_ATTR_SET]	   = {"attr_set",      attr_set_f,	0, 1 },
@@ -298,7 +293,6 @@ struct opdesc	ops[OP_LAST]	= {
 	[OP_FALLOCATE]	   = {"fallocate",     fallocate_f,	1, 1 },
 	[OP_FDATASYNC]	   = {"fdatasync",     fdatasync_f,	1, 1 },
 	[OP_FIEMAP]	   = {"fiemap",	       fiemap_f,	1, 1 },
-	[OP_FREESP]	   = {"freesp",	       freesp_f,	1, 1 },
 	[OP_FSYNC]	   = {"fsync",	       fsync_f,		1, 1 },
 	[OP_GETATTR]	   = {"getattr",       getattr_f,	1, 0 },
 	[OP_GETDENTS]	   = {"getdents",      getdents_f,	1, 0 },
@@ -2042,62 +2036,6 @@ afsync_f(opnum_t opno, long r)
 #endif
 }
 
-void
-allocsp_f(opnum_t opno, long r)
-{
-#ifdef XFS_IOC_ALLOCSP64
-	int		e;
-	pathname_t	f;
-	int		fd;
-	struct xfs_flock64	fl;
-	int64_t		lr;
-	off64_t		off;
-	struct stat64	stb;
-	int		v;
-	char		st[1024];
-
-	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
-		if (v)
-			printf("%d/%lld: allocsp - no filename\n", procid, opno);
-		free_pathname(&f);
-		return;
-	}
-	fd = open_path(&f, O_RDWR);
-	e = fd < 0 ? errno : 0;
-	check_cwd();
-	if (fd < 0) {
-		if (v)
-			printf("%d/%lld: allocsp - open %s failed %d\n",
-				procid, opno, f.path, e);
-		free_pathname(&f);
-		return;
-	}
-	if (fstat64(fd, &stb) < 0) {
-		if (v)
-			printf("%d/%lld: allocsp - fstat64 %s failed %d\n",
-				procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
-	}
-	inode_info(st, sizeof(st), &stb, v);
-	lr = ((int64_t)random() << 32) + random();
-	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
-	off %= maxfsize;
-	fl.l_whence = SEEK_SET;
-	fl.l_start = off;
-	fl.l_len = 0;
-	e = xfsctl(f.path, fd, XFS_IOC_ALLOCSP64, &fl) < 0 ? errno : 0;
-	if (v) {
-		printf("%d/%lld: xfsctl(XFS_IOC_ALLOCSP64) %s%s %lld 0 %d\n",
-		       procid, opno, f.path, st, (long long)off, e);
-	}
-	free_pathname(&f);
-	close(fd);
-#endif
-}
-
 #ifdef AIO
 void
 do_aio_rw(opnum_t opno, long r, int flags)
@@ -3732,61 +3670,6 @@ fiemap_f(opnum_t opno, long r)
 #endif
 }
 
-void
-freesp_f(opnum_t opno, long r)
-{
-#ifdef XFS_IOC_FREESP64
-	int		e;
-	pathname_t	f;
-	int		fd;
-	struct xfs_flock64	fl;
-	int64_t		lr;
-	off64_t		off;
-	struct stat64	stb;
-	int		v;
-	char		st[1024];
-
-	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
-		if (v)
-			printf("%d/%lld: freesp - no filename\n", procid, opno);
-		free_pathname(&f);
-		return;
-	}
-	fd = open_path(&f, O_RDWR);
-	e = fd < 0 ? errno : 0;
-	check_cwd();
-	if (fd < 0) {
-		if (v)
-			printf("%d/%lld: freesp - open %s failed %d\n",
-				procid, opno, f.path, e);
-		free_pathname(&f);
-		return;
-	}
-	if (fstat64(fd, &stb) < 0) {
-		if (v)
-			printf("%d/%lld: freesp - fstat64 %s failed %d\n",
-				procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
-	}
-	inode_info(st, sizeof(st), &stb, v);
-	lr = ((int64_t)random() << 32) + random();
-	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
-	off %= maxfsize;
-	fl.l_whence = SEEK_SET;
-	fl.l_start = off;
-	fl.l_len = 0;
-	e = xfsctl(f.path, fd, XFS_IOC_FREESP64, &fl) < 0 ? errno : 0;
-	if (v)
-		printf("%d/%lld: xfsctl(XFS_IOC_FREESP64) %s%s %lld 0 %d\n",
-		       procid, opno, f.path, st, (long long)off, e);
-	free_pathname(&f);
-	close(fd);
-#endif
-}
-
 void
 fsync_f(opnum_t opno, long r)
 {
diff --git a/tests/generic/070 b/tests/generic/070
index 678344fa..8a134f80 100755
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -29,8 +29,6 @@ _require_attrs
 
 FSSTRESS_ARGS=`_scale_fsstress_args \
 	-d $TEST_DIR/fsstress \
-	-f allocsp=0 \
-	-f freesp=0 \
 	-f bulkstat=0 \
 	-f bulkstat1=0 \
 	-f resvsp=0 \
-- 
2.31.1


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B25C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiLaAxd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4D13F29;
        Fri, 30 Dec 2022 16:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B44B81DF9;
        Sat, 31 Dec 2022 00:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68937C433EF;
        Sat, 31 Dec 2022 00:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448008;
        bh=cWszxIJmhZ2jvP2wtTOB3XoOKrpxJBKvEuJtMu6hraA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=szp7gNiZnirvYj4Q1KFEafp2ktJbb4bj2TVuf6g04Kc8ccBxGHIwQUqObJQCmzXlN
         kSSxBwyvmXda3XzwT6pLYx2wbiVYZkxre24VVF/bv+WL7ebXhGa+e1yLG0wcryoqSd
         AYzsJdvMRVDtcZiwIShJinUavtsV8kTaE8LZu3rBrRwUAZWSyKTeMTm0+WfgzXiFmV
         vu4mL/e6j91g2HYwxZbctcCtxJzVYauu4kEhgu6yiOPAmYfmsvYnH9aRbwzmXjx9m3
         gkdvj4644vr9lOR8dEmSAK23U68I9z5qoP+/UIek0GEwGthwn0KVnHpfBDK7DK44WK
         QNwpzLwZ6FwHA==
Subject: [PATCH 7/7] fsstress: update for FIEXCHANGE_RANGE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878912.732172.17691109886906122211.stgit@magnolia>
In-Reply-To: <167243878818.732172.6392253687008406885.stgit@magnolia>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach this stress tool to be able to use the file content exchange
ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 10608fb554..0fba3d92a0 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -143,6 +143,7 @@ typedef enum {
 	OP_URING_WRITE,
 	OP_WRITE,
 	OP_WRITEV,
+	OP_XCHGRANGE,
 	OP_LAST
 } opty_t;
 
@@ -272,6 +273,8 @@ void	uring_read_f(opnum_t, long);
 void	uring_write_f(opnum_t, long);
 void	write_f(opnum_t, long);
 void	writev_f(opnum_t, long);
+void	xchgrange_f(opnum_t, long);
+
 char	*xattr_flag_to_string(int);
 
 struct opdesc	ops[OP_LAST]	= {
@@ -340,6 +343,7 @@ struct opdesc	ops[OP_LAST]	= {
 	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	1, 1 },
 	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
 	[OP_WRITEV]	   = {"writev",	       writev_f,	4, 1 },
+	[OP_XCHGRANGE]	   = {"xchgrange",     xchgrange_f,	4, 1 },
 }, *ops_end;
 
 flist_t	flist[FT_nft] = {
@@ -2494,6 +2498,170 @@ chown_f(opnum_t opno, long r)
 	free_pathname(&f);
 }
 
+/* exchange some arbitrary range of f1 to f2...fn. */
+void
+xchgrange_f(
+	opnum_t			opno,
+	long			r)
+{
+#ifdef FIEXCHANGE_RANGE
+	struct file_xchg_range	fxr = { 0 };
+	static __u64		swap_flags = 0;
+	struct pathname		fpath1;
+	struct pathname		fpath2;
+	struct stat64		stat1;
+	struct stat64		stat2;
+	char			inoinfo1[1024];
+	char			inoinfo2[1024];
+	off64_t			lr;
+	off64_t			off1;
+	off64_t			off2;
+	off64_t			max_off2;
+	size_t			len;
+	int			v1;
+	int			v2;
+	int			fd1;
+	int			fd2;
+	int			ret;
+	int			tries = 0;
+	int			e;
+
+	/* Load paths */
+	init_pathname(&fpath1);
+	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
+		if (v1)
+			printf("%d/%lld: xchgrange read - no filename\n",
+				procid, opno);
+		goto out_fpath1;
+	}
+
+	init_pathname(&fpath2);
+	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
+		if (v2)
+			printf("%d/%lld: xchgrange write - no filename\n",
+				procid, opno);
+		goto out_fpath2;
+	}
+
+	/* Open files */
+	fd1 = open_path(&fpath1, O_RDONLY);
+	e = fd1 < 0 ? errno : 0;
+	check_cwd();
+	if (fd1 < 0) {
+		if (v1)
+			printf("%d/%lld: xchgrange read - open %s failed %d\n",
+				procid, opno, fpath1.path, e);
+		goto out_fpath2;
+	}
+
+	fd2 = open_path(&fpath2, O_WRONLY);
+	e = fd2 < 0 ? errno : 0;
+	check_cwd();
+	if (fd2 < 0) {
+		if (v2)
+			printf("%d/%lld: xchgrange write - open %s failed %d\n",
+				procid, opno, fpath2.path, e);
+		goto out_fd1;
+	}
+
+	/* Get file stats */
+	if (fstat64(fd1, &stat1) < 0) {
+		if (v1)
+			printf("%d/%lld: xchgrange read - fstat64 %s failed %d\n",
+				procid, opno, fpath1.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo1, sizeof(inoinfo1), &stat1, v1);
+
+	if (fstat64(fd2, &stat2) < 0) {
+		if (v2)
+			printf("%d/%lld: xchgrange write - fstat64 %s failed %d\n",
+				procid, opno, fpath2.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v2);
+
+	if (stat1.st_size < (stat1.st_blksize * 2) ||
+	    stat2.st_size < (stat2.st_blksize * 2)) {
+		if (v2)
+			printf("%d/%lld: xchgrange - files are too small\n",
+				procid, opno);
+		goto out_fd2;
+	}
+
+	/* Never let us swap more than 1/4 of the files. */
+	len = (random() % FILELEN_MAX) + 1;
+	if (len > stat1.st_size / 4)
+		len = stat1.st_size / 4;
+	if (len > stat2.st_size / 4)
+		len = stat2.st_size / 4;
+	len = rounddown_64(len, stat1.st_blksize);
+	if (len == 0)
+		len = stat1.st_blksize;
+
+	/* Calculate offsets */
+	lr = ((int64_t)random() << 32) + random();
+	if (stat1.st_size == len)
+		off1 = 0;
+	else
+		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
+	off1 %= maxfsize;
+	off1 = rounddown_64(off1, stat1.st_blksize);
+
+	/*
+	 * If srcfile == destfile, randomly generate destination ranges
+	 * until we find one that doesn't overlap the source range.
+	 */
+	max_off2 = MIN(stat2.st_size  - len, MAXFSIZE);
+	do {
+		lr = ((int64_t)random() << 32) + random();
+		if (stat2.st_size == len)
+			off2 = 0;
+		else
+			off2 = (off64_t)(lr % max_off2);
+		off2 %= maxfsize;
+		off2 = rounddown_64(off2, stat2.st_blksize);
+	} while (stat1.st_ino == stat2.st_ino &&
+		 llabs(off2 - off1) < len &&
+		 tries++ < 10);
+
+	/* Swap data blocks */
+	fxr.file1_fd = fd1;
+	fxr.file1_offset = off1;
+	fxr.length = len;
+	fxr.file2_offset = off2;
+	fxr.flags = swap_flags;
+
+retry:
+	ret = ioctl(fd2, FIEXCHANGE_RANGE, &fxr);
+	e = ret < 0 ? errno : 0;
+	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
+		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
+		fxr.flags |= swap_flags;
+		goto retry;
+	}
+	if (v1 || v2) {
+		printf("%d/%lld: xchgrange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
+			procid, opno,
+			fpath1.path, inoinfo1, (long long)off1, (long long)len,
+			fpath2.path, inoinfo2, (long long)off2, (long long)len);
+
+		if (ret < 0)
+			printf(" error %d", e);
+		printf("\n");
+	}
+
+out_fd2:
+	close(fd2);
+out_fd1:
+	close(fd1);
+out_fpath2:
+	free_pathname(&fpath2);
+out_fpath1:
+	free_pathname(&fpath1);
+#endif
+}
+
 /* reflink some arbitrary range of f1 to f2. */
 void
 clonerange_f(


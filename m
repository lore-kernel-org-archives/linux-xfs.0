Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A434BC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjBPVMC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBPVMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:12:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D8353809
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F3060C48
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751EC433D2;
        Thu, 16 Feb 2023 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581905;
        bh=rf++h0hSOZud/1+4G5XYEQxbHG+c45Me6iue0eEwKX4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cv8eQmuqAVX1KO8b04G2uN5UonVkbb+x3NF8Ws90wS8JwICLiS1mPfb6mcfDqmZUD
         MefYvkeQVCMOkXiDJD3lJaVIu37L4+AAcyxMocjMMhZzGlzaXalnzFdt1lHmBHtLOT
         yZFF9dKVRX0yRh+bbR6uDtkXt1VM05nB36k/TZVHV8tG3MqW4mscZEOxLNtZJ+TLxT
         zCDtMpNau+Cpz5GEEn+wF2WZFzxcJh713St36DB4PMYQGyVALAlB9ulQst3TqsMuuU
         CrFNRXGGRbcbgF1r3v/i9LcCRMola5QTyC73vr2eqfnysubJ1lksOzhF35yQwSir5q
         JIkUeytPB2LYA==
Date:   Thu, 16 Feb 2023 13:11:45 -0800
Subject: [PATCH 5/6] xfs: make the ondisk parent pointer record a flex array
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882439.3478037.12087015645657287622.stgit@magnolia>
In-Reply-To: <167657882371.3478037.12485693506644718323.stgit@magnolia>
References: <167657882371.3478037.12485693506644718323.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we can use the filename as the parent pointer name hash, we
always write the full 64 bytes into the xattr.  In other words, the
namehash is really a flex array, so adjust its C definition.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_format.h  |    9 ++++++---
 libxfs/xfs_parent.c     |    4 ++--
 libxfs/xfs_parent.h     |   15 ++++++++++++---
 libxfs/xfs_trans_resv.c |    6 +++---
 logprint/log_redo.c     |   45 ++++++++++++++++++++++++---------------------
 logprint/logprint.h     |    3 ++-
 6 files changed, 49 insertions(+), 33 deletions(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 27535750..4d858307 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -842,21 +842,24 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 struct xfs_parent_name_rec {
 	__be64  p_ino;
 	__be32  p_gen;
-	__u8	p_namehash[XFS_PARENT_NAME_HASH_SIZE];
+	__u8	p_namehash[];
 } __attribute__((packed));
 
+#define XFS_PARENT_NAME_MAX_SIZE \
+	(sizeof(struct xfs_parent_name_rec) + XFS_PARENT_NAME_HASH_SIZE)
+
 static inline unsigned int
 xfs_parent_name_rec_sizeof(
 	unsigned int		hashlen)
 {
-	return offsetof(struct xfs_parent_name_rec, p_namehash) + hashlen;
+	return sizeof(struct xfs_parent_name_rec) + hashlen;
 }
 
 static inline unsigned int
 xfs_parent_name_hashlen(
 	unsigned int		rec_sizeof)
 {
-	return rec_sizeof - offsetof(struct xfs_parent_name_rec, p_namehash);
+	return rec_sizeof - sizeof(struct xfs_parent_name_rec);
 }
 
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 064f2f40..8886d344 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -98,7 +98,7 @@ xfs_init_parent_name_rec(
 	rec->p_ino = cpu_to_be64(dp->i_ino);
 	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
 	return xfs_parent_namehash(ip, name, rec->p_namehash,
-			sizeof(rec->p_namehash));
+			XFS_PARENT_NAME_HASH_SIZE);
 }
 
 /*
@@ -197,7 +197,7 @@ __xfs_parent_init(
 	parent->args.attr_filter = XFS_ATTR_PARENT;
 	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
 	parent->args.name = (const uint8_t *)&parent->rec;
-	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	parent->args.namelen = 0;
 
 	*parentp = parent;
 	return 0;
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 4c310076..3431aac7 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -43,8 +43,14 @@ void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
  * the defer ops machinery
  */
 struct xfs_parent_defer {
-	struct xfs_parent_name_rec	rec;
-	struct xfs_parent_name_rec	old_rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
+	union {
+		struct xfs_parent_name_rec	old_rec;
+		__u8			dummy2[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 	bool				have_log;
 };
@@ -112,7 +118,10 @@ unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 
 /* Scratchpad memory so that raw parent operations don't burn stack space. */
 struct xfs_parent_scratch {
-	struct xfs_parent_name_rec	rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 };
 
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 50315738..406592f2 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -424,19 +424,19 @@ static inline unsigned int xfs_calc_pptr_link_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_replace_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 
 /*
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 339d4815..7869d58e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -682,19 +682,18 @@ static inline size_t ATTR_NVEC_SIZE(size_t size)
 
 static int
 xfs_attri_copy_name_format(
-	char                            *buf,
-	uint                            len,
-	struct xfs_parent_name_rec     *dst_attri_fmt)
+	char				*buf,
+	uint				len,
+	uint				alfi_name_len,
+	struct xfs_parent_name_rec	*dst_attri_fmt)
 {
-	uint dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-	if (len == dst_len) {
-		memcpy((char *)dst_attri_fmt, buf, len);
+	if (alfi_name_len <= len) {
+		memcpy(dst_attri_fmt, buf, alfi_name_len);
 		return 0;
 	}
 
 	fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
-		progname, len, dst_len);
+		progname, len, alfi_name_len);
 
 	return 1;
 }
@@ -764,6 +763,7 @@ xlog_print_trans_attri(
 		name_ptr = *ptr;
 		name_len = src_f->alfi_name_len;
 		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_name_len,
 						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
@@ -777,6 +777,7 @@ xlog_print_trans_attri(
 		nname_ptr = *ptr;
 		nname_len = src_f->alfi_nname_len;
 		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_nname_len,
 						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
@@ -814,10 +815,10 @@ int
 xlog_print_trans_attri_name(
 	char				**ptr,
 	uint				src_len,
+	uint				alfi_name_len,
 	uint				attr_flags)
 {
-	struct xfs_parent_name_rec	*src_f = NULL;
-	uint				dst_len;
+	struct xfs_parent_name_rec	*src_f;
 
 	/*
 	 * If this is not a parent pointer, just do a bin dump
@@ -828,10 +829,9 @@ xlog_print_trans_attri_name(
 		goto out;
 	}
 
-	dst_len	= ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-	if (dst_len != src_len) {
+	if (alfi_name_len > src_len) {
 		fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
-			progname, src_len, dst_len);
+			progname, src_len, alfi_name_len);
 		return 1;
 	}
 
@@ -929,14 +929,12 @@ xlog_recover_print_attri(
 			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
 			src_len = item->ri_buf[region].i_len;
 
-			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+			if ((rec = calloc(src_len, 1)) == NULL) {
 				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
 					progname);
 				exit(1);
 			}
-			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, f->alfi_name_len, rec)) {
 				goto out;
 			}
 
@@ -962,14 +960,12 @@ xlog_recover_print_attri(
 			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
 			src_len = item->ri_buf[region].i_len;
 
-			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
-
-			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+			if ((rec = calloc(dst_len, 1)) == NULL) {
 				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
 					progname);
 				exit(1);
 			}
-			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, f->alfi_nname_len, rec)) {
 				goto out;
 			}
 
@@ -993,6 +989,7 @@ xlog_recover_print_attri(
 
 		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
 			src_value = (char *)item->ri_buf[region].i_addr;
+			src_len = item->ri_buf[region].i_len;
 
 			if ((value = ((char *)malloc(f->alfi_value_len))) == NULL) {
 				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
@@ -1000,6 +997,12 @@ xlog_recover_print_attri(
 				exit(1);
 			}
 
+			if (f->alfi_value_len > src_len) {
+				fprintf(stderr, _("%s: bad size of attri value format: %u; expected %u\n"),
+					progname, src_len, f->alfi_value_len);
+				exit(1);
+			}
+
 			value_ptr = src_value;
 			value_len = f->alfi_value_len;
 
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b8e1c932..12d333d7 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,7 +59,8 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len, uint attr_flags);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len,
+		uint alfi_name_len, uint attr_flags);
 extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
 					uint attr_flags);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);


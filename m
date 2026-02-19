Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977A2E6CAB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544720; cv=none; b=KSYsijaubg8nMdkBMn0nly8Dk9zZ+oJSuOT1Yej+zNn+SeqaeaZkHp2INLHO1+sRRDwGdK6Hs07yWo6b7kxIVHUpJ/vcDbhL0aAczTsuHG+SE+KkAifqGBiJzy3aIENTyQYZg4y36rXqNsYW9k9kfuJQHYXN9xuBKU6h69O+lko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544720; c=relaxed/simple;
	bh=yT8Ngv6FY+9khvtY6mMHjHu0ru/CgiOkqh6t2eP8nHc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5VErhsr2etHoyxTu77l7oIqL3n2q4vU8pDe/KpwXKNxwZq4LF13TdWSWhkzf0thOPgmKcquxOp9m5ZWh79Ss9xWw/uXsbzj26oXP+OYxvw9vQrFoP1U47iIhEN2GQ4Us/KXDoq46dXYQ/QSjrL3O3UJbWJWqGMl/sGibq7brTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vcz29E0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vcz29E0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B44C4CEF7;
	Thu, 19 Feb 2026 23:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544720;
	bh=yT8Ngv6FY+9khvtY6mMHjHu0ru/CgiOkqh6t2eP8nHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vcz29E0Ie4/XLLy9pQnfUA9KPsg0p6PsAQiwC0l+UatZvbvFHpoSIjHPxaApSEj3x
	 3/07yXV/f7GdV/qBzNYx4K3W/TUCeETeMpG6wiDFlBTEWo43TrICo+mGY3PYaC1d5L
	 rrvGAMUa8CoOMRDSsusL2gfB38GD/XkZ6nokuVoUpV5F3Vlj+rRRsqPHGiZKJ71DDC
	 E0ijlkGGQhIYhEkj/oDfCj4IpESNqkJu6PYWXh6B6/JF2ve4C1NBZ/mBkMsuBJbEAk
	 gCBFvkHrK8niIiFd4wuk3C3/M5X9IhVqAQ8bHKJ+v2vlzoLIgEzcmeriHoT0Ulpk3I
	 YRakkIADC3rfQ==
Date: Thu, 19 Feb 2026 15:45:19 -0800
Subject: [PATCH 07/12] xfs: remove the xlog_rec_header_t typedef
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456855.1285810.2946325537221491295.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ef1e275638fe6f6d54c18a770c138e4d5972b280

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/libxlog.h         |    4 ++--
 libxfs/xfs_log_format.h   |    4 ++--
 libxfs/rdwr.c             |    2 +-
 libxlog/util.c            |    6 +++---
 libxlog/xfs_log_recover.c |   18 +++++++++---------
 logprint/log_dump.c       |    4 ++--
 6 files changed, 19 insertions(+), 19 deletions(-)


diff --git a/include/libxlog.h b/include/libxlog.h
index 3948c0b8d19b1d..cf39e7402d1378 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -99,9 +99,9 @@ extern int	xlog_do_recovery_pass(struct xlog *log, xfs_daddr_t head_blk,
 extern int	xlog_recover_do_trans(struct xlog *log, struct xlog_recover *trans,
 				int pass);
 extern int	xlog_header_check_recover(xfs_mount_t *mp,
-				xlog_rec_header_t *head);
+				struct xlog_rec_header *head);
 extern int	xlog_header_check_mount(xfs_mount_t *mp,
-				xlog_rec_header_t *head);
+				struct xlog_rec_header *head);
 
 #define xlog_assign_atomic_lsn(l,a,b) ((void) 0)
 #define xlog_assign_grant_head(l,a,b) ((void) 0)
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 4cb69bd285ca13..908e7060428ccb 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -136,7 +136,7 @@ struct xlog_rec_ext_header {
 #define XLOG_REC_EXT_SIZE \
 	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
 
-typedef struct xlog_rec_header {
+struct xlog_rec_header {
 	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
 	__be32	  h_cycle;	/* write cycle of log			:  4 */
 	__be32	  h_version;	/* LR version				:  4 */
@@ -174,7 +174,7 @@ typedef struct xlog_rec_header {
 
 	__u8	  h_reserved[184];
 	struct xlog_rec_ext_header h_ext[];
-} xlog_rec_header_t;
+};
 
 #ifdef __i386__
 #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 500a8d81549209..3419e821ef0a29 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1297,7 +1297,7 @@ libxfs_log_header(
 	libxfs_get_block_t	*nextfunc,
 	void			*private)
 {
-	xlog_rec_header_t	*head = (xlog_rec_header_t *)caddr;
+	struct xlog_rec_header	*head = (struct xlog_rec_header *)caddr;
 	char			*p = caddr;
 	__be32			cycle_lsn;
 	int			i, len;
diff --git a/libxlog/util.c b/libxlog/util.c
index 6e21f1a895d30a..3cfaeb511adaa4 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -67,7 +67,7 @@ xlog_is_dirty(
 }
 
 static int
-header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
+header_check_uuid(xfs_mount_t *mp, struct xlog_rec_header *head)
 {
     char uu_log[64], uu_sb[64];
 
@@ -89,7 +89,7 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
 }
 
 int
-xlog_header_check_recover(xfs_mount_t *mp, xlog_rec_header_t *head)
+xlog_header_check_recover(xfs_mount_t *mp, struct xlog_rec_header *head)
 {
     if (print_record_header)
 	printf(_("\nLOG REC AT LSN cycle %d block %d (0x%x, 0x%x)\n"),
@@ -125,7 +125,7 @@ xlog_header_check_recover(xfs_mount_t *mp, xlog_rec_header_t *head)
 }
 
 int
-xlog_header_check_mount(xfs_mount_t *mp, xlog_rec_header_t *head)
+xlog_header_check_mount(xfs_mount_t *mp, struct xlog_rec_header *head)
 {
     if (platform_uuid_is_null(&head->h_fs_uuid)) return 0;
     if (header_check_uuid(mp, head)) {
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 843b8e9c47a455..65e3c782d59674 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -296,7 +296,7 @@ xlog_find_verify_log_record(
 	xfs_daddr_t		i;
 	struct xfs_buf		*bp;
 	char			*offset = NULL;
-	xlog_rec_header_t	*head = NULL;
+	struct xlog_rec_header	*head = NULL;
 	int			error = 0;
 	int			smallmem = 0;
 	int			num_blks = *last_blk - start_blk;
@@ -331,7 +331,7 @@ xlog_find_verify_log_record(
 				goto out;
 		}
 
-		head = (xlog_rec_header_t *)offset;
+		head = (struct xlog_rec_header *)offset;
 
 		if (head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			break;
@@ -673,7 +673,7 @@ xlog_find_tail(
 	xfs_daddr_t		*head_blk,
 	xfs_daddr_t		*tail_blk)
 {
-	xlog_rec_header_t	*rhead;
+	struct xlog_rec_header	*rhead;
 	struct xlog_op_header	*op_head;
 	char			*offset = NULL;
 	struct xfs_buf		*bp;
@@ -747,7 +747,7 @@ xlog_find_tail(
 	}
 
 	/* find blk_no of tail of log */
-	rhead = (xlog_rec_header_t *)offset;
+	rhead = (struct xlog_rec_header *)offset;
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
 	/*
@@ -1413,7 +1413,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		tail_blk,
 	int			pass)
 {
-	xlog_rec_header_t	*rhead;
+	struct xlog_rec_header	*rhead;
 	xfs_daddr_t		blk_no;
 	char			*offset;
 	struct xfs_buf		*hbp, *dbp;
@@ -1442,7 +1442,7 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		rhead = (xlog_rec_header_t *)offset;
+		rhead = (struct xlog_rec_header *)offset;
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
 			goto bread_err1;
@@ -1479,7 +1479,7 @@ xlog_do_recovery_pass(
 			if (error)
 				goto bread_err2;
 
-			rhead = (xlog_rec_header_t *)offset;
+			rhead = (struct xlog_rec_header *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
@@ -1554,7 +1554,7 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 			}
-			rhead = (xlog_rec_header_t *)offset;
+			rhead = (struct xlog_rec_header *)offset;
 			error = xlog_valid_rec_header(log, rhead,
 						split_hblks ? blk_no : 0);
 			if (error)
@@ -1628,7 +1628,7 @@ xlog_do_recovery_pass(
 			if (error)
 				goto bread_err2;
 
-			rhead = (xlog_rec_header_t *)offset;
+			rhead = (struct xlog_rec_header *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
diff --git a/logprint/log_dump.c b/logprint/log_dump.c
index 1de0206af94a9e..b403c01e99e839 100644
--- a/logprint/log_dump.c
+++ b/logprint/log_dump.c
@@ -21,11 +21,11 @@ xfs_log_dump(
 	int			r;
 	uint			last_cycle = -1;
 	xfs_daddr_t		blkno, dupblkno;
-	xlog_rec_header_t	*hdr;
+	struct xlog_rec_header	*hdr;
 	char			buf[XLOG_HEADER_SIZE];
 
 	dupblkno = 0;
-	hdr = (xlog_rec_header_t *)buf;
+	hdr = (struct xlog_rec_header *)buf;
 	xlog_print_lseek(log, fd, 0, SEEK_SET);
 	for (blkno = 0; blkno < log->l_logBBsize; blkno++) {
 		r = read(fd, buf, sizeof(buf));


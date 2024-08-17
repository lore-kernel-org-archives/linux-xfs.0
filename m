Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E5D43152;
	Sat, 17 Aug 2024 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723877337; cv=none; b=XgkqEa9YkAZ5Tcyu6VSVQssy4iOLnJb5bC7goj2jAZqBMJbE7QN+XcKEaeHakcFWhezNQZVLPwXO8Fbjq8/5dLhFD8DubKAXVMLrumveasfrdStBDNN0Pq/3TbBsrsyJLhfs6k5MJ7hH1/BBuGXONZvE43ycCkWwDShorC0yzhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723877337; c=relaxed/simple;
	bh=TiUFFAOF112hjPlIPQXh74aP+WgoMHBr+ClICKWwoEU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R6Nr2TSzSiFUdTlRwDfK33KJc0W6mHAPbhR2t4NHmxtxyj4kvYReWoSs3hqcl8OX1nxZuhQJLb8//A9uOjL8EuxEgum1Aixwhcl2T6HSMsdKxlOjvdsRG5ooMRWIbto3/x3OkRxdBX54LAXNQXpsInYkTf+ypK7YVbbVUepgJjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: bb6037c85c6411efa216b1d71e6e1362-20240817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_UNTRUSTED
	SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED
	SA_UNTRUSTED, SA_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:5af3ba09-fcd9-4a9f-aa00-ac845cf43be2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.1.38,REQID:5af3ba09-fcd9-4a9f-aa00-ac845cf43be2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:1196c51cb10292919d03434e16518a1a,BulkI
	D:240816171605XRYDUDDJ,BulkQuantity:3,Recheck:0,SF:43|74|66|23|17|19|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: bb6037c85c6411efa216b1d71e6e1362-20240817
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.3.232)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 150669886; Sat, 17 Aug 2024 14:48:38 +0800
From: liuhuan01@kylinos.cn
To: djwong@kernel.org
Cc: dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	liuhuan01@kylinos.cn
Subject: [PATCH] xfs_io: use FICLONE/FICLONERANGE/FIDEDUPERANGE for reflink/dedupe IO commands
Date: Sat, 17 Aug 2024 14:48:26 +0800
Message-Id: <20240817064826.14177-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240809150455.GV6051@frogsfrogsfrogs>
References: <20240809150455.GV6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

Use FICLONE/FICLONERANGE/FIDEDUPERANGE instead of XFS_IOC_CLONE/XFS_IOC_CLONE_RANGE/XFS_IOC_FILE_EXTENT_SAME.
And the declaration becomes useless, delete it.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 include/xfs_fs_compat.h | 54 -----------------------------------------
 io/reflink.c            | 52 +++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 80 deletions(-)

diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
index 0077f00c..e53dcc6e 100644
--- a/include/xfs_fs_compat.h
+++ b/include/xfs_fs_compat.h
@@ -31,60 +31,6 @@
 #define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
 #define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
 
-/*
- * Don't use this.
- * Use struct file_clone_range
- */
-struct xfs_clone_args {
-	__s64 src_fd;
-	__u64 src_offset;
-	__u64 src_length;
-	__u64 dest_offset;
-};
-
-/*
- * Don't use these.
- * Use FILE_DEDUPE_RANGE_SAME / FILE_DEDUPE_RANGE_DIFFERS
- */
-#define XFS_EXTENT_DATA_SAME	0
-#define XFS_EXTENT_DATA_DIFFERS	1
-
-/* Don't use this. Use file_dedupe_range_info */
-struct xfs_extent_data_info {
-	__s64 fd;		/* in - destination file */
-	__u64 logical_offset;	/* in - start of extent in destination */
-	__u64 bytes_deduped;	/* out - total # of bytes we were able
-				 * to dedupe from this file */
-	/* status of this dedupe operation:
-	 * < 0 for error
-	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
-	 * == XFS_EXTENT_DATA_DIFFERS if data differs
-	 */
-	__s32 status;		/* out - see above description */
-	__u32 reserved;
-};
-
-/*
- * Don't use this.
- * Use struct file_dedupe_range
- */
-struct xfs_extent_data {
-	__u64 logical_offset;	/* in - start of extent in source */
-	__u64 length;		/* in - length of extent */
-	__u16 dest_count;	/* in - total elements in info array */
-	__u16 reserved1;
-	__u32 reserved2;
-	struct xfs_extent_data_info info[0];
-};
-
-/*
- * Don't use these.
- * Use FICLONE/FICLONERANGE/FIDEDUPERANGE
- */
-#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
-#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
-#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
-
 /* 64-bit seconds counter that works independently of the C library time_t. */
 typedef long long int time64_t;
 
diff --git a/io/reflink.c b/io/reflink.c
index b6a3c05a..154ca65b 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -43,49 +43,49 @@ dedupe_ioctl(
 	uint64_t	len,
 	int		*ops)
 {
-	struct xfs_extent_data		*args;
-	struct xfs_extent_data_info	*info;
+	struct file_dedupe_range	*args;
+	struct file_dedupe_range_info	*info;
 	int				error;
 	uint64_t			deduped = 0;
 
-	args = calloc(1, sizeof(struct xfs_extent_data) +
-			 sizeof(struct xfs_extent_data_info));
+	args = calloc(1, sizeof(struct file_dedupe_range) +
+			 sizeof(struct file_dedupe_range_info));
 	if (!args)
 		goto done;
-	info = (struct xfs_extent_data_info *)(args + 1);
-	args->logical_offset = soffset;
-	args->length = len;
+	info = (struct file_dedupe_range_info *)(args + 1);
+	args->src_offset = soffset;
+	args->src_length = len;
 	args->dest_count = 1;
-	info->fd = file->fd;
-	info->logical_offset = doffset;
+	info->dest_fd = file->fd;
+	info->dest_offset = doffset;
 
-	while (args->length > 0 || !*ops) {
-		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
+	while (args->src_length > 0 || !*ops) {
+		error = ioctl(fd, FIDEDUPERANGE, args);
 		if (error) {
-			perror("XFS_IOC_FILE_EXTENT_SAME");
+			perror("FIDEDUPERANGE");
 			exitcode = 1;
 			goto done;
 		}
 		if (info->status < 0) {
-			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
+			fprintf(stderr, "FIDEDUPERANGE: %s\n",
 					_(strerror(-info->status)));
 			goto done;
 		}
-		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
-			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
+		if (info->status == FILE_DEDUPE_RANGE_DIFFERS) {
+			fprintf(stderr, "FIDEDUPERANGE: %s\n",
 					_("Extents did not match."));
 			goto done;
 		}
-		if (args->length != 0 &&
+		if (args->src_length != 0 &&
 		    (info->bytes_deduped == 0 ||
-		     info->bytes_deduped > args->length))
+		     info->bytes_deduped > args->src_length))
 			break;
 
 		(*ops)++;
-		args->logical_offset += info->bytes_deduped;
-		info->logical_offset += info->bytes_deduped;
-		if (args->length >= info->bytes_deduped)
-			args->length -= info->bytes_deduped;
+		args->src_offset += info->bytes_deduped;
+		info->dest_offset += info->bytes_deduped;
+		if (args->src_length >= info->bytes_deduped)
+			args->src_length -= info->bytes_deduped;
 		deduped += info->bytes_deduped;
 	}
 done:
@@ -200,21 +200,21 @@ reflink_ioctl(
 	uint64_t		len,
 	int			*ops)
 {
-	struct xfs_clone_args	args;
+	struct file_clone_range	args;
 	int			error;
 
 	if (soffset == 0 && doffset == 0 && len == 0) {
-		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
+		error = ioctl(file->fd, FICLONE, fd);
 		if (error)
-			perror("XFS_IOC_CLONE");
+			perror("FICLONE");
 	} else {
 		args.src_fd = fd;
 		args.src_offset = soffset;
 		args.src_length = len;
 		args.dest_offset = doffset;
-		error = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
+		error = ioctl(file->fd, FICLONERANGE, &args);
 		if (error)
-			perror("XFS_IOC_CLONE_RANGE");
+			perror("FICLONERANGE");
 	}
 	if (!error)
 		(*ops)++;
-- 
2.25.1


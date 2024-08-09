Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA27B19148D
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723198959; cv=none; b=oJ1i6QVEQmcEvwaqtNg5LsSYVLZXx83XAdAKGyN5fELR88v6LokVufzTt7ps7hc/xtGm5RVKnkeaKqO6vhL4iUxHYux/PA/VGvcl9gPW2q7KjNYTrpkz+zoG3hyxkPdUvY6DuyYeGHON8Sn1hAIxWLTbxvZX/ZBag6hqiZBACko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723198959; c=relaxed/simple;
	bh=OQ/x6oav7E+hedNf7+1b6nNj5PAtFNpVgRbZ/ybg00I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sBQCJ0z0GPrwGRhDSJHUfxGefmCkWKrBSy9sS+2YO2FH3OaZBVPTviGKFPbQdNwc6bN2prFE+IWFpuSDWlByCKizSp4wQ0ehi7TUNoATLn392mgtNp+ulE4YV6a3qRQJ1isZ1kvCej2n26p1UiLI3NzS+QZksDu6miIc4O1Fwjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4432c0c0563911efa216b1d71e6e1362-20240809
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:d6ea824a-cd80-4223-9655-f4942a0228c2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:82c5f88,CLOUDID:25e17f335be2bd2b59c1e443edf5f907,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,URL:0
	,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4432c0c0563911efa216b1d71e6e1362-20240809
Received: from node4.com.cn [(10.44.16.170)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 760140062; Fri, 09 Aug 2024 18:22:22 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id B803516002084;
	Fri,  9 Aug 2024 18:22:22 +0800 (CST)
X-ns-mid: postfix-66B5EDDE-6050021449
Received: from localhost.localdomain (unknown [172.29.156.132])
	by node4.com.cn (NSMail) with ESMTPA id 4F10E16002084;
	Fri,  9 Aug 2024 10:22:21 +0000 (UTC)
From: liuhuan01@kylinos.cn
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] xfs_io: use FICLONE/FICLONERANGE/FIDEDUPERANGE for reflink/dudupe IO commands
Date: Fri,  9 Aug 2024 17:02:26 +0800
Message-ID: <20240809090226.196381-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: liuh <liuhuan01@kylinos.cn>

Use FICLONE/FICLONERANGE/FIDEDUPERANGE instead of XFS_IOC_CLONE/XFS_IOC_C=
LONE_RANGE/XFS_IOC_FILE_EXTENT_SAME.
And remove dead code.

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
=20
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
-	 * =3D=3D XFS_EXTENT_DATA_SAME if dedupe succeeds
-	 * =3D=3D XFS_EXTENT_DATA_DIFFERS if data differs
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
 /* 64-bit seconds counter that works independently of the C library time=
_t. */
 typedef long long int time64_t;
=20
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
 	uint64_t			deduped =3D 0;
=20
-	args =3D calloc(1, sizeof(struct xfs_extent_data) +
-			 sizeof(struct xfs_extent_data_info));
+	args =3D calloc(1, sizeof(struct file_dedupe_range) +
+			 sizeof(struct file_dedupe_range_info));
 	if (!args)
 		goto done;
-	info =3D (struct xfs_extent_data_info *)(args + 1);
-	args->logical_offset =3D soffset;
-	args->length =3D len;
+	info =3D (struct file_dedupe_range_info *)(args + 1);
+	args->src_offset =3D soffset;
+	args->src_length =3D len;
 	args->dest_count =3D 1;
-	info->fd =3D file->fd;
-	info->logical_offset =3D doffset;
+	info->dest_fd =3D file->fd;
+	info->dest_offset =3D doffset;
=20
-	while (args->length > 0 || !*ops) {
-		error =3D ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
+	while (args->src_length > 0 || !*ops) {
+		error =3D ioctl(fd, FIDEDUPERANGE, args);
 		if (error) {
-			perror("XFS_IOC_FILE_EXTENT_SAME");
+			perror("FIDEDUPERANGE");
 			exitcode =3D 1;
 			goto done;
 		}
 		if (info->status < 0) {
-			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
+			fprintf(stderr, "FIDEDUPERANGE: %s\n",
 					_(strerror(-info->status)));
 			goto done;
 		}
-		if (info->status =3D=3D XFS_EXTENT_DATA_DIFFERS) {
-			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
+		if (info->status =3D=3D FILE_DEDUPE_RANGE_DIFFERS) {
+			fprintf(stderr, "FIDEDUPERANGE: %s\n",
 					_("Extents did not match."));
 			goto done;
 		}
-		if (args->length !=3D 0 &&
+		if (args->src_length !=3D 0 &&
 		    (info->bytes_deduped =3D=3D 0 ||
-		     info->bytes_deduped > args->length))
+		     info->bytes_deduped > args->src_length))
 			break;
=20
 		(*ops)++;
-		args->logical_offset +=3D info->bytes_deduped;
-		info->logical_offset +=3D info->bytes_deduped;
-		if (args->length >=3D info->bytes_deduped)
-			args->length -=3D info->bytes_deduped;
+		args->src_offset +=3D info->bytes_deduped;
+		info->dest_offset +=3D info->bytes_deduped;
+		if (args->src_length >=3D info->bytes_deduped)
+			args->src_length -=3D info->bytes_deduped;
 		deduped +=3D info->bytes_deduped;
 	}
 done:
@@ -200,21 +200,21 @@ reflink_ioctl(
 	uint64_t		len,
 	int			*ops)
 {
-	struct xfs_clone_args	args;
+	struct file_clone_range	args;
 	int			error;
=20
 	if (soffset =3D=3D 0 && doffset =3D=3D 0 && len =3D=3D 0) {
-		error =3D ioctl(file->fd, XFS_IOC_CLONE, fd);
+		error =3D ioctl(file->fd, FICLONE, fd);
 		if (error)
-			perror("XFS_IOC_CLONE");
+			perror("FICLONE");
 	} else {
 		args.src_fd =3D fd;
 		args.src_offset =3D soffset;
 		args.src_length =3D len;
 		args.dest_offset =3D doffset;
-		error =3D ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
+		error =3D ioctl(file->fd, FICLONERANGE, &args);
 		if (error)
-			perror("XFS_IOC_CLONE_RANGE");
+			perror("FICLONERANGE");
 	}
 	if (!error)
 		(*ops)++;
--=20
2.43.0


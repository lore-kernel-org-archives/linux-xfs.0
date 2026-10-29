Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275780;
	b=onaFwAdHt8+cE4Et70/Y7o78eQjcUm13g0+crgxWG+v58dbRue4bLX5oPnUDqxmdqRlF
	 DqOjICLGyGJqID5yyHVXD16Y0ngkX9xZ3feheLC2xjYAM8KvgdDULppR3iNx6e0wkV18t
	 wBBGOPejKtMQ+GN84fmfphx7YS+Cpb0R8wYMR1y8Nmlyv2c6QKUj0DRdXXFLzEblM4aOi
	 oU6zDTikAoXg/NdENVSpLucBXfmlP4Oasl61DwlfqY+00jFKvpP+gqUkBH1EmHiCgJUN4
	 Wz2zFTO0nCEOq+sBtNYVtt0LCwD579bL3wgngeFbcd7IQGK/Tep0TWSTn0JIAphHAzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P5Lh0qrcOkC2g83jhqQ7JGw35q2mQKJgEtcU6h87wnU=;
	b=VgEI2SzwetCJ26AJ0jq3VejQxlwZG1ziy8bjE4lGkVf389dqWemONbHTPEkI68MddqVn
	 aVfZAyjSAtm0zcZ4pCVrrDtgLB1C4BWpeV8MO8/DwpNfXoJJ7FTMV4XtevhCcieSn1TlD
	 afOLuNhCgJTfkwtUZ2y4WyIM6DdfspwaqaPiUgcPOw1YMp2NMNDLtdCiEMT5OlNxMi9Uf
	 VeRAa/LK+f1q0mdIgidIyTnC9Vl6igKiezQ9YoDqULIQKo2RagAWFc6gwYFvsboZAVgrN
	 kMPZTV9SNC/u4RFRqg11oPGdKWL8njLtF03MJObjfo0e3gvtoMTi9kxlP2B9TZ7mElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4doQQSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FD8606A321
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4doQQSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CE31F01828;
	Thu, 29 Oct 2026 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275780;
	bh=P5Lh0qrcOkC2g83jhqQ7JGw35q2mQKJgEtcU6h87wnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4doQQSpFqn1S8HFw5dwMJ1dqcGL/PGm/D7SLQRYIJWDyy6vJfe22moS2Syno8Y2m
	 b2HsXw7w4MR1TTBf6SjrBPyVrvcncpxiHVNPcmm+tqqX/xa6cwO7QUG49HeIPAzsCf
	 iTY8k8G7cJ/yOHNqRQpfH67UckS+yOOCdyWdscWWv9lpoj5Weu3a8fignQlH2RS1uJ
	 A9llAfIqgAPnOBmZB2QG4yOlXVPbJS6LHBcpWesirDQDMZPa/Lx9x1cSleb01q8aTR
	 0/TAnkroWj9/sWLaBL9CoMyvQzbDgplXZ/uo5xxoLoyXQtxFO8xAHzNzM7kG3wh0Ug
	 aw0p7xOZHn+wQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 04/28] xfs: mark internal metadir file creation helpers static
Date: Thu, 29 Oct 2026 13:06:01 +0100
Message-ID: <20261029120631.803074-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Source kernel commit: c6c54d05b129c4e29f2fdc6d356b5be10765231d

Now that there is xfs_metadir_create_file() mark
xfs_metadir_start_create(), xfs_metadir_create() and xfs_metadir_cancel()
as static and remove them from xfs_metadir.h.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_metadir.c | 6 +++---
 libxfs/xfs_metadir.h | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index 0d6a153bc9e9..7c6b086b73db 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -182,7 +182,7 @@ xfs_metadir_teardown(
  * Begin the process of creating a metadata file by allocating transactions
  * and taking whatever resources we're going to need.
  */
-int
+static int
 xfs_metadir_start_create(
 	struct xfs_metadir_update	*upd)
 {
@@ -236,7 +236,7 @@ out_teardown:
  * a negative error code.  If an inode is passed back, the caller must finish
  * setting up the inode before releasing it.
  */
-int
+static int
 xfs_metadir_create(
 	struct xfs_metadir_update	*upd,
 	umode_t				mode)
@@ -425,7 +425,7 @@ xfs_metadir_commit(
 }
 
 /* Cancel a metadir update and unlock/drop all resources. */
-void
+static void
 xfs_metadir_cancel(
 	struct xfs_metadir_update	*upd,
 	int				error)
diff --git a/libxfs/xfs_metadir.h b/libxfs/xfs_metadir.h
index a795a2d0e3fe..e434b9d1c932 100644
--- a/libxfs/xfs_metadir.h
+++ b/libxfs/xfs_metadir.h
@@ -32,9 +32,6 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
 		const char *path, enum xfs_metafile_type metafile_type,
 		struct xfs_inode **ipp);
 
-int xfs_metadir_start_create(struct xfs_metadir_update *upd);
-int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
-
 typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
 
 int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
@@ -45,7 +42,6 @@ int xfs_metadir_start_link(struct xfs_metadir_update *upd);
 int xfs_metadir_link(struct xfs_metadir_update *upd);
 
 int xfs_metadir_commit(struct xfs_metadir_update *upd);
-void xfs_metadir_cancel(struct xfs_metadir_update *upd, int error);
 
 int xfs_metadir_mkdir(struct xfs_inode *dp, const char *path,
 		struct xfs_inode **ipp);
-- 
2.54.0


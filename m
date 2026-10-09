Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8035B14E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589602; cv=none; b=P2vUqHJvRT0JXDY3eI1VtFR1UudFlP7SVVFdJWRI7z01DUmIKpT+eOp63pLSvJ0JplQi7zKZyxHKCFwM72CTdOcBzCYoTyLAzO612FAgqje2F+sh/WCe+GoLAbJxMHj41wO0tEjtNLwBsWd3ps+sl1Ad3ohMrYLQzctVCAY/XMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589602; c=relaxed/simple;
	bh=hhUOG7S83Oqzhu5TwDY1GD9SEdBgD3dZKOdQRwRrDxY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAm0BU5s8wClzPWiP0KSQxnTMJ2tFIoGLmQ/ByhELEf7GQaoRqQlhl1hUhXzRoTe6y1/VJM5rn2ONH86tw6htxpCLKoJgFgzCCL9LNwzFDdkLErfcw9cJcpFtzfjXgmuTVSrm+x3ULAnUyN9UZjKUnh1ecKtrvZDtUlQ8Aa9l2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDK1MolI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDK1MolI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E4B7A1F000FF;
	Fri,  9 Oct 2026 23:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589601;
	bh=oMNXjLCY9bawc/wzZ6OxEOh740GT6MDVIdGDRmmswUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IDK1MolIfFAV330bL4nYndYhGm60qFHbbJXTgk5oZniF44TP0qTq7X74KRNEeQPKt
	 E0P+HSKcmsso3menIg97RpB/UZBSgjCYTJWTf/SelLm9eP6CmId0o20Pil+10xaKUJ
	 C0fwAC/WCO766TSlPV0dUF0kxCQfgnVPjCX7l2CqY5HkQ+MPyjuryMS0lz5YT+AMHn
	 5ph+QohgXp9/TXnr/din1/00FdSO4geUwYyex1APqXFBtWziMJowDNBchESruiHAQb
	 1gPwwmofUraApNj2uOK1YWDhyeUALzkl5NiS3zHOOii291DMM2WOanITGaXUPUn8ra
	 glQe7aUJ8BaUQ==
Date: Fri, 09 Oct 2026 16:46:40 -0700
Subject: [PATCH 04/26] xfs: mark internal metadir file creation helpers static
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, johannes.thumshirn@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947441.3719791.9905096580050714951.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 libxfs/xfs_metadir.h |    4 ----
 libxfs/xfs_metadir.c |    6 +++---
 2 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_metadir.h b/libxfs/xfs_metadir.h
index a795a2d0e3fe5b..e434b9d1c93200 100644
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
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index 0d6a153bc9e995..7c6b086b73db61 100644
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
@@ -236,7 +236,7 @@ xfs_metadir_start_create(
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


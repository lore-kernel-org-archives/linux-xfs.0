Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCE8369D71
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589586; cv=none; b=egDxImoNbFcRTTWLXTwoCEmAzFqJ8C+KFNRbd61S+nmqUGuEZywe3nlOFlHmWS0HRm4HT/zji6w/7SIbAVN4jOzXigXdpA2Ky/Tvmo1yZP2lhmhvWfUxigsAz9FYSL//rcGAoFTyeeaQB36D9keOnIbfZk8KdcQPBwyOlAdRTFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589586; c=relaxed/simple;
	bh=Zho/stR3bnTyT0YhwelQwukqnXUbJUvNZj8wETk5Rjg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Omikel7HH6Ji/WzKcRAlWGaUkyxws3B3uYBWqY367u7sYAqtusZiOic0PSY2L67Qf/Vzs/XOtT61put7QNzL3KYs/5vfm6RGE423BJoDwFf8hJPtvPFQPpYYkF+LTgtX/WpgWprWt0VIx1xn/E+Xi4xo2GWJjC/lIOVoI/hUiJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5Qz31PV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5Qz31PV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4E6F21F00893;
	Fri,  9 Oct 2026 23:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589585;
	bh=QnXyBczGXeDLWrMmcLv0TthcExUejYIQmvvIx9qKJ5E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=M5Qz31PVM7fZuWRGpyezBBEqjaStrrNn4Rn4qG/JBTWkf1086uLBN9QtL8drWhlPr
	 Sfo/mH65aNjXCP8BKL+fOj3poPtCAwmsm2vA0mNKJXf/DInvGUgazA07fj+Smv0ozY
	 Tus+HVqFJ4OPMp6Z3peD+BwVckKblp21WZc/BFuS/dTkT42LIm/k6CZFc0P/1bIYsl
	 HTonIWrbYFye1SaCXrc6ZmqW/HK3oxiKVfTyx3HSJDd3kryadi0WWhLkSTM4QGeQKm
	 pjF7GpMOTB1RqtXkXa3d3NIwAsxXp5U4E5usjdDcMo7ao32/Bx8Q3DlyH5Zjo8D3a5
	 t0bSfICaMohMA==
Date: Fri, 09 Oct 2026 16:46:24 -0700
Subject: [PATCH 03/26] xfs: create rtgroup metadir inodes using
 xfs_metadir_create_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, johannes.thumshirn@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947423.3719791.17186372343796902414.stgit@frogsfrogsfrogs>
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

Source kernel commit: de64b150a70cbf4e9499921d6cb7dc52fbeb55f7

Now that we have xfs_metadir_create_file() use it in
xfs_rtginode_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.c |   58 ++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c1f8d2cb186a39..93d95ca33d4a53 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -515,6 +515,25 @@ xfs_rtginode_irele(
 	*ipp = NULL;
 }
 
+struct xfs_rtginode_create {
+	struct xfs_rtgroup		*rtg;
+	enum xfs_rtg_inodes		type;
+	bool				init;
+};
+
+static int
+xfs_rtginode_init(
+	struct xfs_metadir_update	*upd,
+	void				*priv)
+{
+	struct xfs_rtginode_create	*rc = priv;
+	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[rc->type];
+
+	xfs_rtginode_lockdep_setup(upd->ip, rtg_rgno(rc->rtg), rc->type);
+	upd->ip->i_projid = rtg_rgno(rc->rtg);
+	return ops->create(rc->rtg, upd->ip, upd->tp, rc->init);
+}
+
 /* Add a metadata inode for a realtime rmap btree. */
 int
 xfs_rtginode_create(
@@ -524,6 +543,11 @@ xfs_rtginode_create(
 {
 	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[type];
 	struct xfs_mount		*mp = rtg_mount(rtg);
+	struct xfs_rtginode_create	rc = {
+		.rtg			= rtg,
+		.type			= type,
+		.init			= init,
+	};
 	struct xfs_metadir_update	upd = {
 		.dp			= mp->m_rtdirip,
 		.metafile_type		= ops->metafile_type,
@@ -542,38 +566,8 @@ xfs_rtginode_create(
 	if (!upd.path)
 		return -ENOMEM;
 
-	error = xfs_metadir_start_create(&upd);
-	if (error)
-		goto out_path;
-
-	error = xfs_metadir_create(&upd, S_IFREG);
-	if (error)
-		goto out_cancel;
-
-	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
-
-	upd.ip->i_projid = rtg_rgno(rtg);
-	error = ops->create(rtg, upd.ip, upd.tp, init);
-	if (error)
-		goto out_cancel;
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		goto out_path;
-
-	kfree(upd.path);
-	xfs_finish_inode_setup(upd.ip);
-	rtg->rtg_inodes[type] = upd.ip;
-	return 0;
-
-out_cancel:
-	xfs_metadir_cancel(&upd, error);
-	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
-	}
-out_path:
+	error = xfs_metadir_create_file(&upd, S_IFREG, xfs_rtginode_init, &rc,
+			&rtg->rtg_inodes[type]);
 	kfree(upd.path);
 	return error;
 }


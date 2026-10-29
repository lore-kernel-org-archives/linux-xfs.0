Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275776;
	b=e2ViSCnEKEfAJQw/Y4lLbuuAhizjEyKia+AMgiPcAQO+w7k2WwG6Cx3+nM8fcQLMRI8K
	 zoGpoFbDa9N8A36UwS88WpqpxhoUjddyw/jFMKPjQGil1I5gd6noROb9M5lAHkHSN4Ano
	 km6ar63RE04RMkh9dKcsIMWn4iwGiln7xDylWO8DfbfJ/RBc6HZD1ogAn9LsF4ZnVI7TX
	 LMitQD36rd8f0Hvia8Vben8M5zlzFzBYCILjdNWRhJnT72itYp2sW7x7QNqHOF5etvzJT
	 UodJ5drEmIrEY0DrHBCqp2Dpn41w31jSw4KJJ86lKPo+Ye6Gj4Ox4jyDqJWwXAjnZ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eBRPIgTCBEt/T/8MQ9e5c+Zj5af71nORqPsXQ310b8E=;
	b=ELIyMAMZ7kSE5BynBGj1sN9019MWabVEc7vsPpd2xpTEibCjQh+6MrlK1IaxbgJy5Brf
	 Hi+rloUvHsiRBbqU83ohDhFza8cZsZmDxJlX4IdBymSosWckjyBRL12tTVVjGW4951yxH
	 3kDNMNvcAiPaZcMyuxQZeVnOKEobWjVqUUs7EYDnd3cw8qtKmo+PmPTj5uCJDxvI91JGw
	 J1YfWH1Va9sQoe/UjcEKkm99VOQwDy+zwsmy53KXwNtUHs5Pgvqq6SqU10di/bPcivn9P
	 PLEVkCyVQvI0DQ1U34VrlswDO4Ptfv93yh+caS4Tf2+PB2SYJyclkwQ4iAcPaPnhvTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8U2lRsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F8606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8U2lRsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D631F01829;
	Thu, 29 Oct 2026 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275776;
	bh=eBRPIgTCBEt/T/8MQ9e5c+Zj5af71nORqPsXQ310b8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8U2lRsjtGSM7pU52SDTZXhrxeMFJw5HR9FTOmmds+6guF1R8amvugb2YAiVt+ga1
	 XYbZAaD8+W9ArwZ1AZig+k5e301OxPkvC8B5/H5y4xqjFeNsxc4pmhD+uxl385iCeq
	 o3BX8psKOACZo/7Dqv6ir0MotsiE5r32d2wO/4tI9coRPWaWnmv0/LUCWJQ+I0fF2l
	 9nttgBmaOEcg2WrAxzc+uoXm4Spz06Y/F7dFSM9taeMYADa2sadHJbyTPgBOpi6cNA
	 4mlNUw7p3BFzOGmDI4FE6aokQX+IY9Hkk8mFehhgHJHMKHr5mgDNujOVDKixPfmZ0E
	 S/SQn9VHYlqvg==
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
Subject: [PATCH 03/28] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
Date: Thu, 29 Oct 2026 13:06:00 +0100
Message-ID: <20261029120631.803074-4-aalbersh@kernel.org>
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

Source kernel commit: de64b150a70cbf4e9499921d6cb7dc52fbeb55f7

Now that we have xfs_metadir_create_file() use it in
xfs_rtginode_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.c | 58 ++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 2bbe651b773a..c6981f566860 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -516,6 +516,25 @@ xfs_rtginode_irele(
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
@@ -525,6 +544,11 @@ xfs_rtginode_create(
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
@@ -543,38 +567,8 @@ xfs_rtginode_create(
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
-- 
2.54.0


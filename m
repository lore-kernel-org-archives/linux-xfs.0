Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275772;
	b=UkOWuboJsnerM++dBg9iMebwySGfOH0/xCOnsNvuOyAmUnuul68dUw03pC/zaXtA/vpe
	 32//XIoPfDSQ13lVfOt9uUDzFkmQxxepFvdgAtKqTOMMKAilQ0PQXT7B2ZA6SMXXSUEvo
	 HLS/RlHZ6TFfJ0ivfOhAZ/nMRZPVlSdgi2R37i28SgRpov/utaN0wzsnfzcn+zdOI+5JO
	 KnmDiWnPl9ezScEu+5ar7tg6RbdCXgmUbaCcQueTUCYwABbNyk97iQRKUpoIGqAjwc4bw
	 SGJqK8EW5jOlqs7jSteTXl6vRmCApaE2HTs5cLIAvOALH2GkIkUhHoFLlXSkgxpA5HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bdVpsIrZol6f+FoIHpF0JuBnicbUoRXgW4zU7b1Ez74=;
	b=32wct+10s2QJHu7w9M6QxmaSC0JeC/DQLDshmTDzdYh2gGClHNUtKEARB8jIy0ZqMbZC
	 dIr/BY6VVB1OJUU/L0fvvMfbvERE76j69Cg+Cssg59z+bouSC0lWJrK9M7yQ+QY7MQlJD
	 cyydd3xFvDjgpcJqZZaKkm4p+JeDFwR2au6UNo+qjIAecxXswMP/eP8d+w8xGEk7qRM3r
	 ohk5xFHHq7XpBUtoYxDuRMYYhTXvwbdevMb3lNhJNaYN4GM12zWjIEdKkZNuT3YWGKTZo
	 2V0RqJHJsqulJ8ObjH//ufldYFt/YboSdULmNR+p3j3Q40JZkDCP54NJcaPqopkBx4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoSQz9Zr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8C606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoSQz9Zr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBF31F01825;
	Thu, 29 Oct 2026 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275771;
	bh=bdVpsIrZol6f+FoIHpF0JuBnicbUoRXgW4zU7b1Ez74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoSQz9ZrRx2Hh+95CKjwZBnn+oNdRp5AKzSZV4336oOI7EsqJfftrrnDES8Kbdhp5
	 hAnu/Sbw2Zengxc0/u068nF//V+9+NJCfcLUVeCAhGXYyLxeDEuDbh8of+cYTwJxyn
	 GDc3ILKFmyF0LLYVF1dApEPFUKQe3jL2IpTxzmqSClq7tO3NIl1OlYB0E3G1nHm7xI
	 mDkBaMq6Jt3wNj8wMuEDtNL0wqm4OYiWHYEdvIUDYflirF3HXJOY5+4RodeOFy3Ccs
	 eN3k/JIiXL7bC+HAt4OsQZysWQCAC2Z4GEEo5pG3WmHCLByi6Irz5MzAvE7Z3cTVym
	 PiGt/Ip8/+mCA==
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
Subject: [PATCH 02/28] xfs: create quota metadir inodes using xfs_metadir_create_file
Date: Thu, 29 Oct 2026 13:05:59 +0100
Message-ID: <20261029120631.803074-3-aalbersh@kernel.org>
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

Source kernel commit: e6ecb1a98d14b1e9ef0cd8f3340d30b5f491d2bc

Now that we have xfs_metadir_create_file() use it in
xfs_dqinode_metadir_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dquot_buf.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 0e59106303c4..21e74d6d17d9 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -415,6 +415,15 @@ xfs_dqinode_load(
 	return 0;
 }
 
+static int
+xfs_dqinode_init(
+	struct xfs_metadir_update	*upd,
+	void				*priv)
+{
+	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Create a metadata directory quota inode. */
 int
 xfs_dqinode_metadir_create(
@@ -427,35 +436,9 @@ xfs_dqinode_metadir_create(
 		.metafile_type		= xfs_dqinode_metafile_type(type),
 		.path			= xfs_dqinode_path(type),
 	};
-	int				error;
 
-	error = xfs_metadir_start_create(&upd);
-	if (error)
-		return error;
-
-	error = xfs_metadir_create(&upd, S_IFREG);
-	if (error)
-		goto out_cancel;
-
-	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		goto out_irele;
-
-	xfs_finish_inode_setup(upd.ip);
-	*ipp = upd.ip;
-	return 0;
-
-out_cancel:
-	xfs_metadir_cancel(&upd, error);
-out_irele:
-	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
-	}
-	return error;
+	return xfs_metadir_create_file(&upd, S_IFREG, xfs_dqinode_init, NULL,
+			ipp);
 }
 
 #ifndef __KERNEL__
-- 
2.54.0


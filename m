Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B2735B14E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589571; cv=none; b=rhFEctdHjQoL/noNo7KPfO71tqOmeeNqfqmWeyaM6lT+vJQV5LsJnYte0PBpHBSYoqEBWrHD1IerE5AA9rcfJCDkt+kVEV/jAv88J9SRPrgbZTFiQtt+Lnoo/3oMGj0ZAjHgT1DosFNGGc6FUk+Rzh9hZyLkFxuztFit3k9wVp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589571; c=relaxed/simple;
	bh=sd0hjfKp8d8UY8kxMMfcAckbl2t2JIJtosrqFavSawU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilp+hwDQFY8nC81of8GgYMXLENE8cjBMc+Xas0zjEGoNdKc1uXo1NnjtUDt0/DQyTDeNFhCqSzRme95mJWZxuDwgKd+yElzQ9QPDrnw9OBYhawsCNLCn6NXVF7FYfkqoe3f5wji3O27UlQ1zEQEiL+erDiF/tLOO04y6rH1Xky4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liplLz1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liplLz1G"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB9C41F000FF;
	Fri,  9 Oct 2026 23:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589569;
	bh=eLXfouEGXvlLqplT48Ps1B+qbQunUhd4LxhN5OufROw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=liplLz1GntM9jf/2nYtBABuWZm1GD3mF/pvLawBWBgy3xwAcTMU5ku8DZGliXcgo3
	 U0lF438XCMW3AwB2H2UknHmun53ZgdwX7NT9/1LryHmvu+/fiwPgSerinRl+Rl7fEg
	 5sT4gVzzOfvt9WUpBHxl005OIWeSzE1PTsjzT+gUasJk2AUNHFZ37WQOulHm2HcJuM
	 1bKyeBtzs/WsTQ4SqisQ9/gNGEEEW+qDatHv58spu/SGnR7NhNOhZoCSM0/hL02MnE
	 knBg0VQiCXB5E+LMj3Gm/Z5xgSo6JTuMX8JyclLCvYtuJHNsY9pVq0y6h6aN/G8GV9
	 m0thpMeuY+Wkw==
Date: Fri, 09 Oct 2026 16:46:09 -0700
Subject: [PATCH 02/26] xfs: create quota metadir inodes using
 xfs_metadir_create_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, johannes.thumshirn@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947404.3719791.2403621139683950463.stgit@frogsfrogsfrogs>
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

Source kernel commit: e6ecb1a98d14b1e9ef0cd8f3340d30b5f491d2bc

Now that we have xfs_metadir_create_file() use it in
xfs_dqinode_metadir_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dquot_buf.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 0e59106303c46f..21e74d6d17d961 100644
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


Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8116D34165F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035150; cv=none; b=eR8ALpEf04hGZfnTAGTKxWfERB8ri4xsyGX4c9urXgl2yM0dPpExAq3H7o3GpRMKPMN+imcIXDoAT0qVZGUYmcb1261ciVPw7MnsufNdOsoezEPqOAi0YI0ua958zk76khJ2m1zIb0kOoFSdE4oqek4FPkUEMJAPUc3u4ed3wpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035150; c=relaxed/simple;
	bh=fEsmLesJVG1ptqhvQLL6m09yiByqXBJVbenzLBNWOdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmuszynaI+i5SZ/36n1kVErdq/J1Jh/dwZ+plhtHgYZWFCnZl1Mnm9assilb07sdzqglitxL3iO3q/f+J5s3XJTJV2parurdogjAfI3Fg8VXeL/lZfX0h9szNjrREKbRm5sGvZ698g5vm1rDP0mlviisZJRH9gAyFwnqt/xC0R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWc+31BF; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWc+31BF"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7762021c574so3252986b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758035147; x=1758639947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Sn0YxjQ11kIHhQIy1ZG/2i2BBYzZFcF21jPuSyb91M=;
        b=gWc+31BFH7osOfq1K4I2Ahl7RDui5eo74EimXChfzlvtEikLCGFCIX8Qw5OeJO5edH
         lF9g9HudLKyq3E+3ImuGg8uhCS+PZCnQ/jCNpvzWBfl71qz2K4Cb4HaEEzpNLGuHUitK
         FvfOjER8AQRJH57ae9aI5sO7omu5k8/a6dhVbS7nNQ7+kIr/OVeRbin4vZOjEH8Y5RiZ
         +EroOCiqgwlcgHbh8xVxwPr4NiQPgyKORdUX4C2EC7wGKslHGEsdemyXr+s7Dtem4pTo
         zj6eWDXAaOvTehrJ2r637c8AqzfCkFPKn8e5Maufq4mPVt/qjYMdac8djaIiBP1g98R/
         A1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035147; x=1758639947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Sn0YxjQ11kIHhQIy1ZG/2i2BBYzZFcF21jPuSyb91M=;
        b=hKvaUIoClhJlEcDGX38vCQZTUqaiT2P9sHuHzSmxPy7ZljzKSgbp/eC/0osbP10yR/
         hX0HbEynustTvYW7MLwARP7dsUZiiK6vkHMjXYKMx9nFSpj6gH3niRuCgPw+8sidoVdv
         TbcILR6/cm0qBKX7qMp9bNPNWeZWq6/ddNy0C6aek/Yex4vT9zs2nFpYAmkAlXfNxORp
         3yN26NmdJ0lh+6EcQEaCZcI3l8nnmn2hKt1mcFmVvfv9upePYZZDUsrOT2MaSDJMRSW3
         /5Vs/RarZY1v+gtFrEliP33anwCiMkd8oV3c5FXsgiFVna93iG6sMOBccOT09pkxhrcE
         vhpg==
X-Gm-Message-State: AOJu0YxJ0QaCxDtEbEaA24PzgpDzutor4c/NrTPZkrh2d6EhAywso9dO
	RelzR2UnhZ5k9cPrqG0jxTg9bYstaJyGpGnFQVVqbCUMAgXF8BXitNazaXL4bA==
X-Gm-Gg: ASbGnctTYha3HXIWZA3OhkKowbVpyK0dw4EaUE7q5GrYmsoVAXU6cr1XOHZqVO7d6sQ
	Cf0cFGVzy7UkV/OifOIPnUNvGuzMll+CqAe0j8+ky2PYSNVdiQTiLeXtZaPRk945+FJ4Nx44sKL
	jEj1v+b8xjfjKto+6oxrSj/t7Yyu83WNTSEcSV5FYb2QSc9uzUO53wNbSCe2Kk86G5CHAXfqy0G
	ejqXoJYojcnp1nU4aSnLc3F0KQSiiN7gHYBjtDHipGaIfBdrbjI0s8tZk2kdNSSgkxWtud5QBT3
	erSmFLyV294nUKOB3+3I7qDE97obnXrI2eHjSLNgPWscBXb2bHMzC5N/vk7a5ZtZz7/f88p53N6
	fmzXgWuTp0ubY7CD4pOIbaMw7P8+TeJHPW629HVtYbYeGKDFDUulg4oounEiy38g5JerleYCqUm
	Ks
X-Google-Smtp-Source: AGHT+IEOSanHQQ5xFMV6ljquXxngn8S64acWJbnEnc+kioKlu5KUxQkT11XVcUdIWA3oBZEgfdcu7A==
X-Received: by 2002:a17:903:2ec6:b0:25c:982e:2b22 with SMTP id d9443c01a7336-25d27134267mr157705155ad.61.1758035146387;
        Tue, 16 Sep 2025 08:05:46 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.211.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26263a76cd4sm94737175ad.31.2025.09.16.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:05:45 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V2 2/3] xfs: Refactoring the nagcount and delta calculation
Date: Tue, 16 Sep 2025 20:34:08 +0530
Message-ID: <ed6d15e5c472859351d81981104a4b16f670ae31.1758034274.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
References: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce xfs_growfs_compute_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  3 +++
 fs/xfs/xfs_fsops.c     | 17 ++---------------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..f2b35d59d51e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -872,6 +872,34 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_compute_deltas(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nb,
+	int64_t			*deltap,
+	xfs_agnumber_t		*nagcountp)
+{
+	xfs_rfsblock_t	nb_div, nb_mod;
+	int64_t		delta;
+	xfs_agnumber_t	nagcount;
+
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
+	}
+	nagcount = nb_div;
+	delta = nb - mp->m_sb.sb_dblocks;
+	*deltap = delta;
+	*nagcountp = nagcount;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1f24cfa27321..f7b56d486468 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+	int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..8353e2f186f6 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -92,18 +92,17 @@ xfs_growfs_data_private(
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
 	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
+	xfs_rfsblock_t		nb = in->newblocks;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
 
-	nb = in->newblocks;
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
 	if (error)
 		return error;
@@ -122,20 +121,8 @@ xfs_growfs_data_private(
 			mp->m_sb.sb_rextsize);
 	if (error)
 		return error;
+	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
 
-	nb_div = nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
-	}
-	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
 	 * supported, and reject a shrink operation that would cause a
-- 
2.43.5


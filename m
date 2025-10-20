Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99B26F280
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975114; cv=none; b=a0BwkRRkWQwgJHjrKjq+m3hG6vZjisq4jStM4NRA3G//ft44Bovc+YwUV82Na1jC6zD/e1RumzehO3D5u38bsGtsbi24y/Gx6AOnHP0dv3bYgTF+YJOdZXHqfpXghKVU0LtdBifH/gyJOkBA2FLbPOGR1xoeRFA4yrFhyUosG6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975114; c=relaxed/simple;
	bh=fEsmLesJVG1ptqhvQLL6m09yiByqXBJVbenzLBNWOdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZNRwjasrNqHEZ2558RqqsIFN20P5o8AN+XCCiI9UZwQL0oj6BOTCjJg0PlROy0NB+5MqL+e6i58yvAvtBPOT0J7jwvP/dcsBIj1PvwAdtOE0DfkLUmg9RD323lkDZHNweq79QmbljUE9q8+Odw8V6NfVkp/KxhpKJJa6PFGNJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Myg0p1C7; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Myg0p1C7"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33db8fde85cso1143977a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 08:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760975112; x=1761579912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Sn0YxjQ11kIHhQIy1ZG/2i2BBYzZFcF21jPuSyb91M=;
        b=Myg0p1C7IsQkt1tCRRXnOdeSbGnoz1lKtUbGdccEDbfISJNASVmwzGIkejLTT+bVUr
         j5BpHLjhHJlAy83sve35qqL7u+0M00p0C6leu8/o0/pSawKD7Z+hiVx4Jb0vmST4vcsR
         1j8IZDIbfnLBjpmtR6s49rKhjkyaA/ro6h+0/jDIQEE3+j5m4kY2aIZIwI/jhJKB8cDY
         iOMFdb4ptQsQguEMeyWoxvwV5blruUDJQDRsxMVW7cCiCCQWUFRQq9zopS8jHn3BNJK1
         Cys/aSw0MdlIsykIjBuY+F1T/gOotEU2nWk/ILmX5Jg8OzKRXox7ABUiejyFkC2B0JwV
         AyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975112; x=1761579912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Sn0YxjQ11kIHhQIy1ZG/2i2BBYzZFcF21jPuSyb91M=;
        b=p7TxyfaM44+tBcan0SGtVzPpsoClmqEaY1qnvnnY9rBCoRvt2pf0ERPMYAftm6kpMR
         EZNo83gGLFKr+fYWaIcKt8rFbZvXjU+xH+ipua4lX5/B951SlySMJ0W4N77kya4SqvIO
         5bss5/MsaRL8jxEz2fNosDqRCtyXhnbyRFhEVcwB+xhJErnStdYI9V6sIJBFYRAMZ8qM
         +m9p0ReVAocOIpHiBRX+few7YHGhANppQIEYY3givMF2FN3BhkBGMuLOtm/OR2Nxa0ps
         virrIoHxVqUX3QbHWhDweH9gf/7oWMUVv3G12dAzHYsgk/jFue6LcI6sNfQ0BWOhh4/O
         EqwQ==
X-Gm-Message-State: AOJu0Ywzpao5g9CgeLwc15uCaTkKYyEoh7rkHi9AlKoTMTyHsnwbMwcM
	QN/po81CVrpWVjzgE+impR26EhzQd2ELYWGUTwEhQlS6PEi8Ngf3PRpuACr3Wg==
X-Gm-Gg: ASbGncvyfQdS05TRhztv0oD6yfK9xnmBj+bp8EME8FSnPKdEMz4DYqr02uvpw8M79Lt
	QujtMo0vsELGitGIA7+9txuZ0yy8vsCUOnS+7uQ5xwZXI6DcgAMg/CNJk437RcXnhubRkQePSuG
	bRYuh602zzoICRqoo3c2r3b0qP9E/fVLXpczUzW/r9QwiBsLTjRnw4m9OOejLX2Ky1TCc0A9dKe
	J0GhbjgcnQUJGLNZEV7lf1WLWEHg9yLCinCeloW49HPheSYMrOR9rzvruHQ39TvCwgxpNlVOgv0
	bJkG56IhfP7ju93q61K7M7sUnIe6rImU5m4l2FZiS8AQSllPQetNiDh2/NiFM2O+8HdgHy6ycDg
	ILHEs1LXyS0XBcze+wEFHGmXFYfvyX/3X3eVk5aVPcNqFf9hy7FC494mkLLgRgI7UdxLXs34UBg
	JICsClXFjpzLe0hYWGHFWBHNp0j6t23xM1qk8/SJl/uXrte11rz84jnVJeR7Zqmqh6
X-Google-Smtp-Source: AGHT+IH9YOjt4RzSxCgl48/xefu69qdD4eVvyf6ELxCgfmL/gb443RPZLUA5H9ShnTeXTdJhRJARRw==
X-Received: by 2002:a17:90b:3e43:b0:339:cece:a99 with SMTP id 98e67ed59e1d1-33bcf86c699mr20309654a91.13.1760975112323;
        Mon, 20 Oct 2025 08:45:12 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b73727sm8075327a12.40.2025.10.20.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:45:11 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V3 2/3] xfs: Refactoring the nagcount and delta calculation
Date: Mon, 20 Oct 2025 21:13:43 +0530
Message-ID: <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
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


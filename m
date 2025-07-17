Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7D128A700
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752748398; cv=none; b=BMxznHX0kLZCBHUh5/FaWhoIi6aXba1jwc/PP/n7Pfytde4uzAbYNEBcYFkjRNfX7Y1Zyqyn4FlVjL5cVA/8e9HSFb7KXSpPgHj/GaDOTduGhUl22gXKtkS8yzqSisuF6EKn5hYAl47VubKE1CVnaoiC6FgK0e0NGQhACBMVgJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752748398; c=relaxed/simple;
	bh=Zi6r+RzkF/yONPIfZGlEMuZbNtv1A1Gv/B2HC5R3FlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3sSCRM9FkVkgPOKN1gRoHbO8wy0vWQV4k1oh4OczrkBJXAkXLnCTnhwtKsuWoNduSUZfkQf0E0NHITFIrmTeaItbxjle9ZqPKg9g1v5rgnF+yMBPfLBD90Iy0/xQEte5zVuYgXABK6qecA7UlccukX1JsmIFArePXaDEzDqyRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MumrxIRq; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MumrxIRq"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-af51596da56so637461a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 03:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752748396; x=1753353196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwOT0gPrKW3v7JBe14vV2q3jj8lwGQ/kIEUwjVXY/0k=;
        b=MumrxIRqi9JFgHW76LyOK0xuoAGHcJa8wgDRgOtk6WxF2F8a/IU5ktlfmbem0bMY4O
         JzPsZMyy029ULoh/bY/kYwXau+pJ1E2cBI82vYKQ+nGQpPajJ2GAPy7INTCVdp+FC5Cg
         1tKJPLxplnXEAwCK9AIWTgeFfeAawljm9Hc+8k4VyqxLtwXpNT4XTDB8JYUwAVcnaWNC
         ueYIWT+zrjp110KzmDWw9rKbnXcGp6I+RBQKFMMfX3f9Gm8aR1swS3IPXAYVRlfeYzd5
         0DupfsZnoAVbO3dumPS095XfajBjj01o63oxmLF3xbVDmmJP8XPUr1cdUQfDOqrwgIcO
         EWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752748396; x=1753353196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SwOT0gPrKW3v7JBe14vV2q3jj8lwGQ/kIEUwjVXY/0k=;
        b=o/hz7hambJUmECyHrDQ6gJpXKQxhdVf93ZltFD6J9L7rC8fcgMqMwQZ7nj8koXJHU5
         7zEhI5WJo+Rhg2F43dav8sVOBCtpHYFN+eMxuJ7bAbn6Yu7J/E35R1Z9OpBOXIjxLbc4
         Y9Czrbzcltv1blbeZb1ZjAr6mWcupUC3ao5MilCZh+IhgIOHgzsx5vQICbKZJniDYWRx
         N0f4eDGUJ7b/A96LydNVkJoxJ9eWQHkQmFhxaGRFnZlQjDv/Lorm1nHHxylTHn5PhqDA
         pV9Z+BVaYRUvdc9y9qiDRtcIU5qXuCp9kawLKyv0OGPqdV/dYLRHTq9cdTlu3lPiiMpK
         ab6w==
X-Gm-Message-State: AOJu0YwYW1ri/JsUEomaW+AuV02GHZCspQ5JeLRVlCcOlcHYCfH5vV+g
	uGL+nj6rKigbD8gA5l15O50AFQ0xmqzz2xDczwv41wgVFCUG5akU0Mdw4gBAPg==
X-Gm-Gg: ASbGncsG3xXQKG/yDWTDkBW5z9udlSLLPZdyQSZWj9oMlY++c5edqoDWBMUGdrppLaM
	9KqcA3Qdi02bwaQSnbzx9LvxvzMhZMkNS6NblY646vElfjpPIk/BvB9ZmD/H6Sam3Yli613ka/w
	pbGg5MW0hJLfok7LmieLPx/kH83/V8YnGsnIfh/qZBZSKdY2w9PIRGpicX2LEG8BymznkxLpTME
	UAzKwCa5KXt7P7WrJRM5stPnESuwL8MqA38IP5QwvOmdHxqYpnc3QnuTccbpEv2jNOeI3YRJ4qT
	gwTB8FuxOv8ElsfKYJ6By3RKQ0KW/rlwzwDOF+agaBAYynybxYIRiTdgyTYdLAaU3DMXGJjixFy
	EjXQz2U9HSqOflFNo+5UZ/Scaa1De4wSjrl3ZzR0TqsmpkjaeonE8w1peOAV/2V9AiliDNgOboC
	LgopP62q2fr5M=
X-Google-Smtp-Source: AGHT+IG5GvcXFjBM9WaiufAj5YzYDJtp2vxUhNi7C0FkZ7U4nwyUcApa2kye7SmyBqB4gLNVQPC3oA==
X-Received: by 2002:a17:90b:582e:b0:313:14b5:2538 with SMTP id 98e67ed59e1d1-31c9f4e133cmr8141992a91.35.1752748395917;
        Thu, 17 Jul 2025 03:33:15 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.in.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31caf805069sm1275145a91.32.2025.07.17.03.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 03:33:15 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC 2/3] xfs: Refactoring the nagcount and delta calculation
Date: Thu, 17 Jul 2025 16:00:44 +0530
Message-ID: <35b8ee6d2e142aeda726752a9197eb233dc44e6d.1752746805.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce xfs_growfs_get_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.c | 25 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  3 +++
 fs/xfs/xfs_fsops.c     | 17 ++---------------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..dcaf5683028e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -872,6 +872,31 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,
+	int64_t *deltap, xfs_agnumber_t *nagcountp)
+{
+	xfs_rfsblock_t nb_div, nb_mod;
+	int64_t delta;
+	xfs_agnumber_t nagcount;
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
index 1f24cfa27321..190af11f6941 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,
+	int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..91da9f733659 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -92,18 +92,17 @@ xfs_growfs_data_private(
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
 	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
+	xfs_rfsblock_t nb = in->newblocks;
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
+	xfs_growfs_get_delta(mp, nb, &delta, &nagcount);
 
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A652DC78C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376347; cv=none; b=l+1X7Qh+VCTThhavsuJYSxsOH99Y/h/RXUOFxunfRJYOsub+VeCpf9H9NUcfGJrMvSjs08rtg4hDSqh7cn2qtpcaI0n1QkfOJZ/kibXtaUQRophOLUYEGC78jhjflOwt+sPI2UwWpVRNJjb/KPJQqLkZj7xxlCSgdgvV57nEe8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376347; c=relaxed/simple;
	bh=jtkuN0UZpzzjTOd/hGcAzuGlHc4XQLi8YBOQUeuHhDQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fn8AafTILQLxNPAlHlz5K/gRIOT0+dyuhegtovOJOLbPtrPh+M/s+p6CgZeb2m0esBXHBl+hLjUl2gJMx4SPA5wZgu8hpz2fcvvysOaYZ3M8vOojC7rcEbzIbeGJovHTvsbRXR/CGxxCXNSnKwJayU4VLWtWx35ctPhIWGl2HKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iav/NOSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iav/NOSH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A490F1F00893;
	Tue,  2 Jun 2026 04:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376346;
	bh=xoaQDfq4sPZ7G8AoQExdxjTnKUpCNJ0mDfIE/xiNVjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iav/NOSH/fWU1ZZZFp34ihE1WS2P2g/cpXbeYSGDpo3cH6EDzLRS48mItMSLzv22r
	 M81pXaPqzO7Cq8fGzqMXhZFq/kcxzxXfY7NVC2xKkiEmdhi8fTsz863LU9Q9wrN3Zc
	 3VSPLnPGxrGoiv5KB7F0de9UeFe21nIq34hKv+ek2g89ndiAz/X8MkvmF/CTJb6423
	 ATVfBCL10j2pDuHxCo9Vk362HHUUTr11Yf11SdQA5rhmC2ZknSInJA0+1/+lRHPsC4
	 Dt/AWG0G3tsjAUarAc8zvxY8tilBVfMpVrcBUEojUFItBfJ+XWQo7rn8hFNUT3GDyq
	 Gqu9ZZ40BDenA==
Date: Mon, 01 Jun 2026 21:59:06 -0700
Subject: [PATCH 4/7] xfs_healer: run a full xfs_scrub repair if we don't know
 how to do a spot repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627117.588879.2171281965197455730.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that there are a few sickness event flags that we don't
explicitly handle in fsrepair.c.  These three codes
(XFS_FSOP_GEOM_SICK_METADIR, XFS_FSOP_GEOM_SICK_METAPATH, and
XFS_AG_GEOM_SICK_INODES) can't be handled from within xfs_healer, so we
should trigger a full xfs_scrub run to try to fix those problems.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: a162dc462186a6 ("xfs_healer: run full scrub after lost corruption events or targeted repair failure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/fsrepair.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)


diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 7ad513b2d69b93..7da9e562d68734 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -88,6 +88,7 @@ try_repair_wholefs(
 	};
 #undef X
 	const struct u32_scrub	*f;
+	uint32_t		needrepair = hme->e.fs.mask;
 
 	foreach_scrub_type(f, hme->e.fs.mask, FS_STRUCTURES) {
 		enum repair_outcome	outcome =
@@ -99,7 +100,11 @@ try_repair_wholefs(
 
 		if (outcome == REPAIR_FAILED)
 			return NEED_FULL_REPAIR;
+
+		needrepair &= ~f->event_mask;
 	}
+	if (needrepair)
+		return NEED_FULL_REPAIR;
 
 	return REPAIR_DONE;
 }
@@ -127,7 +132,8 @@ try_repair_ag(
 		{0,		0},
 	};
 #undef X
-	const struct u32_scrub *f;
+	const struct u32_scrub	*f;
+	uint32_t		needrepair = hme->e.group.mask;
 
 	foreach_scrub_type(f, hme->e.group.mask, AG_STRUCTURES) {
 		enum repair_outcome	outcome =
@@ -140,7 +146,11 @@ try_repair_ag(
 
 		if (outcome == REPAIR_FAILED)
 			return NEED_FULL_REPAIR;
+
+		needrepair &= ~f->event_mask;
 	}
+	if (needrepair)
+		return NEED_FULL_REPAIR;
 
 	return REPAIR_DONE;
 }
@@ -163,7 +173,8 @@ try_repair_rtgroup(
 		{0,		0},
 	};
 #undef X
-	const struct u32_scrub *f;
+	const struct u32_scrub	*f;
+	uint32_t		needrepair = hme->e.group.mask;
 
 	foreach_scrub_type(f, hme->e.group.mask, RTG_STRUCTURES) {
 		enum repair_outcome	outcome =
@@ -176,7 +187,11 @@ try_repair_rtgroup(
 
 		if (outcome == REPAIR_FAILED)
 			return NEED_FULL_REPAIR;
+
+		needrepair &= ~f->event_mask;
 	}
+	if (needrepair)
+		return NEED_FULL_REPAIR;
 
 	return REPAIR_DONE;
 }
@@ -206,6 +221,7 @@ try_repair_inode(
 	struct hme_prefix	new_pfx = { };
 	const struct hme_prefix	*pfx = orig_pfx;
 	const struct u32_scrub	*f;
+	uint32_t		needrepair = hme->e.inode.mask;
 
 	foreach_scrub_type(f, hme->e.inode.mask, INODE_STRUCTURES) {
 		enum repair_outcome	outcome =
@@ -228,7 +244,11 @@ try_repair_inode(
 
 		if (outcome == REPAIR_FAILED)
 			return NEED_FULL_REPAIR;
+
+		needrepair &= ~f->event_mask;
 	}
+	if (needrepair)
+		return NEED_FULL_REPAIR;
 
 	return REPAIR_DONE;
 }


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9E223C9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608907; cv=none; b=rp93JpmvX2sX00m6HtqsmNTvdGueM75YQ3Zmr5uP3U2F8yOwAOW2vWkCza/Wev64zVL2W3MoW2yuXC8GbGJ9as9EZnWXg25HnpkvopGRRPxBVos1oYUg2YF+vLex710BawwILjmm+NPSn4FOp9B9O4aoAmV8Vwcm76lTncBFU3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608907; c=relaxed/simple;
	bh=eBSmiH0P6UQMvDRAOUEbj0A1YcI/NeaxKfIhtF82Jg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHm/q1oL5Boe1Sar0JQWpOJYA7Hfbz0Hf6Wo0ucjlDuIloSy9U0KpufpaN2GYl4HsqOvjhBjXNaG2seSQOajkEO5p8I1bQ8wjG2UC64JT8wQxqFq52AgX9ij20WPhjLhMxW/7tZYEAZdKy80hbgbwmv61lSgi0aubp6kB1nQ1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egGQDSSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egGQDSSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C1C4CEC5;
	Fri, 11 Oct 2024 01:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608907;
	bh=eBSmiH0P6UQMvDRAOUEbj0A1YcI/NeaxKfIhtF82Jg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=egGQDSSGTnydpyH+J1NYbOSwMICCos8Yf27gIDhykGr5XFVQRvTV88yBu7TEbaMG6
	 nsyBIHt+nYai8++M2074jh2vnkFv03X8abDufyW6pVGJuakTjk+Foi1p5Rq1pPxZ9F
	 423VIwk6DdQT9QlAgN9QPHYKbw04UgaCZ0yD18nykLeKQEm1nWtUzAyoi9iGI9KTIH
	 gkyuYv5gm/tgVlsURmkKiz5Igx3rtAnLrKel1eVp7c+QC1MRLNW50XzClNRSsaDPmJ
	 5kPV2MCV87eDGpXPQrb5CtQuSRTWCTGw0KaT/jfDblUDqHa+1BxuicSPq2lUVtVqtq
	 x9uZVjOX559Vg==
Date: Thu, 10 Oct 2024 18:08:27 -0700
Subject: [PATCH 26/36] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644690.4178701.12155004418920264753.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Set the rtbitmap and summary file inumbers to NULLFSINO in the
superblock and make sure they're zeroed whenever we write the superblock
to disk, to mimic mkfs behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e1c9ed7828dc57..f6b3b377b850aa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -660,6 +660,13 @@ xfs_validate_sb_common(
 void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	if (xfs_sb_version_hasmetadir(sbp)) {
+		sbp->sb_uquotino = NULLFSINO;
+		sbp->sb_gquotino = NULLFSINO;
+		sbp->sb_pquotino = NULLFSINO;
+		return;
+	}
+
 	/*
 	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
 	 * leads to in-core values having two different values for a quota
@@ -788,6 +795,8 @@ __xfs_sb_from_disk(
 		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
@@ -811,6 +820,13 @@ xfs_sb_quota_to_disk(
 {
 	uint16_t	qflags = from->sb_qflags;
 
+	if (xfs_sb_version_hasmetadir(from)) {
+		to->sb_uquotino = cpu_to_be64(0);
+		to->sb_gquotino = cpu_to_be64(0);
+		to->sb_pquotino = cpu_to_be64(0);
+		return;
+	}
+
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
 
 	/*
@@ -949,6 +965,8 @@ xfs_sb_to_disk(
 		to->sb_metadirpad = 0;
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
+		to->sb_rbmino = cpu_to_be64(0);
+		to->sb_rsumino = cpu_to_be64(0);
 	}
 }
 


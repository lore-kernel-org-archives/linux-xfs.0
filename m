Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806523C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881730; cv=none; b=eg+oeJuBnBE4QsW7HkEne4XnG7SQnpRUjFm9hSxM/BG+kGglXfE7B+of3ugC827TYnNW6mmcuFNJ4HETLvry0UC20+Vk7HSdVCTCgBiGrpMXfwuVfg/1SnF/kPcM28y4tRtWgr/uC6++Wayuci5aIFmLQMJ4aqvTViLiK/4uc8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881730; c=relaxed/simple;
	bh=N38/QhTQMP85A+u2AQ5ppl4auoS0BQ2Q5RtGNqdOBx4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nuy0HJAHE8ipEerc0ZRtnqYPbuGSVhfAG2Q25jfSA6yjw5SQxIdaBreOLOTVESHRneqUyVHrGhLc4uKjHyR4z/HOxG89hMd3NbnEvggGztUaSVEBkeruwXTSdgR0H3M+iAiQUYbo+uztWL2CFFdHq/u68++9ZKc8nMN+eH3mlTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJAA55Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJAA55Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725AAC4CEDD;
	Thu,  6 Feb 2025 22:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881730;
	bh=N38/QhTQMP85A+u2AQ5ppl4auoS0BQ2Q5RtGNqdOBx4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nJAA55Knh1k32/EbYn35UeUuWTsK+AMlZ4d3pn5ZmDmlXpzRPyEd2WpHpsf/yNNk9
	 VAHJu/l8Pi+63lTc2MjNt+AGRAJhp8+46aOyxEBugfgwAaOl9WTA9XKvJLKm7fN9DT
	 vBzEEAhZIdUS3sUaYwwcox15OqiKL4/r4dLuezv++pm6tBfusACUnToZcLDOY834CJ
	 tpJXTXwOiBKjd9bNmrQY2E8AtToEH17fs/XDvnPGUDywxhMKj5PEYlhpm4AHMYtzos
	 G891OHSG5SX5UDuqwUv2O+01KlKmBRdhclzPmRJpgkgG6EN5f5vVb/IU4k5KS54SL2
	 yh8Nw6u1xMcOg==
Date: Thu, 06 Feb 2025 14:42:08 -0800
Subject: [PATCH 27/56] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087205.2739176.15702435301335759939.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 366243cc99b7e80236a19d7391b68d0f47677f4f

Add a new XFS_SCRUB_METAPATH subtype so that we can scrub the metadata
directory tree path to the rmap btree file for each rt group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 34fcbcd0bcd5e3..d42d3a5617e314 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -830,9 +830,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
+#define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(8)
+#define XFS_SCRUB_METAPATH_NR		(9)
 
 /*
  * ioctl limits


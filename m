Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FE02E9730
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544783; cv=none; b=rDHSgYnPu4UHnOfv9/0eXEuX/5DrBp3bI0Aypx/jBlqdrN6igsRPxCxEznNdt9tAB7veQ1XNebkh309IGodzBVvXv1FGve18jiAAu55tySbVq1mtbHXYtIfXtvmp/LDhgSzltunAGRtbF112ZGjqwtMUPYcBUfvkMayXPC4SmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544783; c=relaxed/simple;
	bh=hYm7V3qzlOCNmRVbX4p8XM6ATMmRP42Ueog/dbbwQOw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N07glfqM4628O/CfKXxvUjrqRQWJSkRRfG4XmZLlPBekUdAgqQKv33NrnB1VA/aoz3t53mZk+xSmtb0mfoqEr9JdJhuzxjwWGtJb4CCikOQ2rJX0qG8hqRA9NP/MCLVlCmCS04YQoCj2QKELoeWSxzwuw/iveA5lFy4hq4fKQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cg+9i7GD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cg+9i7GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8DBC4CEF7;
	Thu, 19 Feb 2026 23:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544782;
	bh=hYm7V3qzlOCNmRVbX4p8XM6ATMmRP42Ueog/dbbwQOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cg+9i7GD0PauL3uT6YJUlvEBOIhSjTNb1GmBOw36PjRhuEOLU9KHlx+2QGgJ1rOSP
	 u7wdxvcnzkn4SQod+9UyXQ2jdKmX+xcKjPCi/hz8n56LtpJAEU+K8/k4wY+XzF98ZE
	 13cM2ZFLxzSN/Ua2XAJJl4MVctBHyLGd08ZT896nJKfU40yG+bGWrx+QCnx4c3ROG2
	 /fJikf+ssVoEpQursTFVB9hTML38LLnO9xRbPEjh/R6Vd+o8yGaDHndlKQVP4ypro0
	 UF7/EfmzTe7IWOsdxAbMUZUaHewPqNUmbJZ8wwcFT4UAw0I8Q6dRod9DLfpaFFD2ru
	 OpQEG4vEQid+A==
Date: Thu, 19 Feb 2026 15:46:22 -0800
Subject: [PATCH 11/12] xfs: fix an overly long line in
 xfs_rtgroup_calc_geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154456926.1285810.16729858707695298732.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: baed03efe223b1649320e835d7e0c03b3dde0b0c

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 1e6629ee03253d..d012ca73000d86 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -80,7 +80,8 @@ xfs_rtgroup_calc_geometry(
 	xfs_rtbxlen_t		rextents)
 {
 	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno, rgcount, rextents);
-	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
+	rtg_group(rtg)->xg_block_count =
+		rtg->rtg_extents * mp->m_sb.sb_rextsize;
 	rtg_group(rtg)->xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
 }
 


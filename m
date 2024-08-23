Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C08B653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372972; cv=none; b=Xk4vvMzxskSXmBVujK+yhYwadMoK3k+MuxrYDfA+8wEw/tG7QOcjXWlumpXPhCUD0fZ0jXmvMGiT2O9leQD9hsdCnht00M64orkyu+RGg7iEgnZdhExiedC6iB/m+v0nMlb6sjLpnVeY1eTa1Pq63rPR84CrhZ3+p6Euyfp/kuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372972; c=relaxed/simple;
	bh=2gytWVOiq+JtZGdu5+Qfx0RkYIMu8RJm/mX4h3NjZXE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSp8E6BWTtEh2krEVITC77vaOoj/jtNOXUWqictynnJ4w1ylKtJKovjMt075Tmx8eX5Oxo081/dgs3zg1kaTScm44seWowGy9iJ3VqzAfPNEnia27U/OtIyleh4oPLLSOBLalls+4GCmrDODe2OvS8xeweJ2RnCjHinyJhBhyKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRduX30u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRduX30u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493FC32782;
	Fri, 23 Aug 2024 00:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372971;
	bh=2gytWVOiq+JtZGdu5+Qfx0RkYIMu8RJm/mX4h3NjZXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HRduX30u0yWm8U2Vv7qYVuRope3xZvjcaPRbyuH5wRC3LLTh2QkHS2EO1ZE1Qbcfb
	 cFA/WqKxbYLjNDfy+bEYrrxAh8eeY5APKs8ca8nf4AsUxR8QuYv4v/GEpSyea0QsYX
	 Wu0DoeVcNkMdeZza3dSx5cYVaiSQDyMFD9sXMWKIRiDWZiYGwvMCZZ18p0sn/NO0PH
	 sqmV3RtgA6Co5UwePOETngxoi35IOXzbDzYqxjXBR4nWF841DX3Hfdk7v6I5F4W89z
	 1Mu+rMPJ0cUwS8gAhszcNOgVkVX1ydXodL0B7+hLxAd4+POFpurNgp/+50Sfbc6k1i
	 T2aIKDDxnQJaA==
Date: Thu, 22 Aug 2024 17:29:30 -0700
Subject: [PATCH 6/6] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089467.61495.6398228533025859603.stgit@frogsfrogsfrogs>
In-Reply-To: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
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

Enable the metadata directory feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cafac42cd51ad..6aa141c99e808 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -397,7 +397,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool


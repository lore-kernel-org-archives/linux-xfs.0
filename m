Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8381120E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299230; cv=none; b=n/3yRBm3jUQyudjXKqhpV7gOXFWlxEkDDSeqVtHdKqQwshYityxJlFybm6HmT588oLpo/iYMWn0tQpCCPpLN3Aeiz8UzOE1PwZKsN01sPzxnRcSeGXK+L8HvMgcpyNMHb5P12VuomLDRpx/nYpiJcwW00FW31C+xfyEcHn+WWjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299230; c=relaxed/simple;
	bh=gkANiSMVHJHbumugeu9FuemCFpUu2wUEQkLsq3X/rfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bll/TJIXrTj8gByIN5QGsGJEDYYYTlGVj26cFEywFjbTzk+TuB2L87mmFbAk7lxDEMh3txmLrqYRREF7fzBoKKF0e2uSBlQYb4Bke8c4PUe0OjrREARx3+Aowb2fpQ+w6y7yzGClr0zUON4loEehzRh7zAhkT/GAOvy+om6lO4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1g/bJlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1g/bJlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCD4C32786;
	Tue, 30 Jul 2024 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299230;
	bh=gkANiSMVHJHbumugeu9FuemCFpUu2wUEQkLsq3X/rfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k1g/bJlXdLlG47GOCXFBLywRt8ajmaRTnXgq1fFppSgi3x8gudmuBdxQDdIg0uMne
	 0ec20HA8FZX3AGAWYVwqAVuUzXWdQRtJdBIX8eGVjVCnh8B/Y6kTaZzjNZkQeKLSnz
	 tCfzb5m2Jf/ofQcZZ7cHSMNbGY8GlFM7bpK78zpCR71/rd8XjUBcwlD6jrjt0s/C5C
	 FzNqu3nvdCIMDQDjlFmOcZJ2zJb/t6opcbyXBjlszN2DGj5Rg+8kc3wzEefDoDhgfN
	 JfqJOb44KfBHj9Y2ehkRyJ921N2DQ6fJ6m97zhcWyq0hFsxEvb0yOFhvo642vEpKi2
	 h3uF0tCGBRI9g==
Date: Mon, 29 Jul 2024 17:27:09 -0700
Subject: [PATCH 013/115] xfs: enable logged file mapping exchange feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842625.1338752.3670668512753428716.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0730e8d8ba1d1507f1d7fd719e1f835ce69961fe

Add the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature to the set of features
that we will permit when mounting a filesystem.  This turns on support
for the file range exchange feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ff1e28316..10153ce11 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -380,7 +380,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_META_UUID | \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231DF818
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710912; cv=none; b=c6EX/qbqRhf0A3DbFeFsJWceGjJJWDsQoC4QXjPja7smY1hTUf50lmVAbCxHZaWy9c9F0rHofiqvzisgP6HvHWmdXB3FWr1TAA1016WiWpFG+QvD8H/ISxTFPdgQJCRvH6yXX9tZvG4qhRdGjNjh9ystewirsW3V4Bxc0GAY+l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710912; c=relaxed/simple;
	bh=Vh0g21My62IAb/SmyG4ANLlu3Q/qVbU4YFw4EOLqXmo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkO/ZTvb86G+YHh3AdxeRTlMJc9Jixafti+seUa0f42OvwCeuCeKRiEmra7mSKcyov8hCXKhizD+rnkW15bJAWnWSt+KwPCXf1/b2LrbSiE0fOC15uzukXniKjAfQhzaTsPsHFHLXEwxnGjDHWpwr6G1MbaLLl/oI/4UQmsY3vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWOZzyQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWOZzyQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE62C433C7;
	Wed, 10 Apr 2024 01:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710912;
	bh=Vh0g21My62IAb/SmyG4ANLlu3Q/qVbU4YFw4EOLqXmo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZWOZzyQZzUxASFbPM2cxKGdq8dmGPoVKjI7qOc8ghVyffw4DR4SiKfThNAlMYP5fZ
	 pBxIixVfJt8s9WeYDEgA76hLJZ6wxweozZg4Vk58oCADwe3Wxc1r/bT+4HdJE3+toH
	 ZBP/+agJqXqZbL8Z06mDOw1xv6ipv5zts/b2oTp9359jjRR/cekkgv5a2xuinE/Tva
	 uTDDt58BBsJ8YAr4KxMyTr6AAUz/TJx1eO6kKtjHo9jn3824AcQmlM390YSFQjifvq
	 xW8sUVxpc77S9NuStzlWEWzKucVZWhFcoP6MIkveM9ypFZaGG4Iybfl6pqEZs0i0hi
	 CcA4NjCKsGPFA==
Date: Tue, 09 Apr 2024 18:01:51 -0700
Subject: [PATCH 32/32] xfs: enable parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970091.3631889.3723065069358160559.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Add parent pointers to the list of supported features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b457e457e1f71..61f51becff4f7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -382,7 +382,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
-		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
+		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool


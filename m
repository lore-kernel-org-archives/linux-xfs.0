Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE78F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928826; cv=none; b=dALbVcahpRfQiuqhh3J94qaMFawz/jcrAZqaPPX0MtiGXuzXwS2FIKWIV+beCeyWc2IBo3RzmD+wFd5gkWCeHA0tB7zWPfy91uK/BNup8a+G+8mPg3+vgvdLAfZGAF6FIbV+KVRb2SnpUymmQNY7IJWomhk3QyYUkvXOEOdDLd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928826; c=relaxed/simple;
	bh=P6NsnAsgZDn6G7ThxuHCz2YnVclbohtc03egf9OEwO8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBb1im6UB1quZ68VqXt2SaIlV4Vb2C8Dj9D93fiZEacoOSi6vsC8DIucU6Hx5P6BnGw3gFydRysO5/sEFyKvQYRSZLM93mftXIBY6PMUsq8rfESS+NCIbsimiKwK9aC7RF8bAd85Wv5FY7A6rWt/kdrAPS0ho+GdFAdO0pHeh08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mA8NzI8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mA8NzI8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74098C116B1;
	Wed, 24 Apr 2024 03:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928825;
	bh=P6NsnAsgZDn6G7ThxuHCz2YnVclbohtc03egf9OEwO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mA8NzI8r7OeTsBYEMFyZ3f4WMP+1ufRaWe5XQxzpW4CwP5TpecMdQOJc1W5gLtmZj
	 QHLPCaBs4xi8gp/WbY3a/p5sZYa/yBSLPOQFA6iU9jzCUoDCvfeQzS9v28xmkX3kkF
	 q8CBgWeVj56eFxKZyHTcSUwNFh9mNeI+N9FfPIRAmtcCERpPh66VtN0FsQUhSKNB6z
	 neB/GKn+ocBq+mnenYccDbdlM0q2AjyTRIvKYLrimAQBk1tERYplzzyvYa0F3Hcw5R
	 u9R3JNHfFzmLOUV9Q+UnRblGlGISKSZoQiUv+QDVKt7zv1GYYICzS6VNifVsE1k9mg
	 eDvCtdv69zuTQ==
Date: Tue, 23 Apr 2024 20:20:25 -0700
Subject: [PATCH 30/30] xfs: enable parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783777.1905110.17451306065508602960.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b457e457e1f7..61f51becff4f 100644
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


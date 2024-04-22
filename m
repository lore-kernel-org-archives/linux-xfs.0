Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8CE153838
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804020; cv=none; b=tgxFE4Qi1f0jXNQZd4wZl+wIZKCQ3j1v6w0n1g8Efc9rn6s+ananF6LuNDPHQGL+1YshnMtxn4V+aF1Kt7AWdoqGmDah8IPGVNbGsL8GJk+gKfUuRbFlG3LE+g7hqZmR+9MpTn63G1hrak2WWSVCenFXSq3UoRgk20QSufPZg/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804020; c=relaxed/simple;
	bh=JqcGK5wYBKVfXYsLskMhXkUeb+090lqZtOyoBpp4wf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwvCqjuChZfXHi+P/NEe7L8RuBxcS3+PkkvFaRgdNtvjhj+vC43aGLZCHlGnrgiE2b8EyB67QnM/2dKLJ9UtWa2dmBBgt1dSMm+W6L9Ogygnd6fybk0/5jAoBJePCDBudBzoKDNZnDBWG5GWwOZlnfSIkIzyfTz1XMPZDc+X2FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2AxytcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2AxytcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B0AC32781;
	Mon, 22 Apr 2024 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804020;
	bh=JqcGK5wYBKVfXYsLskMhXkUeb+090lqZtOyoBpp4wf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2AxytcMRytF3H6YMtIGE17UvpmodkCEzyPGXMcU3VpA9RLA8ARV6ArTAF35sRPhO
	 oZJrB9cil0WUmDOBT/X0775rytLz6mBf9LyXVwujzb39a+lUnkYHxVPzg+MHoLpHLg
	 tDFr3BC++epMND9ml/uN4U6PJFzivLKv+YzqFNnkLDFvQZx1uvbARjVMvjIgorx0st
	 309+FsFtI/3iSbDdRmsjZC+A76gONTiOrlYx4SBRWKNJNk2vXKD8yUuqvXQyA2dCbV
	 tTtEgB2mGNDWpFAIGxMxir4A8292R3N0VhuhL71Ga1oZnZ7+lcwhMvNVPILxeBI/8s
	 A6TziPeSnA4zw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 48/67] xfs: return -ENOSPC from xfs_rtallocate_*
Date: Mon, 22 Apr 2024 18:26:10 +0200
Message-ID: <20240422163832.858420-50-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ce42b5d37527b282d38413c1b5f7283253f6562d

Just return -ENOSPC instead of returning 0 and setting the return rt
extent number to NULLRTEXTNO.  This is turn removes all users of
NULLRTEXTNO, so remove that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 035bf703d..20b5375f2 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -51,7 +51,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
-#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
-- 
2.44.0


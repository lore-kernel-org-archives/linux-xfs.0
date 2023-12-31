Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A53DBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI9anHEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F2C433C7;
	Sun, 31 Dec 2023 21:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057713;
	bh=X7n9SWwYGRwa5po6HtUXNRsjtSSlzHfcOIO1+qpZxKI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eI9anHELra8cjk0ollIMvqTuaAQweebcP6+717dF2FYRs5yFTPtVhI26UNRDSWvd1
	 4dGu9gwHuaRSFjRaoHRpnBAhYpOm1xS+rf/yKd/vOV8cT5wXabq2UlZZyFEZ3p+oq/
	 MJxGar3Jx6e/0TRUoT/pqiF/upTmukSQ0tZch7LbRztYP9NeLtbIfSu7jjWzVJSHRc
	 ozNTDtzH0/g6/klNJiTliynqZRXOLOjwRhjWHAyh0bPVljGQmj8oTvOfz1xzVdR2lH
	 BfIWXgqB/g8+Z0sQ+sdpWsY17mnOxM8NIwQ3bGbSu+wjQoYegcXdYLzQC7re+0wpXh
	 SNNimoJiB70fQ==
Date: Sun, 31 Dec 2023 13:21:52 -0800
Subject: [PATCH 24/24] xfs: enable realtime group feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846626.1763124.11828497045934905103.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 59ba13db53e7a..87476c6bb6c64 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -418,6 +418,7 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_RTGROUPS | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL


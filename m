Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBD1CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846513; cv=none; b=mvJoV6ykubz0Abo5fpDoMP8j5uvtH9NJYib3FOLLFVjLOYz2bnGtb3jD6p+cDIwIPan0sB/5OFHOXZ7a/mP4SOC4BtUBdGAwMjE9Ud/VX8gJROoqg1pLXhx0hfABTQ2O3xmmii51v+nW5ma2nWPTDD8vt1xSl5fClkNw1AXLVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846513; c=relaxed/simple;
	bh=qnBBGtry7VGnzhAZXLDVFSZhECjhiV+XjDfjnj46xps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GcloGaqrwbYL0hBsiSfw4gRuW3Fuy8ksHCqxvdh8nkocdq5qs54cOASjYtuXKTlXnR1PDjpB+Kx6M3quDwrlbqbaHRQLJ5FGLWaYEcwdro52xbmwKb/9Zj+E8eBjetYsOaFpDVqWd0BwHA4MDKnDPh89185QBTgNZR5K4WAPq+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgoUXmZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgoUXmZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB066C4CECF;
	Tue,  5 Nov 2024 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846512;
	bh=qnBBGtry7VGnzhAZXLDVFSZhECjhiV+XjDfjnj46xps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XgoUXmZkTWY0AlGaKnhTu4oymjkwP55WfVAwZjOTQlSBf5meSpM2ymEVn9YQHf5bM
	 TTbeXU26dbJv5RqVAXmB7dia4dsevtwcbIJ/ohDWAXTG7KUOC0pYZ0AG6ptq5KJdp1
	 emmPBtAecZ2TbZA84KgLeYjYpeT79K7dvMjk/nxgFSAD+9FCIsNxf3O0ch75NGEfUQ
	 ugI/gSeQr6tyrwOsGKXmwq1uPcmP39btLvjFl9PU2qQ4wfcjOmqMz0qYnYDbzMgh4q
	 c3N1XkACh2+yT/45TF4OptlvCY47444tIIGJnDOhr4mHYvsX8g0Q8WBo5BwD6BXVKm
	 A0Gzm+hahZlbQ==
Date: Tue, 05 Nov 2024 14:41:52 -0800
Subject: [PATCH 2/2] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400047.1873485.6257489631130767475.stgit@frogsfrogsfrogs>
In-Reply-To: <173084400008.1873485.5807628318264601379.stgit@frogsfrogsfrogs>
References: <173084400008.1873485.5807628318264601379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable the metadata directory feature.  With this feature, all metadata
inodes are placed in the metadata directory, and the only inumbers in
the superblock are the roots of the two directory trees.

The RT device is now sharded into a number of rtgroups, where 0 rtgroups
mean that no RT extents are supported, and the traditional XFS stub RT
bitmap and summary inodes don't exist.  A single rtgroup gives roughly
identical behavior to the traditional RT setup, but now with checksummed
and self identifying free space metadata.

For quota, the quota options are read from the superblock unless
explicitly overridden via mount options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d6c10855ab023b..4d47a3e723aa13 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -403,7 +403,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905091CD00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372533; cv=none; b=LYAZExcQ02fh3FrNsdNkaFlSzhGFTdLf1NtiwtM/95NCalabF5TPF3eTrjfIuduUvUBccU0k87ZI5ghAlGknExLXGXlodtRoGI6Ad4WyqiG6K1fbevTR7ZWXhiI+OYwF3FXxq+Zr4UVm7CNomyL/UWF16ISePEUwCzRzNsHSdcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372533; c=relaxed/simple;
	bh=bmmnxBPL7FwPtuqRCjGCasmd1tRFvMqNDQZix2c9HqY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtrsuVju2QwLsqaubeJOof8/stAQ6XFKPc7eMjwg7W9J9+aOQi4rIglOPrbxhbm7bos5xK/X2jC4hs2RZN7aq0ST8KrBOUj7Sc5W4YGh5X5G3Bn9+2QyQC2awkIAqWnhEcciKMBEDgEwj9VCmYkJHrDDXTZm3XIVOdVXKGOiKKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUuip3bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUuip3bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FD8C32782;
	Fri, 23 Aug 2024 00:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372533;
	bh=bmmnxBPL7FwPtuqRCjGCasmd1tRFvMqNDQZix2c9HqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kUuip3bNC2dxM8qlNT6CbyaYYQMjTIXAwAqI59gYbcQN7N5cYkqFzLKHKswF4ldwm
	 6XDDsozN2XjIWugGVNU9m9jXjRNZq2tyqm+5o4CWC3O+mNdrM3JM5OHOgkoKRdNWp6
	 qIxpACAbXdpJP4rcXPGBopGox6Ns9p9l/yKPVaWfPlTp+btLVLDNgB8wY74KQRQCog
	 +2ifhK5ie/PE2uBkn3i7VqqUWFOfYHViy9NX6pe5T0C4qwYgx/nGRFVihsCzj3tZ8i
	 9Lc3OK1cErSdLLukEmyn8OkyFJk6ihOKvOtDVCsefz9VX6ea8yG2SbbCyaESWTd8CN
	 3Aml6lYtvJTYA==
Date: Thu, 22 Aug 2024 17:22:12 -0700
Subject: [PATCH 04/26] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088588.60592.14229821430878166126.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b441b9258128e..57819fea064e7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -186,7 +186,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgextents;	/* rt extents in a realtime group */
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 29b20615d80bb..2a0155d946c1e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1407,6 +1407,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgextents = sbp->sb_rgextents;
+	}
 }
 
 /* Read a secondary superblock. */


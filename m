Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B229E114;
	Tue, 17 Feb 2026 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370470; cv=none; b=DlU1xoR917ys3+6kXn+21p0BrD4Tsvf1Qg9vM3vF9JWl/qu3ItioTVYDioedslTSgekX91Y40Bjd2fMDViqaBFsYJld8qDguef3q9wsw49NWR4K8AVC9WncBUNoa39hzJwSaPEykq0aIkpnV2vGkyHa5E4qCtgcA8TgBr7YGFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370470; c=relaxed/simple;
	bh=f2twwFutl41Dm8SpQbW4Bu89uc1StDutafhXVOkPI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUj1zUfXShMVJ0Z8cFQcIat5ZvIGxSqkoN/zUvUcaAYo8agOQCIQTGggFjU07+saVdnTpjZP8AKlPReob+cluHKxTm2FShbsAhb7+JBDVUgRKoIp0I4vsdq7wWLG3gWR+UvazAGwse/uRbvXEP0MKZZUqa/D7d5sdRAT799hiB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcJz/9cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcJz/9cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2017BC19421;
	Tue, 17 Feb 2026 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370469;
	bh=f2twwFutl41Dm8SpQbW4Bu89uc1StDutafhXVOkPI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcJz/9cT7TECipo5wwPltmWDtx/cFeBYFo7OpTChXEVUC5c+PJRS0ei4Gd840+lKu
	 6+DpG5hCpqqw1tgZIDJQELFCoJtpzrlo78QSDhNpKuUgOdeByP08NAhBzMvHf9eBgx
	 /OkCrkXvBUQ4/fUeYf3s0MeYeI6LqpqqN5D/tvwBb/iaq2nVvtTMDR6OtUvZdZhZON
	 /qbDmRt8gXfXPCzxY9jPzY14ODv8qYNZGby5nCCRzgDqhT4L1e1o0e+S2SPqE9IHSo
	 v27k+LiHBFAi5HsP/DlGT61MoN593x45Zs0MXqpU9uV9PU95jnUHaoZdJHEo2m1cAD
	 ApcURl9DCxbog==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 17/35] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Wed, 18 Feb 2026 00:19:17 +0100
Message-ID: <20260217231937.1183679-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix typo in subject]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6b8e4e87abee..44c616113734 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1366,6 +1366,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.51.2


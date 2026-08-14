Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7130045D1AB;
	Fri, 14 Aug 2026 09:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699598; cv=none; b=B4d+ZZxeaqACCupqwJ3ah94i/SkelSCuPsdSaJQZYhpMTs7OZcdfWJGiDZqBWQB5SD8oflnkIJny3MNtLEvJNRNxxOAK8/G23wnT7w1oCnbqa8JZbZ77XnBLb/B89U3gXePEkSrUQeJkN7wXf1gAkR170JiHojWY8lxXxoiBjBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699598; c=relaxed/simple;
	bh=gHl4HQg4dFPXM12xo/VO+LNovevHv2UmpG8XKevlUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ontLIrZzISV9xq9QA5vgkUNpCy+5fW3fR7KEROp9zmQ6UflOFtgEtYlkWfOsLAF7Au067X+9dlvPuMA0cO4HBlHJR4fq7EyauhXB1kzbISg6J7iYehfaTT6KRSoRgfjG2geEDuFfBCD/gXH5GjTswfJCGXg0OYRG9YYiq/pVr3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I77zTBZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I77zTBZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4081F000E9;
	Fri, 14 Aug 2026 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699597;
	bh=AufMkm+nEeCieeEcnf+ZJSfHdxMb9GSGIeKul87lEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I77zTBZFYKCV7UtWfgedOvE6u7sNSrhLcYSmAFc8Lc9Jf1KDd734GEk99fLebVIN3
	 XEp+4LEKPUyf6+wzhIBG0YH+I+Dm/Y5F8Y5E7LXcmcZjCEblZuPhqlSvzvezvjoABQ
	 LyQm8NAJOQ2D5k+hyEWLrPv7X+kUOrzGoMoq87ATRfJU7nOa2Ufh9Y2RPECDI95UdV
	 2Zh6wFhOxKGutrHBo22cInIWSU5JK4wZXEbI6ipDxqO32uCr8arVYWUx1TkPixPveu
	 2c5TQ19TH4YqK1rdlmPQ8WiaFkufU/WkEx/1XGyYShZ3wKTeHT/Snnp6yc+W918DHU
	 2a7e4CyAZwgsQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 13/25] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Fri, 14 Aug 2026 11:24:30 +0200
Message-ID: <20260814092448.1818082-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 11dc1a485ca7..55667cc762f8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1370,6 +1370,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0


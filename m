Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449526AE4
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737045194; cv=none; b=iumID4amwlXmYD/AXCWA6BtU4FcNefKONQLhpuOkfr2o9QWPBou17VKUfmsgD18mqRby371KYMY5RgOF8S4cXz0BUKym425FArzRZpEZ0dhWbVjCJBASpPyHn1pT+LCqN+A1GjxCkwYWnEAeRHwVnr+zLSVb/ijWnNSTLajNHIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737045194; c=relaxed/simple;
	bh=V1857p/2J4F2pm2LhmMayYGVd66wXDuTCsCXAH4Bb10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bFJNnr2b4dvp8b7B/nBK+MHFspI0I/y51Oygdm+l5w6fcjexJYCOEzm5oUyzHEMjlu30fbRZ7uJjYRTXUvZvjTY1G63IL+a1YR7x88HJqDT9Q9F0yssUk2viPXW1MpnGrIPrSDIEjP6K6j9zv6rrQ3NVii0Xwb8ikCdFhYV4v94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rafkcsug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rafkcsug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17E6C4CED6;
	Thu, 16 Jan 2025 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737045194;
	bh=V1857p/2J4F2pm2LhmMayYGVd66wXDuTCsCXAH4Bb10=;
	h=From:To:Cc:Subject:Date:From;
	b=rafkcsugGE7pC/Jq1QjF17ofQzAD1YJxzJDbEHMDEp765Lq+1kiTHwQNiPPeYB5P2
	 jB85TjtivLwBc9AbjneAZOls43HRy2KyxNsJ2nAATyY0fzN52dgLZL5AKUARrlMXR2
	 35UAV91utdLVWUCmbTLwNvFP05iQRC1cWhYJhuz/omexOTy65WBn1bUPJjDzZng9QL
	 72z031hc8mC7EkUKRC2ELqJ3/SGhMvegefmolOiPJgdeTqC/wWi6Uvo5xQpIGg3BO1
	 j6Vo/EotjQuqKaypZ8OmthYCb2NBoef8zQk+j80Jhb476ERLAZoVrLHr1XgtNT6f+i
	 ixBVmUKAQHjfA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH] libxfs: Remove pointless crc flag check from xfs_agfl_verify
Date: Thu, 16 Jan 2025 17:32:56 +0100
Message-ID: <20250116163304.492079-1-cem@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Just a small clean up.
xfs_agfl_verify() is only called from xfs_agfl_{read,write}_verify()
helpers.
Both of them already check if crc is enabled, there seems to be no
reason for checking for it again.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3d33e17f2e5c..619e6d6570f8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -787,9 +787,6 @@ xfs_agfl_verify(
 	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
-	if (!xfs_has_crc(mp))
-		return NULL;
-
 	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
 		return __this_address;
 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
-- 
2.47.1


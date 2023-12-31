Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACDC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYSmV4rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0E3C433C8;
	Sun, 31 Dec 2023 21:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059997;
	bh=m0fDmYfxEXeZcBqVbxQ6PbxJQ3ZihpUmYiERC9l9xFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YYSmV4rK5rX/kFP8Ysa+PEJOUoVNrzYpCdKMFU1BYfqQKR7/sxAnPDmsrnlxn5eYv
	 Q33nNLdzJ/FvG5FwWBPULTw0LS3orasjoAoaxBaJUwBR2h42w/m8BPbK7/l632F5pM
	 i7mnd2RycDLGX/wtewOigaeyspBqOYyI4kFe+HAo+Qd3dCirPIuq8ERCgmtfSbT4tb
	 FitLegFxV1qpo6PumUM3lmIvfGkJiDi8i5jg0K2v9nTYUDWu9TEaiFiRDFJsH6Jxo7
	 f66VJyMVxvX3MXkAPyEcTnAmD/sDZcyvr/vfr4o6qXnygNQnfsWD/4mVMWFhaUhaDg
	 5d+bjAQHGf91A==
Date: Sun, 31 Dec 2023 13:59:57 -0800
Subject: [PATCH 6/6] xfs: enable realtime quota again
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404853269.1767666.15160738988111971879.stgit@frogsfrogsfrogs>
In-Reply-To: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
References: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
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

Enable quotas for the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b89f0e8f80f9f..9ee319e7b13bb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1532,15 +1532,9 @@ xfs_qm_mount_quotas(
 	int			error = 0;
 	uint			sbf;
 
-	/*
-	 * If quotas on realtime volumes is not supported, we disable
-	 * quotas immediately.
-	 */
-	if (mp->m_sb.sb_rextents) {
-		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
-		mp->m_qflags = 0;
-		goto write_changes;
-	}
+	if (mp->m_sb.sb_rextents)
+		xfs_warn(mp,
+	"EXPERIMENTAL realtime quota feature in use. Use at your own risk!");
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
 


Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D886736A03A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399514; cv=none; b=ehQRflZKFYRcC1xV8kxBbmKyaM0bahDlsJDon9U31VRtP2bKqIXQPLeoT+kIpSHNr+KJ/BtB3o0ooVg8PKgk4MNwZ8XPYerK/pLWg0XAR8iU0LZ6PI2zOmLMRV66Cux0gLGEkv8g7bfbVheWqN4l2GbnPZ7tMVH2SqjKnS9CiSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399514; c=relaxed/simple;
	bh=2U7LOhtHbcyKAmZ6eeBAVMhUtbgVnFD5Bpo7D9+65uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inlKAwmxF/YoCFl0KfehuWxjHRFvEuvZ6uo4uYDGzMwxz0H6CGhNtfDK/VWw1+wHf96xkHxxmRpXlqt1A4hcgUPjHr7ndxGDP4HwczpdEUhWeI0K8bpsMFbqgd1MssLhDIj1IIldQFhkq6bwaizzp9+Ps58PJBn1OMZrx674LPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net; spf=pass smtp.mailfrom=theesfeld.net; dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=nf++OdoY; arc=none smtp.client-ip=79.135.106.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="nf++OdoY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780399510; x=1780658710;
	bh=oVSFITDaMDcl8F5hxC/fPH9w/x2e4vNGrwqofJcPWKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=nf++OdoYgmrBJGlOqboAAeyuvwSEzGeFOx/3+v+2PYYKn8Ns1lvpOXFWfVI33kJ3O
	 Pwkq0zlW/TwQIKdxAaXctGO84Vgj1QdlYurK7GdELL5a1OS9NvR57MEVlr9vVUnP4i
	 Dksb/5uUM7AOiPdHqrFatWdDYuGYtiG07P/JZs+dvxQ4n33pn34Ho+TdqKn+xVJN8N
	 jHR4MqwHnjL73MUFOMqEqkJ11hzeqwp/oaCP+Y1aXK7rwfb0NB9fZtgMl7ez2JDo77
	 cVM0USQt6K41aT2cSb5cTKu9w9A6b/Hne2SBm9SZl18o6I4T6JviOEx3cSbGqfgi2H
	 J+/q/izIuQycQ==
X-Pm-Submission-Id: 4gV7m52t7Fz2Scpl
From: William Theesfeld <william@theesfeld.net>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] xfs: convert dquot iterator map allocation to kmalloc_objs()
Date: Tue,  2 Jun 2026 07:25:08 -0400
Message-ID: <20260602112508.25581-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601191858.608270-1-william@theesfeld.net>
References: <20260601191858.608270-1-william@theesfeld.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 converted the open-coded kmalloc(N * sizeof(*p), ...) in
xfs_qm_reset_dqcounts_buf() to kmalloc_array().  Per review feedback
from Carlos Maiolino on the v1 thread, switch instead to the
kmalloc_objs() helper, which is the preferred form for new XFS code
and matches the style of recent conversions elsewhere in fs/xfs/.

While touching this, also drop the __GFP_NOFAIL flag and handle the
allocation failure explicitly by returning -ENOMEM.  The function
already has callers that propagate errors out of quotacheck setup,
so an early -ENOMEM is harmless and avoids relying on the allocator
to retry forever on memory pressure.

No functional change for the success path.

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 fs/xfs/xfs_qm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7bd15d9e7..83e8d80bc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1170,8 +1170,9 @@ xfs_qm_reset_dqcounts_buf(
 	if (qip->i_nblocks == 0)
 		return 0;
 
-	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
-			GFP_KERNEL | __GFP_NOFAIL);
+	map = kmalloc_objs(*map, XFS_DQITER_MAP_SIZE, GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
 
 	lblkno = 0;
 	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-- 
2.54.0


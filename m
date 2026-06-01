Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6483290C7;
	Mon,  1 Jun 2026 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780341555; cv=none; b=c4wl+2i56JEVYbIDWox3aryilAbURt5+xpd77zSGvSDFMkLkOEFNdUPPDX22au/WOB0O/Ks+KuSxDMrGb5+VYrZyDvjomubFX22X4lV4bzgivEGzh6rA6zj8XKeyRm1wM1cnDshN/EBlGpJf739Je3G6ixMZhoaDhnVHs+MCrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780341555; c=relaxed/simple;
	bh=ZEXW7Agq1GmUUGyeOP94NIuv9DVRrd6t2povhPQSY6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=apxrZjajzXH+gJrnXjUuEwlwoDxmomXru4qG+GcKpUQV0ghZHvyywXkTilI/aFi72hG7oDITu3XTENyY3k81afzvwFZ9BRlLZS2O30XvMnOstxJuG+ahlxDWnbouT8XcdUUgf3OHkLRKw2ICxH6wtzAqWH65UX9JuzykAh8c8s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net; spf=pass smtp.mailfrom=theesfeld.net; dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=pneZWNOV; arc=none smtp.client-ip=79.135.106.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="pneZWNOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780341542; x=1780600742;
	bh=vi4hrcsJw0zmTXPJsVF/0kIc+gNXs3IFoA5FM5kBcfY=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=pneZWNOVdjQfAc6gE73FkDPSbOBBkbXFOQEnPxu/1074q0GLE8M8WF2acF0CGoCUI
	 DsTZnudMeYs6/PxRUsDLeb1PQi7Vma3mNO++vnlwcXa1JT5fbx/GVur7NxntKhIH1M
	 9KdbdwaW2HswktzWz7v6UA2isgHAP5Kwy7X/AbARZ4IqTWMYk1mE6mFjnH8tEgu2E9
	 Z25BrPMevJSlRRLvK5WoYlGle/DQzxXf2/EDNQ/o5Y+mdLSg/rK1vpEn7H8+29zhC8
	 ULgyL+ZMsSpsJrMHjjwsWSAulIYG99Nm4lvgwQDspCP04W6HrTw89lP1gSrJxolW1g
	 TMg9QxicyOgqw==
X-Pm-Submission-Id: 4gTkKJ3vq6z1DDLM
From: William Theesfeld <william@theesfeld.net>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: convert dquot iterator map allocation to kmalloc_array()
Date: Mon,  1 Jun 2026 15:18:57 -0400
Message-ID: <20260601191858.608270-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the open-coded kmalloc(n * sizeof(*p), ...) pattern in
xfs_qm_dqiterate() to kmalloc_array(n, sizeof(*p), ...).  This matches
the convention adopted across fs/xfs/ in commit 910bbdf2f4dXX ("xfs:
convert buf_cancel_table allocation to kmalloc_array") and is the only
remaining instance of the old pattern in fs/xfs/.

No functional change.  XFS_DQITER_MAP_SIZE is a compile-time constant
(10) so the runtime overflow check added by kmalloc_array() folds away;
the conversion is for consistency and to keep fs/xfs/ free of the
deprecated form.

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 fs/xfs/xfs_qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7bd15d9e7..eebdeb181 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1170,7 +1170,7 @@ xfs_qm_reset_dqcounts_buf(
 	if (qip->i_nblocks == 0)
 		return 0;
 
-	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
+	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),
 			GFP_KERNEL | __GFP_NOFAIL);
 
 	lblkno = 0;
-- 
2.54.0


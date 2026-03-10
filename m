Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1FD3D47A2
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146010; cv=none; b=JwXn+USoOiYLfqxtD/rjthepPGejuHiY9Bqruqs0gvZtED4TREa4+5GaYDo5DvY1kRyJQu6le2USgUCDwK+lnY1jFAv7blYNgw4snTbjVCaAHfvlfFc9FXZzDKJvon+O2JWA5qL3sYfA3A2Cw+we+AUEjLEFoM5dE2fGBhhvwtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146010; c=relaxed/simple;
	bh=Y+yLNB+3vxPPGVfTOy2JxBAmLUzT4osGEDC+Mfvh3MU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qx+0Cd/aZsg6kg1Ax+JGcC3kgo4vmTFgJAY6IRkc8P4oxlE0p/i+SGcOsWOww2OvV46mcCOtG7cGb6nFzj6c4ohyuMB8lcLFj3J1GsKsLAULlC/H7jeKG7ptIRHcZGh+xOoGkBDVvp0ulzvBd5CFnn/8t2WN/5qgxWdW4Ps9ok0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmj152AE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmj152AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAF2C19423;
	Tue, 10 Mar 2026 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773146010;
	bh=Y+yLNB+3vxPPGVfTOy2JxBAmLUzT4osGEDC+Mfvh3MU=;
	h=From:To:Cc:Subject:Date:From;
	b=mmj152AENGFP3p+qaztaKw8dL82AUc+xopkQFk2yFz04Cyg6tobsXrYruzAEv6F0w
	 gLrYof1UmuoSGnJTdM0iavHonH042Z67isOVeMm6s0RRgaPLDew4RqrGp0ZqjALSTr
	 H5VhNBNZUGjcvr2hoaj7iPX4ej66NLDezngQrO/yR5QH3Ngs5HtfqzH5C7hAUa/Qj7
	 U1K04IhLnq9WdU+fvHbQfJw6W75PunXCeGWMkTOiQkiRdc1O52fI5f3xxr8m67TomH
	 sU5YFyy0Tr5/bCt+mTH5RCLmuBAo3aukkcSAZdBeWtsmu+5lzE5wtcYl3uKRGt6xbU
	 o8YXVZIBlhOvw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH 0/3] Decouple busy_extents from cil context
Date: Tue, 10 Mar 2026 13:33:13 +0100
Message-ID: <20260310123324.339310-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This series belongs to some work I am doing on AIL aiming to improve its
writeback performance.

I need the cil context to be treated as a single unit during AIL
processing, and having busy_extents associated with it gets in the way.

This has passed the same tests I run during patch integration without
regressions.

Instead of keeping rebasing it on top of newer versions, I'd appreciate
I could get reviews and upstream this part now, to reduce the amount of
changes I need to rebase.

I should get the next part ready soon once I fix a few issues on it.

Carlos Maiolino (3):
  xfs: add a couple helpers to alloc/free xfs_busy_extents
  xfs: convert busy_extents list to a pointer within cil context
  xfs: remove owner field from xfs_extent_busy

 fs/xfs/xfs_discard.c     | 17 ++++++-----------
 fs/xfs/xfs_extent_busy.h | 24 +++++++++++++++++-------
 fs/xfs/xfs_log_cil.c     | 18 ++++++++----------
 fs/xfs/xfs_log_priv.h    |  2 +-
 4 files changed, 32 insertions(+), 29 deletions(-)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
2.53.0


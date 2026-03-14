Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A3C1FC7
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 00:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773532847; cv=none; b=t3FZh1PDjQqyC6+1VgXbUvy9CgkXEsWo+e9BYHhrkNEy/3KGwFH5gjHdmfj9uE+/wsLlpSfI88RlCURFUTWXoZn9TbA1PnsGXDWONNvmpvZ0jyQSuvoe6Qqm+l/0fKOBeOl7PYip9hir1qSbxLeXA2UhvkrqQMVkKL36WiqXopY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773532847; c=relaxed/simple;
	bh=knHKiUWSQjqCTTfHjVg0tjIcGkNhFE/V1RclUjtDw4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T4/v61L7PGkUOry2W7UL25gdkyBVzAX6fGJIzqVbVOrD85oZEgEvaz41QioSiLvioblZ/8HXPOjugjwRZwGV+7Nqziy3OF1GtmQlHDpCnyCrVSlkHNJ6qob0zJKrVKgKVtTC9evMsy/WKeRRrsij59s6QUGw6kzWwFgfuDamlME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRI271a1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRI271a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B18C116C6;
	Sun, 15 Mar 2026 00:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773532846;
	bh=knHKiUWSQjqCTTfHjVg0tjIcGkNhFE/V1RclUjtDw4k=;
	h=From:To:Cc:Subject:Date:From;
	b=iRI271a1xrnV7Z+LqdlP4kEu4Wb9w/NRkB0ZcU/bVHKZZTPIc43ZsC6O4DnglCBCV
	 S2H+8y7AVwgJ2q/cll1plj1Uc2HCeGcQGCPE9TEkIIIEF3gKgoWsGpzzDtWK3zfHrN
	 JVyTLnd6EC26zxvm4LEaXgmnFIhHORAxUnHDhrSk4inVRZEWWyFEwzhYnNcoKHZXXM
	 gcbGppC+JQS2k8Y0ihOaW1ks1mTVVumS4D4HNZnGESzcq5xwVLsfYPGDxvvEASxbYm
	 iHuNSPdhEno3eFtha7+uik3OYTSK1VUYf9VICDtaxijXwF1+cGpEaPzD5ILtnGrk1H
	 0eR4321aNvD+w==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 0/3] Zoned XFS code improvements
Date: Sun, 15 Mar 2026 08:55:05 +0900
Message-ID: <20260314235508.183984-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All,

here are 3 simple patches to cleanup/improve the code for zoned XFS.
Overall, there is no functional changes introduced beside the change
of information displayed in /proc/self/mountstats (patch 2).

Damien Le Moal (3):
  xfs: improve xfs_select_zone_nowait()
  xfs: improve xfs_zoned_show_stats()
  xfs: improve xfs_zoned_need_gc()

 fs/xfs/xfs_zone_alloc.c |  9 +++++----
 fs/xfs/xfs_zone_gc.c    | 24 ++++++++++++++++++------
 fs/xfs/xfs_zone_info.c  |  6 ++++--
 3 files changed, 27 insertions(+), 12 deletions(-)


base-commit: f8544b654f22b1138ba12bc0971a96963b20311d
-- 
2.53.0


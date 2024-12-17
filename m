Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62C1487C1
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 04:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734409663; cv=none; b=JMqPHmw7LypAJNUkSKCeerKROcOJLF9vG20EgnQyIn/OZLfTQeUkdiwZeN2B9cLhrEqAcCLQwWgDzEK3tmJ+N07Uphx5SM6zXpeD/fJa+WJGSEnIY/eJ+31emWdQd/yNQ6tFMaSgHzpGdW8TrghOUudwG5cls4wKEe5qInrvTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734409663; c=relaxed/simple;
	bh=F8JQ1oNUiD1mNZm5hB1rT369i4V+eKEj4NN5/a42fhM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qcG6bTL4XcgDZHqp/BtEDjKC9nFwDbIcI8ww8L7T5HATHM5WGu4MNGuATki+9xQqSZxg05frANYD0MBDv6epB/aSgym8YfAq+N325cqQn5rPizTYiASWL1HorfQiq0Cz+Er4MmH4gx7afLtvTSqdlAYZqPDr8ithOIgxagl6na0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E9T9tl2V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E9T9tl2V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gnNb9KHUYZMY9YL041j1VlohFNjbpjK2Py/sV2Ypzaw=; b=E9T9tl2VvoMdwD2IAtM9fBDRoe
	eMwiHYD3q0UeulNaC+QYC7VspOrRh73kxT/T79yE6zUi7Rvg3Q2hF8/pymiG31ptP6sHCMbMRRItf
	qp/47q3wFh9uHNYkx4nMAfuzmDKAc6ffSLN1n98FJY3Dm7+Gg4EgN6DOPjPK/Yp/1CnOxUJpQd2mP
	3ppN3NY68PistQDKFOlgYFizWW6ZWY9/huMiauRdTzwmZTZo4iLb0ABmANdXKZT/w0CkI+XN/D5hp
	xiyHn0/Hhuy7+wlhQ5wtZF+UG+CR3sKPdQvpFNsjLumniW7MvaNqHjFgU/MYm2WBAu7dKA0TVXSM/
	wKGFIHzA==;
Received: from 2a02-8389-2341-5b80-985e-4a20-56ce-2551.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:985e:4a20:56ce:2551] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tNPBM-0000000C9LI-2ONE;
	Tue, 17 Dec 2024 04:27:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT
Date: Tue, 17 Dec 2024 05:27:35 +0100
Message-ID: <20241217042737.1755365-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Non-rtg file systems have a fake RT group even if they do not have a RT
device, and thus an rgcount of 1.  Ensure xfs_update_last_rtgroup_size
doesn't fail when called for !XFS_RT to handle this case.

Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 7e7e491ff06f..2d7822644eff 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -272,7 +272,7 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 }
 
 # define xfs_rtgroup_extents(mp, rgno)		(0)
-# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
+# define xfs_update_last_rtgroup_size(mp, rgno)	(0)
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
-- 
2.45.2


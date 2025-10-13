Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC7635948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323739; cv=none; b=Qc4IW02sij4JQjjJksfEasiVXbdNoBgy7Kl95zMqzgAvQ95drivPbNZGUVnf6pzhUrxrKku6RU8UBJS0VceSKkQQ1wxs2P1dSTvMMsIX5A/X6hOrhXuYG5lwaciC56t5IpCIXU0mivgx/lPsjXkaHHPO1IgSTMw1TnnF4Qn5Ngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323739; c=relaxed/simple;
	bh=co42cYnxE/fd71HmpoF/QexNjAeTQvLAVPsSIBC69Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BxiT2HNrWG59QBijli89p3aBT0d4PA5atXscUhipXexGoECz4GSLY/E7gQdbx0XMTyHBtwmPWwkdoLmANlwkbM54qn3C0kTWncRFsN+PamEWaCK8268VApe4nmx9wiZVRwUQX9CDYyWi3PI82PlKCayQBfDtScmq073b+g4nLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S9BvUrnJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S9BvUrnJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=W0rlANqP4Qyf+QC/SBRie5IlQ72NTAeKAN9zhijFctU=; b=S9BvUrnJLOpGwKNZOFfQylMgYS
	0HEMqn54JVc5/M6TAw1qXLRIA391YDkjpaGCzMpISsPIo26hVcGseyw4WaK+sLv0ZGBnVUdD4QiWh
	bTGQTCiT0PrHOO+p4+K3Y3Hrrii6KlEGsg/yiFRaMB1J6Ao8WCWESONQmYW0umCDjTMPY3997BgBf
	PXBVvEoH1ykt30kC9gTFrLvXnLANKNMxghVhF9gd79kbxRg3NHrdGSf9uhvA86FmNNEQcjbjlX8O9
	VVD+0IsKcIo9NPLLBPMO+VR51iJx9vIz6SpWnIH+YN6ANxxjMckrTvArE/gRRdpDYbynfetSrnQUj
	aJeXexnw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cL-0000000C7cN-1MZR;
	Mon, 13 Oct 2025 02:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup quota locking
Date: Mon, 13 Oct 2025 11:48:01 +0900
Message-ID: <20251013024851.4110053-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the xfs quota locking, but splitting the
synchronization of the quota refcount from the protection of the data
in the object, and then leveraging that to push down the content locking
only into the places that need it.

Diffstat:
 libxfs/xfs_quota_defs.h   |    4 -
 scrub/quota.c             |    8 --
 scrub/quota_repair.c      |   11 +--
 scrub/quotacheck.c        |    6 +
 scrub/quotacheck_repair.c |   15 +---
 xfs_dquot.c               |  112 ++++++++++++----------------------
 xfs_dquot.h               |   22 ------
 xfs_dquot_item.c          |    6 -
 xfs_qm.c                  |  150 +++++++++++-----------------------------------
 xfs_qm.h                  |    2 
 xfs_qm_bhv.c              |    4 -
 xfs_qm_syscalls.c         |   10 +--
 xfs_quotaops.c            |    2 
 xfs_trace.h               |    6 -
 xfs_trans_dquot.c         |   18 ++---
 15 files changed, 124 insertions(+), 252 deletions(-)

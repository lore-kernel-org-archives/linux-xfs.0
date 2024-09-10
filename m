Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB214F218
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 04:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942548; cv=none; b=gNj7LRqz9pn99NikPe6xh1O+S7skbn/Lxnk7e5hHM/3wwpdFD1uCGFj2KxvNqHrWZ0Bj9GHIyO+V4zIdY69/ieXtaNeOzVqMqXQQ2YIYjQvI+wU80erUI4konygT728hCsv/v+6UkGV0TB+oActmDM+tXCAhw4NmUU9tH5Ew/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942548; c=relaxed/simple;
	bh=dU3bvlMLcLw6Tsc1/L+JWNkBhJSk+KC9B9Fu/YjM6Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PTjrI6AE3+yFdP0UUJGoPRon4TE1HCayEr3aCRpOzn61fETyPeGmgs05MfJLmOIirAUbWsvInITjTtkQ4m4lf52K5HLCZExjMpLh36PHlGNZJRgSah0gJkHyP6G8Sq8vkNl+jXnRuUAAW0/1VfM+jLPY7DbB493IIImj8Y+9ItY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JvxF10Fk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JvxF10Fk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZrY2cqtG/oVp6LCxAcVMX5qLY1E5ZfCMeFPfGKnePbE=; b=JvxF10FkwPrfyeJ1j7MyazUoEb
	vCfRbALUR1NiTAOZvDKFKlaqWeGSqcp/zQJDdQ2iwVvKPvxl9fQw8qKRLLySZ8AzIrPaVUpYOWiPK
	nTdz4VktVNCFcgGg03EzR6qbneP2kgx2hQ5+pfCSKx2cmtxgQQfy2XKpsKRPn9/KhRpOMiLGKqhsf
	6bR2P3L1nqHyEXIOH0Vi7ZDePbMp21bkGPUETYOP/sS2cSCfkVxtGYX54hUfIvGAcLGUuPYYfqxMV
	ODMxvl+tyGTwsxAMZa7NAy9CgF2db7l+dED7u4ImhY1YhKfO+5N5n1HNBpONxBcZgAoYI59fiaipH
	AP88HSQw==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsUt-00000004D4R-2ysL;
	Tue, 10 Sep 2024 04:29:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix recovery of extfree items just after a growfs
Date: Tue, 10 Sep 2024 07:28:43 +0300
Message-ID: <20240910042855.3480387-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

auditing the perag code for the generic groups feature found an issue
where recovery of an extfree intent without a logged done entry will
fail when the log also contained the transaction that added the AG
to the extent is freed to because the perag structures are only created
after log recovery has finished.

I will also send out a reproducer for this issue.

Diffstat:
 libxfs/xfs_ag.c          |   63 +++++++++++------------------------------------
 libxfs/xfs_ag.h          |   10 +++----
 libxfs/xfs_log_recover.h |    2 +
 xfs_buf_item_recover.c   |   16 +++++++++++
 xfs_fsops.c              |   20 ++++++--------
 xfs_log_recover.c        |   58 ++++++++++++++++++-------------------------
 xfs_mount.c              |    9 ++----
 7 files changed, 76 insertions(+), 102 deletions(-)

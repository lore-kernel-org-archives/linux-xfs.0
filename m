Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7748E3090D7;
	Mon,  6 Apr 2026 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775455053; cv=none; b=uUt7mmjf/W5sxiKm+qDUS6CpVJSJZ+XJm/IhdRxXO/aY4I0ODVqt+fAO6Pih691lAuueFewZupcCIAs/uAzZ/xU2jsgsXwkXVJ2x8DUKZRyKh+GnQamoRPTZGK4uSqN1JLtMO4ZZIrVuwxyo9hqRAAux/kZ8VbwzFAIkW/97s0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775455053; c=relaxed/simple;
	bh=MCj2QB3L2Lyx0oRTyIqtQVX/PNdajocTylZNS+RaogI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RAcAeIH5zPhkN929cXarYN5Ddw4g6n8N6FFXtK2pPhzd9WVzlHEYarbdQOWXrLoBus7qIty/BUXuftub3fQX5QS+ZesV5VcnUfvFvhNvomxABHTCsZ3NuQBDVpj+JoXoxpYoB+nOd/VM5qQOgfMcg3sQCE3tzIYQluA7sf74NDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eSUyW+nL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eSUyW+nL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xuMIXRSb3RZJXFWAskxvLNDlMXgSeGYz0d/a+xM8OEA=; b=eSUyW+nLD6PwvTd66yzetuEKOM
	Fg/+JsHOaUWBAUEVHY8rJ+oLJREwz10Apva6Y0qrk1tqBeFOnLQOZVTmpVXAZsSzvEhQtXc2P84fq
	zi78wkuFr66zgJSLx6gJQOpignBhHl19xo1MASI3orqk+hfA8rcnXMrQLXyvuUsiXsSE88J9N6p86
	fMQyM3gzC9UZ6VKhlgQjwSTsMZVSHbeLYt8NInO27JSUGcfvreGvSpJW99Bes9EbSR038P9SpGvHe
	C/sSmajGbw/Z2vrKE0TsM60rm5RdaREhoXjgnMlD+11MeG7riAL3PGr3ynHfvsA5eE3Om0nH4mJDE
	YEXBn82g==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cxn-00000004pVH-2KFj;
	Mon, 06 Apr 2026 05:57:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: refactor submit_bio_wait and bio await helpers v2
Date: Mon,  6 Apr 2026 07:57:19 +0200
Message-ID: <20260406055728.472919-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series factors common code between submit_bio_wait and
bio_await_chain into a common helper, and then uses that in XFS
as well instead of open coding such functionality.  It also
cleans up the submit or kill logic in the ioctl handlers to
share more code.

There is another places in btrfs that could be refactored to
use this, although it is non-trivial, and I plan to add more
users of this helper to XFS in the future.

Changes since v1:
 - preserve (and extend) setting REQ_SYNC

Diffstat:
 block/bio.c          |   81 ++++++++++++++++++++++++++++++++-------------------
 block/blk-lib.c      |   16 +---------
 block/blk.h          |    2 -
 block/ioctl.c        |   11 +-----
 fs/xfs/xfs_zone_gc.c |   19 +++--------
 include/linux/bio.h  |    2 +
 6 files changed, 63 insertions(+), 68 deletions(-)

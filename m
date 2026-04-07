Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2C315D46;
	Tue,  7 Apr 2026 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570744; cv=none; b=BswhgpDyWvMS6DtZcN0hY/JExtenlBhEO8wU5Ooc5DNKibq8TzRKnUJzcvIZBiwSJni3IM7OLuVUYv1UWnMpd3zcgBHX1/TQWPcQtGc1CmrJ1K1bqdBcCydbs4VrrGUwTQu5iwbgEwmK/1A5ZHnfrb4okP3vl4Zd2E6kRq6gsKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570744; c=relaxed/simple;
	bh=bNTcYE+cRTy4wk6YpfrujvBRQ2WrOMVbRbBk5yG5O08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aohtFC02GEHPEq2ifLJNQMASajZVRR+qC3U0MIE6xx/egE1O9gb/cGQl66Zq8vexMedFLdvUGYMXXhO5iem3gMRaLcu0u0lsODjzERR3rLMOG65ZHTBnSgO/Re2l8zZ6v36H+tDIcCCLid4mchblkGhO+biE2JhKORBpZMWnu9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O9hEUAJ8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9hEUAJ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CQtu6M2OoTW2+9Rku5FRgYHosqSkYRkpUq1cIUCvdCw=; b=O9hEUAJ8xwC8v6JwLnHEL9SUv0
	dOouX61Azyv1GO3wA6BWaqqJKI3kYzWLTELu1LwHJxmrOkeYgQDTyBXO56yrMBoUwDfjhkxKvCJlv
	0XaDI1t9SorlwpJ0puKzAxqrzzM6o4Ys+mGuX8LA0nm3IwUiejRU7d24kdjDLW8q6JMw104MKTiCl
	Ak4mwXdFbT7Q4LN4un7hUFhsyKg70cBnjY8m6jCO71tRZMh9YBTPQv2Uzqb+fGYZb5w1wLVQvzain
	xb9OuBafHYSTbbtKKW5VyuiGuguEAXguqYQg+g/1C2rM8EZIrZwZc14uqPp/OqMsWdhRs7L+NwhZ8
	wsBtM4BA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA73m-00000006Ysj-3uFo;
	Tue, 07 Apr 2026 14:05:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: refactor submit_bio_wait and bio await helpers v3
Date: Tue,  7 Apr 2026 16:05:23 +0200
Message-ID: <20260407140538.633364-1-hch@lst.de>
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

Changes since v2:
 - spelling fixes
 - rename the kick callback to submit

Changes since v1:
 - preserve (and extend) setting REQ_SYNC

Diffstat:
 block/bio.c          |   81 ++++++++++++++++++++++++++++++++-------------------
 block/blk-lib.c      |   16 +---------
 block/blk.h          |    2 -
 block/ioctl.c        |   11 +-----
 fs/xfs/xfs_zone_gc.c |   38 +++++++++--------------
 include/linux/bio.h  |    2 +
 6 files changed, 73 insertions(+), 77 deletions(-)

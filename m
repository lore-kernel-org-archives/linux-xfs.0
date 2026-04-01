Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841DE2E11B9;
	Wed,  1 Apr 2026 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052279; cv=none; b=l83HUngw9c9IgEe7ZKBbLrHKriDgBcCzhVnIDZWz/8nzz/4axzXnWM1r+uWIQE51OzxgujHhoUVdc9A7VkVadktDLlxYkHGxAcv0oiKHyNcYsNUr8pVHIG2mlBwOihESY8841McDb2FLfbziZUKxBhkYIXaN5nAeMsG8CQmdc2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052279; c=relaxed/simple;
	bh=QwnIaDComFt5DA/RMMO5xZEHzYhf/RkPhdBbhsH8d2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SBDeHuZLhdt373OSJXgCFTtg06u0M4uR0DJoTycUlPU+s8AKV1VrKiDBfWlixVE5F3LRexBqw43VQ3VHnG86NcuF5YasBw0UyHn45QuAqukQEFDpDXTQTT5e4YZP2UCUvoRJrL+0TboHERe2Fq5tE2DxHJEXTDghvek5GKVlAYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NkT+xudh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NkT+xudh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+LgRutdunM8zsXhwoT1alzR/ay0lSuk8QsMqDwsAUNY=; b=NkT+xudhYkIQNN0OyqKwpfXohW
	o7TWRmg8Ib6aFRmmT66+nDLdQrdwcvqgcsABarWdv3YG/GOmcA2eDD1HK1LWVDAAwv1trN50g3buy
	1nDUc/fjBukm2XsZgTVFGRydgZOlSSeJEJmALierdrGrkiXbYI4nuDIygdjzr5A4Yh42oxp+LHWt2
	u/pWZVBzBMPS744uFqN52gCsvG/mqSIUpMjmNZ5IMeD3H7RPTQuL3bA8wJFCy0DppuuUxapNEif5b
	2NL4NegY3/OMX1lzpLGGXk/QNlW1PzFS3k4cZKzRboGEiMfYK1xoRSs4sUMEsFL4NI07R7tD1Tlmw
	9oDtFX8Q==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7wBQ-0000000FNPu-1kIX;
	Wed, 01 Apr 2026 14:04:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: refactor submit_bio_wait and bio await helpers
Date: Wed,  1 Apr 2026 16:03:55 +0200
Message-ID: <20260401140433.125924-1-hch@lst.de>
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

Diffstat:
 block/bio.c          |   80 +++++++++++++++++++++++++++++++--------------------
 block/blk-lib.c      |   16 +---------
 block/blk.h          |    2 -
 block/ioctl.c        |   11 +------
 fs/xfs/xfs_zone_gc.c |   19 +++---------
 include/linux/bio.h  |    2 +
 6 files changed, 62 insertions(+), 68 deletions(-)

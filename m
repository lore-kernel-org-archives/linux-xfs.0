Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCDA31D730
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030757; cv=none; b=eQ1/aX8HmeA3r20f1MuQpSXVB+nmUy/8cDrOlzI2gEhtcQCfFsDcfHtNtDyzQAX0AaiW0PRCqPcuRBd6OFXrQw4obL9UZYdWlpTC8LiEVgODwVxM4WwREnGU8o6S9m5vn+EVsQfwk+iqxE/lnze8TC8xMT4K99/v0lGS+PI8jZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030757; c=relaxed/simple;
	bh=ev0vHlWiAV+bv+81ZZutO9YjewQCDTVz4zpwx3pzsak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uBMWkWH8LxDs9ZhOcwDR4tw5trFte1T/JOjB/TqulDVqWrtJIdu4Dbt3+GicqHW8TBc0YnpSc/9APx8ea8+mK78vldWJWMymxldGcctS1283Zibl49eBvaZLJmbn1039FitADOfPac/Djpv2/S2li8cCXHENip0P3e1FEJOGF/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oshQqEmd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oshQqEmd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5maVcgrmmn/MJTiNwtLEZ7qZgSjx+qGX3/ZwU5NCMYc=; b=oshQqEmdp3tLlUg0jhLDXA/JzW
	VyAGho8gPNxVFaxEYGZaFMnvMq2h4uefPL+FPH8jBu////ce/B5cX3+shc8VcN8OMiTHDa8f4tica
	J7Go+3ybVml+Lq4cG0P56Y+l+hljB9Btd2ipdNp3nTAI+wFA7I6ysN4iSUji5FHXxSDkqLQ4nFiwD
	bDUcPbOxxYsgsELcaQbZUBK8WfhMLi+3nznzrzb+yWyxQi7s3JudGdOm5sdgFGl07Y/hic0PK3BrF
	+t23CCqTobA09uhJSLY304yoZru8zX1xV0ge1QRkrJPqJ9c8KzgI9IqDpDzwO/cYUnTZ+Rqnnra6l
	bjRtYA3A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyW6l-00000007zf3-2uhE;
	Tue, 16 Sep 2025 13:52:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: store the buftarg size in the buftarg v3
Date: Tue, 16 Sep 2025 06:52:30 -0700
Message-ID: <20250916135235.218084-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when playing around with new code that stores more than the current
superblock in block zero of the RT device I ran into the assert in
xfs_buf_map_verify that checks that a buffer is withing sb_dblocks.

That check is obviously incorrect for targets that are not the main data
device, but unlike to hit in practice as the log buftarg doesn't store
any cached buffers, the RT device currently only one for block 0, and
the in-memory buftargs better don't grow larger than the data device.

It's probably better to fix it anyway before running into real issues
on day, and storing the value also removes the need for the notify
failure code to poke into the block device.

Changes since v1:
 - grow the correct buftarg when replying a primary sb update

Changes since v1:
 - grow the correct buftarg when applying the growfs deltas

Diffstat:
 xfs_buf.c              |   38 +++++++++++++++++++++-----------------
 xfs_buf.h              |    4 +++-
 xfs_buf_item_recover.c |    7 +++++++
 xfs_notify_failure.c   |    2 +-
 xfs_super.c            |    7 ++++---
 xfs_trans.c            |   21 ++++++++++-----------
 6 files changed, 46 insertions(+), 33 deletions(-)

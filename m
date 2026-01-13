Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABCC269CE7;
	Tue, 13 Jan 2026 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768288762; cv=none; b=VDB9st/zjNE2Bf5GlCuYogKuOIYWnkMB+9NQNlyD4Al6Fs8WW9W1At6rLewjfYcHPxo0RsNIsxUWb4JvH1qzN4q1jdSbyqpd0S/cgmiPKO5rHuJDDHT/7wVBi2xBmj1w7DEF/iyhiiNnGfrMPL5O0vYAfcykXeFz6zYaQjb5ces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768288762; c=relaxed/simple;
	bh=3o0qrTBij7ZXAwEQSzdiDF922ENSwpqcvO23bcQ5V2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g27V0WEHTWBykG5c0/MOJOcku0p9YkCiOK4pIo5XE76p1+EKPVyCA/JKJcJTXUgFPn+l0oaTceVk/gfL5wswRh77eDndaa44eFVQUBab8DIsrJpoOOT8scP20NUsJ/cc9otY1DBPYpsVBlFQWdVH1WMU1zabAn3HcwkPulgdpN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UxqpZIO/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UxqpZIO/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=khiRlHWzVQktDDnpu65BfKffTvpaVTSOB4TwYQDcD9M=; b=UxqpZIO/vK9hu+nB7Ya7YFnULr
	CSFyiJdhsA4AuT/gHtUFQwHURDd7BtuLTRZxt6r39U6RSU+HLM8w9NV/5GZ2czaWNdnDOn4wBeZyv
	bM3ErK3pJRMunTpDZJqTC/Jx6xrHQrR7VgSPJdPdlP3fuon+2QI+mpwzdQv16yVh1WmLvOzPJocXH
	S0Ajw1b5ZzkCqh77mznpaEj4e4uaWP+CD5EQeyMZNDBXytvGhHptHMeK7ELoKqNKFZ4u8YzA8cpaM
	BvB2YbDO0BH8J8nXllfrCmqUE6PU3i+xLS9JHvoTVeJ1Dig7c+ScMdK3VvJChOxm1BBsx8z6smQJs
	hyhDKWjw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfYgO-00000006dTv-3c4b;
	Tue, 13 Jan 2026 07:19:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve zoned XFS GC buffer management v3
Date: Tue, 13 Jan 2026 08:19:00 +0100
Message-ID: <20260113071912.3158268-1-hch@lst.de>
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

the zoned XFS GC code currently uses a weird bank switching strategy to
manage the scratch buffer.  The reason for that was that I/O could be
proceed out of order in the early days, but that actually changed before
the code was upstreamed to avoid fragmentation.  This replaced the logic
with a simple ring buffer, which makes the buffer space utilization much
more efficient.

Before that, two patches  makes the reuse of the bios a lot less fragile,
and for that we need a new block layer helper that should eventually also
be useful in other places.

Jens, let me know if merging the bio helper through the XFS tree is ok.

Changes since v2:
 - fix a commit message typo
 - fix a missing : in the bio_reuse kerneldoc comment
 - warn about bios with integrity and crypto context, and add some
   documentation about this

Changes since v1:
 - assert that the reused bio is not cloned, and update the comments for
   bio_reuse a bit

Diffstat:
 block/bio.c          |   33 ++++++++++++++
 fs/xfs/xfs_zone_gc.c |  113 +++++++++++++++++++++++++++------------------------
 include/linux/bio.h  |    1 
 3 files changed, 94 insertions(+), 53 deletions(-)

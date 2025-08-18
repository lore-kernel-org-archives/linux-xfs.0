Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639F721770C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493919; cv=none; b=ns6WtZWEVBkN3dBgKegSuuTQTnFG6MOevBDnlspMD4Qf3mpUzU+W3KwZRKbbAS+MVFf4xq+cGjqzHjd95JxucpzIpX4hRHB3wjVqMClQY/T1rk/magoymAdbnAmnw/0JFUMdX5D5o09rCpWlPsN8HGMgjotmEjr0HXVHmgqCNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493919; c=relaxed/simple;
	bh=uDgxO2cPkWbTMqvUasLuI8VLLmsdO8i5BV7WBccfpyY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hApcQVKZCSVZ6WF8ZAUWhBIxDkMxrwHTNEX13sGAv5UTPeAgxRBGbE4JH+KJ3yRk0twVkZjlZ0GCWszD0SJKjJQxCqHrtjoQgQIwN6dZOvNUKMoUGGhUlpD9nbny9LQdUdv3vb4+rlD3oU61scM4qGgGIAv7BAt78bb4o944Cs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V0+ypunl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V0+ypunl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TAbYChIvejupsc7PjcGDhS1mhK9H8ceYqqe04ekJYO0=; b=V0+ypunl8Jd3U1E9IZBwfBeh4n
	/A3HB4CZrNZjBCx/0Lpy/jeNO7Y/2GuOokoAtpo4zGpMmSy+fWZRNO22JLgKb3zToXhu+PQOb7dUA
	bYdNAGuTcY9pzpHe3tK04EVFxveRSy54T3YwDfJPQMsD+IXxl4NNVlLNWDDhsn+LMSbbN02tF2J7u
	sCuTZtscXb4SETFdU6vemQTJdg6vkFBzsZ02N/KiF7jCr7HwJ/8aRo2pmaocjvWXTIktN4X3jupDT
	TuFc0dwYHnKcsM9OEyw2kCQ61UjyrA7SZLA9FPr0BSTCOaxbaQTun0Xn+I4eh+A6+QE8g9sWfsvlP
	tE+Z+X0g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unsA1-00000006Wm2-1xrI;
	Mon, 18 Aug 2025 05:11:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: store the buftarg size in the buftarg
Date: Mon, 18 Aug 2025 07:11:22 +0200
Message-ID: <20250818051155.1486253-1-hch@lst.de>
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

Diffstat:
 xfs_buf.c              |   38 +++++++++++++++++++++-----------------
 xfs_buf.h              |    4 +++-
 xfs_buf_item_recover.c |    7 +++++++
 xfs_notify_failure.c   |    2 +-
 xfs_super.c            |    7 ++++---
 xfs_trans.c            |   21 ++++++++++-----------
 6 files changed, 46 insertions(+), 33 deletions(-)

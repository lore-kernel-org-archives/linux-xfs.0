Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773522147E6
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157566; cv=none; b=fjHe38pFcnvbLWBmI56LK3piPeaR71Bbv9Tx2bnbHVTjQol6yJAzlB4tu4EaC6AZo6P3MuIT9e4cEbDc5vpgxBlXRlgskPJPu4Ap9R41wKnjrUStqRFKMWkiTbfGxJuJ5y3/a3wXSDAhnUMBpUEvqR8VJvgcg8OMhbw6933n4lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157566; c=relaxed/simple;
	bh=GT3usQh904AIJg4ooqYDE23to5enGOZE3+JhUCHxeN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C3pIgmKshCpKoPZNQXqb8mmay3zMQxXkAm/I6hRGin2fRt8IlCf42lEO5NSRwvE6VwQgX81AqFjaH+sRPDReWJHRmATLx6yto6HteFSV0B3eIDjv34YlbWUnx0S4h2BaVj+akfToWA4UnTn4j7pxCnUK9G0kkmDsnCUmXmJlb1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cMiZ1GXR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMiZ1GXR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CqHWYaJxOxEpYSP4KrdmYfU6IBuTVJowlzA8cxHAzgA=; b=cMiZ1GXRGHBuvznvFpq4q6lJ1L
	ShVxFmfH6QZxcIzd3Se1VCJF1IGHUyAWj1sLf++2KzyO0rLlZ4QfngReuLLy+bksUttShbCYBKaZA
	e5rGfbHms+2nNt7uQFqY4wxvgyyJBC9kOHFtsFjBuxYJ6PJc52df3ZgZ4fvwWfemsBJzzTZCcAKWJ
	q9/SmLszXjW5C/q62EusK47OBeCqF6GHgPlgQk9Fzyun3mIDi5gSEAEFV0vfbYYHD8fuX6EO2uA+C
	uj/yyi2bxwulKW/umAHlSfEZAMMngO62xaUX44lMJ3R30vj7bhOXEbFnBA5RJ5o66FzrN2TAbn2K4
	VcyvC1rA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvm-00000006yPV-2bNt;
	Tue, 17 Jun 2025 10:52:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups
Date: Tue, 17 Jun 2025 12:51:58 +0200
Message-ID: <20250617105238.3393499-1-hch@lst.de>
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

this series has a bunch of cleanups, mostly around the mount code and
triggered by various recent changes in the area.

Diffstat:
 xfs_buf.c     |   42 +++++-------------------
 xfs_buf.h     |   23 +------------
 xfs_buf_mem.c |    2 -
 xfs_file.c    |    2 -
 xfs_inode.h   |    2 -
 xfs_iomap.c   |    2 -
 xfs_iops.c    |    2 -
 xfs_mount.c   |   98 +++++++++++++++++++++++-----------------------------------
 xfs_super.c   |   12 +------
 xfs_trace.h   |   31 ++++++++----------
 10 files changed, 74 insertions(+), 142 deletions(-)

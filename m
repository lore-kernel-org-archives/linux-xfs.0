Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF5111A5
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714374127; cv=none; b=D4O8eizXISGh7nj5uNfKca2Fu+gMDpZFI7zemfNy6mOrh5G/EM7tLh2Ak111OABZ7WfPIkRZJDdBDVP4OIW65jC5XvC9B0WElMVVhHw8Y7+yIkid00EDo5WIYbszFr8TzrgGNod2OfrkerW2Ibpt8O4KK3rrn9Xt+P4rWphGvu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714374127; c=relaxed/simple;
	bh=rLRApm40QalDJmKWiLw2pmMaJME+lrRbqHt9gh/uHiY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c8Z2kKAywjigYvleHSiJJKdoIqL7ELIAW4WqSD9IvY64PoAsW0rCvY8HG9wMdDqhEkmBskWnbTUH0MyuppjhuIvid2vWLgyIyN+d9vvTq/0uXJn6rV+EE7uBhwzmIRiARmUvgPz+qYjj5x1v/wK655uzCvPwgo0xDTJblCRHpw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ol4xYzku; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ol4xYzku"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uPODyH8ffh+k1+m7xRLGRzUfYA/gYKa6E2Ey9pANRoI=; b=Ol4xYzku4ybvl0dDx1zTChwXHv
	1Me4EQx6psPlx+Q0S3jjfXAIlAsrp3nziz+pciD78TzlWtKjmZnVsXbliWLCaK6gB2Xx6uTJGj2Er
	gUmY1hQSSpagYDofMF/3FaJEcSspIyTwfdg6H1bs9OliAWr0QzfOMfrNv0H5DyZ76z8g20+PCD7VH
	NmIdwn8+mNE64q4uzy6z4GDeyefA2HXPgUZ2e3th22CNOHrXOOYdEqkIlaZfJ1oFCcAjnqDNfFaVE
	+ZUXXZGTbMmqtZPQ0ajzBZ2YcPVtoZqrbCB6ZU1mf+IOguI5qAlTH5UvikQhgAV6933IQ+UK323wy
	quLCtiUw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1L1W-00000001kLY-2Kvl;
	Mon, 29 Apr 2024 07:02:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: fix h_size validation
Date: Mon, 29 Apr 2024 09:01:57 +0200
Message-Id: <20240429070200.1586537-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes the slab out of bounds founds by Sam's fuzzer,
and tightens up the h_size validation and log recovery buffer
allocation while at it.

Diffstat:
 xfs_log_recover.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

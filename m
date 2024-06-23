Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469D820E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120940; cv=none; b=QuBp/kV9hcxjL++IHby/Jv0bwFQc01KRQ6/Mm/dzAVM1tJXfhdSKOqFEKt7e0m+SQI5GMTi+/johDMsFG0IgF6TO92C0l6xrnZneL5PFN35Ih2SEiBp9yDXCH/zH2sQaIOMs80krRyFvZnJbFVr47//7nBb8PhRm2T4yHbFhk40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120940; c=relaxed/simple;
	bh=h/Pb4m2nL+q9qEjpD5QAoV0ts52vxvcjWKPoVQ229BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PEuR/cR+staUWSTCrehGvOS9QnNTpUuK7ZzzU2h74tF7w2ScXQ8vqALrRPKdJzJAFRkO7z0wwdEZuDJfN3ADtHiSUK7cFOE9I4dtIMpbUxL+40ZqH2WAuOv8aOVWNbcVuY7Ep4p/cVcTqQ0rmz2awGy8RbJRqL+SmxbTyD3oEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GezRkaRQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GezRkaRQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=w8D+fJaDCz9jW8WXfbAgpc2GhLIYhUEqE49fm6Pup8U=; b=GezRkaRQHtUVt1xi2a3Zd1sN8+
	Ruf3GCPTFIGQYbeDbYEt8nYZK5uLNAyVJrboHtP9+egvc8MYyfQr/C6U21d9O3FMXo6LHvDbraYQF
	jtMvrwsazwyEITXRlA3s+AJ52zHrkkRycaOyX2CUAUOVMZdgIi3wWvlDgQZOVAbUQ72KbjzD/rWlH
	C3u2urxg2NxvdUtr+Dc8stMrAbvxRcYrMYIDFeD7hdT4K4rO+/vM/wROZGlyUVIm+NMUfWccOhrBF
	YcJ5uZOI67yN9gModiWOh5riTCY2OKxGW6MBe+3/VceUwW5wR6DjayU7xVpH9sApNLeiftKydUucD
	Dq1S4L/w==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFt1-0000000DODa-2VAo;
	Sun, 23 Jun 2024 05:35:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: post-EOF block handling revamp
Date: Sun, 23 Jun 2024 07:34:45 +0200
Message-ID: <20240623053532.857496-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reworks handling of post-EOF blocks, primarily in ->release.
This takes over the work originally started by Dave in:

    https://marc.info/?l=linux-xfs&m=154951612101291&w=2
 
and lingering in Darricks's tree:

    https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close

for years to ensure ->release doesn't too eagerly kill post-EOF block
speculative preallocation and then goes on to not let preallocation
on inodes with the append only flag set linger forever.

I'll also post a rebased version of Dave's patches from back then.

The first patch has already been sent standalone and as part of Darrick's
fixes series, but as the rest of the series depends on it I'm sending it
here again - third time's a charm.

Diffstat:
 xfs_bmap_util.c |   58 ++++++++++++++++++----------------
 xfs_bmap_util.h |    2 -
 xfs_file.c      |   73 +++++++++++++++++++++++++++++++++++++++++--
 xfs_icache.c    |    4 +-
 xfs_inode.c     |   94 +-------------------------------------------------------
 xfs_inode.h     |    5 +-
 6 files changed, 109 insertions(+), 127 deletions(-)

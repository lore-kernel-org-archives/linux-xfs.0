Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nva5bY6T"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B652EC4
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 12:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rC7zs8ARwIqx7XfmN9QOsJBAWvxuhA3Os712frhfMwo=; b=Nva5bY6T4ysyoM9Jx+b/qBhFhA
	HtIj+aMo/b4W21UkD9WtDm77jN2lUHZEGLDWfrVHtcIW9hXMxcAA4cOR0msMW3db6T9kxWpnnwTzm
	cmGhuYaT68LF+b1PkjmphSSn+G9/3rFM/qYzUjchlBonND/wAWu8vjnA+0E6wcOb8pYv2ILM4vn30
	XPqq/lRDssmTrRKv2gV2R7J9WyumJvXfqlTosmVYPnw0ZOScDxHuTKIIZ5es2D3wftYuvXKQ4hGr/
	fBE5c41BqcUajNVBc4t6io5s3YH7To2OXKda12cJA7Ma05qVieYIHEfd+jDBjpXC3AbmZEDJ/ImDq
	VA0l42yA==;
Received: from [2001:4bb8:191:e7ca:e426:5a32:22a9:9ec0] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rAFE2-005WA5-1h;
	Mon, 04 Dec 2023 20:07:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: move xfs_ondisk.h to libxfs/
Date: Mon,  4 Dec 2023 21:07:19 +0100
Message-Id: <20231204200719.15139-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204200719.15139-1-hch@lst.de>
References: <20231204200719.15139-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move xfs_ondisk.h to libxfs so that we can do the struct sanity checks
in userspace libxfs as well.  This should allow us to retire the
somewhat fragile xfs/122 test on xfstests.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/{ => libxfs}/xfs_ondisk.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_ondisk.h (100%)

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
similarity index 100%
rename from fs/xfs/xfs_ondisk.h
rename to fs/xfs/libxfs/xfs_ondisk.h
-- 
2.39.2


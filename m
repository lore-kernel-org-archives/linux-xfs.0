Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0C46420
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oHplK3Ko"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gcAzqK+lTkjK9vIUj42PNFprXLQjjfIXxq3h1Y6NlkM=; b=oHplK3Kow3B4p37Nh+oap4ZhcB
	lLFITdDk48SDBVgR1OR/YjJqyQbl8J4FXURKCL052ssa8VVypzpupLzdBfHS3my3eWzcelOErajeR
	yzKLeOTYU6KM+nZCHYM95VeszngVslFOzX67GJNL8ls7llsqjA0uG2mXufP+VlriTueO+XrOQvX/c
	gUi4EJO6ef+hyXVgwJdntBRW4v7UgrZZlXf8F4n88OTP3ahYumGVXiOi314cFtP3ua+zvGZlB08lv
	ArVSpvQKa0NE86C+qyjRmDjU+oUEp3yYB9ydW4mMTXv+HvTNgr8b+tPTN9SDkQnyDQzVqvf0ZjIzE
	MvDb2DJw==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYS-008AF1-2y;
	Sun, 17 Dec 2023 17:03:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: attr cleanups
Date: Sun, 17 Dec 2023 18:03:42 +0100
Message-Id: <20231217170350.605812-1-hch@lst.de>
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

this series started by trying to remove xfs_attr_shortform as sparse
complains about it due using a variable sized array in struct using in a
variable sized array.  I ended up cleaning a lot more code around it
once I started looking into it, including some basic cleanups for the
inode fork inline data memory management (I'll have another series for
more work there at a later time).

Note that the dir2 equivalent for the structure has already been removed
long time ago.

Diffstat:
 libxfs/xfs_attr.c           |   28 ++---
 libxfs/xfs_attr_leaf.c      |  215 ++++++++++++++------------------------------
 libxfs/xfs_attr_leaf.h      |    7 -
 libxfs/xfs_attr_sf.h        |   23 ++--
 libxfs/xfs_bmap.c           |    4 
 libxfs/xfs_da_format.h      |   30 +++---
 libxfs/xfs_dir2.c           |    2 
 libxfs/xfs_dir2_block.c     |    6 -
 libxfs/xfs_dir2_sf.c        |   78 ++++++---------
 libxfs/xfs_iext_tree.c      |   36 +++----
 libxfs/xfs_inode_fork.c     |   70 ++++++--------
 libxfs/xfs_inode_fork.h     |   10 --
 libxfs/xfs_ondisk.h         |   14 +-
 libxfs/xfs_symlink_remote.c |    4 
 scrub/attr.c                |   17 +--
 scrub/inode_repair.c        |    4 
 scrub/readdir.c             |    6 -
 scrub/symlink.c             |    2 
 xfs_attr_list.c             |   13 +-
 xfs_dir2_readdir.c          |    6 -
 xfs_inode.c                 |    6 -
 xfs_inode_item.c            |   10 --
 xfs_symlink.c               |    4 
 23 files changed, 239 insertions(+), 356 deletions(-)

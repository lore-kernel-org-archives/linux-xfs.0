Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F921D52E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 20:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KDxE816S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=iHc1VIK+FQHTxxZYWinxJhm2R2v7O5CXab2Z6jdBwi8=; b=KDxE816SnbGftr0NMCc99J133C
	wbDuCKB6/jQq2/kxVP3Dg41msZ7LfucEVn00UNTDtCB7eBX6na5MvGukP+s2MnS3v0Vybj/7GyUKd
	Rjah1LC7lbJoa5m9+7IawslzvlxHVsblQPIXb0GTosmO/3725hvfZDuyai8WXSQQi+tXmw9+ddJ3D
	kF/NaYgUD48gPmBlhAglIZqUip046qjTGe2sCZ7ZC+q5dCw2/awtGypxv6yOwYTggh+T4HptQsczm
	Na/H4svQo4fx/+kpOsJl2EKB+pXRs200lQWQuCNIp2otnUXvrhfKQRsvCZ+kKjVP2MPi4n2tvXdhF
	QD6xf8KA==;
Received: from [89.144.223.119] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rL80i-00C4SC-2L;
	Wed, 03 Jan 2024 20:38:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: RFC: in-memory btree simplifications
Date: Wed,  3 Jan 2024 21:38:31 +0100
Message-Id: <20240103203836.608391-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Darrick,

this series has a bunch of simplifications for the xfbtree code I came
up with while reviewing it and trying to understand the logic.

The series is against the djwong-wtf with everything and the kitchen
sink, and will need some heavy rebasing.  As always I'll offer to it
if the changes themselves look good.  I'll probably have a few more
invasive bits in this area when I get further.

Diffstat:
 Documentation/filesystems/xfs-online-fsck-design.rst |    5 
 fs/xfs/libxfs/xfs_bmap.c                             |   27 -
 fs/xfs/libxfs/xfs_bmap_btree.c                       |   14 
 fs/xfs/libxfs/xfs_btree.c                            |   52 +--
 fs/xfs/libxfs/xfs_btree.h                            |   13 
 fs/xfs/libxfs/xfs_btree_mem.h                        |   38 --
 fs/xfs/libxfs/xfs_rmap_btree.c                       |   17 -
 fs/xfs/libxfs/xfs_rmap_btree.h                       |    5 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c                 |   10 
 fs/xfs/libxfs/xfs_rtrmap_btree.c                     |   27 -
 fs/xfs/libxfs/xfs_rtrmap_btree.h                     |    5 
 fs/xfs/scrub/rcbag.c                                 |   47 --
 fs/xfs/scrub/rcbag_btree.c                           |   15 
 fs/xfs/scrub/rcbag_btree.h                           |    5 
 fs/xfs/scrub/rmap_repair.c                           |   55 ---
 fs/xfs/scrub/rtrmap_repair.c                         |   49 ---
 fs/xfs/scrub/trace.h                                 |   13 
 fs/xfs/scrub/xfbtree.c                               |  306 ++-----------------
 fs/xfs/scrub/xfbtree.h                               |   34 --
 19 files changed, 154 insertions(+), 583 deletions(-)

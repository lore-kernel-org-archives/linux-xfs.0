Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K/sQZ51t"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073E7AB
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ncb/zNqNo+koGeqqo9GR8PnxRr82NoGDt+PRZCHrWL8=; b=K/sQZ51tIPZaQSqjcI2gdfGKrX
	3m1nsw3+CAGcVWbCQWyPWoikL9zBdWlIK2C5bGw1ml7/fjfMJacw2I0VfRVff5e7BjaaExTK91sbM
	/hT2Bx8DQdyedXKUEAVhCrUBzStvTYat7M1sLL81Ogg5QYPuXfzQtTWZsFrOczHYpmUIIAFuABSkW
	jgD5nDW5AtnI9DJN/aBAmjABSxLRvNI9E0JO23olArdZFX1blBa5CBuF/RHpp11uYvpFJmgcI5SPT
	ODF0mvp68CE+nxRPsUo/8VpSyG3WUmpiv/vdg6OtbmVBDpG2dUFpReCanqE3dXg6LQnHKlFYl66VW
	GgU/+kKA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDLCO-00E6ck-2x;
	Wed, 13 Dec 2023 09:06:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: pass ops directly to the xfs_defer helpers
Date: Wed, 13 Dec 2023 10:06:28 +0100
Message-Id: <20231213090633.231707-1-hch@lst.de>
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

this little series cleans up the defer mechanism to directly pass the
ops instead a type enum that is used to index a global table.

Diffstat:
 libxfs/xfs_alloc.c       |    4 +-
 libxfs/xfs_attr.c        |   92 +++++++++++------------------------------------
 libxfs/xfs_bmap.c        |    2 -
 libxfs/xfs_defer.c       |   63 ++++++++++----------------------
 libxfs/xfs_defer.h       |   25 +++---------
 libxfs/xfs_log_recover.h |    3 +
 libxfs/xfs_refcount.c    |    2 -
 libxfs/xfs_rmap.c        |    2 -
 xfs_attr_item.c          |   69 +++++++++++++++++------------------
 xfs_bmap_item.c          |    3 +
 xfs_extfree_item.c       |    4 +-
 xfs_log_recover.c        |    4 +-
 xfs_refcount_item.c      |    3 +
 xfs_rmap_item.c          |    3 +
 xfs_trace.h              |   18 ++++-----
 15 files changed, 110 insertions(+), 187 deletions(-)

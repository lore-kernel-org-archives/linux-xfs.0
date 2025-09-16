Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B118032856B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040129; cv=none; b=GWwGlewa3gJy6ECka1bEomdv0qmkH2l3NwH5uV8jixjN/HJHhdX0CymTOQzKXqC//E36J/EaGgFOU8cGf8RoMPuUNozULGUyyZ3rWwJDpFH9beL0sjiHiQtvMvloDELF6SQDl5B13BCKK4776tMuAhpxCSRHu2u9WwONipGVS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040129; c=relaxed/simple;
	bh=V4rX2F34uFGptDU9ZkimGjoMWfc2HQLDhE3y1AwvpXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K9jjJAeF+nTJAPnGJUooEIz7tyO94szZL0OM6gzUbLNRy7kBltyUhkHXW9ImtKF9ldPp8k28PCwjtMwXH3XCKMuFMEYVgzCF/4rhGbt8p8j+ORq1f5JDRCxkutdQ90kI7J3sGxz9/WV+HLpbVJromlJyvqLCppEiGB6YFjCzJjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J4RR1ddU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J4RR1ddU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dTcY1GF6SmMxHk2XYuBbn81v/8/Z7whl9zgMLwQ8QZg=; b=J4RR1ddUCo8j5ITGChhWXVTGui
	3ApQFYQj4u+IyzHsG+baVWvAoQi5QzRfdrkWEADv+ze6CVqcWTf2wniQOjJBtwzn/7WN9Xg2BG2TJ
	2nWYS/QHcqSvqtAKZPGO+vgwToJ2C3Gs7Q74WxUNfgsfZ9jIOFgO+eAmzJVGSVVp1TA6Wn4fH7lRs
	5N6E6NEuESVvwXPXqm/VTyIDrdh2/SVti9mQt2p5K0WJzFt/UN11O+Nhcg5Ib7KgyFwF8m1q/xpBm
	KPpKr/SjhOwq7aeMTV2p/AUjDas+2eC5X0sQBqcbw6e0LFYOgKf1ZzNJBmRjAXfnpW4/5HsWL3BnY
	kG7yXIQQ==;
Received: from [206.0.71.8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyYXv-00000008T2j-0k6U;
	Tue, 16 Sep 2025 16:28:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup error tags v2
Date: Tue, 16 Sep 2025 09:28:13 -0700
Message-ID: <20250916162843.258959-1-hch@lst.de>
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

while adding error injection to new code I'm writing I got really annoyed
with all the places error tags had to be added.  This series cleans the
error tags so that only the definition and one table have to be updated.
I've also cleaned up a lot of the surroundings while at it.

Changes since v1:
 - add a big fat comment and a idef/undef pair for the ERRTAGS magic

Diffstat:
 libxfs/xfs_ag_resv.c    |    7 -
 libxfs/xfs_alloc.c      |    5 -
 libxfs/xfs_attr_leaf.c  |    2 
 libxfs/xfs_bmap.c       |   17 +--
 libxfs/xfs_btree.c      |    2 
 libxfs/xfs_da_btree.c   |    2 
 libxfs/xfs_dir2.c       |    2 
 libxfs/xfs_errortag.h   |  106 +++++++++++++----------
 libxfs/xfs_exchmaps.c   |    4 
 libxfs/xfs_ialloc.c     |    2 
 libxfs/xfs_inode_buf.c  |    4 
 libxfs/xfs_inode_fork.c |    3 
 libxfs/xfs_metafile.c   |    2 
 libxfs/xfs_refcount.c   |    7 -
 libxfs/xfs_rmap.c       |    2 
 libxfs/xfs_rtbitmap.c   |    2 
 scrub/cow_repair.c      |    4 
 scrub/repair.c          |    2 
 xfs_attr_item.c         |    2 
 xfs_buf.c               |    4 
 xfs_error.c             |  216 ++++++------------------------------------------
 xfs_error.h             |   47 ++++------
 xfs_inode.c             |   28 ++----
 xfs_iomap.c             |    4 
 xfs_log.c               |    8 -
 xfs_trans_ail.c         |    2 
 26 files changed, 165 insertions(+), 321 deletions(-)

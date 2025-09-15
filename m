Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562952FA0F1
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943066; cv=none; b=ZCAFMSH5yGBsIp7JXAco+S5LPccMTFYOkEqPa+DytiZaGabenQY+Zg6dcBGi4l1AaNcUxom+BZNBY6bLYPGKe0c0XBAgHQSGFwb1nM1dA/l7WnIz3OAjFSdH/rt7Ev5MJlO9b5U+TUHimCs45YoX2GJ+AI12MyzFLrxjIbqZk8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943066; c=relaxed/simple;
	bh=Itf2s7/5daKDDoQvrsBicGj3xQ2ndOFq9h8x+y9nuo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SlH6qkl6oyUfmOYhCNhak8KkI53s1JdLnydCdvKQAzY3YIXGFjpUOz4SkD19lZqzhOrrUksPwWmfM3d9Qd55WVFqSDeB+HrjqHaekuJNyL7RSjSQVcn9Ns6mh0MB9OMeTfdaBf/j5N/loaCQg278BefW1sRemQordTzLfwJJQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wxsiA2Nd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wxsiA2Nd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZnO4G8kTifK4GtTW1Guo0HlipTZ6zC0LVMNy8kiLwbM=; b=wxsiA2NdaxqA9MrSWWNrEjnTb7
	vb9gq9bcS9e8nI9EATNsF86GjWBqHwX+w6Yqes+PdmaPl8DxyJqBht4E0obJ+TgH9FdTcIVZlpE/J
	LqrwIsgUwGNVphpNe9dUe5LyqrYlPoj8T85eOfytJEOMbHnwDVt0h/7h0pCJEEPvpJgP3gRTSkPm5
	tWPUlA8QTNbE7oATyOI/Xx1EgHuhVU3ZdkkCycDd3cAtW7sTbhfZ7ax9P25FwZ8Z2OgkyT02tsl9g
	KOTtApUxIKsWnTuZsGZvvWpGKOhqDdCfrxixBkp3mNXxuRIVJ9oGVpucryILRRwT1Wl4zuy2ioz8p
	yT0NAOwQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9IP-00000004KU4-0MlV;
	Mon, 15 Sep 2025 13:31:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup error tags
Date: Mon, 15 Sep 2025 06:30:36 -0700
Message-ID: <20250915133104.161037-1-hch@lst.de>
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

Diffstat:
 libxfs/xfs_ag_resv.c    |    7 -
 libxfs/xfs_alloc.c      |    5 -
 libxfs/xfs_attr_leaf.c  |    2 
 libxfs/xfs_bmap.c       |   17 +--
 libxfs/xfs_btree.c      |    2 
 libxfs/xfs_da_btree.c   |    2 
 libxfs/xfs_dir2.c       |    2 
 libxfs/xfs_errortag.h   |   94 ++++++++++----------
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
 26 files changed, 153 insertions(+), 321 deletions(-)

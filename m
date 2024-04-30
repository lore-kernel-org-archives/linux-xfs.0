Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617DA171669
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481907; cv=none; b=lmGOAdleTrnWMbL+bAfpohhmLpzs2Px6hr+BY1y34NYL5uP/4xPubdroJoswV29qMFiSbHcwVGSK4AC983ppPMkHKctD0+uTGDiP2diFw7AKPuqY201UsbjhbE0szaL5PlfkXzHVxzQS01boHEMIoatkmRye9ZhkSJys4bj7yQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481907; c=relaxed/simple;
	bh=mr64wlDYOTeAOuPdAi9/dDbzQWmM0/FKibyVzP9vYMU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RngObCb/cOjtWNYDuZJtT9tn+OfTi3vsFeK7K7x+WWgzOnzyt2Q5qm2X8ZzJiI1F9GzoOd8n1wjjhkOeTkw6o/NluyZHMF7Fo7BZGV4C7BMU0pzYXwawItqAxFcgaCLpGv8F6y93wdbhW3j05alf+nMSTvG7/9Bu22TW4It6ReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qAwyVX7F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qAwyVX7F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xj6PaW5cG7QKjwXDq4IBGS+MiOZb7mOtYWnENc/K1p0=; b=qAwyVX7FHmGIgUcgEgCltEOsX9
	VNTkSxOpJnUQcdsGGaG6VXcOm+YvMec/3bWPMBSoQTR5vuKNnBFMh5Tqu/ij2nVUY11tzU6gVtmx/
	QYXPNcnq/1jb8aGRoNbZvYYmeZ08HoBvGUbK1KJYOezGiwSTCithB3ROzBB3TvCtTVw3+rCDod/GG
	y7Iu0VG0hAXSllRzKKECFBeSrGTnYaR+s3zoEDTBQquu2YkEoqLHOGNZJ5SNgeU0VXxkTbOmKvAEP
	+0u4BwlTcuT3ObH8RuwSx9SYMNldW5cULxnALNVm9ZubsOk3q28CH+N6MA7fG1N8RAEtY9DEDDdB9
	UuyaSRMQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n3x-00000006Py2-0Pt2;
	Tue, 30 Apr 2024 12:58:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: quota (un)reservation cleanups
Date: Tue, 30 Apr 2024 14:58:20 +0200
Message-Id: <20240430125822.1776274-1-hch@lst.de>
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

this little series cleans up our quota (un)reservation interfaces a
little.  It has been split from a larger series that needs more work.

Diffstat:
 libxfs/xfs_bmap.c |   16 +++++-----------
 libxfs/xfs_bmap.h |    2 +-
 xfs_aops.c        |    6 +-----
 xfs_bmap_util.c   |    9 +++------
 xfs_bmap_util.h   |    2 +-
 xfs_iomap.c       |    4 ++--
 xfs_quota.h       |   23 +++++++++--------------
 xfs_reflink.c     |   11 +++--------
 8 files changed, 25 insertions(+), 48 deletions(-)

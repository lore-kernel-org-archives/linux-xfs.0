Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEC2413247;
	Thu, 30 Apr 2026 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555238; cv=none; b=GQVr595XJCbIkOw/rjKR+zAdCRed4vnyKf1iepVdpnvpOJ9tKvGBOkTlWfuT/E0yGZr/gR4dCThhk4p50efsN0HM0d9ncuOJJA/FG5lDs5awAsFFdD+1mgDZ4Zvpru1RETsg7viKMR1HM0ue1rWUBIw6sRMrQKZIu9LcwOHLBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555238; c=relaxed/simple;
	bh=v+OXPFuWZFqIaEx8Lgud2WVESG6xqMUnRMotVAMhZQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHnYDxjZGQce/UXosc30023W2LBE4l5q6frO0zB5ome39Y08Lq5eRXKcgHfn+m6rYyaiiSqUrCXkorCktAGLCdB2UVVaMcMyLMc5Y8rLRQlmJoFrFkRiUYo756a/FyY3FvaU/k4c8DexNUup+aXnmUi8ONoLQybeyTJej45notg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gdjFW56v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gdjFW56v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=crEKbGfWlMcgjccq6HSM1U0NNPpQNkRsS/+nTe2hEGQ=; b=gdjFW56vy2Yya/oNeAeYop5L6T
	rUKEnbUEEBsrQnzHobliEhIE59Fj+smR/F9j+CF2rH3u9wWIKAwYzKqqHLl+zHQLvUCA9nhrLlYzh
	wb803qAhKAYvecTSMuSc2KS/+37VZOibjNxXoof73sI3s1t7fgSZnBeftX6UpKlB/zatOIPhN/ZVj
	UL/ZTFmmGOWx4J48GxOobp7a5/xPgF6vxL22wWozRjoCsL8dtL2JQXcgFDYIhJ1RMHuq9IPCMNp0w
	QBqFfFZO9yu/ILSkHPUTaeqlGrv9RWHJdSgS4XcL8hyiEue8fyf5VxeQm7zMhz01o6gAIaimZw+LO
	nPLeFGxw==;
Received: from [2001:4bb8:2d1:b956:8772:dd9e:18ae:7a3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIRJY-00000005Wv4-1rUp;
	Thu, 30 Apr 2026 13:20:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: fix block layer bounce buffering for block size > PAGE_SIZE
Date: Thu, 30 Apr 2026 15:20:03 +0200
Message-ID: <20260430132019.312405-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has two fixes that make the new block layer bounce
buffering code work for the block size > PAGE_SIZE case.

Diffstat:
 block/bio.c          |   27 +++++++++++++++------------
 fs/iomap/direct-io.c |    2 +-
 include/linux/bio.h  |    3 ++-
 3 files changed, 18 insertions(+), 14 deletions(-)

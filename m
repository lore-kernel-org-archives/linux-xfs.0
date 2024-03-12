Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148B97AE72;
	Tue, 12 Mar 2024 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254909; cv=none; b=GO25DOfoneFlPpHtggMMW6t1kZlRIAx0FQQIwqyMGL+w0rKp3K1ooH4MUUSHQzj9ZzbmTN5Zqdh95RCiUxpG8/WNNR26B9lDQ3NgsAg0yynF2EBiJIvDKPqWT6SzyWoCqVH4+eMaNADlACv3dzRzqWabVkpOMqVvGW01tvIFdYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254909; c=relaxed/simple;
	bh=7w3XeBJMmAtE65uQl32FUcatV/W5i4cp2Ud3Ixk3lhA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NvqMzajU4B2fww+KQPlVwZNl48KB34EPW0lv/1vT4WPxQH0eQAYZdGMRZc1Pln1snWz9CwmVAUbEKMZjJmvj6PBGnPkGkL+7Py+447d8O6toCz47AIgmwlz3UpkFtllXZX/gvRdmqV2D/flFCRQLLPO8uDu/wd5m0xlsG7xpdbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d/miBaPZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d/miBaPZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pn7Anh9njmnmAu3L5gNvV/rJYKFjcYmEsb1l8Are5AM=; b=d/miBaPZhadtVwJsjoqOML0mBL
	qCtO46aMlr6PrABMvl+1v/hsGUgCIxQInFRR4dQrvbSweY/7TlZ8ZK56H8tFhyPpo/qx3a+5RvmKo
	D+z9nLpbw+PUxSB3081x4919oOnu6p/2DcweIAubyr5HAwo6J6R0EAzHDuqtg/VfYs1JeRkLtVd+6
	iG3ZeMOCxZYAruRHOZPHHQKF5l8RzInZMoaP+Rw+WqJUkoWH3WuyMOKUNUQnK7m3PPiDX3y3Facpn
	O4GyicPJO3epY5m8PhOdWCeqFrYXcy2ohz07H/MAWyV8CZ4MY9ChmJ21DrnfsBz1J6YkU6fiNRb7a
	wsy8+9Zg==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3QZ-00000006D6R-1cGg;
	Tue, 12 Mar 2024 14:48:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: RFCv2: fix fatal signal handling in __blkdev_issue_discard
Date: Tue, 12 Mar 2024 08:48:21 -0600
Message-Id: <20240312144826.1045212-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[sorry for the resend, the hotel wifi just broke down]

Hi all,

this tries to address the block for-next oops Chandan reported on XFS.
I can't actually reproduce it unfortunately, but this series should
sort it out by movign the fatal_signal_pending check out of all but
the ioctl path.  The write_zeroes and secure_erase path will need
similar treatment eventually.

Tested with blktests and the xfstests discard group for xfs only.

Changes since v1:
 - open code the fatal signal logic in the ioctl handler
 - better bio-level helpers
 - drop the file system cleanups for now

Diffstat:
 block/bio.c         |   48 +++++++++++++++++++++++----
 block/blk-lib.c     |   90 +++++++++++++++-------------------------------------
 block/blk.h         |    1 
 block/ioctl.c       |   35 +++++++++++++++++---
 include/linux/bio.h |    4 ++
 5 files changed, 102 insertions(+), 76 deletions(-)

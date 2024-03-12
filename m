Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926647BAEB;
	Tue, 12 Mar 2024 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254743; cv=none; b=h/YKfHVKHUdqalfI7dR69llSWS5dbrTilZXoE61xGE6o+JfWwHGpRTZtg6qMvZP/BB6B2BsEcnVlWzeIqEN5jAO5Q/KTS3N8po3wcwFebq6f1eqXwTMf8PygxnFI1WPr/gx4A+UuWXcUtBUzzKGWzxqbIETdqiK0cj0ClMg+4RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254743; c=relaxed/simple;
	bh=LFe2ZHxELIz8umxQX+9UZTNe8/lqs3Y0aWvtd1DqGDA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RpmCGlsgErX1jqiBavAYAdRhTwwMesvyggz5+7xYZV0clbzmxXuMvksUhPdRzkB+dHHS2vAcSSw77Q0kL8Q/HqNEXcLcDSiRu396Q4zXkb5b2MzA7PFg2wHjnDBfB+XlFMFX6WNeDHU5TyL9GA7KvbJB5nPwGFaeteTTl0xaazc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jIvrCuKd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jIvrCuKd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dVupA3BPIwip8256Nu1sv4B40R2NvuXz2V9DyL9nojE=; b=jIvrCuKdtZwHlw6es8YSi0QJB3
	bViU0wmKcD0ajcDMAkKmGLcODW/Yvwmelnv3dX9KC0pG7a92Qz4cJ2j/K9Hjo1iToH3Jfex1V0h9V
	bz85Qce6zCymYfTGDVpzzHXRWXANoXt7WwRFzOLl7pEYqWXAzzEEw3vgNHCfxIfO6tfH+CQGLFGN8
	TCQ6W8w4kbrL4T7iPu3hGy94aTA3kfx+91JKcCgQafXz2DdYO2IZrQNWyVL7iYJKNJqTp5o2QgeHm
	wLGOB2ofVC7Ynq8U5Ea8b7+Hty3DvtxQ/k/AQtnixWOi6hGk2fVGhdzMJG521TVYSPANfzriSbm7r
	jivM0mQQ==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Nr-00000006C6J-3a9y;
	Tue, 12 Mar 2024 14:45:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: RFCv2: fix fatal signal handling in __blkdev_issue_discard
Date: Tue, 12 Mar 2024 08:45:26 -0600
Message-Id: <20240312144532.1044427-1-hch@lst.de>
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

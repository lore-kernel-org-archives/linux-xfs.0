Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0461B78F3;
	Thu,  7 May 2026 05:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130125; cv=none; b=kL3lzdje3CJJZv0q0oy/fE7u680SfcggH4n98RIFMODVmDmSFfPTsr6tGzRgjVLZqC+XR+oIzu0jScBLgA2KiPXRjvkFEH9+1njbUJFJvuSbOZh5fcGqWlz+JWKIbskDnTGiE+d5OHXTTUAIsX0fYk4RiZypCzk+Etb8cWVj5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130125; c=relaxed/simple;
	bh=yxroJRjEGUbyRj5kI6X/DS8yQTTEQHsAthXLoWFrpug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m3rlDzkW+BJdGZrIihzxvswESVBlAc9brgTsJtwuu3nPF9Q+UHAmyQ4CpcVzpK1SX8NsHKXnYSE5ht+/R+0uedhZ3w5x2T+8C1rNJBRHJ9GYfmjMkbwDslYxPlc535InjFe4e1H2QW84u7VBXVJQXxleTy5ekwnFmHkqsy7z4cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nRauK8iA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nRauK8iA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CKFAjES2gFiXuKnMxHCHtVrZ0QNMmLLhxSZDfzYnhko=; b=nRauK8iAwUlrJyE5zK65kFWuUx
	StKrPXXvPesiloHhpI/99MprzszQGcr+ZffwKUFNnkhtMjgoDnvi/3HEubc1xHTulBh2Ikrm06aDY
	5p/K5J7F3N77WX3nYBiSJDUE/uKb8zzKQcx0S2sHWDo9mVDYgtH7PACUnLQO8BqGID2BCdDXotVd1
	Qg2/EyIyAd0dgZ0znT/Sy4YBhxLSeVABsD0nsEGMrBMAyNnQbbAct/aqVl9iJWPimXWTnwDA0QYXx
	tm6FFeqr/tYiZFpHUI3iG65JkVmerLJxJFpjAWc5ahcnPxfEkP1R205BoMAG+/OUCpEm0apbDrbz+
	K4lIGSEw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKqs3-00000002lxa-03e3;
	Thu, 07 May 2026 05:01:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: fix block layer bounce buffering for block size > PAGE_SIZE v2
Date: Thu,  7 May 2026 07:01:46 +0200
Message-ID: <20260507050153.1298375-1-hch@lst.de>
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

Changes since v1:
 - update a commit log to better describe the applicability

Diffstat:
 block/bio.c          |   27 +++++++++++++++------------
 fs/iomap/direct-io.c |    2 +-
 include/linux/bio.h  |    3 ++-
 3 files changed, 18 insertions(+), 14 deletions(-)

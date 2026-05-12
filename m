Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF2A3DDDAF;
	Tue, 12 May 2026 05:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778564235; cv=none; b=W7SEG8q7chrR4Bap7JPZNVwy89DS4mFGCQ5lo8fVNrArywKQAN/W0E7C6caLXw1HZFNsP0aJrQcGs5t0SkfxDt6yB+CvdaWp+f8fuYd3YyFS49+dnh4dRV0clkrIgO8kOp0GoWwsa2JwfOlYibmG6azEQZjEI4v9uHO+86hGm04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778564235; c=relaxed/simple;
	bh=xYUiiRFWAaMTSmHD4RAMcNnvT/8RdO/a36JJ4ivIESA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kczW+zHqY84+mQh3MOJgiADXp5GNRJBYMLYL5cd69G+Ncq8t8u/SwzVTgi+K63BYBjwPo7HjMFLuaSAB9+VP0QmVRMRqhFv7bdaFO9qMr+GTZJWvgAoxPzFK/xFWmu7jvsBed/h0Gmyc1flXcFtCpjwtyuts/yuhdWlakT9ey1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BKwVZyZB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BKwVZyZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Hw3XcDONqEpFVCAFM8gW1FdoetT8Zbq83oYUzuqJBc=; b=BKwVZyZBxahKZ8ZxCxPC6Y4z5Q
	pBiOEEqDkyx5ololy28vqASvBt4xi35sl0+NmWmVYePnVyQ72qbz3HwzDQq1AstWN25FRYsfZL4yD
	FMnezLkwXChwq9Lg8k2aBxxz9HNfyNtpVLv573yOfNZ/eB9CP1TIUvRVru5ciaKPe/f5DKPzFioOz
	mzDZhG9FVUkbzWZmxaJ/X4fLnz21zuNa5oGBY8gNbRmsAdW1dnnzK8h5NAlfUrt/sUDd5CmL8jRAu
	TerYktd4rvWR4hE8yA7w0bS2Amo/cU73MVg4bamNvnyv7oYMkUbHbvGSTZLjuwoBI1GwKcFyb0J6K
	aW1iSWxQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnj-0000000FfJy-2bJw;
	Tue, 12 May 2026 05:37:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 04/12] swap: restrict to regular files or block devices
Date: Tue, 12 May 2026 07:35:20 +0200
Message-ID: <20260512053625.2950900-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Various swap code assumes it runs either on a block device or on a
regular file.  Make this restriction explicit using checks right
after opening the file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a183c9c95695..651c1b59ff9f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3515,6 +3515,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = -ENOENT;
 		goto bad_swap_unlock_inode;
 	}
+	if (!S_ISBLK(inode->i_mode) && !S_ISREG(inode->i_mode)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 	if (IS_SWAPFILE(inode)) {
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
-- 
2.53.0


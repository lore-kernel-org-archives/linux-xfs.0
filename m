Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F66364E8B;
	Thu,  9 Apr 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750583; cv=none; b=H3piPLnh+tsqnMOsA72Y6YGxJhwTeoUU4rk4U0dXR2YOaQg+iyrNW/97OdQPml34VW8NWUlPH39NKcFqXn8j9yRTJxWWiSRTAFlwYp2XdYTzDHrg5409n0gBkN70o6SRkwIZ/iMvT1UnQwUt1eOCN81cb/uepw9Q7dUNk52VX7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750583; c=relaxed/simple;
	bh=H7wxKxyzsR7uIE5I7wtMB9FI5rg6pnFWdwRJjLi61YE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bPIhloDJkyHQhhh+ZsZTXrQZI8nVhpIqvz6R6AGOZmsMQrIzJ0nVqdWp7R0oz7Pzh4gdzBHjREMdZmtPbikSyp9N7KfDzVRDHhUHFuZurkP/rHymkYDio4ht2o4LxUxK9XxGOirb6VH4lOg6QJVJ99kk7RnYbFG1R4L4AI1kS7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h1GNWoD0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h1GNWoD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SxYUlZLj1gmpCo8eCeKIGiFpev17tNAzKybkLp/40nI=; b=h1GNWoD01ZSYa/9RK53eKMGQb1
	pR3bWB8r+lqXQGNAfbDaoppHO9yJzu6TVAz1FBtkAuv2UJXybU3NPyHtXfnnldQdTCk2Lem1xXdCD
	NtgsXzOkwgjvGy5+pgs/+7NVU8mSGDWkfKsloQY00RzyNk6q/fLDR6L0frIclJE016YKFf4jtwmwC
	pKn0xWdrvZi/5zG4ZL2hRPaoq/MwDZ2no6r+pRr8vGp9n60IRZXUUkN2LSI90ezMaS5sAJteTs2XV
	PGB991wT4VMT4up40SyJD74ssZchAv0VmSSmrK5nt+iqGBXIv/I/aoVN+APRoQgFDKIvoFVagV4LZ
	6nh+Keqw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqF-0000000At1t-0EJp;
	Thu, 09 Apr 2026 16:02:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: bio completion in task enhancements / experiments
Date: Thu,  9 Apr 2026 18:02:13 +0200
Message-ID: <20260409160243.1008358-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series builds on top of:

Subject: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices

which I fixed up to apply to linux-next.  If you want to seriously review
or test this, you're best off using the git branch here:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/bio-task-completion

it first makes the complete in task interface more flexible so that it
can also be used from inside the ->bi_end_io handlers, which we'll need
for a few uses cases.  The second patch fixes the offload condition, the
next two then convert to uses in iomap added in the current merge window 
over to the interface.

The last patch plays with the implementation and reuses concepts from 
erofs to reduce the completion latency at the expense of more always
alive threads.

There's a few other places that could benefit from this, like erofs
decompression, PI verification in the block and file systems paths, or
fscrypt decryption.

Diffstat:
 block/bio.c                 |   93 ++++++++++++++++++++++++++++++++++++++++++++
 block/fops.c                |    5 +-
 fs/buffer.c                 |   25 ++++++++++-
 fs/iomap/bio.c              |   44 --------------------
 fs/iomap/ioend.c            |   53 +++----------------------
 fs/xfs/xfs_aops.c           |    4 -
 include/linux/bio.h         |   28 +++++++++++++
 include/linux/blk_types.h   |    6 ++
 include/linux/buffer_head.h |    5 ++
 9 files changed, 165 insertions(+), 98 deletions(-)

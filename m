Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB622B9BF
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470864; cv=none; b=fofjFJskRqe0jSAMIht3/zYYiLUc2XPbg7CUffHBaYEP24fTLtpnaQShF4/Lkjgs1DZGn8JMttUk2qURjpsYEjSgLoaTSCyDLS8khF4hIijFX2jXmdkfSKqU2KpbMrKIPMRUNe8nr395/H1yMvhepsjRVqjUEZNo5TtV4YZVnXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470864; c=relaxed/simple;
	bh=WosfwFLlkqKyC+7HPb4hD9wkENcHuPS8BmjzyQzNqC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VN8y9F+2OWUeK1RBsuJFr8mT3fDJNE095qf8BCopGJPn6k2QnZ2oFDLgJzMXdjhmOyUnRL9tQC7qsn48B4flnB7smKyLGtN5PgmXoAhMYKWhwBtYqOMgmd88NQi+fx2+XLsyRvjcTjQvil6WmnuIIR/W9Kr/NTutNlhpLN83EVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hsODvU+D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hsODvU+D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gj8XlF/AL24ZQZtaxBbFy05erHafH/K381hr35q78oo=; b=hsODvU+DfT/c1oF2RgSGmQlwxK
	97YHArLUS8sQusJ4k17Z7r0MulrqXF3P4VKyyC2IkpuRAkZr+mfobKo7iVn0yYYujj11EHV/wJM+e
	K9AUQeDDwozZRWYkz/N51J7SV3zx81/70PFPtPLiFeRv7r8QUyLpFcz5ri3UoqtFhhlUEt7TsNqbY
	N4EBh+/I/JpazVDNFCew8DS0WonarW3lyV/O50LWHKeb4AmQ6pc585jGTDL7jgEfmhNpH5TebUgoo
	a8RrlkU5UUp6OH1QWEdz2eKR3VqAlwBq7zCTmanckj3bAeXDvOeCVbLDSjzCKZ6Og4JJpgCdIn5RY
	ad8xXjaQ==;
Received: from 2a02-8389-2341-5b80-7457-864c-9b77-b751.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7457:864c:9b77:b751] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shheA-00000001MPO-15wp;
	Sat, 24 Aug 2024 03:41:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a DEBUG-only assert failure in xfs/538 v2
Date: Sat, 24 Aug 2024 05:40:06 +0200
Message-ID: <20240824034100.1163020-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when testing with very small rtgroups I've seen relatively frequent
failures in xfs/538 where an assert about the da block type triggers
that should be entirely impossible to trigger by the expected code
flow.

It turns out for this two things had to come together:  a bug in the
attr code to uses ENOSPC to signal a condition that is not related
to run out free blocks, but which can also be triggered when we
actually run out of free blocks, and a debug in the DEBUG only
xfs_bmap_exact_minlen_extent_alloc allocator trigger only by the
specific error injection used in this and a few other tests.

This series tries to fix both issues and clean up the surrounding
code a bit to make it more obvious.

Changes since v1:
 - fix build for !DEBUG builds
 - improve a comment
 - fix a comment typo

Diffstat;
 xfs_attr.c      |  178 ++++++++++++++++++++++----------------------------------
 xfs_attr_leaf.c |   40 ++++++------
 xfs_attr_leaf.h |    2 
 xfs_bmap.c      |  134 +++++++++++++-----------------------------
 xfs_da_btree.c  |    5 -
 5 files changed, 143 insertions(+), 216 deletions(-)

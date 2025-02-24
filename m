Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F018BC36
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409908; cv=none; b=T7st08Dbqva3EI5jV0mcVoAgNej2uXekguOw95Xh5VOorXXxvtoLtC0sURWJOenJRGg34/320O4baH5ejG147ue1ha2nhBVn3hDy+nkEl9TQl9029QsKhrtE5nOl9lL1lY3FOfqqFNA+sgqka3tvs1o9zNtqaiy2QuxKq7m0j6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409908; c=relaxed/simple;
	bh=zFwM3LHW2RSUgL9d76I0AOQONskat8pZyFEYBTxUnBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fZWChPCRAc3v7Zd9qFENciXPnNezEkRVJ5ji+c4hUI6uWSRr582KXpYdiBdyBtewRYIxhEL7A/0GeoYVt93R6cxTGiyJmWkFhbopMTvl+hnTl411WO5uj5PukD/+ytqe1RvSr/Fnj/w+DUzbCWYMrlupe2gGRXArS+k6uAHJrcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fY6buU8b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fY6buU8b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rmUauIIAR8V9NC9ZsM4fxL4bHhkpcW3ro06fkxt0XFc=; b=fY6buU8bNK7GHY708sjtNadgQN
	jQsfx1oS7t14CFtVMQzwTcpKd/p3iDRdmmNsafFvfbZ9TA/V2ZjXRJalZWL1JzpclFJiW6LGtN30P
	PHT2WqbzSat6u6o3MWhSlIsg91mvlqLY48MPilZdFDP+qlhGNSk7z3CIoAtQCt/ax+9jkv0px/txG
	zDsge1YYt1zQGfK1LIOIvZe4TftSacTUgAtC+2fMlO/fSAFAMJVavWpMQoV31H85TOhGHG4kxgEKC
	FhceRrLA9z7hX6l8/GeYiqJThCfadXH9iNZwvDDPb985wQXId5OgCCl3+2FJc35FEkT5IvFZ3k1DO
	4Fboa9ZQ==;
Received: from syn-035-131-028-085.biz.spectrum.com ([35.131.28.85] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tma7W-0000000EEfj-0xf1;
	Mon, 24 Feb 2025 15:11:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplifications v2
Date: Mon, 24 Feb 2025 07:11:34 -0800
Message-ID: <20250224151144.342859-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reduces some superlfous work done in the buffer cache.  Most
notable an extra workqueue context switch for synchronous I/O, and
tracking of in-flight I/O for buffers where that is not needed.

Changes since v1:
 - add a comment explaining the __xfs_buf_ioend return value
 - fix a function name reference in a commit message

Diffstat:
 xfs_buf.c         |  182 ++++++++++++++++++------------------------------------
 xfs_buf.h         |    7 --
 xfs_buf_mem.c     |    2 
 xfs_log_recover.c |    2 
 xfs_mount.c       |    7 --
 xfs_rtalloc.c     |    2 
 xfs_trace.h       |    1 
 7 files changed, 71 insertions(+), 132 deletions(-)

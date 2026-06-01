Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B83783AE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317858; cv=none; b=nHutx536XJxp2qqfFrq9rPz/IQ/CdeeLzLbIKygEuf/0Buluqi6349/r0iLpi/MUfX0wUawWKGIYRicy2G+9PvIJ9pHBpx8a3GGJrQYCxkdrC8gT0S1IkijxbgUcwukldZXA+wAEsrQ7hrYQpKYAgDcuRLhd3AF75tKBSsdjViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317858; c=relaxed/simple;
	bh=r0FVIN/7gJT0SEt4ZMwZdSd24Dz4vDfVylozcV5q1Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GM42a8fSteNbcAWQXZLDSFgOFrry4nFMjrFIU03mSUKzm0mbRh3z9YgQM5pgsSB/vgGgboIDxY6ScRFxbQLkF3zpdKi3Dy7QybDpJfnNrs+3rlNYKHek7uVwxBSqMycpLXUJv0D8ofW5NQHsLKC+jacyBc0rqz+Lp1EA3JAX0Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pLZ0xbJa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pLZ0xbJa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=o901ntZx1V+4HtKfn0DHRmCUsJ8UySfgD2ZZSTCIr8M=; b=pLZ0xbJaI0Tu60+nLJmR0X+P1Y
	J7Q4aOv7u+Ir2WV1pqhkBlSnGO5ebSBM0LdcbvlPEbr7x1exi5O5GKCkag17t3QfVeN9QuYHim1Dm
	yconutoQPRpuTIwWc0vguOkJMSNVrh0dm8aQJOk/6mjKvUkw9HzGqaPXxi4xAwSU87ar3At52qRom
	4GYMv37hRVRQkoDyvxe8iPFlie5+zyfRbKYkre59I5g9afvAKb0S5fD5+5bVbrIOoecTp5AV7Mk2C
	mHstd2+HpN0MR0fQVPS6OstHztCzlE3UHdObi6HXQBMd9j8ybzy5FbJIfITXbrp0rzhxd5/vOHrBn
	6qQ0IgSQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU206-0000000BA0x-0yAd;
	Mon, 01 Jun 2026 12:44:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: shrink struct xfs_imap
Date: Mon,  1 Jun 2026 14:43:46 +0200
Message-ID: <20260601124410.3508980-1-hch@lst.de>
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

struct xfs_imap is embedded into struct xfs_inode and takes up
considerable space.  This series applies some relatively easy shrinkage
to it.  It it based on top of the "remove struct xfs_inode.i_ino" series.

A git tree is also available:

    git://git.infradead.org/users/hch/xfs.git xfs-shrink-imap

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-shrink-imap

Diffstat:
 libxfs/xfs_ialloc.c    |   88 ++++++++++++++++++++-----------------------------
 libxfs/xfs_inode_buf.c |   20 +++++------
 libxfs/xfs_inode_buf.h |   13 +++----
 scrub/ialloc.c         |   11 +++---
 scrub/ialloc_repair.c  |    7 +--
 scrub/inode_repair.c   |   12 ++++--
 scrub/trace.h          |   12 +++---
 xfs_icache.c           |    2 -
 xfs_inode_item.c       |   20 +++++++----
 xfs_itable.c           |    2 -
 xfs_iunlink_item.c     |    2 -
 11 files changed, 90 insertions(+), 99 deletions(-)

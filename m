Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8A38237B
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991581; cv=none; b=uGIkvyDwvFu2341cIou/nh4hvttQHyV5Ywi8tu9ZeGFqcvZnnyoW8+fzKRaq6iK8Yxd4pXKv+i6RcJlUJK6VF0HMCtmiGNnYeGjHY3Xhu9xMRPPD7SUORieG0CC3rZfPa7S577nLFf6qbjByZYIx5AjlsMAZF54gMp9OxmNPlLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991581; c=relaxed/simple;
	bh=Ccndm+raF793HaJrhHF1hVvPmNaGlcH65JGsd4sKwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H2ttr9qxqm9dqOCWjZ03C57kwekLlZPbwhsrxxrSfwoPZD9lft28rped/UmoPFFc+CRv4x37llBehL6qj1+eyzKBHl2+hgbeQLgMa4g6M2U1HtrpCOx3ELqfkSt1z0OXBjSWiyW+1dl0GlPQ41QYwNncYjWYZkAJfHzhGcLZRP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DGCvQ9ae; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DGCvQ9ae"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=n9QN8CEBiu88eSqFnmVxQb0fOA5R9+qyTNBcdPtFpVE=; b=DGCvQ9aeNNW9bzC5YVQuKnMaom
	Hz2PaxVuKnFR+wVyGOqUy/6glQkwcZ2AnZP9oQ87fDzrjs8Uhc4RrpcqUzLPRdUwGGr8RwwKHucAl
	tVwOC+Uk1rf8ucEWiJIc0dSTmkeaQ0srVovvGZG5OloGLC0cu8XdiVQwHKG7c0GqRLIfxe9oBaNTN
	vz9K/g/QI02Up+TSxDpc++6/6xqZ9WUqdFOX4+d6qrZ/yeEUJaXI9zwXECJXrF15ffeeKDhp9lxY5
	t/l2QNkxnpqi8O07W/g6uwsyG7rGr5WpOd6U4jYgafpWliy6jIhUJ1LFxxL5B1uMeu4BJvWh2KcAy
	2B16KU3A==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrGc-00000004zcb-16r3;
	Tue, 09 Jun 2026 07:52:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix dblocks adjustment in growfs v3
Date: Tue,  9 Jun 2026 09:52:43 +0200
Message-ID: <20260609075254.1698464-1-hch@lst.de>
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

the first patch fixes a possible incorrect sb_dblocks when growfs gits
the maximum agcount or a too small AG.  The second then cleans up the
surrounding code to be better readable.

Btw, is there any reason to have this code in xfs_ag.c?  It is only used
by growfs and not at all in userspace, so having it in xfs_fsops.c would
seem more natural.

Changes since v2:
 - another too large overflow fix
 - spelling fixes

Changes since v1:
 - clarify what we wrong in the commit log for patch 1
 - use a 64-bit agno variable in patch 2 to deal with 32-bit overflows

Diffstat:
 libxfs/xfs_ag.c |   44 +++++++++++++++++++++-----------------------
 libxfs/xfs_ag.h |    5 ++---
 xfs_fsops.c     |    4 +++-
 3 files changed, 26 insertions(+), 27 deletions(-)

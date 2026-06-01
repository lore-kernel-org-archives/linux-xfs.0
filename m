Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12654346E6C
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 11:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780312118; cv=none; b=m5pGrNYtR1E7YgyLZcfGGzxiliK9nNSq97O7QJEejC568eJbj1Wij4a5wR80bOdzT8N8yft0/lGrdOMp1mNR9FqrP7LyuAYO6g7Q/QjgA/PDGv4BZ3b/gJ6VVe+KKvKFG1N/xUhNYYdg1sIszYWZuzSSpZJa5UkXUykL5UCZQ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780312118; c=relaxed/simple;
	bh=Am16o9hbwkpZExNoMtENpRE3BdGigkKrVKJ86nD0XHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bhepZg5lvRcnDrk7HE+6oozj1QEqwGX54VUgagzM3lwrrH+INZUyJ2Uy5EPqg2COq/CdQbtJfirqTwY0qNKKzKS5XQQHDadBCSdg+dNBHATcholqZvQhm+amx4Bdpil273Xfz2xKGZt/oHNSNiCTP36bylm5mK6cImX2+MPSyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R87m6kXJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R87m6kXJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VMuypyjFcnnQzw1vGQQTIXX4tXpfW4hgOh+W9MshMbI=; b=R87m6kXJJ1yGnstU7PIspunoVS
	ZsXIBj8q0B/tWAdc6iWW/hgF41ye6ZphJTu9o39nMJfhsRTG8SK4jDt7UXWQj9GKutMNyrV46P3jM
	B+sDnq5EG1LnEUqidyuYDekKk29TMtL7fjkyM+Jxe0LeziWJKbEJJR1FUViAOTUzNxJuMazp/N/Bo
	+ruH/NcuCv4hhy3Eqax2dQlAeWXEjo5c54qWUt1JmyRrYj1WwLpUucG0xwK203ibDEkf9aOX4hJcm
	UdR1rGnp0hqRBgxGYDe/L0CaNgfnU9FzsiqLkSSn0iBUgw8iGJ36LrHisp8OVNjYoxHDKg9/DK1ER
	e7nXzx7w==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0VR-0000000AhsI-2N4V;
	Mon, 01 Jun 2026 11:08:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: fix dblocks adjustment in growfs
Date: Mon,  1 Jun 2026 13:07:51 +0200
Message-ID: <20260601110824.3392683-1-hch@lst.de>
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

Diffstat:
 libxfs/xfs_ag.c |   44 +++++++++++++++++++++-----------------------
 libxfs/xfs_ag.h |    5 ++---
 xfs_fsops.c     |    4 +++-
 3 files changed, 26 insertions(+), 27 deletions(-)

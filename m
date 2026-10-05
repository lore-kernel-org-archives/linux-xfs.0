Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B800B481234
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205003; cv=none; b=HSo9IkLthKWRERlWXwkJP4RMJs3L+xG3TzlUzJFCaVf6sCTVxxdzB2+5J9gsXbqo+3SXPUeIjNUhIUL2XS1julWui1WRmn8I5VplTU7rbZXbhRgYxa05Gm99NZPsgbdpmVWYqy43TZ8bxtBloGGJ04drz8Iga0GcdZ5rcpblOS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205003; c=relaxed/simple;
	bh=lmpnHfAs6WeCyNmMv254X0OqhhnivSFaW3+Rr6G3Zuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VqqnAvPn4gFnp6W7g/CWniMomUHY7RmLHrHnXHWyUNIZsxU1ixdldeu4GSlhaVzFQmsodUoS/X1JOVq0/292Zzo40cog4pmMicuFoi1uycHUsXR6JUjKBcO05wd/5gAPErBSimM8zPTxBH7AEj15ZdkeQkE7qBpNhQThpmpvVbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YtpeusQG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YtpeusQG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lmpnHfAs6WeCyNmMv254X0OqhhnivSFaW3+Rr6G3Zuo=; b=YtpeusQGGzpTDqUGdvseHr3lm1
	nBTgaM7OL8ILylZzgx8QpooY3OsyFfjAx5ls6bZQud310+64vW+y4TqPd1bK2ZprUv2flSwm0jbWw
	+x/jtj1DwTMecURiN+fWoz9zBijJEq8l8tSakx3NBLSWJ31f3y0YMGrAF8wdsLWGtYgYRSy62dvsI
	YNBn6rsC8DybFN7tGc0ZcUvacMBYaJeu8l1e/v5uq2pp6WmkcF7qiPW028SYbqOFTLebiH49zQl/Q
	1vUVUT5UaaqU5fp4ay8YHMTP/cnkixVzXM9mBqn0OCHxoHKHtAF0mCaQQSTUOjxCI1Htn/1bVg1AM
	dAPNn8Hg==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFE-0000000GR3X-0nDK;
	Mon, 05 Oct 2026 12:56:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: reduce libxfs to kernel differences v2
Date: Mon,  5 Oct 2026 14:56:10 +0200
Message-ID: <20261005125637.1340355-1-hch@lst.de>
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

this series cleans up libxfs to further reduce the difference to
the kernel version, and to reuse xfs_trans.h and the various log item
headers that my kernel series moved to libxfs.

Note that in this series, it uses the Linux 7.2 versions of the kernel
headers as libxfs hasn't been resynced with 7.3 yet.

Changes since v1:
 - really remove the old xfs_trans.h
 - juggle various includes around and remove several that are not needed

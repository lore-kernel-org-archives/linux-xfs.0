Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF2923ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777554; cv=none; b=aQ7M1Yokzt+D1eet8taMUGSeKL84RbPpGbUv3XoHeIQ97kGxsSxSyWIYxli0r0BtEyBGfcXgJvZWKQjJD3BVG4of9V9MFgUGuQswy8Os4SgUGjn8aJjFlYKVR/P31b/0CsFq8hQpEQOpVpQGY7Z0oSpEaBXlt2BUayQNlfOzXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777554; c=relaxed/simple;
	bh=cyHtuDJcuHvRZ0cAG1pxxGk6zSUWkt6qr+XuvLGjzYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tqMaP4M5kBqMdg23C5kCXaPKHMOA9eY9qiRCfRP57DRq2FFDiudWcRovmNX9/NjIih+luzLFxZhDzE9GHvB4/I1g7Hd7kqdTKjLbeFxJZXNYHdf1ids7G0g/8BECIOxhF+yeZTqklBuwMivA+5E2vjSnSkDPlJUNpFILlONp3S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m711dcsr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m711dcsr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JX7fN98RZUQKvZVxKSqy82xM2zPXO+PVrKiBK69Hd48=; b=m711dcsrBBcg0cpJVYyAPzkHug
	eOPWSIyaAAEkNdw/bB1ceqM+1rzdJjE4qotXjRVMd8pUyig2tRSORI6cidveqQWCxZH5kb/ZDpVnF
	Dz3gK5RfgiujY1lXHvBqYiI6p59kwHKOi93z9iuiy1HL2KJuMarwmtrNHopgRqjyQCvwy1PdwK/kd
	PedjAPFr5KfuQQsBg7Mt5MtNaSPWgYV+ekiasDwaFS/llnjm0d1gDZT/6FWw3xEmNKIlhKjnD7RFh
	iblAt+Y9c0kg1jzJFpckphdRRpDyBd2KkGM4jHy9o27Q0+Hqil9xZFydnfMwt+Se+Kc5fNWg6cfAA
	FJe9Z/og==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLB9-00000005MjH-2cx2;
	Mon, 13 Jan 2025 14:12:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: buffer cache cleanups v2
Date: Mon, 13 Jan 2025 15:12:04 +0100
Message-ID: <20250113141228.113714-1-hch@lst.de>
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

over the holidays I dusted off some old buffer cache cleanup as the bio
splitting in the zoned code gave me a better idea how to handle
discontiguous buffer bio submission.  This spiraled a bit into various
additional minor fixes and cleanups.

Changes since v1:
 - make xfs_buf_submit return void
 - improve a comment

Diffstat:
 xfs_buf.c        |  511 +++++++++++++++++++------------------------------------
 xfs_buf.h        |    9 
 xfs_buf_item.h   |    5 
 xfs_dquot.c      |   14 -
 xfs_inode_item.c |   14 -
 xfs_trans_ail.c  |    9 
 xfs_trans_buf.c  |    8 
 7 files changed, 194 insertions(+), 376 deletions(-)

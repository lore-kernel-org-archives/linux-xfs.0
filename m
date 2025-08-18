Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05FA12D1F1
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493641; cv=none; b=d8LPYkT9VULvbqplZXTCQ7gZJWqPiQg0VCJ8JXF/WGP+SFNMR+GSNWQVP2+hEFdk4QEpahYOplFG1wB08emP3O8ZfXNzTQ3CK7QPl9vkKp5PjTcvCPJAWtl80M51/SZ3rCL+qCNUDELwhM2DJJIpSbfg17YwzLpoSoanmHc8M0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493641; c=relaxed/simple;
	bh=qBdRD4rQNde1Q1tR/TTCVxnMMrrSPlBzmH6HYx4gYvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AhNWgxkHLzi8O0nc+yACMUTPn4EhJWywkvOfmGmDO0Bh6N4YJfKg7Y8heLieoy246Smj46mL/vQvGGt01REuwyuxRCKedwgyVY+aAysQ2H4NH8gsT8EeBb+tK5TN/OfQG+WR+EqIdv5vPDyFGkZHHPOOhEriLEIC7xfvXGarL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zggylckS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zggylckS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6qxYTFGtwsXr7mudaOlrvf7A6gnOOJct46q0vh5kaVA=; b=zggylckSr40RY+7bPrmLh9Ep8S
	84k5XfDY9Ty9GhIy4dSNxxg9NRA3Thq5vX4YVTwGVNwqFPjUT/j3ruRK3uDMIE65ID0qunVRJblGp
	/1hB8nKLHMnDKalO0VUM9Q6uGU0z2xbQSW7etqP2K5qT49fEj9mpt4lUEWOpZKezyjH2/kJCJ0Nru
	DBMfAoSDYDnXL/k2U7IEub2lg9mgB1qeuFbINX/vRL9vlQSV4f91Al7pR7ZAyLzb7lTMPVoWNBzvL
	geDMiv3wxf+68V4yVse14qe1aYUX4prxEND8ElsxA5+qeKI7F07nz4UVwOiC5WeRB89I9nNMD0PLs
	Jk0P3Hew==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uns5W-00000006WXl-3g5Z;
	Mon, 18 Aug 2025 05:07:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: zoned allocator fixes
Date: Mon, 18 Aug 2025 07:06:42 +0200
Message-ID: <20250818050716.1485521-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this has fixes for the zoned allocator.  One removes my original version
of the inode zone affinity, which turned to be worse than the more
general version later added by Hans.  The second one ensures we run
inodegc when out of space just like for the normal write path, and the
third one rejects swapon directly instead of going into a rat hole
iterating all extents first.

Diffstat:
 xfs_aops.c            |    3 +++
 xfs_zone_alloc.c      |   45 ++-------------------------------------------
 xfs_zone_space_resv.c |    6 ++++++
 3 files changed, 11 insertions(+), 43 deletions(-)

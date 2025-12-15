Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF1732B98D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 09:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792134; cv=none; b=m42p4Uk5AeMz5k4tJGFKa3R/wlbhL12+ZnjeASCeUxEmCm5Epn2hKic0jXwx2PpHrKTeU/8E1JhIoTZgI64b7KMBqFJgxPTsZLWhC650t1eiDGehpPKDdyZ8UqNnhPwENm7Ya510Bg5rFJGcD09kmTnaekAB6j17R/x6GrIP06A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792134; c=relaxed/simple;
	bh=/yl04L9dZuO8BNcbvTuWc/MTFeUcLisozW+1XCF2R8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yn2/Z0laJMUQoDY0VfJNjYD8QBmdNXtFcHSqrXNRLwss6MVDUEofRdGxuB3TE2NEob7haQARAtUjoacxU34gpU2i53hz5gN/YgkBzos5tvb9TI81AZ5I9dY4hkety9qFrYw4/05azck+uHKXQzfnz+AnPakCSWxl6NOyymz4qhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b/19kh3X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b/19kh3X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gzQCini5jiyhrAZaO8/rMI/T/Ae62i0ChKpGRdIYWqk=; b=b/19kh3XXEpP0TVB7eMTO+p0yY
	Sex5t7XUeIAEQvjax/OUCpaezWJh7Dpoonr7NAUPgIjhKU0AgFtNJ1Fa4PNWVB/m+fVxfpZ3SaJ+C
	WLetZcIZE3HQYm0va72K1+DmffJIWHYtIL8rzMlnzn7W09pc5cPx8UPCIu0S/5qo4ivyCXMYXibEe
	8nBiNuBkgTKUHw3MsQhCVqhsACt5DmBZDOkBhMUgOgistxOj6cm0CKbDGlXYTIHHvNzb0y5ePtYmf
	/En9znFnUXCLNGAm6EjxrnQt9FmOpEA7ePefjEPzRBt9qb3hq4ul7lti6J1jmI/jFKVbLOjPi/fkR
	fpDkAq/w==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5CC-00000003OkX-0El6;
	Mon, 15 Dec 2025 09:48:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: reject non-zone aligned RT subvolumes
Date: Mon, 15 Dec 2025 10:48:35 +0100
Message-ID: <20251215094843.537721-1-hch@lst.de>
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

this rejects not-aligned zoned RT volumes in the SB verifier and in growfs.

Diffstat:
 libxfs/xfs_sb.c |   13 +++++++++++++
 xfs_rtalloc.c   |   14 ++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

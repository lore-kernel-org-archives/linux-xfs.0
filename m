Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594A23A1AC
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244638; cv=none; b=uCCrMM1PhpVvavWRHMEdhsfnRTmDkiVUNLI32III46+Vt2n/lyJe0lDMOF2+0TI/1V1nGYMM2qt6LAANiTZx8tXazKatcgBKlt4jMcxq5s3LNK20w7pnPMDzeX0rNkZGBrLPENdAkKEfFIZCgx9EnnqRoiy7QbPCNtwR5ReRIjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244638; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPKam9Xs1XQ7hpNu3m8nfExSpY3Fzesivk3qNukEtjOS2h9o5hMNrYd+GbGOIMl1n7dD8KspjvkVR1DcsMN+YEi8QRLR0bvy6FHO29IMN4aq8qeydo4n56P7f6Zq9rj14JxdjZEXbmN1gkgUFxSd+8G/ZfYyrpIQ6Ar0eEckS0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HhS0qMjP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HhS0qMjP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HhS0qMjPC6BQzO5B3pS/cX/tF/
	Lew8QhlHzJHTXBX4mqwz4imDyhVyzj2YmyYCQ0gAFeNM9bR8Y5ZRCuVYfmytuR1aPpQuG7NU3lBBs
	Ty7e+0H/DnBWljFsfFUhorm3ljzA84NssE8/G1uW96NBzF2NyREnEdarQZlpxicV0IUFYOo9QhJYA
	nzgGc1k6QPkAWm9M2d8DVgI05qu/utln0ZzCR2k1NML/QZfgIkAgGLLNQWbIQdjB4Xq8ONDrpOyWX
	kHXm35JwyJlUxOYS8weQg86s+HvbY2Ht8iF3QkhY0yPf62hywEYpSBRdnJm0IeI/O1FR0Lhuc87K/
	j2GRZm4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbC0-0000000AvMu-2F3H;
	Tue, 16 Apr 2024 05:17:16 +0000
Date: Mon, 15 Apr 2024 22:17:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 10/31] xfs: record inode generation in xattr update log
 intent items
Message-ID: <Zh4J3N75ZZ6kmqqo@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323027948.251715.16414467417803139677.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323027948.251715.16414467417803139677.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


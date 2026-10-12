Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578CA35676A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811361; cv=none; b=QPZKh9zFqOsLwgwGGCySofOeEU282yyQEyUJV8RTrnF3DoH0ngJ7IMckHmVujQoMkfvweDB8F6KEJHLMev1wkrih+dDAnC/cOKT6MXALfq0Oin3bL5ApRwKihngj3YShktq6aV007vX0CzPUEHHu5pfQvDJmcMXoR/doGjUsR7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811361; c=relaxed/simple;
	bh=AOcSRq/33e9v/9AvWZnH3YQTt5miLtY6iSRsC+HFXH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zk0ZLfVglQM01vKLz5j4YvkA1QxEa9UAcgwv7NdXWnAsgS4t0yS0L++TPHRRM9gGNQM6mso7xc4paOvx4kNRQSaoHNnVmlgU1tSsYQtv9S2yMyFwFMzdCorMY8KPoABYU1/1dCviXOU149/J43Y1s/bhEqKBEOVa4LhszV0M2aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rio+Mmo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rio+Mmo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kh+qPxuh/hqOesQ3KKY5YoqR8jIIzcyxnEjJ0aMk7s0=; b=rio+Mmo6RmVGbZSXTwFi/Vv6mr
	JH2Wxm6Qc02nAuRcHbpuTfcAuIgqJibaja0JDS7Xx8zk80Hm+XHlzB0U3ZJXkHvYr32tNDszqayFC
	FEdMkzzzO9Bn7tg8XMdRjIyO+2CJTXLJaaLlNMEJD8EoxJzTRn5IT8pqQD/LqWuyXCl2pdp5ASFjC
	9wTjBM6M9ITfiJnK/t2oKQf/qDBDq/yHIP51Q5bjsZdbu0hSwK4ti/uXyK21HIssYN79da4Qnoq/k
	uWc+Fsyqfxhc8kKbWHX2/V2PD2nrRHb9OrN1RaNu8/FjpDgeNpBeKRPZth39T2TcgRF+0FnbGnDoh
	KCUJpWSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFzD-0000000AYWQ-0EoC;
	Mon, 12 Oct 2026 13:22:39 +0000
Date: Mon, 12 Oct 2026 06:22:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yun.zhou@windriver.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs: don't hold buffer locks across sync
 transaction commit in xfs_sync_sb_buf
Message-ID: <aszfHy7rfOSYN6Q-@infradead.org>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
 <179158947530.3719791.2785151427381835148.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158947530.3719791.2785151427381835148.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/* Always NULL, do not call xfs_sync_sb_buf! */

... in userspace!

?

> +	struct xfs_buf		*m_sb_bp, *m_rtsb_bp;

Please use separate lines for struct members, just as in the kernel
version.


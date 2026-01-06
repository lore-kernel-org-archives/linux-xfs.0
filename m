Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C373164D8;
	Tue,  6 Jan 2026 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767687058; cv=none; b=NwVa4T5TY7hfPdxPkF/4SpMCAVNzb2w1ekb+rB7j68ntM7Xfpgs/dZ3b/daJ4y6z7ZnUjttrTCDgIgRNd2N4imCSVYN/hJOuw+mevMwCDxK/L+82ZRrep1S/Vo3Tw00bEcWakNWpy+1xYVJkyD8KJhyPRaATf3WHiKRVR3YwMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767687058; c=relaxed/simple;
	bh=f912y653UkY9MSk2l8M9/B3PHKz2ZqRbyzfWie7Z5BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGQAiOcElPPHyIpLhyw+11lqgN0KBlOSR+raKWboa/RkqJ7jWXI+2J2MfrjbVM2GH2vVd6ULiKCaJMlLyXfjifwi46TGvJ+oA6sIkvUit/fkhDncoJB0IlJzD+Vcn1XkkKt+ROonuHmfXonacLDcVkefipPSFDmt0fVqeRGAwls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0G4/ipvm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0G4/ipvm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f912y653UkY9MSk2l8M9/B3PHKz2ZqRbyzfWie7Z5BM=; b=0G4/ipvm3kpXaIWTE7rm2KS3SN
	KJjEnuhHnxqIdGIXIHAfbWl+paiSYlygH1+hA1Uwkdc7OSbwKi4igbVnlBUhtkUVQMME7zFk8yW9l
	lwGKi9D3xpVDkcdenc1wYAeV7Pzt1gzMsQ+zpkCmwPXwk5EutXU0l+S/jQ2NP6KkCIK6OxizVTC3A
	0kiLF333c76Mqs1RSGL8WWWxC9E81D7Q/5W1cgjv8DGY+kAhfpGoYswQHM5oWbD1i+wbttOeae1VU
	WlQG9ReQ/5sznwHKKAMlw/3KbzqcyTU6wWFvlKE5LxgYxQhe6vu+4Nn1jXN7bwCgwOTmq5J9BgqWX
	ZXRWlAcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd29X-0000000Cauc-2qYp;
	Tue, 06 Jan 2026 08:10:55 +0000
Date: Tue, 6 Jan 2026 00:10:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>,
	cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
Message-ID: <aVzDj2OEa_R9bJyW@infradead.org>
References: <695b2495.050a0220.1c9965.0020.GAE@google.com>
 <aVxGFP1GJLPremdy@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVxGFP1GJLPremdy@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 10:15:32AM +1100, Dave Chinner wrote:
> iomap: use mapping_gfp_mask() for iomap_fill_dirty_folios()

This looks good, but didn't we queue up Brian's fix to remove
the allocation entirely by now?


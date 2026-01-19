Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769237F72E
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768833963; cv=none; b=SeDKBPcKfSUEEp/ugKdxIIdn3TcuOwcp+S34mtPuQ1PUk1Z/bCHXT0JJa2iL1GGci3I+WzWXLl+zVqYv8EIs1AD7GKqGDouklG/OLglZ7hVC88IcmMxXsCR3GhkwNjm5hX0Ch29K/vcCgc9WV9CsLNZtUvc6EZ9+10xpcU8Is0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768833963; c=relaxed/simple;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWODL1BEIbjk628F3BRhjE8xw7BQbZ9kGVZuXww1nBduVHlNJTmue63IjvPLbaLGIRkIErnJoAy7RpF4SlvPRQOcjNbNPBOwDJek9fMQeWhERWDVpTy82RkOpzAKANQCfSgz5PVaPqFsfjDwGi1bdI5HY8yd0dSleMMMfdVy6SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PRSzN0pu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PRSzN0pu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=; b=PRSzN0puY2ByfIg/KtEpYlxZPG
	gbhCtIvl1bnNOWziA4cksHwvqXQPN1h8ZwCT+NwTrJyFbOGHBjEg78trXJgh6NS8cEr/8wclj5XMO
	M7ycy7NE8Pkcn7BP2YjNJKipKWQpth4K+zvIFZFoy4PHJDEMRTKnPaF5FV4Sf1cION8GbmTb+AEnm
	R5SaD4n0/I4jaohfPsecKC5caBD4H+Wdub1jNcPpMsJwYwlIJdyIjTM2fzaw/ZKsbxum/707a2qh2
	rnofBd9IAgfcIvnyOarW1P6ITGxTnTf55CxoyWCNINeqTkOUEFGokR/BK3sxcz1Bml7J7HmABDss2
	QuCSQbeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhqVv-00000002HtQ-2z8H;
	Mon, 19 Jan 2026 14:45:55 +0000
Date: Mon, 19 Jan 2026 06:45:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aW5Do2YeRpq2IJZ_@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
 <aQMPqDAxyM3i3pQk@infradead.org>
 <aQMbZoAAVWxxx6wc@infradead.org>
 <aW3J5Cc3ezll_601@infradead.org>
 <aW3g7G_dWk4cbx0_@infradead.org>
 <aW3zct8OHdx5QJpG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW3zct8OHdx5QJpG@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/xfs.git xfs-buf-hash

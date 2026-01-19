Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8741B24A058
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802801; cv=none; b=G93khXKOLoqtRGtyMMS/Q+si4jK4enVI9dFNKFPsvdajkQ+AGRddxGDnXEqpcscCC3XpbYhjguHGpTkgosfFTow6pzgZLqd4pI7k5BBc4APnnNpOJeXY1pkT+woqphI/l3OkSvWKGWbsXAGcDETRjJSMh8GLRc6SJKdwQCSwEhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802801; c=relaxed/simple;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNk3IrQ8NnmzR52B3kL4Vc0JumddoLEL736Je0Q9JyMxvk7EpqjbKu+b5Et0oV4KLf4/ZWJ3Ab86877O4H2xKC1A/v9dXus1Zrftn+DRCOeKCcy149u0uVwFpmF38eva6wUlxhLkyuJrV0gQibbRo+SDNAoZjMtwFExHMWB7SPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DEP/fxdr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DEP/fxdr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=; b=DEP/fxdrNTOh5BbDaGBZ4QlGe/
	/GCBeO4U/k9YmIo3qN6yXmreE26mJgN7wdkIpqt9aVZvm2evtOIsHwOWE6ZqlnDPu3UoGCxlTWmpf
	IFkSxci3i60h2M35Txuo2ElinN9NlyKmGpac/DVCQy8hAvfbD8NB6jHHdyHRiRi4+6Bzq1rdqgojB
	KgVFlx0i9u9EQe2Em1COYzh1PPPc7g13n6+YqwEEJ5fnigbrcIVhnI8SDfNnqd9Cza3f1hXki8c/I
	1fUNChhhsvw5G9zKB8x8fJBgrpNpp8eT60YuYm34a1he3v9eszawwaM+JVLKAx0fWOzShPUtIGGcf
	LQgBDNQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhiPE-00000001OGM-29IT;
	Mon, 19 Jan 2026 06:06:30 +0000
Date: Sun, 18 Jan 2026 22:06:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aW3J5Cc3ezll_601@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
 <aQMPqDAxyM3i3pQk@infradead.org>
 <aQMbZoAAVWxxx6wc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQMbZoAAVWxxx6wc@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/xfs.git xfs-buf-hash

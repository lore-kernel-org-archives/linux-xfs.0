Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FA333509F
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761808303; cv=none; b=gBzQHCVzF9M6fxbsO7k5EuGUvLyihTB8+LKPCM1uOSxOcuXQepwPZKmuALMHjhnRxgK6OXEB5JLG3Ozw9W+e3OSzBqHoOUZsIcVplmeHiWJYDpV5x+7RqN+X2UxakifTxbKCP3T8IsZ4euCaW5V/wbSQRBlGu6ZLOHq5YpFW//8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761808303; c=relaxed/simple;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyzDWb6BzBiAiRnkZkc/q/10nV2kQhbOwEob7xOGmin+sc0pnTiaucA6hxgT83JZDMm4nMYY5XS2ODCe08MzmU7ZA4fcOufr08zVHcJIg6/lgP+Fg543cLYl2EWucdUHEXeFrj4tj1laKX4sSldmydSP672/BFnGenoBkbQQri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k9Uo+Ftw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k9Uo+Ftw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=; b=k9Uo+FtwnNlbGl7YdgiL9Wyc/l
	YfsJfD6OmNbDS6JH9NoOxH2So5v5q41Wnk5yeU3PT23ckw7abuBsHClIGM6b+FbZ8f73b+WArNvYT
	GFwxo5RKsz9xvF89dYzxJEqmGFOzbU04Y8UEfKjMVydvqCvoPi785ZCB/xmgzQCzj42U7ELq1GDKi
	SrgNnX4TveLi7AWOKaFDpVghz7Ix3AfhCIF+gI9CdmGOGMXazggVqsaGGwsQyrKmMskUNaoHyKrcs
	6GJcBbezmREj3hbPZw9J9XhOJ2pimscwS+yDoua7qoamuDky7ukDdGGjT5FI4wQxsb/+K0p1Jo08f
	U8LJs1YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEMor-00000003cOn-03Uo;
	Thu, 30 Oct 2025 07:11:37 +0000
Date: Thu, 30 Oct 2025 00:11:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aQMPqDAxyM3i3pQk@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6901e360.050a0220.32483.0208.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/xfs.git xfs-buf-hash


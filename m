Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F5B271A6D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768808688; cv=none; b=shmdGstJU7pSkHJo4PGMhfMGK7L//yJQIo4WEmTn8WprevekD2l8x1ZBgkvsMf4PAE9+cKriJran5nH0AKnS0xfTUA/7xRFW8lPvekKrEyp14S7Icwg59R1/DYe57qNMu99GvqheTST5+2AeWed4ULc0apCR8An//6B6pltImsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768808688; c=relaxed/simple;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPs+blG06UDIU3BoMemO5nT3wU3NV+pqJyM+4AbiuwMgXA7h6ZwoiK/v3iy7CveEQSGipMFd/Q4ZZuEFW5SV3d0c2NjjJY/L5cJ1rumNMYGc5HsppL/QfAYM17m/zKIwsVaCGmOipowT+U92Btf97f/Nlpa0ESMgrgRslPzb9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KGVb0T6M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KGVb0T6M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=; b=KGVb0T6M+5PgFPSB/YbJNt2LFA
	UzfpWnW154k9VQ23ZOxFEFgOSs2Wf9pnK6jCkMqS4CcYzQXoEgnpLMXtuN6rIeRRviSvYomXVZjA9
	FXoPHefN82ZD4xXv4l9SvonGwJGY2JWO6B1Sj4L9slZaUlmvsswN6u9qTRcksnNnk2ACVZQqbPgx0
	niR2MeWXrdC3x4D+gO0+qDAEigRLgG4AcHdPXjySLl5otmC1vCyrunHmBn2C9ouyBfmjT4UQrymfW
	Q7vkIvjDMQZAQ6xRfeEiL0T52xWpfOaJWWVaGjpSNSnoddoXlVJP/UAZmRfnJd7/CY50bBccK8u9w
	r6hLTRoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhjwK-00000001WAu-1XBk;
	Mon, 19 Jan 2026 07:44:44 +0000
Date: Sun, 18 Jan 2026 23:44:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aW3g7G_dWk4cbx0_@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
 <aQMPqDAxyM3i3pQk@infradead.org>
 <aQMbZoAAVWxxx6wc@infradead.org>
 <aW3J5Cc3ezll_601@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW3J5Cc3ezll_601@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/xfs.git xfs-buf-hash

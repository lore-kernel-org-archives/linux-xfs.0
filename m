Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114143;
	b=R2TVCpcTPpZDnJkqeZU2Km+6hbs57DbqfZLiZdHuZM4PkDYuY/XxoorwbJHAQXWFIAbL
	 CHyKg9wtMwaAPBcXpxZZKT2u9PsYfUHpSGe5Jay47iB4vJfvnsyXwcAUuED8gmG+i1Qp8
	 KeBrCjIN6cNF+96uzW5qGscfJRHIv5d5d7D1EKPKcylghHKV4DQWbakJc+PgQMBY8k2H+
	 zL1OXZfcEax7cPRtS7If9+I3VCayL4In+dKOLqCWYVxoWXBcirSNESov81CaLvpfj4I6j
	 4whhCHpKqmz7teNdijFjuMr6XiT1FlnNC1WHGJfvaHvERmLRYcvGVsueXzbusAD4O3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114143;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=j++aTtoBwRCqPAIJ1xdb0VPZ8eTvJmBg+6jD5++G4Yk=;
	b=qezuyOfqJE3e/CK+ZBzT6bgASHolOL7g0vrmwV156UGzWwvWXSP/WAhOn+tOe7jQ6jyu
	 vSm/5u3drCX42vWjFqUeUw8p/4qgl+JfUN2K7nsyiSWaiu0oesErHhkH7LnIXeHx42m4z
	 93ewLj21lVQBh2Y+DQ175H+MK0HvXVlL8LzQmqyoQ0Wd+V+TpOZpJZ/oANETi76PiG1rJ
	 pDm3QdkvwucsxkMD1Xj/wIe0u0ZFMZb0cNG9Z1vD87wKZyBbEo7P45lZucQ+rctk4Rmfg
	 s0+mimNvJjZ+jd1mmRAdoSFW35WX/w7xVhb8S9GSVQyFazteGNXiBPAV87so2vWatgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zYPm1ed+;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACFB606A31D;
	Tue, 27 Oct 2026 15:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ACFB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zYPm1ed+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j++aTtoBwRCqPAIJ1xdb0VPZ8eTvJmBg+6jD5++G4Yk=; b=zYPm1ed+WeV/P4XRaKxze5ULLn
	d73eYUIUD35RT6eCgg6stInU7k0gTgBDTtbZ+ox8HJYt26Uq15yJcPPW08vlFoUlVDFmj4MOZse0U
	qDzo0/6KBEGY9cXN/2XiWL9XeXEHOxq4qTQZdIQbdZAOI6KIdo+hrezAGeb/affgCYM8Ock1OF3Id
	7Ke2iExRW55aPL+tMoREO9gdxBpYAepA0m6TEGF/2hT8SKNVHaBwH+LkOMp/isUj1hz+PuQ/mtxit
	yK2UEYf8fgGXN78uEsr7YR0eQcd9L3A3X+xN+r0kuh+oF5Jvyx1zHD+IKAA7o3wK/D1FWWtfT0x6B
	jv0RA44w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLito-000000058gA-0E79;
	Tue, 27 Oct 2026 15:15:40 +0000
Date: Tue, 27 Oct 2026 08:15:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <auDAHHC6a2ROBt7v@infradead.org>
References: <20261016160037.GA107919@frogsfrogsfrogs>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Better late than never:  It was a pleasure to work with you,
including some series that got close to remote pair programming.

Hope you'll have a great time without work, and we'll eventually see
you back in one place or another


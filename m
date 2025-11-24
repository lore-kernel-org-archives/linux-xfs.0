Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBF821D3F6;
	Mon, 24 Nov 2025 08:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763973989; cv=none; b=gdJKY+Ysi5pIaR/e9NXWw9XxAuhl/xeTpYzpA9d8CrYH3NCOetZkNekHtoORzajCJr5W5y6araiUw0srj5bWJjtJI9xEerred8dJha12zhLq6fv1MypVpAGdfzszBc5iyOEkdfhM/Lym8uyZoy3s5NY84xI8l9akMNiSvvQfd1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763973989; c=relaxed/simple;
	bh=pdDfqjlNx27iPnI9pJppCZ+I0FlTkbULs3GtLJpBPGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVH6HtmVWmU8cQ4F2LYXqEhHHx47qqn785FownlqFOGL6/DfB01WlSAA3hEgW/vhqtIXuKEKl45TS+IFlFRZEVPMg5+NtSjubT1E+MPdFJFNlD1ACfF3aRJXmbIdhw0G17jqR0iA0jKTc06W58Y+lx9yjWarrhWc05nr36lKm3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgVeSW5y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgVeSW5y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vMflnHuhqctH0PW3zDZQQ6cV4nj+kdVhkNSEmRIgwmU=; b=LgVeSW5ykn3lhSqA+0d+g2qCnf
	uKiszQAiS8Ud/n22qdLJ+MVzZWZFvEuUlWo4vEARrbRjnWkNH0WxxM3pt1rN55DJHXPvq+7UqZM0I
	ew1/xtcV8675FX0rCHgDamv37ZknwVPdPflk0toHXF0kS2JKbwCYYLFo2swe3LGBe+NeX6uhK0YFP
	AvuTHeoINoVRMf084ATS/WtMaT53CzKpIEX0CBdu7V7bkerPKW1+/cPKN8P00Tx/SM/Ccq3xrbkzI
	b9jk6LdOTzNbIfX4TmhN+SKNKyPT5h+BVmIcR5xylH1qlA5fP1dhtGnMIliW3RXDEEJ9WdII7qZ4C
	BO2O3KEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNSDJ-0000000BIP8-1YDQ;
	Mon, 24 Nov 2025 08:46:25 +0000
Date: Mon, 24 Nov 2025 00:46:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	syzbot <syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com>,
	cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING: kmalloc bug in xfs_buf_alloc
Message-ID: <aSQbYfHTBvX6cpsx@infradead.org>
References: <692296c8.a70a0220.d98e3.0060.GAE@google.com>
 <aSQE_Q6DTMIziqYV@infradead.org>
 <CANp29Y700kguy+8=9t7zG2NWZDYtgxfqkUqsRmE+C6_hFdh73g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y700kguy+8=9t7zG2NWZDYtgxfqkUqsRmE+C6_hFdh73g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 24, 2025 at 09:43:47AM +0100, Aleksandr Nogikh wrote:
> On Mon, Nov 24, 2025 at 8:10 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > This got fixed in vmalloc by adding GFP_NOLOCKDEP to the allow vmalloc
> > flags.
> >
> > Is syzbot now also running on linux-next?
> >
> 
> Linux-next has been one of the targets for a very long time already.

Ok, I'm not updatodate then.  How do we deal with the fact that no
specific commit fixed an issue, but a commit causing a problem got
replaced with a different one in linux-next?

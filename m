Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F318A950;
	Tue, 10 Sep 2024 08:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955688; cv=none; b=boFrY+c9D32PQ3sfFoghExm9iC+/O20tSfMBkj8buQkFBPD6wjU03mI5jMTD6e2JOWiMpjf8sSQ/UXltzgIGsCccmV3daXteb3agJWC09lsdWntYNURp5If2PaMe8ct1Ll8k4jhM1rFosztuKgRUkgAsZyA5Y9cfmD1+WWaSpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955688; c=relaxed/simple;
	bh=n6lTvb8ctWCZJg7gGSkM6ri3wmxA4Fyo9i0OlOu3t7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRBKNxZfDDtuIQk/HfDhxXPROKn3GsZKPR3pJXkiWOajqnyvRqcW+irMvbipzqQG9xtLKur7p836mHNerJ1joqFlARqMd7Xrknd4n7We+RmDJTN+5DWLydS2Iv/yD0o2GNafGg4jvz8UoxnB0LJf/FHMho1vZC02RWnMeUgudj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Q3cko72; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Q3cko72"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n6lTvb8ctWCZJg7gGSkM6ri3wmxA4Fyo9i0OlOu3t7w=; b=2Q3cko72j3efTKvD2h+8Ne3oJl
	BBrDCu7AxT6FkWdOFwvtTtLR06kZD+YI0nshld5bVvvaWn0mfImvlE2WUm05eARxPV0arY6N035Qr
	7cLedc1xieNpn6y30NPETJOaxyv5gaUaMZjiNjUw80saw8aNomExLmi0jVUqX3hAQi2zGydjkVH82
	eu9Cm6r7qnjxBRztrDlCrivIZOgNpOkrzXJfdylDqKY4wOrmhtnMf7JuxzeosSglQgwXXeyTu06Lc
	EvVpPv/q6mBsXi+IdDOGNcHstoXil4ZfdAeWM4PmM3DIpWzqK1/bVgZ9luBZhyKOAY3VL8ozTg0Tt
	0T8te3ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvuu-00000004jrO-3JCU;
	Tue, 10 Sep 2024 08:08:04 +0000
Date: Tue, 10 Sep 2024 01:08:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: add CONFIG_MMU dependency
Message-ID: <Zt_-ZOG6SWvGgHtb@infradead.org>
References: <20240909111922.249159-1-arnd@kernel.org>
 <20240909134219.xkz37p5biid22u6k@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909134219.xkz37p5biid22u6k@quack3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 09, 2024 at 03:42:19PM +0200, Jan Kara wrote:
> Thanks! I've noticed the error from 0-day over the weekend as well. At this
> point I'd rather handle this in a similar way as e.g. filemap_fault() is
> handled in NOMMU case. I agree users of XFS (or bcachefs for that matter)
> with !CONFIG_MMU are unlikely but fsnotify_filemap_fault() can grow more
> users over time and providing the stub is easy enough. I'll push out fixed
> version of the patch.

Yes, the stub is the right fix for this.


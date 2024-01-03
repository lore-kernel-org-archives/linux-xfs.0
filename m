Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE33D1CF82
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 19:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bmwh1GxA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zHtcPa/ZVfTN8Z+TvSe+s3ONpcwky6uzSNupXNpCMKE=; b=bmwh1GxAbCExjvdVc2jZUMwiGS
	RJuG69nO3SDCk9Yggx6LOSEY89yifAEJZiojHgDsQgQGzqPz9O4EqntJ3RrlNVKJlUOTZ9A0XOH8O
	Y5Iz5AW/m8CBigBD5vwadToGN06yuQK3wypdb50FBUXu0zyXLtZa5WDNzRlJL6fwcQ0hxnklcsFaL
	3uCXrouCSyhLGsDVzwYu0faseA8pUPr9Axu6cyhnL6xez3DlBQKBcRguZMLvAKeQXhTUykibFZyGL
	UDgsxJKyHbUpV4nd7pxd/zUZVF7SyHT93bDpnL5r94x7JsPtBpNsfHK5fDEub0cp2OKDewzKXuOig
	+Vdot4UA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rL6yL-00BuPO-0M;
	Wed, 03 Jan 2024 19:32:13 +0000
Date: Wed, 3 Jan 2024 11:32:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH 3/9] xfs: create buftarg helpers to abstract block_device
 operations
Message-ID: <ZZW2PTYBrVZCn3pj@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829626.1748854.5183924360781583435.stgit@frogsfrogsfrogs>
 <ZZUgK4Ah6QJkgOyL@infradead.org>
 <20240103192635.GR361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103192635.GR361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:26:35AM -0800, Darrick J. Wong wrote:
> Now we don't need these wrappers since we can't accidentally dereference
> bt_xfile as a struct block_device.  I'll drop this one.

And Christian posted a ptch to make the bdev_handle a file, so we might
end up using files a lot more here :)


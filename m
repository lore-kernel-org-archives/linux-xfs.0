Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8AA30E0DB;
	Fri, 17 Oct 2025 04:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760675026; cv=none; b=R3lboT52jOgkU2ko6xdsqVclOpi7F9Wb4TX8JBT7Az9zxqZ9+BEauzPQSJS8jvBc6e3WmRDgrb6CI++bdhH2s1VjWMuDHoAyF7P315aOQUy6aIb0cBKjs2l3ELqXgTMtPoWfw6l8Qp5ifRQYiPe2H91tqn9cfEos6Lr5CAbWXfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760675026; c=relaxed/simple;
	bh=gwZFouldB0TrZs2cmQzadv9i9A0JseF9KXJb7W4wHb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFLPgGj4vKCYNqu0sifgR5xbmA3KwG+DpgFanri19K77GzOh9Ih7t3/SgtLpQvwSgnqfu2YS5HhSGG43ZLb7TrLN+vxduHRjdeOvUjXpSHDs2sDRgY/ftX0QgW6EOl/z1TXiXxCL03jsWfWrG9k4/JsACnMvFtM3GX3aofdJfRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z3c4ea/g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z3c4ea/g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4aOrCt7RsOUOXyp3PFyNwKf4GkA8ZBukZUCHY0Y/mqo=; b=Z3c4ea/gR/ZqlYvJ16K7vH/W6t
	hPceVpO9X0CqSGD7yCql1gN8xDttUSbrt6iISGB8njUItnUuvEuzKg3ptv7Bea/aQG7Mp/g3w/N5C
	y2NTjVKPRIpi2RxffP322yZFAzDgg63xeqS9KYYTzIyuGgS5enT1W1fCwl6EJ1ZFsiMDY9VCz6YZv
	IvFKWRg6PdUQNfEuo3PImE96F6XhKLirMwcRVcTEXFQ44ltYZAGYITvnGXi0cbhqJc9qKolLmaevo
	/yNxbpkhcgj+RDJhcCTrwIYYAAJ8NNicNLYziAMmWMxyWDvcTQwdrH66yb+EP08Ccju7+F9Dn91wN
	3uMAcchw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9c0G-00000006W8S-1929;
	Fri, 17 Oct 2025 04:23:44 +0000
Date: Thu, 16 Oct 2025 21:23:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] common/filter: fix _filter_file_attributes to handle
 xfs file flags
Message-ID: <aPHE0N8JX4H8eEo6@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618007.2391029.16547003793604851342.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054618007.2391029.16547003793604851342.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 15, 2025 at 09:38:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, _filter_file_attributes can only filter ext4 lsattr flags.
> Update it to handle XFS lsattr flags as well.

What XFS flags end up in lsattr?  Is this coordinated with the official
registry in ext4?


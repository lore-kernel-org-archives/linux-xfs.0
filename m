Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256E0446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431846; cv=none; b=KfG8GKLJWjqxOqd8VJP8RWu1ZUakVg5fLioT5JbMrP6xaXVVPDZRKnREkPhfI1iVrOHnZFevXm4Zy9FVNcNl3mfk6K/dzLCumVmeNwV6f/WPk1PGsVk491vugEEe6lYfxC3nlSOs+W0IWim0V4hUwZZQqLuOjc/lmpcVEXMPj34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431846; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBKEUwrB2uPJKPj0R5viphvieNil2i0PzPdfUs0yeFO7ALOyBbnaILUtTPua/AagyAJqZnsMrIz8otAne3hoep2R7US27s9rtjfOT63JEqtOtxiOw753tN0oIpu9+f1txWjIOh+BZUjY66GWI3I0JtkYPx1FihCJzNyirWH4SFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mOyPEBEc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mOyPEBEc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mOyPEBEcF8yGGEAF+HMjYkAfsb
	CJcChaq6f/pSgHlA/Gjp1CH00++kA9DvMas2N6ZlHofhTHOUtPfd6Y/QVuoJFtupofmvH/udX9W0i
	gFy4IoZ8LEsobOM3CwsZMi4DEKsqo20+b8GJh/75jKR+nnpy1KxIaEwDRYgeWxx2g4i5VYGTXGzwz
	rNMAjrq0D9m2Ok5bCJS+7r4beYQZQ9a66tb5Lz3NvTkB3oyVu73vQkaqvOsflaZiaV5abcRxkIh5N
	GnFtR0LFfw5bhRhlRzZN+MM5c809b20VVq70I64nKdzFTsMgp9tyiSS+81LscWFDbouQgAMSpyjoe
	TbYTLg3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozbQ-00000003AWh-3SEj;
	Tue, 26 Mar 2024 05:44:04 +0000
Date: Mon, 25 Mar 2024 22:44:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: implement live quotacheck inode scan
Message-ID: <ZgJgpD5aUR03TkMz@infradead.org>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
 <171142134323.2218196.1865684046006657533.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134323.2218196.1865684046006657533.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

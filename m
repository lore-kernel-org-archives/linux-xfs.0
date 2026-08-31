Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75F242E8F8
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183388; cv=none; b=VKZe4RKPujFU/TBSdlFA9OsALuPZgJM/GAnZzNG6JymzPjNdroiILC1Lc5iqhHKFL6aiUaly3joiFM2VlqHWdAjzsdv7/OInoLFoj1p7GFBwuHIHxm4IvbEMhXr34D2WDyFnK08C7AnBVDpB/C2k3qKZrYOh5/2Qoo4eTUFTVGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183388; c=relaxed/simple;
	bh=B4w4eMErb6Xq08hRYN0NNtYmvVbZCDiAU/oTF7w6J8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdYczAjzkidTrs0tBaTQcqe0KxU4xfQKTzPQORrok+mdqaUcTCgPHjJsz6cZQqSFccIFYfsP94sbCcqjksB6oGC5vyiykxCyJpJgk6iTb9ElAH0gvrJ2HUj/fLwcNzz13wmN1+PZTDVVYBtU+fF3NSKoCVHob14X02tjxPM7bF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1uhDZOjp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1uhDZOjp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AUZa8CRudDnCOwRAVya/aoEnsShGtfi6043UNOD+XAI=; b=1uhDZOjp3IOZC41wbjQpFUR5uK
	JLKQafTqK7HAIQcywzwGRmu4rKv6xuO40nmRDs7cKu2NI2OkRxJMbAfyBbWNoPXbf1sEnsqv/owUz
	IPZUW0uuY2CmXba+q51pKnpIxllPyh3Yz/g5GRylfpQ2pZLKm9Bk2VdPbz+IEqV7lJ8yTgZvmILrY
	qLX586XMIKThqE5ykjVeJ/KgPmijR76jTgrh9LqyYZgffdFd/El7hu3dsi25xmXoow7JiaSR06G1V
	WspsPRFZLQNVLKJbrOG8NKUp9RN2ZRLn/fGj8Z7QzMGjfNI2X7v4b6Aj0MjLSbx7p+Cynv8yUJoLp
	YIHMdnZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12BU-00000009RL2-3QuO;
	Mon, 31 Aug 2026 13:36:24 +0000
Date: Mon, 31 Aug 2026 06:36:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] xfsprogs: add xfs_repair -R --- log replay
Message-ID: <apWDWDSYlGBlT4NO@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Aug 30, 2026 at 10:15:47AM -0700, Chris Wedgwood wrote:
> Adds xfs_repair -R: replay the log then repair, without mounting and
> without discarding it as -L does.  Patches 1-2 are standalone fixes; 3-9
> implement -R, importing log recovery from v7.1 fs/xfs into libxlog/.

Pretty sure intro for a pretty big and long needed feature.
What's the motivation to get this done now?  How was it tested?
I'd kinda expect an xfstests series to go along with that did
something like generic/388 and generic/475 but with log recovery
performed by repair at least, plus specific tests for all the pitfalls
you ran into when implementing it.


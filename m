Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB49FC0A;
	Thu,  4 Jul 2024 06:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720073106; cv=none; b=bPt+G6zJGux9uEElZ/AhSZz0w/Lk9REIZXkmaP7v2n2rleotXgxS0Q/uXASLQKhSrMR89Ae3Cd0Kv6p2hVN2tFPhb3tA52jyOAd0yDiz2ye3w5S+pWIr967bcoCL7L/7NZuBqhjePPobfgnPiyXXdn7YmWYJ6H2D4PVZ18WVpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720073106; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKu1BS1EyEYxypCSv/RzR1TUzyywET5ZDBe04Lj45//aehY48PY0LlMJ3/TUTa7PYmeh1FGBRTpWYrIHrUU/JH9k9LKwfGA4hM8MhrclmtYQe2FD5z95EvRgCTLpd4BBTlzCKjBlnn1JQGJxnrXRQXG7Scc3qQViGuECYbMLzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cMOwA47N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMOwA47N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cMOwA47NGyUkr/lrubalKiPcYp
	ru3lLRMn5zwAoSJlvzdoOK7FCq8xHpn0JvdfyMzp0fT4oIAsfOdhUYFq/Nwt53cg2If2ov1MAxSzT
	Dc2ZeiCkpQZnvrYKzoZ3rdc3FZ7dxUVY1NbbcK1B81Vvyu89ieCELsZk4TTP07rbwD9pgHQAW+Ke4
	2xnxKZeAuLxTptfW/wIDsVZAdLRvTqCN4GCZqMRZhATWhRzQGdWOolWTs0x7X0RI/HOZH5zSNEO/z
	Qr7KDKS/UI3gVxDF0JKGsqdzAWlZC6lC8SI3LN/lwGO99HPy4m7PpmxfeYufwFAlksl8fky6UZNO4
	QCiUdl7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sPFab-0000000CI64-0GjI;
	Thu, 04 Jul 2024 06:05:05 +0000
Date: Wed, 3 Jul 2024 23:05:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/444: fix agfl reset warning detection for small log
 buffers
Message-ID: <ZoY7kT5rKmgfT51-@infradead.org>
References: <20240703213605.GK103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703213605.GK103020@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


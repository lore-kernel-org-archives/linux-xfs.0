Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3E1514F6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 06:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504856; cv=none; b=WUdIAqdKQ6MYUS+U9qr9SLG4w2s+0tCB+lDzxwj4gWmIUtF3BIHQrrq9F4Aljvxnyxyw1co2N6Jr4QO+z1/2ASmYTKvg218ifp7V35+DmWQh32UJFTxFa+k0HB4TSEjHpHg86F+uHPKwQawCh62O4D7S1Pu4oDsiwoUd1jah708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504856; c=relaxed/simple;
	bh=4ik32yeuxxpY9wRmjk/XLGHK2OQduQmy5ZpDpH3Ds1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bu6crqfSvUcpqUEbXv1vRIWAHLNt1oXKp9A9t6W/Nq4dIAJL5EZcPy1nlKmzWTisF4oKKAJs5AH9eXlffgt/i3N8qM3QbS35KyLiEyw+NVwsWpVtIpvdktGW45ZegWCM1ezKpc/rhxPj9jD4Zbh4Aa87Bq57ChOiUuRseZrhov8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H17AV4m/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H17AV4m/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4ik32yeuxxpY9wRmjk/XLGHK2OQduQmy5ZpDpH3Ds1Y=; b=H17AV4m/v5UlPO7/0brKBtRqw7
	GLBzqO2z8CJi2eBScyKLwcQNDblyrC29Zz5NGo2JfAHgoH3dWBFiL3BnxFt4zpH0uY+YTE/yl3vtP
	L39yux8f6MtKv2yuBZ/O5ahTV9mgFX4zflyBYFg2BmZTqbYbErAi/Xj1AOpM5WKP4QP00JIk9XWQM
	/28+XNWCBYuvoa+tPvkzD6fSM3xVo+Wm3poYgNjKVHvwmrNHCFI9N0JycrWyl0iGQhYzEtUHS0VAs
	mULwhEro8CSscTuZaAOR5YASit1siKgvJFanXJwK2YlbNy9KDrBGyeUX9B37fRwcgJ25qM5dtIBPh
	48vYur/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNnwj-0000000FlZo-3XRL;
	Wed, 18 Dec 2024 06:54:13 +0000
Date: Tue, 17 Dec 2024 22:54:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in
 the data device
Message-ID: <Z2JxlVLlr6vxyZMV@infradead.org>
References: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
 <173405122737.1181241.12229622781538486656.stgit@frogsfrogsfrogs>
 <Z1vP9qDWdywLExjt@infradead.org>
 <20241217195813.GP6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217195813.GP6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 17, 2024 at 11:58:13AM -0800, Darrick J. Wong wrote:
> How about I put a somewhat massaged version of this into the commit log?

Sounds good.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E3372EF4
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552902; cv=none; b=f1nJLzcDp8M9zSDjm+Z4ZoaYYlHZZUVM46GWL4q+GPL5SrzZJRYhQyAXZARPkVKkhZGtsqqsNb1FqFZ8JiEWLO58xH20xIZrlWg5a5wt+sU1JDkKdIdP6JHBfbSC04xk47939mOzxxHwpMFdAJ7UMfgIDFwtux1tTpPPw6uCobU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552902; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTwof+8R0vS+onwIEICcfdBhS7rZ8SuE0ALmxzeATLUkiILP3ucY8MhPOO9n/65yVE7Cd40OQ9rCp+EOGSF0fF8TWUUxdKHnvZ4tOwZO1PNuJ67kThsZlZnUAdInqEZ54FqZbg5uyWbkhpTRzWmAzWQWLiVhZm3UU/Pp7C68eYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ghwGVQdp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ghwGVQdp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ghwGVQdpx62/van1s8f5Vxm8iw
	oUsJB+KxhIcibissRq7/qxcHgVWHYJsIovLELXCFQTX1AJ3RgmymJ0O1dUzeDIruOA6kAtyJyUbNk
	3BBR15cHEJeB8I4T7V/DbK42/nObepvQEFyAKxLfNWMXR/YM6LIKkCYsxG9MQiOcQxTzARhWiK4S6
	qfo/aUCIbMMDccdA3t9YM5puriR+jU/Sg3+C1vVcoRoOEGwyYmQLwoc55px+IczP9KRQj2RnO6zQR
	nTP2M2txPur15lbm3Uv6BaKzWB+ZT0rIvnjvw1t+mcZgf92A3nvpXqknJxlPZHQcaHdstmlGR3ulx
	Q5sNjKOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRyu-0000000FSri-3AeQ;
	Tue, 03 Mar 2026 15:48:20 +0000
Date: Tue, 3 Mar 2026 07:48:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/26] xfs_healer: create a per-mount background
 monitoring service
Message-ID: <aacCxB_2W0NYW5vn@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783509.482027.13001515079400864128.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783509.482027.13001515079400864128.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D81B6D0F;
	Wed, 19 Feb 2025 07:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949219; cv=none; b=AchHQwMsmOHmNdHQwJHbZzNQj1eK7Ravzh0ak6vz+YY4pMXb3eMoY09zpU2ikIbcjoiXjdr6dvv4hOZoUQeC23NZWEDoY6Q5TFswLeJnXSNZn4/5HeLGChpaqvHaD2nwTbitDcNxGqLiCJ8Gs1aqz8pP8aF3W9XLy1gjGU+XWWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949219; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCmP3U3IlUfzhOLCWmYOLOqWxmkg90GkpWxNE+sywirv1/kluY3Gy7yp6mKVvJv3aBnntk7sndgfxhsF0jPjxGrPi6FoW6qHYIx10M/jdC+a7pbk6ShHuVKIQG1FXbtsJ13C5rVw6MqQT9olpuEA+j3+tbr4ZsJc7AU6eLQGRb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mNUkw0Y8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mNUkw0Y8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mNUkw0Y8T/NHX24kyXtpo+GLIw
	sVjhqaMYBqVM5ofCo1kvOB6WmV8UXGg9b2AwgG2gytdw6ONyE1+vQNG+TifCLkYdWtCQZ4UBvC55j
	hQG0h4XhgkTw3x1zK5xFDFanec255lfShtS/q/6TBQ72CF22GLt0jtpwGjXe+B2eAnLcfT9ZCJTwo
	Gt523NkuvFRD6s31GSBk7VnGKMhA1mh/PB9464vIIhtEkwzRAqz30eFXqesu7/gXv9VXTzJhWqtkm
	kXLtVEWaRgbe8/qMEZhHzPcHHkQUhtsOA8BQJqHa59a3zkwon6kMBGyawf25lLWzr6oXLLveIDVif
	TOHGDf0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeH3-0000000BBBT-3zNC;
	Wed, 19 Feb 2025 07:13:37 +0000
Date: Tue, 18 Feb 2025 23:13:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 04/15] fuzzy: run fsx on data and rt sections of xfs
 filesystems equally
Message-ID: <Z7WEoTQuDzpodRgn@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589254.4079457.10498287265932477514.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589254.4079457.10498287265932477514.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


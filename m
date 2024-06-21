Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE7BEA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945338; cv=none; b=RRJIukjFI8bCe2DDZ0lRDaCS5oiEzbyerk5KD0xH4eM2MM7P6BmOBZJKczZjHXXllQf3mqciR0udIqBJHT/FlcZuqyGUa+sxn/3LnanSpGRfrQJ8Zvw0D1B7TaKLjzqJiFbOu9YSbcOQaN4ebRSXEBAwkNO3m+9q80kpb1tk4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945338; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdzLSPZeqjl3PBUsz5G5VBZLqrEF1X5q3dMrmPQG7O1D3Vd8d0qQhQjqCR1ys0xUXbEmVQMCM9tGSJ6T1wkPXrqUFtnA3nWjTXv2VI43aJ9b1+giRc7N+m5oKEuAglLeK7mrBcDTJ3RztGxEvU6egYxHzYUFm+ZxjZe97K0A4Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q1SjTBZO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q1SjTBZO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q1SjTBZOR56miCbiVNgY7doIO+
	L7lQHObQ786FCSd1O9z0GRCTJJkJUA5NSl0hMp1Djmhpe/qK9V8QgoC6X0elP35ZwMb8ECAb1ap9p
	O6t893fTj4On92YAkeZWqL6hRV2qUh5OLpJ1OZ4rJQqYUXg+NpurhLA7DVOS9DrEQZxwsDtvbhFDe
	c/81KXxs8wNUBuWktm9p1CNrrVa8+kLhVOBsAjb7qtmlzVAIvXSHmEPZxjzpD4sCKQtBavtI+oHG3
	y7cEoliPqQFjY+7PX1jWvqgqXDJ3rZfRL6cyMUwlhWC8YnCM1JbA91+FrHBDmdyi6dMZ/7oEfMlR7
	JiTr77DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWCm-00000007gU9-2bBA;
	Fri, 21 Jun 2024 04:48:56 +0000
Date: Thu, 20 Jun 2024 21:48:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: give rmap btree cursor error tracepoints their
 own class
Message-ID: <ZnUGOCNp84VUhbU5@infradead.org>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419249.3184396.641039011881838280.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419249.3184396.641039011881838280.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

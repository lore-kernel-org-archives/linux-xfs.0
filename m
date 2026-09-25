Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74C339769B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314600; cv=none; b=AtVNSf4X2ZRUBc+vK/R9x6vjxxOs4QEvv6BYo9MhM+c5EOw6TeKPSYiSQuPAphFgwHPfXNouxZPSv+oMpER/Ratwgy3tdS9d3wbnTQw9wxCZ7yCHBPklXkIJlLDvbdjfh50n+wivDuzz259Gfl5qI/mwt6nIUOZxLBz6LBZfqws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314600; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJgzzUsIk8dwvyu8RXPHeSyeTIuAIqAby9HmbNPkGH1UCOG+TrZlBpL1f8H4LiDs5fd6oIy/+hTPJy45HmHilMSatfhUqmuBR2GhAoQJg4rdlLONuvQye6Kj2AnvWNHtZV5yE45k1fO1drLZoARVVBKshzmwGjhTq5gueU7c8uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bzbcW0jZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bzbcW0jZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bzbcW0jZTFbQUMOc3ACSJK+oxE
	yWQDCgDYXIMKP0pprJFtlRNWeBTunGTXAfCOP1In82V02pVAToFs9ge4p+PolTx2PpOJP8O5cMv6r
	zge2kHA6bLZD4FjBOrJNuvKWXmXWG9n5CC120bZCCoS1nEtmcSA7a3+uUT5f4bLjXkTGowkf2nRHb
	F1Xo/m90Q6sBDk52Ja/gCQMp2Pq57K4zufVRQiZMYf8/W1lQPAwcLbcbNEMCdnNleu62N+L7VZSsa
	7yRAFTc8SheGrvBuLWUVskXiXtWCgDcYnRS4zfcv9w6ur5GhOwI1e8nugRVwdRgt/WDe2SahTXVA6
	sErPDDSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9ybv-0000000Chlj-0sZv;
	Fri, 25 Sep 2026 05:36:39 +0000
Date: Thu, 24 Sep 2026 22:36:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: write the rt super immediately during repair
Message-ID: <arYIZ3dH___K_crT@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932155.3344850.307719005695648802.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932155.3344850.307719005695648802.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


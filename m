Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9392C11EF;
	Mon,  6 Jul 2026 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317807; cv=none; b=c0GfeDaWWifoZ7b+hcl0fAhG1TAZMC8bjH4mNAivgVyggduZ332mpFjBc0MsVN8wrbJwW5GuPKXGKTg3IswPDGuUB3dPe0qtiq4Vz8+/IuSth12djnapultrnXFdPSb0OwTrn1x1Sotv+zlN+IxAq4AZve/QT6+A7/1Dfl+IYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317807; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXr3nJTspJk7wZnds2pDAZaANGuY9JT1fY5JkkMCLVYIWiZNOqiaowNMpCApVGxkuk+MpUfOaBF0mfN3Ylq+yRzUJsfge/NSHfEwQxZCl3O9RzYwQA9PzOg3Hrxlxk5QiFAWNEkIBak2NUW6YIXsyslS+JSx6/7e1Bl1eWtmid0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pt4y8l2L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pt4y8l2L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Pt4y8l2L5HQ4suCEaTRj0+NmeM
	STvtaZmQxqiiZLFhag1jUpe37KDxCuft0TzqybGngtSwqegc+gnBhMZjiW1rKOTw3Ceq8jw0FZMmc
	hoHJQSF/Cb8iNRp7I7jAw4UuWQ3Ukqu29VoB5NIDuX0i0lnArr+/w204+aXqg8fSfEg+iEBUI55c6
	TKpHkbz3nyXWEdhIfE4cZlhEvaWPStLBGaR1mA+KWUlYwDBNG4AQ1lg4wc6DWQGtIWr5fnrZE13hm
	n9PvY7Q1JQ2RHTfLQN3VeW01c4nYggVovlJ2GnwAgkaMDTQeBPScsqCSyxiaGxOGCcdXFqKi0BRcr
	ztxA9isw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgcQL-0000000BZ0q-3Rvm;
	Mon, 06 Jul 2026 06:03:21 +0000
Date: Sun, 5 Jul 2026 23:03:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fail recovery on a committed log item with no
 regions
Message-ID: <aktFKamLw1z5sgNW@infradead.org>
References: <20260702162000.3548359-1-bestswngs@gmail.com>
 <20260702162000.3548359-4-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702162000.3548359-4-bestswngs@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


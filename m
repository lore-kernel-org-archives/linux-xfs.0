Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8C718FDDA
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126472; cv=none; b=ljDX7xdLJ+uU+mrEfvSvDI7t7Zx3iD5ZoHBf0sJyHo7WXe5x1e+HYN1CCTcONmQTCyxtSUi3CodNqGsftgkayVre9b0LripfCXzR9551/PrbnmGt5u4i0aLwAbOBUdE7jN8sG1yIA8fz32Uiaac2k4zJ/7di770ps4NBNvVe6g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126472; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GO9ctL6vnN6lqpXiN//1A7QVjn9/mcgqazG4ohFaZzY9dBiCTcG3zZRkwXSiZaylrHxkOOLl8HzayKI/HKR/z9tlnHb7yO7gAn8rJnthL8FZu0I3aGMemvJ+Xg0i5cwq0fuTUma2pkcY28bvwHxYuxLuF3gzLjUJMvvkq4ahbJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gtQwH1gg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gtQwH1gg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gtQwH1gguiT3f5Ey2AEjapOPSe
	vb+reQ3KeDHvnRsSEXOjwdN6WqwlGnxkOE7Zkali6hWG2v4Uz625PvqZ731+EQZo2Fj2ai3cLQBPi
	XnTub6+hCtKgPq4LApXRsc+o5/DE9JpgTqYZT18JP0HGRXzZwQaWOkN7eK+7F55TPhEcPI6hCueTt
	eWXU1I0nhb+BeGxt36cPx3UiQpkklLLjsM/SSD3xyYIqzbxfIO8U5vnDLxL8NG0rsWGvyjUgRuVxb
	aT8DZ5+ps9CX4suIXrNdyuZdx3+mym2YvYQ4NBlfidAP0rCk4BflctNJbbcdmpLxZvUeMhz/Hib06
	mDLr1+8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc3uM-00000008TvY-2pWJ;
	Thu, 08 Aug 2024 14:14:26 +0000
Date: Thu, 8 Aug 2024 07:14:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, sandeen@sandeen.net,
	cem@kernel.org
Subject: Re: [PATCH v3] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrTSwtcBKuFDwqTQ@infradead.org>
References: <20240807193801.248101-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807193801.248101-3-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

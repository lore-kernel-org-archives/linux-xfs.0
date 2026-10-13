Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BB139B4A3;
	Tue, 13 Oct 2026 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876842; cv=none; b=qt8qhZtgnDAAljMbOFl9beqh/A9Hu9EzvuNvKDWRbYcklnx0yvlWPyUUIwcnr4INSg9bLi4CrGxTylGiiUuJ+GHBCHmz87UOgWxzJAnzVKKdTKtW+AVRov2g5IgYFc5IjmID62oRKzbuQOQR6Mpu5Cg8HP9eID86FE3sJkfRIkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876842; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsp69z0II5WyeieQE0g718h6hOobROLeuWTvf4XDSPaKfgeecFA31HJ/JC7Ny6UkSFNeuWBi32BT844MnwgpPehwX4VuPGjomsZuzEVMBDWTWtmjdrf8Gs0TEz6YNgobybu6nk14YBSWgMtqv5dpmtvELPsdUNpulmRCE2xQA6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PZi2hdw8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PZi2hdw8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PZi2hdw8poE1TZKDXWaafL2cBN
	Q/B41cvC6SFM8pUSJaLwzxVF0BufZUO77ANhCrw0bL3XltP+i54C6QY9dC5xtnrF72E1yAiIHkpT1
	Da2m3zMMlTpqzr0WDgxmS7Al2hQ4/gtWIig2b14I7C2XSah9nOQNRDoxLK8f4zj40eAZiMqkJCxPc
	gZ1qUSEsDJ1uHyXPQWpqAaNPbWfdhGHR3EeHyP+VwfeJzyv1TwZKB94VxGLO/BHPLCTqe1l62V/GL
	rm6beI5amQEQL94eroK/lchMgUnp090ur4raPVG/MQ9q7yPaGc9VbpwLsqh65S0IOVQ+kyVy4a8Yd
	j7OgyGWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX1A-0000000CDzQ-2hVd;
	Tue, 13 Oct 2026 07:33:48 +0000
Date: Tue, 13 Oct 2026 00:33:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test unlinked inode list checking and repair
 with loops
Message-ID: <as3e3Irsaqy7VGPK@infradead.org>
References: <179185007737.1732474.11416600010761357309.stgit@frogsfrogsfrogs>
 <179185007781.1732474.3546955288834118375.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179185007781.1732474.3546955288834118375.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


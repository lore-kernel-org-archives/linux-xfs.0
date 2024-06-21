Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B41EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945435; cv=none; b=GHGGA4gKxegnoHMR/A+AOZiHAl2RJXV6smKG/5BqzPRKQabMFH1UEi7JInYGl3lYW7YDjTLrF8Ul430AuwnL5jhMvq6HZND20HpECA0Bv1d3s/H/5VDO0Jws9VFcVUGyoQySYHAY1a0B5IR3i/5Tgpl6dEMPWvZiPIWaUaYE6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945435; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnNCw6ozxC2xiZkjHcJ8r2+xg6YWhxtwWoadL3A9E8rgHLs/Zf/RzhEREU10qnBchGG778KKxX/YuNtJhvQ35LnD/2vvcrPUxaSpwPg9xUKGTw4GcqBWqWC9s1LMrUaFw/xG6Tb4Yl80stF+RpVl4rERbngqdNIFcsUWn3lN1sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2W0ZKw3f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2W0ZKw3f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2W0ZKw3fBZKVXo2tddbL6EV5hs
	n2gpjESoU0pC8NmZ5j+JRAcHNfzDiDTj2pdDjllBW64A5r8VaWxXVIdIhaiXwUblQUPzFjtlaXaBs
	YHFht/3YU+BMCZSjQzrc7NISL3Zz4xpeShgdl8bHPt8vS3ndkmehBmo7NwaHfdiymbkWWy5yBGGeC
	p9ejXRGTcaZ1E8wOEUbgUKwrfdfbXnVJ0WUqteU1Dc28ajkQr4IljMJJPQEPk64vUkUH40gQPfLZf
	QJw8fmYXpOp82u0/eMXtYElYVbhzsrShWEt2oL3hatXs3B76q91gEF31LZ5GAVNHGCoNgR6FZGJMo
	BHv5Z1YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWEM-00000007ghe-2PeU;
	Fri, 21 Jun 2024 04:50:34 +0000
Date: Thu, 20 Jun 2024 21:50:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: remove xfs_trans_set_rmap_flags
Message-ID: <ZnUGml1IHMGvbNyF@infradead.org>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419301.3184396.4725607583390300491.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419301.3184396.4725607583390300491.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

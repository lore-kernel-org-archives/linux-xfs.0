Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD84A205E2E
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420793; cv=none; b=HmAfQMKq43jB27UbXUBXwoVespLJ9mn9wCOgy3M3Yy+q+ZnyAEp8oEpFoVv+FGC5aCOESRnW4EqA9NOMxM8EUEZCscmb1IdFxHvLk9Cpme3Ilzkd/yqXu9SsxzEMBqLfDf5BtuIrAXa8jTccWQBCopzo9C+BN/W+U5b0hFowVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420793; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WtHmHBLRCmLvEQijc7ebQu1r3k1m2b5iqEIgU/cOvoJhqWQTXJ6oafNc5u4RRRE7hj18lVE25ZSNTUdGfMOrYmJKuIJbmWfLktfN/K6mvkw/7IACBqchxkyoQOT1b2V/LfkvQaI1hzqsnPWemnlN6u4HNPEYjJy2F8KYdptee9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y3ylSPpX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y3ylSPpX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=y3ylSPpXz+wHszAGS9w06ErR+C
	Xh3baStwc/COrXjNDVU0BtYlOTB7+Z2XtGLa2B7uyK9B3pajYi7DFp820xBohULMLY8zEoPwUU2e7
	eWIq8LRxHUmECiNZ7bBRYUBNZzxe4rniW2j7nI+JJp0zoDfCkaHp6ax7D9PZUPC6ocmw8XkvVRjR0
	nUOP4ln+VdfDv7WFUsdZO6DIJczRvgoPesE/NXizt2GRnL9zYZBci4whvsKSqykceCYc+vg93M0wC
	Tcrp7RJecGZX8DzEhBLMwWm/AcFA7encBjC/C+WwdLUGPegm4aEbTCvDIQ4iokmH8gnpqd9VzL599
	1xmFi6uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQo3-00000009iG5-1PZb;
	Thu, 13 Feb 2025 04:26:31 +0000
Date: Wed, 12 Feb 2025 20:26:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/22] xfs_repair: reject unwritten shared extents
Message-ID: <Z610d7_hsFQB8Tk9@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089177.2741962.5838383202072252893.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089177.2741962.5838383202072252893.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


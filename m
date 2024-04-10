Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C720DDB
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730134; cv=none; b=sNdz9nYRH8HDBvbrcIzxCc4BEo9GmQoy6Lg5/cek/uV0IgfamAx0fGCPk7DVfLmdhHhAyHBZnejhJy4fhwQSu/oPXpvx6SCywvNz3gb41eOy79D+4CswmrTNUBKbryeggTV8vMSNXKBVU6gdplVr9B2b+T7iIZAaikEwagUGlnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730134; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bC5age+UDQAUe2OihDBhd9WQb40jVVruLnDtTMYpALg0fqV1ln0r43gQyS3X3gKPynacSU44NO9E65FeWnlGBxbmElfXRCq8NeYT+JGgwYbltc5+D7raWPOHftuMHgK+X+9EljDo2BJ5yCtGYmB6FxFVCYw/siUgJ1lJUc8jUXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lq/mzzPQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lq/mzzPQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Lq/mzzPQxcckZjYUEGX2Ubuwgo
	lVgfQdfLnPOS6QFJYtIHrOmGq1iY8gRB39Nu+P/L5R+5xRBF4Xh3CuqnftOjS6v1SnmlYpYWsNjBw
	gPxfVbS+kM9JkEtyZijeSqVgrb583/XSuYOXWnMqepLK2K0GWBAb0Cax8Jf2NiEJK21cZRk/wWQY9
	q6jXR+mN9wHf/krIkE79jL9i+z8IZC0SUwikVPGdZh1xIZZOAk6028Q/s2A6H8kRolSt8X8KqbiUG
	QVlyujpr16SLLcV9khhP229YvHs/nXMacxB3FxuDffheR15uS1RDzGasD2IWY+MrJxSuwArP1jAMb
	P+rLca0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRLY-00000005Mij-3q9S;
	Wed, 10 Apr 2024 06:22:12 +0000
Date: Tue, 9 Apr 2024 23:22:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfs: add a per-leaf block callback to
 xchk_xattr_walk
Message-ID: <ZhYwFC0eqqzAG2qR@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971153.3632937.2520789896532879492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971153.3632937.2520789896532879492.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


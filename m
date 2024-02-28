Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B53A24B39
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135519; cv=none; b=Nl7Xvp0PX/ZbyZ/PXoUPy80aAYRj5TKRjAXWa2KpfIrlPM2ZzQlVia/2jG69R83yrFOMbd7YWNvKkKZZuNxOBB0TsMXh5tZlUGL0ckVrMJ7C7nT1C0kJed5xyqfG9zyeFqmoCnWdm1aX1B8tcapbWoleAdQsehT4yTD1+DMCQfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135519; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeK9iziyEfcsrDzjOMykAobLeqWie0rVRUq7MhYrgVPvwLymPEH77s+4rsA2DkbvdU6dc9p153l8Sj4EvCgTZnAArFew7fnExUX5u51vahz/0uCYYCyAkDOwWuwJCkFLkLW2Xn0T7lBZ2dcSUuZ/BdqaXNrlCHZ4h6at5TTw/SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=edNVKF2E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="edNVKF2E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=edNVKF2Ee55oO0WqSAry1xUcjo
	mNymGUjBr6DUOr8emFN8B33DTXVwF1AJTelm2Yv8BDU1aLi4CzDRSOpXEPtsQpgecAis0soBTW/FY
	dT5iaEIEjDdTYwyBZDdHNbyNyqAJV1B/6BoP1lWQfOXM5h9hFjWFc0WdamUhqznEugPNWNAqMXIWc
	MWseBR3aWZS9MBT2p0pI5ysJXW3sBgg/pZsha2zbph7JPv6uj4ZuAaC3E7H9HF8KkCkKvqQ5rKAS3
	5zPGxK5CMbBLlWnUnBXez6btW+5t0XpfDtCA/1Px2axaSOUXnX4Uoyzt0Ol4QwwCr9pNQjBeTv6EU
	txq2bbWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMDt-00000009z6o-2hkF;
	Wed, 28 Feb 2024 15:51:57 +0000
Date: Wed, 28 Feb 2024 07:51:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/14] xfs: support non-power-of-two rtextsize with
 exchange-range
Message-ID: <Zd9WnchIv4uI0c5B@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011839.938268.6567862146289505624.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011839.938268.6567862146289505624.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

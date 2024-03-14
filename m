Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871725664
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381749; cv=none; b=jrn7+oo6OhJQ02Pt68W/9BkbZuZHRQZNjFvgXUh5fG/SuvnwaLI2jMZ5R7yrfb8P9ZDdvvuju6dX5SGCO6tWDoSbzUeiDqJ9EpKsgQ8Oyt/1BV0/bm1pUOoNusmTeuzyOuwOXMx2seOPQwUBUH2iD/5O+KKjKJDngjWdj3+T0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381749; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MkZfijg6yWgk4vtadJrMn6ipvhYQIpB9b/osdesAJMlVZGZH9JVfda4kgZDEl9krgpcmVLUAYeI7c+6/YLZFgedAH9x11s906nfBqhN24+A++OU6Gf8Y3V+Rh/+ZDgr5y/nw5hSU8kobcHIEDG7MnJ9hUPbztwXL5Q6DFD9p3oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t+jXQ2rO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t+jXQ2rO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=t+jXQ2rOV99YVJ5e/6iVe2kxJz
	5puQT7QNypKqGIGdVLAoB5gne0GXO0cPuKyilU6AzVhCdaWxscBfuuqGTKjSPR/aoPht8jzJ1Om2F
	UG66K2N4UUOQR4dY8egdy2+aZrKXZ6zz5KvORXh2cll6mA2PEDJXtNwXXTCtPGC7D3LZHtRj96IBQ
	ZS3wOwmhEEoYKvVliS/OPl5hc0MG9qbLrKUSQ4o3rUB6e2ORZyNIkOC9AiH1AR1U4dhnpKGm0ArKX
	W8RyIQatFWfe6I1iNjC8kIkU40M8qQxOXL/b73s0e/oHc+BhAl8IXTGkd7t/0F14zlxTkv1ByI4lQ
	3aK0dmgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaQN-0000000Ccxc-3oz3;
	Thu, 14 Mar 2024 02:02:27 +0000
Date: Wed, 13 Mar 2024 19:02:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, "Darrick J. Wong" <djwong@djwong.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs_repair: support more than 2^32 rmapbt records
 per AG
Message-ID: <ZfJas0eyN6GOyYbx@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434772.2065824.18696490895008470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434772.2065824.18696490895008470.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

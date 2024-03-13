Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3254BF4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367272; cv=none; b=t1/vgZvytQjhCI+D3DMjm51Ni2MD+mQiL7GbJCE5Yrr+wp9xG0W5S7r9GfDjgZkqwtlvNvBXNzxTSGGtxLuutMn0/7W1AN0ZiXJxXCqOeJv7f0Uh7zwEnaecntT50T++IXph41gwOSMHq1EQSxd0BoWRBmnMPdrFzLqgrOslpi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367272; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ar6tZmgVE5dxw4vDwwxwW1AbgS1xdw6fSYFJrSPHVzNF16T15at7dNvuyjlFIuJjnvfUKdJZ8ocLp7rvPqly2+iGIjzMWYEGX+68tzgtT1+6x3bh7nT78JnZE4GMMPiN1d8+FbFSThOZofZcxGL+gTn5l1T2ahuXjTSBQ5LoHRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J+YtXvj0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J+YtXvj0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=J+YtXvj0fFFjuqa8rwkLfAi+uR
	M7eC+d+465w/Kc9aJFLUCYr4yJeEx4znIJ+NhZ+8rtbzF6vY/Yh8RFAiSwEv1ZiuHmWkUlNDteC1H
	GvLzsPQWwwLSknBfjlwswMGsLjqbA4PY1maCWSC46XskIsxaJwxElxmWt9DAeoa2H1q0E7a+RDPKC
	rUx3hWDt7AXkrVOzpafjNVEMOuvUj1VXxlKEsSMdj7LPMY88WqaK2ZDTSVYzjibeZbg+6KWxmBHCl
	UzfDi5mY8wEkkPRkLx9mWLD90zyWqEb1BJENzsEpRkqj8C4U3dLXUlXWsDfRJ1/fiPp+FjImIzP1m
	vRBC0TfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWes-0000000C3sE-2qVW;
	Wed, 13 Mar 2024 22:01:10 +0000
Date: Wed, 13 Mar 2024 15:01:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs_repair: convert utility to use new rt extent
 helpers and types
Message-ID: <ZfIiJrboMXIlWI3b@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430643.2061422.11374848731173937406.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430643.2061422.11374848731173937406.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE404224AEB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810267; cv=none; b=n+TWi8I2N7xD9W1yEpPNkRpK5lICn3xtJPpO9IBoy1c/OOHOtx0nlE7Cx+pULaL4TQ0jrMlY9UqT6com56OoJ1CQdpsIeU5fYt8fEaEHtADhp8mq5MpiS/s0Fh0fdxa/OEIgvr8UwaLmOV14lXmiyNI5D8dXSjNSKjgcVkyy0u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810267; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9+ACnk+iXIL7136zTTvIdCFChYm1vxI8NIXTPFaGwlHpOK8kAJq6zspc5qKesOxspbqc6XlyZCaekHuZNTYQgolnKCd8mOGRb/Q0jizCgDN5AnQ32BOuTiUHLxTltDU6vBbkt+o6V0x3XAD2Ko8hbK9fjRtviY6117gILioi0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pghTA4Fi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pghTA4Fi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pghTA4Fi0RGxVkdsvbleb+7awX
	greKzfhBvISs6JKSNXDfxgIUiPDZnejWaKGqQf5CYo8Ji5He9VzLWwiRSBgXrs8kv2NZmNeE5dVyH
	Sdnu06Jsx3iupwJxL4suOMZNkpdM8vNfe4BIrYEkEAUxj1j+tgxE97ZCNenyMW4REu/6KvsNYlhLQ
	ERUKkytjwGJYiWYf563jn/p+nbxAZDmoeDSi3T5W8vnqGCzk0563/5giE4T9MxyKVspIbEAXOSfiO
	bZ9KHDTjM7NesOLIxXDeOkEhW/6y865EXmPjHMgEgCX/FGlP6EXNiXMOKLe3cssXSMlJwFaPS9b1t
	YHGiPLVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtFi-0000000AKuV-1ZvF;
	Tue, 10 Dec 2024 05:57:46 +0000
Date: Mon, 9 Dec 2024 21:57:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/50] xfs_io: display rt group in verbose bmap output
Message-ID: <Z1fYWo_8MElMTAA8@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752571.126362.12918164461473948684.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752571.126362.12918164461473948684.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


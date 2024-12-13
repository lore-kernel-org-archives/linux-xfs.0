Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9FE1372
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074380; cv=none; b=iFGm2k0yhCOScUTcv3VSYDbrjYtHoPeSZ1uxYN9w/5O5yitaYvd7YS16lqzNgfdGmLB/bi1C+f0USDYyrETpRUggxxYDFnWuBj+5uaYigqBcf9iulRnMf3QNxxyPxCtC6kzA+5mSDytbqmtVdsz+C9UW0aesfHp7VLbLVjJJ0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074380; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bK6S10D+mc0fyiZoent0zLB6cG6x83Wj25nNOnwzjrn6wARxTNhLrdFTX90j8qUarLNvmdl40+4sa8AfmW1l8lyJMI2FrlMneBq6Pe3XdBAxpdfn+Kj3NFciyvWVcMNbkFdX4IZ+sPe1yIlnAwCQL6SgJh9bPi4GQPoFUdG2T8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eOfa99y1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eOfa99y1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eOfa99y1oR2poyDW7uEWYWvXu1
	PX448lf1oyg0gN7z6heumS+12hL0DKRscL+BCwU+spg1AQYY44dLlYSioUfXWfui8/d+q/nb9XxOE
	Wt8qJlXzDIz+0o5hxmzSFwi7uRnMB2bRjqG2cnHdISua7O1nNt9LlfWLgSlz/oYNXxA1s7QJkc83F
	PX8B0yb60BK0oQOY/rP7mvkWtKO8vicZuxhO67Bmo9+uj8vdJ22Nq+AiQZMbWywwvstYcrpims6x7
	J2e1ZhWZVVvSd0jnE5Kq8oDseh7/79tcbJWF1Yt5WjtnYK9vmPhTreTc3iq2pVJ/lb+8ftwx5WNnv
	tpNAYL3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzxb-00000002wst-18w5;
	Fri, 13 Dec 2024 07:19:39 +0000
Date: Thu, 12 Dec 2024 23:19:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/37] xfs: repair inodes that have realtime extents
Message-ID: <Z1vgC_5a5srQGey5@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123795.1181370.12023276963649602828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123795.1181370.12023276963649602828.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


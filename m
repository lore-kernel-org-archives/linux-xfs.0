Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1040D7DA9C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848686; cv=none; b=TDZwI1T9ksLPSmP5R7M/7tESqKhnmXt3mE5xz4hCMhQsceMfyUuJyDYcSEQDknwuiNSjXKuIKV3ROZ+EhG9RCBjEHlOi2j2zJX7QQc4lwDe03Uk734gfYDo4lsvzCSE7FpN1GWNBKRuLdgB2F68PmQyfnewiYTOD8SLNcZLYw0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848686; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQSIo7n8cNxUVHpC0UqPLqCGm3peDkrF7vt3XHjWIP0DNLiN/rLX9IMmY3ecxtQkLaRzNzhq7vkRae6JLw+MLfknTmP70tr/w2gXVEUD3SRlL2nJvsIBRc1lLsYKXd6vMvwhYuaZajzkW8i6LXwqGsDcBPADLRAP6TpdHTkzgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ss8fHcWI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ss8fHcWI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ss8fHcWIUdGFFf5MH1A72jivEh
	x5DwjObCODN6sp8Q3y0zwDgd9CDNirl+7Oh2tYM5JyIAjQpyCOSDfInuf4PnG5XrPv6AU1CDqG+r8
	sQPoQtYiYa3HQghOcc5cAeZ25mD17qgwBxaBtyevp9HY55QGCjbrDXWXH8sS0/T0WOp+W+tUhojrQ
	Zf2sjzHKP7xW4VhpZxH0k6BHHPqdxMLrMWlGTw6Hz912Rf1btDAO+8i9mDpQX7MDGR6onHeurSFYv
	njLTmzeX5JnOmjA04sFbEeHBzJH4t0TugmvL4L9J9nF1BhVfYlRr2PQ2MOphKUB7mw9pFjmniS6iw
	E/J0RSEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsNA-00000004szS-2n7P;
	Wed, 02 Oct 2024 05:58:04 +0000
Date: Tue, 1 Oct 2024 22:58:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: don't crash in get_inode_parent
Message-ID: <Zvzg7AKAOm03ABW0@infradead.org>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
 <172783103408.4038674.5358388719134964046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103408.4038674.5358388719134964046.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


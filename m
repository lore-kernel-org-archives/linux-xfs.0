Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A881446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431815; cv=none; b=B6RgWuwkgdNKDFUjbOcgqXjzfzM3Iebiq8oMGvNwHWcIa3k1O5cjYfbhkwbTMpkI42oGlCY1TEnT5anORrB/RcuRRnEWD9wO20a9SF7jO0Ux46ehWuuOiZ/Ph4d+Mf2ennSM/bLQttrGagJYpHdOzfbCazBi1q+v5/e3rNLgOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431815; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoxP9O+zJrDRAbJEWcM/PFepzTJ3bMrcwXDd5Gnw96QmVURh0d3248HdYwZPzWwYVvZYthP5fokvVpUPsFd78DJZwrHEAO5GPIXRyyhupKSq/OOvbUK9jidB16uY6PliGqCpAkljTMEAfR0K9ofEOTrzMDS3PX7quFAzo2uRMaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rYiifMTX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rYiifMTX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rYiifMTXr7zdteHcjZ7Ctj1k3B
	LpS99p74fBsWd1h34mXaIv4wyuVPfDaZfafnYvKsAtQQF0rerL3luOm3v9bAB7Xg7QNxsbeHXgeAW
	ziCdV7qx+ivQ6J6iTvUcoK3nmSEWA/x73KN+qhPVL9Bkvk65a5YWsV2vmBQhv+9Zd93CTCPv+3rPS
	Om2kJm3c52wREr6JPPbEFS+pFOEkVUsYF0pZepTROxc4D/2yfA9EvPtUFGgg9l0myvt0apaqMe5HV
	yYN8qrHk3y97TmjRoaD+8owX1qQXFmltwOrx36vCU1YFevF5RM/CTtVi9Mv7J/WaKkFlmPmNiapdD
	jcAecn0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozaw-00000003AUu-0ora;
	Tue, 26 Mar 2024 05:43:34 +0000
Date: Mon, 25 Mar 2024 22:43:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_spaceman: report health of inode link counts
Message-ID: <ZgJghhzCAKBKfRo-@infradead.org>
References: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
 <171142134008.2218093.11193146609274529471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134008.2218093.11193146609274529471.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

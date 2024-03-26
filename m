Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18AF446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431863; cv=none; b=KjHuwBIb3GYFLhxEb9IDEBdutI8gJGjZjckxeoV+eTtQaipJ5sAAFfbvOh6A02fnDsmXgJ/EqT++uslDmcLJrbNwRW5pryY0usMJA6Tj3VEwm6wP2GyYi5g4jX7rshNWzf4L+5dIbQibZDskGAsUkogmlPHBTZ8qq7bbW0sNa7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431863; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V53XaGGyIvL2JFLAhDbLw6YXIhlcsNueC7eDXRK6i90c0TMDhlhNGHRKUXBbncNfPKYIN57pdKbkQ+H+PiruPOCGP+bO1toUys5j90/RpiEFegfpSdGDG4Anc+E02nul5CQL0YIRvG7/6Gvftjz/OLbULMsnx4BLNpUNycFB1N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VWDpHnDy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VWDpHnDy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VWDpHnDy+qXoqJeziDgx479S1o
	tCgCyZY5IOSeP2b7DwPdOgfx+o09p3x5lnRFv53ZYlyJAW0o+JvVil37LRQoX4GzjhT6Btj3iDHg0
	rEDPtD1b04WMIPVwDh7DQgnRON13llvpeC5URTmExSNe1x7BAbhKTpKElbSciHr+5XLwTkXy8d3X2
	nieuorx01aAWVq8uxdXfAfP/6OCOFuuV0VYK/rPmx1ESn8Q0HZVk1UTYRnV0vRt41grgcGOaYBaA8
	xuHe8C4Dlrc1H+ZjimXsPmoXVPZZUTegU5lg0bJAscM0O5S4p/QxHCZigHhpnzvc7zrty+bXZhfhV
	mZCqjn8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozbi-00000003Ac8-0zyA;
	Tue, 26 Mar 2024 05:44:22 +0000
Date: Mon, 25 Mar 2024 22:44:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_scrub: check file link counts
Message-ID: <ZgJgthIxxgu6sEa2@infradead.org>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
 <171142134338.2218196.12906003001405825233.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134338.2218196.12906003001405825233.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

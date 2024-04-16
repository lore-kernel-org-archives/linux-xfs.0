Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C1738FA3
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244063; cv=none; b=e699B44DFUUlqn/J0OEO9vIKPQputBMPA/z34hbm90o7Tlp4PvM/InRim8M2lC0kyAcAmoRxAAeCWkQfr4+zlQOYcKg/CWqcO1Jqayr3ci8No9DZrBwRFnOs0dLO82hjcEqPvcdHXzUI8eUf3NfbsqyJ1c21QrZA9Wf5PQHys00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244063; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbiDzlNMqNw6cA9jTbTSFnwCK2RTChOtGdjbuFIimzTUhWR/fjxxpn42YvXlO5A6Ez1oTrIXZIfIAaD4gk3vDI64isqZu2QZ/0h2epDluM6hwxvXDSVYhCnxMSYHhQO36iolkmHrkm3POB87eM19uvr2EuhEqry6qHcIlTMjP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lSLkZTOL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lSLkZTOL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lSLkZTOLlzWKUPbxA/k3rVxNNx
	SZF8tkoqnm69Pj8mRbLYtu0ohsji9sKJFz41BqDQ49rMGK1rDPfqVdULPK+a3nSGVqPJpGO8KiY8Y
	oLR0z9xmTqygwTmQv2Uwt2X+OUPZ1XwDY1ayljwCYIcuQnNes/94v75BPg9coWqTCOBJLp7yGZ3x5
	cjDZ1HY/Oj62jfsnzaHPMvR/bS6oAdpXnmieMLGc+ndOLJesYiaXPU2dkDbaje8zhx+g0kxYrNK6K
	Qx6JUf37fYzCc0AptNBSrmXXOvhEh2nzrFej4TBAC3JLCbrAjBT3g2E/BMerg3roT+fIlHZOVACAu
	z9uyZBlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwb2j-0000000AtOp-3Taj;
	Tue, 16 Apr 2024 05:07:41 +0000
Date: Mon, 15 Apr 2024 22:07:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs: remove xfs_da_args.attr_flags
Message-ID: <Zh4HncTSm0j7-Jk8@infradead.org>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
 <171323026636.250975.12612221980696101903.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323026636.250975.12612221980696101903.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

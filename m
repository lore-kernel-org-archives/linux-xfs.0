Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D27329E5A;
	Thu, 16 Jul 2026 08:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189940; cv=none; b=Zr/IagTWlETamNJD6MdMWzRAB0l+OVXE0T9NwhUiCLWht8gaMF4LtIE/ph/BiSvR0B/HPTFGjRNp3b/jTPQFP6ZlWHAZ9aSaSTHX5B6W5wfN0w1IhsAdjFfGnEkZWj53yOwdesbPIae+FAZY0gy/hpM5Y+2f7XahBrlQ/+1SxMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189940; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6AiUVaYrXNFHVY+gObRwhcXiJ/iAN7XxyDns36lR0UplZQqc7O12LjlUhbgGetoLEX7p6Rimt5lEZ1vliEfr9RrBfzLl5pCJNQG026ADearxNRoDSWlS/NIGYWP4cyrckwb6tAqCMB073kw5p0SifDM9sZGnQpCI/6O3ebPwnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DD0F6732A; Thu, 16 Jul 2026 10:18:56 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:18:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix transaction block reservation in
 xrep_rtbitmap
Message-ID: <20260716081856.GD12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797403.2008054.16457221917569138909.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797403.2008054.16457221917569138909.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


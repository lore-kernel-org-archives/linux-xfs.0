Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602E2AE95;
	Wed, 19 Feb 2025 07:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949173; cv=none; b=Snzw3/qtochnGacdDdujc9CmUAWkV0KBwkQ0f5V61zTlmlnglDDIrUDEmuJjefwp6NsNqCe+G3TBSz1acRVHo6wg7af53pOJ6mlpK9+dwehX6IQwzKMFq7uFDwAbShWDA7b3vYPL2EvF1KlvDKCuDSxkz+nuwJNkyaXT/ANAy+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949173; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLA2bM2CgeK+pmC5+rDzO/2rSVftdZaEFfqawxU6NimN177gsxg+8bf2rhBQFhDh7mzzCXIQaokR0LDIxLyWolv8zf/mzcnG6qIuG4CZoPEeKSL3TDQ9btfMlz3FfQZA9nOwNQkfgkSqiAfsPHMWOz27Vwf8UWeEviFaNTANr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kYnFy0ao; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kYnFy0ao"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kYnFy0aoY/fWopSjoZi5qlDvYL
	ywoMtpn+NXiRIz1tVWhidJ/mG9/ipR6znAxRciFDHBm8kEzXfd9pmdDIx+fZM1ojbvyhNITwfejFi
	m1I9g4ONhGbx0kyvLn0wj4EclF09oRgasxbGTqUpmsIQKqHmNTF++ul2eFHYav3n7+VIGav+ONTjd
	fD/RHvy7/UkWsTuJMpFDrCmRx4ZTjrwnh9xZPipj2wYwEHBf+p3hU+CFJqZrqjCP4o9J9RVF7StP/
	3AyeNrwK0DVPdsbja2QDLlUYsYgHLCuzHLixqv4nuHg9BK5o1o79KK74oGf+EVFpWSJ2o/U3MElMi
	pkSNiAmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeGK-0000000BB1F-04Oo;
	Wed, 19 Feb 2025 07:12:52 +0000
Date: Tue, 18 Feb 2025 23:12:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 02/15] common/{fuzzy,populate}: use _scratch_xfs_mdrestore
Message-ID: <Z7WEc_KMpNE559Qy@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589216.4079457.5690934779911954776.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589216.4079457.5690934779911954776.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


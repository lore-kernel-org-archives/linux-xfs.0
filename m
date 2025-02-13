Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8F205E0B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739421012; cv=none; b=oDkQG3cMzkr3xcQ6CqhWIR/k0mtQr/3OxcQMoofyeFvk5rFtXLxZ9IzJlat526Y3fA4qgrZyHvTT9pa6Q9OKGCmVGUFvVF07mWTzl7VftHbtdU8MARBTpfVnrUVm7Bw2qliaPF5yZCNQlbem5TvwqtmI066P5IuXUmizaLsWCz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739421012; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7oMVbiLYihAtNOf9xv6EgJVZdmjR+uEiDbxN/NB/+c9+Ea+qi6s0HrG0E9i8yD/7e8ek01yINZ/HSpj4QkWiXtw1+uPPBL6J1J7d9E0dtdQkeGb49B4EoecEPxAqoxaPGQyKFdGaO4Ylakk804ASpO8KnYWaHYrRN4EMUaYb1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=omnqYw8j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="omnqYw8j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=omnqYw8jQ7hiKrIoEKkCne5f2c
	B/1v58LUrdBGhJ/ku86ePGmS9zsM8vM7DttYZhyQLZnJWP0GAK7eYdhn3dZg4L6zjL5ef2qFDLVOr
	AphH2eZjMlm7/kp42IG++VOi7NAnccUbusZ9Gm8oZLwj8NJ2A0htupeZQ4EMRoGq9x44T8kHTUmQk
	xBWNf9wkvrWssw+NmVYpgY0S73MXovg6ScMWcNnCKvX1zD91oWuKaMrZsKs3gW+idnuW6241vu0R2
	GIDSIsAUK3D+7cVY9K2atwoOVOD2yVe7HUq95GnIdhalXKmwwPIQgN/5kMnfnqnsSklu7gZ5Pz6+o
	PjApB9AA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQrb-00000009iji-0FW0;
	Thu, 13 Feb 2025 04:30:11 +0000
Date: Wed, 12 Feb 2025 20:30:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_db: make listdir more generally useful
Message-ID: <Z611U46mZbF9Dm9b@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089649.2742734.4268130787597232707.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089649.2742734.4268130787597232707.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


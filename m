Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2789C17542
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855481; cv=none; b=ZL+VEZfOgaHsM8Ld9UxISafq5kaq0huNOL1H2fzUnNso/TlB8cUgKNpizslG+jZmf9XovKKqVtAuk6OC6Cg9J0VVqcDI8t8HxN7v6UPx+AlDMLoCQP66J/ow5GRjj/iA0xeYUAqP2/geeeCp/SCwcocEcDVtR/1wAlI37EmJZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855481; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQvn34gWW+9E9ZPZ+4oaF3cJ7pP1cEniwpq2KE+l68NouXqKgCWGQqMh+ga6GmTfdry1wKjZlASnMnJ3I97OsBN1DmOFvHoOTCEhJQ2pR6jRgstYmgf+M/X8YEf+vWiz1SsGgQo9WC3DchwsZFpVqQ1mpkonocPajWWP2hGPfCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3F73qmtQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3F73qmtQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3F73qmtQ3tnrKCVedYLAiUXPe8
	JqMOwaWoWDlh8RtftX6VH4YKygT+BlqCZ6/skrsWiU1ZzbRbiP1Xmfe2Qvi/FLk3wOkJlrfzbVZZ0
	RdnmcvvbMlEwCaBGmjJX0VyljLKgHg+OTFfesAu7CMnO1KLw0eHqJ8p4u9sE1Gd4yDpP5vPQiMxUR
	pnmxYJihwwW+aMJjSA+j97dtSjqEUg+VoYL2RMQ5m79lhVJDHWYm41fe6oOcIGvC8Y90NlnbqDCXV
	5vv8T3OezJDrOSrS5REJbQHNf4htaVA+l4DY1vARFfa8CoLyaSX7HceYbeF1BI4ZQxzHTRDjV5lx4
	Es4Ivgbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn55-0000000AQpq-39Fx;
	Fri, 02 Feb 2024 06:31:19 +0000
Date: Thu, 1 Feb 2024 22:31:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: port refcount repair to the new refcount bag
 structure
Message-ID: <ZbyMN87_dtCYNiXo@infradead.org>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
 <170681337921.1608752.15139847768666002180.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337921.1608752.15139847768666002180.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

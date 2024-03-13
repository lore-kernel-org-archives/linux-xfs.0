Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E54159163
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367480; cv=none; b=Drn2LtQOMLMqaQYipn0k96ajlShpY22BdXguaV2CZ2hANCnFBNlougaTmmU1Ph3s8xjlLIa+1+kF+6zq5Hle+/L4KK6oDrC2Q8joGuNr0M6C6fn+4eAmegqgSzTNJtShRtM9oP53aTjX3oz1b0hizEKqLmnmEgl7eQ1z6gdRfZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367480; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xv39CWJH2DVKdy+WImlekk7azvWNi0hUJ4xzRzGKJQuFWMh0CmRgZsRgSVNddCIL1mHkGhYowm69dZbXdBnvfh9AMXMUkduWzsWKieJvj9p+TwTyEDKGWSDimZ/v79G80SSKw87t1LwN2TIyQtAP9LqvMfnm37DtFASIHl7+AEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JMnZYXpm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JMnZYXpm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JMnZYXpmg6/Z7fMjH4F5YPuZmv
	YKBne1oZdv14N6Zj5x+Ag1wDbfUMqqLKIUWF/T1Woc9d6r0sF2dhrySnOV1N+4aOSQzuNSKEcBPm2
	KtKIvlZMZGMWt8UuD0HzmACobIRiu2QPNMdR1UvJRsa/2l9ixn7wVM6MBvMctmQlBkxhGEi0E5yUI
	VmIIlQEO1QR3jcNNmjYDPNjdHLHaWeZv+iv/8fbaBBu95mTEcmJa8Aj1RegjFgpjihuBiXKEF8Fd4
	J5+ng5J5wRQ/5U1tLqKnKCrTBv3rQK0pyE8LAxfc6yCUdLuo3dF5puZr3t0F+vfUC9yHpa4z5MW6I
	7yzJK9gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWiE-0000000C4Fx-2NDy;
	Wed, 13 Mar 2024 22:04:38 +0000
Date: Wed, 13 Mar 2024 15:04:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: bulk load records into new btree blocks
Message-ID: <ZfIi9vU4jdgik632@infradead.org>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
 <171029432531.2063452.98834952088069975.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432531.2063452.98834952088069975.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F9638DCF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390109; cv=none; b=NVwmkeFvMndpeST/8kRUN+T+yYPwUFc3boepHYZfrhsTNZVfN1537oShl6Y03kot/CCsfBRyYfuDg9fQtkWV/WJjF31yOvaWMqWPuPFOc++nX80mc5vdGI5akMhS1TExnni0PLSENaG1B3mI4wsJJJH6C0Z8qFromIGdDF/sdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390109; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFDA5MBDodCOW9XfateKBKnhE+DCjkK/bj6rQlwO5bqu0TCcvSE+82G4xWVpyQF6sF0FynKWzP9u9iq20DZGNQCfggK9qasx6Hhn4hn1DxG6XqyU9j405SvCd5VCGCsqPPnUAf/jVZpd9VR2+R6tp8LCrdCMa4puDgHrkpCDdeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jXy0pMlK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXy0pMlK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jXy0pMlKW6uZNQR17lBJ1dudwR
	UZ8VrrGUJa8WF9qSPORUR0N0oDZi8pjYCWW4zsnhaT4H2t58bogKKk1lP9XrkhvO7MRBSfjLJXyM9
	23BhTyHLeBqd7Em8P2v07JT6JS9gaODeeZF+YSum4nhOOZJWrTR3SAslTrGyPeNUyMPC3MXmrMf5M
	Lmc45HAzJMoazBasipFBRy+HwwHY8m0paYcVNyTk1zfqpjSILoDlGt4sk7OJdlrZnHZeW/KxoBcCY
	TbF4SfPqLQWF0iJb48JBHkLO4fs5VHOoDs/fvhDHtfvq3K9OZaFHVV+K/HCABjoZGGHU1MyF9q98j
	DPl/yUNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMdf-0000000FHB9-2eNj;
	Fri, 23 Aug 2024 05:15:07 +0000
Date: Thu, 22 Aug 2024 22:15:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/26] xfs: add block headers to realtime bitmap and
 summary blocks
Message-ID: <Zsga29QuAxcLDvE9@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088710.60592.14084013825936440220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088710.60592.14084013825936440220.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


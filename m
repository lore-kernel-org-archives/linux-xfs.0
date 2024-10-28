Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3CAF9F8
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104385; cv=none; b=Yt1CLsDwrrpn1mepmrZBGJ1UyPqGEWk3/RHxc+GOfG2S75oAWq7Tu2D0PqdLMOvBrgGY05dByfRB8Sjgr+cTdDQi7v1j5uPAKIlar26s8pQt3FvIo8Bwx4vokG2Fi0/3s+8RN1XU8nTnhjEQqnPW9/x1pXL+XxG+Du6LOHrwJOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104385; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtWryADWUjqGAP0v7825v+/Adnteeqpcd4HajnEPVWZVFkgwncQgh9M/EXGX0UBIBAzmAPsiARYPjKpgjBDah6toKFFDJ3dBGxKBGWLFhLFzwghIfVAj6o1c8w63PlTmFVg7d3a/cCQC6E/5D8wRfxXBh78kHM5n0Osdthgsi9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0i5t2duQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0i5t2duQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0i5t2duQEG4V7foGjbAsdQcFr/
	YW5AweQnXTUmxkWaQDSXfLP2+4pOMKUYt8xIivNKwcMtiGudBcdQ33s9aBl3Ci02NzLI+jT/vKHro
	yisdsKt4Q8YJzoqjOJDr1dloe7gjwBAd3OIZrVNT//2pInLBwMuqpWWOaE3WRSOvqXMTspm498Byn
	X3TIWbo/tK9HrGTyrZWIKkSHiUggGEe2heNwgNzFCgdKlstpXrjxGtW2Gzf2P9nc9B34CTbQZbTc4
	Ef8/CbBK98Wypfhj+oe3vYDBD5HjcdyeaQPll9iN1h8cOtgKMGOmAPnHHD/QcmPcmhPaKJwV48uQh
	a8LLVqbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LBP-0000000A6r0-3qVD;
	Mon, 28 Oct 2024 08:33:03 +0000
Date: Mon, 28 Oct 2024 01:33:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs_fsr: port to new file exchange library function
Message-ID: <Zx9MPycfS_83rBHt@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773405.3040944.316630518119574344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773405.3040944.316630518119574344.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


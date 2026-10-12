Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BE2374A12
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811198; cv=none; b=tTxWygN96aW1KBt42u4E3kzPok78Sk8XT2X04dsqbJwoUBZ9uAtQr4aud+04aQaTnjitBCyfwTrF8OXTARlpWbyohEMMdFOluy41P62Y1jkl3ZaT1UykBZCsQAj8IWFPbW307hPlujKhkzk+EZHQ3Ey9hRQTgl2qPpjTQsra9uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811198; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa6J8bnDEq3mOdo25T8HiuC5tRuYaz5YsVaCrm07tU4R0ehlO9fxV+eiNwjSUmoSo3jFjiCnyfV17do8HSUsfsTklLjWN6pxa1JbhPRkvR3+DHP6lCJ5Vwiuu/nQW+bnjkLU825DUDPgu2gY6BYDIxBfqrnn7N663IRP1jnkq1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mlXLewQx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mlXLewQx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mlXLewQxzRtvTz5aIwnvgf+mhQ
	zH8E4y0e9dsSg4gNUocc9S1u1pUQvKwvx2V9TCg5q/VrztkwlHIBLq9fg+yxXxghwlkZFdwtGpDww
	TKMYARXGHFjw1GEuIxd1tXHlz58fIagVYhc+m5J51R793ZZ4rZe0r2KvLWTsph4CpwtLNt2XrEWCd
	zRL+Tq/39+9IztauTCZmi8Oxga6pEtPVLLcN5d6UJCMPXPWvM7mHy5UvtOc4WXZrHAM1fXJaPOwpE
	TO4LUoXy5HfR+uqVQguYbQkX7RkiesXm6DWghIuphYyGfRVpsvDn4OCCzYgvIbbeRA5GlfVLNcFFo
	6Kv/2eqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFwa-0000000AY9b-3jUB;
	Mon, 12 Oct 2026 13:19:57 +0000
Date: Mon, 12 Oct 2026 06:19:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: refactor inode forkoff to byte conversions
Message-ID: <aszefKttSOFFMNzn@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178066061.1058822.13853695617803714523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178066061.1058822.13853695617803714523.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

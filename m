Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC1D356A3C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990758; cv=none; b=YdJ+v6B0B88z9muVnw0yyrnOTWJwz/0ZuxXA1/ovWo5mbmmp79sDF4QQpqZIrtcp9bwMzOPvwjVRY0+zoAoj0lUbvfeOcJ9QG4Bwnq5ckf+2yLiTdb3KkgVZ+EYQisDKLFQXfBrsNxhictp6Z7W0z1ShjzCEHrySpOt05S6kAKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990758; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaMa3O5VAPoHwZF5IE63HwlhHch2goHcgVX3RBRM0JwfWGqqRW/Im/HO4ouSN3vvEehjtGN/b39MHbByfAVtkWBY2S3ZSdcTynC4ULEVUxq53AfpI+YY+K+RTRnz2KYLE5pBEjekn9OaFmdh2DsZ9tiyrfZpkxaPAsM/ZvjTY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xoNwldDO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xoNwldDO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xoNwldDODwei7FrTzFeiwmLWcy
	dd5MYUPIblnmpgS/KzR7DrtZhohsrSltbWX0QYISxAvwzvp989rqlAPfecpYJ3VyLwngSkKAQ1PQI
	DUKl7EmYa7QiJ0PNl4lNaAN6ecIhNAUnJp4nKtpa2fPdsHE5mxRpiUHQg62XiueWlWafK39M0o6oZ
	AyMeFnPtCWDjS3KbqYqMJUe71ig4XlPtvA8kxXzDz+FhwN0hoB8VndISF0xwasAc2M72atOJbaKEA
	kqV/jLI6OHpLIVE48d3jXIPe/GDXImYCvPygNzL7MHnGbtJtdi2RBm3peU1IJR/UsoS5UADQW3gVD
	HsXYHRMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U27-0000000CDPJ-3ZB8;
	Fri, 20 Mar 2026 07:12:35 +0000
Date: Fri, 20 Mar 2026 00:12:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/22] mkfs: rename byte unit conversion macros
Message-ID: <abzzY0vv2TBhoLn5@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389506977.3681140.16696878706426311389.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389506977.3681140.16696878706426311389.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185D22085
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730029; cv=none; b=KbleI+fQIMUgV1VPhfNdiLLZl/gcf1E7gtEVIttbJxgOTFyx+wc58bxSjkCi/hZ69rNyTi1uM07U8bf0gC/52MVXu0lYXzU97orpCKfxUO54iBVL8y18QxoJWqqQz6boQ+p9afQieSi1OgySKH+UQ3zkach+ORbBWDoSMEM7DGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730029; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfBraPnaaRqbkkWciRGsRpLQVP3xdFogNeLZ+7P5KwJkNUg1IngjEBgUaQ8wyt5C8g4hbozBCCIc5W8zCEVj0LmEs3P3o+i65NTXQfOX99qwHjVxNy44MAyWXraDJnauaZIKF7a+61eh5GhRJmHZ0u9LLDaJWYzHfgeLY/r6HRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kwIDMvAn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kwIDMvAn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kwIDMvAnTSNdORxCXgHP9gujnJ
	uT0bXNnOYG45yjTy8RuclTJiUMyk/bJEcC3/G1w+EWWFuimyxN6KlszGjpj8J+jKDS1v4WoaYRfgT
	ocXknN4GXmoxrDlW9aqK2nlXHwovGvnPrS4lUE3nG/JeEavgUClrWvNVvN3kLIGo4d0UBDmY3xQrP
	c0r+x2+Mrv4lENHd8T5x8xv0/drdT48I8ZrKIaCsnRl6N9Za0vQGs7J05dmDglGFlbn7+BNMTIiOE
	bJK20XQ2DnLYRMqWCib99F3hU9JS6plY/xAsiQjyLb2yTykB4E+bnvJqRTRS0/q1UbfMAVBpc7GZ8
	8GAM9Mng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRJr-00000005M68-2MOO;
	Wed, 10 Apr 2024 06:20:27 +0000
Date: Tue, 9 Apr 2024 23:20:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: implement live updates for parent pointer
 repairs
Message-ID: <ZhYvqzYJGuPPM285@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971103.3632937.380180446982719145.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971103.3632937.380180446982719145.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

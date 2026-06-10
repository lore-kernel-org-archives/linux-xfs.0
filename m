Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046B406802;
	Wed, 10 Jun 2026 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781093619; cv=none; b=uhgVBrkcOFCrpd//Gaqx8zSNl4FoZ+MP4UafX0kqqSNHmANDJqVMN62PDz1Y5lwpNBGzw0MDO+NGvpq5BkHbr3ryXk8MM4KeJMymRkz0wRJ/wXqY9AFZ2Nu+p7ChUYizT5lGuGhD3VFyRegf21CIfXeaA2ZBxra/cwCrpX1dj8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781093619; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS6PmksGY56L0hHSu2MoZbL15b5Y0wjRhML+biTVgRExpSBumeBAX0KgM5lqcqb3RgfTSnDRIcCsiWY8yfaTODRM8fUObxaDOQgjkSX7Up9G0/D8UjmemvHqDNCdo92ijfQYAl1PddXrDP6Zgy7+AR57dL8NwKOe14553rLHv4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZcnCpRSI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZcnCpRSI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZcnCpRSIxLVUxvOdP6JfYFD1lD
	QAnbjQtwr8soM4R4T2RsKsN8vVR5zPjn3PfSsm2zhx4SXqQJtNVrTbF7npDdG4y0XP4/F5vR8RXII
	4jlhAEDMCPMYeVKJXhu0Sr+zHz9TVR2vnmJevmSVrQ7eS+4DHg3WacvPoJSjHx8YKnKNyNs7XSAmF
	FHMLkvHj+r1Cdnu1yu4JQVt1y0FM+3l29Kpe7AAPwAprIFUzL9O5lZ3MfAI0reFOTphUgxNaygRdP
	cUnxLcghosBxg2V3onAf5oHl2rFYws0EKB92+4URKJu+/M1M+25yW1m/nYfEAHjlsuk8ikllqW17M
	5Mx6jg5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXHoP-00000007cja-3aqY;
	Wed, 10 Jun 2026 12:13:37 +0000
Date: Wed, 10 Jun 2026 05:13:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: cem@kernel.org, djwong@kernel.org, david@fromorbit.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v4 2/2] xfs: shut down the filesystem on a failed mount
Message-ID: <ailU8bH_D4a4b2Uu@infradead.org>
References: <20260607183026.37700-1-m.lobanov@rosa.ru>
 <20260607183026.37700-2-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607183026.37700-2-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


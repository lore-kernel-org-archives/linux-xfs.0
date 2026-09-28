Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6A45D18C;
	Mon, 28 Sep 2026 08:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583027; cv=none; b=bB6PMDDKD7OblGTrPNV1mdhirblZZqxJpjTH18DSchmYKPMxPi79uZ7kEWNpUnBlRtGTdo6Cx98tXD9rQHqtSd1r6gZx3NJ+PAY++WJGZXg7/VZkZ3DPGFIxLa2iqcKUK3GCEFG2T8dUhoYmq2IVuo/lWsLktoB59QDlx9NuQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583027; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJaG4qnktIvryUP5Y1MAP5hWTo8fbFHtBqjAm9CFxwAsNoIA32CajcVWeABb/wT7cFwjwX2csI+/kU7P8KjL0EG0oXReXChsYArQfZaQ8a1aeIftdukFiKirk9nFXmKuHaEx3nucs00GOr43PrC1oAxnf50bXbI2nCVVlcR8Ej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tMVIYyTu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tMVIYyTu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tMVIYyTuohG7XB3Yb3FLBusGHZ
	oFHRELEd4KyHfTflbg25Jn9dlWK6N8n/TfFV2FdjgmV6jFnT8Xqjl43bkvB5sT1Xqwn8niP/xV6UM
	QKTSiQ6T27uBGNlxn61XseVUR4PT28yXH5ltyFp4m5IRqM0NEnpLmvaBNYiTcYNFaYEV6jlmJhb8g
	rnNWNx5JkLSLSPckIJvKALJEoaJV60+NsJ+dBg+5xF7hHSEuuHaDfWFWntIVAfqkEQxPkvh6WAfyf
	8ukbrj82UdDEh9FXLqL5lKq++FBIWkPTJndCVY2hzcOWw3g7mwNWuHiR7Aj7UwgQ/elILFToRa941
	ITTNkSHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6RN-0000000023M-2sB0;
	Mon, 28 Sep 2026 08:10:25 +0000
Date: Mon, 28 Sep 2026 01:10:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: don't proceed with xattr repair if the live
 update fails
Message-ID: <arog8X23S3_BuxiQ@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612830.479634.12263440837702460390.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612830.479634.12263440837702460390.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


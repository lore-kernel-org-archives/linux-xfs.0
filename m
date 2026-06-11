Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C621773D;
	Thu, 11 Jun 2026 14:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186435; cv=none; b=ljEkpfgSoi3ifd4oIOHupseLN/MDGv2IYLkUbR87NKh5UZnUOL9NguJlz8FC/hzzgucIoq7McvmDKLjcz0Ui6vv/adUg53SIgmtkhnrYWTRWFqtLyUXgb257nQTyZG6IHjobpEv7Rg6pPaWQ+M0Ck0ey+zB0oQG/6jYZv5BsDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186435; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXQr0S/bG9gYUAWWOn9KvKcvqG502oVmYjCXs7bJmcbLPVME7gU+kl6f3QwAWCcG4m+KyU8oX+TFBipoWBHZ/u8N7e7mk6It9rM1+aHcqQppXSLiaohZRAeygtm5P4h5VMLGryxbXTuKsOHo6hx+LnnPvI+w2g0fAL2XVaYE6Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3aToPFC7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3aToPFC7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3aToPFC7iDtF0PDyOerIzrCGjB
	LdK8Iz8jgR3exbBwu+mqTO5ifT6eNhvHTupDMzTw2oC7eGzQeVzjKxoV1RBzZSpnBojPtnjHhWsmm
	ujIWvZ2oGTlSj1Idrr++d2jkf6IpYoTGm4It+zukcc/FF1pGc7ldc+fTdLmXuMCKZ49r/aHXAjN6O
	6mRYbwthfd6cAoPgOsSbp6aCmqsFGaHcx0CrQnTZvuWD009+M7OeKLBI0we8o0845rwOP8u/yIQu1
	3V1j9CC9PDNtYxrQW263DHDBXuLP6ZfOdWfBub7yIAzeh1N1UB26ocxnvAIFMhd5AlJvS1ICrguy0
	yzIN2jCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfxR-00000009ZE4-0nW9;
	Thu, 11 Jun 2026 14:00:33 +0000
Date: Thu, 11 Jun 2026 07:00:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: cem@kernel.org, djwong@kernel.org, david@fromorbit.com,
	hch@infradead.org, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v5 2/2] xfs: shut down the filesystem on a failed mount
Message-ID: <aiq_ga-tmzGwJ9YP@infradead.org>
References: <20260610191904.12533-1-m.lobanov@rosa.ru>
 <20260610191904.12533-2-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610191904.12533-2-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDE4182DF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390126; cv=none; b=Nn/IrTu7h5GvXrOj81HGxBjQkTlMV0dIjhfxsbV6uTA2M0ZC8IepRBY6AJvnfr+MbjViyOcJTCFQKxnCepALrX8j5U+15jpkioA8qpjUglTMt4pUiKVQpuDb7ZXLw0rpChlA0kFj1dArvOJTCpYV2aiYQ0I1EHMf/xvaUf8D6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390126; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dl8VyrJoCwapuWpLblU6qVSWPPfNJlNdyKbFIvedRIdMHRWyXhjXycrTbVRoI88zzrNL7+LdrkGesz1bsdi+aeJ53Ot3CnLvbwRV+H9ZMqiKF/JTerOWBrlVrj9RgxhinJHkhYY6yt7pBsYhs208W6oT2qY5FxZKjTyrmZzSePY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uho50h/E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uho50h/E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uho50h/EQbyUDZBHPtieqxj3Q5
	jMA+d2qwmSqpUNtTlQs3cxL14EadiAQ8jhm1bDtKgmmaaMGYiTPVhGuaTNS+Hwp0vxGxLW3NGV2xe
	2BiSFBC94YD0E5Lqp0oe0xWh+MSmDEQj1gfe8lXZIh66QcRPVXDn70dxtXTDfGG9sdV8drXybvGkb
	wuYNtzdVUEIm8TwM8TgKMT/YCaFE6UbEJOvUX0FxB+hGgG7Oe2AMfUa4A6zlTHjAVhIV0WsExJuz0
	A8JDg9YO+bhYp0yI0PpCqj/j04X1iSJgL27ZiaXWJ8MFxvTQDVIX4sSwfWroUB4CnnErRE+rnLMjR
	6c1SSCzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMdw-0000000FHEi-2pro;
	Fri, 23 Aug 2024 05:15:24 +0000
Date: Thu, 22 Aug 2024 22:15:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/26] xfs: encode the rtbitmap in big endian format
Message-ID: <Zsga7JDvuSJVm4xq@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088729.60592.727533950842079798.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088729.60592.727533950842079798.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


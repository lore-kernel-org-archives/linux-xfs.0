Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030BB54BC5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602664; cv=none; b=lvuPWoe6kL3gHbxT6sjnnTO+ppmYuWhsyeGZ88BvWz/gvlgE5FcYbxlZNvFOSXlMXQrs3OJ7AMsx62Rr64np08+c8DDRZ8YCNa8/IXQBisg1i3/2U5kgd8sYGOXqEZJy9LmxYOheO6SoTwD/ITi2Sp3mJl5lk5gqVfwpaLwLoe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602664; c=relaxed/simple;
	bh=9VHgyvZe7sdSkLMnFpwCYSUkWBe+1vRswBQUclfspAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHwSiEj1VFfDOTBnA0t+CR7VylB2vNQhwCUuRf4JVt39wZqthzDvDnjy5XXXWMQy2FfnbtFpkKbTJb4hozzdG+0MrnzyyIXaYwUjsUITTwFICnyeDPX+1+XqNmn4BPoiDXkL1iHlrwVfLPxPXZgb77vYu4ETEGWNXQmP2NAXZx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iDmFsG5+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iDmFsG5+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9VHgyvZe7sdSkLMnFpwCYSUkWBe+1vRswBQUclfspAA=; b=iDmFsG5+X1tdPU3DeflSAzvhjp
	r2fIC5VIfOxBi19z0otod3fUJ+G87Z8Gg1zOS0E+MRGl6T//yECKQMdZpvBeTG5BEWsnkjvBQmSkZ
	vrnMRWHXq5Pk918BpKQWKOVrY/x1t9zVjfZjFkk+JFBmfBFzbEVJn2ZrQKo3pHzALwrjbUOdk/ljr
	WwrOY4gyUR4Eqav2XZEND8LbRvBQPGebjDxCCXtGgc2S3MdrM9cNn09ZDdErzx5z98PedwJlYMzOh
	tb5IA0FIm06IzkLpHz2oKZLu8j7zzhEoJYUMrfRdM7tHig3NXPTUw6se+eso22qFvhxnRQcUa1Hmy
	GUQjC4fQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjJO-0000000FfQn-2RCh;
	Tue, 30 Jan 2024 08:17:42 +0000
Date: Tue, 30 Jan 2024 00:17:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/8] xfs: create a sparse load xfarray function
Message-ID: <ZbiwppH8qJKvlbe4@infradead.org>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
 <170659062818.3353369.15735312742710633221.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659062818.3353369.15735312742710633221.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good modulo the naming calling that is completely irrelevant to
anyone trying to understand this code in the future:

Reviewed-by: Christoph Hellwig <hch@lst.de>

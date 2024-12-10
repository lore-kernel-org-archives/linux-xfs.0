Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CB979FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808851; cv=none; b=iNt6dIiS6BV7C/iwERTHNXs9L0+pRTP+hFISxgLG2p45HYuctpL86EZ/BrZ6YOjPpSwl685dW8XYqUWGtU77w3Kxjs7Fgd/9LeLQkpqJIeY2LDlmALIFLP91WStxo7Mq7XrSq3crEwbm+L5Wi8Jj1Kcj45fEtL6bPwXQT/J4rFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808851; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=natL4DmSsCEVhw5HihRB5l4tWfp6/XKpqYBE6QEHdOWuJ4tIpa+U34BBHrIblljcQQdUhQmJ+4psvqIq2sU6fq1owBkdepVT8m9rkFCT6R7pX81NtjdDdkjlGPe/4QiCmiJJdPJD4e2cTbQ/3DKb1DYyGOia+RUmOZZ4Qmdrpmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a//aQN0h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a//aQN0h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a//aQN0h4HlRZcowaZhdV1Rpt5
	KL7RXahjSJr1xTaX9u7uUWjzEobsizDYROig3wo/MTAtzxcuKnL3DzN7uz9avtOna5QYUb01M47r9
	eDdykVwv/iOiMxFxUg76OCr/tp/6q+cuJbRW9Gbq1Yc8NrLSh3gOG57kHiC5M3SXYsIAEynn20VJF
	GlFiuOqVgmihuVpUuj1BMeaiZ01O/P8QPNuaW7V67zTd6qpi97WNTZ254KRh4N887TE3pUdrtdVsB
	xN8WvAYbg+VFwSwypx30fYybgRHtNXqDk7fPeIhUSXMMZ7tkpAZP+vsp3G3Ib+eQmfyaWgqKrp+Xh
	7wn4Gq7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKssr-0000000AI1q-2XU0;
	Tue, 10 Dec 2024 05:34:09 +0000
Date: Mon, 9 Dec 2024 21:34:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/50] libfrog: support scrubbing rtgroup metadata paths
Message-ID: <Z1fS0Stb8GSexuXf@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752083.126362.5682773152874800985.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752083.126362.5682773152874800985.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


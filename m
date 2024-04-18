Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC3C53AC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414262; cv=none; b=pmrU3Vx1o4iLXscKxvQcSoVRgut7Q90j0/wF2skaF2dQwZI4NXXyX4xdoYTYpdsxRttufvspD4YTKStPCE5Wf3V7AOmx077uQ5U7NR69R6ackSAmA2QUlm0GdeeD/6r6asPQAwIGWSgYpkB7tDRHj+LCvY/OZI0YKigy93geebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414262; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1HYXAhM/kIocz3y7A+lmmJlu5uk6xqc/dsgJnvF8EtNv0mUFtf45RFk7F7YdnDU2aBdzvZ9GaGfuyvbSxOFZlvXTYZyespi4rePKXYnQcqpGJ51BWzLRIpx77FgVODn4nYXxmXOSg0Uh3cTFq0m75JTuvtd6eWVo7YnZ+CxcEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KLLXeFT+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KLLXeFT+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KLLXeFT+y44pnRSa5oAMv0YqXu
	rKw3mAAIP7j4dq2Mp7Z59oGJrIbz8Km1AQ5l8ZXvUUCxi5vLGAYAJtlbFs49iZIy0TnGYI74AA+8d
	ip3HEaa0t8SKtJqh0iazlJT+7gn7uGUYZTobF5bP8TxKqX0Fn7g0Bz01etkU8Tevzwxw0JKL3kN9j
	ULn5tT0GFdoF53u6P3oKTjeJ1TB/XFUKDAcuHMzBGRx+zyHklSE9P3sunQZASBV7mc0PH5uzIAX5d
	DEwe9QFx6JipNUt29u+C5CWXLPcGlQvcijr6o/2DNSgW7spcAjThP3U0RXk2CFwtzrl5kkxWiY9tk
	DGcJJqeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJJt-00000000tM9-1Yyo;
	Thu, 18 Apr 2024 04:24:21 +0000
Date: Wed, 17 Apr 2024 21:24:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: exchange-range for repairs is no longer dynamic
Message-ID: <ZiCgdSv9oUElJjlK@infradead.org>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
 <171339556011.2000000.12744010747635397134.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339556011.2000000.12744010747635397134.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


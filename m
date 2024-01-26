Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FEA1B940;
	Fri, 26 Jan 2024 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276079; cv=none; b=ovVNetfJNpHeUqWcQhCgNaxFn7k7hlKPvxWH1O37marfDZbQY+/5+/kbrKz9Ab8UlkUPnxCVPAuvB75E+YZ1hyjSfJf73krlcb1IlsOxJGPRRqjlYvoAB76AJs5bm404++bCnfn3WyAOqxXC5vB/7qT+5I9yXTIIH9dNh0AgcP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276079; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHhKCDPUH054m7vW4LKmkpRdNxeoKlPM0pV2RVL4IB6OVeAz3nT9d0HO/6Ie0Vcgez4DvlmElRLzr+mdd3xfybtT/lOi2R8EPPL+qMgbWUm/S2YsqAEJmZjF18JNmqCefXhKHOXwLuSFBNFy1HWBcIj55lYLdLPilX5b4dlBzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I0ISy8qd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I0ISy8qd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=I0ISy8qdDooho9kUg+T7PHZqFX
	kLfAiGzKcXGcMyKaCj4OHrfKL7NQ7v6paIhEmfcX12QnuS21m0V0wje25YkRCIXuLAgWQHfwt0vys
	arkGWvxVAPWo2RwKo7w7WOX6V7h1DhAJ9mo1quMDZ0ErUGSy/EEv8yJsoo8VF5oYgi6+yYSkjuCn2
	c5AlTr5PyFzfkR2IddDmAtrB/Te5bR2P17KymRhCKkHpFTHwNTGkuQiyK8IoOlFFFn8uX2MlrY0MY
	ooMrQpgThL3JC5pPWYbiyGXt/3JV8aiCzV+Uv8PQy5f0MizRltSYIZbSLMFI7AyfxDsVCHAiCkaTX
	xnz8NwWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMLm-00000004Dh9-2hBa;
	Fri, 26 Jan 2024 13:34:37 +0000
Date: Fri, 26 Jan 2024 05:34:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs/{129,234,253,605}: disable metadump v1 testing
 with external devices
Message-ID: <ZbO05vRQNGkMdAHT@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924449.3283496.4305194198701650108.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924449.3283496.4305194198701650108.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


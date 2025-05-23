Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E971FF1CF;
	Fri, 23 May 2025 05:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977195; cv=none; b=DWBec+6xV8RHsXAVebaAx68gKqQpZcOVcUvoCiscwA8d5Cu8Kl5XdyX81oVeZrYgSoncgGdmm8eu9cI6zsx/k3UjxsMm8vgGS6BmgLTqk4dy0QKFQxbCSAyrQ8ZbkRUG6K6e8HN4dXioej1QNS+6khsIzMBkLxTXRaKWZYxpe9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977195; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2Vzja2VlzpULiNwZV5QxiA49Z22qhUGCFBlYyFVlbSaXrQPoAB6hRTiZygP5HLsrgazQ76qRrn3HFTZ2eibqRuMBet1ZWHjce5VMl6nq6XTAHNVR76Iso1JAxQXe5/88vBRbhw0G5Fh/3J/IWjxaTcFzQiHOLI9wJbboefAoKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fr0FFSId; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fr0FFSId"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fr0FFSIdccjbkefgrLAygqhZ1x
	K2FD66XlZWFVr74nWNnf056MqEVrlvuf5yQV1s+dOvRG1i81HupsL1433lDyfGNQSi5PIHVOtYy5S
	cUtOByDVnJT0iNwdhVhlho98/hfCCPS/kfYuHhJjg4LyB5W8aI2RMl5zWvCx4CB+P4l5qSCWOteRm
	xLZo3R9JSGIWExwvFzzMwE9iN+Lytb/XxM4yofkywRcK90yOliGcEmB6nPdaGJRd5mxqmwWOYa/FO
	mm9Qxg2BH285qQ+RCs4C3xGyT/wChEMkOYegdkWpRergV2a9nLAQepTuBCn0nV96djg043UNbwNXO
	xD0rSoqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKiW-00000002yhl-46CE;
	Fri, 23 May 2025 05:13:12 +0000
Date: Thu, 22 May 2025 22:13:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] generic/251: fix infinite looping if fstrim_loop
 configuration fails
Message-ID: <aDAD6Oe3WeHr5kj0@infradead.org>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
 <174786719713.1398933.8706464867612580485.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719713.1398933.8706464867612580485.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


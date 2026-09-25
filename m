Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27853C4B60;
	Fri, 25 Sep 2026 04:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311594; cv=none; b=WQbHbKYmF4WNXLlL4CUNgg09CgR9KPrp52zlFufClFkQBYoT7nLlxOwmzQrd7rdQzzDQu3DIBsDSBZgv1+FnYcl7xDE3RgNhtHfotmMnmfl018d0YPVmjaJqC6TmZOlgT/TgvcxnFFvtXesD1tExbTRqTFtk0zjqanOG6alqm1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiuaBDljHGjsPqVpcPPJh2fikJoXoYcbYFV/be9Q9nfmxUECVK7kdBXg0XsXkpOTXRC0AeqpIoxtgSkvVYQm7s3WcGLZKtofRD1XuR38mSJet38UvNBJdhPFLPvDVw3MbcHSpuoNyJjeRYgJGfvcv0XW5mzLaYEz9BRcOQfJvvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ygKGmc2p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ygKGmc2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ygKGmc2pzEHPWjB2NQC8tuMtoP
	KFP4uA1k7vDzAbfU06x+PsnuzmY8ujaR0w9xvcGZxhPVGqKu+99sMn6iqOOIQ7mjnLXaL7UtFpWDm
	zQfTKazk6HczNtXY7rDHlSczAubcDueZgqTIDtPC8wlteYoBln7LwnZBG3a+uuDiQteDIA9fHCPUs
	Z7UnXOBg/fKN2pjJr5TCui3h7WMXnBeCUUiQoCCiG16k9G08XO+JGDNzRBRJuvuMt/ZJWd7zEA9gk
	rBoL2eZX7M0SDsN0WzIK6/AoLR6jvWABUtsoCAOLQ388Elgh2chYmVW2Ygoxj2uaR9Z4KNKSH0Fdw
	3d3CGWRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9xpI-0000000CctB-14iX;
	Fri, 25 Sep 2026 04:46:24 +0000
Date: Thu, 24 Sep 2026 21:46:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arX8oLYjmxBl8rWD@infradead.org>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-2-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-2-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


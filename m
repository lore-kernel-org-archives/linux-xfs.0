Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309E301486;
	Tue, 22 Sep 2026 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054054; cv=none; b=tSVpriMQVKSdpqagVZnnKF2te4M7vEGvkLrIBQyzawXmS/lPhwOavobHs5Ao1vndzIVx895TnSChFdKuMV7sep6mR1KYblAzyv/ttHmYit04p9Xa4RJH/Asn29Uv7vGE9wvA8sEC7jO8Mukf1aEHdIvmdRSEyrCFoe0NyKgvXo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054054; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxG6q2JLU4StHVtbIGCn9jGv5ZafD0rkJEQuVkfDNG9JMkg4z/Tx63U7UXgq8YFpx5p/qppY5sA/foOhNhkD3kBy8aQtcyq3LeqmAMF9FVhgLtOQLEmoEgwuXcylEv4R3QEEvrL2zbyeaqotg1A42TfpsApauLyAtrxQEzNa1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lshXP7AT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lshXP7AT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lshXP7AThn798lDtbs+RlVZ7ey
	M0HYEmt4Uz0VxtwKMawzhqI1k9FUuQng/l3SVLTSH0Ckyd5MsFMD7yK97YycWcP3D87rDiEjLRID2
	236ixlT1HN92Zy726hrJdazybOzHIwU6ZglDsKrzAFBaiFVG/O3uZUnDNfucRRlLiheGwWFe3GhA5
	fKOWWOXI269LOQhDwm9dzAM9VHWWJ2hd1Jmp5sCVe2ekgj69cpWBwxmIdf8aXQ4jXBy8VRpJP9VAh
	ZTDECl3mT16vFGHdBlR7DFDcL0c4NLm+qMpK7lIZIaZaYUeL8ygCMpeLUp2Y3PH0k/jrPgQvxllhY
	KLfmu6WA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8spV-00000004EOr-25qg;
	Tue, 22 Sep 2026 05:14:09 +0000
Date: Mon, 21 Sep 2026 22:14:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: fix missing xfs_qm_adjust_dqlimits call in
 quotacheck repair
Message-ID: <arIOoT6Le7wAD1Sq@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120572.181988.15018530254063783796.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120572.181988.15018530254063783796.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


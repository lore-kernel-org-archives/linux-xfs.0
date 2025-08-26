Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE718187554
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214485; cv=none; b=OVLYkeutiAlgZyaJHkJ9sZyNCEmQCieeTbdK/qem25gp9bu15flkH1mCDqfsgjHnOHUgiRZGM7gxos2osr8Oj8wkEfUAbOm8/tlkD6+oWcjPAMR8rw+r5exmj9vMS6WGBt2iDaNrYjod9F5oL20609Nv1d9QY3woSG4TtSpLuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214485; c=relaxed/simple;
	bh=BbO5gshgzmou5xtEa3rVWdh9Fu8W/DFr14RwZwgeZ8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVmqZyCRV0te0/kSeqGeqaQe+j/g5t9rHy1szoJv7ofwSNpRINd2VJDOumzrCMvDQz7WW/Updx8kNTGG5vkTmMr7HBGs8gHH5/GBHlVP8q7aqySCwZRnYBOs475ChHInrTf4+WNYdSpwOEbbgJi24Hozielf4jBmWZqmC17reB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZJoAfnvN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZJoAfnvN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5dS/wNrp+jL5cd4wuBJgvlp397KkEzokaW2v4WWtGf0=; b=ZJoAfnvNXRt8n7XFxD2xUK37XV
	+dvBHUvgodWt76clcEIw2o+fkaebZ1M6OQfOkt+5ZrsoalGijllI3vV4aNHpGmvKoVFVzdTtxq52L
	RKaeoOdlU4Uva6A242suLcVm5Srton6n593i18Q5m/e1swLpILMRXrK02BS3HKPuBy0pc6z7LH2T8
	XUPBR3NcUZWYVlU+LCqMte1X2FpI0ykbwGhcd/1uGQAjf1BUwP1KLFuoZU3D+mtF5KFYEQII3qs1h
	C/TmnXMeWZKzKU9FC1+YklB3KnyX6Kwe7ZbwaKYZAnFNL/EBEk5CjJ2TuOphFcnpBI0lokZYtYOab
	1s2FurfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqtc4-0000000C58m-0Cnf;
	Tue, 26 Aug 2025 13:21:24 +0000
Date: Tue, 26 Aug 2025 06:21:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, contact@xavierclaude.be, djwong@kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 9ec44397ea2a
Message-ID: <aK201Ikol4QsG8Yl@infradead.org>
References: <kmkoyhtz4mjuy5xlucr4noywsgons5n6pn5ti3fjs4uv34fzlx@zsopyugtig6f>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kmkoyhtz4mjuy5xlucr4noywsgons5n6pn5ti3fjs4uv34fzlx@zsopyugtig6f>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Btw, do you to pick up the support for populate from a directory from
Luca?  I think this will be a really nice feature to have.


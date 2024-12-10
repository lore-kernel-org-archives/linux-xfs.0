Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8D22617A;
	Tue, 10 Dec 2024 05:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808303; cv=none; b=IPq2BG445GZEjRjyvNro/qpX5bYH7dsmvJ/L4so1TKISV/xwdErujbA+uVRyE85QTSbFaODsRLPZ7+tsjCAfR2sW/uLuCFSNHKMpIEpmoWI8tR8iOlhLcqGXCzSNuJ5pS+QkoVKlcazTfreXU7YJedspNIvHPE5Nq5jy06YD8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808303; c=relaxed/simple;
	bh=Mj9P1EyDQ60WIlPAI2kFShfCzsUhmmrswdAhrZ18uTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8kF5G1qfD8kPqdLi9z/73QZawYfD1pRH+UGgjmP5kE/merEvf0omGAWF44wFkHWuB14kO2zogKHg9QMExs02rJNYt9jYtQq9kj1qB+bz5BPANHCiTw2bRF1J4FxM0qjKV7DXxWmHi6qwd9Ym+9O/xb1AHZNHK3B9sY89NxyH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=prT5Zo1F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="prT5Zo1F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mj9P1EyDQ60WIlPAI2kFShfCzsUhmmrswdAhrZ18uTU=; b=prT5Zo1FTkZVZ6bYeh+fNpVb2d
	wdHr11V0USMOvNnh8fn3KPVDi86aAp6z1nFHznuwBd7Wd4nMQgnMN0Gc7gWwedaNhKPwoMOEgt1mS
	5oUJ4Yt+RLIcUj8TOqTxvgKLJJG7974uoR1AmBFbYDvxkE2dWYRC6x7YLD2wuY+df04Ca2PoBbHj/
	sVq1L7cPMZJ3c3+Ze87KREsKgU+uIiesSXX8OonQSJTUUBzGNEoa4OO2lCcw4wZ+r+cTrtARwlnny
	CKkdpb3pDlEqQi+eI4XBd9UXYwhcte4EyCJFjmhc7EwR5lTPAG0fNeqmsm01NEappuHRlVqRsruS3
	ziVCFKZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsk2-0000000AHB5-0ksy;
	Tue, 10 Dec 2024 05:25:02 +0000
Date: Mon, 9 Dec 2024 21:25:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, dan.carpenter@linaro.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 6/9] xfsprogs: bug fixes for 6.13
Message-ID: <Z1fQruaMo-kQU6KK@infradead.org>
References: <20241206232259.GO7837@frogsfrogsfrogs>
 <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Shouldn't the bug fix series go first?


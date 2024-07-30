Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1259B1AA3EC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722376612; cv=none; b=mMMxTf/YLkeUyeQW0GZIsTr3AuKAQD8prkI2TNY77q2O5eBCpUR9ua6dyLbvUpm9jQqclkArowj9lxg8jJFSIBMSDltazZv2yWAOLgfyV88/GAq5B1k8BE9OsjpwkI1mcVrMoAFbpnPgmGLvKuzJH7+kgP1MzGLQu9dJMXwKVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722376612; c=relaxed/simple;
	bh=9QMLGc78mdbvFZWmTBmtfMGJy7jpFzWm4BvWdpTSeSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2ZebDQDiqPqsTtfdWVp6tTx0ROw6pZ9JoVX0XzgAoPGp5F76B+5VoRfATsNOYtKGhF1S091PdSzgbAqoVio8EyyOxiZemsoqZo0uE/EFTO22bw/9BGIYoklg8qeS5HIoy8q4MYzJguXOhqb87xnr5Nvz4VpTwh7eKh6A0FA1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2ez4A9ny; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2ez4A9ny"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9QMLGc78mdbvFZWmTBmtfMGJy7jpFzWm4BvWdpTSeSc=; b=2ez4A9nyq3vNqugNU4G/2UTAdL
	cOK7kNeescZfsIM6aviJAhe8jG8rFAiVg3zM6I4Kq+g2LxFE46EF4slUnajPeVajtM1AF63ICeJff
	ccMeim0RujbmgefyZSHQVpkSLSASBCw2b5ZbbVzW6NF5Mvl7IYB5ZHbReE9cFgfSgFxT1p/Dqy+Ta
	DvHtPQRJvngHyn2dm+cZh7DQby36vPWq0IR/MRdpWO2622uusO3zhWg0O5zdzKQ8Juqa0bEsjTUse
	9ao50Q+fEU0/YkqAiKPpzhVcue8jkCCa1rvbUE2J4GiHhr43s2q0DDc4q9vwYTcRQxy1IaEqQCsaA
	+C2syqqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYupu-0000000GaZK-2uyi;
	Tue, 30 Jul 2024 21:56:50 +0000
Date: Tue, 30 Jul 2024 14:56:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: define a self_healing filesystem property
Message-ID: <ZqlhopUMJNAyxuSw@infradead.org>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
 <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

self-healing sounds a little imposterous :)

The code itself looks fine though.


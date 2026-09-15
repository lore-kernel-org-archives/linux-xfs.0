Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E9351C20;
	Tue, 15 Sep 2026 06:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453572; cv=none; b=fch+Im1BXrQXmI3yVQth7lvN4ojM7gx6++YJS/MbR/XaGktURoqNK4StjYNh1CJwcU+mtDA3jaX3+MaIHDUzn1cfYykEwtw9hUmacD3Quvd1c29VRgGw/8gAv1PbSEUNYVfnbcCHFQNZH8PHNV+PsTTsvHtpna5aXZtbVZXxj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453572; c=relaxed/simple;
	bh=yqY3ik6cXV22s/dXvlXIZPybCCjr9fCmQAPwm3ECPBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFtw8SRU70eMUybzhg7hFM7BpnGlds8Onqjc0xyEKe2LywevBQXA58DjC4ekcRv3GjWyn4lKC6qvGYz9rbjYlfgcijmGncQDNkq7YFIC2MWRLCCogNZmQHU1bS74b+G56bDlJmRKn9vaQ4CGXb47IPpXzYgOKaE+CP7Qlfo8RmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RtYFC/3p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RtYFC/3p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ImfSYqPcAldcoka/EDkAMcs8ltcpbNC3JtQj164J/IU=; b=RtYFC/3p2DMWA9N8hgInt4BZiu
	+BetAd75Obw0+/Wj2e8jT5hMDETvUS2xTxUZX8QtiHChMmgsrNARv82WqoVni6lVbWuhicmnHNmoS
	JFbvG0s4O7jR8QNCeOug/RMf6ZWDSbpftggiD7T1yfkowmGMs8UdTI80gl+GsNrJWmIqI1jL3Wai4
	nPJRy7v7iO2coC4kj22uLte4nBWU9rU3lHBN5quFhBu7iiGfKZ9Cc5o/aWdMfnzNf3mT0VIdZDUv0
	BDkFn+w/e17tMCFGHEff5n2zptHJB7PigS0wZCw9NoCUk7ajE7riCldXOCj+4LjQydX28WKmQBwRp
	FhrbC9ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6McK-00000005LJz-47kv;
	Tue, 15 Sep 2026 06:26:09 +0000
Date: Mon, 14 Sep 2026 23:26:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: call xfs_dquot_set_prealloc_limits if we
 installed default rtb limits
Message-ID: <aqjlAHDUv8ViI-7D@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048543.3061055.4920055292209877451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048543.3061055.4920055292209877451.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 14, 2026 at 10:37:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have quotas for the realtime volume, we also have
> precomputed watermark limits for the realtime block counts.  These
> precomputations should be done any time we change the rtb limits, which
> means that xfs_qm_adjust_dqlimits needs to ensure that if we installed
> a default rtb limit.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

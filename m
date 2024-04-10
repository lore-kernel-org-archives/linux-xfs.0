Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEDEC129
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729195; cv=none; b=NbVMG27vdnhhCh2UNAh5wta9T3KD+TOIh+AGBRF9L5kQypNZWOTIHK5OACbsN85be8Nak6MQlhVSumnDi5UzZzU+Z6vD8bLcVL0/gsrBMVC2NXR/Q3h5jdYDfiYhJbnwNNBeJGborQgPGF4oP5aMIwp2lx1PIQ3/4aGdyt4fDQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729195; c=relaxed/simple;
	bh=AXqGZHCAt/qSHR7h1tW3BS515F4StJ34LqGxSIvn02Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSJpnMu/PGl6yKgevhLFyVxFMQAPtFCMHzzTqFmA61XqaXbrmXj/JpF5gJvAinSHX/dWBSRv9YNvt/afj3bYUxFXHIdWRNm3nzf2Nrk67RrgRoVrv8HPiOan/dwKelXJ27RR1xUpZad/KSBQlAytdmT0rDQcM+4qGUB2GPmvmIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nP1HPoyP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nP1HPoyP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1YWa5U/eb1nN2pZRNFRtPjDVt+YNAW1FPWG6yM1x568=; b=nP1HPoyPUWBRj4RBolJsiMdNI6
	Avq+ADQgXYBJ0Eo5kR8E6NeSpX90IuhfseJBCC35+3Y05MJT6i0MYXNBZQTtNWJA5oP5TfBK5M8BH
	2CmKXhdlpVfRlP5p0I4tLbRvQAe4wBhIJDlRqzwZOmOpnQqKqeLFgTvJsUqeVwCyE9vBll7pbDgjA
	RHyzRT6yA4avUv5lEd+IPdWqyg9GVXszCrTWndGJCyMGccw3FC5S4JRfrBL45C9DRl1NDioCXM0s4
	C0iOskrtVgRKI/EFBwmSNf3cu+jw8uCvxbnPEq6KXXiXwdpMXD7szCYKJyO5IXIEiyQ3Fi2nHj069
	zGo8agQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR6P-00000005Iyq-0M3e;
	Wed, 10 Apr 2024 06:06:33 +0000
Date: Tue, 9 Apr 2024 23:06:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/32] xfs: enable parent pointers
Message-ID: <ZhYsafjrEg4Nb6la@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970091.3631889.3723065069358160559.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970091.3631889.3723065069358160559.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 06:01:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add parent pointers to the list of supported features.

Any reason to split this from actually adding the feature bit?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


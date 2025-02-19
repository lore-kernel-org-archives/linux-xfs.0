Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421CE8C0B;
	Wed, 19 Feb 2025 07:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949575; cv=none; b=dHHtfAgUH/xGKH184YwYNYMDLoHIC2YGq39D3q3Draoxmlu44J+csli9cRwvICFmp2LMETJVB2zmtOmgK/Rig6iFLX0nZ3KduMxHSgMrEcbVXSVnrfTi8y7X9jhwTSntG2Af6in0GGh0DAWCLZ7fWW8su86ueAshsFPXogRktn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949575; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWS2EHHOKlSCIe/agUrIBexkBEbCYqI8RlmvGj3UXt/2ho2HFtkoUH/BIOJfRf7MRbdsgRF2DfAEfLWNrEHrFU1Zu6jhx9HX3ZxTaApevKonBcCJ1ucBkyD6xpKZNUAt3Eyp+r2QHD4/P1QONZDCGhwpeu3JFKqSHPTrHAVgqts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NASIC8h0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NASIC8h0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NASIC8h0gTh3tPkPKcXX9ZaauA
	EkyssLz723+F2SupcUp/RorvaOZJoEktdkeR75qxWKZmhRZqOtdZxdO1HNFHCtaZ/elCQJ0oWkc8y
	ElaKL7oxfwsHS2DQ9mPBhlodiot2dJyH2SPJs65y3L9dqy2OU5ojbBL0cQrPE1WzWgThvN5Ghy5kZ
	e5pChd2dXchSB3oeSlOfbgpbZHlJLK+itaogqIoYj69C4ml69BFGCt5oQcnwtfT3PktqbrAxuEw/k
	jEn2FA8VIQ452MG/mOeWWmdUZZusQCjfwmz3mvt2y/REuR+KQYiQAe6ZJAXyVbL/D0+pMyL9cRWkl
	cfzdyTUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeMn-0000000BCrf-3sIk;
	Wed, 19 Feb 2025 07:19:33 +0000
Date: Tue, 18 Feb 2025 23:19:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: update tests for quota files in the metadir
Message-ID: <Z7WGBeC-vk5QPxxq@infradead.org>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
 <173992589860.4080063.6004431845318847274.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589860.4080063.6004431845318847274.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


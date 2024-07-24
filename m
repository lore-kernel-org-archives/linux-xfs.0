Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DEC157A59
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721826918; cv=none; b=EdnEu/niZauX0lF/K3pWsLtqvQSAPv6OsHyi4ZmOoGB110hpqb2Dn4CK74KFtXe9iVvjiMCmiKP78IO6AwHY5sDGx6R0vTxPdWuKSmlrOCP6lHssungxg0D5/twcbZ/JdzL8fxGEY7+hUasBDxUVUELa7qd65hnRLOtWJ3Tvh9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721826918; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcdIINy5rFG7ylb2tNpHCICioyzA9K3JeHyOIKzSNcW8Pqwnt1B8IKUq73o4hJbmyrRAFuK25XdKwueerx2PO8RRsm9P9zSZHO/o2FxfrfTW0tZSn2TvjpBa+Yd4StfihAnIvix+MEY2SGmQLSfDwV/SNSKdhCZOYL2SVjc0pBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mnIdkWFM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mnIdkWFM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mnIdkWFML9I85/+XEZVahqX0v/
	Qph0VYhqp8wvODPJghB9+mFsPXz0JgkNnBQ2iSmQn0rRoTaj8nTclT9qL51LF/o+atq66qhTB7wJv
	lwmnpKOs5Cx0qc7VnAycMSwSQpsMufotK6Lcxe/2LgfOs6T9v+MXCosodfaOsUcRVoODq/MjROtkk
	5A4wMHrPLKpmN+ECOPLFQMBO+0MSDKbFZMncVrNAKb+TXouaLLtAB1G3mMDPE5ytKwXNxiT5LraAE
	tm9DPwirxoqYc9J11oyaqEW5ZXPuxYEpKHEd5ouIIPXOup1VLEGgKWFbsuX+xvmz7+LNx+krW57pu
	dYUqh9cA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWbpt-0000000FPlO-0sPR;
	Wed, 24 Jul 2024 13:15:17 +0000
Date: Wed, 24 Jul 2024 06:15:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix a memory leak
Message-ID: <ZqD-ZRpfc-vNuezs@infradead.org>
References: <20240724051155.GX612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724051155.GX612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


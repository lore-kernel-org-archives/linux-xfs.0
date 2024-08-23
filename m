Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA4376E9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388051; cv=none; b=E+b8tDAFZQsCrAOzmnPpuvIZRCCEaBuhxEmrk+cdwEWrKnR9Zc7NZGGuYircDqa/Hszxn8fvBfHxTeo9+hPqUx4uaHT136xxIRIU1U7/ak9s7AtFjphobQyuxXL8vb9WEB4JG3RvtYkJN1ZCnhkzmk6WnAA4RLs1ybFx3ZyaQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388051; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJjAJjcXCf9+NT+UXm78/aAVTkOJzEbWFetlnFhwcEX2/2+I8FM5PzivAtpw7NIQNzY/CLvNPsg0wJy0vtrfnaSj5tWjofKroX4SftpMJWZ0auPPXNmUGEtYtBN+VDNVwCB6Sp62UcJ7ZGkk/g8EYdjGOxF3sBeI4E0xt/7F39o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zxutg1zO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zxutg1zO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zxutg1zO/dfyGuapSg3uD0Sw6q
	dSCLrY6Tx1Q97gmG4QyGjUTDnTJsfBSXm71gAUgfIt2eQrQXGiAcI7kZObEEVDjWJpHws6hrRfFMu
	R3xbSCWKRIXj7yCKYV1fNmgDPS9YkWCHUDKHQqeu1t4cX2mglSosYZpt/CLmeKUOskQI1xP4AmtN2
	y7sLuSFj+xg3t4KGIMiKz+WXi/aw1FXl6oSeOLXHS6g7l/ZUk/EVzYxA6FqrfDsxa0W+BBBJ8RVxo
	IJ6P1khYxKyXA+8TuMgWFw0Xl6YFn+xYSh59ll7OGp9vMMqshFlOkwvzcWFsE/S3N1FBvP5OHh/M8
	VY9HXpNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM6T-0000000FDQO-0yOV;
	Fri, 23 Aug 2024 04:40:49 +0000
Date: Thu, 22 Aug 2024 21:40:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs: advertise metadata directory feature
Message-ID: <ZsgS0XLxV5B0Pv_k@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085329.57482.14642494325904894193.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085329.57482.14642494325904894193.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


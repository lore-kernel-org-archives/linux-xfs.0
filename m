Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C676741F5D4;
	Mon, 12 Oct 2026 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811020; cv=none; b=KWrQjDeXpi82w19yFht9MlHK0TppAh4FLumyQooS3bNSrUni3SuO4B4CQNsKpFDJ77uOhCbDAIA1D0QH6EhOyBs2+fs7VRaO2aWTEKlnzjAi0NS7aJ+L4PzGeV0jqFL9E5hoE6a5IhzjT6hGfV1F5ly7Lk/PMkB5yDFwY2fGkfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811020; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBo9zD+VoCzmN3qrX5aEjTtA2BmVlDoAG3TRLT02s/zAFBJYSmejjFAH5u83m+Mm4VHLAWKSjVZygRF1Y/NF4XovNfdr+XCoGrZcJkaldjWZjA4LGhxPo9QISXNlJV9lg8SMFNso0bl63Oo9hkRGr1Vb21jMMi6sKTY3j42uWSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2kCLjQdM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2kCLjQdM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2kCLjQdMnHxdcbdLXldaZ27Esb
	/Vkrrt21Ttq/h7LuPA9GWMiusSECfuspqy2p9zDxe4NLVxD4b6O5nqCR0lBgioIXt4urQyI0oH7nK
	OWnTB1Wqq+qXUW/YAIaldM7BTcUDH6X/MIJvNzx4/EDghJq9bDrvrtuc7ohFnTF5hzTTTVzKvcDXB
	s/UlKikee4unC/fYU7gjnQ2S5/hXykTDtFBl1fHhxVe3/rlxQkiNEDPeBU4GQN7vJPL5ZOLH5aVEY
	zb/iVXJ8U8SaVUMStCDs1vbj4iPIbNans4mRYd/xrp2M8HNGW+DhKDJiIoFJa8ePdX2ZkGAoBImUv
	kqhi1CKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFtj-0000000AXo2-1RC8;
	Mon, 12 Oct 2026 13:16:59 +0000
Date: Mon, 12 Oct 2026 06:16:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: don't try to repair rtsummary if the summary
 file isn't computed
Message-ID: <aszdy1ZOIHC4v-fC@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065880.1058822.7169477353675130912.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065880.1058822.7169477353675130912.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


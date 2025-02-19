Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2311BBBC6;
	Wed, 19 Feb 2025 07:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949899; cv=none; b=S9Rw7pMAKVj+WxgzQr5GtIbvmc57x/vrPKbH7BT5nCTSNrBiH8f4ARoPg+rwmdHSjsM/K1PBTaFNQvuf1mqcVs8s272184J8003nRWfAifAbboXDdkLx+ZitN/hsIi+sfbf+J6C2VcVrJg+KTKcVHG3uB9LRelXJ33lh6+yKNTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949899; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvVX+zkbtZSsIDWzEF8UMdqkhuE2Q/2Uu2Eqaa7Vg2EGnA4Zcs6diOtZecEmsbsitXhWQHW5LvZohcfxG2KyBtpI4N5rxGFI+lt+o6LsIo9jtL6XKYiT12yHZQVowEwCvQk7Gzs7K8RllKVqexZQEvZtmzMLCScnGXpZRXF8qNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rxWeVhpR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rxWeVhpR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rxWeVhpR3wDxT9Bx2RCzAO7ifO
	ZDEoDgdyQIGyXs5nKsGj0/jLXxF5JVKupnGAk0VUty+av1cXNxA2t1QIrkNAwT/cdYdtQjHodoDBD
	ysry4foelX+sirNgADm7lwRWFH3DmAG1pGErmeqkb9ta4oW8hVqws3dmfg20O4oEGkXQXh/TfYv22
	kvN2yxCdEqDSN9yZKCMp7pYCAdm47II4r46FH11szdwtvZnhAbYlHZNbgrhXEvAlbUZc1PomEgiwQ
	yzvXuptCNADBt9yZvI3TX1yGedv5aL6sCwmYwBlWhY8X6N1KScqbgycZlMatFb6Zv2XRO5gCTCHF/
	ZfnT+u6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeS1-0000000BE1v-2Urq;
	Wed, 19 Feb 2025 07:24:57 +0000
Date: Tue, 18 Feb 2025 23:24:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs/336: port to common/metadump
Message-ID: <Z7WHSeQuLduOTMFv@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591149.4080556.17871153207427090752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591149.4080556.17871153207427090752.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024251AE00E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081630; cv=none; b=MXVHPqyMFlIuLvKTqdO4yIg8rmr2mhZ868c+EMAifhiHz+CeJet35HVk27BBiqJU+QGrsvblSdD7i34KNtGA/tDDeS4VOjKuKnIRvADDlnm+TdaO8R6LuySxfOWYoRpna2tMZuSFD0OBysXV1SKWcPNt8B6K5mpB7vGfLpT9wCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081630; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/E/OXI+9vUjdLUP2ESaqFMd3QXIFlb34RlvKUH8FAhnJEzo90caojJGen6WsnJh3ZNfMT+9C85HQKfh8cn6w0MR/vHrq2HG4MpMt71ucBBScFUHH0iVu6d8bZ80geolIyFIAllwSW8ZhfaP0XXAfLQUxG7qj0OovGAvfOgvSw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u5hd3oN9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u5hd3oN9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u5hd3oN9PB+YQXgAIfADn9F6ly
	2yvmBI5HIGG15nmMBCBkoib1VyRFfuzUV4VFzxA4SjDciJy7iTW/BauIhyW7ik3Uy0JI/2LtRbd61
	f41EaDBUXlYbXhpS28n5++chYh2c1RZP9mLAQ5t9RNDGRynzus+qooXea08z60iGgrTwsaE1Yeqld
	PW8CU+hb46dRv3MGP65GrQmOVp7DOwyIBRSvXqWaKBvZUvZ+4seswmAQXTrbzXLK7RzJquP02nuNZ
	GZjG2RXb5NcP/IVpLdC/9n/mAD50KV+beYfsYD9Mx1i/R44V0eIm2XapKG6WrKhuBswgj2vXQpSiH
	Sb1mMiAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1qU-00000003EIu-2mVu;
	Fri, 13 Dec 2024 09:20:26 +0000
Date: Fri, 13 Dec 2024 01:20:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/43] xfs: scrub the metadir path of rt refcount btree
 files
Message-ID: <Z1v8Wpm2sXiIwVj4@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125149.1182620.2553301724738000525.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125149.1182620.2553301724738000525.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


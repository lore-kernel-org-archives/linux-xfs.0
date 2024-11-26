Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEAD7E9;
	Tue, 26 Nov 2024 05:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597792; cv=none; b=OqGpoNMiTvOURrt74ro5uahGcM7g5T5NigaaeBhWgbMED7N+K4Y3eRpujnXghRemHj+emyA4wq4d1DOdY62Lk8gqV2ge7/392/ZyjeL7Y09Q9gwxesvpamTN3FB1Um9i9zpcnHpTKtHdz9PGQImfFgEyde51XfP+2dEWn8LIF40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597792; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqOChn9+/oa8km0w9Bjn1wczH+BZce5GeRWrT4oADvNGwPV8xxwbJKhpKx9AFX5nD/5f6VHR5aooxcPrg/Hj9bHIz+inc8x2wz9qUpBXY/d3DpYm/V+GFtt0groUGiqEX0N9witWC7GWugyJGQR1eEXKcw0blXnm0aPvo525Lmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kr7FdpFL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kr7FdpFL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kr7FdpFLnz0pvUumShyoawNUsx
	zzy04V4pAsc7wn7uCO14tPjU+lflCCXgyB05iZmwMk+BBMvRtXJSweq0bgVHf8OIdXJiI/Hdg8YR+
	DLW9GDb4n/F9hqVzbfA6bHs7nTbudWQtn+3AW1vCrvd0FOVvrc/v1dKMBwhBzJ94Mjkx9KezaiZQX
	0CCbm5qBJghyK2hrQis0SqOLo+tr7kzJ42fha6miez6SNrRUL3Phu+yWYdtcvIHUN8ZAJ7KhI6KzD
	AVOk8/PhSB0hWUqNK0PmFKD0U42y4NXPfWqEhAVm8UThbUI1wwVUf4/kUrRgBleLeyZYvutWElcNO
	ip0+Oqag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnpe-00000009eXW-29OY;
	Tue, 26 Nov 2024 05:09:50 +0000
Date: Mon, 25 Nov 2024 21:09:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/21] xfs: only run precommits once per transaction
 object
Message-ID: <Z0VYHpd8gOm_e3sO@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398042.4032920.1346072051908401243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398042.4032920.1346072051908401243.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


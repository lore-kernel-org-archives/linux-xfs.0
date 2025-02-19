Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BAE8C0B;
	Wed, 19 Feb 2025 07:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949602; cv=none; b=kHr0z7cUBmS/q0i83kjWSjAxOaYNk57uFX3e381vuFsKrzfO9bopeEEVwmdOV0ii7Plc06is24+4fCmJRGVRMmQSKwn/XWxCp3Xj7A5nECUOR4I9nqRdXTQGlzz9Egfzz7vmUQ5M8fSeiMKOIphR56cMpD+wSLOFUMZgO6K9vOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949602; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMT+x9YU5U/IKhqwe1t+ZvxZsj0zFJ/3DBFk3U77Hk5MzfyHC1+ta+a7AMr5gvFikIbNEQGcfCZ/pFbcu8gk4X38CPl+YJuCNL6uRDHSMWPy6JnOUnTEmOPjeDa+qDiN/1fAeHmu1jA5Ev8hQ85Iwx4Nha85LNM9WV4U8e1pRPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pEjEW04z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pEjEW04z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pEjEW04zSCi7hTpofXFV9lY9pu
	rBvYA41Pcxra+MI4L1ZOjLkUYmJOGIUXouXcE+mFynSOftzFzzetnp42m7vkArH+8RgZAtrJORDVk
	niTjCLGcy7PdyacYcyG5R8Hx47b8IrbyFgUFSYDiGYgBMXWLnOco8HVEns9VQmNnnAq4G9OUOlPMZ
	3+fGbo5Zf2Wl9FpzNsCjbsANk1TQcwOhuagvlccv3i8Zxta4sUd+cGB3+zrbnH5T764ONvd8Ra+YK
	IZ+YhQ+ML4KHnnfZrRAP8zT1gGVEJATiuGDjjDIwJiA9cUu9eMC7IEEjH4e09O9rnLTSJpid1STWL
	gkKJs9+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeNE-0000000BCy6-3ARG;
	Wed, 19 Feb 2025 07:20:00 +0000
Date: Tue, 18 Feb 2025 23:20:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: test persistent quota flags
Message-ID: <Z7WGIIkixL4VfBvV@infradead.org>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
 <173992589878.4080063.13008930042280912515.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589878.4080063.13008930042280912515.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


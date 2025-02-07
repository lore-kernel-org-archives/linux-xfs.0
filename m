Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA963D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905727; cv=none; b=LxvCPYRZz7HMFep+n08GsaS4cPtguScx2sjqFcnVZRzvnkwihxlRE/hhHLHn+lZ9jvYl/6tFa4481Z1K1C6WceREdrFg56FR38KIT9tdJHvkQdi5VCsxRj7xc3Kqf5hsrCq28T7v44wzT/9FYi3Yvr9p4M2WIAxDeDCXCcmidSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905727; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3a5ekMs1WeYRigV6kcnUqDDbxSAFrsCmum+dDiXUkWaZ2dVQa93kj7UV/7v9zrr7odMS7FWdPSIY6IKWMgSFLWOcphruA0b81hnnZb/8vAOq/n9+38Jw47bilmjtVsb6WR3G2EicXYdtXRRiOavvGhDYTMrDIVAEzo3hJpE1qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vW/orPXY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vW/orPXY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vW/orPXYUDDlm57jhHHdovCh9u
	OX7ny0pE4y0FzjqGwEfq2oJwjSLj44fWlBh+I2zJsknfQ+9WdURqjsGydkVSRKgJkV6VMMxUJ1Cx0
	xBPZQohYsAnF4jxnUiSmdwOpIjaEIH2LGiFYSfmbVHqqahI3rqnNROzubRY5MZOILhcimn0Y3xLBT
	WsRe6U915SH/V/P34SapwJIz5IDAPUGA3itGH7TBDSO1WY0jdgiefKQ+DGPHBmWpqkB760WQNghdp
	7xSF2M/m4P7t8Fr5cFtwl5d2r+gbS09zjRWpiI87eYDZckQkrUIXOK+SZcjBRhHkSG2ZdBn65XRad
	UfqcMmeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGoX-00000008MNm-14yT;
	Fri, 07 Feb 2025 05:22:05 +0000
Date: Thu, 6 Feb 2025 21:22:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/27] xfs_repair: use realtime rmap btree data to check
 block types
Message-ID: <Z6WYfdFyLNPqrwGc@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088326.2741033.4026936578793794237.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088326.2741033.4026936578793794237.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


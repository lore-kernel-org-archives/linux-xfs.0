Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD60148FF5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806496; cv=none; b=exxEEeodYhS+dN/fykzVh8oGXwUJWvcNfD9Sahbb8Q22vKPn+1gqAzSI17zFkt3imFTKSu2lOUMrtHtyDI5R46tR90XuWvl4nCZEvnf45nqyaUuh5fwHbR8BcT/JOqQ/NqQDlWqBXp147pUgZRuU0/jQQ7k0gXF93LJnbzigHVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806496; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/rKWGd1UX7dzbv/Jh+101p2mlyRs7wYPfGWonc9WQWAUlxAYC044OXqFSYmSKsfZSVbov2LaY4i2K4KOVre+/sQSNV1+DICObdnH7hFtEc8oQsNA3uQUDXjn1t7u8OWI/mZboObsScOCoRKX24CtRjk9dJXD0NG4pHAFfGBbSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B/oCfGc0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B/oCfGc0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=B/oCfGc00ba+QJQxytn+C5KurD
	v7Rm19LzzbOv/NIJOaVPiIV0/BACGC0Qk0RyPlKwigrjEwqR6BXt/GUJCOX4b8Pt1imPJY/koe2BC
	Dl2WJVN6fX/iBWHfecVBlP3eozUBMSLJ2TAAF6Cle2tllIuojgQ01ZhaucXEy7KfDBMwK8o2UtsRl
	7nHqQNLsW6fuA84zfyT4nDzaNuEqgKjCe9jdqIpGwH9MXP5FscPXWYs+YICu/7WiE/xGKh5rwIntJ
	dJti7G8N7pCKluDsQQrUCH5plXr5W5e7IEd/hZwUSPmAjB1AID36jnz80TV9Vdj6VK5H7o3JUXDbO
	HV3RhkUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsGt-0000000AEUW-1JLm;
	Tue, 10 Dec 2024 04:54:55 +0000
Date: Mon, 9 Dec 2024 20:54:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/41] xfs_io: support scrubbing metadata directory paths
Message-ID: <Z1fJn9BGioIKX7Bl@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748361.122992.14800316196936096339.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748361.122992.14800316196936096339.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


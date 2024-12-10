Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0840F433CA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807829; cv=none; b=CcdHdcGRTMUAyFm3hq0gW2WjGOqkngdxUpBI2qKpFGAA8FmxeGhkUalWvVaYB1ytN4abrEmBrbmzodk2scedRJZIyw5HkPF60yWEObsf9rqHE72gGnzwuTI2FDml+ix5+rmii4W4Dtg8xeo5GvWTwI3LlggR01xvNgsCqd13Rss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807829; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miQM5usKMxVbBVbWStbgRMyhqDXynLwIv+vu8jIFjJmkqs7ADQpJ8BeKUYmfQyW5KKMC/Nag/1wAwGK6WrP9VP0KyNydGuCRSLz40+3bbhL42Rr7eMtO/vAvXKb+uEUPQ8n1CfEIvvBi/rdV/URQ3cz0qMeZLL+3g7g6sp9YhzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=akabx3Y/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="akabx3Y/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=akabx3Y/jiiUj3plcYfZR75ore
	oEY0Zx4skERovGbo5oddbgKx3iLDHaVh+VUHHgwrSR2wiLhHmAWhp1tHmPPMrOD6o+30i3deigKF1
	je3YNBbfjvTA5VwrVfrXCGw0SfHEyPAiYoLupyfRQslSqrWmvBdeLz/R53NwQo06Xg3bjtN9vrhm7
	ffiRTkm5zX50m1eDX7AwpYlltK3t5Gt5BNnTWNvVBx4SmyQFuJq6mObFWYwU7xO8nf07C8R4gxae1
	/Ul//Mp2pkW2I3rCDTyPZwQMtx8B7UfgyapF8qnY+xMFVyG15EgywIlJ8LrKCrVDF4aSctIN9pIJA
	l9PjR5yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKscN-0000000AGDu-2QHV;
	Tue, 10 Dec 2024 05:17:07 +0000
Date: Mon, 9 Dec 2024 21:17:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/41] xfs_repair: don't let metadata and regular files
 mix
Message-ID: <Z1fO01gepFzfB6CU@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748695.122992.10407812901278086211.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748695.122992.10407812901278086211.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


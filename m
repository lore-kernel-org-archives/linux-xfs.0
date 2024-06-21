Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4989912D745
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945212; cv=none; b=EcZl/namiFLAeiaquoDeGAYe2A2pfYJX91rIBo+BZFzuOKoM+HxTsmceX1AeaTdbl+38JD4SQsZgBGiEX/Swr1wn9FS4tblHZkQVkz+qH0KXnuKtJoHlyvvyy/FDm7F5Fc3W5EeClIKCi75ppbkKQDSdO/ivGe2d+HNXOYsg31M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945212; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZLLCa6/M/kUytgXnFXsm/H/M7MVstzbW1acsKLIgm2KKiQheWfFFcpjDAWvO6qdA4A2gfSw3pS1dLNQ+9GNVJdG57p9QlCnhPL2GsD/5cS0HSHtNl2EolJIh97Q9j4lnYveY2HjjX+XTOFgnpVKGI//UElpxSELR+pCyT+nFF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SWzlob0C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SWzlob0C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SWzlob0CT/DSy/UuynRO6N7NAs
	aM+bIJQiHL5J9dbb9U0m6cV9l5vKJZQ+8EeAzEvIi/js03hcl8YvNQThWKb6W0xp8yMyrFsrcKlaa
	CmqpuD/86v1Khzw+byhQbIY/c7gXZDqqDDU25s7uV+rbB3gDPQxFz9yKz1g5be50v/wqvrRP5RxDp
	QghhTKtxCJQoY/qeJdk63Sj4qWTD8r55On+E3TSs/VQy3C5HVE5VgFg8gjfEjzfWLX44r8hzFwPCb
	r2A5D3GplmAZPYRxjgIFSpmA5KEbOivpEjHjoakkVZayLk4d3KPSsHjhQ5GNNFjKgi49mQNQdVouc
	JioHDc5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWAl-00000007g4X-009f;
	Fri, 21 Jun 2024 04:46:51 +0000
Date: Thu, 20 Jun 2024 21:46:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: clean up extent free log intent item tracepoint
 callsites
Message-ID: <ZnUFuioAambrYiDH@infradead.org>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
 <171892418712.3183906.13356447364652197747.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418712.3183906.13356447364652197747.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


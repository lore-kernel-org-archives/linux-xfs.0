Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6D3359A78
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990843; cv=none; b=dN7Ez8tdNU0ZbHqsm/lUxPqoqGQp+r55OURS4I9ksmohihqx9dik7e5N5P24meM0Jk/f/uydDohRNzUisBntTcxoinL9qcPGIZ7QzgeV5Q85f+ijdZfTkrf3zF3dLaWQmbtVH99HDvbovZp2dPCA6M1knhSFtcVzJaiN3kT5Bsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990843; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaGK54qAaNNU47Whx+iaHRUO+i8RXYjlfBpdPjKJW3DV7pFoXX/2fOTJFpTELofwntcMvisQ27HjVXeRWQBln9Bv67z3+P6/TVB0Z7JkW45MWsXMAyK4hhBOsaPqRGi7qmO7TgJiJqJBB3DwSLr4nc+I+097voxQ8gNrtZwpebg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sJ4b9zX6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sJ4b9zX6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sJ4b9zX6iVLCM7uJcvzSZ0lcSk
	eDFoaaOmAJ/ZbvaWEb1pVQHHrw2ZxX+4TQ4kEdiiC0jHUGcJou5nbHFL4Ra6C+yBZjYg+zxGi2Jhv
	V9I5P8zbUVtDKI2rax30SD7pd0TdukOXN47t+BphSEViK2iD92MTo/qJPiWCUmyBL3mWlPT8lA6O/
	iVJdCwlplv13a1Nqd7F19v+virLlgtITO8jIdQuWXn+Hh0teIvpjozpyf7fL5n15u05V+PubVPTvE
	DsE0CUrT3gSrgn9HyRqsJedBQK3/TRpEE6s/fd39+6vGj2+PADD3ye9dnNhkchYpY7fqyFbxxEVQk
	sSJ1XiaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U3W-0000000CDSZ-0sVg;
	Fri, 20 Mar 2026 07:14:02 +0000
Date: Fri, 20 Mar 2026 00:14:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/22] xfs_scrub: move read verification scheduling to
 phase6.c
Message-ID: <abzzulPYj-_3qjy9@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507068.3681140.18439157462761401139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507068.3681140.18439157462761401139.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


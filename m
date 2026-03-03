Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC51D3BED07
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553016; cv=none; b=bAx77NRfsftFEPsJvazkzhOwgUW2vMpZ4cuIad4wWtYzxO2ox0n+ur3RfgfAjgMb9fcERkEr7GarE38GNc5w/+pGUMFpR+T/Ngxu+gixiBEfiokHiGBOP/FfSSLR50yGhD4LIFhf9JbfkF70nO9fpr2qvWSSy5NzmbrHWlVwfmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553016; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7MweoA7GOl8behwkf2xOOo+ydCHlVGOGTs1nSQ6pSDXoYgfR87z0RXAXm9sAtIpbZSoaqATDYGqFcxPR/ZRSnLcNU1pgZvfeuBp3eJg3GBKFGaq38BEr+GTJKkvqiSGB0dO+x8W/2w1FON7hXQHsfkK3gOtPCyQMXfvkF2N/qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jRm/tuGv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jRm/tuGv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jRm/tuGvewXnopzq05ZPBA0Oif
	XzSkArwLISuXna+fqVeTmRzieL6vDEy2LZhlnGx9eQO2ER0m+uXf3GHuecwkuJEX6toD09aEu/GA2
	AsVEMuAzLN7nAk7QK4UJtmk/ENkG7pYGKGnfFj8FZ2kp+V1mLVQbqCAB4Jwc58lxwshF5rENJB4h7
	27xn14qd3NsYh1mNL0NpcP899pfhToOMelNbc839gCdLAWNVT2IT6QPa9xJWWPdA0ogIogkbZ4ey7
	CP680Hx4lEapgihEab8gXfyX8COg+X9z0eJPjTjT9rrbV7hRBd37skIgWRSOCa2px8NaBAJFkxA9j
	aU8At/ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS0k-0000000FT6N-2I7Z;
	Tue, 03 Mar 2026 15:50:14 +0000
Date: Tue, 3 Mar 2026 07:50:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/26] xfs_healer: run full scrub after lost corruption
 events or targeted repair failure
Message-ID: <aacDNnGwNmJzqzrh@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783582.482027.2137236511256164643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783582.482027.2137236511256164643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


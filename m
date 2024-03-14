Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318101FB4
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381814; cv=none; b=l4YS0xeB7TJ/uoP0IoK9RIVFfgV5PMaO77vjyCcgOCj/kOVzs+ObmPbntnVstEVMfbDrIgfkLfX3mJdArTpczZdAMGgLnF5s5t8eRsUBZrSdrh5urXkUat9OM0jEHbbQRjThhdB6G1guVcJ4PKxGEYibgsMZ3UdOwX8RHJQry2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381814; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRSuK9CfE92zm+Mt2rYRbiC1A1PKb1B4Keb9f/WSxJcYfyvlC6u6Mn677RvSHCkshIgIowtKg8FZvMXqUdn/mCWQ9UDdYDpHwUOqzCxXp98dEBh1It/8hxgXVtQACHP1RhDJVEr/heb4uFCy7FF81KwLbfoGQ8lCco9O9Jt82Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T+/vtn1D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T+/vtn1D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=T+/vtn1Dft5DfUSPvXfYqZl0/T
	wUsnFEJeTh0SwBoici1+Sqgjf3jnB7uwTXc382BOFEJOfDPNNh36IzcRYLJrMUFSuGNjExClslRBX
	NBcbtWiqWeurqcBshPu/F5SDS6HleTSfrdb2/dprBa8VpKDrzYScNgbAzX4iVjBskImzAQKm7dDjq
	556szI1yW6qBEL1iFqmFUK1hyZDCi5K394tnltvBPLfOqxNYFELmbHXkegFbx2C8HVRh0OOGX0yWR
	FO3m4/yCkLVn08Wl/3np2fbBkowE5EF75F1JTEzA2rtb1nfd0QnMxQet77zduSrXndhAfGsw7m8BV
	wFjHO+pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaRQ-0000000Cd5E-3cNw;
	Thu, 14 Mar 2024 02:03:32 +0000
Date: Wed, 13 Mar 2024 19:03:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, "Darrick J. Wong" <djwong@djwong.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_repair: clean up lock resources
Message-ID: <ZfJa9ITYdBDVzJKN@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434801.2065824.8093618587875439562.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434801.2065824.8093618587875439562.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

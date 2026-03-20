Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7F22C08D4
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773991016; cv=none; b=iO1L/BTHvVzA+CoQHlCH4CRER67Xfc7jsVM55Bq6AZ8MWZarYDh57+zYYRL47ovB7XiBItqi8jE1Gq/4G/1g2TQDYkB2SdcBM6taWu9VG8/bqfteWgZn8H8XzgyXNXqYL/wpsXwOnOy8faXFRL+XwIhvYHSFZZb1E1vugmgOyhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773991016; c=relaxed/simple;
	bh=wpxQnZL33X1DFPrm5p9sKGCN5ZbOqgC2BxW+BN2JewM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU6CVGVc+dMInJhZsuxVgKyEXSJQdqZ4WAq1xDKsbJHW7TkWsapMUP4qFsUFE/JX7oIZl33dXlIa73o7Q7uNwgCQgYYO2UfKqXpSo1l8B7dGySWF887mm+mUg6VEMOdKTcpv2lfdKjgnAd5MgxVQ6IIFPtIHHiiN98VvGL8kkzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jYKt8egL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jYKt8egL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PyvWsIxCJ8CartbNgi99VyTXtj2NYpNAyBj3qIk8Jj4=; b=jYKt8egLiZSSTHvcHX80IZQfiD
	O6xRXtp1YVnufuagnn3cVwkpQaUeM/TPus2ESy/g1QPcGUyBIm6lKYbVSvv/GeAwarWzaJUURFUVN
	w2kEysg3OsEsK77u4w48ts+NLgrIPqE+Mpr7aiBxGfDwXeSQBQLkQuRfKGdrABwR/6iDlyYbLbMyM
	ysSH/wKhkZP78DXIKLqpKyK122vsYZrusywHALCNsr1zHeippGphPCwaTuflNPLmPupVFyAWejLYa
	8Pi4UZ7K7K6K2YPx8T7LmLGj+bGhy5jKO+1pKU5AG7PRQOAMVk51pWrBJhULKc0Tbwytdsk35ybB6
	D5VT4svA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U6I-0000000CDua-1G6v;
	Fri, 20 Mar 2026 07:16:54 +0000
Date: Fri, 20 Mar 2026 00:16:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/22] xfs_scrub: raise media verification IO limits
Message-ID: <abz0ZjMmmFMk3l5e@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507326.3681140.15280052926187020484.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507326.3681140.15280052926187020484.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 18, 2026 at 09:51:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> To avoid starving other threads of disk IO resources, the read-verify
> pool limits the size of verification IOs to limit bandwidth consumption,
> and it is willing to over-verify some amount of unwritten media to
> reduce the number of verification IO requests sent to the device.
> 
> However, these limits were set in 2018 when areal densities were lower
> and disk bandwidth was more limited.  Increase them now to reduce scan
> time on the author's system by 10% in foreground and 50% in background
> mode.

This looks good for now.  At some point we'll need to return to
fine-tune this better for different media.

Reviewed-by: Christoph Hellwig <hch@lst.de>


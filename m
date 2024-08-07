Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AFE7BAE7;
	Wed,  7 Aug 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041341; cv=none; b=vBSqasjT27MYGP9qDjlfUGnlg+hJeeZXKnbzsb8QrCo6D2teweGq4+VlA+rHW6ovpWnUfFBdvf4AdNY67B7kAfDmBLwhHk95BVFAA/63cVDHDvNsOKr91WHeDKgn2yIgxaXcY5SrhShCs9bFQRPzjEpZvjfavsHkEePe/y60zyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041341; c=relaxed/simple;
	bh=eJPkIQ/JqO0aJwTuZ/puLdVqa+kag4LisdYO91DFT8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWFtTF7XqmO6AN9U1YCSRz8ovjLtUe9Kr/YeemQ1RvqnCN7bLMjsNZtDD0b+Y5IRYSaVoxGn7q97ylz6oeU1jQ2o9jLEJJzQzKdlOws5QOPgALZ3IfI1NJ/VqYzzufsvpVkMSIaqyGaDkQLrVZtewiS9Wso9Vs1J3CssyGAY8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pEHF3CuH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pEHF3CuH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t1UJ4UAfvFS9I+Dz8qWv7LrfW1PcL8xhFJtoVPpb7Kc=; b=pEHF3CuHDL8vuXsIBqLtFXXVA+
	Fywf0n3zW84mlY6tTK1uzz4Gmp8FY2JiRcEaK/oSKbdpLAMJ5jqdHZhteJaRAx6h/HrBUw0RAdvrR
	qshSTQHEi/o6l7C08QSRBHZc0YOw3u6mFRMXWpU8wmlg3o2jAJ2CAHYi+uH+lEd9PFBY8QfzRKiay
	fGEYf6p6SJTH+EaPY8XvV2PAhUDSnd7HO6DiYBvmnxSx8cCpshID0VwkndlqHPKiOra5wS/XKOij/
	9qTU+VwI0IAKNGOWSJaWKOcMuXLHE13OH5f9RY7VcTe1AYpW5vtcYscTuy4dwF9+WffTPbFOUasyl
	0/rG25Zw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbhlL-00000005M5c-2x6v;
	Wed, 07 Aug 2024 14:35:39 +0000
Date: Wed, 7 Aug 2024 07:35:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove all traces of xfs_check
Message-ID: <ZrOGOz8R8ptGVsbJ@infradead.org>
References: <20240806225606.GC623922@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806225606.GC623922@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 06, 2024 at 03:56:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfsprogs stopped shipping xfs_check (the wrapper script) in May 2014.
> It's now been over a decade since it went away, and its replacements
> (xfs_repair and xfs_scrub) now detect a superset of the problems that
> check can find.
> 
> There is no longer any point in invoking xfs_check, so let's remove it
> from fstests completely.

Yes, please!!

Reviewed-by: Christoph Hellwig <hch@lst.de>

Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AD1EFFA5
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 06:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302868; cv=none; b=u8WgMX3BWk21kKgI82umvX8qq9Hot8Atbh1vq78xA+XNpcx2ZMFQa5Tp+xUrjKpL1+PN7a72YnZvQL6VQsqE4WcA3pf8R5JbbW/ChergaXJeF9Ca7X7+VXPnVnjYjwCUPrkBbnQf9qZdYIcdVP+0soUg87iyQykqeCJIfP2blnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302868; c=relaxed/simple;
	bh=0kl9DYQrOl19QQwO/gdJ15lf0jTaKlfjERoBptNCAy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBCY1dkJfwhVP8unmM8mXS5kIwFpBuPdzPtw+SHKhNHrswTT9punNK744vWkqRbyIbWMOqAY0x3YjgNapl+9utX7khuOAaKezxMYOB0oPPxS4oJ2QmE/JOZNvQHtUbsPkYq4CYI9uSUNURkdJyjnFc41d0iCCAYycnuUb03dwi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wKQ1fuuv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wKQ1fuuv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bdr7oW45D8iMwBRGDs2YrcXIey972l/e/CNJp4O+Piw=; b=wKQ1fuuvGqehnnpwmjokKLZfPj
	HI0jHwY08fGNw2n+x8EABVUNZjnPqY/7IFg06Nl7jDqUBeOigiq3TioEvLSthrixNIO4/b9thtWBn
	90Fy33gBzrawvtiDMDe6OIxLybQsguVTMh5GVqKornDvSIyegMkGtURohqkgqlLWUwVZoVwets9+2
	tRTSCIHgwpT1phk+2ozEUzk4awzzNwJvb5pf7S1S6kmD+lXCBaoV6ewPIof7dNfTOsBFKRka9o9Mg
	FirrGRF4VQwrEym0tEtRVqGYt8yrIjWwE1WloWnj0xELf3edZUL1Y/Sg7cnb/g8n5+6g2TVFk7JcN
	JMh8s10Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u770E-00000005wOt-1MAa;
	Tue, 22 Apr 2025 06:21:06 +0000
Date: Mon, 21 Apr 2025 23:21:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_io: make statx mask parsing more generally useful
Message-ID: <aAc1UtYb2HL3w5T_@infradead.org>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <20250416052251.GC25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416052251.GC25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 15, 2025 at 10:22:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance the statx -m parsing to be more useful:

Btw, -m claims to set STATX_ALL, which the kernel deprecated soon after
adding it:

 * This is deprecated, and shall remain the same value in the future. To avoid
 * confusion please use the equivalent (STATX_BASIC_STATS | STATX_BTIME)
 * instead.

do we need to do something about the -m definition in xfs_io because
all fields aren't included in STATX_ALL?


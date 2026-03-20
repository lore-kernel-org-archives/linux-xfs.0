Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EA356A3C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990720; cv=none; b=PqU4buMRQu5sOh2ZFiqK74n1Z9kCo5Jjo4R4h+yXUly50I0ZgNiqcEnQpkRSx3b6hYWYd7+RyC2fegxy1CgU/LE5GuH1/C43G0P2m2YMBUmTRxkh2J31P39JIHDogWcny79nOH1pOP/bcsagQ2wnTQFBo5TPoUJGdRughKZqlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990720; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnE8+dWUpkZCPM88qsgq4kJsRb5iax9/cN3wLjJHtjwIauEsZYD+dPShLBIVeeb8p0kBMWG0jGnw57hAcZ1h/XJPbRrHOP7zqXzU1L6KVrjb8OcOOkxXjdkYhFOsB3Bv5YP4a7z/kBpVKg5K0aHCSUvu9hE06N/NJhFZSIVRzMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tEGEtNPr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tEGEtNPr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tEGEtNPr+5YW2gdFfSfI4O15eM
	tQzTQ5AFeLDxBnxr3sRLU6UxOhvNVipiHrjeJA3Zm6ZQxTmf/F8EoMLmsUKrg++kBQNbhdg3oY67z
	7EDRZ5U9oW+NtCa6ujYohe4bLGLUdZTAL1K7vWZb+u/fBZK5GHRw/swgGmvlX3vWxki5arCiXqCA/
	et4EWyJoR2kau7eF4PeuZfY25lhS3fsg9KWR3kWMmsN1T0asdngll0wNb/Nx96dfk9VOqtdDYn320
	NWw1tsoWRRnc0zIo3sOx1pt4g1oJLV8tdGwsqfVRM7dY8OyzAXECf9jqvyudwwHdCIMja1x/oh0si
	hC7tYpqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U1M-0000000CDO3-1qQi;
	Fri, 20 Mar 2026 07:11:48 +0000
Date: Fri, 20 Mar 2026 00:11:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/26] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <abzzNE2uG9szGhR8@infradead.org>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
 <177389506495.3680139.1450874724011035240.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389506495.3680139.1450874724011035240.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


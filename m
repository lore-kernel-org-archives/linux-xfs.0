Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAC171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388618; cv=none; b=dkDbqWinaZaFyo5gOlgvJHyhRBMStzXj2l1L+7CubQI3UsWwdgWy+qk0f84Y6ToL6Q7skPSbm16suXQNRekGO+6b6ccl0m1GBvrjeSZiIUhm+tWHad5JUAvyKOpPNIdyMl3Cn4cjNYXDt6SjAi5cFN798A5CpL0xiJyUhKLSQds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388618; c=relaxed/simple;
	bh=muEX6jxsOqK51w8iN/AHTA5ovo6+StZm4ipoJ4XRJDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sS6evZOJyCr4YKx3Xpip/CPyU9s6t8pYoxmFlG1cip6RDV6fmvwSocMD3WirR9clh4i7FNlEqhCU422r6aIAH1i7FeCk7FmKAk1MptJjZHyk+A4G4Xo7JC3ieqbu4y0SB1U/0hdTrZESG5i3beFFHE7QLAchb+65X93YWJPd2+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xFE5fTfg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xFE5fTfg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E3Wwbo3w0MkXxb17pYujAiFC1MasyRLcZ2kByVtpJeA=; b=xFE5fTfg+RkGJ05YM6kYdYugPM
	y5AIurttsMfts4mdP8p5dYvho+vf8+V0U9SrVYXkRjA/QL3qhMf/oIihExpWtUIgMZP5yZSfFaPQ7
	dhUztqQJ0uuE6IkQfee0f2ZPy9waPv3/NAEoDkd/OPQ/O5COyO20QQY5GA+3dbcStnqIpnpHtX3ou
	f/Ii6q4zBjqJR7CraSWzcELUxz+cW37PFrxfCLr9PfOhJyghwC/BA6Pg6yBgcgcHFf3Spcgzb3i44
	j3KQfkAm8vP//yxRh474m7otZmPnII3HFv0zUowXxiJQCSKjYmG3yV/frR/5aafSy3pmdKTFMojub
	O8TSDA8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMFc-0000000FEGr-3Dxt;
	Fri, 23 Aug 2024 04:50:16 +0000
Date: Thu, 22 Aug 2024 21:50:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/26] xfs: metadata files can have xattrs if metadir is
 enabled
Message-ID: <ZsgVCOsDBJ1HQviI@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085484.57482.17914105316962083187.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085484.57482.17914105316962083187.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:06:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If metadata directory trees are enabled, it's possible that some future
> metadata file might want to store information in extended attributes.
> Or, if parent pointers are enabled, then children of the metadir tree
> need parent pointers.  Either way, we start allowing xattr data when
> metadir is enabled, so we now need check and repair to examine attr
> forks for metadata files on metadir filesystems.

I think the parent pointer case is the relevant here, so maybe state
that more clearly?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


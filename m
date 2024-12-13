Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445151925A4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 08:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734078658; cv=none; b=YV4gQXFoKLgDnibEGJn8fwAIimZcE2CejDHq8toC/ZSGmb0OKVxKRlhyy3UDFhzcaP+J1f3Tpp8m+v2ltZKzQoSTOmHR0tWMzhZiVPwTxa9C+nynJ/YjWjHKFOX8PUlNDOvffiASoFcgPkeyMNBk15vVPqmiQ7NQ8in7RJtK5vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734078658; c=relaxed/simple;
	bh=zFO4SoH7wKXI0tSHUACS9OjbOyctDcRjIqz4qZ9nP3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmtFTouH6Bwh002G+LzIMmAFkRKMv2JPNKPzynndzGVXBHAw+AXfBFkk8zKSixVv1Kfn3jWOHKirDFlFHvfazvBzcK5phD9/bOi+y8CcJ0aF0HCSdSFlvcfyAIByQ3PVDrp3cYEgS3L+B6BGWWt/nlc7TTyoxS2nb5gkGK1j5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zsv3b28v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zsv3b28v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f8NV6B+VLIWBHvi78DZj6N5gU6AWF+Rn71c6k3+sWno=; b=Zsv3b28vADKahDZuKGJ2p3fr8T
	AzlaAVrp4geT0iMSWMeZzqcmOtUaFP+EDtmGd7uDf3YCNk6GZkbVU2X+rmL3vWMUFFOgo8OKcjeqN
	jXBOKguuCJp0d/XskOglbZy9PKof5I53vdF8BLK5eVyUO7jWxska/aLcgIBd0+cyLdrMZsc4RR2AL
	PRW5cTNmii0Kc1R3No4vBVR1rsbHgld7KkupycsFaheNAOKnh2KzYVMFQ7NPBWwvIYLTz6bwzKB1T
	cIAm8U07WfdhSPeUQAcxQeqHC3Kn9D/6ARJt+duOtT3QjeRxDPM8kV74VjWvjzpLKsgnbU9Qr45zo
	i22k+moQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM14a-000000035Yx-2x6Y;
	Fri, 13 Dec 2024 08:30:56 +0000
Date: Fri, 13 Dec 2024 00:30:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v6.0 5/5] xfs: reflink with large realtime extents
Message-ID: <Z1vwwOMR9sF3MrWY@infradead.org>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
 <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:57:58PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Now that we've landed support for reflink on the realtime device for
> cases where the rt extent size is the same as the fs block size, enhance
> the reflink code further to support cases where the rt extent size is a
> power-of-two multiple of the fs block size.  This enables us to do data
> block sharing (for example) for much larger allocation units by dirtying
> pagecache around shared extents and expanding writeback to write back
> shared extents fully.

FYI, I'd really like to avoid us pushing the large allocation sizes
further than we have to.  Or in other words, unless we have a really
important use case for this I'd prefer not to merge this code.


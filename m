Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C468119B3D3;
	Tue, 13 Aug 2024 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561171; cv=none; b=Q3IHff1eekQy8Y+IkJ3pg7Lbl/tye8COvjPBrY5R2VDZptJ2NDCzb7GWQoOrZBDs3aPiDn63B+EtVJ6YN+NluuB2h3Pl8V1Mr1A5DIVlahI95wgrwbiGpWNVk/7wES/ogyWexms/Vuw+aaH5uLdWpO+YgN3nZW30OY4fThwWZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561171; c=relaxed/simple;
	bh=0b26u3Ata99ntkzMdYLTm9FWZecKan0fXkfuBgbCp8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDbl9NMFaAjo8JNW38Ath3bc83AG6HkYGzhuKaDFGgYZsuW/M2eeoL0vbenr4lF7FsWAwyrELkA3jM8D59FA6h2HbH4rj8/HpnpwRXCTZ9OWoVf31MXpC+VsuJy3nBiROkoXfqlCldHYri8GboJ5ifOv/inED3S3MpaNG41vhcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7FF2227A87; Tue, 13 Aug 2024 16:59:25 +0200 (CEST)
Date: Tue, 13 Aug 2024 16:59:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Anders Blomdell <anders.blomdell@gmail.com>, linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <20240813145925.GD16082@lst.de>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com> <ZraeRdPmGXpbRM7V@dread.disaster.area> <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com> <ZrfzsIcTX1Qi+IUi@dread.disaster.area> <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com> <ZrlRggozUT6dJRh+@dread.disaster.area> <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com> <ZrslIPV6/qk6cLVy@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrslIPV6/qk6cLVy@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 07:19:28PM +1000, Dave Chinner wrote:
> In hindsight, this was a wholly avoidable bug - a single patch made
> two different API modifications that only differed by a single
> letter, and one of the 23 conversions missed a single letter. If
> that was two patches - one for the finobt conversion, the second for
> the inobt conversion, the bug would have been plainly obvious during
> review....

Maybe we should avoid identifiers that close anyway :)

The change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

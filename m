Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C11A23A4
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841965; cv=none; b=WqxOIVOjyOAwTaKNIY9Xox/UdA5GpV/DO1G97hkWxSLE7V26V+A8VrQgPGaVNfpzQmXvaUDVfZOP2jwjsP75rk7GTFLKA5DIMsRK+8Vk7xDFNocbknq+qq1TMrBntXfeMRQfcC4WtLnwRE4kXn5aZKXXAKtBHktw6ZFVE3fyaYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841965; c=relaxed/simple;
	bh=SrcH+c0D6ob8L7n1L3tRV1hiOWCh4EGXzjutTnVEmaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6LiFFPsOn5nMmgrJ1/vVcO2Cn5CrZNXH18sxWYo4Jch1uMVy1H+e0ZH8cpmyqKm8InBDYt3tCGjdPpZqzkgTKgLvDaIrEZ3kYkFCyib7PIG5jobaUPEtesAi+6Zq4+WJZaDS0LbQgKfCK/k+vn27dUcv4OjhLTBSUWK7muJQuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrA0JyqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrA0JyqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7DEC4CEF1;
	Thu, 30 Oct 2025 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761841965;
	bh=SrcH+c0D6ob8L7n1L3tRV1hiOWCh4EGXzjutTnVEmaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrA0JyqWdd0XGRidFMP0Xdfsrizpn/upFfGCZb3vlW3AWZJqzIGaVjenm3ZcQQIHJ
	 xM790lsiGjtrTe3PT6ID63kx8NBWOTlt9iBmtau67zRpRrGVUORWOeNNs1EMjsOOlQ
	 u9z1CxLTFfBl6OGQVs0bDz8cTTmfivak65me7fiICO4Dil/EAXbgJH0yFuIvtLH6PD
	 /w0/kQJoZ+khQIAz0X02skaYq2m4KmJVTp5y1FcnmQaNXFNjPDg6Leiq9+MXrrZWD6
	 onZNvebrYEwwj7PKVzIBrKg7yraIjVRDdNt/5UK83aMZXTAQiaO11GGNmAplJGAg0+
	 ZgaNaqNZL9G/w==
Date: Thu, 30 Oct 2025 09:32:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix overflows when converting from a count of
 groups to blocks
Message-ID: <20251030163244.GL3356773@frogsfrogsfrogs>
References: <20251027140439.812210-1-hch@lst.de>
 <20251027160726.GR3356773@frogsfrogsfrogs>
 <20251030065439.GA13617@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030065439.GA13617@lst.de>

On Thu, Oct 30, 2025 at 07:54:39AM +0100, Christoph Hellwig wrote:
> On Mon, Oct 27, 2025 at 09:07:26AM -0700, Darrick J. Wong wrote:
> > >  
> > > +static inline xfs_rfsblock_t
> > > +xfs_rtgs_to_rtb(
> > 
> > ...especially since we're really not returning an rtblock here.
> 
> What would be a good name here?
> 
> xfs_rtgs_to_rfsb() ?

xfs_rtgs_to_rfsbs?

(rtg[roups]s is plural, so rfsb[lock]s should be too)

[this is all bs, yuk yuk, I'll be at this club all week :P]

--D

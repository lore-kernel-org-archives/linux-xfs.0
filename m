Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5123CD8BB;
	Mon, 29 Jun 2026 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782773938; cv=none; b=aU6h92X1xRH1+2iBq9xWfb3ZfkxekskZY8U15Dm6ft6ZRdeNYeIWGnyqkT4idW8yAiDhjdKAC3RIMQow93EDsIQRn4Xb2pgyZ6Li6vvcnlS+eS6CNjVtWOh/Z8/dcf0SxlzEYgNomPM0uMUtOVrXBBJKC3WMDfxIvhrM0k6jlsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782773938; c=relaxed/simple;
	bh=Ogegkbp90XszGNzdoxRRkavDrho2Qyu04OgkUeRgRFQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lg5u2mKj6LobSuqWjnH7JCj5U6rdU4NaOYVDIEstrPsuuMXUfHBQqTGHXD9KfxqYkPlHXtpMtvH9vZMF535VxBlFW+REXh/qPCBBimcKEyNp4OVG665RMzUoew6+QavcDjTlkcIE1pm91BSL8SOVIEKF9frau/qU47x+u1Y0dxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pj2/3jnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pj2/3jnj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AE6261F000E9;
	Mon, 29 Jun 2026 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782773937;
	bh=RjFZ7ggerNF4Kl3istM3FVs5O1TSX656rtv4KYO756s=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=Pj2/3jnjys+M/pEBVdP3ljp7PU5POxBZ2sl0Uo11KH1Oz0Y2VqVsbqWFdaZYXqvQ9
	 OwLe53Ub3OIdV9Oxuu8qonm3y/56AOB1ic+wLouSmd37yfksJxCvidMd0B3L5Pdxfk
	 PMzG+t1BScGKTy43KsKa5KFgyeGSMqVVOJB5vlXJC9CghnTixRH1tGPT+VkqL4UQ1M
	 ljwDUDSFCm38CA2sU/JZyUxf6hxG8IsiHe0bPuHzr3NJaC2mB3AA0SS6sIkTPNZ2Gn
	 4F4YvLdXea2aLVg8eavtJERoJ6s3Yfr7hwTEtdlKXyDUDIJOXTTj/MZhM0sjOIcBmf
	 OxlbnLQ2kFtLg==
Date: Mon, 29 Jun 2026 15:58:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260629225857.GH6095@frogsfrogsfrogs>
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-3-hch@lst.de>
 <20260626045353.GA8735@lst.de>
 <akKye7hMwSw3Vc8L@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKye7hMwSw3Vc8L@zlang-mailbox>

On Tue, Jun 30, 2026 at 02:00:10AM +0800, Zorro Lang wrote:
> On Fri, Jun 26, 2026 at 06:53:53AM +0200, Christoph Hellwig wrote:
> > I'll retract this patch in favour of the btrfs fix from Darrick.
> > We'll still need patch 1, though.
> 
> Let me make sure I have the current status mapped out correctly. So we
> should apply/merge the following patches:
> 
> [PATCH 1/2] common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
> [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
> [PATCH 1/2] xfs/078: disable all concurrency scaling
> 
> And revert:
> [PATCH 2/2] xfs/216: disable all concurrency scaling
> 
> Is that correct?

Sounds fine to me.

--D

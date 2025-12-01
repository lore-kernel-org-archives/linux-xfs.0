Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5189825F988
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 22:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764628665; cv=none; b=tJ0zZ8sPIik00eAY4Vw2DJ0/Vw6mhXMus+us9NjS3NQeHIQOKHiuS5MO9qTA1hOaZFRny0C5BOF4kufVMKbk5Zu4VelE5x0jGt0iLsOOBe1HiVC8/6XMvAE9jMxdiVWgzREsXPwjONM4tOEu6MlFdOtaBt83aSlr54Opi4jKUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764628665; c=relaxed/simple;
	bh=95fUj2HvP20vFx4jURGDhpRdoaX72AxGfXsG0Krby8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m506n7KN5cpZm3fE26HEu1WkQZS1fXM7HeLcRUGS+y4rlApDTtj6dHx3gfZwz5TiygeeIvfdaWrCZjCJLxtCJKsUJAZbvvkvHm7gSXCALdLF6WixFdVlpSj3I0sbb1nth5NNJ+D+ES60oLdoNnnkJVLkyQhTo/hvV9mygTiNHSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJb1QUBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJb1QUBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7894C4CEF1;
	Mon,  1 Dec 2025 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764628664;
	bh=95fUj2HvP20vFx4jURGDhpRdoaX72AxGfXsG0Krby8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJb1QUBjz3z6bRwjfYn/VKpMO8fsqqpR+DCP/BDpzqbLACJD1JfhFLylALcCXOR1w
	 1xurC2HIJ52svxdXngSY2JZeaHgNfVJ01v08RmrcbQlATOT9sKGP+tpVwWYxbsrp5t
	 a4+juWVj1u6owklNUhxHA4wTq6BW8rcSJieVGA5wLUeLKf5GlH+1gfXn2vqk9piYFS
	 QCdCzCa+zeavFMuD5uX9nDauMr6pzdczLqhY8m7AL/3QgpN9GtPXXMpBEYHN2+LEpk
	 YtdpBTbYIKvUTn3Ycm1Ke/BFRxP5pNEfATkW8t7OKFj5wU5Y+iMT+KUSwvmAoUBtZ/
	 W1ZGdo7DV0p4A==
Date: Mon, 1 Dec 2025 14:37:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: add a enum for the XR_INO_* values
Message-ID: <20251201223744.GB89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <z-56E7SJXYuGLyhwMv_kupA6P2PsSlno3ZFbm0ZBF9Txb-n4NCMjzm45G45l18LisGhRfSQjDFf3YyOKUNVgPw==@protonmail.internalid>
 <20251128063719.1495736-2-hch@lst.de>
 <gsry5zrjmrda6m6yj7o2wifqgf5gg4hpbcaej7ehon3aqdbswt@lewg6qgjizhx>
 <sIpjVVPgFrJB_EYQ-4f1Y8i6qGYh1qcqLJgCagHsWzYHVXQTUM5isxe7N0EvT84tAEQPhAqUnUGZN_QRxZJamA==@protonmail.internalid>
 <20251201062241.GA19310@lst.de>
 <txngz5bzrffhoavi5ybwtcptmgypljosi5wtgyqiuq7o3qgwhe@acb2ashnm6ml>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <txngz5bzrffhoavi5ybwtcptmgypljosi5wtgyqiuq7o3qgwhe@acb2ashnm6ml>

On Mon, Dec 01, 2025 at 10:00:55AM +0100, Carlos Maiolino wrote:
> On Mon, Dec 01, 2025 at 07:22:41AM +0100, Christoph Hellwig wrote:
> > On Fri, Nov 28, 2025 at 08:53:16AM +0100, Carlos Maiolino wrote:
> > > I think those comments are redundant as the enums are mostly
> > > self-descriptive, but independent of that the patch looks good.
> > 
> > Most seem on their own, but given that this is mixing file type, data vs
> > rt device, and magic metafiles into a single enum I think it's worth
> > keeping.
> 
> Reasonable enough.

Agreed, I don't mind the extra comments.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


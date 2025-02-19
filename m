Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5556A934
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943916; cv=none; b=MpmM0/KU8hQqlVPASZ+oBJasn5arRGRjsaSIipOhREpbq4zwdGs3w/EqwT6mVtk6pivK5PWkl9V/nrNqO0Pm96FF1igkKnlPASeJ57Tx1Jk4S5PsQirQRGChXusWzlv9mGI6AGctajApNpueW7u1Lp7E0YPhMPO40sZwXxOdH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943916; c=relaxed/simple;
	bh=XUB2EmvWltgWzxNDdYVxKUQ0g/Bres6/96y1zuxdSFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/BRaF/fnaejuFHcX7Nb5oqqTNnF4f2bMd0rBTK19yZsnHgSynlDHPnI4zt5ivqYrkIBXjpHmv3XhZf2DxeqUXx4tFI0eJart7ZUg46P5zfCWVvZvKr6G9mwuwg6eBxhLQaVqRPzL7W4uAWieq/6HryG5zRcVJr5SCtVsM1YcMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7UgvPPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7UgvPPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B966C4CED1;
	Wed, 19 Feb 2025 05:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739943916;
	bh=XUB2EmvWltgWzxNDdYVxKUQ0g/Bres6/96y1zuxdSFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V7UgvPPWiOMD2fgrmI7dSGrmLalGW3Z8+wcyiwdC61aNnQQGVCoK7CFWzu7parezh
	 GLzNek6OgX3X4OZV/wliUt/9Wy2fLMNQcbtG3bEQje1otnMKC480cdPDxaiv+CSM72
	 Fdwr22tJ/8Apvm0MU5JqUhc5tfq8xrtWhssSpNoE2lmSeXRGbyBaU3P37zX51d3rbw
	 hss0BMBfQkdl8jgYw027/amQJQzy2neRQDA0o88RaOzzNIVUBRf/SnkrqD6JZD/IfN
	 ZtGdp8fSFsSipCLZxBT9BIQdytMcypd7kvGJgOSgwaPLAaKSZauwc6dz4KNNl9zt+y
	 AdpqWOPjLvkBw==
Date: Tue, 18 Feb 2025 21:45:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs,xfs_repair: don't pass a daddr as the flags
 argument
Message-ID: <20250219054515.GT3028674@frogsfrogsfrogs>
References: <20250219040813.GL21808@frogsfrogsfrogs>
 <20250219053717.GD10173@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219053717.GD10173@lst.de>

On Wed, Feb 19, 2025 at 06:37:17AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 08:08:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > libxfs_buf_get_uncached doesn't take a daddr argument, so don't pass one
> > as the flags argument.  Also take the opportunity to use
> > xfs_buf_set_daddr to set the actual disk address.
> 
> Should it take a daddr argument?  I've been wondering that a bit as the
> interface that doesn't pass one seems a bit odd.

We'd have to change the kernel first, there are libxfs callers with that
signature.

> The patch itself looks fine, although I don't really see the point in
> the xfsprogs-only xfs_buf_set_daddr (including the current two callers).

Eh, yeah.  Want me to resend with those bits cut out?

--D

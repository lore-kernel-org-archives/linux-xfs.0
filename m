Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F36366DA3;
	Tue, 19 May 2026 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223656; cv=none; b=VKiY69E8isuW8EGIX9O62sDXUWz1dsL6lVIUT3ZXml5KSBYU2b8JrVBw2LSwbjQJrrfqBp9Hnv/huamGwHOpSAq2fD7RObokYtuEc66L6QHwyXazq/0uSaO4hDK7H4WY2gG47IjQLcqrpuZybOrMEMihk66IsuI9r3o2UiKOMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223656; c=relaxed/simple;
	bh=sjdqVwnwiLRX5iocH/+AnP/7Gx0pQHJMzhczuC6eDhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdGtRFVN7a13KWsXIdHJ+o/Pzk/Wlse4kR+gMQM7NhI+gAqAunwj9ugFSD9aJetqTmkiU5GZhH+ORQA7qtm0Lz0E6YiRYZeEUWwuf1jwUDwm0GsCI8MEb7LHrHQiGQXP50ad6BG40otiv3pxvV5WRBTFVspu4pTpLGZ6RdOxRQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwsA+duq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwsA+duq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A8D1F000E9;
	Tue, 19 May 2026 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779223654;
	bh=MtTD+PAUL8JXQt07D1QorlucFcBKTmTOO7YeP4C7NTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dwsA+duq8D8+ps2aOP7gum8MD0oOa2/KbawGhz4IbBeEplyaBaHj3wgKZqy4zDB1r
	 28pS41xYC2BbVhhn/Ycc2utvsupEDgyHwQ++d0lDzm8luVzRC3bt/22t+9ztQ/oP8X
	 /fpGi1ZO2N214/oOxQucX/ZKDVG3xPzBiKL4ABXftuOaZER/pU8VvyDpMvvh9buQor
	 0IC0c6HGy4xluLGo69srlm2jWbnXR/oqnl8OHPWtQk6RN+In1zXSn1KHCdweQdqJ9E
	 XhBeDS0bw01eowMHB7C1Tx/niWbyyMuwpdQmGnlZ5CIAe8XBAZhjfrZQ2VjazLWK44
	 jgBxcGYidxSog==
Date: Wed, 20 May 2026 04:47:28 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <agzL2KZgrXHb-1wR@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>
References: <20260518062514.506071-1-hch@lst.de>
 <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>
 <agtbqjAxUsCsLwyr@zlang-mailbox>
 <20260519083758.GA15916@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519083758.GA15916@lst.de>

On Tue, May 19, 2026 at 10:37:58AM +0200, Christoph Hellwig wrote:
> On Tue, May 19, 2026 at 03:03:37AM +0800, Zorro Lang wrote:
> > On Mon, May 18, 2026 at 02:27:42PM +0200, Carlos Maiolino wrote:
> > > On Mon, May 18, 2026 at 08:24:53AM +0200, Christoph Hellwig wrote:
> > > > The fsverity test generic/759 could be used to reproduce a regression in
> >                               ^^^
> >                               579
> 
> Yeah.
> 
> > Hmm... Generally, we state which case was copied/forked from in the introductory
> > comments of the case and in the commit log. If you want to specifically mention
> > the original author, I think we can add a dedicated line in the commit log, for
> > example:
> 
> If Eric is fine with that I can stick to the normal rule.
> 
> > What do you and others think?
> 
> I don't really care at all.  I just want to make sure I don't smub
> everyone involved with this the wrong way :)

I've merged this patch with above typo fixes. Please feel free to check
patches-in-queue branch.

Thanks,
Zorro

> 
> 

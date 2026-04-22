Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC43E35AC38;
	Wed, 22 Apr 2026 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776898041; cv=none; b=OxhQnQCITBy5kSdjwPDIjbl0fRI1QyqLLCo8pOiU2Clnc0q5CLT4XYQReDZM0guvvaYuoOk7Furg3G7975jPL89EEM57pQiUoc4ieKFA6KvFR0fM+/twndl1KAklAnTPjxRAKghXbV5OYMgyS26mWpBnE5WI+2owozpB99Ic35c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776898041; c=relaxed/simple;
	bh=xywk3FuWWC6fImVY9XXhdwDp4KDD7unC169c5GRX1tI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zge23IRpJfLGAbCyC4kY154qqJFge2jLfGueK5lb+yZ/kHYomp5A8uYoWs2gutr9Lh8tXRkcHkgV/mv5gs4SA1dcIplm6Rl1+htXj1P0COOgo9aRm0SiT1MjADwzCyc4cx2G97aK/r7y71bOe/TlT8RKzL5P399YITh+h/tkZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=taLQSnF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="taLQSnF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BCAC2BCB3;
	Wed, 22 Apr 2026 22:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776898040;
	bh=xywk3FuWWC6fImVY9XXhdwDp4KDD7unC169c5GRX1tI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=taLQSnF3g6HjJbm8te8XI4HVGp9e1gYWYDyyEz4BDMSY9RcVw0NXVW7XxNrL52qCk
	 XPKErDIJA4sab4tLjf0mKkrAvi/TtZ3wBs3wdurJAhtObSlzCASr1OLS6myyQJTU1m
	 7klnFauuVwF7QP/L63MRpWBDs69K6V4heEuT0ERt8G6EQ8ttNsdGztrZJly83cpNYu
	 LYk/WSAJXazmI45BAAZnCCGTQ7h9+ITYX2SKoPiujjo0/H5GJcvptdWUTVFCrvYEBW
	 m9I8VcfQRYVtcp1nirJ+jBJUduExqrJUPrsdhuZz3a4BeSBwXE/BUyb8VWEywliUcI
	 9SG/FhHW9jycg==
Date: Wed, 22 Apr 2026 15:46:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260422224604.GA2226@sol>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
 <20260420114714.1621982-4-aalbersh@kernel.org>
 <20260421214457.GC37143@quark>
 <gpmgtg2wkoo4vozzaaouhdp2df6zlifwi6gy4jvq7xc22zo7om@t3f2bl374nlr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gpmgtg2wkoo4vozzaaouhdp2df6zlifwi6gy4jvq7xc22zo7om@t3f2bl374nlr>

On Wed, Apr 22, 2026 at 11:59:11AM +0200, Andrey Albershteyn wrote:
> > The 'if (!fsverity_active(inode) && IS_VERITY(inode)) {' condition
> > should stay
> 
> Why? With recent changes, the fsverity_active() now checks for
> IS_VERITY() instead of verity_descriptor.
> 

Okay, I forgot that that had changed.  Looks like the kerneldoc never
got updated, though.  It still says "This checks whether the inode's
verity info has been set."

- Eric

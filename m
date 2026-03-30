Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD79F1A6800
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 09:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864505; cv=none; b=h8tnQdNHIDWCo4AtVJZkkWd9UZbu097x2qmC5wWadKsEvAgzCaalJ298bCF+5WxzsEA0++P6vSIRGDtxiagrQjQ+odzMeXyOuizMNqUh/2WzEx/bw1/vxlSNpzxBfry7R+AjkyYkiYGEFocIKLDmsE5n8c4ExzGJ5lH8rUNbDAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864505; c=relaxed/simple;
	bh=Busg3+HEtISauRac/pK3+eAuhnKHqIIle5oTVSytEHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7/KMz/mF79EfTQdzGQsGzDIRVOSj2P47sUylf8L/iTydZTfFpKRveBCE4N/buGJ4WPwWlDX7izdRAE4b8Ha2PVfWuylTuBkod0SpNqjwxa05VgV50R2u28QH/mcUcjK+FWqYODGBo7d0thkJ5QRQWUDaBwNhXJ7inpdvbBnGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e50oAl+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e50oAl+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB85C4CEF7;
	Mon, 30 Mar 2026 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774864505;
	bh=Busg3+HEtISauRac/pK3+eAuhnKHqIIle5oTVSytEHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e50oAl+l/B6WmG9HIJsf8dpnFQ29/bSuIEO91NSPl0Zf8+A1qHmtJWTfzJ+CxpKAH
	 P1Bg9dOrDGRdRs3Ss3onjuQzg64PP4mKzXmr0VUDmcT184Df6DvmNWe0X9vnXRgVC5
	 33lJHq+ZyjXuWMj/OOosuKvTs5wM0upEg2thbcXYlZmQW1Vdf6rni1NA37owYbjyRp
	 4tY0bobtLNiDxBqahYjtFnY/gxEPZJd0tCjrr3edgKcrvYpI5VHidc0y5irUsuck1O
	 uYGnOqA07qU69l/Tn0ul1AJIN0b+2qI2b1qhqjkYmVfmeBQocvtUXkSFX5Kt1bPXGQ
	 cTdAZ+8gbc8/g==
Date: Mon, 30 Mar 2026 11:55:01 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Message-ID: <acpIdXHqg_Y7bHEY@ryzen>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-5-hch@lst.de>
 <20260330054732.GA5079@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054732.GA5079@lst.de>

On Mon, Mar 30, 2026 at 07:47:32AM +0200, Christoph Hellwig wrote:
> Note that this patch actually requires the "cleanup open GC zone handling"
> series.  I had the two the other way around in my local tree, but decided
> to send the series with the fix out first after a trivial rebase worked
> fine, which obviously wasn't a good enough test.  Sorry.

I don't know if this series should be applied to 7.0 or not, but if so,
then I'm guessing that we do not want this series to depend on a cleanup
series.

If both series are targeting 7.1, then it probably doesn't matter.


Side note: You probably know this already, but if you had it the other way
around in your local tree, "git reflog" can be of great help to get the
SHA1 of the commit before the trivial rebase, even if you no longer have
any references to that old SHA1.


Kind regards,
Niklas

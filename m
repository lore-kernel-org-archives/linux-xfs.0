Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862F1FDA61
	for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 05:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765429463; cv=none; b=DVnt4fzQor75+P9Y+O8Q7gTMyLNr96qn6eQMHkpw1lC04SM5aZGNbuHsOdPXU4VQSiUGon/Z2i579rLP1M1rfnLvgjgci1BrDVSE71IeGJ0dEWrOz60It6DU/FOR6DmNKDjQRxtzZut4umTMdm1GvTe5dWHAoFq5ZJgxuCYgUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765429463; c=relaxed/simple;
	bh=cfrfDZE2szvkfuDH7and7mfh4tJoHtHg85C065qtess=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dV2hJUu18k9bsm5l+yrkiJ7OccMUQVN5gmYF3x2vvmkhMok4/rTIiCXV7kTQnvFeYEtuimCGclfPe7yVN1ih5o9X15N99GZo8kl+8uf6VF3DbnNF6COOEMX9EzgaBOXbOgu+a4pos//rOexccuDhaOOML4xRQOeIUQMcptWQkV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD66C227A87; Thu, 11 Dec 2025 06:04:17 +0100 (CET)
Date: Thu, 11 Dec 2025 06:04:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251211050417.GA26597@lst.de>
References: <20251210142305.3660710-1-hch@lst.de> <20251210164859.GB7725@frogsfrogsfrogs> <20251210165438.GA9489@lst.de> <20251210191825.GD7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210191825.GD7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 11:18:25AM -0800, Darrick J. Wong wrote:
> How nasty is it, exactly?  AFAICT,
> 
>  * The zone targetting code (aka the zone we copy into) then has to
>    know to avoid a runt endzone?

Yes.  And I don't really have a good idea how to do that.

>  * Thresholding gets weird because they don't apply right to the runt
>    zone, which means the victim selection is also off.

Yes.

>  * The code that reserves zones for gc or other ENOSPC handling then has
>    to ensure it never picks a runt zone to avoid corner case problems

This is what is needed for 1) above with all the same issues.

> Any other reasons?  Given that zoned is still experimental I think I'm
> ok with adding this restriction, but only after some more thorough
> understanding. :)

Yeah.

> Also does growfs need patching so that it doesn't create a runt zone?

I think we run the buffer verifier there, but a nicer check to abort
early would be helpful.  As would be a test case.


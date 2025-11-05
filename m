Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7A1307490
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762349244; cv=none; b=o865ocqswEe3R+2PlNAWK5YrIDeO6DenOt1oFBw5zSzDPfEyyP4dIqpjJ0efY+TnOeJ0mw+Ky9nk4UEqR4ZIkxHT/YoacP7JACEX0uK9vX34NNcQrqrH4PPy7U3DNzsVonaMc+XYpA5TH7XbGJuXis8DHnvhkBz53PwAKf6gz7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762349244; c=relaxed/simple;
	bh=LqNp45gSQEJRKYjPef7T0UIScRXMFkt0dG3AGqp/e2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h62xsSDeKbcB3NhZOny87Z36JRMV3HVPje7udXhIcqrIEQc1/SDBfyMZbYIpevQfD1YDRi8ARv1YKo/PwsXJGJ+V50ubd57QlC0pS5eZQRBOExrjFhoLHfl1TnOLnCvxwmi30ffV0+k8Mui4YyEmChmtPoh6jBb7RrjUGNyxQEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 512BA227AAA; Wed,  5 Nov 2025 14:27:19 +0100 (CET)
Date: Wed, 5 Nov 2025 14:27:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251105132719.GA20048@lst.de>
References: <20251030144946.1372887-1-hch@lst.de> <20251030144946.1372887-3-hch@lst.de> <20251101000409.GR3356773@frogsfrogsfrogs> <20251103104318.GA9158@lst.de> <20251104233930.GP196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104233930.GP196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 04, 2025 at 03:39:30PM -0800, Darrick J. Wong wrote:
> > The unmount format is smaller than an opheader, so we won't split it
> > because of that, but unless I'm misreading things it could fix a bug
> > where we'd not get a new iclog when needed for it otherwise?
> 
> Yeah, I think that's theoretically possible.  I wonder what that would
> look like to generic/388 though?  I haven't seen any problems with log
> recovery for a while other than the large xattr thing, so maybe it's not
> worth worrying about.

If we don't split a copy we'd need to we'd either overrun the buffer
or something catches it before trying to do that (hopefully).  So I
guess it simply doesn't happen, probably because it is so small that
the accounting slack for the continuation opheaders catches it somehow.


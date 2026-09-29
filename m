Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CDE5012BA
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676882; cv=none; b=O5Bkt1MFZue0s9m5TCS0bHytvOMYiMU7jl9dKoRkjApIXZzLcxc8LNeMbCMSwJAUrkAkoVGzfWLl7+0CMj1VvoO8BKKHs1LQrpFx7KE4Gd39lct927tRBMtuI2Ugpe5XnVQibgDETfYt9IdKL0rOM6zEZlj+Qft6zDWCpd4IETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676882; c=relaxed/simple;
	bh=xw/biIKlzu+KKyyVQ1oMslU3/tjU9PWGLJHvSubYPBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eB8GaDAJ4UBp4zJxJMJ95HiB881zpsDlBW0FDH3IXiAXiaSIG7z5mJcVicSDOiTY3ZzGtTp0NGZOMKOVtJeAdTc84jNShsSju7U1imhGj0OKosCsH4c1ihdnTX+ME2NtyBCseM+P5SsqcDmpnkdwfGFIzrvhbRYYHhYeNHvtRIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwADITYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwADITYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512C21F000FF;
	Tue, 29 Sep 2026 10:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790676863;
	bh=eBB4ngqy9jaisIdqtzAhkbfVVXZB5JSUUXMEtEx5x3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YwADITYw5Tdn9caiv/KKcQUHbZLmAZmxqvTxop8fEkF4zdDez4bbjQjW/fldZSAyr
	 VUWt50FxA47JpXGITXiJ1YQwIhVP7WyWAsaDiEzIAB1k1w24BHzDLaVXmJzllpS8wR
	 WRx0T5hWHulyfZEazJFY08Bdd3s1mAN9DJZNfOWQKGMo3Sl9gdT/H/IFa2UuFGphzq
	 vQF2YSOYaNAsE2Vbs8oORrQFY7SZ6eZJXLD6xQGk6aquwkcQdDrXjOowUObqL8Lk0U
	 7V2gpP+Jg4PBECn5RWj8Yv4wsuXKfQ+TWFd2XDVwGuVNzAkyceCkoGNIjIPxrUAu3+
	 t6KJLjVgePoYw==
Date: Tue, 29 Sep 2026 12:14:19 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/32] man: fix alignment of the rtstart field in
 ioctl_xfs_fsgeometry.2
Message-ID: <aruPOE_gTwMfqe6P@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-2-hch@lst.de>
 <20260924203029.GA2705364@frogsfrogsfrogs>
 <20260926061530.GG20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926061530.GG20636@lst.de>

On 2026-09-26 08:15:30, Christoph Hellwig wrote:
> On Thu, Sep 24, 2026 at 01:30:29PM -0700, Darrick J. Wong wrote:
> > On Thu, Sep 24, 2026 at 12:03:51PM +0200, Christoph Hellwig wrote:
> > > Using tabs for indentation messes up man page rendering, so use spaces
> > > for rtstart to match the other fields.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > This could go into 7.3.
> 
> Andrey, can you pick this up directly, or should I resend it standalone?
> 
> 

I've picked this up, it will be in next for-next

-- 
- Andrey

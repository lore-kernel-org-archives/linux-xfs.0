Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DA81EEA40;
	Tue, 22 Apr 2025 07:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745308797; cv=none; b=Nxm4GE47K3MOC0wwjs9ul0E04qU/l8r8gQt4TczIEEHJKZkt0wVE+bGr2RwMj0A2DdTi7D2/f3CqnUTJTDMrp1X4eDqbnB5y1Oy3UePNLHsMnyn+RJAXOSeX5Aujvvuc98PpiuzF2vUuqTJt/M3n6wYG6k+m4+oTyL7eutycSYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745308797; c=relaxed/simple;
	bh=6uYq948jP0plKCa8h8/BnAACDkw7xAC78wECv68M75g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBYdu8MYxZdo225ItWMJDp3CxbHSmdkwSr/txX4g7Nb+1hzTZe0lPDLKx6KnJlJaKXBimIBg7mp1aB9G0+wMMPmt/K+nijvI7h8AeQ0ZKexjWA05mPyn3r04EJnDfavGNdqknyFktlNbDpr2Ea8In8s9MmuD/3oYUiuH1YVIg/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crcWqiFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crcWqiFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3DFC4AF13;
	Tue, 22 Apr 2025 07:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745308797;
	bh=6uYq948jP0plKCa8h8/BnAACDkw7xAC78wECv68M75g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=crcWqiFNhFriHwgT3q0la5F5SFpEstBIwknznWZ4k7gv1tcdJHo+ffVE22PdWBhku
	 mvHMEEx0qQcar1zYsgJ173fKFjpO1M9TrLUIFsAtDO8+PpRGH3ZGbQFrFKQ5ruQet2
	 Dj+aOrvyQAPp+5F0dWMPSAwyonBRE/tCCUnX17tkmkMWipuTVPbkF5SWIvL5X8Wywt
	 H1vH4KKPJjouSqnnwttTOUtUV3eQUmbxb9U35OEB0g7qckZIsqCougGxrI/AzEmVhD
	 J61qp4Fp0JYSf5qo61NtQM/eDeRqY9MInmKrJvQ7y1Wu0KIrSWd4tVyVrd5ZCmBq9m
	 k2XxvnoUg5OwA==
Date: Tue, 22 Apr 2025 09:59:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: hch <hch@lst.de>
Cc: Guenter Roeck <linux@roeck-us.net>, 
	Hans Holmberg <Hans.Holmberg@wdc.com>, Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <vtbzasrb6cx4ysofaeyjus75ptnqrydm24xw7btzeiokqueey3@qamjjgwyubml>
References: <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
 <20250421083128.GA20490@lst.de>
 <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
 <20250422054851.GA29297@lst.de>
 <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
 <6Vk6jXI2DGWoxaC5fwn8iLCw5Bdelm4TDO1z8FiRamhu_v1yAbbQ-TB6I1p9OQZDcydN5LSY9Kgzb7vhsAaPkg==@protonmail.internalid>
 <20250422060137.GA29668@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422060137.GA29668@lst.de>

On Tue, Apr 22, 2025 at 08:01:37AM +0200, hch wrote:
> On Mon, Apr 21, 2025 at 10:57:31PM -0700, Guenter Roeck wrote:
> >> free should be floored to zero, i.e.
> >>
> >> 	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));
> >>
> >
> > Do you mean max, maybe ?
> 
> Yes, sorry.
> 
> Also if you want the work taken off your hands I can prepare a patch
> as well, I just don't want to do that without approval from the
> original author.

Just noticed it, I shouldn't read emails backwards on time :)
I had the same thoughts as hch though. But giving Guenter's last message...

hch, do you want to write a patch for that or should I?

btw, Guenter, I still plan to work on a generic mult_frac() to properly fix
this. Could you please share a reproducer for your case so I can test it on the
same architectures you're doing so? Hopefully it can be cross compiled?

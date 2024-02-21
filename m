Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D97C33F7;
	Wed, 21 Feb 2024 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535624; cv=none; b=CFYOGL1KcyrE8dpQFcKyLWpp1GRNMSrUJ6DIaN9VxUVjh3/01kmjf5gSaCmrJwsEkAsA2h6K1w0ZDiXYKO9Nf/ncUOR+UuJnN1Ckdf3F4yjZSloBUaOtW4hn3NkkS+yyDKxde6/eYg0dX3PGM4yI8SZWRNBJid1AvSZ0AxilB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535624; c=relaxed/simple;
	bh=SPC7GdXwmp+ng7T99WcMMxyAlOO+M5BdhoieuR7EFgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQW5zd0lvh6ZvJOegG7dwap3OSs8ZojbRu5/Eo77LXYOzSojEptvMoylvaszd24wmQuGkoI9wBG3P+SK1rjm78ScgxGOEVcgiiMPYlPgjYn0AQP9y9itQfmLEsxau2kMjuiyCB70W07Kno24NHtoQ+rGijW/4KlGKlpjJ7s2hTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+l+GiT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+l+GiT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49F0C433F1;
	Wed, 21 Feb 2024 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708535623;
	bh=SPC7GdXwmp+ng7T99WcMMxyAlOO+M5BdhoieuR7EFgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+l+GiT7+Ejq6HYWZ/EAQUkblCthVnNoEfsbNC3doUt0kOMmdqydm2SIINQvCaFTD
	 sqCxduJ831rnB5/sv+QXbaMmBcKqa+TWVE2QqKgQnaTKJWVMzyIZxu/q2rgBtW3JWH
	 RmUPOhu0yBmjHG7ZtcFxu/eQFdwtN6tpntrYmH+UYAlyBC8W9TFK3iWTM5ulIJjP7J
	 SM6spI3+kivNZbLp0xPrGi3/CayJPtC0v8nFBxm0+IJfbjZqrQxNanclsDhBtnS05N
	 rzQRXj4kASY8OWdorIhbr/6O8TyjrBEsOCZY0GQxLbRChOnW2TffVCCUPaaTtoD3P2
	 JVkKAW4dQPtEg==
Date: Wed, 21 Feb 2024 09:13:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/449: don't run with RT devices
Message-ID: <20240221171343.GI6226@frogsfrogsfrogs>
References: <20240221063524.3562890-1-hch@lst.de>
 <20240221155338.GF616564@frogsfrogsfrogs>
 <20240221162515.GA25439@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221162515.GA25439@lst.de>

On Wed, Feb 21, 2024 at 05:25:15PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 21, 2024 at 07:53:38AM -0800, Darrick J. Wong wrote:
> > Odd... this test only takes ~50s on my rt testing rig.
> > 
> > _scratch_mkfs_sized should restrict the size of both the data device and
> > the rt volume to 256M, right?  Looking at tot, it sets "-d size=$fssize"
> > and "-r size=$fssize", so I don't think I understand what's going on
> > here.
> 
> You are right.  I have some local patches that messed things up and
> increased the data device size based on paramters of the RT device
> in _scratch_mkfs_sized.  I've fixed this up now.

Increases the data device size?  Does it do that to sidestep the case
where fstests fails because the rtbitmap needs more space than is
available in the data device? ;)

--D
